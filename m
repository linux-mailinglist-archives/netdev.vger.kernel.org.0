Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11D448545D
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240726AbiAEOZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:25:31 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:29324 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240683AbiAEOZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:25:20 -0500
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JTWvr392Mzbjmd;
        Wed,  5 Jan 2022 22:24:40 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 03/15] net: hns3: create new set of common rss get APIs for PF and VF rss module
Date:   Wed, 5 Jan 2022 22:20:03 +0800
Message-ID: <20220105142015.51097-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220105142015.51097-1-huangguangbin2@huawei.com>
References: <20220105142015.51097-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

The PF and VF rss get APIs are almost the same espect the suffixes of API
names. These same impementions bring double development and bugfix work.

So this patch creates new common rss get APIs for PF and VF rss module.
Subfunctions called by rss query process are also created(e.g. rss tuple
conversion APIs).

These new common rss get APIs will be used to replace PF and VF old rss
APIs in next patches.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/Makefile  |   4 +-
 .../hns3/hns3_common/hclge_comm_rss.c         | 164 ++++++++++++++++++
 .../hns3/hns3_common/hclge_comm_rss.h         |  31 ++++
 3 files changed, 197 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c

diff --git a/drivers/net/ethernet/hisilicon/hns3/Makefile b/drivers/net/ethernet/hisilicon/hns3/Makefile
index 18f833138562..00d0a8e7f234 100644
--- a/drivers/net/ethernet/hisilicon/hns3/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/Makefile
@@ -18,11 +18,11 @@ hns3-$(CONFIG_HNS3_DCB) += hns3_dcbnl.o
 obj-$(CONFIG_HNS3_HCLGEVF) += hclgevf.o
 
 hclgevf-objs = hns3vf/hclgevf_main.o hns3vf/hclgevf_mbx.o  hns3vf/hclgevf_devlink.o \
-		hns3_common/hclge_comm_cmd.o
+		hns3_common/hclge_comm_cmd.o hns3_common/hclge_comm_rss.o
 
 obj-$(CONFIG_HNS3_HCLGE) += hclge.o
 hclge-objs = hns3pf/hclge_main.o hns3pf/hclge_mdio.o hns3pf/hclge_tm.o \
 		hns3pf/hclge_mbx.o hns3pf/hclge_err.o  hns3pf/hclge_debugfs.o hns3pf/hclge_ptp.o hns3pf/hclge_devlink.o \
-		hns3_common/hclge_comm_cmd.o
+		hns3_common/hclge_comm_cmd.o hns3_common/hclge_comm_rss.o
 
 hclge-$(CONFIG_HNS3_DCB) += hns3pf/hclge_dcb.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
