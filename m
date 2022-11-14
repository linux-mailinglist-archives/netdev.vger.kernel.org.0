Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80703627C21
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236548AbiKNLVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236146AbiKNLVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:21:01 -0500
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528C66475;
        Mon, 14 Nov 2022 03:17:35 -0800 (PST)
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AEA5lcD016147;
        Mon, 14 Nov 2022 06:17:09 -0500
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3ktwrrp6ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 06:17:09 -0500
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 2AEBH7Jm006008
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Nov 2022 06:17:07 -0500
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Mon, 14 Nov
 2022 06:17:07 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Mon, 14 Nov 2022 06:17:06 -0500
Received: from tachici-Precision-5530.ad.analog.com ([10.48.65.157])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 2AEBGh5h031805;
        Mon, 14 Nov 2022 06:16:45 -0500
From:   Alexandru Tachici <alexandru.tachici@analog.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <steve.glendinning@shawell.net>,
        <UNGLinuxDriver@microchip.com>, <andre.edich@microchip.com>,
        <linux-usb@vger.kernel.org>
Subject: [net] net: usb: smsc95xx: fix external PHY reset
Date:   Mon, 14 Nov 2022 15:16:43 +0200
Message-ID: <20221114131643.19450-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: 4Fuyddp9qQM8wFjQvmTtI4D4ho-JUD95
X-Proofpoint-GUID: 4Fuyddp9qQM8wFjQvmTtI4D4ho-JUD95
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_10,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 priorityscore=1501 clxscore=1011 bulkscore=0 mlxlogscore=759
 malwarescore=0 impostorscore=0 mlxscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211140082
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An external PHY needs settling time after power up or reser.
In the bind() function an mdio bus is registered. If at this point
the external PHY is still initialising, no valid PHY ID will be
read and on phy_find_first() the bind() function will fail.

If an external PHY is present, wait the maximum time specified
in 802.3 45.2.7.1.1.

Fixes: 05b35e7eb9a1 ("smsc95xx: add phylib support")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/usb/smsc95xx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index bfb58c91db04..5ed001c0cd56 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1134,8 +1134,15 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 		goto free_mdio;
 
 	is_internal_phy = !(val & HW_CFG_PSEL_);
-	if (is_internal_phy)
+	if (is_internal_phy) {
 		pdata->mdiobus->phy_mask = ~(1u << SMSC95XX_INTERNAL_PHY_ID);
+	} else {
+		/* Driver has no knowledge at this point about the external PHY.
+		 * The 802.3 specifies that the reset process shall
+		 * be completed within 0.5 s.
+		 */
+		fsleep(500000);
+	}
 
 	pdata->mdiobus->priv = dev;
 	pdata->mdiobus->read = smsc95xx_mdiobus_read;
-- 
2.34.1

