Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9A750621F
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 04:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344623AbiDSCai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 22:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233778AbiDSCah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 22:30:37 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C2C2C138
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 19:27:55 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Kj6zj60b8zCrD9;
        Tue, 19 Apr 2022 10:23:29 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 10:27:53 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv6 PATCH net-next 01/19] net: introduce operation helpers for netdev features
Date:   Tue, 19 Apr 2022 10:21:48 +0800
Message-ID: <20220419022206.36381-2-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220419022206.36381-1-shenjian15@huawei.com>
References: <20220419022206.36381-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

To avoid interdependencies between netdev_features_helper.h and
netdevice.h, put the helpers for testing feature is set in the
netdevice.h, and move advandced helpers like
netdev_get_wanted_features() and netdev_intersect_features() to
netdev_features_helper.h.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |   1 +
 include/linux/netdev_features.h               |  12 +
 include/linux/netdev_features_helper.h        | 604 ++++++++++++++++++
 include/linux/netdevice.h                     |  45 +-
 net/8021q/vlan_dev.c                          |   1 +
 net/core/dev.c                                |   1 +
 6 files changed, 646 insertions(+), 18 deletions(-)
 create mode 100644 include/linux/netdev_features_helper.h

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index ba3fa7eac98d..08f2c54e0a11 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -4,6 +4,7 @@
 #include <linux/etherdevice.h>
 #include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/lockdep.h>
+#include <linux/netdev_features_helper.h>
 #include <net/dst_metadata.h>
 
 #include "nfpcore/nfp_cpp.h"
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 2c6b9e416225..e2b66fa3d7d6 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -11,6 +11,18 @@
 
 typedef u64 netdev_features_t;
 