new file mode 100644
index 000000000000..70bf4504d41e
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
@@ -0,0 +1,164 @@
+// SPDX-License-Identifier: GPL-2.0+
+// Copyright (c) 2021-2021 Hisilicon Limited.
+#include <linux/skbuff.h>
+
+#include "hnae3.h"
+#include "hclge_comm_rss.h"
+
+u32 hclge_comm_get_rss_key_size(struct hnae3_handle *handle)
+{
+	return HCLGE_COMM_RSS_KEY_SIZE;
+}
+
+void hclge_comm_get_rss_type(struct hnae3_handle *nic,
+			     struct hclge_comm_rss_tuple_cfg *rss_tuple_sets)
+{
+	if (rss_tuple_sets->ipv4_tcp_en ||
+	    rss_tuple_sets->ipv4_udp_en ||
+	    rss_tuple_sets->ipv4_sctp_en ||
+	    rss_tuple_sets->ipv6_tcp_en ||
+	    rss_tuple_sets->ipv6_udp_en ||
+	    rss_tuple_sets->ipv6_sctp_en)
+		nic->kinfo.rss_type = PKT_HASH_TYPE_L4;
+	else if (rss_tuple_sets->ipv4_fragment_en ||
+		 rss_tuple_sets->ipv6_fragment_en)
+		nic->kinfo.rss_type = PKT_HASH_TYPE_L3;
+	else
+		nic->kinfo.rss_type = PKT_HASH_TYPE_NONE;
+}
+
+int hclge_comm_parse_rss_hfunc(struct hclge_comm_rss_cfg *rss_cfg,
+			       const u8 hfunc, u8 *hash_algo)
+{
+	switch (hfunc) {
+	case ETH_RSS_HASH_TOP:
+		*hash_algo = HCLGE_COMM_RSS_HASH_ALGO_TOEPLITZ;
+		return 0;
+	case ETH_RSS_HASH_XOR:
+		*hash_algo = HCLGE_COMM_RSS_HASH_ALGO_SIMPLE;
+		return 0;
+	case ETH_RSS_HASH_NO_CHANGE:
+		*hash_algo = rss_cfg->rss_algo;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+void hclge_comm_rss_indir_init_cfg(struct hnae3_ae_dev *ae_dev,
+				   struct hclge_comm_rss_cfg *rss_cfg)
+{
+	u16 i;
+	/* Initialize RSS indirect table */
+	for (i = 0; i < ae_dev->dev_specs.rss_ind_tbl_size; i++)
+		rss_cfg->rss_indirection_tbl[i] = i % rss_cfg->rss_size;
+}
+
+int hclge_comm_get_rss_tuple(struct hclge_comm_rss_cfg *rss_cfg, int flow_type,
+			     u8 *tuple_sets)
+{
+	switch (flow_type) {
+	case TCP_V4_FLOW:
+		*tuple_sets = rss_cfg->rss_tuple_sets.ipv4_tcp_en;
+		break;
+	case UDP_V4_FLOW:
+		*tuple_sets = rss_cfg->rss_tuple_sets.ipv4_udp_en;
+		break;
+	case TCP_V6_FLOW:
+		*tuple_sets = rss_cfg->rss_tuple_sets.ipv6_tcp_en;
+		break;
+	case UDP_V6_FLOW:
+		*tuple_sets = rss_cfg->rss_tuple_sets.ipv6_udp_en;
+		break;
+	case SCTP_V4_FLOW:
+		*tuple_sets = rss_cfg->rss_tuple_sets.ipv4_sctp_en;
+		break;
+	case SCTP_V6_FLOW:
+		*tuple_sets = rss_cfg->rss_tuple_sets.ipv6_sctp_en;
+		break;
+	case IPV4_FLOW:
+	case IPV6_FLOW:
+		*tuple_sets = HCLGE_COMM_S_IP_BIT | HCLGE_COMM_D_IP_BIT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+void hclge_comm_get_rss_hash_info(struct hclge_comm_rss_cfg *rss_cfg, u8 *key,
+				  u8 *hfunc)
+{
+	/* Get hash algorithm */
+	if (hfunc) {
+		switch (rss_cfg->rss_algo) {
+		case HCLGE_COMM_RSS_HASH_ALGO_TOEPLITZ:
+			*hfunc = ETH_RSS_HASH_TOP;
+			break;
+		case HCLGE_COMM_RSS_HASH_ALGO_SIMPLE:
+			*hfunc = ETH_RSS_HASH_XOR;
+			break;
+		default:
+			*hfunc = ETH_RSS_HASH_UNKNOWN;
+			break;
+		}
+	}
+
+	/* Get the RSS Key required by the user */
+	if (key)
+		memcpy(key, rss_cfg->rss_hash_key, HCLGE_COMM_RSS_KEY_SIZE);
+}
+
+void hclge_comm_get_rss_indir_tbl(struct hclge_comm_rss_cfg *rss_cfg,
+				  u32 *indir, u16 rss_ind_tbl_size)
+{
+	u16 i;
+
+	if (!indir)
+		return;
+
+	for (i = 0; i < rss_ind_tbl_size; i++)
+		indir[i] = rss_cfg->rss_indirection_tbl[i];
+}
+
+u8 hclge_comm_get_rss_hash_bits(struct ethtool_rxnfc *nfc)
+{
+	u8 hash_sets = nfc->data & RXH_L4_B_0_1 ? HCLGE_COMM_S_PORT_BIT : 0;
+
+	if (nfc->data & RXH_L4_B_2_3)
+		hash_sets |= HCLGE_COMM_D_PORT_BIT;
+	else
+		hash_sets &= ~HCLGE_COMM_D_PORT_BIT;
+
+	if (nfc->data & RXH_IP_SRC)
+		hash_sets |= HCLGE_COMM_S_IP_BIT;
+	else
+		hash_sets &= ~HCLGE_COMM_S_IP_BIT;
+
+	if (nfc->data & RXH_IP_DST)
+		hash_sets |= HCLGE_COMM_D_IP_BIT;
+	else
+		hash_sets &= ~HCLGE_COMM_D_IP_BIT;
+
+	if (nfc->flow_type == SCTP_V4_FLOW || nfc->flow_type == SCTP_V6_FLOW)
+		hash_sets |= HCLGE_COMM_V_TAG_BIT;
+
+	return hash_sets;
+}
+
+u64 hclge_comm_convert_rss_tuple(u8 tuple_sets)
+{
+	u64 tuple_data = 0;
+
+	if (tuple_sets & HCLGE_COMM_D_PORT_BIT)
+		tuple_data |= RXH_L4_B_2_3;
+	if (tuple_sets & HCLGE_COMM_S_PORT_BIT)
+		tuple_data |= RXH_L4_B_0_1;
+	if (tuple_sets & HCLGE_COMM_D_IP_BIT)
+		tuple_data |= RXH_IP_DST;
+	if (tuple_sets & HCLGE_COMM_S_IP_BIT)
+		tuple_data |= RXH_IP_SRC;
+
+	return tuple_data;
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
index 74bd30b2fcc9..66f9efa853ca 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
@@ -7,6 +7,21 @@
 
 #include "hnae3.h"
 
+#define HCLGE_COMM_RSS_HASH_ALGO_TOEPLITZ	0
+#define HCLGE_COMM_RSS_HASH_ALGO_SIMPLE		1
+#define HCLGE_COMM_RSS_HASH_ALGO_SYMMETRIC	2
+
+#define HCLGE_COMM_RSS_INPUT_TUPLE_OTHER	GENMASK(3, 0)
+#define HCLGE_COMM_RSS_INPUT_TUPLE_SCTP		GENMASK(4, 0)
+
+#define HCLGE_COMM_D_PORT_BIT		BIT(0)
+#define HCLGE_COMM_S_PORT_BIT		BIT(1)
+#define HCLGE_COMM_D_IP_BIT		BIT(2)
+#define HCLGE_COMM_S_IP_BIT		BIT(3)
+#define HCLGE_COMM_V_TAG_BIT		BIT(4)
+#define HCLGE_COMM_RSS_INPUT_TUPLE_SCTP_NO_PORT	\
+	(HCLGE_COMM_D_IP_BIT | HCLGE_COMM_S_IP_BIT | HCLGE_COMM_V_TAG_BIT)
+
 struct hclge_comm_rss_tuple_cfg {
 	u8 ipv4_tcp_en;
 	u8 ipv4_udp_en;
@@ -31,4 +46,20 @@ struct hclge_comm_rss_cfg {
 	u32 rss_size;
 };
 
+u32 hclge_comm_get_rss_key_size(struct hnae3_handle *handle);
+void hclge_comm_get_rss_type(struct hnae3_handle *nic,
+			     struct hclge_comm_rss_tuple_cfg *rss_tuple_sets);
+void hclge_comm_rss_indir_init_cfg(struct hnae3_ae_dev *ae_dev,
+				   struct hclge_comm_rss_cfg *rss_cfg);
+int hclge_comm_get_rss_tuple(struct hclge_comm_rss_cfg *rss_cfg, int flow_type,
+			     u8 *tuple_sets);
+int hclge_comm_parse_rss_hfunc(struct hclge_comm_rss_cfg *rss_cfg,
+			       const u8 hfunc, u8 *hash_algo);
+void hclge_comm_get_rss_hash_info(struct hclge_comm_rss_cfg *rss_cfg, u8 *key,
+				  u8 *hfunc);
+void hclge_comm_get_rss_indir_tbl(struct hclge_comm_rss_cfg *rss_cfg,
+				  u32 *indir, u16 rss_ind_tbl_size);
+u8 hclge_comm_get_rss_hash_bits(struct ethtool_rxnfc *nfc);
+u64 hclge_comm_convert_rss_tuple(u8 tuple_sets);
+
 #endif
-- 
2.33.0

