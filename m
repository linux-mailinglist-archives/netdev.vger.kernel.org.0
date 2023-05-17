Return-Path: <netdev+bounces-3400-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F10DE706E45
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:37:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A724B1C20AD2
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B032C111A8;
	Wed, 17 May 2023 16:37:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7F14421
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:37:24 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A7C10F9
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=nVej5yuRW/fMiHtc52Jp3MwlG9wHWNj7defztboYkA4=; b=u7UNv2apO1mOne+eQbBogOO5vn
	r2i3QNe6QUO3KkTAJXaDp8TfyA4yB7iUkwBoDsNwU4rG7DjiwoqC4Wzliyze7g1U1T7iXuuumYkpK
	fP99gLLKUi1TvVZ2fNGBJ6Xyot9QC2MMJ0th7lpoJK0y3IZB6tUlZsYt0LO9kYveNSfw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pzJRj-00D9Vl-80; Wed, 17 May 2023 17:52:11 +0200
Date: Wed, 17 May 2023 17:52:11 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next 7/7] net: sfp: add support for rate selection
Message-ID: <255a933c-95d8-4872-b394-b948a7f68a92@lunn.ch>
References: <ZGSuTY8GqjM+sqta@shell.armlinux.org.uk>
 <E1pzEXx-005jUu-W2@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pzEXx-005jUu-W2@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> +static void sfp_module_parse_rate_select(struct sfp *sfp)
> +{
> +	u8 rate_id;
> +
> +	sfp->rs_threshold_kbd = 0;
> +	sfp->rs_state_mask = 0;
> +
> +	if (!(sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_RATE_SELECT)))
> +		/* No support for RateSelect */
> +		return;
> +
> +	/* Default to INF-8074 RateSelect operation. The signalling threshold
> +	 * rate is not well specified, so always select "Full Bandwidth", but
> +	 * SFF-8079 reveals that it is understood that RS0 will be low for
> +	 * 1.0625Gb/s and high for 2.125Gb/s. Choose a value half-way between.
> +	 * This method exists prior to SFF-8472.
> +	 */
> +	sfp->rs_state_mask = SFP_F_RS0;
> +	sfp->rs_threshold_kbd = 1594;
> +
> +	/* Parse the rate identifier, which is complicated due to history:
> +	 * SFF-8472 rev 9.5 marks this field as reserved.
> +	 * SFF-8079 references SFF-8472 rev 9.5 and defines bit 0. SFF-8472
> +	 *  compliance is not required.
> +	 * SFF-8472 rev 10.2 defines this field using values 0..4
> +	 * SFF-8472 rev 11.0 redefines this field with bit 0 for SFF-8079
> +	 * and even values.
> +	 */
> +	rate_id = sfp->id.base.rate_id;
> +	if (rate_id == 0)
> +		/* Unspecified */
> +		return;
> +
> +	/* SFF-8472 rev 10.0..10.4 did not account for SFF-8079 using bit 0,
> +	 * and allocated value 3 to SFF-8431 independent tx/rx rate select.
> +	 * Convert this to a SFF-8472 rev 11.0 rate identifier.
> +	 */
> +	if (sfp->id.ext.sff8472_compliance >= SFP_SFF8472_COMPLIANCE_REV10_2 &&
> +	    sfp->id.ext.sff8472_compliance < SFP_SFF8472_COMPLIANCE_REV11_0 &&
> +	    rate_id == 3)
> +		rate_id = SFF_RID_8431;
> +
> +	if (rate_id & SFF_RID_8079) {
> +		/* SFF-8079 RateSelect / Application Select in conjunction with
> +		 * SFF-8472 rev 9.5. SFF-8079 defines rate_id as a bitfield
> +		 * with only bit 0 used, which takes precedence over SFF-8472.
> +		 */
> +		if (!(sfp->id.ext.enhopts & SFP_ENHOPTS_APP_SELECT_SFF8079)) {
> +			/* SFF-8079 Part 1 - rate selection between Fibre
> +			 * Channel 1.0625/2.125/4.25 Gbd modes. Note that RS0
> +			 * is high for 2125, so we have to subtract 1 to
> +			 * include it.
> +			 */
> +			sfp->rs_threshold_kbd = 2125 - 1;
> +			sfp->rs_state_mask = SFP_F_RS0;
> +		}
> +		return;
> +	}
> +
> +	/* SFF-8472 rev 9.5 does not define the rate identifier */
> +	if (sfp->id.ext.sff8472_compliance <= SFP_SFF8472_COMPLIANCE_REV9_5)
> +		return;
> +
> +	/* SFF-8472 rev 11.0 defines rate_id as a numerical value which will
> +	 * always have bit 0 clear due to SFF-8079's bitfield usage of rate_id.
> +	 */
> +	switch (rate_id) {
> +	case SFF_RID_8431_RX_ONLY:
> +		sfp->rs_threshold_kbd = 4250;
> +		sfp->rs_state_mask = SFP_F_RS0;
> +		break;
> +
> +	case SFF_RID_8431_TX_ONLY:
> +		sfp->rs_threshold_kbd = 4250;
> +		sfp->rs_state_mask = SFP_F_RS1;
> +		break;
> +
> +	case SFF_RID_8431:
> +		sfp->rs_threshold_kbd = 4250;
> +		sfp->rs_state_mask = SFP_F_RS0 | SFP_F_RS1;
> +		break;
> +
> +	case SFF_RID_10G8G:
> +		sfp->rs_threshold_kbd = 9000;
> +		sfp->rs_state_mask = SFP_F_RS0 | SFP_F_RS1;
> +		break;
> +	}
> +}

Having read all that, you can kind of understand why few vendors get
SFP EEPROMs correct.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

