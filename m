Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3B9380279
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 05:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhEND0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 23:26:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3674 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhEND0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 23:26:49 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FhDPB1S1qz1BMPb;
        Fri, 14 May 2021 11:22:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 14 May 2021 11:25:26 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 01/12] net: hns3: support RXD advanced layout
Date:   Fri, 14 May 2021 11:25:09 +0800
Message-ID: <1620962720-62216-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620962720-62216-1-git-send-email-tanhuazhong@huawei.com>
References: <1620962720-62216-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the driver gets packet type by parsing the
L3_ID/L4_ID/OL3_ID/OL4_ID from RX descriptor, it's
time-consuming.

Now some new devices support RXD advanced layout, which combines
previous OL3_ID/OL4_ID to 8bit ptype field, so the driver gets
packet type by looking up only one table, and L3_ID/L4_ID become
reserved fields.

Considering compatibility, the firmware will report capability of
RXD advanced layout, the driver will identify and enable it by
default. This patch provides basic function: identify and enable
the RXD advanced layout, and refactor out hns3_rx_checksum() by
using ptype table to handle RX checksum if supported.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   3 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 358 +++++++++++++++++++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  12 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  17 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |   2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |   1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  17 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 +
 12 files changed, 393 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 1d21890..1d265c3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -91,6 +91,7 @@ enum HNAE3_DEV_CAP_BITS {
 	HNAE3_DEV_SUPPORT_STASH_B,
 	HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B,
 	HNAE3_DEV_SUPPORT_PAUSE_B,
+	HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B,
 };
 
 #define hnae3_dev_fd_supported(hdev) \
@@ -141,6 +142,9 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_tqp_txrx_indep_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B, (ae_dev)->caps)
 
+#define hnae3_ae_dev_rxd_adv_layout_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B, (ae_dev)->caps)
+
 #define ring_ptr_move_fw(ring, p) \
 	((ring)->p = ((ring)->p + 1) % (ring)->desc_num)
 #define ring_ptr_move_bw(ring, p) \
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 9d702bd..e58a2c1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -367,6 +367,9 @@ static void hns3_dbg_dev_caps(struct hnae3_handle *h)
 		 "yes" : "no");
 	dev_info(&h->pdev->dev, "support imp-controlled PHY: %s\n",
 		 test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, caps) ? "yes" : "no");
+	dev_info(&h->pdev->dev, "support rxd advanced layout: %s\n",
+		 test_bit(HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B, caps) ?
+		 "yes" : "no");
 }
 
 static void hns3_dbg_dev_specs(struct hnae3_handle *h)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 783fdaf..712a6db 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -91,6 +91,278 @@ static const struct pci_device_id hns3_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, hns3_pci_tbl);
 
