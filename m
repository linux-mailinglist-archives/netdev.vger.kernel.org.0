Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5BF6294AD
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbiKOJpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238005AbiKOJp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:45:27 -0500
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE551FFA0;
        Tue, 15 Nov 2022 01:45:26 -0800 (PST)
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AF74xAB028085;
        Tue, 15 Nov 2022 04:45:00 -0500
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3kuvksuxek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Nov 2022 04:44:59 -0500
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 2AF9iwXR057517
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Nov 2022 04:44:58 -0500
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by ASHBMBX8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Tue, 15 Nov
 2022 04:44:57 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Tue, 15 Nov 2022 04:44:57 -0500
Received: from tachici-Precision-5530.ad.analog.com ([10.48.65.160])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 2AF9iatU023257;
        Tue, 15 Nov 2022 04:44:53 -0500
From:   Alexandru Tachici <alexandru.tachici@analog.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <steve.glendinning@shawell.net>,
        <UNGLinuxDriver@microchip.com>, <andre.edich@microchip.com>,
        <linux-usb@vger.kernel.org>
Subject: [net v2 1/1] net: usb: smsc95xx: fix external PHY reset
Date:   Tue, 15 Nov 2022 13:44:34 +0200
Message-ID: <20221115114434.9991-2-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115114434.9991-1-alexandru.tachici@analog.com>
References: <20221115114434.9991-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: B14qenhWzzHc7iPdXb2si1YDU4hGhPjY
X-Proofpoint-ORIG-GUID: B14qenhWzzHc7iPdXb2si1YDU4hGhPjY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_04,2022-11-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=717
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 phishscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211150067
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An external PHY needs settling time after power up or reset.
In the bind() function an mdio bus is registered. If at this point
the external PHY is still initialising, no valid PHY ID will be
read and on phy_find_first() the bind() function will fail.

If an external PHY is present, wait the maximum time specified
in 802.3 45.2.7.1.1.

Fixes: 05b35e7eb9a1 ("smsc95xx: add phylib support")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/usb/smsc95xx.c | 46 ++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index bfb58c91db04..32d2c60d334d 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -66,6 +66,7 @@ struct smsc95xx_priv {
 	spinlock_t mac_cr_lock;
 	u8 features;
 	u8 suspend_flags;
+	bool is_internal_phy;
 	struct irq_chip irqchip;
 	struct irq_domain *irqdomain;
 	struct fwnode_handle *irqfwnode;
@@ -252,6 +253,43 @@ static void smsc95xx_mdio_write(struct usbnet *dev, int phy_id, int idx,
 	mutex_unlock(&dev->phy_mutex);
 }
 
+static int smsc95xx_mdiobus_reset(struct mii_bus *bus)
+{
+	struct smsc95xx_priv *pdata;
+	struct usbnet *dev;
+	u32 val;
+	int ret;
+
+	dev = bus->priv;
+	pdata = dev->driver_priv;
+
+	if (pdata->is_internal_phy)
+		return 0;
+
+	mutex_lock(&dev->phy_mutex);
+
+	ret = smsc95xx_read_reg(dev, PM_CTRL, &val);
+	if (ret < 0)
+		goto reset_out;
+
+	val |= PM_CTL_PHY_RST_;
+
+	ret = smsc95xx_write_reg(dev, PM_CTRL, val);
+	if (ret < 0)
+		goto reset_out;
+
+	/* Driver has no knowledge at this point about the external PHY.
+	 * The 802.3 specifies that the reset process shall
+	 * be completed within 0.5 s.
+	 */
+	fsleep(500000);
+
+reset_out:
+	mutex_unlock(&dev->phy_mutex);
+
+	return 0;
+}
+
 static int smsc95xx_mdiobus_read(struct mii_bus *bus, int phy_id, int idx)
 {
 	struct usbnet *dev = bus->priv;
@@ -1052,7 +1090,6 @@ static void smsc95xx_handle_link_change(struct net_device *net)
 static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct smsc95xx_priv *pdata;
-	bool is_internal_phy;
 	char usb_path[64];
 	int ret, phy_irq;
 	u32 val;
@@ -1133,13 +1170,14 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (ret < 0)
 		goto free_mdio;
 
-	is_internal_phy = !(val & HW_CFG_PSEL_);
-	if (is_internal_phy)
+	pdata->is_internal_phy = !(val & HW_CFG_PSEL_);
+	if (pdata->is_internal_phy)
 		pdata->mdiobus->phy_mask = ~(1u << SMSC95XX_INTERNAL_PHY_ID);
 
 	pdata->mdiobus->priv = dev;
 	pdata->mdiobus->read = smsc95xx_mdiobus_read;
 	pdata->mdiobus->write = smsc95xx_mdiobus_write;
+	pdata->mdiobus->reset = smsc95xx_mdiobus_reset;
 	pdata->mdiobus->name = "smsc95xx-mdiobus";
 	pdata->mdiobus->parent = &dev->udev->dev;
 
@@ -1160,7 +1198,7 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	}
 
 	pdata->phydev->irq = phy_irq;
-	pdata->phydev->is_internal = is_internal_phy;
+	pdata->phydev->is_internal = pdata->is_internal_phy;
 
 	/* detect device revision as different features may be available */
 	ret = smsc95xx_read_reg(dev, ID_REV, &val);
-- 
2.34.1

