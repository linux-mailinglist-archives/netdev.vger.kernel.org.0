Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CFA4CD567
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 14:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiCDNrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 08:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiCDNrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 08:47:00 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8054A1B84D6;
        Fri,  4 Mar 2022 05:46:12 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646401570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+qVNVphU3Gm3EnlFWZRXmSURmHaVndeojdH/n2OcvIc=;
        b=Mj3OST0SQfXiy8DBZm8US3DVz9ppbnUkSJpLY44P+ArnzdySToKmhmuGZnF4tpaMKXBFpt
        gi6CbIccfUQn5ljWOqqEE1fzsjOBtbYgamV9lXVAoZiPPYaXJZjyzi48O63yLYniupf+p6
        jlZvYIEiE4LNXj1s5zsHVUwlyF4yH52tiEozJD5gXYU9wIZatN6as1/civFdn2RYxQz9EX
        DBPVdduv5BkyNacUMmY04dIWOLAB2jy70h1cy6mVaZnZeQVmTpR6xrhech45o0M/plz6Ls
        DRhCxfST8Wf+9LljIruDg3o9fFmw1MLCKWNzH3/NznwEuGzkbVDEg/y2hgBJ4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646401570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+qVNVphU3Gm3EnlFWZRXmSURmHaVndeojdH/n2OcvIc=;
        b=Xb19Oja3bbFVg6GnmPnbHKScCj4hVOICzSVFdCDOd3fy0iXUfHKIjiWyUlwjXSgkmFwFHX
        H9HkP1l3NmfntNAQ==
To:     Divya Koppera <Divya.Koppera@microchip.com>,
        netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        richardcochran@gmail.com
Cc:     linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        madhuri.sripada@microchip.com, manohar.puri@microchip.com
Subject: Re: [PATCH net-next 3/3] net: phy: micrel: 1588 support for LAN8814
 phy
In-Reply-To: <20220304093418.31645-4-Divya.Koppera@microchip.com>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-4-Divya.Koppera@microchip.com>
Date:   Fri, 04 Mar 2022 14:46:08 +0100
Message-ID: <87ee3hde5b.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Fri Mar 04 2022, Divya Koppera wrote:
> Add support for 1588 in LAN8814 phy driver.
> It supports 1-step and 2-step timestamping.
>
> Co-developed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> ---
>  drivers/net/phy/micrel.c | 1088 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 1066 insertions(+), 22 deletions(-)

[snip]

> +static bool is_sync(struct sk_buff *skb, int type)
> +{
> +	struct ptp_header *hdr;
> +
> +	hdr = ptp_parse_header(skb, type);
> +	if (!hdr)
> +		return false;
> +
> +	return ((ptp_get_msgtype(hdr, type) & 0xf) == 0);

The '& 0xf' is already performed by ptp_get_msgtype() and you can use '==
PTP_MSGTYPE_SYNC' instead of 0.

Second, this seems like the second driver to use is_sync(). The other
one is dp83640. Richard, should it be moved to ptp classify?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmIiGCATHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgkafD/9Amt6hCJYn08slvDgpUI1XdQ3cmggH
t9PslPZSCutHidicIoDgLtEI1AtQAVexZN181eHLF6SjRDoNA0hgQQCMR4b/TkWH
vYWUXcoabIxeG0cnf/hAlfgdceMF7d5QdJxHIIBu09KXlDojqp1pAFOy7yxODM+g
hcuB9WsBzRiPE4QZbPENXd3XoGHsECfNb1owUPIUS47DJPUwsfPwyoJjc9bIUKz7
0W5WYdV97GbU+omp8Pt8NCT100FfIFN0cCJ/VN7ra5KI9olXGWQA8FvnUQgQmdZF
whskULc2aNxb2g+4c09aD/Ykpuiy7YvwG1tSAFqbVhzJV0A4bT7tkZkz042E81ik
GbT+UpGGXReQzFt1jb887CMR0JHYw4A3GyZVx7l7pDoYvx99BMUUIF1Bz89x4Lnj
vIcQaK01qVFpfwnY7y/QrFEzO0E+3xbIDrVBu0HgdpUOvL4rL3VhDA3E3qVN5WpS
yOjnWiP36OtXdDgpXLM9VdqbYo7vzEhikeFBkJIbL3dlL5iFtCMip41/5YWYFOGh
ObWfJ5cO5VfXcpcxag24s0zEG1lK83UfO64YNV90DxbbTbR19EzN702qCmj2AyMv
VDbQw71WrX3OpAIslfbaATPeDvY3x8ZECmCvryiRpZb7c7YZ7spWJFqeEZnoayv4
OG+rQebpHO/Flg==
=Uwq4
-----END PGP SIGNATURE-----
--=-=-=--
