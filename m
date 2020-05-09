Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DFB1CBE2B
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 08:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgEIGsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 02:48:36 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23336 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725940AbgEIGsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 02:48:36 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0496kpBW000890;
        Fri, 8 May 2020 23:48:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=hJtSi1wIwqUW8oZs17PumpPFLyPSBRASrQRGWkhvFrI=;
 b=WVI7jFv3LGzwjJiEug6wokZm4OqpxnjvmmNRLTsPAQJVScZcy1aJrlLHqYrID7JT3YfJ
 Vei17PzIrGh38A+1kwpPzpdxbwPrJgFk/tx7528neOid6+BzmgMOtgkmpXT8ywmXtgO9
 S/VuWue8WZVAMOcgyIELlA9tZUpENzWP1qGuqKbuCHTIgiLEr/fPuy0MQQu27FBPo55M
 MbihT3gTvbLjYbWd4SxkYtQGPz05TTlrQFgMyl8a2gJjbMIQNRKAo5wFi32MueGXaU+M
 fTlBfN4ToBt3wEvCcBzQSYVhLoP99wMq+Sq9Nl83Y/xdjQxpcKlPIvGNekr95p3EWdPM nw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30wjj7gvdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 23:48:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 23:48:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 23:48:32 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 895073F703F;
        Fri,  8 May 2020 23:48:18 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 7/7] net: atlantic: unify MAC generation
Date:   Sat, 9 May 2020 09:47:00 +0300
Message-ID: <20200509064700.202-8-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200509064700.202-1-irusskikh@marvell.com>
References: <20200509064700.202-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_02:2020-05-08,2020-05-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch unifies invalid MAC address handling with other drivers.

Basically we've switched to using standard APIs (is_valid_ether_addr /
eth_hw_addr_random) where possible.
It's worth noting that some of engineering Aquantia NICs might be
provisioned with a partially zeroed out MAC, which is still invalid,
but not caught by is_valid_ether_addr(), so we've added a special
handling for this case.

Also adding a warning in case of fallback to random MAC, because
this shouldn't be needed on production NICs, they should all be
provisioned with unique MAC.

NB! Default systemd/udevd configuration is 'MACAddressPolicy=persistent'.
    This causes MAC address to be persisted across driver reloads and
    reboots. We had to change it to 'none' for verification purposes.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 14 +++++++++++
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 22 ------------------
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 23 +------------------
 3 files changed, 15 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 18cad06f2ea7..1c6d12deb47a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -272,6 +272,14 @@ static int aq_nic_hw_prepare(struct aq_nic_s *self)
 	return err;
 }
 
+static bool aq_nic_is_valid_ether_addr(const u8 *addr)
+{
+	/* Some engineering samples of Aquantia NICs are provisioned with a
+	 * partially populated MAC, which is still invalid.
+	 */
+	return !(addr[0] == 0 && addr[1] == 0 && addr[2] == 0);
+}
+
 int aq_nic_ndev_register(struct aq_nic_s *self)
 {
 	int err = 0;
@@ -296,6 +304,12 @@ int aq_nic_ndev_register(struct aq_nic_s *self)
 	if (err)
 		goto err_exit;
 
+	if (!is_valid_ether_addr(self->ndev->dev_addr) ||
+	    !aq_nic_is_valid_ether_addr(self->ndev->dev_addr)) {
+		netdev_warn(self->ndev, "MAC is invalid, will use random.");
+		eth_hw_addr_random(self->ndev);
+	}
+
 #if defined(AQ_CFG_MAC_ADDR_PERMANENT)
 	{
 		static u8 mac_addr_permanent[] = AQ_CFG_MAC_ADDR_PERMANENT;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index 017364486703..eeedd8c90067 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -283,8 +283,6 @@ static int aq_fw2x_get_mac_permanent(struct aq_hw_s *self, u8 *mac)
 	u32 efuse_addr = aq_hw_read_reg(self, HW_ATL_FW2X_MPI_EFUSE_ADDR);
 	u32 mac_addr[2] = { 0 };
 	int err = 0;
-	u32 h = 0U;
-	u32 l = 0U;
 
 	if (efuse_addr != 0) {
 		err = hw_atl_utils_fw_downld_dwords(self,
@@ -299,26 +297,6 @@ static int aq_fw2x_get_mac_permanent(struct aq_hw_s *self, u8 *mac)
 
 	ether_addr_copy(mac, (u8 *)mac_addr);
 
-	if ((mac[0] & 0x01U) || ((mac[0] | mac[1] | mac[2]) == 0x00U)) {
-		unsigned int rnd = 0;
-
-		get_random_bytes(&rnd, sizeof(unsigned int));
-
-		l = 0xE3000000U | (0xFFFFU & rnd) | (0x00 << 16);
-		h = 0x8001300EU;
-
-		mac[5] = (u8)(0xFFU & l);
-		l >>= 8;
-		mac[4] = (u8)(0xFFU & l);
-		l >>= 8;
-		mac[3] = (u8)(0xFFU & l);
-		l >>= 8;
-		mac[2] = (u8)(0xFFU & l);
-		mac[1] = (u8)(0xFFU & h);
-		h >>= 8;
-		mac[0] = (u8)(0xFFU & h);
-	}
-
 	return err;
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index e8f4aad8c1e5..0ffc33bd67d0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -6,6 +6,7 @@
 #include <linux/iopoll.h>
 
 #include "aq_hw.h"
+#include "aq_hw_utils.h"
 #include "hw_atl/hw_atl_llh.h"
 #include "hw_atl2_utils.h"
 #include "hw_atl2_llh.h"
@@ -212,28 +213,6 @@ static int aq_a2_fw_get_mac_permanent(struct aq_hw_s *self, u8 *mac)
 	hw_atl2_shared_buffer_get(self, mac_address, mac_address);
 	ether_addr_copy(mac, (u8 *)mac_address.aligned.mac_address);
 
-	if ((mac[0] & 0x01U) || ((mac[0] | mac[1] | mac[2]) == 0x00U)) {
-		unsigned int rnd = 0;
-		u32 h;
-		u32 l;
-
-		get_random_bytes(&rnd, sizeof(unsigned int));
-
-		l = 0xE3000000U | (0xFFFFU & rnd) | (0x00 << 16);
-		h = 0x8001300EU;
-
-		mac[5] = (u8)(0xFFU & l);
-		l >>= 8;
-		mac[4] = (u8)(0xFFU & l);
-		l >>= 8;
-		mac[3] = (u8)(0xFFU & l);
-		l >>= 8;
-		mac[2] = (u8)(0xFFU & l);
-		mac[1] = (u8)(0xFFU & h);
-		h >>= 8;
-		mac[0] = (u8)(0xFFU & h);
-	}
-
 	return 0;
 }
 
-- 
2.20.1