+#define HNS3_RX_PTYPE_ENTRY(ptype, l, s, t) \
+	{	ptype, \
+		l, \
+		CHECKSUM_##s, \
+		HNS3_L3_TYPE_##t, \
+		1 }
+
+#define HNS3_RX_PTYPE_UNUSED_ENTRY(ptype) \
+		{ ptype, 0, CHECKSUM_NONE, HNS3_L3_TYPE_PARSE_FAIL, 0 }
+
+static const struct hns3_rx_ptype hns3_rx_ptype_tbl[] = {
+	HNS3_RX_PTYPE_UNUSED_ENTRY(0),
+	HNS3_RX_PTYPE_ENTRY(1, 0, COMPLETE, ARP),
+	HNS3_RX_PTYPE_ENTRY(2, 0, COMPLETE, RARP),
+	HNS3_RX_PTYPE_ENTRY(3, 0, COMPLETE, LLDP),
+	HNS3_RX_PTYPE_ENTRY(4, 0, COMPLETE, PARSE_FAIL),
+	HNS3_RX_PTYPE_ENTRY(5, 0, COMPLETE, PARSE_FAIL),
+	HNS3_RX_PTYPE_ENTRY(6, 0, COMPLETE, PARSE_FAIL),
+	HNS3_RX_PTYPE_ENTRY(7, 0, COMPLETE, CNM),
+	HNS3_RX_PTYPE_ENTRY(8, 0, NONE, PARSE_FAIL),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(9),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(10),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(11),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(12),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(13),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(14),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(15),
+	HNS3_RX_PTYPE_ENTRY(16, 0, COMPLETE, PARSE_FAIL),
+	HNS3_RX_PTYPE_ENTRY(17, 0, COMPLETE, IPV4),
+	HNS3_RX_PTYPE_ENTRY(18, 0, COMPLETE, IPV4),
+	HNS3_RX_PTYPE_ENTRY(19, 0, UNNECESSARY, IPV4),
+	HNS3_RX_PTYPE_ENTRY(20, 0, UNNECESSARY, IPV4),
+	HNS3_RX_PTYPE_ENTRY(21, 0, NONE, IPV4),
+	HNS3_RX_PTYPE_ENTRY(22, 0, UNNECESSARY, IPV4),
+	HNS3_RX_PTYPE_ENTRY(23, 0, NONE, IPV4),
+	HNS3_RX_PTYPE_ENTRY(24, 0, NONE, IPV4),
+	HNS3_RX_PTYPE_ENTRY(25, 0, UNNECESSARY, IPV4),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(26),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(27),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(28),
+	HNS3_RX_PTYPE_ENTRY(29, 0, COMPLETE, PARSE_FAIL),
+	HNS3_RX_PTYPE_ENTRY(30, 0, COMPLETE, PARSE_FAIL),
+	HNS3_RX_PTYPE_ENTRY(31, 0, COMPLETE, IPV4),
+	HNS3_RX_PTYPE_ENTRY(32, 0, COMPLETE, IPV4),
+	HNS3_RX_PTYPE_ENTRY(33, 1, UNNECESSARY, IPV4),
+	HNS3_RX_PTYPE_ENTRY(34, 1, UNNECESSARY, IPV4),
+	HNS3_RX_PTYPE_ENTRY(35, 1, UNNECESSARY, IPV4),
+	HNS3_RX_PTYPE_ENTRY(36, 0, COMPLETE, IPV4),
+	HNS3_RX_PTYPE_ENTRY(37, 0, COMPLETE, IPV4),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(38),
+	HNS3_RX_PTYPE_ENTRY(39, 0, COMPLETE, IPV6),
+	HNS3_RX_PTYPE_ENTRY(40, 0, COMPLETE, IPV6),
+	HNS3_RX_PTYPE_ENTRY(41, 1, UNNECESSARY, IPV6),
+	HNS3_RX_PTYPE_ENTRY(42, 1, UNNECESSARY, IPV6),
+	HNS3_RX_PTYPE_ENTRY(43, 1, UNNECESSARY, IPV6),
+	HNS3_RX_PTYPE_ENTRY(44, 0, COMPLETE, IPV6),
+	HNS3_RX_PTYPE_ENTRY(45, 0, COMPLETE, IPV6),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(46),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(47),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(48),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(49),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(50),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(51),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(52),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(53),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(54),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(55),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(56),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(57),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(58),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(59),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(60),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(61),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(62),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(63),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(64),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(65),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(66),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(67),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(68),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(69),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(70),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(71),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(72),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(73),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(74),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(75),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(76),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(77),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(78),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(79),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(80),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(81),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(82),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(83),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(84),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(85),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(86),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(87),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(88),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(89),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(90),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(91),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(92),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(93),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(94),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(95),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(96),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(97),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(98),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(99),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(100),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(101),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(102),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(103),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(104),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(105),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(106),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(107),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(108),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(109),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(110),
+	HNS3_RX_PTYPE_ENTRY(111, 0, COMPLETE, IPV6),
+	HNS3_RX_PTYPE_ENTRY(112, 0, COMPLETE, IPV6),
+	HNS3_RX_PTYPE_ENTRY(113, 0, UNNECESSARY, IPV6),
+	HNS3_RX_PTYPE_ENTRY(114, 0, UNNECESSARY, IPV6),
+	HNS3_RX_PTYPE_ENTRY(115, 0, NONE, IPV6),
+	HNS3_RX_PTYPE_ENTRY(116, 0, UNNECESSARY, IPV6),
+	HNS3_RX_PTYPE_ENTRY(117, 0, NONE, IPV6),
+	HNS3_RX_PTYPE_ENTRY(118, 0, NONE, IPV6),
+	HNS3_RX_PTYPE_ENTRY(119, 0, UNNECESSARY, IPV6),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(120),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(121),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(122),
+	HNS3_RX_PTYPE_ENTRY(123, 0, COMPLETE, PARSE_FAIL),
+	HNS3_RX_PTYPE_ENTRY(124, 0, COMPLETE, PARSE_FAIL),
+	HNS3_RX_PTYPE_ENTRY(125, 0, COMPLETE, IPV4),
+	HNS3_RX_PTYPE_ENTRY(126, 0, COMPLETE, IPV4),
+	HNS3_RX_PTYPE_ENTRY(127, 1, UNNECESSARY, IPV4),
+	HNS3_RX_PTYPE_ENTRY(128, 1, UNNECESSARY, IPV4),
+	HNS3_RX_PTYPE_ENTRY(129, 1, UNNECESSARY, IPV4),
+	HNS3_RX_PTYPE_ENTRY(130, 0, COMPLETE, IPV4),
+	HNS3_RX_PTYPE_ENTRY(131, 0, COMPLETE, IPV4),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(132),
+	HNS3_RX_PTYPE_ENTRY(133, 0, COMPLETE, IPV6),
+	HNS3_RX_PTYPE_ENTRY(134, 0, COMPLETE, IPV6),
+	HNS3_RX_PTYPE_ENTRY(135, 1, UNNECESSARY, IPV6),
+	HNS3_RX_PTYPE_ENTRY(136, 1, UNNECESSARY, IPV6),
+	HNS3_RX_PTYPE_ENTRY(137, 1, UNNECESSARY, IPV6),
+	HNS3_RX_PTYPE_ENTRY(138, 0, COMPLETE, IPV6),
+	HNS3_RX_PTYPE_ENTRY(139, 0, COMPLETE, IPV6),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(140),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(141),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(142),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(143),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(144),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(145),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(146),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(147),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(148),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(149),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(150),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(151),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(152),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(153),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(154),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(155),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(156),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(157),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(158),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(159),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(160),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(161),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(162),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(163),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(164),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(165),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(166),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(167),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(168),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(169),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(170),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(171),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(172),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(173),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(174),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(175),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(176),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(177),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(178),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(179),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(180),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(181),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(182),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(183),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(184),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(185),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(186),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(187),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(188),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(189),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(190),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(191),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(192),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(193),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(194),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(195),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(196),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(197),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(198),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(199),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(200),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(201),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(202),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(203),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(204),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(205),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(206),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(207),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(208),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(209),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(210),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(211),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(212),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(213),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(214),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(215),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(216),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(217),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(218),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(219),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(220),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(221),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(222),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(223),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(224),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(225),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(226),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(227),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(228),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(229),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(230),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(231),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(232),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(233),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(234),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(235),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(236),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(237),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(238),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(239),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(240),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(241),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(242),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(243),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(244),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(245),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(246),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(247),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(248),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(249),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(250),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(251),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(252),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(253),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(254),
+	HNS3_RX_PTYPE_UNUSED_ENTRY(255),
+};
+
+#define HNS3_INVALID_PTYPE \
+		ARRAY_SIZE(hns3_rx_ptype_tbl)
+
 static irqreturn_t hns3_irq_handle(int irq, void *vector)
 {
 	struct hns3_enet_tqp_vector *tqp_vector = vector;
@@ -2996,35 +3268,15 @@ static void hns3_checksum_complete(struct hns3_enet_ring *ring,
 	skb->csum = csum_unfold((__force __sum16)(lo | hi << 8));
 }
 
-static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
-			     u32 l234info, u32 bd_base_info, u32 ol_info)
+static void hns3_rx_handle_csum(struct sk_buff *skb, u32 l234info,
+				u32 ol_info, u32 ptype)
 {
-	struct net_device *netdev = ring_to_netdev(ring);
 	int l3_type, l4_type;
 	int ol4_type;
 
-	skb->ip_summed = CHECKSUM_NONE;
-
-	skb_checksum_none_assert(skb);
-
-	if (!(netdev->features & NETIF_F_RXCSUM))
-		return;
-
-	if (l234info & BIT(HNS3_RXD_L2_CSUM_B)) {
-		hns3_checksum_complete(ring, skb, l234info);
-		return;
-	}
-
-	/* check if hardware has done checksum */
-	if (!(bd_base_info & BIT(HNS3_RXD_L3L4P_B)))
-		return;
-
-	if (unlikely(l234info & (BIT(HNS3_RXD_L3E_B) | BIT(HNS3_RXD_L4E_B) |
-				 BIT(HNS3_RXD_OL3E_B) |
-				 BIT(HNS3_RXD_OL4E_B)))) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.l3l4_csum_err++;
-		u64_stats_update_end(&ring->syncp);
+	if (ptype != HNS3_INVALID_PTYPE) {
+		skb->csum_level = hns3_rx_ptype_tbl[ptype].csum_level;
+		skb->ip_summed = hns3_rx_ptype_tbl[ptype].ip_summed;
 
 		return;
 	}
@@ -3054,6 +3306,46 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 	}
 }
 
