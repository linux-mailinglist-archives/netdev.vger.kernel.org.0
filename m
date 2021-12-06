Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300D74693FF
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 11:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236757AbhLFKj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 05:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbhLFKjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 05:39:25 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39555C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 02:35:57 -0800 (PST)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8608:6e64:956a:daea:cf2f])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 1B6AZR87480876
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 6 Dec 2021 11:35:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1638786930; bh=tmKijsISZj/4sjDdB+Ye1BRz3YbHXowWmKY4ejs4dHw=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=V8l5LhNHWWr2YrkBsgWiXuOqES66QhuGnn7b+p4nuuKqwnQ778y3g3IbDXRogaDcw
         V66dT/JR4WxAU1a9EeJ0/Rj5lIKHJX3P0cZP3gftmKpXZrJmmwH2wXJKBcMH86drl3
         HGeeI2f4PmxCC0XdID4bRDI8TgW++dEyJMisN9XE=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1muBLD-001qpK-DC; Mon, 06 Dec 2021 11:35:27 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     =?utf-8?B?54Wn5bGx5ZGo5LiA6YOO?= <teruyama@springboard-inc.jp>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Subject: Re: [PATCH net,stable] phy: sfp: fix high power modules without
 diag mode
Organization: m
References: <20211130073929.376942-1-bjorn@mork.no>
        <20211202175843.0210476e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YaoFkZ53m7cILdYu@shell.armlinux.org.uk>
        <YaoUW9KHyEQOt46b@shell.armlinux.org.uk>
        <877dclkd2y.fsf@miraculix.mork.no>
        <YathNbNBob2kHxrH@shell.armlinux.org.uk>
Date:   Mon, 06 Dec 2021 11:35:27 +0100
In-Reply-To: <YathNbNBob2kHxrH@shell.armlinux.org.uk> (Russell King's message
        of "Sat, 4 Dec 2021 12:38:13 +0000")
Message-ID: <877dcif2c0.fsf@miraculix.mork.no>
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
> On Fri, Dec 03, 2021 at 02:55:17PM +0100, Bj=C3=B8rn Mork wrote:
>> "Russell King (Oracle)" <linux@armlinux.org.uk> writes:
>>=20
>> > Thinking a little more, how about this:
>> >
>> >  drivers/net/phy/sfp.c | 25 +++++++++++++++++++++----
>> >  1 file changed, 21 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
>> > index 51a1da50c608..4c900d063b19 100644
>> > --- a/drivers/net/phy/sfp.c
>> > +++ b/drivers/net/phy/sfp.c
>> > @@ -1752,17 +1752,20 @@ static int sfp_sm_probe_for_phy(struct sfp *sf=
p)
>> >  static int sfp_module_parse_power(struct sfp *sfp)
>> >  {
>> >  	u32 power_mW =3D 1000;
>> > +	bool supports_a2;
>> >=20=20
>> >  	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
>> >  		power_mW =3D 1500;
>> >  	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
>> >  		power_mW =3D 2000;
>> >=20=20
>> > +	supports_a2 =3D sfp->id.ext.sff8472_compliance !=3D
>> > +				SFP_SFF8472_COMPLIANCE_NONE ||
>> > +		      sfp->id.ext.diagmon & SFP_DIAGMON_DDM;
>> > +
>> >  	if (power_mW > sfp->max_power_mW) {
>> >  		/* Module power specification exceeds the allowed maximum. */
>> > -		if (sfp->id.ext.sff8472_compliance =3D=3D
>> > -			SFP_SFF8472_COMPLIANCE_NONE &&
>> > -		    !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
>> > +		if (!supports_a2) {
>> >  			/* The module appears not to implement bus address
>> >  			 * 0xa2, so assume that the module powers up in the
>> >  			 * indicated mode.
>> > @@ -1779,11 +1782,24 @@ static int sfp_module_parse_power(struct sfp *=
sfp)
>> >  		}
>> >  	}
>> >=20=20
>> > +	if (power_mW <=3D 1000) {
>> > +		/* Modules below 1W do not require a power change sequence */
>> > +		return 0;
>> > +	}
>> > +
>> > +	if (!supports_a2) {
>> > +		/* The module power level is below the host maximum and the
>> > +		 * module appears not to implement bus address 0xa2, so assume
>> > +		 * that the module powers up in the indicated mode.
>> > +		 */
>> > +		return 0;
>> > +	}
>> > +
>> >  	/* If the module requires a higher power mode, but also requires
>> >  	 * an address change sequence, warn the user that the module may
>> >  	 * not be functional.
>> >  	 */
>> > -	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE && power_mW > 1000) {
>> > +	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE) {
>> >  		dev_warn(sfp->dev,
>> >  			 "Address Change Sequence not supported but module requires %u.%uW=
, module may not be functional\n",
>> >  			 power_mW / 1000, (power_mW / 100) % 10);
>>=20
>> Looks nice to me at least.  But I don't have the hardware to test it.
>
> I don't have the hardware either, so I can't test it - but it does need
> testing. I assume as you've reported it and sent a patch, you know
> someone who has run into this issue? It would be great if you could ask
> them to test it and let us know if it solves the problem.

Hello Teruyama!

Any chance you can test this proposed fix from Russel?  I believe it
should fix the issue with your NTT OCU SFP as well.


Bj=C3=B8rn
