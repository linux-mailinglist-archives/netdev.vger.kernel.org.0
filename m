Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 029E413DA30
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 13:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgAPMlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 07:41:44 -0500
Received: from mail.katalix.com ([3.9.82.81]:52114 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbgAPMlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 07:41:44 -0500
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jan 2020 07:41:43 EST
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 463A87D3A7;
        Thu, 16 Jan 2020 12:31:43 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1579177903; bh=wUZDD53D/PnlWBV28+Y7BOxbPHN9i3qCs1ckSitszn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pVeoxwhxx3qsrpBLsAaLdzFnDrXv1JnHkwSaQa2z+POkP2sGIk1RlG3Qp1AU+U61K
         fcV8jmkaD4FcsfyqRo9rkaH/MHDeEmiCTSxcQijis2aDikQTB7Ol1r07C9UBZakOki
         oI/DA4xI5qlSkf8EeD9VktmzcHT4JXqpYt7owlLCRsOuP9INtcEyf2c/AVPkM4TcUZ
         eOmE7rtZJy307QtwF6bNyWoJyQAvXLFin7IocBTRqmiR4cM1rlT9yzSNEC92u+AiaP
         M4rc2N5JoSVzom8CHGC1PcD9aQV+TSW32uOt1tw0Ka79ysTL4ndv+HLZl+SNZGVpkk
         LY4s2cUa8kxLQ==
Date:   Thu, 16 Jan 2020 12:31:43 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200116123143.GA4028@jackdaw>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Thu, Jan 16, 2020 at 11:34:47 +1300, Ridge Kennedy wrote:
> In the past it was possible to create multiple L2TPv3 sessions with the
> same session id as long as the sessions belonged to different tunnels.
> The resulting sessions had issues when used with IP encapsulated tunnels,
> but worked fine with UDP encapsulated ones. Some applications began to
> rely on this behaviour to avoid having to negotiate unique session ids.
>=20
> Some time ago a change was made to require session ids to be unique across
> all tunnels, breaking the applications making use of this "feature".
>=20
> This change relaxes the duplicate session id check to allow duplicates
> if both of the colliding sessions belong to UDP encapsulated tunnels.

I appreciate what you're saying with respect to buggy applications,
however I think the existing kernel code is consistent with RFC 3931,
which makes session IDs unique for a given LCCE.

Given how the L2TP data packet headers work for L2TPv3, I'm assuming
that sessions in UDP-encapsulated tunnels work even if their session
IDs clash because the tunnel sockets are using distinct UDP ports
which will effectively separate the data traffic into the "correct"
tunnel.  Obviously the same thing doesn't apply for IP-encap.

However, there's nothing to prevent user space from using the same UDP
port for multiple tunnels, at which point this relaxation of the RFC
rules would break down again.

Since UDP-encap can also be broken in the face of duplicated L2TPv3
session IDs, I think its better that the kernel continue to enforce
the RFC.

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl4gV64ACgkQlIwGZQq6
i9D3jQf+OTNq+2eVvfzzIY4bh6ZeT4qMG8Z1QTiniRerwcvtrhhEzDtQ82zTNb0O
AaxzG071orNYbVIkYmkNbXNjHSlAKIM/ckwYJvCmVuL15tMdDVniF696K5tOsasc
pdQkEESpZ1V2TyOopv7kXMKFlSFUWaQrKWorOCMZN531qpZADBz7UubXEk8Q0BcL
4BvPsakxzUw8PXkApZa9262fj0O/leUVHXIn8cHqwc/5hmcarfstz9NXJutpg2wx
vl5mpNojYKhoBLXso4Z197UZ4bSohltWhR8uEv2eoDp31sqkHviBo+GFMnzBZnv5
SWRFw2jMW+S9NdeFImzUnMAwM+iIGA==
=QjAQ
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