+static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
+			     u32 l234info, u32 bd_base_info, u32 ol_info)
+{
+	struct net_device *netdev = ring_to_netdev(ring);
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	u32 ptype = HNS3_INVALID_PTYPE;
+
+	skb->ip_summed = CHECKSUM_NONE;
+
+	skb_checksum_none_assert(skb);
+
+	if (!(netdev->features & NETIF_F_RXCSUM))
+		return;
+
+	if (test_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state))
+		ptype = hnae3_get_field(ol_info, HNS3_RXD_PTYPE_M,
+					HNS3_RXD_PTYPE_S);
+
+	if (l234info & BIT(HNS3_RXD_L2_CSUM_B)) {
+		hns3_checksum_complete(ring, skb, l234info);
+		return;
+	}
+
+	/* check if hardware has done checksum */
+	if (!(bd_base_info & BIT(HNS3_RXD_L3L4P_B)))
+		return;
+
+	if (unlikely(l234info & (BIT(HNS3_RXD_L3E_B) | BIT(HNS3_RXD_L4E_B) |
+				 BIT(HNS3_RXD_OL3E_B) |
+				 BIT(HNS3_RXD_OL4E_B)))) {
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.l3l4_csum_err++;
+		u64_stats_update_end(&ring->syncp);
+
+		return;
+	}
+
+	hns3_rx_handle_csum(skb, l234info, ol_info, ptype);
+}
+
 static void hns3_rx_skb(struct hns3_enet_ring *ring, struct sk_buff *skb)
 {
 	if (skb_has_frag_list(skb))
@@ -3237,6 +3529,8 @@ static int hns3_set_gro_and_checksum(struct hns3_enet_ring *ring,
 				     struct sk_buff *skb, u32 l234info,
 				     u32 bd_base_info, u32 ol_info)
 {
+	struct net_device *netdev = ring_to_netdev(ring);
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	u32 l3_type;
 
 	skb_shinfo(skb)->gso_size = hnae3_get_field(bd_base_info,
@@ -3252,7 +3546,16 @@ static int hns3_set_gro_and_checksum(struct hns3_enet_ring *ring,
 						  HNS3_RXD_GRO_COUNT_M,
 						  HNS3_RXD_GRO_COUNT_S);
 
-	l3_type = hnae3_get_field(l234info, HNS3_RXD_L3ID_M, HNS3_RXD_L3ID_S);
+	if (test_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state)) {
+		u32 ptype = hnae3_get_field(ol_info, HNS3_RXD_PTYPE_M,
+					    HNS3_RXD_PTYPE_S);
+
+		l3_type = hns3_rx_ptype_tbl[ptype].l3_type;
+	} else {
+		l3_type = hnae3_get_field(l234info, HNS3_RXD_L3ID_M,
+					  HNS3_RXD_L3ID_S);
+	}
+
 	if (l3_type == HNS3_L3_TYPE_IPV4)
 		skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
 	else if (l3_type == HNS3_L3_TYPE_IPV6)
@@ -4350,6 +4653,9 @@ static int hns3_client_init(struct hnae3_handle *handle)
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
 		set_bit(HNS3_NIC_STATE_HW_TX_CSUM_ENABLE, &priv->state);
 
+	if (hnae3_ae_dev_rxd_adv_layout_supported(ae_dev))
+		set_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state);
+
 	set_bit(HNS3_NIC_STATE_INITED, &priv->state);
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index daa04ae..843642b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -19,6 +19,7 @@ enum hns3_nic_state {
 	HNS3_NIC_STATE_SERVICE_SCHED,
 	HNS3_NIC_STATE2_RESET_REQUESTED,
 	HNS3_NIC_STATE_HW_TX_CSUM_ENABLE,
+	HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE,
 	HNS3_NIC_STATE_MAX
 };
 
@@ -114,6 +115,9 @@ enum hns3_nic_state {
 #define HNS3_RXD_FBLI_S				14
 #define HNS3_RXD_FBLI_M				(0x3 << HNS3_RXD_FBLI_S)
 
+#define HNS3_RXD_PTYPE_S			4
+#define HNS3_RXD_PTYPE_M			GENMASK(11, 4)
+
 #define HNS3_RXD_BDTYPE_S			0
 #define HNS3_RXD_BDTYPE_M			(0xf << HNS3_RXD_BDTYPE_S)
 #define HNS3_RXD_VLD_B				4
@@ -366,6 +370,14 @@ enum hns3_pkt_ol4type {
 	HNS3_OL4_TYPE_UNKNOWN
 };
 
+struct hns3_rx_ptype {
+	u32 ptype:8;
+	u32 csum_level:2;
+	u32 ip_summed:2;
+	u32 l3_type:4;
+	u32 valid:1;
+};
+
 struct ring_stats {
 	u64 sw_err_cnt;
 	u64 seg_pkt_cnt;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 76a4824..0df9ca3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -386,6 +386,8 @@ static void hclge_parse_capability(struct hclge_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_PAUSE_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGE_CAP_PHY_IMP_B))
 		set_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGE_CAP_RXD_ADV_LAYOUT_B))
