Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E0194BB8
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbfHSR2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:28:48 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36456 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbfHSR2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:28:45 -0400
Received: by mail-wr1-f65.google.com with SMTP id r3so9571460wrt.3;
        Mon, 19 Aug 2019 10:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LDL1hIKadz1gfObFDnKi45zKhu1D1Ko8kUYujKrQlXI=;
        b=Z60DL/+1uGqB6RAG9SY6mTUSrszUibmymMj+BCjmF8VzVv0OfxV6lTLlkqtJLYliZN
         ogn5iXTtb00TNB/5OSLI6xhz3CxHE7pJmcd7f5Axr/2IVT0/ELrp6GAZ+SbFNRhKKwWq
         hNMLwkTLlNmGgFiHX56LYQk1nL0vI0aCe6S6Q+UjxTMaX8kNewewdopAU+P/fix/I2lw
         tvJ4+WM2gEi00fnFGVzGXiQV+ClNzw3ztJci7nmC8Uo2JKobJVLBjzP5ATDeWHpRcZKd
         6BKmclfp3iq2648uxgx6aWa/it/S41T/MVEDXzgdHCdRQGr7Vdgz5/RtRBTcRmmsB30z
         eP6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LDL1hIKadz1gfObFDnKi45zKhu1D1Ko8kUYujKrQlXI=;
        b=bPRgO3CRzkKDrNeVXjOX/CRb4jaQQVjGO62EA9J4Mil1fmoAQgdkf6oxsFeLzaWZiZ
         Wu9lcbS0rcVT4qYh2yX8/M+4kxyDSv093T/+C7GS7fVhvbyoVhQI8kwS6T0oBDOklKzL
         4LxASy4MWOE0c3BNxOCUo0njJqOLQQoN+peUB4k7kbFuBGX3lvfPIAvmmLTLGoydLa0z
         b3FmW1YTjfLwcSBnaHx38sRDCvb2Jb+g5z4Gr65AlKK5Or/xt4Vxl2zc1NbUAbbh1A5D
         8qyD5Guc603IeY6vJrpWBq8IvYqHFt9ExKlS9bczWh9m/DQDUROxD6TFp2Dm7ulOvOV/
         aM4g==
X-Gm-Message-State: APjAAAULgjud2ij0PiJumC+QbAMFl5RBMtP8WodjwmPjb+VsxatwCFcQ
        /0j5laO3CL2xD7mhkTCHh4coCQjENVA=
X-Google-Smtp-Source: APXvYqx5uU5Wkhv60Ep5MQhWUVfVnCLRfGCdZTr4zXY0b1zOPWbc8aC4hUxy7JD5FDmQPjf/M14kSg==
X-Received: by 2002:adf:e3ce:: with SMTP id k14mr27044218wrm.303.1566235723149;
        Mon, 19 Aug 2019 10:28:43 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id c15sm41983879wrb.80.2019.08.19.10.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 10:28:42 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
X-Google-Original-From: Hubert Feurstein <hubert.feurstein@vahle.at>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next v2 4/4] net: fec: add support for PTP system timestamping for MDIO devices
Date:   Mon, 19 Aug 2019 19:28:27 +0200
Message-Id: <20190819172827.9550-5-hubert.feurstein@vahle.at>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20190819172827.9550-1-hubert.feurstein@vahle.at>
References: <20190819172827.9550-1-hubert.feurstein@vahle.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hubert Feurstein <h.feurstein@gmail.com>

In order to improve the synchronisation precision of phc2sys (from
the linuxptp project) for devices like switches which are attached
to the MDIO bus, it is necessary the get the system timestamps as
close as possible to the access which causes the PTP timestamp
register to be snapshotted in the switch hardware. Usually this is
triggered by an MDIO write access, the snapshotted timestamp is then
transferred by several MDIO reads.

The ptp_read_system_*ts functions already check the ptp_sts pointer.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index c01d3ec3e9af..dd1253683ac0 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1815,10 +1815,12 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	reinit_completion(&fep->mdio_done);
 
 	/* start a write op */
+	ptp_read_system_prets(bus->ptp_sts);
 	writel(FEC_MMFR_ST | FEC_MMFR_OP_WRITE |
 		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
 		FEC_MMFR_TA | FEC_MMFR_DATA(value),
 		fep->hwp + FEC_MII_DATA);
+	ptp_read_system_postts(bus->ptp_sts);
 
 	/* wait for end of transfer */
 	time_left = wait_for_completion_timeout(&fep->mdio_done,
@@ -1956,7 +1958,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	struct device_node *node;
 	int err = -ENXIO;
-	u32 mii_speed, holdtime;
+	u32 mii_speed, mii_period, holdtime;
 
 	/*
 	 * The i.MX28 dual fec interfaces are not equal.
@@ -1993,6 +1995,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	 * document.
 	 */
 	mii_speed = DIV_ROUND_UP(clk_get_rate(fep->clk_ipg), 5000000);
+	mii_period = div_u64((u64)mii_speed * 2 * NSEC_PER_SEC, clk_get_rate(fep->clk_ipg));
 	if (fep->quirks & FEC_QUIRK_ENET_MAC)
 		mii_speed--;
 	if (mii_speed > 63) {
@@ -2034,6 +2037,8 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 		pdev->name, fep->dev_id + 1);
 	fep->mii_bus->priv = fep;
 	fep->mii_bus->parent = &pdev->dev;
+	fep->mii_bus->flags = MII_BUS_F_PTP_STS_SUPPORTED;
+	fep->mii_bus->ptp_sts_offset = 32 * mii_period;
 
 	node = of_get_child_by_name(pdev->dev.of_node, "mdio");
 	err = of_mdiobus_register(fep->mii_bus, node);
-- 
2.22.1

