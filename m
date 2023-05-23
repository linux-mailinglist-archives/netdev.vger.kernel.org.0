Return-Path: <netdev+bounces-4733-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B11E970E10F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:54:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7910A1C20B1E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 570F5200A0;
	Tue, 23 May 2023 15:54:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402EA1D2BA
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:54:54 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F9191
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=FIiNuPP8ga2rEoNmjmmFkkUK2H100/g0RZ8OUp+/UqI=; b=fyRZoK02j4Vcxw9/mXb7/G9Q/5
	kD2FgMoJdKgAvqhRUSeUWAyEqTyraq3GtZDp0kr4JmVlgWe1wLvINNtE+te5p1Ei0/rGj/qlPHWCK
	hJoBNqCDG6xOZxnn9InvvjoA20YM6xiv+rQvy7K7M5nJtQTqxxU5ptzLVU40g1tuSh+gdtfdP70s+
	Ws/JuO89ngk3oT2qUMxjPCBclGhPRC+iuPF0wwceuFgug0986Ng/Wx2SUNwL2z3XKFkAm+xYq4C/l
	vLgda+rahJc8U7E7deJuuqvqj8y1O6XOb9rjx1vSrI2gacCORdkGlu4yRq4JFBm4vD4dK2YiLVGVQ
	ElU+5Y7Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38370)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q1ULP-0000hn-SK; Tue, 23 May 2023 16:54:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q1ULN-0000i8-8e; Tue, 23 May 2023 16:54:37 +0100
Date: Tue, 23 May 2023 16:54:37 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>
Cc: Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	linux-arm-kernel@lists.infradead.org,
	Madalin Bucur <madalin.bucur@nxp.com>,
	Marcin Wojtas <mw@semihalf.com>,
	Michal Simek <michal.simek@amd.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RFC 0/9] Add and use helper for PCS negotiation modes
Message-ID: <ZGzhvePzPjJ0v2En@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

Earlier this month, I proposed a helper for deciding whether a PCS
should use inband negotiation modes or not. There was some discussion
around this topic, and I believe there was no disagreement about
providing the helper.

The discussion can be found at:

https://lore.kernel.org/r/ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk

This series adds that helper, and modifies most code to use it. I have
a couple of further patches that hoist this function out of every PCS
driver and into phylink's new phylink_pcs_config() function that I've
posted separately, and drop the "mode" argument to the pcs_config()
method, instead passing the result of phylink_pcs_neg_mode().

I haven't included those because this series doesn't update everything
in net-next, but for RFC purposes, I think this is good enough to get
a few whether people are generally happy or not.

Note that this helper is only about modes that affect the PCS such as
the SGMII family and 802.3z types, not amount negotiation that happens
in order to select a PCS (e.g. for backplanes.)

 drivers/net/dsa/qca/qca8k-8xxx.c                   | 13 ++--
 drivers/net/ethernet/freescale/fman/fman_dtsec.c   |  7 +-
 drivers/net/ethernet/marvell/mvneta.c              |  5 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  4 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  | 10 ++-
 .../ethernet/microchip/lan966x/lan966x_phylink.c   |  8 ++-
 .../net/ethernet/microchip/sparx5/sparx5_phylink.c |  8 ++-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  5 +-
 drivers/net/pcs/pcs-lynx.c                         | 18 +++--
 drivers/net/phy/phylink.c                          | 14 ++--
 include/linux/phylink.h                            | 81 +++++++++++++++++++++-
 11 files changed, 136 insertions(+), 37 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

