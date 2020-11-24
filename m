Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5BF2C29DE
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 15:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389200AbgKXOki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 09:40:38 -0500
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:46251 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730481AbgKXOkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 09:40:37 -0500
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0AOEWCAQ017400;
        Tue, 24 Nov 2020 15:40:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=STMicroelectronics;
 bh=/gBlAC28FXcb6RG+VvW/oP4Fyova5QfXA8ljSa5ZgMM=;
 b=N5aQzoJB5+owiet0hUrQ8lbEAFlZleMRGjdeT6Oh8/jBfDPLADy5462QlHPHxEJ6yODd
 pj/9ZMumQRigtx0i19nrP2K6ENE/+2zkmt2FHinnf6ZQeT2ktT8O6vKHPFhIXNO5dQF6
 0juf8LtcOVS2gnP9faz3xzv11hchL/eI6cEep62CH0Jg5ToIsuXpinDTjPC4TNHoXan8
 qFfWRPBWNobDL+S7QTi5L9ukzqLGTHRtJYdlPUEVE6vIRosksPbwuQA0GuAQbR1Vp291
 7U3Beyh7n85UsF5XuVHfm+GqssLhAB4vnQtFEW7ocC30jXVa7p8GqsOmdCnrAnyjgANq ew== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 34y05h80b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 15:40:05 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D8FCA10002A;
        Tue, 24 Nov 2020 15:40:00 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag1node3.st.com [10.75.127.3])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id AEBA82BA2BB;
        Tue, 24 Nov 2020 15:40:00 +0100 (CET)
Received: from localhost (10.75.127.50) by SFHDAG1NODE3.st.com (10.75.127.3)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Nov 2020 15:40:00
 +0100
From:   Antonio Borneo <antonio.borneo@st.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>
CC:     Antonio Borneo <antonio.borneo@st.com>, <stable@vger.kernel.org>,
        <linuxarm@huawei.com>, Salil Mehta <salil.mehta@huawei.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: phy: fix auto-negotiation in case of 'down-shift'
Date:   Tue, 24 Nov 2020 15:38:48 +0100
Message-ID: <20201124143848.874894-1-antonio.borneo@st.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.75.127.50]
X-ClientProxiedBy: SFHDAG4NODE3.st.com (10.75.127.12) To SFHDAG1NODE3.st.com
 (10.75.127.3)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_04:2020-11-24,2020-11-24 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the auto-negotiation fails to establish a gigabit link, the phy
can try to 'down-shift': it resets the bits in MII_CTRL1000 to
stop advertising 1Gbps and retries the negotiation at 100Mbps.

From commit 5502b218e001 ("net: phy: use phy_resolve_aneg_linkmode
in genphy_read_status") the content of MII_CTRL1000 is not checked
anymore at the end of the negotiation, preventing the detection of
phy 'down-shift'.
In case of 'down-shift' phydev->advertising gets out-of-sync wrt
MII_CTRL1000 and still includes modes that the phy have already
dropped. The link partner could still advertise higher speeds,
while the link is established at one of the common lower speeds.
The logic 'and' in phy_resolve_aneg_linkmode() between
phydev->advertising and phydev->lp_advertising will report an
incorrect mode.

Issue detected with a local phy rtl8211f connected with a gigabit
capable router through a two-pairs network cable.

After auto-negotiation, read back MII_CTRL1000 and mask-out from
phydev->advertising the modes that have been eventually discarded
due to the 'down-shift'.

Fixes: 5502b218e001 ("net: phy: use phy_resolve_aneg_linkmode in genphy_read_status")
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
Link: https://lore.kernel.org/r/478f871a-583d-01f1-9cc5-2eea56d8c2a7@huawei.com
---
To: Andrew Lunn <andrew@lunn.ch>
To: Heiner Kallweit <hkallweit1@gmail.com>
To: Russell King <linux@armlinux.org.uk>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
To: netdev@vger.kernel.org
To: Yonglong Liu <liuyonglong@huawei.com>
Cc: linuxarm@huawei.com
Cc: Salil Mehta <salil.mehta@huawei.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-kernel@vger.kernel.org
Cc: Antonio Borneo <antonio.borneo@st.com>

 drivers/net/phy/phy_device.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5dab6be6fc38..5d1060aa1b25 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2331,7 +2331,7 @@ EXPORT_SYMBOL(genphy_read_status_fixed);
  */
 int genphy_read_status(struct phy_device *phydev)
 {
-	int err, old_link = phydev->link;
+	int adv, err, old_link = phydev->link;
 
 	/* Update the link, but return if there was an error */
 	err = genphy_update_link(phydev);
@@ -2356,6 +2356,14 @@ int genphy_read_status(struct phy_device *phydev)
 		return err;
 
 	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
+		if (phydev->is_gigabit_capable) {
+			adv = phy_read(phydev, MII_CTRL1000);
+			if (adv < 0)
+				return adv;
+			/* update advertising in case of 'down-shift' */
+			mii_ctrl1000_mod_linkmode_adv_t(phydev->advertising,
+							adv);
+		}
 		phy_resolve_aneg_linkmode(phydev);
 	} else if (phydev->autoneg == AUTONEG_DISABLE) {
 		err = genphy_read_status_fixed(phydev);

base-commit: d549699048b4b5c22dd710455bcdb76966e55aa3
-- 
2.29.2

