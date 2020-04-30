Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEBD1BF201
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgD3IFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:05:15 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16216 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726474AbgD3IFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 04:05:13 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U852sh011030;
        Thu, 30 Apr 2020 01:05:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=BVvz00AL6OQDQeTQQVAnimvU1wvbVOJzQXrpONy9Ipo=;
 b=JI663gqqPsiWRU+rsc1Hzv/BIKV7LEsWag3Gr0917jrdMD8Ltcm7RzR3BSMpK9eitwB2
 RUgWiGFAye8rUHizx82ZQf0TB8MIAJWGxGDTqku0mZdXCp3TU6wmIB90od5wPkohM52w
 dYLU1GucPnNgaUy3UWtCQpIxBpxAXX09ZMiBJ9nTZuJOLWrdVbMEBkiyh7f2r6yiO0+x
 rVkShZbE4dn+YMy3FOpYx2k6NmI6jIHbtDPJE5ek2HzPQDRkryw9flYoJ4hgkyObqDMw
 VqtBCzXfW9fNTWaWQgkVFyj+sSw6PXc3D3BVHZF6LjJmKa8SwzGRqIkvnsWoPktMMRY8 3w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 30mjjqnsk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 01:05:12 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Apr
 2020 01:05:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Apr 2020 01:05:11 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 6CD793F703F;
        Thu, 30 Apr 2020 01:05:09 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bezrukov <dbezrukov@marvell.com>
Subject: [PATCH v2 net-next 04/17] net: atlantic: add hw_soft_reset, hw_prepare to hw_ops
Date:   Thu, 30 Apr 2020 11:04:32 +0300
Message-ID: <20200430080445.1142-5-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430080445.1142-1-irusskikh@marvell.com>
References: <20200430080445.1142-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_02:2020-04-30,2020-04-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

A2 will have a different implementation of these 2 APIs, so
this patch moves them to hw_ops in preparation for A2.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Co-developed-by: Dmitry Bezrukov <dbezrukov@marvell.com>
Signed-off-by: Dmitry Bezrukov <dbezrukov@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h   |  5 +++++
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c  | 16 +++++++++++++++-
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c         |  2 ++
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c         |  2 ++
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c      |  4 ----
 5 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index 7d71bc7dc500..84abce29d590 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -182,6 +182,11 @@ struct aq_hw_ops {
 
 	int (*hw_set_mac_address)(struct aq_hw_s *self, u8 *mac_addr);
 
+	int (*hw_soft_reset)(struct aq_hw_s *self);
+
+	int (*hw_prepare)(struct aq_hw_s *self,
+			  const struct aq_fw_ops **fw_ops);
+
 	int (*hw_reset)(struct aq_hw_s *self);
 
 	int (*hw_init)(struct aq_hw_s *self, u8 *mac_addr);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 80dd744dcbd1..7f4d8abab951 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -257,6 +257,20 @@ static void aq_nic_polling_timer_cb(struct timer_list *t)
 		  AQ_CFG_POLLING_TIMER_INTERVAL);
 }
 
+static int aq_nic_hw_prepare(struct aq_nic_s *self)
+{
+	int err = 0;
+
+	err = self->aq_hw_ops->hw_soft_reset(self->aq_hw);
+	if (err)
+		goto exit;
+
+	err = self->aq_hw_ops->hw_prepare(self->aq_hw, &self->aq_fw_ops);
+
+exit:
+	return err;
+}
+
 int aq_nic_ndev_register(struct aq_nic_s *self)
 {
 	int err = 0;
@@ -266,7 +280,7 @@ int aq_nic_ndev_register(struct aq_nic_s *self)
 		goto err_exit;
 	}
 
-	err = hw_atl_utils_initfw(self->aq_hw, &self->aq_fw_ops);
+	err = aq_nic_hw_prepare(self);
 	if (err)
 		goto err_exit;
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index 9b1062b8af64..2dba8c277ecb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -886,6 +886,8 @@ static int hw_atl_a0_hw_ring_rx_stop(struct aq_hw_s *self,
 }
 
 const struct aq_hw_ops hw_atl_ops_a0 = {
+	.hw_soft_reset        = hw_atl_utils_soft_reset,
+	.hw_prepare           = hw_atl_utils_initfw,
 	.hw_set_mac_address   = hw_atl_a0_hw_mac_addr_set,
 	.hw_init              = hw_atl_a0_hw_init,
 	.hw_reset             = hw_atl_a0_hw_reset,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index d20d91cdece8..4e2e4eef028d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1478,6 +1478,8 @@ static int hw_atl_b0_set_loopback(struct aq_hw_s *self, u32 mode, bool enable)
 }
 
 const struct aq_hw_ops hw_atl_ops_b0 = {
+	.hw_soft_reset        = hw_atl_utils_soft_reset,
+	.hw_prepare           = hw_atl_utils_initfw,
 	.hw_set_mac_address   = hw_atl_b0_hw_mac_addr_set,
 	.hw_init              = hw_atl_b0_hw_init,
 	.hw_reset             = hw_atl_b0_hw_reset,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 354705f9bc49..7259bcb81e9b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -67,10 +67,6 @@ int hw_atl_utils_initfw(struct aq_hw_s *self, const struct aq_fw_ops **fw_ops)
 {
 	int err = 0;
 
-	err = hw_atl_utils_soft_reset(self);
-	if (err)
-		return err;
-
 	hw_atl_utils_hw_chip_features_init(self,
 					   &self->chip_features);
 
-- 
2.20.1

