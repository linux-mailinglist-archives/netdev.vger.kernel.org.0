Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3538416A16
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 04:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243934AbhIXClZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 22:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbhIXClY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 22:41:24 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71822C061574;
        Thu, 23 Sep 2021 19:39:52 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1632451190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1pf6JHCeBw9ltmD5jCIx3FWgGbPQ5ydU17gpry5ETxc=;
        b=tSHN14QdKppcl+snRQHoEd2N9gyTGDx9aZ8fS3PZ5wN+o2xSmJzLJe2zi2a5c3NrUbxDf3
        oqjaEl37J7Xdk0kLpJfkwSZhpk5gbpcG6b5NtlGWjUVXTDIPo7VpDtiBIjAC+/TFMkb+2Y
        r/oTlWjkL9xsrfXBsZVNXXLq7RT+lT0=
Date:   Fri, 24 Sep 2021 02:39:49 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <d03a2c604913430c8f83c84f02868e6d@linux.dev>
Subject: Re: [PATCH net-next] net: socket: integrate sockfd_lookup() and
 sockfd_lookup_light()
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210923082453.42096cc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210923082453.42096cc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210922063106.4272-1-yajun.deng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

September 23, 2021 11:24 PM, "Jakub Kicinski" <kuba@kernel.org> wrote:=0A=
=0A> On Wed, 22 Sep 2021 14:31:06 +0800 Yajun Deng wrote:=0A> =0A>> As co=
mmit 6cb153cab92a("[NET]: use fget_light() in net/socket.c") said,=0A>> s=
ockfd_lookup_light() is lower load than sockfd_lookup(). So we can=0A>> r=
emove sockfd_lookup() but keep the name. As the same time, move flags=0A>=
> to sockfd_put().=0A> =0A> You just assume that each caller of sockfd_lo=
okup() already meets the=0A> criteria under which sockfd_lookup_light() c=
an be used? Am I reading=0A> this right?=0A> =0AYes, this patch means eac=
h caller of sockfd_lookup() can used sockfd_lookup_light() instead.=0A> P=
lease extend the commit message clearly walking us thru why this is=0A> s=
afe now (and perhaps why it wasn't in the past).=0A>=0AThe sockfd_lookup(=
) and  sockfd_lookup_light() are both safe. The fact that they have been =
around for so long is the best proof. sockfd_lookup_light() is just lower=
 load than sockfd_lookup(). so we can used the lower load helper function=
.=0A=0A>> static ssize_t sockfs_listxattr(struct dentry *dentry, char *bu=
ffer,=0A>> size_t size)=0A>> @@ -1680,9 +1659,9 @@ int __sys_bind(int fd,=
 struct sockaddr __user *umyaddr, int addrlen)=0A>> {=0A>> struct socket =
*sock;=0A>> struct sockaddr_storage address;=0A>> - int err, fput_needed;=
=0A>> + int err;=0A>> =0A>> - sock =3D sockfd_lookup_light(fd, &err, &fpu=
t_needed);=0A>> + sock =3D sockfd_lookup(fd, &err);=0A>> if (sock) {=0A>>=
 err =3D move_addr_to_kernel(umyaddr, addrlen, &address);=0A>> if (!err) =
{=0A>> @@ -1694,7 +1673,7 @@ int __sys_bind(int fd, struct sockaddr __use=
r *umyaddr, int addrlen)=0A>> (struct sockaddr *)=0A>> &address, addrlen)=
;=0A>> }=0A>> - fput_light(sock->file, fput_needed);=0A>> + sockfd_put(so=
ck);=0A> =0A> And we just replace fput_light() with fput() even tho the r=
eference was=0A> taken with fdget()? fdget() =3D=3D __fget_light().=0A> =
=0A> Maybe you missed fget() vs fdget()?=0A=0AIn fact, the sockfd_put() a=
lready changed in this patch. Here is the modified:=0A#define            =
         sockfd_put(sock)             \=0Ado {                           =
                   \=0A       struct fd *fd =3D (struct fd *)&sock->file;=
 \=0A                                                 \=0A       if (fd->=
flags & FDPUT_FPUT)               \=0A               fput(sock->file);   =
              \=0A}=0A=0A> =0A> All these changes do not immediately stri=
ke me as correct.=0A> =0AThis is the information of this patch:=0A includ=
e/linux/net.h |   8 +++-=0A net/socket.c        | 101 +++++++++++++++++--=
-------------------------=0A 2 files changed, 46 insertions(+), 63 deleti=
ons(-)=0A=0A>> }=0A>> return err;=0A>>=20}
