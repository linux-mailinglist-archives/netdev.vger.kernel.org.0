Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EE0438186
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 05:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhJWD1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 23:27:35 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:27183 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbhJWD1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 23:27:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634959494; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=+oajzsf1fl9Gw8kku/wIe9EdIdkDw2TeU2ygjiesPhQ=; b=F+3KhgtvbHSajDEG2YxtYr5nkjKNaXBebQxRHyZwvYCu86EsUN8vAeFqW9A7E6RDaBosfMFe
 aJk1KDy9okWWsNjIJl6RvkK7cNWcq+vPty15yYJ2sNESkmzPbVB/o2L+81vEUz2DtbsuCkPl
 vFS4Qx+lO0MBIIxT3JyijwnrOyg=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 6173808514914866fa39117d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 23 Oct 2021 03:24:53
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1D9B0C4360C; Sat, 23 Oct 2021 03:24:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CCED3C4360C;
        Sat, 23 Oct 2021 03:24:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org CCED3C4360C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v5 10/14] net: phy: add genphy_c45_fast_retrain
Date:   Sat, 23 Oct 2021 11:24:08 +0800
Message-Id: <20211023032412.30479-11-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211023032412.30479-1-luoj@codeaurora.org>
References: <20211023032412.30479-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add generic fast retrain auto-negotiation function for C45 PHYs.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/phy-c45.c | 34 ++++++++++++++++++++++++++++++++++
 include/linux/phy.h       |  1 +
 2 files changed, 35 insertions(+)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index c617dbcad6ea..b01180e1f578 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -611,6 +611,40 @@ int genphy_c45_loopback(struct phy_device *phydev, bool enable)
 }
 EXPORT_SYMBOL_GPL(genphy_c45_loopback);
 
+/**
+ * genphy_c45_fast_retrain - configure fast retrain registers
+ * @phydev: target phy_device struct
+ *
+ * Description: If fast-retrain is enabled, we configure PHY as
+ *   advertising fast retrain capable and THP Bypass Request, then
+ *   enable fast retrain. If it is not enabled, we configure fast
+ *   retrain disabled.
+ */
+int genphy_c45_fast_retrain(struct phy_device *phydev, bool enable)
+{
+	int ret;
+
+	if (!enable)
+		return phy_clear_bits_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_10GBR_FSRT_CSR,
+				MDIO_PMA_10GBR_FSRT_ENABLE);
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->supported)) {
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_AN, MDIO_AN_10GBT_CTRL,
+				MDIO_AN_10GBT_CTRL_ADVFSRT2_5G);
+		if (ret)
+			return ret;
+
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_AN, MDIO_AN_CTRL2,
+				MDIO_AN_THP_BP2_5GT);
+		if (ret)
+			return ret;
+	}
+
+	return phy_set_bits_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_10GBR_FSRT_CSR,
+			MDIO_PMA_10GBR_FSRT_ENABLE);
+}
+EXPORT_SYMBOL_GPL(genphy_c45_fast_retrain);
+
 struct phy_driver genphy_c45_driver = {
 	.phy_id         = 0xffffffff,
 	.phy_id_mask    = 0xffffffff,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 736e1d1a47c4..04e90423fa88 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1584,6 +1584,7 @@ int genphy_c45_config_aneg(struct phy_device *phydev);
 int genphy_c45_loopback(struct phy_device *phydev, bool enable);
 int genphy_c45_pma_resume(struct phy_device *phydev);
 int genphy_c45_pma_suspend(struct phy_device *phydev);
+int genphy_c45_fast_retrain(struct phy_device *phydev, bool enable);
 
 /* Generic C45 PHY driver */
 extern struct phy_driver genphy_c45_driver;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

