Return-Path: <netdev+bounces-9571-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6430B729D61
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:53:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B44F71C20C54
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98FBB182BE;
	Fri,  9 Jun 2023 14:53:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D700256D
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 14:53:54 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B582D48;
	Fri,  9 Jun 2023 07:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=VoWyh3blPPiSMX+LkkceKIME1iOgbcnQP9AkgDOvlUs=; b=DVSgC/LnAiRmpRoF+PC2QSQawU
	6Mi8BAptpJH/Zzb5Nr584bueKOTp4DJ7j2IjBx3WbCFm+Fs+otVsfPLs0e252zJ+9V9pwA2FiZqvj
	JnIXAxsmWb9nVhVsB7y544VrU6pAYqLCH/EBwPUqoPnT2T9gm47mDvtcfozCsmH/38TY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q7dUj-00FM88-Oq; Fri, 09 Jun 2023 16:53:41 +0200
Date: Fri, 9 Jun 2023 16:53:41 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: alexis.lothore@bootlin.com
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	paul.arola@telus.com, scott.roberts@telus.com
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: implement egress tbf
 qdisc for 6393x family
Message-ID: <d196f8c7-19f7-4a7c-9024-e97001c21b90@lunn.ch>
References: <20230609141812.297521-1-alexis.lothore@bootlin.com>
 <20230609141812.297521-3-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609141812.297521-3-alexis.lothore@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> +int mv88e6393x_tbf_add(struct mv88e6xxx_chip *chip, int port,
> +		       struct tc_tbf_qopt_offload_replace_params *replace_params)
> +{
> +	int rate_kbps = DIV_ROUND_UP(replace_params->rate.rate_bytes_ps * 8, 1000);
> +	int overhead = DIV_ROUND_UP(replace_params->rate.overhead, 4);
> +	int rate_step, decrement_rate, err;
> +	u16 val;
> +
> +	if (rate_kbps < MV88E6393X_PORT_EGRESS_RATE_MIN_KBPS ||
> +	    rate_kbps >= MV88E6393X_PORT_EGRESS_RATE_MAX_KBPS)
> +		return -EOPNOTSUPP;
> +
> +	if (replace_params->rate.overhead > MV88E6393X_PORT_EGRESS_MAX_OVERHEAD)
> +		return -EOPNOTSUPP;
> +
> +	/* Switch supports only max rate configuration. There is no
> +	 * configurable burst/max size nor latency.

Can you return -EOPNOTSUPP if these values are not 0? That should make
it clear to the user they are not supported.

>  /* Offset 0x09: Egress Rate Control */
> -#define MV88E6XXX_PORT_EGRESS_RATE_CTL1		0x09
> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL1				0x09
> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_64_KBPS		0x1E84
> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_1_MBPS		0x01F4
> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_10_MBPS		0x0032
> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_100_MBPS		0x0005
> +#define MV88E6XXXw_PORT_EGRESS_RATE_CTL1_FRAME_OVERHEAD_SHIFT	8

Are they above values specific to the 6393? Or will they also work for
other families? You use the MV88E6XXX prefix which means they should
be generic across all devices.

	Andrew

