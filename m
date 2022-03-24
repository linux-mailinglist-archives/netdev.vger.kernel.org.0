Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0848F4E6670
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351482AbiCXP5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351436AbiCXP4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:48 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1952AD109
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:11 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KPV7f2M37zBrgt;
        Thu, 24 Mar 2022 23:51:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 23:55:07 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv5 PATCH net-next 02/20] net: introduce operation helpers for netdev features
Date:   Thu, 24 Mar 2022 23:49:14 +0800
Message-ID: <20220324154932.17557-3-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220324154932.17557-1-shenjian15@huawei.com>
References: <20220324154932.17557-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a set of bitmap operation helpers for netdev features,
then we can use them to replace the logical operation with them.
As the nic driversare not supposed to modify netdev_features
directly, it also introduces wrappers helpers to this.

The implementation of these helpers are based on the old prototype
of netdev_features_t is still u64. I will rewrite them on the last
patch, when the prototype changes.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 include/linux/netdevice.h | 597 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 597 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7307b9553bcf..0af4b26896d6 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2295,6 +2295,603 @@ struct net_device {
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
+static inline void netdev_features_zero(netdev_features_t *dst)
+{
+	*dst = 0;
+}
+
+static inline void netdev_features_fill(netdev_features_t *dst)
+{
+	*dst = ~0ULL;
+}
+
+static inline bool netdev_features_empty(const netdev_features_t src)
+{
+	return src == 0;
+}
+
+/* helpers for netdev features '==' operation */
+static inline bool netdev_features_equal(const netdev_features_t src1,
+					 const netdev_features_t src2)
+{
+	return src1 == src2;
+}
+
+#define netdev_active_features_equal(ndev, features) \
+		netdev_features_equal(ndev->active_features, features)
+
+#define netdev_hw_features_equal(ndev, features) \
+		netdev_features_equal(ndev->hw_features, features)
+
+#define netdev_wanted_features_equal(ndev, features) \
+		netdev_features_equal(ndev->wanted_features, features)
+
+#define netdev_vlan_features_equal(ndev, features) \
+		netdev_features_equal(ndev->vlan_features, features)
+
+#define netdev_hw_enc_features_equal(ndev, features) \
+		netdev_features_equal(ndev->vlan_features, features)
+
+#define netdev_mpls_features_equal(ndev, features) \
+		netdev_features_equal(ndev->vlan_features, features)
+
+#define netdev_gso_partial_features_equal(ndev, features) \
+		netdev_features_equal(ndev->vlan_features, features)
+
+/* helpers for netdev features '&' operation */
+static inline netdev_features_t
+netdev_features_and(const netdev_features_t a, const netdev_features_t b)
+{
+	return a & b;
+}
+
+#define netdev_active_features_and(ndev, features) \
+		netdev_features_and(ndev->active_features, features)
+
+#define netdev_hw_features_and(ndev, features) \
+		netdev_features_and(ndev->hw_features, features)
+
+#define netdev_wanted_features_and(ndev, features) \
+		netdev_features_and(ndev->wanted_features, features)
+
+#define netdev_vlan_features_and(ndev, features) \
+		netdev_features_and(ndev->vlan_features, features)
+
+#define netdev_hw_enc_features_and(ndev, features) \
+		netdev_features_and(ndev->hw_enc_features, features)
+
+#define netdev_mpls_features_and(ndev, features) \
+		netdev_features_and(ndev->mpls_features, features)
+
+#define netdev_gso_partial_features_and(ndev, features) \
+		netdev_features_and(ndev->gso_partial_features, features)
+
+/* helpers for netdev features '&=' operation */
+static inline void
+netdev_features_direct_and(netdev_features_t *dst,
+			   const netdev_features_t features)
+{
+	*dst = netdev_features_and(*dst, features);
+}
+
+static inline void
+netdev_active_features_direct_and(struct net_device *ndev,
+				  const netdev_features_t features)
+{
+	ndev->active_features = netdev_active_features_and(ndev, features);
+}
+
+static inline void
+netdev_hw_features_direct_and(struct net_device *ndev,
+			      const netdev_features_t features)
+{
+	ndev->hw_features = netdev_hw_features_and(ndev, features);
+}
+
+static inline void
+netdev_wanted_features_direct_and(struct net_device *ndev,
+				  const netdev_features_t features)
+{
+	ndev->wanted_features = netdev_wanted_features_and(ndev, features);
+}
+
+static inline void
+netdev_vlan_features_direct_and(struct net_device *ndev,
+				const netdev_features_t features)
+{
+	ndev->vlan_features = netdev_vlan_features_and(ndev, features);
+}
+
+static inline void
+netdev_hw_enc_features_direct_and(struct net_device *ndev,
+				  const netdev_features_t features)
+{
+	ndev->hw_enc_features = netdev_hw_enc_features_and(ndev, features);
+}
+
+static inline void
+netdev_mpls_features_direct_and(struct net_device *ndev,
+				const netdev_features_t features)
+{
+	ndev->mpls_features = netdev_mpls_features_and(ndev, features);
+}
+
+static inline void
+netdev_gso_partial_features_direct_and(struct net_device *ndev,
+				       const netdev_features_t features)
+{
+	ndev->gso_partial_features = netdev_mpls_features_and(ndev, features);
+}
+
+/* helpers for netdev features '|' operation */
+static inline netdev_features_t
+netdev_features_or(const netdev_features_t a, const netdev_features_t b)
+{
+	return a | b;
+}
+
+#define netdev_active_features_or(ndev, features) \
+		netdev_features_or(ndev->active_features, features)
+
+#define netdev_hw_features_or(ndev, features) \
+		netdev_features_or(ndev->hw_features, features)
+
+#define netdev_wanted_features_or(ndev, features) \
+		netdev_features_or(ndev->wanted_features, features)
+
+#define netdev_vlan_features_or(ndev, features) \
+		netdev_features_or(ndev->vlan_features, features)
+
+#define netdev_hw_enc_features_or(ndev, features) \
+		netdev_features_or(ndev->hw_enc_features, features)
+
+#define netdev_mpls_features_or(ndev, features) \
+		netdev_features_or(ndev->mpls_features, features)
+
+#define netdev_gso_partial_features_or(ndev, features) \
+		netdev_features_or(ndev->gso_partial_features, features)
+
+/* helpers for netdev features '|=' operation */
+static inline void
+netdev_features_direct_or(netdev_features_t *dst,
+			  const netdev_features_t features)
+{
+	*dst = netdev_features_or(*dst, features);
+}
+
+static inline void
+netdev_active_features_direct_or(struct net_device *ndev,
+				 const netdev_features_t features)
+{
+	ndev->active_features = netdev_active_features_or(ndev, features);
+}
+
+static inline void
+netdev_hw_features_direct_or(struct net_device *ndev,
+			     const netdev_features_t features)
+{
+	ndev->hw_features = netdev_hw_features_or(ndev, features);
+}
+
+static inline void
+netdev_wanted_features_direct_or(struct net_device *ndev,
+				 const netdev_features_t features)
+{
+	ndev->wanted_features = netdev_wanted_features_or(ndev, features);
+}
+
+static inline void
+netdev_vlan_features_direct_or(struct net_device *ndev,
+			       const netdev_features_t features)
+{
+	ndev->vlan_features = netdev_vlan_features_or(ndev, features);
+}
+
+static inline void
+netdev_hw_enc_features_direct_or(struct net_device *ndev,
+				 const netdev_features_t features)
+{
+	ndev->hw_enc_features = netdev_hw_enc_features_or(ndev, features);
+}
+
+static inline void
+netdev_mpls_features_direct_or(struct net_device *ndev,
+			       const netdev_features_t features)
+{
+	ndev->mpls_features = netdev_mpls_features_or(ndev, features);
+}
+
+static inline void
+netdev_gso_partial_features_direct_or(struct net_device *ndev,
+				      const netdev_features_t features)
+{
+	ndev->gso_partial_features = netdev_mpls_features_or(ndev, features);
+}
+
+/* helpers for netdev features '^' operation */
+static inline netdev_features_t
+netdev_features_xor(const netdev_features_t a, const netdev_features_t b)
+{
+	return a ^ b;
+}
+
+#define netdev_active_features_xor(ndev, features) \
+		netdev_features_xor(ndev->active_features, features)
+
+#define netdev_hw_features_xor(ndev, features) \
+		netdev_features_xor(ndev->hw_features, features)
+
+#define netdev_wanted_features_xor(ndev, features) \
+		netdev_features_xor(ndev->wanted_features, features)
+
+#define netdev_vlan_features_xor(ndev, features) \
+		netdev_features_xor(ndev->vlan_features, features)
+
+#define netdev_hw_enc_features_xor(ndev, features) \
+		netdev_features_xor(ndev->hw_enc_features, features)
+
+#define netdev_mpls_features_xor(ndev, features) \
+		netdev_features_xor(ndev->mpls_features, features)
+
+#define netdev_gso_partial_features_xor(ndev, features) \
+		netdev_features_xor(ndev->gso_partial_features, features)
+
+/* helpers for netdev features '^=' operation */
+static inline void
+netdev_active_features_direct_xor(struct net_device *ndev,
+				  const netdev_features_t features)
+{
+	ndev->active_features = netdev_active_features_xor(ndev, features);
+}
+
+static inline void
+netdev_hw_features_direct_xor(struct net_device *ndev,
+			      const netdev_features_t features)
+{
+	ndev->hw_features = netdev_hw_features_xor(ndev, features);
+}
+
+static inline void
+netdev_wanted_features_direct_xor(struct net_device *ndev,
+				  const netdev_features_t features)
+{
+	ndev->wanted_features = netdev_wanted_features_xor(ndev, features);
+}
+
+static inline void
+netdev_vlan_features_direct_xor(struct net_device *ndev,
+				const netdev_features_t features)
+{
+	ndev->vlan_features = netdev_vlan_features_xor(ndev, features);
+}
+
+static inline void
+netdev_hw_enc_features_direct_xor(struct net_device *ndev,
+				  const netdev_features_t features)
+{
+	ndev->hw_enc_features = netdev_hw_enc_features_xor(ndev, features);
+}
+
+static inline void
+netdev_mpls_features_direct_xor(struct net_device *ndev,
+				const netdev_features_t features)
+{
+	ndev->mpls_features = netdev_mpls_features_xor(ndev, features);
+}
+
+static inline void
+netdev_gso_partial_features_direct_xor(struct net_device *ndev,
+				       const netdev_features_t features)
+{
+	ndev->gso_partial_features =
+			netdev_gso_partial_features_xor(ndev, features);
+}
+
+/* helpers for netdev features '& ~' operation */
+static inline netdev_features_t
+netdev_features_andnot(const netdev_features_t a, const netdev_features_t b)
+{
+	return a & ~b;
+}
+
+#define netdev_active_features_andnot(ndev, features) \
+		netdev_features_andnot(ndev->active_features, features)
+
+#define netdev_hw_features_andnot(ndev, features) \
+		netdev_features_andnot(ndev->hw_features, features)
+
+#define netdev_wanted_features_andnot(ndev, features) \
+		netdev_features_andnot(ndev->wanted_features, features)
+
+#define netdev_vlan_features_andnot(ndev, features) \
+		netdev_features_andnot(ndev->vlan_features, features)
+
+#define netdev_hw_enc_features_andnot(ndev, features) \
+		netdev_features_andnot(ndev->hw_enc_features, features)
+
+#define netdev_mpls_features_andnot(ndev, features) \
+		netdev_features_andnot(ndev->mpls_features, features)
+
+#define netdev_gso_partial_features_andnot(ndev, features) \
+		netdev_features_andnot(ndev->gso_partial_features, features)
+
+#define netdev_active_features_andnot_r(ndev, features) \
+		netdev_features_andnot(features, ndev->active_features)
+
+#define netdev_hw_features_andnot_r(ndev, features) \
+		netdev_features_andnot(features, ndev->hw_features)
+
+#define netdev_wanted_features_andnot_r(ndev, features) \
+		netdev_features_andnot(features, ndev->wanted_features)
+
+#define netdev_vlan_features_andnot_r(ndev, features) \
+		netdev_features_andnot(features, ndev->vlan_features)
+
+#define netdev_hw_enc_features_andnot_r(ndev, features) \
+		netdev_features_andnot(features, ndev->hw_enc_features)
+
+#define netdev_mpls_features_andnot_r(ndev, features) \
+		netdev_features_andnot(features, ndev->mpls_features)
+
+#define netdev_gso_partial_features_andnot_r(ndev, features) \
+		netdev_features_andnot(features, ndev->gso_partial_features)
+
+static inline void
+netdev_features_direct_andnot(netdev_features_t *dst,
+			     const netdev_features_t features)
+{
+	*dst = netdev_features_andnot(*dst, features);
+}
+
+static inline void
+netdev_active_features_direct_andnot(struct net_device *ndev,
+			     const netdev_features_t features)
+{
+	ndev->active_features = netdev_active_features_andnot(ndev, features);
+}
+
+static inline void
+netdev_hw_features_direct_andnot(struct net_device *ndev,
+			 const netdev_features_t features)
+{
+	ndev->hw_features = netdev_hw_features_andnot(ndev, features);
+}
+
+static inline void
+netdev_wanted_features_direct_andnot(struct net_device *ndev,
+			     const netdev_features_t features)
+{
+	ndev->wanted_features = netdev_wanted_features_andnot(ndev, features);
+}
+
+static inline void
+netdev_vlan_features_direct_andnot(struct net_device *ndev,
+			   const netdev_features_t features)
+{
+	ndev->vlan_features = netdev_vlan_features_andnot(ndev, features);
+}
+
+static inline void
+netdev_hw_enc_features_direct_andnot(struct net_device *ndev,
+			     const netdev_features_t features)
+{
+	ndev->hw_enc_features = netdev_hw_enc_features_andnot(ndev, features);
+}
+
+static inline void
+netdev_mpls_features_direct_andnot(struct net_device *ndev,
+			   const netdev_features_t features)
+{
+	ndev->mpls_features = netdev_mpls_features_andnot(ndev, features);
+}
+
+static inline void
+netdev_gso_partial_features_direct_andnot(struct net_device *ndev,
+				  const netdev_features_t features)
+{
+	ndev->gso_partial_features =
+		netdev_gso_partial_features_andnot(ndev, features);
+}
+
+/* helpers for netdev features 'set bit' operation */
+static inline void netdev_features_set_bit(int nr, netdev_features_t *src)
+{
+	*src |= __NETIF_F_BIT(nr);
+}
+
+#define netdev_active_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->active_features)
+
+#define netdev_hw_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->hw_features)
+
+#define netdev_wanted_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->wanted_features)
+
+#define netdev_vlan_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->vlan_features)
+
+#define netdev_hw_enc_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->hw_enc_features)
+
+#define netdev_mpls_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->mpls_features)
+
+#define netdev_gso_partial_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->gso_partial_features)
+
+/* helpers for netdev features 'set bit array' operation */
+static inline void netdev_features_set_array(const int *array, int array_size,
+					     netdev_features_t *dst)
+{
+	int i;
+
+	for (i = 0; i < array_size; i++)
+		netdev_features_set_bit(array[i], dst);
+}
+
+#define netdev_active_features_set_array(ndev, array, array_size) \
+		netdev_features_set_array(array, array_size, &ndev->active_features)
+
+#define netdev_hw_features_set_array(ndev, array, array_size) \
+		netdev_features_set_array(array, array_size, &ndev->hw_features)
+
+#define netdev_wanted_features_set_array(ndev, array, array_size) \
+		netdev_features_set_array(array, array_size, &ndev->wanted_features)
+
+#define netdev_vlan_features_set_array(ndev, array, array_size) \
+		netdev_features_set_array(array, array_size, &ndev->vlan_features)
+
+#define netdev_hw_enc_features_set_array(ndev, array, array_size) \
+		netdev_features_set_array(array, array_size, &ndev->hw_enc_features)
+
+#define netdev_mpls_features_set_array(ndev, array, array_size) \
+		netdev_features_set_array(array, array_size, &ndev->mpls_features)
+
+#define netdev_gso_partial_features_set_array(ndev, array, array_size) \
+		netdev_features_set_array(array, array_size, &ndev->gso_partial_features)
+
+/* helpers for netdev features 'clear bit' operation */
+static inline void netdev_features_clear_bit(int nr, netdev_features_t *src)
+{
+	*src &= ~__NETIF_F_BIT(nr);
+}
+
+#define netdev_active_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->active_features)
+
+#define netdev_hw_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->hw_features)
+
+#define netdev_wanted_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->wanted_features)
+
+#define netdev_vlan_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->vlan_features)
+
+#define netdev_hw_enc_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->hw_enc_features)
+
+#define netdev_mpls_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->mpls_features)
+
+#define netdev_gso_partial_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->gso_partial_features)
+
+/* helpers for netdev features 'test bit' operation */
+static inline bool netdev_features_test_bit(int nr, const netdev_features_t src)
+{
+	return (src & __NETIF_F_BIT(nr)) > 0;
+}
+
+#define netdev_active_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, ndev->active_features)
+
+#define netdev_hw_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, ndev->hw_features)
+
+#define netdev_wanted_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, ndev->wanted_features)
+
+#define netdev_vlan_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, ndev->vlan_features)
+
+#define netdev_hw_enc_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, ndev->hw_enc_features)
+
+#define netdev_mpls_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, ndev->mpls_features)
+
+#define netdev_gso_partial_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, ndev->gso_partial_features)
+
+static inline bool netdev_features_intersects(const netdev_features_t src1,
+					      const netdev_features_t src2)
+{
+	return (src1 & src2) > 0;
+}
+
+#define netdev_active_features_intersects(ndev, features) \
+		netdev_features_intersects(ndev->active_features, features)
+
+#define netdev_hw_features_intersects(ndev, features) \
+		netdev_features_intersects(ndev->hw_features, features)
+
+#define netdev_wanted_features_intersects(ndev, features) \
+		netdev_features_intersects(ndev->wanted_features, features)
+
+#define netdev_vlan_features_intersects(ndev, features) \
+		netdev_features_intersects(ndev->vlan_features, features)
+
+#define netdev_hw_enc_features_intersects(ndev, features) \
+		netdev_features_intersects(ndev->hw_enc_features, features)
+
+#define netdev_mpls_features_intersects(ndev, features) \
+		netdev_features_intersects(ndev->mpls_features, features)
+
+#define netdev_gso_partial_features_intersects(ndev, features) \
+		netdev_features_intersects(ndev->gso_partial_features, features)
+
+
+/* helpers for netdev features '=' operation */
+static inline void netdev_set_active_features(struct net_device *netdev,
+					      const netdev_features_t src)
+{
+	netdev->active_features = src;
+}
+
+static inline void netdev_set_hw_features(struct net_device *ndev,
+					  const netdev_features_t src)
+{
+	ndev->hw_features = src;
+}
+
+static inline void netdev_set_wanted_features(struct net_device *ndev,
+					      const netdev_features_t src)
+{
+	ndev->wanted_features = src;
+}
+
+static inline void netdev_set_vlan_features(struct net_device *ndev,
+					    const netdev_features_t src)
+{
+	ndev->vlan_features = src;
+}
+
+static inline void netdev_set_hw_enc_features(struct net_device *ndev,
+					      const netdev_features_t src)
+{
+	ndev->hw_enc_features = src;
+}
+
+static inline void netdev_set_mpls_features(struct net_device *ndev,
+					    const netdev_features_t src)
+{
+	ndev->mpls_features = src;
+}
+
+static inline void netdev_set_gso_partial_features(struct net_device *ndev,
+					    const netdev_features_t src)
+{
+	ndev->gso_partial_features = src;
+}
+
+/* helpers for netdev features 'get' operation */
+#define netdev_active_features(ndev)	((ndev)->active_features)
+#define netdev_hw_features(ndev)	((ndev)->hw_features)
+#define netdev_wanted_features(ndev)	((ndev)->wanted_features)
+#define netdev_vlan_features(ndev)	((ndev)->vlan_features)
+#define netdev_hw_enc_features(ndev)	((ndev)->hw_enc_features)
+#define netdev_mpls_features(ndev)	((ndev)->mpls_features)
+#define netdev_gso_partial_features(ndev)	((ndev)->gso_partial_features)
+
+/* helpers for netdev features 'subset' */
+static inline bool netdev_features_subset(const netdev_features_t src1,
+					  const netdev_features_t src2)
+{
+	return (src1 & src2) == src2;
+}
+
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
 	if (!(dev->active_features & NETIF_F_GRO) || dev->xdp_prog)
-- 
2.33.0

