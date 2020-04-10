Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F041A435F
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 10:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgDJILS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 04:11:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39854 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725839AbgDJILR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 04:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586506277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cjo0z+erSS8+o55En0JXZs4QhDVZF1UD9ZTunPJ+eug=;
        b=UqupLBNk5STOSJxtSP4BV/xsIXey2ZOoGHdaZAoofdzq1O8wxRQkYZv0+NI7urMb0hGqlW
        HID56g9ncBl/LX975Rx3p+poo4zxLTLU0jNQ6++SxMlwFV8kXzdbLSOpVvb2lsQHvTtCIS
        QcWgAyMP5r5cmhTt56cOBdrVMPrxhEU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-YJH0Vf3SMO2F0gRP4tU8Dg-1; Fri, 10 Apr 2020 04:11:13 -0400
X-MC-Unique: YJH0Vf3SMO2F0gRP4tU8Dg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E95BF149C2;
        Fri, 10 Apr 2020 08:11:11 +0000 (UTC)
Received: from ovpn-112-47.ams2.redhat.com (ovpn-112-47.ams2.redhat.com [10.36.112.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 571715C1BB;
        Fri, 10 Apr 2020 08:11:10 +0000 (UTC)
Message-ID: <f216cb8ed643979e9e71da0f0af361340fd444fd.camel@redhat.com>
Subject: Re: [PATCH net] net/ipv6: allow token to be set when accept_ra
 disabled
From:   Thomas Haller <thaller@redhat.com>
To:     David Miller <davem@davemloft.net>, liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net,
        yoshfuji@linux-ipv6.org
Date:   Fri, 10 Apr 2020 10:11:04 +0200
In-Reply-To: <20200409.101355.534685961785562180.davem@davemloft.net>
References: <20200409065604.817-1-liuhangbin@gmail.com>
         <20200409.101355.534685961785562180.davem@davemloft.net>
Organization: Red Hat
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-OPLRBcons0Qpxmm3R96Z"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-OPLRBcons0Qpxmm3R96Z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-04-09 at 10:13 -0700, David Miller wrote:
> From: Hangbin Liu <liuhangbin@gmail.com>
> Date: Thu,  9 Apr 2020 14:56:04 +0800
>=20
> > The token setting should not depend on whether accept_ra is enabled
> or
> > disabled. The user could set the token at any time. Enable or
> disable
> > accept_ra only affects when the token address take effective.
> >=20
> > On the other hand, we didn't remove the token setting when disable
> > accept_ra. So let's just remove the accept_ra checking when user
> want
> > to set token address.
> >=20
> > Fixes: f53adae4eae5 ("net: ipv6: add tokenized interface identifier
> support")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>=20

Hi,

I don't agree.


> It is dangerous to change this, because now people can write bootup
> and configuration scripts that will work with newer kernels yet fail
> unexpectedly in older kernels.

This concern is a very strict interpretation of "forward
compatibility".

The patch relaxes a check. Every change that enables something that
wasn't possible before has this danger. It seems acceptable that people
cannot use newer kernel features on kernel that don't support it.=20


> I think requiring that RA be enabled in order to set the token is
> an absolutely reasonable requirement.


That seems to be the real problem: "Why would you posibly want to do
this?"

1)

NetworkManager sets accept_ra=3D0, because it does autoconf in user
space. It supports tokens, which are entirely handled in user space.

However, when using tokens, NetworkManager likes to configure the token
also in kernel. Yes, it's not overly useful, but it's pretty nice that
you see the token in `ip token` too.

This wasn't an issue until recently, because NetworkManager didn't
actually set accept_ra=3D0.


2)

If you want to set

  a) token ::1 dev eth0
  b) echo 1 >  /proc/sys/net/ipv6/conf/eth0/accept_ra
  c) ip link set
eth0 up

then you can do the 3 steps in several different orders, but not in the
most(?) sensible one: a,b,c).

Yes, this makes the earlier concern about the danger of people doing
the sensible thing on newer kernels bigger.



3)

There is the oddity that
=20
  # echo 1 >  /proc/sys/net/ipv6/conf/w/accept_ra
  # ip token set ::123 dev w
  # ip token

shows the token. Then,=20

  # echo 0 >  /proc/sys/net/ipv6/conf/w/accept_ra
  # ip token

still shows the token. The EINVAL indicates you that having a token
with accept_ra=3D0 is wrong. But still, it shows a token set, and you
have no way of clearing it (except toggling accept_ra).



I don't care so much about 1) either. If this is really how kernel
wants to do it, fine. NetworkManager won't set the token. It just
doesn't seem sensible to me.



best,
Thomas

--=-OPLRBcons0Qpxmm3R96Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEESep8Zw4IUOdBlRT2KcI2bk38VygFAl6QKhgACgkQKcI2bk38
Vyi6yw/9EaYwgT98+8xKIS0zzsfdbdoow+psO3zN6EuzoJIzjvmmI/k8iFxCqVHZ
1OWOadzsdF/iXByPMnP1Ap4C8/2MuNoj1l8lxaAU48ZDb6XEE0CMgFy5TV/PJ1mr
LkxHwGhhA4lfwD1I77GxUMeN3mz/T/n4a0m2IHKGZY8DkJsXmB9/vTFANjcXk5dR
aW1o02uYQz/cC4hX37m7o2ISQxdg+J7xpIYN2Kz/IbyNk7vgNdNxmCh7nW3/oOMe
ZMRBEnCFr0aM1+DfOfZB1QEwCJj+N9zCasn4jQoJy/yCNG5TOfStWbpWGH1+2i2b
h+qzsGkKyOeH/D4szZYiIImhDKIm6M9togBS73B0dzIcauupydI2VVXrxvB+PkUo
Lk7wd6aPInrWZei0oAmN1GVoZEtV14nt1HGWaZRiD7ZNlolQop6Yo7yak1Qdcb+L
qBfEbq8CXmKZW+5NTyE3Kaf03xD8WsB4V6imkxJ9kNhyEMinlV6Eh6V0vfEPhHv5
QxK5DuWqyTgJX/jnd70vHSo3aiPxz4nCE9FaWVJf09liJ8AWyscQQTwjTnOgYxuG
3m2v06XsRCXyqbhXV6xaopSOJ3zlTgixo7B9uKc/6I+k0A+rYhcwl6Hnsv++HosT
8rPrpsyojLTDk8M0CnLfvjncYVEXQMg58XJMpHjINReOQy0H3JU=
=J5RA
-----END PGP SIGNATURE-----

--=-OPLRBcons0Qpxmm3R96Z--

