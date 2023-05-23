Return-Path: <netdev+bounces-4605-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8284B70D85A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:05:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EFF21C20CC6
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 508691E50F;
	Tue, 23 May 2023 09:04:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3891E509
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:04:44 +0000 (UTC)
Received: from smtp.missinglinkelectronics.com (smtp.missinglinkelectronics.com [162.55.135.183])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E6E102;
	Tue, 23 May 2023 02:04:41 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp.missinglinkelectronics.com (Postfix) with ESMTP id 92A7620621;
	Tue, 23 May 2023 11:04:39 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at missinglinkelectronics.com
Received: from smtp.missinglinkelectronics.com ([127.0.0.1])
	by localhost (mail.missinglinkelectronics.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xFltrHOvrUuh; Tue, 23 May 2023 11:04:39 +0200 (CEST)
Received: from humpen-bionic2.mle (p578c5bfe.dip0.t-ipconnect.de [87.140.91.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: david)
	by smtp.missinglinkelectronics.com (Postfix) with ESMTPSA id 131112045B;
	Tue, 23 May 2023 11:04:38 +0200 (CEST)
From: David Epping <david.epping@missinglinkelectronics.com>
To: Vladimir Oltean <olteanv@gmail.com>,
	Russell King <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com,
	David Epping <david.epping@missinglinkelectronics.com>
Subject: [PATCH net v2 0/3] net: phy: mscc: support VSC8501
Date: Tue, 23 May 2023 11:04:02 +0200
Message-Id: <20230523090405.10655-1-david.epping@missinglinkelectronics.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

Hello,

this updated series of patches adds support for the VSC8501 Ethernet
PHY and fixes support for the VSC8502 PHY in cases where no other
software (like U-Boot) has initialized the PHY after power up.

The first patch simply adds the VSC8502 to the MODULE_DEVICE_TABLE,
where I guess it was unintentionally missing. I have no hardware to
test my change.

The second patch adds the VSC8501 PHY with exactly the same driver
implementation as the existing VSC8502.

The third patch fixes the initialization for VSC8501 and VSC8502.
I have tested this patch with VSC8501 on hardware in RGMII mode only.
https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/DataSheets/VSC8501-03_Datasheet_60001741A.PDF
https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/DataSheets/VSC8502-03_Datasheet_60001742B.pdf
Table 4-42 "RGMII CONTROL, ADDRESS 20E2 (0X14)" Bit 11 for each of
them.
By default the RX_CLK is disabled for these PHYs. In cases where no
other software, like U-Boot, enabled the clock, this results in no
received packets being handed to the MAC.
The patch enables this clock output.
According to Microchip support (case number 01268776) this applies
to all modes (RGMII, GMII, and MII).

Other PHYs sharing the same register map and code, like
VSC8530/31/40/41 have the clock enabled and the relevant bit 11 is
reserved and read-only for them. As per previous discussion the
patch still clears the bit on these PHYs, too, possibly more easily
supporting other future PHYs implementing this functionality.

For the VSC8572 family of PHYs, having a different register map,
no such changes are applied.

Thanks for your feedback,
David

--

Changes in v2:
- adjust cover letter (U-Boot, PHY families)
- add reviewed-by tags to patch 1/3 and 2/3
- patch 3/3: combine vsc85xx_rgmii_set_skews() and
  vsc85xx_rgmii_enable_rx_clk() into vsc85xx_update_rgmii_cntl()
  for fewer MDIO accesses
- patch 3/3: treat all VSC8502 family PHYs the same (regardless of
  bit 11 reserved status)

Additional notes for review:
- If you want to, feel free to add something like
  Co developed by Vladimir Oltean <olteanv@gmail.com>.
  I did not do that, because the Kernel documentation requires a
  signed off by to go with it.
  Significant parts of the new patch are from your emails.
- I left the mutex_lock(&phydev->lock) in the
  vsc85xx_update_rgmii_cntl() function, as I'm not sure whether it
  is required to repeatedly access phydev->interface and
  phy_interface_is_rgmii(phydev) in a consistent way.
- For cases of not RGMII mode and not VSC8502 family there is no
  MDIO access. Same as with the current mainline code.

--

David Epping (3):
  net: phy: mscc: add VSC8502 to MODULE_DEVICE_TABLE
  net: phy: mscc: add support for VSC8501
  net: phy: mscc: enable VSC8501/2 RGMII RX clock

 drivers/net/phy/mscc/mscc.h      |  2 +
 drivers/net/phy/mscc/mscc_main.c | 80 +++++++++++++++++++++-----------
 2 files changed, 56 insertions(+), 26 deletions(-)


base-commit: 18c40a1cc1d990c51381ef48cd93fdb31d5cd903
-- 
2.17.1


