Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09934416A7C
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 05:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244034AbhIXDlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 23:41:07 -0400
Received: from out2.migadu.com ([188.165.223.204]:26124 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243927AbhIXDlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 23:41:04 -0400
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1632454770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H32Do5KLQwbmwW23dyqRQ7oezzkGBTzKs2qPrn/A6BI=;
        b=LtEYvTtQlvSOuPSX7f6ybpGHMdmXvp8e+kJzd3iEb8ylyL26BUgU69p/LMpBkoc2Fax9iU
        1Os8oSJ6Z45RkgnRbtQ+wYxQ3AiX16h5W3rncrAF6m8e9MpopTLN5y0/yG9QiTDXk9ou5N
        hWHpFpNGLlo+Xw+4EgIW8GYkSJPFUG4=
Date:   Fri, 24 Sep 2021 03:39:30 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <016b34c6de78009c8617c521e8d1ee0d@linux.dev>
Subject: Re: [PATCH net-next] net: socket: integrate sockfd_lookup() and
 sockfd_lookup_light()
To:     "Al Viro" <viro@zeniv.linux.org.uk>, kuba@kernel.org,
        "Eric Dumazet" <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <YU0+QDerqF5+pPB7@zeniv-ca.linux.org.uk>
References: <YU0+QDerqF5+pPB7@zeniv-ca.linux.org.uk>
 <20210922063106.4272-1-yajun.deng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

September 24, 2021 10:56 AM, "Al Viro" <viro@zeniv.linux.org.uk> wrote:=
=0A=0A> On Wed, Sep 22, 2021 at 02:31:06PM +0800, Yajun Deng wrote:=0A> =
=0A>> -#define sockfd_put(sock) fput(sock->file)=0A>> int net_ratelimit(v=
oid);=0A>> +#define sockfd_put(sock) \=0A>> +do { \=0A>> + struct fd *fd =
=3D (struct fd *)&sock->file; \=0A> =0A> Have you even bothered to take a=
 look at struct fd declaration?=0A> Or struct socket one, for that matter=
... What we have there is=0A> ...=0A> struct file *file;=0A> struct sock =
*sk;=0A> ...=0A> =0A> You are taking the address of 'file' field. And tre=
at it as=0A> a pointer to a structure consisting of struct file * and=0A>=
 unsigned int.=0A> =0A>> + \=0A>> + if (fd->flags & FDPUT_FPUT) \=0A> =0A=
> ... so that would take first 4 bytes in the memory occupied=0A> by 'sk'=
 field of struct socket and check if bit 0 is set.=0A> =0A> And what sign=
ificance would that bit have, pray tell? On=0A> little-endian architectur=
es it's going to be the least=0A> significant bit in the first byte in 's=
k' field. I.e.=0A> there you are testing if the contents of 'sk' (a point=
er=0A> to struct sock) happens to be odd. It won't be. The=0A> same goes =
for 32bit big-endian - there you will be checking=0A> the least significa=
nt bit of the 4th byte of 'sk', which=0A> again is asking 'is the pointer=
 stored there odd for some=0A> reason?'=0A> =0A> On 64bit big-endian you =
are checking if the bit 32 of=0A> the address of object sock->sk points t=
o is set. And the=0A> answer to that is "hell knows and how could that po=
ssibly=0A> be relevant to anything?"=0A=0AWell, the forced conversion is =
wrong. sorry for that.
