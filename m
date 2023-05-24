Return-Path: <netdev+bounces-5025-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AD5270F750
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33BEC1C20D68
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3CF660874;
	Wed, 24 May 2023 13:08:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B5F6085F
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:08:16 +0000 (UTC)
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85FAB6;
	Wed, 24 May 2023 06:08:14 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 01960FF810;
	Wed, 24 May 2023 13:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684933693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Dlu+LIg1CB+EdnEPMRmgOuwoUG3Sx5A6cdZB48OIf+o=;
	b=TXeMRzQjPBVJLFm8zj+9XMU3hmTOf+SK7zuShVTqMztutIcqd118u6v0w9R/KPPCE7h8qp
	GZbNPXSmJBJUYjLN9W01if1NHI2dXvYZbS517YQJ8EetG4J6DpBW5wjXXkPOA08EqBu3TP
	KxLLjyy2yl/fWTUx0ccinXmfglU9jXnmoVlfviY3awUi6quztjFfpQR1nFhRG7IceaZuri
	0RR0QA3LX/w8M2UH/wiT/VpdyWMCD8hGm7InL3BIxtVzA6Fkx0TsCMLbZGNNzPbozgN+yo
	aJcC+0s+iS9aJYCZU2PM7+PLdc8TUnkwkpvzHajszsWdSoVUUGJdVsz6VJ6C3A==
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: Mark Brown <broonie@kernel.org>,
	davem@davemloft.net
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	alexis.lothore@bootlin.com,
	thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH net-next 0/4] net: add a regmap-based mdio driver and drop TSE PCS
Date: Wed, 24 May 2023 15:08:03 +0200
Message-Id: <20230524130807.310089-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello everyone,

This series follows-up on the worki [1] aiming at dropping the altera TSE PCS
driver, as it turns out to be a version of the Lynx PCS exposed as a
memory-mapped block, instead of living on an MDIO bus.

One step of this removal involved creating a regmap-based mdio driver
that translates MDIO accesses into the actual underlying bus that
exposes the register. The register layout must of course match the
standard MDIO layout, but we can now account for differences in stride
with recent work on the regmap subsystem [2].

Mark, Net maintainers, this series depends on the patch e12ff2876493 that was
recently merged into the regmap tree [3].

For this series to be usable in net-next, this patch must be applied
beforehand. Should Mark create a tag that would then be merged into
net-next ?

This series introduces a new MDIO driver, and uses it to convert Altera
TSE from the actual TSE PCS driver to Lynx PCS.

Since it turns out dwmac_socfpga also uses a TSE PCS block, port that
driver to Lynx as well.

Thanks,

Maxime

[1] : https://lore.kernel.org/all/20230324093644.464704-1-maxime.chevallier@bootlin.com/
[2] : https://lore.kernel.org/all/20230407152604.105467-1-maxime.chevallier@bootlin.com/#t
[3] : https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git/commit/?id=e12ff28764937dd58c8613f16065da60da149048

Maxime Chevallier (4):
  net: mdio: Introduce a regmap-based mdio driver
  net: ethernet: altera-tse: Convert to mdio-regmap and use PCS Lynx
  net: pcs: Drop the TSE PCS driver
  net: stmmac: dwmac-sogfpga: use the lynx pcs driver

 MAINTAINERS                                   |  14 +-
 drivers/net/ethernet/altera/Kconfig           |   2 +
 drivers/net/ethernet/altera/altera_tse.h      |   1 +
 drivers/net/ethernet/altera/altera_tse_main.c |  57 +++-
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   1 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   2 +-
 .../ethernet/stmicro/stmmac/altr_tse_pcs.c    | 257 ------------------
 .../ethernet/stmicro/stmmac/altr_tse_pcs.h    |  29 --
 drivers/net/ethernet/stmicro/stmmac/common.h  |   1 +
 .../ethernet/stmicro/stmmac/dwmac-socfpga.c   |  90 ++++--
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  12 +-
 drivers/net/mdio/Kconfig                      |  10 +
 drivers/net/mdio/Makefile                     |   1 +
 drivers/net/mdio/mdio-regmap.c                |  85 ++++++
 drivers/net/pcs/Kconfig                       |   6 -
 drivers/net/pcs/Makefile                      |   1 -
 drivers/net/pcs/pcs-altera-tse.c              | 160 -----------
 include/linux/mdio/mdio-regmap.h              |  25 ++
 include/linux/pcs-altera-tse.h                |  17 --
 19 files changed, 258 insertions(+), 513 deletions(-)
 delete mode 100644 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
 delete mode 100644 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
 create mode 100644 drivers/net/mdio/mdio-regmap.c
 delete mode 100644 drivers/net/pcs/pcs-altera-tse.c
 create mode 100644 include/linux/mdio/mdio-regmap.h
 delete mode 100644 include/linux/pcs-altera-tse.h

-- 
2.40.1


