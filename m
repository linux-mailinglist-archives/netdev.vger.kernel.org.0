Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072CA416A28
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 04:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243969AbhIXCv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 22:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbhIXCv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 22:51:26 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9D0C061574;
        Thu, 23 Sep 2021 19:49:54 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1632451792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pPZqGRw1WwCLIpDnX3mQU1v67yD75RIgM3v4q/TSB/Q=;
        b=j9qTNzSjHAn1oA/KTXxgG36McukCNyD9HCcYZg/6jPnQsLDnldIpH8mQpNWIuv+2vBbpV9
        2XrmBkEdTH0qMhUB4QqMIKHoZO8Xfk/VnePWOXMZDuBKioByrteKiZrumeRHUL7a7sO5yZ
        X68+P9Lkyg9k1ZwaPYdwwDNDAOcaD1Q=
Date:   Fri, 24 Sep 2021 02:49:51 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <836595da2ba742cb790b8dd2a3c14ae4@linux.dev>
Subject: Re: [PATCH net-next] net: socket: integrate sockfd_lookup() and
 sockfd_lookup_light()
To:     "Eric Dumazet" <eric.dumazet@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <b6263d35-0d31-e4a8-a955-494ce2b36ad6@gmail.com>
References: <b6263d35-0d31-e4a8-a955-494ce2b36ad6@gmail.com>
 <20210922063106.4272-1-yajun.deng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

September 24, 2021 12:49 AM, "Eric Dumazet" <eric.dumazet@gmail.com> wrot=
e:=0A=0A> On 9/21/21 11:31 PM, Yajun Deng wrote:=0A> =0A>> As commit 6cb1=
53cab92a("[NET]: use fget_light() in net/socket.c") said,=0A>> sockfd_loo=
kup_light() is lower load than sockfd_lookup(). So we can=0A>> remove soc=
kfd_lookup() but keep the name. As the same time, move flags=0A>> to sock=
fd_put().=0A> =0A> ???=0A> =0A>> Signed-off-by: Yajun Deng <yajun.deng@li=
nux.dev>=0A>> ---=0A>> include/linux/net.h | 8 +++-=0A>> net/socket.c | 1=
01 +++++++++++++++++---------------------------=0A>> 2 files changed, 46 =
insertions(+), 63 deletions(-)=0A>> =0A>> diff --git a/include/linux/net.=
h b/include/linux/net.h=0A>> index ba736b457a06..63a179d4f760 100644=0A>>=
 --- a/include/linux/net.h=0A>> +++ b/include/linux/net.h=0A>> @@ -238,8 =
+238,14 @@ int sock_recvmsg(struct socket *sock, struct msghdr *msg, int =
flags);=0A>> struct file *sock_alloc_file(struct socket *sock, int flags,=
 const char *dname);=0A>> struct socket *sockfd_lookup(int fd, int *err);=
=0A>> struct socket *sock_from_file(struct file *file);=0A>> -#define soc=
kfd_put(sock) fput(sock->file)=0A>> int net_ratelimit(void);=0A>> +#defin=
e sockfd_put(sock) \=0A>> +do { \=0A>> + struct fd *fd =3D (struct fd *)&=
sock->file; \=0A>> + \=0A>> + if (fd->flags & FDPUT_FPUT) \=0A>> + fput(s=
ock->file); \=0A>> +} while (0)=0A> =0A> Really ?=0A> =0A> I wonder how w=
as this tested ?=0A> =0A> We can not store FDPUT_FPUT in the sock itself,=
 for obvious reasons.=0A> Each thread needs to keep this information priv=
ate.=0A=0AThe sockfd_lookup() already changed in this patch. FDPUT_FPUT s=
tored in fdget(), precisely in __fget_light().
