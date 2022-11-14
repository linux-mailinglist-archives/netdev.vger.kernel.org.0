Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5095C62775A
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbiKNIUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236302AbiKNIUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:20:46 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24846BC0E
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 00:20:45 -0800 (PST)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N9j145y9Bz15Lwl;
        Mon, 14 Nov 2022 16:20:24 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 16:20:43 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 16:20:43 +0800
From:   Hao Lan <lanhao@huawei.com>
To:     <lanhao@huawei.com>, <lipeng321@huawei.com>,
        <shenjian15@huawei.com>, <linyunsheng@huawei.com>,
        <liuyonglong@huawei.com>, <chenhao418@huawei.com>,
        <wangjie125@huawei.com>, <huangguangbin2@huawei.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <xiaojiantao1@h-partners.com>, <dvyukov@google.com>
Subject: [PATCH V2 net 1/3] net: hns3: fix incorrect hw rss hash type of rx packet
Date:   Mon, 14 Nov 2022 16:20:46 +0800
Message-ID: <20221114082048.49450-2-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20221114082048.49450-1-lanhao@huawei.com>
References: <20221114082048.49450-1-lanhao@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, the HNS3 driver reports the rss hash type
of each packet based on the rss hash tuples set. It
always reports PKT_HASH_TYPE_L4, without checking the
type of current packet. It's incorrect.
Fixes it by reporting it base on the packet type.

Fixes: 796640778c26 ("net: hns3: support RXD advanced layout")
Fixes: 232fc64b6e62 ("net: hns3: Add HW RSS hash information to RX skb")
Fixes: ea4858670717 ("net: hns3: handle the BD info on the last BD of the packet")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   1 -
 .../hns3/hns3_common/hclge_comm_rss.c         |  20 ---
 .../hns3/hns3_common/hclge_comm_rss.h         |   2 -
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 163 ++++++++++--------
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |   1 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        |   1 -
 6 files changed, 94 insertions(+), 94 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 0179fc288f5f..17137de9338c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -819,7 +819,6 @@ struct hnae3_knic_private_info {
 	const struct hnae3_dcb_ops *dcb_ops;
 
 	u16 int_rl_setting;
-	enum pkt_hash_types rss_type;
 	void __iomem *io_base;
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
index e23729ac3bb8..ae2736549526 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
@@ -191,23 +191,6 @@ u32 hclge_comm_get_rss_key_size(struct hnae3_handle *handle)
 	return HCLGE_COMM_RSS_KEY_SIZE;
 }
 
