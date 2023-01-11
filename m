Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8E2665DA0
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 15:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjAKOVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 09:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239150AbjAKOVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 09:21:02 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DE9399
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 06:21:00 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1673446858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rneorGZgzHYBZ6P8/homwx26gInWYL0O5oRY9/IR3hw=;
        b=xR1rYjrAAs1jtAkcBqakb7uJtHVy5pGbRmx7OBCcymUhXEFtCbCalkSgZuzFPqRtGhmKRN
        gGsTx/5d+hPR+0lSd6fDqHYkpIiUCNPljXavaKFAGGlSXEIiedRTz9GNGk2PykyysEnySC
        qU2vFrpmRt/0RPctVrX3Jo/exKvRBuFvudb4U9ldjrzq+LOWPp01nUpjrBC7G+mycCOBiR
        lRaEtXg4FiPpy13k/2pxMt6iL/TkCkApkEUvYDhh2K+LalCV03F5oIHNgiKojPyABnkCLy
        EAz4JC8VaqYH+DV8Tosjq84c3j4LLJcuLGsMExC+uUCp5o+tixYUMI3pU7BTow==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1673446858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rneorGZgzHYBZ6P8/homwx26gInWYL0O5oRY9/IR3hw=;
        b=3jXnxOmDBseopur/M46ATzbQpn/izq/TQbNdxFr+a+3U3uplRbYac+Fw5ZlIdoRwISa1+R
        wDuhaS+TZSdBXuCw==
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Enable PTP receive for
 mv88e6390
In-Reply-To: <Y7678lFYTzDFc27j@lunn.ch>
References: <20230111080417.147231-1-kurt@linutronix.de>
 <Y7678lFYTzDFc27j@lunn.ch>
Date:   Wed, 11 Jan 2023 15:20:56 +0100
Message-ID: <87zgapkv93.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed Jan 11 2023, Andrew Lunn wrote:
> On Wed, Jan 11, 2023 at 09:04:17AM +0100, Kurt Kanzenbach wrote:
>> The switch receives management traffic such as STP and LLDP. However, PTP
>> messages are not received, only transmitted.
>>=20
>> Ideally, the switch would trap all PTP messages to the management CPU. T=
his
>> particular switch has a PTP block which identifies PTP messages and trap=
s them
>> to a dedicated port. There is a register to program this destination. Th=
is is
>> not used at the moment.
>>=20
>> Therefore, program it to the same port as the MGMT traffic is trapped to=
. This
>> allows to receive PTP messages as soon as timestamping is enabled.
>>=20
>> In addition, the datasheet mentions that this register is not valid e.g.=
 for
>> 6190 variants. So, add a new cpu port method for 6390 which programs the=
 MGTM
>> and PTP destination.
>
> The mv88e6190x_ops and ops mv88e6190_ops structure does not have a
> ptp_ops member. So these two devices do not support PTP.
>
> I think it would be cleaner to implement setting the PTP MGMT port as
> part of the ptp_ops. Maybe add a new op, which is called from
> mv88e6xxx_ptp_setup() if set?

OK, can do. The 6390 currently uses mv88e6352_ptp_ops. This one is used
by a lot of other devices, too. For instance, the 6341 doesn't have this
PTP MGMT port, but uses the same ops structure. Thus, I'd have to
introduce a new ptp ops structure for both 6390 devices.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmO+xcgTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgsIRD/96mL+2eGa9vl6cd2Yb7WgR1pGmbYpq
c/F1heYcQnvjCt7dMz8HQ87L4kjnzN4WYR6e7ueM4H/eSjosY6ndIagGysT1PHd/
oFUcJZrwC1z3UhAYvn19fK6pbL+/YUhzRtYFzIuZ1Eay4zBh2LZ35blOG8GHVdRr
XVEv+lR76LVezR9NQFz3ZWbperMZ8Ig3Pv5xLThXQ/jrJnK/o/6cRFiBaFxd+g4A
YrICiyAE0EN/wglm1Y2qRf5HnbXtl04dB5uB6FH5caz12ZuxXiV0WqQhg8OaWIUp
httggjsJIze8WxKq/lUfx4njP11BUGqMeFFO22WU4tXu2o5qpFmZX1dCchZ/kiJG
AigIu9WOyIcR+BlxJnduWIDrWumWojlDpnLbxNX8HyBMklfMMTgV13vTDraqsq4G
VqWz9WHJppD5ArkdfCvwVUz+ymaQ+2eeJp0EioP1oD0/8JJA6DSDmAhaOgbZjIrr
aWcnbE7+/CYdXX91LjmW5Lbz29VWKZ/mJvs1sDyVNIYRanEQQFWZPSN5//6/k2ze
S6+SGR1793zNwj1dOUQCSOPTrr2feJ5rMcw2WDiZ4ZuLzudHHfR+3s2u9Nndu4bh
13FBrqteukycbvgC3vUmkYirtMhAskR3apaIkBoJ/k0jlmkpy9kCgJaLEX0LjB3r
INl93DNmcvczyA==
=O8zj
-----END PGP SIGNATURE-----
--=-=-=--
