Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79062A3DDD
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgKCHlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:41:36 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:23948 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725982AbgKCHlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:41:36 -0500
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A37eJNZ010184;
        Tue, 3 Nov 2020 02:41:25 -0500
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 34h1s51chq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 02:41:25 -0500
Received: from SCSQMBX10.ad.analog.com (SCSQMBX10.ad.analog.com [10.77.17.5])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 0A37fNcv039469
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Tue, 3 Nov 2020 02:41:24 -0500
Received: from SCSQMBX10.ad.analog.com (10.77.17.5) by SCSQMBX10.ad.analog.com
 (10.77.17.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1779.2; Mon, 2 Nov 2020
 23:41:22 -0800
Received: from zeus.spd.analog.com (10.66.68.11) by SCSQMBX10.ad.analog.com
 (10.77.17.5) with Microsoft SMTP Server id 15.1.1779.2 via Frontend
 Transport; Mon, 2 Nov 2020 23:41:22 -0800
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 0A37fExS015488;
        Tue, 3 Nov 2020 02:41:20 -0500
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <alexaundru.ardelean@analog.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <ardeleanalex@gmail.com>, <kuba@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH net-next v2 2/2][RESEND] net: phy: adin: implement cable-test support
Date:   Tue, 3 Nov 2020 09:44:36 +0200
Message-ID: <20201103074436.93790-2-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201103074436.93790-1-alexandru.ardelean@analog.com>
References: <20201103074436.93790-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_05:2020-11-02,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxlogscore=960 clxscore=1015 bulkscore=0 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011030053
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADIN1300/ADIN1200 support cable diagnostics using TDR.

The cable fault detection is automatically run on all four pairs looking at
all combinations of pair faults by first putting the PHY in standby (clear
the LINK_EN bit, PHY_CTRL_3 register, Address 0x0017) and then enabling the
diagnostic clock (set the DIAG_CLK_EN bit, PHY_CTRL_1 register, Address
0x0012).

Cable diagnostics can then be run (set the CDIAG_RUN bit in the
CDIAG_RUN register, Address 0xBA1B). The results are reported for each pair
in the cable diagnostics results registers, CDIAG_DTLD_RSLTS_0,
CDIAG_DTLD_RSLTS_1, CDIAG_DTLD_RSLTS_2, and CDIAG_DTLD_RSLTS_3, Address
0xBA1D to Address 0xBA20).

The distance to the first fault for each pair is reported in the cable
fault distance registers, CDIAG_FLT_DIST_0, CDIAG_FLT_DIST_1,
CDIAG_FLT_DIST_2, and CDIAG_FLT_DIST_3, Address 0xBA21 to Address 0xBA24).

This change implements support for this using phylib's cable-test support.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 138 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 619d36685b5d..3e66f97c7611 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -8,6 +8,7 @@
 #include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
+#include <linux/ethtool_netlink.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mii.h>
@@ -70,6 +71,31 @@
 #define ADIN1300_CLOCK_STOP_REG			0x9400
 #define ADIN1300_LPI_WAKE_ERR_CNT_REG		0xa000
 
+#define ADIN1300_CDIAG_RUN			0xba1b
+#define   ADIN1300_CDIAG_RUN_EN			BIT(0)
+
+/*
+ * The XSIM3/2/1 and XSHRT3/2/1 are actually relative.
+ * For CDIAG_DTLD_RSLTS(0) it's ADIN1300_CDIAG_RSLT_XSIM3/2/1
+ * For CDIAG_DTLD_RSLTS(1) it's ADIN1300_CDIAG_RSLT_XSIM3/2/0
+ * For CDIAG_DTLD_RSLTS(2) it's ADIN1300_CDIAG_RSLT_XSIM3/1/0
+ * For CDIAG_DTLD_RSLTS(3) it's ADIN1300_CDIAG_RSLT_XSIM2/1/0
+ */
+#define ADIN1300_CDIAG_DTLD_RSLTS(x)		(0xba1d + (x))
+#define   ADIN1300_CDIAG_RSLT_BUSY		BIT(10)
+#define   ADIN1300_CDIAG_RSLT_XSIM3		BIT(9)
+#define   ADIN1300_CDIAG_RSLT_XSIM2		BIT(8)
+#define   ADIN1300_CDIAG_RSLT_XSIM1		BIT(7)
+#define   ADIN1300_CDIAG_RSLT_SIM		BIT(6)
+#define   ADIN1300_CDIAG_RSLT_XSHRT3		BIT(5)
+#define   ADIN1300_CDIAG_RSLT_XSHRT2		BIT(4)
+#define   ADIN1300_CDIAG_RSLT_XSHRT1		BIT(3)
+#define   ADIN1300_CDIAG_RSLT_SHRT		BIT(2)
+#define   ADIN1300_CDIAG_RSLT_OPEN		BIT(1)
+#define   ADIN1300_CDIAG_RSLT_GOOD		BIT(0)
+
+#define ADIN1300_CDIAG_FLT_DIST(x)		(0xba21 + (x))
+
 #define ADIN1300_GE_SOFT_RESET_REG		0xff0c
 #define   ADIN1300_GE_SOFT_RESET		BIT(0)
 