+		set_bit(HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B, ae_dev->caps);
 }
 
 static __le32 hclge_build_api_caps(void)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index c6fc22e..c6cd273 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -391,6 +391,7 @@ enum HCLGE_CAP_BITS {
 	HCLGE_CAP_UDP_TUNNEL_CSUM_B,
 	HCLGE_CAP_FEC_B = 13,
 	HCLGE_CAP_PAUSE_B = 14,
+	HCLGE_CAP_RXD_ADV_LAYOUT_B = 15,
 };
 
 enum HCLGE_API_CAP_BITS {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6304aed..55b0453 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11167,6 +11167,18 @@ static void hclge_clear_resetting_state(struct hclge_dev *hdev)
 	}
 }
 
+static void hclge_init_rxd_adv_layout(struct hclge_dev *hdev)
+{
+	if (hnae3_ae_dev_rxd_adv_layout_supported(hdev->ae_dev))
+		hclge_write_dev(&hdev->hw, HCLGE_RXD_ADV_LAYOUT_EN_REG, 1);
+}
+
+static void hclge_uninit_rxd_adv_layout(struct hclge_dev *hdev)
+{
+	if (hnae3_ae_dev_rxd_adv_layout_supported(hdev->ae_dev))
+		hclge_write_dev(&hdev->hw, HCLGE_RXD_ADV_LAYOUT_EN_REG, 0);
+}
+
 static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 {
 	struct pci_dev *pdev = ae_dev->pdev;
@@ -11339,6 +11351,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		mod_timer(&hdev->reset_timer, jiffies + HCLGE_RESET_INTERVAL);
 	}
 
