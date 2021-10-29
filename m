Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA8443FC79
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbhJ2Mqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbhJ2Mqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 08:46:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F78C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 05:44:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mgREy-0004fB-Qp; Fri, 29 Oct 2021 14:44:12 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-e533-710f-3fbf-10c2.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:e533:710f:3fbf:10c2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 0D5016A0A0E;
        Fri, 29 Oct 2021 12:44:11 +0000 (UTC)
Date:   Fri, 29 Oct 2021 14:44:11 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] can: netlink: report the CAN controller mode
 supported flags
Message-ID: <20211029124411.lkmngckiiwotste7@pengutronix.de>
References: <20211026121651.1814251-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eyd3iugdqq4tttdt"
Content-Disposition: inline
In-Reply-To: <20211026121651.1814251-1-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--eyd3iugdqq4tttdt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On 26.10.2021 21:16:51, Vincent Mailhol wrote:
> This patch introduces a method for the user to check both the
> supported and the static capabilities. The proposed method reuses the
> existing struct can_ctrlmode and thus do not need a new IFLA_CAN_*
> entry.
>
> Currently, the CAN netlink interface provides no easy ways to check
> the capabilities of a given controller. The only method from the
> command line is to try each CAN_CTRLMODE_* individually to check
> whether the netlink interface returns an -EOPNOTSUPP error or not
> (alternatively, one may find it easier to directly check the source
> code of the driver instead...)
>
> It appears that can_ctrlmode::mask is only used in one direction: from
> the userland to the kernel. So we can just reuse this field in the
> other direction (from the kernel to userland). But, because the
> semantic is different, we use a union to give this field a proper
> name: "supported".
>
> The union is tagged as packed to prevent any ABI from adding
> padding. In fact, any padding added after the union would change the
> offset of can_ctrlmode::flags within the structure and thus break the
> UAPI backward compatibility. References:
>
>   - ISO/IEC 9899-1999, section 6.7.2.1 "Structure and union
>     specifiers", clause 15: "There may be unnamed padding at the end
>     of a structure or union."
>
>   - The -mstructure-size-boundary=64 ARM option in GCC:
>     https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html
>
>   - A similar issue which occurred on struct can_frame:
>     https://lore.kernel.org/linux-can/212c8bc3-89f9-9c33-ed1b-b50ac04e7532@hartkopp.net
>
> Below table explains how the two fields can_ctrlmode::supported and
> can_ctrlmode::flags, when masked with any of the CAN_CTRLMODE_* bit
> flags, allow us to identify both the supported and the static
> capabilities:
>
>  supported &	flags &		Controller capabilities
>  CAN_CTRLMODE_*	CAN_CTRLMODE_*
>  -----------------------------------------------------------------------
>  false		false		Feature not supported (always disabled)
>  false		true		Static feature (always enabled)
>  true		false		Feature supported but disabled
>  true		true		Feature supported and enabled

What about forwards and backwards compatibility?

Using the new ip (or any other user space app) on an old kernel, it
looks like enabled features are static features. For example the ip
output on a mcp251xfd with enabled CAN-FD, which is _not_ static.

|         "linkinfo": {
|             "info_kind": "can",
|             "info_data": {
|                 "ctrlmode": [ "FD" ],
|                 "ctrlmode_static": [ "FD" ],
|                 "state": "ERROR-ACTIVE",
|                 "berr_counter": {
|                     "tx": 0,
|                     "rx": 0
|                 },

Is it worth and add a new IFLA_CAN_CTRLMODE_EXT that doesn't pass a
struct, but is a NLA_NESTED type?

Marc

--
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--eyd3iugdqq4tttdt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmF77JgACgkQqclaivrt
76luHgf/SLb+/I09MNvU0um+puegckHKw9U+uOUHe2Tx+m2KCXD56Bya1sKOlnrm
P7jOp2pdhbHr99n1wVeAeV9u9OGJC5sc+HxQrjIr0C1Rgufvft5ML1DhSWyhxAZ5
w6m4jEG/U/MdRqlhSR/4MYGwWNKhLtwNxQ+e99W2n9V35jPcDV4TNfVNFbCLFr4t
YrRP3DKhyxEejk8dX7Db4jW3AJBaYXtKCAqEOCgLmjr8JZ3HIgpS8rQtSVQ3uPq6
fOAbB0PABWSnQJBwGAPhr12fheli1lFE9yIbyt6n+hpUUYNPJUK1bJwrxNQB3fPY
QSdVGfa30LGZzKFnXvWUFs0D7oxmYw==
=VoXU
-----END PGP SIGNATURE-----

--eyd3iugdqq4tttdt--