@@ -741,10 +767,117 @@ static int adin_probe(struct phy_device *phydev)
 	return 0;
 }
 
+static int adin_cable_test_start(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_clear_bits(phydev, ADIN1300_PHY_CTRL3, ADIN1300_LINKING_EN);
+	if (ret < 0)
+		return ret;
+
+	ret = phy_clear_bits(phydev, ADIN1300_PHY_CTRL1, ADIN1300_DIAG_CLK_EN);
+	if (ret < 0)
+		return ret;
+
+	/* wait a bit for the clock to stabilize */
+	msleep(50);
+
+	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_CDIAG_RUN,
+				ADIN1300_CDIAG_RUN_EN);
+}
+
+static int adin_cable_test_report_trans(int result)
+{
+	int mask;
+
+	if (result & ADIN1300_CDIAG_RSLT_GOOD)
+		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
+	if (result & ADIN1300_CDIAG_RSLT_OPEN)
+		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
+
+	/* short with other pairs */
+	mask = ADIN1300_CDIAG_RSLT_XSHRT3 |
+	       ADIN1300_CDIAG_RSLT_XSHRT2 |
+	       ADIN1300_CDIAG_RSLT_XSHRT1;
+	if (result & mask)
+		return ETHTOOL_A_CABLE_RESULT_CODE_CROSS_SHORT;
+
+	if (result & ADIN1300_CDIAG_RSLT_SHRT)
+		return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
+
+	return ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
+}
+
+static int adin_cable_test_report_pair(struct phy_device *phydev,
+				       unsigned int pair)
+{
+	int fault_rslt;
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1,
+			   ADIN1300_CDIAG_DTLD_RSLTS(pair));
+	if (ret < 0)
+		return ret;
+
+	fault_rslt = adin_cable_test_report_trans(ret);
+
+	ret = ethnl_cable_test_result(phydev, pair, fault_rslt);
+	if (ret < 0)
+		return ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1,
+			   ADIN1300_CDIAG_FLT_DIST(pair));
+	if (ret < 0)
+		return ret;
+
+	switch (fault_rslt) {
+	case ETHTOOL_A_CABLE_RESULT_CODE_OPEN:
+	case ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT:
+	case ETHTOOL_A_CABLE_RESULT_CODE_CROSS_SHORT:
+		return ethnl_cable_test_fault_length(phydev, pair, ret * 100);
+	default:
+		return  0;
+	}
+}
+
+static int adin_cable_test_report(struct phy_device *phydev)
+{
+	unsigned int pair;
+	int ret;
+
+	for (pair = ETHTOOL_A_CABLE_PAIR_A; pair <= ETHTOOL_A_CABLE_PAIR_D; pair++) {
+		ret = adin_cable_test_report_pair(phydev, pair);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int adin_cable_test_get_status(struct phy_device *phydev,
+				      bool *finished)
+{
+	int ret;
+
+	*finished = false;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_CDIAG_RUN);
+	if (ret < 0)
+		return ret;
+
+	if (ret & ADIN1300_CDIAG_RUN_EN)
+		return 0;
+
+	*finished = true;
+
+	return adin_cable_test_report(phydev);
+}
+
 static struct phy_driver adin_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1200),
 		.name		= "ADIN1200",
+		.flags		= PHY_POLL_CABLE_TEST,
 		.probe		= adin_probe,
 		.config_init	= adin_config_init,
 		.soft_reset	= adin_soft_reset,
@@ -761,10 +894,13 @@ static struct phy_driver adin_driver[] = {
 		.suspend	= genphy_suspend,
 		.read_mmd	= adin_read_mmd,
 		.write_mmd	= adin_write_mmd,
+		.cable_test_start	= adin_cable_test_start,
+		.cable_test_get_status	= adin_cable_test_get_status,
 	},
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300),
 		.name		= "ADIN1300",
+		.flags		= PHY_POLL_CABLE_TEST,
 		.probe		= adin_probe,
 		.config_init	= adin_config_init,
 		.soft_reset	= adin_soft_reset,
@@ -781,6 +917,8 @@ static struct phy_driver adin_driver[] = {
 		.suspend	= genphy_suspend,
 		.read_mmd	= adin_read_mmd,
 		.write_mmd	= adin_write_mmd,
+		.cable_test_start	= adin_cable_test_start,
+		.cable_test_get_status	= adin_cable_test_get_status,
 	},
 };
 
-- 
2.17.1

