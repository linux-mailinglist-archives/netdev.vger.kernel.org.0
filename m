Return-Path: <netdev+bounces-9264-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DB05728516
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:34:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 378AF281777
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96979101D6;
	Thu,  8 Jun 2023 16:34:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9C523D7
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:34:15 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCFF3592;
	Thu,  8 Jun 2023 09:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=mfnbtev31uFyEY3OhGP9nDmwVwNJ/fmqpOtxac0yHZI=; b=bT5s0Vb6l+/HbrzHFoe+F1K3dy
	OdYtl/xh4w6NTkuwm3zmrZb4syiVtYZ+1vWvLpaNmUDmESD6juzgdUsRzvlI+yRj+vUf54ssuYaU9
	aiZ1m5N90dSlwVgHxibwaWSIRMAd+TmgdQfWD38sDLGa1QRJgtzhoG0PhUs6i0dDP7Kbh1LQyyUeG
	lGwoDz+IS+8oJEZnN5KT0rfHtP/CuPWHuu0mgiMc0qJHJw17G87cOgOjQzS+DLTurelyJuot0vV75
	VYHoVsn8wnHMfmOk39BJAPBu3harCOQYhuSY0BnbVIsmA+vMEBYZh6Sxoa2z1fgx/Zlq/UJdfGDnj
	10Utx6WA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55434)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q7Ia3-0000gL-EG; Thu, 08 Jun 2023 17:33:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q7Ia2-0000xd-LI; Thu, 08 Jun 2023 17:33:46 +0100
Date: Thu, 8 Jun 2023 17:33:46 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	linux-arm-kernel@lists.infradead.org, Horatiu.Vultur@microchip.com,
	Allan.Nielsen@microchip.com, UNGLinuxDriver@microchip.com,
	Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net 2/2] net: phylink: use a dedicated helper to parse
 usgmii control word
Message-ID: <ZIIC6mi2LtrD5P2m@shell.armlinux.org.uk>
References: <20230608163415.511762-1-maxime.chevallier@bootlin.com>
 <20230608163415.511762-3-maxime.chevallier@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608163415.511762-3-maxime.chevallier@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 06:34:14PM +0200, Maxime Chevallier wrote:
> Q-USGMII is a derivative of USGMII, that uses a specific formatting for
> the control word. The layout is close to the USXGMII control word, but
> doesn't support speeds over 1Gbps. Use a dedicated decoding logic for
> the USGMII control word, re-using USXGMII definitions with a custom mask
> and only considering 10/100/1000 speeds

Seems to be a duplicate patch?

Please see my comments on the other submission of this patch.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

