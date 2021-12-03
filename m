Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4B44678A5
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 14:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381200AbhLCNpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 08:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381280AbhLCNpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 08:45:18 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8003C06173E
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 05:41:53 -0800 (PST)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8608:6e64:956a:daea:cf2f])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 1B3DfbmH026263
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 3 Dec 2021 14:41:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1638538898; bh=M/gBvf2hxCASUDmitBBg9ryhF7aUleymKP4aAc/0l7M=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=aUVvqaeRIpMiH6JzVdpOJvpXOzFK1Nq9JfqV984GvJlxAeJrcQMIrCkWczgrJUkPD
         Lwhr9mfInK5U1sMHbcz/ZXWP5okPydQrYjfavAGdek1Hv5tmugB8P8jS33TxMNGDGL
         OpY/+5h6O8i0bOUWRZ3caITv74wGVe0OaVV8SLXw=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1mt8oj-001jZF-CR; Fri, 03 Dec 2021 14:41:37 +0100
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
Date:   Fri, 03 Dec 2021 14:41:37 +0100
In-Reply-To: <YaoFkZ53m7cILdYu@shell.armlinux.org.uk> (Russell King's message
        of "Fri, 3 Dec 2021 11:54:57 +0000")
Message-ID: <87czmdkdpq.fsf@miraculix.mork.no>
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

> On Thu, Dec 02, 2021 at 05:58:43PM -0800, Jakub Kicinski wrote:
>> On Tue, 30 Nov 2021 08:39:29 +0100 Bj=C3=B8rn Mork wrote:
>> > Commit 7cfa9c92d0a3 ("net: sfp: avoid power switch on address-change
>> > modules") changed semantics for high power modules without diag mode.
>> > We repeatedly try to read the current power status from the non-existi=
ng
>> > 0xa2 address, in the futile hope this failure is temporary:
>> >=20
>> > [    8.856051] sfp sfp-eth3: module NTT              0000000000000000 =
rev 0000 sn 0000000000000000 dc 160408
>> > [    8.865843] mvpp2 f4000000.ethernet eth3: switched to inband/1000ba=
se-x link mode
>> > [    8.873469] sfp sfp-eth3: Failed to read EEPROM: -5
>> > [    8.983251] sfp sfp-eth3: Failed to read EEPROM: -5
>> > [    9.103250] sfp sfp-eth3: Failed to read EEPROM: -5
>> >=20
>> > Eeprom dump:
>> >=20
>> > 0x0000: 03 04 01 00 00 00 80 00 00 00 00 01 0d 00 0a 64
>> > 0x0010: 00 00 00 00 4e 54 54 20 20 20 20 20 20 20 20 20
>> > 0x0020: 20 20 20 20 00 00 00 00 30 30 30 30 30 30 30 30
>> > 0x0030: 30 30 30 30 30 30 30 30 30 30 30 30 05 1e 00 7d
>> > 0x0040: 02 00 00 00 30 30 30 30 30 30 30 30 30 30 30 30
>> > 0x0050: 30 30 30 30 31 36 30 34 30 38 20 20 00 00 00 75
>> > 0x0060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> > 0x0070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> > 0x0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> > 0x0090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> > 0x00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> > 0x00b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> > 0x00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> > 0x00d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> > 0x00e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> > 0x00f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> >=20
>> > Previously we assumed such modules were powered up in the correct
>> > mode, continuing without further configuration as long as the
>> > required power class was supported by the host.
>> >=20
>> > Revert to that behaviour, refactoring to keep the improved
>> > diagnostic messages.
>> >=20
>> > Fixes: 7cfa9c92d0a3 ("net: sfp: avoid power switch on address-change m=
odules")
>> > Reported-and-tested-by: =E7=85=A7=E5=B1=B1=E5=91=A8=E4=B8=80=E9=83=8E =
<teruyama@springboard-inc.jp>
>> > Cc: Russell King <rmk+kernel@armlinux.org.uk>
>> > Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
>>=20
>> Russell, any comments?
>
> Sorry for the delay, I've been out over the last couple of days. I=20
> hink it's fine, but the code here is not easy to understand, hence
> why this subtlety was missed. So, I'm not entirely happy about going
> back to the original code.
>
> Maybe instead doing a check in sfp_sm_mod_hpower() for this would
> be better? Possibly something like:
>
> static int sfp_module_parse_power(struct sfp *sfp)

You lost me now.  This is still changing sfp_module_parse_power() and
not sfp_sm_mod_hpower().=20=20


> {
> 	u32 power_mW =3D 1000;
> +	bool supports_a2;
>
> 	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
> 		power_mW =3D 1500;
> 	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
> 		power_mW =3D 2000;
>
> +	supports_a2 =3D sfp->id.ext.sff8472_compliance !=3D
> +				SFP_SFF8472_COMPLIANCE_NONE ||
> +			sfp->id.ext.diagmon & SFP_DIAGMON_DDM;
>
> 	if (power_mW > sfp->max_power_mW) {
> 		/* Module power specification exceeds the allowed maximum. */
> -		if (sfp->id.ext.sff8472_compliance =3D=3D
> -			SFP_SFF8472_COMPLIANCE_NONE &&
> -		    !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
> +		if (!supports_a2) {
> ...
> 	}
> +
> +	if (!supports_a2 && power_mW > 1000) {
> +		/* The module power level is below the host maximum and the
> +		 * module appears not to implement bus address 0xa2, so assume
> +		 * that the module powers up in the indicated mode.
> +		 */
> +		return 0;
> +	}
>
> 	/* If the module requires a higher power mode, but also requires
> ...

Fine with me.  Looks cleaner, and should solve the reported problem
AFAICS.

> This way, if the module reports it doesn't support 0xa2, we don't get
> the "Address Change Sequence not supported" message - since if 0xa2 is
> not supported, then the address change sequence is irrelevant. However,
> modules shouldn't have that bit set... but "shouldn't" doesn't mean
> they do not.

Makes sense.  Although that's not a problem here, I guess we have to
expect just about any combination of random bits ;-)

> This also has the advantage of making the check explicit and obvious,
> and I much prefer the organisation of:
>
> 	if (module_exceeds_host_power) {
> 		handle this case
> 	} else {
> 		do other checks
> 	}


OK

> I think maybe dealing with power_mW <=3D 1000 early on may be a good idea,
> and eliminates the tests further down for power_mW > 1000.
>
> 	if (power_mW <=3D 1000) {
> 		sfp->module_power_mW =3D power_mW;
> 		return 0;
> 	}
>
> since those modules do not require any special handling.

Do you want this included now, or is that for a later cleanup?




Bj=C3=B8rn