+	hclge_init_rxd_adv_layout(hdev);
+
 	/* Enable MISC vector(vector0) */
 	hclge_enable_vector(&hdev->misc_vector, true);
 
@@ -11720,6 +11734,8 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		return ret;
 
+	hclge_init_rxd_adv_layout(hdev);
+
 	dev_info(&pdev->dev, "Reset done, %s driver initialization finished.\n",
 		 HCLGE_DRIVER_NAME);
 
@@ -11735,6 +11751,7 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_clear_vf_vlan(hdev);
 	hclge_misc_affinity_teardown(hdev);
 	hclge_state_uninit(hdev);
+	hclge_uninit_rxd_adv_layout(hdev);
 	hclge_uninit_mac_table(hdev);
 	hclge_del_all_fd_entries(hdev);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index ff1d473..10f5c11 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -53,6 +53,7 @@
 /* bar registers for common func */
 #define HCLGE_VECTOR0_OTER_EN_REG	0x20600
 #define HCLGE_GRO_EN_REG		0x28000
+#define HCLGE_RXD_ADV_LAYOUT_EN_REG	0x28008
 
 /* bar registers for rcb */
 #define HCLGE_RING_RX_ADDR_L_REG	0x80000
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index d8c5c58..bd19a2d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -359,6 +359,8 @@ static void hclgevf_parse_capability(struct hclgevf_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGEVF_CAP_UDP_TUNNEL_CSUM_B))
 		set_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGEVF_CAP_RXD_ADV_LAYOUT_B))
