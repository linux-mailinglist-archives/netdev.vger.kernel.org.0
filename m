Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A194678E7
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 14:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352505AbhLCN6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 08:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243650AbhLCN6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 08:58:51 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4C6C06173E
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 05:55:27 -0800 (PST)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8608:6e64:956a:daea:cf2f])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 1B3DtIcJ027720
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 3 Dec 2021 14:55:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1638539719; bh=b36wlv4C/4ylWVzS0s0ymbAA4VAqnfrOZNgjREJ55wE=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=UlRqS2ZB8AqGew6pu7oEBM4LCQWRQyoEMoayBKsCiMazRU0uWCRXdOJaeuFNoRL4D
         ljpVPo1T3A+xidD+fGbKjCjczJaNPCQFbalfy5+gQn+PV0lJLLL0ur0zOJpxHQseKC
         qR1yYfjPVg6W8JoyPnZji2biWG9GKvIoG35Kf4gQ=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1mt91x-001jap-ST; Fri, 03 Dec 2021 14:55:17 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        =?utf-8?B?54Wn5bGx5ZGo5LiA6YOO?= <teruyama@springboard-inc.jp>
Subject: Re: [PATCH net,stable] phy: sfp: fix high power modules without
 diag mode
Organization: m
References: <20211130073929.376942-1-bjorn@mork.no>
        <20211202175843.0210476e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YaoFkZ53m7cILdYu@shell.armlinux.org.uk>
        <YaoUW9KHyEQOt46b@shell.armlinux.org.uk>
Date:   Fri, 03 Dec 2021 14:55:17 +0100
In-Reply-To: <YaoUW9KHyEQOt46b@shell.armlinux.org.uk> (Russell King's message
        of "Fri, 3 Dec 2021 12:58:03 +0000")
Message-ID: <877dclkd2y.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.3 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Russell King (Oracle)" <linux@armlinux.org.uk> writes:

> Thinking a little more, how about this:
>
>  drivers/net/phy/sfp.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 51a1da50c608..4c900d063b19 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -1752,17 +1752,20 @@ static int sfp_sm_probe_for_phy(struct sfp *sfp)
>  static int sfp_module_parse_power(struct sfp *sfp)
>  {
>  	u32 power_mW =3D 1000;
> +	bool supports_a2;
>=20=20
>  	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
>  		power_mW =3D 1500;
>  	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
>  		power_mW =3D 2000;
>=20=20
> +	supports_a2 =3D sfp->id.ext.sff8472_compliance !=3D
> +				SFP_SFF8472_COMPLIANCE_NONE ||
> +		      sfp->id.ext.diagmon & SFP_DIAGMON_DDM;
> +
>  	if (power_mW > sfp->max_power_mW) {
>  		/* Module power specification exceeds the allowed maximum. */
> -		if (sfp->id.ext.sff8472_compliance =3D=3D
> -			SFP_SFF8472_COMPLIANCE_NONE &&
> -		    !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
> +		if (!supports_a2) {
>  			/* The module appears not to implement bus address
>  			 * 0xa2, so assume that the module powers up in the
>  			 * indicated mode.
> @@ -1779,11 +1782,24 @@ static int sfp_module_parse_power(struct sfp *sfp)
>  		}
>  	}
>=20=20
> +	if (power_mW <=3D 1000) {
> +		/* Modules below 1W do not require a power change sequence */
> +		return 0;
> +	}
> +
> +	if (!supports_a2) {
> +		/* The module power level is below the host maximum and the
> +		 * module appears not to implement bus address 0xa2, so assume
> +		 * that the module powers up in the indicated mode.
> +		 */
> +		return 0;
> +	}
> +
>  	/* If the module requires a higher power mode, but also requires
>  	 * an address change sequence, warn the user that the module may
>  	 * not be functional.
>  	 */
> -	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE && power_mW > 1000) {
> +	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE) {
>  		dev_warn(sfp->dev,
>  			 "Address Change Sequence not supported but module requires %u.%uW, m=
odule may not be functional\n",
>  			 power_mW / 1000, (power_mW / 100) % 10);



Looks nice to me at least.  But I don't have the hardware to test it.


Bj=C3=B8rn