-void hclge_comm_get_rss_type(struct hnae3_handle *nic,
-			     struct hclge_comm_rss_tuple_cfg *rss_tuple_sets)
-{
-	if (rss_tuple_sets->ipv4_tcp_en ||
-	    rss_tuple_sets->ipv4_udp_en ||
-	    rss_tuple_sets->ipv4_sctp_en ||
-	    rss_tuple_sets->ipv6_tcp_en ||
-	    rss_tuple_sets->ipv6_udp_en ||
-	    rss_tuple_sets->ipv6_sctp_en)
-		nic->kinfo.rss_type = PKT_HASH_TYPE_L4;
-	else if (rss_tuple_sets->ipv4_fragment_en ||
-		 rss_tuple_sets->ipv6_fragment_en)
-		nic->kinfo.rss_type = PKT_HASH_TYPE_L3;
-	else
-		nic->kinfo.rss_type = PKT_HASH_TYPE_NONE;
-}
-
 int hclge_comm_parse_rss_hfunc(struct hclge_comm_rss_cfg *rss_cfg,
 			       const u8 hfunc, u8 *hash_algo)
 {
@@ -344,9 +327,6 @@ int hclge_comm_set_rss_input_tuple(struct hnae3_handle *nic,
 	req->ipv6_sctp_en = rss_cfg->rss_tuple_sets.ipv6_sctp_en;
 	req->ipv6_fragment_en = rss_cfg->rss_tuple_sets.ipv6_fragment_en;
 
-	if (is_pf)
-		hclge_comm_get_rss_type(nic, &rss_cfg->rss_tuple_sets);
-
 	ret = hclge_comm_cmd_send(hw, &desc, 1);
 	if (ret)
 		dev_err(&hw->cmq.csq.pdev->dev,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
index 946d166a452d..92af3d2980d3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
@@ -95,8 +95,6 @@ struct hclge_comm_rss_tc_mode_cmd {
 };
 
 u32 hclge_comm_get_rss_key_size(struct hnae3_handle *handle);
-void hclge_comm_get_rss_type(struct hnae3_handle *nic,
-			     struct hclge_comm_rss_tuple_cfg *rss_tuple_sets);
 void hclge_comm_rss_indir_init_cfg(struct hnae3_ae_dev *ae_dev,
 				   struct hclge_comm_rss_cfg *rss_cfg);
 int hclge_comm_get_rss_tuple(struct hclge_comm_rss_cfg *rss_cfg, int flow_type,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 4cb2421e71a7..7fc83409f257 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -105,26 +105,28 @@ static const struct pci_device_id hns3_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, hns3_pci_tbl);
 
-#define HNS3_RX_PTYPE_ENTRY(ptype, l, s, t) \
+#define HNS3_RX_PTYPE_ENTRY(ptype, l, s, t, h) \
 	{	ptype, \
 		l, \
 		CHECKSUM_##s, \
 		HNS3_L3_TYPE_##t, \
-		1 }
+		1, \
+		h}
 
 #define HNS3_RX_PTYPE_UNUSED_ENTRY(ptype) \
-		{ ptype, 0, CHECKSUM_NONE, HNS3_L3_TYPE_PARSE_FAIL, 0 }
+		{ ptype, 0, CHECKSUM_NONE, HNS3_L3_TYPE_PARSE_FAIL, 0, \
+		  PKT_HASH_TYPE_NONE }
 
 static const struct hns3_rx_ptype hns3_rx_ptype_tbl[] = {
 	HNS3_RX_PTYPE_UNUSED_ENTRY(0),
-	HNS3_RX_PTYPE_ENTRY(1, 0, COMPLETE, ARP),
-	HNS3_RX_PTYPE_ENTRY(2, 0, COMPLETE, RARP),
-	HNS3_RX_PTYPE_ENTRY(3, 0, COMPLETE, LLDP),
-	HNS3_RX_PTYPE_ENTRY(4, 0, COMPLETE, PARSE_FAIL),
-	HNS3_RX_PTYPE_ENTRY(5, 0, COMPLETE, PARSE_FAIL),
-	HNS3_RX_PTYPE_ENTRY(6, 0, COMPLETE, PARSE_FAIL),
-	HNS3_RX_PTYPE_ENTRY(7, 0, COMPLETE, CNM),
-	HNS3_RX_PTYPE_ENTRY(8, 0, NONE, PARSE_FAIL),
+	HNS3_RX_PTYPE_ENTRY(1, 0, COMPLETE, ARP, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(2, 0, COMPLETE, RARP, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(3, 0, COMPLETE, LLDP, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(4, 0, COMPLETE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(5, 0, COMPLETE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(6, 0, COMPLETE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(7, 0, COMPLETE, CNM, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(8, 0, NONE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(9),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(10),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(11),
@@ -132,36 +134,36 @@ static const struct hns3_rx_ptype hns3_rx_ptype_tbl[] = {
 	HNS3_RX_PTYPE_UNUSED_ENTRY(13),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(14),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(15),
-	HNS3_RX_PTYPE_ENTRY(16, 0, COMPLETE, PARSE_FAIL),
-	HNS3_RX_PTYPE_ENTRY(17, 0, COMPLETE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(18, 0, COMPLETE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(19, 0, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(20, 0, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(21, 0, NONE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(22, 0, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(23, 0, NONE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(24, 0, NONE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(25, 0, UNNECESSARY, IPV4),
+	HNS3_RX_PTYPE_ENTRY(16, 0, COMPLETE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(17, 0, COMPLETE, IPV4, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(18, 0, COMPLETE, IPV4, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(19, 0, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(20, 0, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(21, 0, NONE, IPV4, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(22, 0, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(23, 0, NONE, IPV4, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(24, 0, NONE, IPV4, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(25, 0, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(26),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(27),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(28),
-	HNS3_RX_PTYPE_ENTRY(29, 0, COMPLETE, PARSE_FAIL),
-	HNS3_RX_PTYPE_ENTRY(30, 0, COMPLETE, PARSE_FAIL),
-	HNS3_RX_PTYPE_ENTRY(31, 0, COMPLETE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(32, 0, COMPLETE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(33, 1, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(34, 1, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(35, 1, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(36, 0, COMPLETE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(37, 0, COMPLETE, IPV4),
+	HNS3_RX_PTYPE_ENTRY(29, 0, COMPLETE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(30, 0, COMPLETE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(31, 0, COMPLETE, IPV4, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(32, 0, COMPLETE, IPV4, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(33, 1, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(34, 1, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(35, 1, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(36, 0, COMPLETE, IPV4, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(37, 0, COMPLETE, IPV4, PKT_HASH_TYPE_L3),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(38),
-	HNS3_RX_PTYPE_ENTRY(39, 0, COMPLETE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(40, 0, COMPLETE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(41, 1, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(42, 1, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(43, 1, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(44, 0, COMPLETE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(45, 0, COMPLETE, IPV6),
+	HNS3_RX_PTYPE_ENTRY(39, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(40, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(41, 1, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(42, 1, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(43, 1, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(44, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(45, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(46),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(47),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(48),
@@ -227,35 +229,35 @@ static const struct hns3_rx_ptype hns3_rx_ptype_tbl[] = {
 	HNS3_RX_PTYPE_UNUSED_ENTRY(108),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(109),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(110),
-	HNS3_RX_PTYPE_ENTRY(111, 0, COMPLETE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(112, 0, COMPLETE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(113, 0, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(114, 0, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(115, 0, NONE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(116, 0, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(117, 0, NONE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(118, 0, NONE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(119, 0, UNNECESSARY, IPV6),
+	HNS3_RX_PTYPE_ENTRY(111, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(112, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(113, 0, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(114, 0, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(115, 0, NONE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(116, 0, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(117, 0, NONE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(118, 0, NONE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(119, 0, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(120),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(121),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(122),
-	HNS3_RX_PTYPE_ENTRY(123, 0, COMPLETE, PARSE_FAIL),
-	HNS3_RX_PTYPE_ENTRY(124, 0, COMPLETE, PARSE_FAIL),
-	HNS3_RX_PTYPE_ENTRY(125, 0, COMPLETE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(126, 0, COMPLETE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(127, 1, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(128, 1, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(129, 1, UNNECESSARY, IPV4),
-	HNS3_RX_PTYPE_ENTRY(130, 0, COMPLETE, IPV4),
-	HNS3_RX_PTYPE_ENTRY(131, 0, COMPLETE, IPV4),
+	HNS3_RX_PTYPE_ENTRY(123, 0, COMPLETE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(124, 0, COMPLETE, PARSE_FAIL, PKT_HASH_TYPE_NONE),
+	HNS3_RX_PTYPE_ENTRY(125, 0, COMPLETE, IPV4, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(126, 0, COMPLETE, IPV4, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(127, 1, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(128, 1, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(129, 1, UNNECESSARY, IPV4, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(130, 0, COMPLETE, IPV4, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(131, 0, COMPLETE, IPV4, PKT_HASH_TYPE_L3),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(132),
-	HNS3_RX_PTYPE_ENTRY(133, 0, COMPLETE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(134, 0, COMPLETE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(135, 1, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(136, 1, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(137, 1, UNNECESSARY, IPV6),
-	HNS3_RX_PTYPE_ENTRY(138, 0, COMPLETE, IPV6),
-	HNS3_RX_PTYPE_ENTRY(139, 0, COMPLETE, IPV6),
+	HNS3_RX_PTYPE_ENTRY(133, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(134, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(135, 1, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(136, 1, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(137, 1, UNNECESSARY, IPV6, PKT_HASH_TYPE_L4),
+	HNS3_RX_PTYPE_ENTRY(138, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
+	HNS3_RX_PTYPE_ENTRY(139, 0, COMPLETE, IPV6, PKT_HASH_TYPE_L3),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(140),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(141),
 	HNS3_RX_PTYPE_UNUSED_ENTRY(142),
@@ -4171,15 +4173,35 @@ static int hns3_set_gro_and_checksum(struct hns3_enet_ring *ring,
 }
 
 static void hns3_set_rx_skb_rss_type(struct hns3_enet_ring *ring,
-				     struct sk_buff *skb, u32 rss_hash)
+				     struct sk_buff *skb, u32 rss_hash,
+				     u32 l234info, u32 ol_info)
 {
-	struct hnae3_handle *handle = ring->tqp->handle;
-	enum pkt_hash_types rss_type;
+	enum pkt_hash_types rss_type = PKT_HASH_TYPE_NONE;
+	struct net_device *netdev = ring_to_netdev(ring);
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
 
-	if (rss_hash)
-		rss_type = handle->kinfo.rss_type;
-	else
-		rss_type = PKT_HASH_TYPE_NONE;
+	if (test_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state)) {
+		u32 ptype = hnae3_get_field(ol_info, HNS3_RXD_PTYPE_M,
+					    HNS3_RXD_PTYPE_S);
+
+		rss_type = hns3_rx_ptype_tbl[ptype].hash_type;
+	} else {
+		int l3_type = hnae3_get_field(l234info, HNS3_RXD_L3ID_M,
+					      HNS3_RXD_L3ID_S);
+		int l4_type = hnae3_get_field(l234info, HNS3_RXD_L4ID_M,
+					      HNS3_RXD_L4ID_S);
+
+		if (l3_type == HNS3_L3_TYPE_IPV4 ||
+		    l3_type == HNS3_L3_TYPE_IPV6) {
+			if (l4_type == HNS3_L4_TYPE_UDP ||
+			    l4_type == HNS3_L4_TYPE_TCP ||
+			    l4_type == HNS3_L4_TYPE_SCTP)
+				rss_type = PKT_HASH_TYPE_L4;
+			else if (l4_type == HNS3_L4_TYPE_IGMP ||
+				 l4_type == HNS3_L4_TYPE_ICMP)
+				rss_type = PKT_HASH_TYPE_L3;
+		}
+	}
 
 	skb_set_hash(skb, rss_hash, rss_type);
 }
@@ -4282,7 +4304,8 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 
 	ring->tqp_vector->rx_group.total_bytes += len;
 
-	hns3_set_rx_skb_rss_type(ring, skb, le32_to_cpu(desc->rx.rss_hash));
+	hns3_set_rx_skb_rss_type(ring, skb, le32_to_cpu(desc->rx.rss_hash),
+				 l234info, ol_info);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 133a054af6b7..294a14b4fdef 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -404,6 +404,7 @@ struct hns3_rx_ptype {
 	u32 ip_summed : 2;
 	u32 l3_type : 4;
 	u32 valid : 1;
+	u32 hash_type: 3;
 };
 
 struct ring_stats {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 987271da6e9b..e34ac9c5900e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4859,7 +4859,6 @@ static int hclge_set_rss_tuple(struct hnae3_handle *handle,
 		return ret;
 	}
 
-	hclge_comm_get_rss_type(&vport->nic, &hdev->rss_cfg.rss_tuple_sets);
 	return 0;
 }
 
-- 
2.30.0

