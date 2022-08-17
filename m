Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8696459719F
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240193AbiHQOjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237215AbiHQOi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:38:58 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEE69D109;
        Wed, 17 Aug 2022 07:38:00 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4M79Ww0zrVz1N7L4;
        Wed, 17 Aug 2022 22:34:36 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 17 Aug 2022 22:37:56 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 17 Aug 2022 22:37:56 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <idosch@nvidia.com>,
        <linux@rempel-privat.de>, <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/2] net: ethtool: add VxLAN to the NFC API
Date:   Wed, 17 Aug 2022 22:35:37 +0800
Message-ID: <20220817143538.43717-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220817143538.43717-1-huangguangbin2@huawei.com>
References: <20220817143538.43717-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support for steering VxLAN flows using the ethtool NFC interface, this
patch adds flow specifications for vxlan4(VxLAN with inner IPv4) and vxlan6
(VxLAN with inner IPv6).

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 include/uapi/linux/ethtool.h | 48 ++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 2d5741fd44bb..687c4b5e7bc6 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -931,6 +931,28 @@ struct ethtool_usrip4_spec {
 	__u8    proto;
 };
 
+/**
+ * struct ethtool_vxlan4_spec - general flow specification for VxLAN IPv4
+ * @vni: VxLAN network identifier
+ * @dst: Inner destination eth addr
+ * @src: Inner source eth addr
+ * @eth_type: Inner ethernet type
+ * @tos: Inner type-of-service
+ * @l4_proto: Inner transport protocol number
+ * @ip4src: Inner source host
+ * @ip4dst: Inner destination host
+ */
+struct ethtool_vxlan4_spec {
+	__be32	vni;
+	__u8	dst[ETH_ALEN];
+	__u8	src[ETH_ALEN];
+	__be16	eth_type;
+	__u8	tos;
+	__u8	l4_proto;
+	__be32	ip4src;
+	__be32	ip4dst;
+};
+
 /**
  * struct ethtool_tcpip6_spec - flow specification for TCP/IPv6 etc.
  * @ip6src: Source host
@@ -981,6 +1003,28 @@ struct ethtool_usrip6_spec {
 	__u8    l4_proto;
 };
 
+/**
+ * struct ethtool_vxlan6_spec - general flow specification for VxLAN IPv6
+ * @vni: VxLAN network identifier
+ * @dst: Inner destination eth addr
+ * @src: Inner source eth addr
+ * @eth_type: Inner ethernet type
+ * @tclass: Inner traffic Class
+ * @l4_proto: Inner transport protocol number
+ * @ip6src: Inner source host
+ * @ip6dst: Inner destination host
+ */
+struct ethtool_vxlan6_spec {
+	__be32	vni;
+	__u8	dst[ETH_ALEN];
+	__u8	src[ETH_ALEN];
+	__be16	eth_type;
+	__u8	tclass;
+	__u8	l4_proto;
+	__be32	ip6src[4];
+	__be32	ip6dst[4];
+};
+
 union ethtool_flow_union {
 	struct ethtool_tcpip4_spec		tcp_ip4_spec;
 	struct ethtool_tcpip4_spec		udp_ip4_spec;
@@ -988,12 +1032,14 @@ union ethtool_flow_union {
 	struct ethtool_ah_espip4_spec		ah_ip4_spec;
 	struct ethtool_ah_espip4_spec		esp_ip4_spec;
 	struct ethtool_usrip4_spec		usr_ip4_spec;
+	struct ethtool_vxlan4_spec		vxlan_ip4_spec;
 	struct ethtool_tcpip6_spec		tcp_ip6_spec;
 	struct ethtool_tcpip6_spec		udp_ip6_spec;
 	struct ethtool_tcpip6_spec		sctp_ip6_spec;
 	struct ethtool_ah_espip6_spec		ah_ip6_spec;
 	struct ethtool_ah_espip6_spec		esp_ip6_spec;
 	struct ethtool_usrip6_spec		usr_ip6_spec;
+	struct ethtool_vxlan6_spec		vxlan_ip6_spec;
 	struct ethhdr				ether_spec;
 	__u8					hdata[52];
 };
@@ -1900,6 +1946,8 @@ static inline int ethtool_validate_duplex(__u8 duplex)
 #define	IPV4_FLOW	0x10	/* hash only */
 #define	IPV6_FLOW	0x11	/* hash only */
 #define	ETHER_FLOW	0x12	/* spec only (ether_spec) */
+#define	VXLAN_V4_FLOW	0x13	/* spec only (vxlan_ip4_spec) */
+#define	VXLAN_V6_FLOW	0x14	/* spec only (vxlan_ip6_spec) */
 /* Flag to enable additional fields in struct ethtool_rx_flow_spec */
 #define	FLOW_EXT	0x80000000
 #define	FLOW_MAC_EXT	0x40000000
-- 
2.33.0

