Return-Path: <netdev+bounces-4079-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 899BF70A904
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 18:14:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54D5A280362
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 16:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BAE98F58;
	Sat, 20 May 2023 16:13:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B588F56
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 16:13:39 +0000 (UTC)
Received: from smtp.missinglinkelectronics.com (smtp.missinglinkelectronics.com [162.55.135.183])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD42118
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 09:13:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp.missinglinkelectronics.com (Postfix) with ESMTP id 3F7BA20661;
	Sat, 20 May 2023 18:07:23 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at missinglinkelectronics.com
Received: from smtp.missinglinkelectronics.com ([127.0.0.1])
	by localhost (mail.missinglinkelectronics.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KEUQHyrAvODV; Sat, 20 May 2023 18:07:23 +0200 (CEST)
Received: from humpen-bionic2.mle (p578c5bfe.dip0.t-ipconnect.de [87.140.91.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: david)
	by smtp.missinglinkelectronics.com (Postfix) with ESMTPSA id 8923E2021B;
	Sat, 20 May 2023 18:07:22 +0200 (CEST)
From: David Epping <david.epping@missinglinkelectronics.com>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com,
	David Epping <david.epping@missinglinkelectronics.com>
Subject: [PATCH net 0/3] net: phy: mscc: support VSC8501
Date: Sat, 20 May 2023 18:06:00 +0200
Message-Id: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

Hello,

this series of patches adds support for the VSC8501 Ethernet PHY and
fixes support for the VSC8502 PHY in RGMII mode (see below for
discussion).

The first patch simply adds the VSC8502 to the MODULE_DEVICE_TABLE,
where I guess it was unintentionally missing. I have no hardware to
test my change.

The second patch adds the VSC8501 PHY with exactly the same driver
implementation as the existing VSC8502. Note that for at least RGMII
mode this patch is not sufficient to operate the PHY, but likely the
existing code was not sufficient for VSC8502, either.

The third patch fixes RGMII mode operation for the VSC8501 (I have
tested this on hardware) and very likely also the VSC8502, which share
the same description of relevant registers in the datasheet.
https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/DataSheets/VSC8501-03_Datasheet_60001741A.PDF
https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/DataSheets/VSC8502-03_Datasheet_60001742B.pdf
Table 4-42 "RGMII CONTROL, ADDRESS 20E2 (0X14)" Bit 11 for each of
them.

By default the RX_CLK is disabled in both PHYs. This results in no
received packets being handed to the MAC. The patch enables this
clock.
Since I can only test RGMII mode, and the register is called RGMII,
my patch is limited to the RGMII mode. However, according to
Microchip support (case number 01268776) this applies to all modes
using the RX_CLK (which is all modes?).
Since the VSC8502 shares the same description, this would however mean
the existing code for VSC8502 could have never worked.
Is that possible? Has someone used VSC8502 successfully?

Other PHYs sharing the same basic code, like VSC8530/31/40/41 don't
have the clock disabled and the bit 11 is reserved for them.
Hence the check for PHY ID.

Should the uncertainty about GMII and MII modes be a source code
comment? Or in the commit message? Or not mentioned at all?

Thanks for your feedback,
David

David Epping (3):
  net: phy: mscc: add VSC8502 to MODULE_DEVICE_TABLE
  net: phy: mscc: add support for VSC8501
  net: phy: mscc: enable VSC8501/2 RGMII RX clock

 drivers/net/phy/mscc/mscc.h      |  2 ++
 drivers/net/phy/mscc/mscc_main.c | 50 ++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

-- 
2.17.1