+struct netdev_feature_set {
+	unsigned int cnt;
+	unsigned short feature_bits[];
+};
+
+#define DECLARE_NETDEV_FEATURE_SET(name, features...)		\
+	static unsigned short __##name##_s[] = {features};	\
+	struct netdev_feature_set name = {			\
+		.cnt = ARRAY_SIZE(__##name##_s),		\
+		.feature_bits = {features},			\
+	}
+
 enum {
 	NETIF_F_SG_BIT,			/* Scatter/gather IO. */
 	NETIF_F_IP_CSUM_BIT,		/* Can checksum TCP/UDP over IPv4. */
diff --git a/include/linux/netdev_features_helper.h b/include/linux/netdev_features_helper.h
new file mode 100644
index 000000000000..5cc6368f65e5
--- /dev/null
+++ b/include/linux/netdev_features_helper.h
@@ -0,0 +1,604 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Network device features helpers.
+ */
+#ifndef _LINUX_NETDEV_FEATURES_HELPER_H
+#define _LINUX_NETDEV_FEATURES_HELPER_H
+
+#include <linux/netdevice.h>
+
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
+/* active_feature prefer to netdev->features */
+#define netdev_active_features_equal(ndev, __features) \
+		netdev_features_equal(ndev->features, __features)
+
+#define netdev_hw_features_equal(ndev, __features) \
+		netdev_features_equal(ndev->hw_features, __features)
+
+#define netdev_wanted_features_equal(ndev, __features) \
+		netdev_features_equal(ndev->wanted_features, __features)
+
+#define netdev_vlan_features_equal(ndev, __features) \
+		netdev_features_equal(ndev->vlan_features, __features)
+
+#define netdev_hw_enc_features_equal(ndev, __features) \
+		netdev_features_equal(ndev->hw_enc_features, __features)
+
+#define netdev_mpls_features_equal(ndev, __features) \
+		netdev_features_equal(ndev->mpls_features, __features)
+
+#define netdev_gso_partial_features_equal(ndev, __features) \
+		netdev_features_equal(ndev->gso_partial_features, __features)
+
+/* helpers for netdev features '&' operation */
+static inline netdev_features_t
+netdev_features_and(const netdev_features_t a, const netdev_features_t b)
+{
+	return a & b;
+}
+
+#define netdev_active_features_and(ndev, __features) \
+		netdev_features_and(ndev->features, __features)
+
+#define netdev_hw_features_and(ndev, __features) \
+		netdev_features_and(ndev->hw_features, __features)
+
+#define netdev_wanted_features_and(ndev, __features) \
+		netdev_features_and(ndev->wanted_features, __features)
+
+#define netdev_vlan_features_and(ndev, __features) \
+		netdev_features_and(ndev->vlan_features, __features)
+
+#define netdev_hw_enc_features_and(ndev, __features) \
+		netdev_features_and(ndev->hw_enc_features, __features)
+
+#define netdev_mpls_features_and(ndev, __features) \
+		netdev_features_and(ndev->mpls_features, __features)
+
+#define netdev_gso_partial_features_and(ndev, __features) \
+		netdev_features_and(ndev->gso_partial_features, __features)
+
+/* helpers for netdev features '&=' operation */
+static inline void
+netdev_features_mask(netdev_features_t *dst,
+			   const netdev_features_t features)
+{
+	*dst = netdev_features_and(*dst, features);
+}
+
+static inline void
+netdev_active_features_mask(struct net_device *ndev,
+			    const netdev_features_t features)
+{
+	ndev->features = netdev_active_features_and(ndev, features);
+}
+
+static inline void
+netdev_hw_features_mask(struct net_device *ndev,
+			const netdev_features_t features)
+{
+	ndev->hw_features = netdev_hw_features_and(ndev, features);
+}
+
+static inline void
+netdev_wanted_features_mask(struct net_device *ndev,
+			    const netdev_features_t features)
+{
+	ndev->wanted_features = netdev_wanted_features_and(ndev, features);
+}
+
+static inline void
+netdev_vlan_features_mask(struct net_device *ndev,
+			  const netdev_features_t features)
+{
+	ndev->vlan_features = netdev_vlan_features_and(ndev, features);
+}
+
+static inline void
+netdev_hw_enc_features_mask(struct net_device *ndev,
+			    const netdev_features_t features)
+{
+	ndev->hw_enc_features = netdev_hw_enc_features_and(ndev, features);
+}
+
+static inline void
+netdev_mpls_features_mask(struct net_device *ndev,
+			  const netdev_features_t features)
+{
+	ndev->mpls_features = netdev_mpls_features_and(ndev, features);
+}
+
+static inline void
+netdev_gso_partial_features_mask(struct net_device *ndev,
+				 const netdev_features_t features)
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
+#define netdev_active_features_or(ndev, __features) \
+		netdev_features_or(ndev->features, __features)
+
+#define netdev_hw_features_or(ndev, __features) \
+		netdev_features_or(ndev->hw_features, __features)
+
+#define netdev_wanted_features_or(ndev, __features) \
+		netdev_features_or(ndev->wanted_features, __features)
+
+#define netdev_vlan_features_or(ndev, __features) \
+		netdev_features_or(ndev->vlan_features, __features)
+
+#define netdev_hw_enc_features_or(ndev, __features) \
+		netdev_features_or(ndev->hw_enc_features, __features)
+
+#define netdev_mpls_features_or(ndev, __features) \
+		netdev_features_or(ndev->mpls_features, __features)
+
+#define netdev_gso_partial_features_or(ndev, __features) \
+		netdev_features_or(ndev->gso_partial_features, __features)
+
+/* helpers for netdev features '|=' operation */
+static inline void
+netdev_features_set(netdev_features_t *dst, const netdev_features_t features)
+{
+	*dst = netdev_features_or(*dst, features);
+}
+
+static inline void
+netdev_active_features_set(struct net_device *ndev,
+			   const netdev_features_t features)
+{
+	ndev->features = netdev_active_features_or(ndev, features);
+}
+
+static inline void
+netdev_hw_features_set(struct net_device *ndev,
+		       const netdev_features_t features)
+{
+	ndev->hw_features = netdev_hw_features_or(ndev, features);
+}
+
+static inline void
+netdev_wanted_features_set(struct net_device *ndev,
+			   const netdev_features_t features)
+{
+	ndev->wanted_features = netdev_wanted_features_or(ndev, features);
+}
+
+static inline void
+netdev_vlan_features_set(struct net_device *ndev,
+			 const netdev_features_t features)
+{
+	ndev->vlan_features = netdev_vlan_features_or(ndev, features);
+}
+
+static inline void
+netdev_hw_enc_features_set(struct net_device *ndev,
+			   const netdev_features_t features)
+{
+	ndev->hw_enc_features = netdev_hw_enc_features_or(ndev, features);
+}
+
+static inline void
+netdev_mpls_features_set(struct net_device *ndev,
+			 const netdev_features_t features)
+{
+	ndev->mpls_features = netdev_mpls_features_or(ndev, features);
+}
+
+static inline void
+netdev_gso_partial_features_set(struct net_device *ndev,
+				const netdev_features_t features)
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
+#define netdev_active_features_xor(ndev, __features) \
+		netdev_features_xor(ndev->features, __features)
+
+#define netdev_hw_features_xor(ndev, __features) \
+		netdev_features_xor(ndev->hw_features, __features)
+
+#define netdev_wanted_features_xor(ndev, __features) \
+		netdev_features_xor(ndev->wanted_features, __features)
+
+#define netdev_vlan_features_xor(ndev, __features) \
+		netdev_features_xor(ndev->vlan_features, __features)
+
+#define netdev_hw_enc_features_xor(ndev, __features) \
+		netdev_features_xor(ndev->hw_enc_features, __features)
+
+#define netdev_mpls_features_xor(ndev, __features) \
+		netdev_features_xor(ndev->mpls_features, __features)
+
+#define netdev_gso_partial_features_xor(ndev, __features) \
+		netdev_features_xor(ndev->gso_partial_features, __features)
+
+/* helpers for netdev features '^=' operation */
+static inline void
+netdev_features_toggle(netdev_features_t *dst, const netdev_features_t features)
+{
+	*dst = netdev_features_xor(*dst, features);
+}
+
+static inline void
+netdev_active_features_toggle(struct net_device *ndev,
+			      const netdev_features_t features)
+{
+	ndev->features = netdev_active_features_xor(ndev, features);
+}
+
+static inline void
+netdev_hw_features_toggle(struct net_device *ndev,
+			      const netdev_features_t features)
+{
+	ndev->hw_features = netdev_hw_features_xor(ndev, features);
+}
+
+static inline void
+netdev_wanted_features_toggle(struct net_device *ndev,
+				  const netdev_features_t features)
+{
+	ndev->wanted_features = netdev_wanted_features_xor(ndev, features);
+}
+
+static inline void
+netdev_vlan_features_toggle(struct net_device *ndev,
+				const netdev_features_t features)
+{
+	ndev->vlan_features = netdev_vlan_features_xor(ndev, features);
+}
+
+static inline void
+netdev_hw_enc_features_toggle(struct net_device *ndev,
+			      const netdev_features_t features)
+{
+	ndev->hw_enc_features = netdev_hw_enc_features_xor(ndev, features);
+}
+
+static inline void
+netdev_mpls_features_toggle(struct net_device *ndev,
+			    const netdev_features_t features)
+{
+	ndev->mpls_features = netdev_mpls_features_xor(ndev, features);
+}
+
+static inline void
+netdev_gso_partial_features_toggle(struct net_device *ndev,
+				   const netdev_features_t features)
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
+#define netdev_active_features_andnot(ndev, __features) \
+		netdev_features_andnot(ndev->features, __features)
+
+#define netdev_hw_features_andnot(ndev, __features) \
+		netdev_features_andnot(ndev->hw_features, __features)
+
+#define netdev_wanted_features_andnot(ndev, __features) \
+		netdev_features_andnot(ndev->wanted_features, __features)
+
+#define netdev_vlan_features_andnot(ndev, __features) \
+		netdev_features_andnot(ndev->vlan_features, __features)
+
+#define netdev_hw_enc_features_andnot(ndev, __features) \
+		netdev_features_andnot(ndev->hw_enc_features, __features)
+
+#define netdev_mpls_features_andnot(ndev, __features) \
+		netdev_features_andnot(ndev->mpls_features, __features)
+
+#define netdev_gso_partial_features_andnot(ndev, __features) \
+		netdev_features_andnot(ndev->gso_partial_features, __features)
+
+#define netdev_active_features_andnot_r(ndev, __features) \
+		netdev_features_andnot(__features, ndev->features)
+
+#define netdev_hw_features_andnot_r(ndev, __features) \
+		netdev_features_andnot(__features, ndev->hw_features)
+
+#define netdev_wanted_features_andnot_r(ndev, __features) \
+		netdev_features_andnot(__features, ndev->wanted_features)
+
+#define netdev_vlan_features_andnot_r(ndev, __features) \
+		netdev_features_andnot(__features, ndev->vlan_features)
+
+#define netdev_hw_enc_features_andnot_r(ndev, __features) \
+		netdev_features_andnot(__features, ndev->hw_enc_features)
+
+#define netdev_mpls_features_andnot_r(ndev, __features) \
+		netdev_features_andnot(__features, ndev->mpls_features)
+
+#define netdev_gso_partial_features_andnot_r(ndev, __features) \
+		netdev_features_andnot(__features, ndev->gso_partial_features)
+
+static inline void
+netdev_features_clear(netdev_features_t *dst, const netdev_features_t features)
+{
+	*dst = netdev_features_andnot(*dst, features);
+}
+
+static inline void
+netdev_active_features_clear(struct net_device *ndev,
+			     const netdev_features_t features)
+{
+	ndev->features = netdev_active_features_andnot(ndev, features);
+}
+
+static inline void
+netdev_hw_features_clear(struct net_device *ndev,
+			 const netdev_features_t features)
+{
+	ndev->hw_features = netdev_hw_features_andnot(ndev, features);
+}
+
+static inline void
+netdev_wanted_features_clear(struct net_device *ndev,
+			     const netdev_features_t features)
+{
+	ndev->wanted_features = netdev_wanted_features_andnot(ndev, features);
+}
+
+static inline void
+netdev_vlan_features_clear(struct net_device *ndev,
+			   const netdev_features_t features)
+{
+	ndev->vlan_features = netdev_vlan_features_andnot(ndev, features);
+}
+
+static inline void
+netdev_hw_enc_features_clear(struct net_device *ndev,
+			     const netdev_features_t features)
+{
+	ndev->hw_enc_features = netdev_hw_enc_features_andnot(ndev, features);
+}
+
+static inline void
+netdev_mpls_features_clear(struct net_device *ndev,
+			   const netdev_features_t features)
+{
+	ndev->mpls_features = netdev_mpls_features_andnot(ndev, features);
+}
+
+static inline void
+netdev_gso_partial_features_clear(struct net_device *ndev,
+				  const netdev_features_t features)
+{
+	ndev->gso_partial_features =
+		netdev_gso_partial_features_andnot(ndev, features);
+}
+
+/* helpers for netdev features 'set bit' operation */
+static inline void netdev_feature_add(int nr, netdev_features_t *src)
+{
+	*src |= __NETIF_F_BIT(nr);
+}
+
+#define netdev_active_feature_add(ndev, nr) \
+		netdev_feature_add(nr, &ndev->features)
+
+#define netdev_hw_feature_add(ndev, nr) \
+		netdev_feature_add(nr, &ndev->hw_features)
+
+#define netdev_wanted_feature_add(ndev, nr) \
+		netdev_feature_add(nr, &ndev->wanted_features)
+
+#define netdev_vlan_feature_add(ndev, nr) \
+		netdev_feature_add(nr, &ndev->vlan_features)
+
+#define netdev_hw_enc_feature_add(ndev, nr) \
+		netdev_feature_add(nr, &ndev->hw_enc_features)
+
+#define netdev_mpls_feature_add(ndev, nr) \
+		netdev_feature_add(nr, &ndev->mpls_features)
+
+#define netdev_gso_partial_feature_add(ndev, nr) \
+		netdev_feature_add(nr, &ndev->gso_partial_features)
+
+/* helpers for netdev features 'set bit array' operation */
+static inline void
+netdev_features_set_array(const struct netdev_feature_set *set,
+			  netdev_features_t *dst)
+{
+	int i;
+
+	for (i = 0; i < set->cnt; i++)
+		netdev_feature_add(set->feature_bits[i], dst);
+}
+
+#define netdev_active_features_set_array(ndev, set) \
+		netdev_features_set_array(set, &ndev->features)
+
+#define netdev_hw_features_set_array(ndev, set) \
+		netdev_features_set_array(set, &ndev->hw_features)
+
+#define netdev_wanted_features_set_array(ndev, set) \
+		netdev_features_set_array(set, &ndev->wanted_features)
+
+#define netdev_vlan_features_set_array(ndev, set) \
+		netdev_features_set_array(set, &ndev->vlan_features)
+
+#define netdev_hw_enc_features_set_array(ndev, set) \
+		netdev_features_set_array(set, &ndev->hw_enc_features)
+
+#define netdev_mpls_features_set_array(ndev, set) \
+		netdev_features_set_array(set, &ndev->mpls_features)
+
+#define netdev_gso_partial_features_set_array(ndev, set) \
+		netdev_features_set_array(set, &ndev->gso_partial_features)
+
+/* helpers for netdev features 'clear bit' operation */
+static inline void netdev_feature_del(int nr, netdev_features_t *src)
+{
+	*src &= ~__NETIF_F_BIT(nr);
+}
+
+#define netdev_active_feature_del(ndev, nr) \
+		netdev_feature_del(nr, &ndev->features)
+
+#define netdev_hw_feature_del(ndev, nr) \
+		netdev_feature_del(nr, &ndev->hw_features)
+
+#define netdev_wanted_feature_del(ndev, nr) \
+		netdev_feature_del(nr, &ndev->wanted_features)
+
+#define netdev_vlan_feature_del(ndev, nr) \
+		netdev_feature_del(nr, &ndev->vlan_features)
+
+#define netdev_hw_enc_feature_del(ndev, nr) \
+		netdev_feature_del(nr, &ndev->hw_enc_features)
+
+#define netdev_mpls_feature_del(ndev, nr) \
+		netdev_feature_del(nr, &ndev->mpls_features)
+
+#define netdev_gso_partial_feature_del(ndev, nr) \
+		netdev_feature_del(nr, &ndev->gso_partial_features)
+
+static inline bool netdev_features_intersects(const netdev_features_t src1,
+					      const netdev_features_t src2)
+{
+	return (src1 & src2) > 0;
+}
+
+#define netdev_active_features_intersects(ndev, __features) \
+		netdev_features_intersects(ndev->features, __features)
+
+#define netdev_hw_features_intersects(ndev, __features) \
+		netdev_features_intersects(ndev->hw_features, __features)
+
+#define netdev_wanted_features_intersects(ndev, __features) \
+		netdev_features_intersects(ndev->wanted_features, __features)
+
+#define netdev_vlan_features_intersects(ndev, __features) \
+		netdev_features_intersects(ndev->vlan_features, __features)
+
+#define netdev_hw_enc_features_intersects(ndev, __features) \
+		netdev_features_intersects(ndev->hw_enc_features, __features)
+
+#define netdev_mpls_features_intersects(ndev, __features) \
+		netdev_features_intersects(ndev->mpls_features, __features)
+
+#define netdev_gso_partial_features_intersects(ndev, __features) \
+		netdev_features_intersects(ndev->gso_partial_features, __features)
+
+/* helpers for netdev features '=' operation */
+static inline void netdev_active_features_copy(struct net_device *netdev,
+					       const netdev_features_t src)
+{
+	netdev->features = src;
+}
+
+static inline void netdev_hw_features_copy(struct net_device *ndev,
+					   const netdev_features_t src)
+{
+	ndev->hw_features = src;
+}
+
+static inline void netdev_wanted_features_copy(struct net_device *ndev,
+					       const netdev_features_t src)
+{
+	ndev->wanted_features = src;
+}
+
+static inline void netdev_vlan_features_copy(struct net_device *ndev,
+					     const netdev_features_t src)
+{
+	ndev->vlan_features = src;
+}
+
+static inline void netdev_hw_enc_features_copy(struct net_device *ndev,
+					       const netdev_features_t src)
+{
+	ndev->hw_enc_features = src;
+}
+
+static inline void netdev_mpls_features_copy(struct net_device *ndev,
+					     const netdev_features_t src)
+{
+	ndev->mpls_features = src;
+}
+
+static inline void netdev_gso_partial_features_copy(struct net_device *ndev,
+						    const netdev_features_t src)
+{
+	ndev->gso_partial_features = src;
+}
+
+/* helpers for netdev features 'get' operation */
+#define netdev_active_features(ndev)	((ndev)->features)
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
+static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
+							  netdev_features_t f2)
+{
+	if ((f1 ^ f2) & NETIF_F_HW_CSUM) {
+		if (f1 & NETIF_F_HW_CSUM)
+			f1 |= (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
+		else
+			f2 |= (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
+	}
+
+	return f1 & f2;
+}
+
+static inline netdev_features_t
+netdev_get_wanted_features(struct net_device *dev)
+{
+	return (dev->features & ~dev->hw_features) | dev->wanted_features;
+}
+
+#endif
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7b2a0b739684..a092423653e2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2304,6 +2304,33 @@ struct net_device {
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
+/* helpers for netdev features 'test bit' operation */
+static inline bool netdev_feature_test(int nr, const netdev_features_t src)
+{
+	return (src & __NETIF_F_BIT(nr)) > 0;
+}
+
+#define netdev_active_feature_test(ndev, nr) \
+		netdev_feature_test(nr, ndev->features)
+
+#define netdev_hw_feature_test(ndev, nr) \
+		netdev_feature_test(nr, ndev->hw_features)
+
+#define netdev_wanted_feature_test(ndev, nr) \
+		netdev_feature_test(nr, ndev->wanted_features)
+
+#define netdev_vlan_feature_test(ndev, nr) \
+		netdev_feature_test(nr, ndev->vlan_features)
+
+#define netdev_hw_enc_feature_test(ndev, nr) \
+		netdev_feature_test(nr, ndev->hw_enc_features)
+
+#define netdev_mpls_feature_test(ndev, nr) \
+		netdev_feature_test(nr, ndev->mpls_features)
+
+#define netdev_gso_partial_feature_test(ndev, nr) \
+		netdev_feature_test(nr, ndev->gso_partial_features)
+
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
 	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
@@ -4815,24 +4842,6 @@ const char *netdev_drivername(const struct net_device *dev);
 
 void linkwatch_run_queue(void);
 
-static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
-							  netdev_features_t f2)
-{
-	if ((f1 ^ f2) & NETIF_F_HW_CSUM) {
-		if (f1 & NETIF_F_HW_CSUM)
-			f1 |= (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
-		else
-			f2 |= (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
-	}
-
-	return f1 & f2;
-}
-
-static inline netdev_features_t netdev_get_wanted_features(
-	struct net_device *dev)
-{
-	return (dev->features & ~dev->hw_features) | dev->wanted_features;
-}
 netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_t one, netdev_features_t mask);
 
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index e5d23e75572a..2c9b353f13e8 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -24,6 +24,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/phy.h>
 #include <net/arp.h>
 
diff --git a/net/core/dev.c b/net/core/dev.c
index d5a362d53b34..4d6b57752eee 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -88,6 +88,7 @@
 #include <linux/interrupt.h>
 #include <linux/if_ether.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/skbuff.h>
-- 
2.33.0

