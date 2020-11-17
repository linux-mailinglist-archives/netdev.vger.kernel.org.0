Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84A62B7121
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 22:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgKQVxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 16:53:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbgKQVxB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 16:53:01 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 864D8221FC;
        Tue, 17 Nov 2020 21:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605649980;
        bh=lMWkBtbmoedGzqfgkKGICNn1Q70aD5ADoQYGNsf/4to=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ePwCsSdsiOqpuwE34w196SsPULwXn1jEo9kHu3WjN/76i5/c+BmM7ARkK7ZR7BTAi
         9/hO/eD4K8p6pHihRf4295zuLTHEwGtNBrIL+ta/u00xBxqgTbs6ugoQEclp6q5awI
         aUcDu4PbCAg7gzvNdSvOka9OBHAf+X1ANnzjKKY4=
Date:   Tue, 17 Nov 2020 13:52:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 1/3] net: add support for sending RFC8335
 PROBE
Message-ID: <20201117135259.142aad6c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <d038c95149a0497e4fda40f856e1a1179065da9b.1605386600.git.andreas.a.roeseler@gmail.com>
References: <cover.1605386600.git.andreas.a.roeseler@gmail.com>
        <d038c95149a0497e4fda40f856e1a1179065da9b.1605386600.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 12:56:11 -0800 Andreas Roeseler wrote:
> Modifying the ping_supported function to support probe message types
> allows the user to send probe requests through the existing framework
> for sending ping requests.
>=20
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>

You need to reorder the patches so that defines are added first.

Otherwise if someone lands on this patch during bisection the kernel
will not build:

../net/ipv4/ping.c: In function =E2=80=98ping_supported=E2=80=99:
../net/ipv4/ping.c:456:39: error: =E2=80=98ICMP_EXT_ECHO=E2=80=99 undeclare=
d (first use in this function); did you mean =E2=80=98ICMP_ECHO=E2=80=99?
  456 |         (family =3D=3D AF_INET && type =3D=3D ICMP_EXT_ECHO && code=
 =3D=3D 0) ||
      |                                       ^~~~~~~~~~~~~
      |                                       ICMP_ECHO
../net/ipv4/ping.c:456:39: note: each undeclared identifier is reported onl=
y once for each function it appears in
../net/ipv4/ping.c:458:40: error: =E2=80=98ICMPV6_EXT_ECHO_REQUEST=E2=80=99=
 undeclared (first use in this function); did you mean =E2=80=98ICMPV6_ECHO=
_REQUEST=E2=80=99?
  458 |         (family =3D=3D AF_INET6 && type =3D=3D ICMPV6_EXT_ECHO_REQU=
EST && code =3D=3D 0);
      |                                        ^~~~~~~~~~~~~~~~~~~~~~~
      |                                        ICMPV6_ECHO_REQUEST
../net/ipv4/ping.c:459:1: error: control reaches end of non-void function [=
-Werror=3Dreturn-type]
  459 | }
      | ^
cc1: some warnings being treated as errors
make[3]: *** [net/ipv4/ping.o] Error 1
make[2]: *** [net/ipv4] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [net] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [__sub-make] Error 2