+		set_bit(HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B, ae_dev->caps);
 }
 
 static __le32 hclgevf_build_api_caps(void)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index c6dc11b..202feb7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -159,6 +159,7 @@ enum HCLGEVF_CAP_BITS {
 	HCLGEVF_CAP_HW_PAD_B,
 	HCLGEVF_CAP_STASH_B,
 	HCLGEVF_CAP_UDP_TUNNEL_CSUM_B,
+	HCLGEVF_CAP_RXD_ADV_LAYOUT_B = 15,
 };
 
 enum HCLGEVF_API_CAP_BITS {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 0db51ef1..7bef6b2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3242,6 +3242,18 @@ static int hclgevf_clear_vport_list(struct hclgevf_dev *hdev)
 	return hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 }
 
+static void hclgevf_init_rxd_adv_layout(struct hclgevf_dev *hdev)
+{
+	if (hnae3_ae_dev_rxd_adv_layout_supported(hdev->ae_dev))
+		hclgevf_write_dev(&hdev->hw, HCLGEVF_RXD_ADV_LAYOUT_EN_REG, 1);
+}
+
+static void hclgevf_uninit_rxd_adv_layout(struct hclgevf_dev *hdev)
+{
+	if (hnae3_ae_dev_rxd_adv_layout_supported(hdev->ae_dev))
+		hclgevf_write_dev(&hdev->hw, HCLGEVF_RXD_ADV_LAYOUT_EN_REG, 0);
+}
+
 static int hclgevf_reset_hdev(struct hclgevf_dev *hdev)
 {
 	struct pci_dev *pdev = hdev->pdev;
@@ -3279,6 +3291,8 @@ static int hclgevf_reset_hdev(struct hclgevf_dev *hdev)
 
 	set_bit(HCLGEVF_STATE_PROMISC_CHANGED, &hdev->state);
 
+	hclgevf_init_rxd_adv_layout(hdev);
+
 	dev_info(&hdev->pdev->dev, "Reset done\n");
 
 	return 0;
@@ -3379,6 +3393,8 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 		goto err_config;
 	}
 
+	hclgevf_init_rxd_adv_layout(hdev);
+
 	hdev->last_reset_time = jiffies;
 	dev_info(&hdev->pdev->dev, "finished initializing %s driver\n",
 		 HCLGEVF_DRIVER_NAME);
@@ -3405,6 +3421,7 @@ static void hclgevf_uninit_hdev(struct hclgevf_dev *hdev)
 	struct hclge_vf_to_pf_msg send_msg;
 
 	hclgevf_state_uninit(hdev);
+	hclgevf_uninit_rxd_adv_layout(hdev);
 
 	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_VF_UNINIT, 0);
 	hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 265c9b0..b146d04 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -47,6 +47,7 @@
 
 /* bar registers for common func */
 #define HCLGEVF_GRO_EN_REG			0x28000
+#define HCLGEVF_RXD_ADV_LAYOUT_EN_REG		0x28008
 
 /* bar registers for rcb */
 #define HCLGEVF_RING_RX_ADDR_L_REG		0x80000
-- 
2.7.4

