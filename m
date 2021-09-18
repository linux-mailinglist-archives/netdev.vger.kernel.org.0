Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F9C410316
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 04:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238076AbhIRCzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 22:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235408AbhIRCz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 22:55:26 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C995FC061574;
        Fri, 17 Sep 2021 19:54:03 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1631933639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=REJkfdtNTNFprE/RSlp+W3E2WPPvcBEYXXyYwEJ7yj4=;
        b=FgZ2e6HJujMUnFJBsF321eCYfRjYz0qHKMG9WQQoXqCyI7c1GWzkB5jATRRWvu2g0GMemo
        UkP8dTdQjJ0rmhaAkGzLgNgoVDX69YI3CjgTvtEX/0q0shTi9TjbLS86o1YNxknOtwytTa
        O2xdFEpr/+mR+lhgbhnvWfHjipNllMA=
Date:   Sat, 18 Sep 2021 02:53:59 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <87275ec67ed69d077e0265bc01acd8a2@linux.dev>
Subject: Re: [PATCH net-next] net: socket: add the case sock_no_xxx
 support
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210917183311.2db5f332@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210917183311.2db5f332@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210916122943.19849-1-yajun.deng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

September 18, 2021 9:33 AM, "Jakub Kicinski" <kuba@kernel.org> wrote:=0A=
=0A> On Thu, 16 Sep 2021 20:29:43 +0800 Yajun Deng wrote:=0A> =0A>> Those=
 sock_no_{mmap, socketpair, listen, accept, connect, shutdown,=0A>> sendp=
age} functions are used many times in struct proto_ops, but they are=0A>>=
 meaningless. So we can add them support in socket and delete them in str=
uct=0A>> proto_ops.=0A> =0A> So the reason to do this is.. what exactly?=
=0A> =0A> Removing a couple empty helpers (which is not even part of this=
 patch)?=0A> =0A> I'm not sold, sorry.=0A=0AWhen we define a struct proto=
_ops xxx, we only need to assign meaningful member variables that we need=
.=0AThose {mmap, socketpair, listen, accept, connect, shutdown, sendpage}=
 members we don't need assign=0Ait if we don't need. We just need do once=
 in socket, not in every struct proto_ops.=0A=0AThese members are assigne=
d meaningless values far more often than meaningful ones, so this patch I=
 used likely(!!sock->ops->xxx) for this case. This is the reason why I se=
nd this patch.=0A=0AI would send a set of patchs remove most of the meani=
ngless members assigned rather than remove sock_no_{mmap, socketpair, lis=
ten, accept, connect, shutdown, sendpage} functions if this patch was acc=
epted. =0Ae.g.  =0A=0Adiff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.=
c=0Aindex 1d816a5fd3eb..86422eb440cb 100644=0A--- a/net/ipv4/af_inet.c=0A=
+++ b/net/ipv4/af_inet.c=0A@@ -1059,20 +1059,16 @@ const struct proto_ops=
 inet_dgram_ops =3D {=0A        .release           =3D inet_release,=0A  =
      .bind              =3D inet_bind,=0A        .connect           =3D =
inet_dgram_connect,=0A-       .socketpair        =3D sock_no_socketpair,=
=0A-       .accept            =3D sock_no_accept,=0A=0A--- a/net/ipv4/af_=
inet.c=0A+++ b/net/ipv4/af_inet.c=0A@@ -1059,20 +1059,16 @@ const struct =
proto_ops inet_dgram_ops =3D {=0A        .release           =3D inet_rele=
ase,=0A        .bind              =3D inet_bind,=0A        .connect      =
     =3D inet_dgram_connect,=0A-       .socketpair        =3D sock_no_soc=
ketpair,=0A-       .accept            =3D sock_no_accept,=0A        .getn=
ame           =3D inet_getname,=0A=0A=0A        .gettstamp         =3D so=
ck_gettstamp,=0A-       .listen            =3D sock_no_listen,=0A        =
.shutdown          =3D inet_shutdown,=0A        .setsockopt        =3D so=
ck_common_setsockopt,=0A        .getsockopt        =3D sock_common_getsoc=
kopt,=0A        .sendmsg           =3D inet_sendmsg,=0A        .read_sock=
         =3D udp_read_sock,=0A        .recvmsg           =3D inet_recvmsg=
,=0A-       .mmap              =3D sock_no_mmap,=0A        .sendpage     =
     =3D inet_sendpage,=0A        .set_peek_off      =3D sk_set_peek_off,=
=0A #ifdef CONFIG_COMPAT=0A@@ -1091,19 +1087,15 @@ static const struct pr=
oto_ops inet_sockraw_ops =3D {=0A        .release           =3D inet_rele=
ase,=0A        .bind              =3D inet_bind,=0A        .connect      =
     =3D inet_dgram_connect,=0A-       .socketpair        =3D sock_no_soc=
ketpair,=0A-       .accept            =3D sock_no_accept,=0A        .getn=
ame           =3D inet_getname,=0A        .poll              =3D datagram=
_poll,=0A        .ioctl             =3D inet_ioctl,=0A        .gettstamp =
        =3D sock_gettstamp,=0A-       .listen            =3D sock_no_list=
en,=0A        .shutdown          =3D inet_shutdown,=0A        .setsockopt=
        =3D sock_common_setsockopt,=0A        .getsockopt        =3D sock=
_common_getsockopt,=0A        .sendmsg           =3D inet_sendmsg,=0A    =
    .recvmsg           =3D inet_recvmsg,=0A-       .mmap              =3D=
 sock_no_mmap,=0A        .sendpage          =3D inet_sendpage,=0A #ifdef =
CONFIG_COMPAT=0A        .compat_ioctl      =3D inet_compat_ioctl,
