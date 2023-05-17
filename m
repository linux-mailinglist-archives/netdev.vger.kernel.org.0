Return-Path: <netdev+bounces-3458-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4F7707357
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 22:51:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 312642813D2
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 20:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40CB2101F2;
	Wed, 17 May 2023 20:51:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FDDAD28
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 20:51:28 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E4A4EF8;
	Wed, 17 May 2023 13:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=td3mHGkbZWK4bitS2wf7sSOv43WhAuUzx6ATNa2Tgf4=; b=ek
	edixrKGZzWlRPN4admMXkmeIkDyls9+iPJOKFtXhNJMRqestd1tnzfFRCBZFNabqnlUDrCzXL3VCD
	Z2aTEpbg8/j1FrMSret7OixMTIjsnjq3C1JbTLLbkw6NfDrDbJjn01GX5vnXrAuHd/7tifYZVEmVP
	mu/65FFl91j8jLQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pzO7B-00DAiR-Ej; Wed, 17 May 2023 22:51:17 +0200
Date: Wed, 17 May 2023 22:51:17 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: alexis.lothore@bootlin.com
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com, paul.arola@telus.com,
	scott.roberts@telus.com
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: enable support for
 88E6361 switch
Message-ID: <9a836863-c279-490f-a49a-de4db5de9fd4@lunn.ch>
References: <20230517203430.448705-1-alexis.lothore@bootlin.com>
 <20230517203430.448705-3-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230517203430.448705-3-alexis.lothore@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 10:34:30PM +0200, alexis.lothore@bootlin.com wrote:
> From: Alexis Lothoré <alexis.lothore@bootlin.com>
> 
> Marvell 88E6361 is an 8-port switch derived from the
> 88E6393X/88E9193X/88E6191X switches family. It can benefit from the
> existing mv88e6xxx driver by simply adding the proper switch description in
> the driver. Main differences with other switches from this
> family are:
> - 8 ports exposed (instead of 11): ports 1, 2 and 8 not available
> - No 5GBase-x nor SFI/USXGMII support

So what exactly is supported for link modes?

The way you reuse the 6393 ops, are these differences actually
enforced? It looks like mv88e6393x_phylink_get_caps() will allow
2500BaseX, 5GBaseX and 10GBaseR for port 10.

> +	[MV88E6361] = {
> +		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6361,
> +		.family = MV88E6XXX_FAMILY_6393,
> +		.name = "Marvell 88E6361",
> +		.num_databases = 4096,
> +		.num_macs = 16384,
> +		.num_ports = 11,
> +		/* Ports 1, 2 and 8 are not routed */
> +		.invalid_port_mask = BIT(1) | BIT(2) | BIT(8),
> +		.num_internal_phys = 5,

Which ports have internal PHYs? 2, 3, 4, 5, 6, 7 ?  What does
mv88e6xxx_phy_is_internal() return for these ports, and
mv88e6xxx_get_capsmv88e6xxx_get_caps()? I'm wondering if you actually
need to list 8 here?

     Andrew

