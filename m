Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1863E5BBD1A
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiIRJuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiIRJt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:56 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440A811A29
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:48 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MVjf42Yp6zHnlP;
        Sun, 18 Sep 2022 17:47:40 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:46 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 01/55] net: introduce operation helpers for netdev features
Date:   Sun, 18 Sep 2022 09:42:42 +0000
Message-ID: <20220918094336.28958-2-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a set of bitmap operation helpers for netdev features,
then we can use them to replace the logical operation with them.

The implementation of these helpers are based on the old prototype
of netdev_features_t is still u64. These helpers will be rewritten
on the last patch, follow the prototype changes. For the new type
netdev_features_t maybe large than 8 bytes, use netdev_features_t
pointer as parameter.

To avoid interdependencies between netdev_features_helper.h and
netdevice.h, put the helpers for testing feature in the netdevice.h,
and move advandced helpers like netdev_get_wanted_features() and
netdev_intersect_features() to netdev_features_helper.h.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |   1 +
 include/linux/netdev_feature_helpers.h        | 607 ++++++++++++++++++
 include/linux/netdev_features.h               |  11 +
 include/linux/netdevice.h                     |  48 +-
 net/8021q/vlan_dev.c                          |   1 +
 net/core/dev.c                                |   1 +
 6 files changed, 651 insertions(+), 18 deletions(-)
 create mode 100644 include/linux/netdev_feature_helpers.h

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 8b77582bdfa0..8023a3f0d43b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -4,6 +4,7 @@
 #include <linux/etherdevice.h>
 #include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/lockdep.h>
+#include <linux/netdev_feature_helpers.h>
 #include <net/dst_metadata.h>
 
 #include "nfpcore/nfp_cpp.h"
diff --git a/include/linux/netdev_feature_helpers.h b/include/linux/netdev_feature_helpers.h
new file mode 100644
index 000000000000..4bb5de61e4e9
--- /dev/null
+++ b/include/linux/netdev_feature_helpers.h
@@ -0,0 +1,607 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Network device features helpers.
+ */
+#ifndef _LINUX_NETDEV_FEATURES_HELPER_H
+#define _LINUX_NETDEV_FEATURES_HELPER_H
+
+#include <linux/netdevice.h>
+
+static inline void __netdev_features_zero(netdev_features_t *dst)
+{
+	*dst = 0;
+}
+
+#define netdev_features_zero(features) __netdev_features_zero(&(features))
+
+/* active_feature prefer to netdev->features */
+#define netdev_active_features_zero(ndev) \
+		netdev_features_zero((ndev)->features)
+
+#define netdev_hw_features_zero(ndev) \
+		netdev_features_zero((ndev)->hw_features)
+
+#define netdev_wanted_features_zero(ndev) \
+		netdev_features_zero((ndev)->wanted_features)
+
+#define netdev_vlan_features_zero(ndev) \
+		netdev_features_zero((ndev)->vlan_features)
+
+#define netdev_hw_enc_features_zero(ndev) \
+		netdev_features_zero((ndev)->hw_enc_features)
+
+#define netdev_mpls_features_zero(ndev) \
+		netdev_features_zero((ndev)->mpls_features)
+
+#define netdev_gso_partial_features_zero(ndev) \
+		netdev_features_zero((ndev)->gso_partial_features)
+
+static inline void __netdev_features_fill(netdev_features_t *dst)
+{
+	*dst = ~0ULL;
+}
+
+#define netdev_features_fill(features) __netdev_features_fill(&(features))
+
+static inline bool __netdev_features_empty(const netdev_features_t *src)
+{
+	return *src == 0;
+}
+
+#define netdev_features_empty(features) __netdev_features_empty(&(features))
+
+#define netdev_active_features_empty(ndev) \
+		netdev_features_empty((ndev)->features)
+
+#define netdev_hw_features_empty(ndev) \
+		netdev_features_empty((ndev)->hw_features)
+
+#define netdev_wanted_features_empty(ndev) \
+		netdev_features_empty((ndev)->wanted_features)
+
+#define netdev_vlan_features_empty(ndev) \
+		netdev_features_empty((ndev)->vlan_features)
+
+#define netdev_hw_enc_features_empty(ndev) \
+		netdev_features_empty((ndev)->hw_enc_features)
+
+#define netdev_mpls_features_empty(ndev) \
+		netdev_features_empty((ndev)->mpls_features)
+
+#define netdev_gso_partial_features_empty(ndev) \
+		netdev_features_empty((ndev)->gso_partial_features)
+
+/* helpers for netdev features '==' operation */
+static inline bool __netdev_features_equal(const netdev_features_t *feats1,
+					   const netdev_features_t *feats2)
+{
+	return *feats1 == *feats2;
+}
+
+#define netdev_features_equal(feat1, feat2)	\
+			__netdev_features_equal(&(feat1), &(feat2))
+
+#define netdev_active_features_equal(ndev, __features) \
+		netdev_features_equal((ndev)->features, __features)
+
+#define netdev_hw_features_equal(ndev, __features) \
+		netdev_features_equal((ndev)->hw_features, __features)
+
+#define netdev_wanted_features_equal(ndev, __features) \
+		netdev_features_equal(ndev->wanted_features, __features)
+
+#define netdev_vlan_features_equal(ndev, __features) \
+		netdev_features_equal((ndev)->vlan_features, __features)
+
+#define netdev_hw_enc_features_equal(ndev, __features) \
+		netdev_features_equal((ndev)->hw_enc_features, __features)
+
+#define netdev_mpls_features_equal(ndev, __features) \
+		netdev_features_equal((ndev)->mpls_features, __features)
+
+#define netdev_gso_partial_features_equal(ndev, __features) \
+		netdev_features_equal((ndev)->gso_partial_features, __features)
+
+/* helpers for netdev features '&' operation */
+static inline bool
+__netdev_features_and(netdev_features_t *dst, const netdev_features_t *a,
+		      const netdev_features_t *b)
+{
+	*dst = *a & *b;
+	return *dst != 0;
+}
+
+#define netdev_features_and(dst, a, b) __netdev_features_and(&(dst), &(a), &(b))
+
+#define netdev_active_features_and(ndev, a, b) \
+		netdev_features_and((ndev)->features, a, b)
+
+#define netdev_hw_features_and(ndev, a, b) \
+		netdev_features_and((ndev)->hw_features, a, b)
+
+#define netdev_wanted_features_and(ndev, a, b) \
+		netdev_features_and((ndev)->wanted_features, a, b)
+
+#define netdev_vlan_features_and(ndev, a, b) \
+		netdev_features_and((ndev)->vlan_features, a, b)
+
+#define netdev_hw_enc_features_and(ndev, a, b) \
+		netdev_features_and((ndev)->hw_enc_features, a, b)
+
+#define netdev_mpls_features_and(ndev, a, b) \
+		netdev_features_and((ndev)->mpls_features, a, b)
+
+#define netdev_gso_partial_features_and(ndev, a, b) \
+		netdev_features_and((ndev)->gso_partial_features, a, b)
+
+/* helpers for netdev features '&=' operation */
+static inline bool
+__netdev_features_mask(netdev_features_t *dst,
+		       const netdev_features_t *features)
+{
+	return __netdev_features_and(dst, dst, features);
+}
+
+#define netdev_features_mask(dst, __features)	\
+	__netdev_features_mask(&(dst), &(__features))
+
+#define netdev_active_features_mask(ndev, __features) \
+		netdev_features_mask((ndev)->features, __features)
+
+#define netdev_hw_features_mask(ndev, __features) \
+		netdev_features_mask((ndev)->hw_features, __features)
+
+#define netdev_wanted_features_mask(ndev, __features) \
+		netdev_features_mask((ndev)->wanted_features, __features)
+
+#define netdev_vlan_features_mask(ndev, __features) \
+		netdev_features_mask((ndev)->vlan_features, __features)
+
+#define netdev_hw_enc_features_mask(ndev, __features) \
+		netdev_features_mask((ndev)->hw_enc_features, __features)
+
+#define netdev_mpls_features_mask(ndev, __features) \
+		netdev_features_mask((ndev)->mpls_features, __features)
+
+#define netdev_gso_partial_features_mask(ndev, __features) \
+		netdev_features_mask((ndev)->gso_partial_features, __features)
+
+/* helpers for netdev features '|' operation */
+static inline void
+__netdev_features_or(netdev_features_t *dst, const netdev_features_t *a,
+		     const netdev_features_t *b)
+{
+	*dst = *a | *b;
+}
+
+#define netdev_features_or(dst, a, b) __netdev_features_or(&(dst), &(a), &(b))
+
+#define netdev_active_features_or(ndev, a, b) \
+		netdev_features_or((ndev)->features, a, b)
+
+#define netdev_hw_features_or(ndev, a, b) \
+		netdev_features_or((ndev)->hw_features, a, b)
+
+#define netdev_wanted_features_or(ndev, a, b) \
+		netdev_features_or((ndev)->wanted_features, a, b)
+
+#define netdev_vlan_features_or(ndev, a, b) \
+		netdev_features_or((ndev)->vlan_features, a, b)
+
+#define netdev_hw_enc_features_or(ndev, a, b) \
+		netdev_features_or((ndev)->hw_enc_features, a, b)
+
+#define netdev_mpls_features_or(ndev, a, b) \
+		netdev_features_or((ndev)->mpls_features, a, b)
+
+#define netdev_gso_partial_features_or(ndev, a, b) \
+		netdev_features_or((ndev)->gso_partial_features, a, b)
+
+/* helpers for netdev features '|=' operation */
+static inline void
+__netdev_features_set(netdev_features_t *dst, const netdev_features_t *features)
+{
+	__netdev_features_or(dst, dst, features);
+}
+
+#define netdev_features_set(dst, __features)	\
+		__netdev_features_set(&(dst), &(__features))
+
+#define netdev_active_features_set(ndev, __features) \
+		netdev_features_set((ndev)->features, __features)
+
+#define netdev_hw_features_set(ndev, __features) \
+		netdev_features_set((ndev)->hw_features, __features)
+
+#define netdev_wanted_features_set(ndev, __features) \
+		netdev_features_set((ndev)->wanted_features, __features)
+
+#define netdev_vlan_features_set(ndev, __features) \
+		netdev_features_set((ndev)->vlan_features, __features)
+
+#define netdev_hw_enc_features_set(ndev, __features) \
+		netdev_features_set((ndev)->hw_enc_features, __features)
+
+#define netdev_mpls_features_set(ndev, __features) \
+		netdev_features_set((ndev)->mpls_features, __features)
+
+#define netdev_gso_partial_features_set(ndev, __features) \
+		netdev_features_set((ndev)->gso_partial_features, __features)
+
+static inline void __netdev_feature_change(int nr, netdev_features_t *src)
+{
+	if (*src & __NETIF_F_BIT(nr))
+		*src &= ~(__NETIF_F_BIT(nr));
+	else
+		*src |= __NETIF_F_BIT(nr);
+}
+
+#define netdev_feature_change(nr, src)	\
+		__netdev_feature_change(nr, &(src))
+
+#define netdev_active_feature_change(ndev, nr) \
+		netdev_feature_change(nr, (ndev)->features)
+
+#define netdev_hw_feature_change(ndev, nr) \
+		netdev_feature_change(nr, (ndev)->hw_features)
+
+#define netdev_wanted_feature_change(ndev, nr) \
+		netdev_feature_change(nr, (ndev)->wanted_features)
+
+#define netdev_vlan_feature_change(ndev, nr) \
+		netdev_feature_change(nr, (ndev)->vlan_features)
+
+#define netdev_hw_enc_feature_change(ndev, nr) \
+		netdev_feature_change(nr, (ndev)->hw_enc_features)
+
+#define netdev_mpls_feature_change(ndev, nr) \
+		netdev_feature_change(nr, (ndev)->mpls_features)
+
+#define netdev_gso_partial_feature_change(ndev, nr) \
+		netdev_feature_change(nr, (ndev)->gso_partial_features)
+
+/* helpers for netdev features '^' operation */
+static inline void
+__netdev_features_xor(netdev_features_t *dst, const netdev_features_t *a,
+		      const netdev_features_t *b)
+{
+	*dst = *a ^ *b;
+}
+
+#define netdev_features_xor(dst, a, b) __netdev_features_xor(&(dst), &(a), &(b))
+
+#define netdev_active_features_xor(ndev, a, b) \
+		netdev_features_xor((ndev)->features, a, b)
+
+#define netdev_hw_features_xor(ndev, a, b) \
+		netdev_features_xor((ndev)->hw_features, a, b)
+
+#define netdev_wanted_features_xor(ndev, a, b) \
+		netdev_features_xor((ndev)->wanted_features, a, b)
+
+#define netdev_vlan_features_xor(ndev, a, b) \
+		netdev_features_xor((ndev)->vlan_features, a, b)
+
+#define netdev_hw_enc_features_xor(ndev, a, b) \
+		netdev_features_xor((ndev)->hw_enc_features, a, b)
+
+#define netdev_mpls_features_xor(ndev, a, b) \
+		netdev_features_xor((ndev)->mpls_features, a, b)
+
+#define netdev_gso_partial_features_xor(ndev, a, b) \
+		netdev_features_xor((ndev)->gso_partial_features, a, b)
+
+/* helpers for netdev features '^=' operation */
+static inline void
+__netdev_features_toggle(netdev_features_t *dst,
+			 const netdev_features_t *features)
+{
+	__netdev_features_xor(dst, dst, features);
+}
+
+#define netdev_features_toggle(dst, __features)	\
+		__netdev_features_toggle(&(dst), &(__features))
+
+#define netdev_active_features_toggle(ndev, __features) \
+		netdev_features_toggle((ndev)->features, __features)
+
+#define netdev_hw_features_toggle(ndev, __features) \
+		netdev_features_toggle((ndev)->hw_features, __features)
+
+#define netdev_wanted_features_toggle(ndev, __features) \
+		netdev_features_toggle((ndev)->wanted_features, __features)
+
+#define netdev_vlan_features_toggle(ndev, __features) \
+		netdev_features_toggle((ndev)->vlan_features, __features)
+
+#define netdev_hw_enc_features_toggle(ndev, __features) \
+		netdev_features_toggle((ndev)->hw_enc_features, __features)
+
+#define netdev_mpls_features_toggle(ndev, __features) \
+		netdev_features_toggle((ndev)->mpls_features, __features)
+
+#define netdev_gso_partial_features_toggle(ndev, __features) \
+		netdev_features_toggle((ndev)->gso_partial_features, __features)
+
+/* helpers for netdev features '& ~' operation */
+static inline bool
+__netdev_features_andnot(netdev_features_t *dst, const netdev_features_t *a,
+			 const netdev_features_t *b)
+{
+	*dst = *a & ~(*b);
+	return *dst == 0;
+}
+
+#define netdev_features_andnot(dst, a, b)	\
+		__netdev_features_andnot(&(dst), &(a), &(b))
+
+#define netdev_active_features_andnot(ndev, a, b) \
+		netdev_features_andnot((ndev)->features, a, b)
+
+#define netdev_hw_features_andnot(ndev, a, b) \
+		netdev_features_andnot((ndev)->hw_features, a, b)
+
+#define netdev_wanted_features_andnot(ndev, a, b) \
+		netdev_features_andnot((ndev)->wanted_features, a, b)
+
+#define netdev_vlan_features_andnot(ndev, a, b) \
+		netdev_features_andnot((ndev)->vlan_features, a, b)
+
+#define netdev_hw_enc_features_andnot(ndev, a, b) \
+		netdev_features_andnot((ndev)->hw_enc_features, a, b)
+
+#define netdev_mpls_features_andnot(ndev, a, b) \
+		netdev_features_andnot((ndev)->mpls_features, a, b)
+
+#define netdev_gso_partial_features_andnot(ndev, a, b) \
+		netdev_features_andnot((ndev)->gso_partial_features, a, b)
+
+static inline void
+__netdev_features_clear(netdev_features_t *dst,
+			const netdev_features_t *features)
+{
+	__netdev_features_andnot(dst, dst, features);
+}
+
+#define netdev_features_clear(dst, __features)	\
+		__netdev_features_clear(&(dst), &(__features))
+
+#define netdev_active_features_clear(ndev, __features) \
+		netdev_features_clear((ndev)->features, __features)
+
+#define netdev_hw_features_clear(ndev, __features) \
+		netdev_features_clear((ndev)->hw_features, __features)
+
+#define netdev_wanted_features_clear(ndev, __features) \
+		netdev_features_clear((ndev)->wanted_features, __features)
+
+#define netdev_vlan_features_clear(ndev, __features) \
+		netdev_features_clear((ndev)->vlan_features, __features)
+
+#define netdev_hw_enc_features_clear(ndev, __features) \
+		netdev_features_clear((ndev)->hw_enc_features, __features)
+
+#define netdev_mpls_features_clear(ndev, __features) \
+		netdev_features_clear((ndev)->mpls_features, __features)
+
+#define netdev_gso_partial_features_clear(ndev, __features) \
+		netdev_features_clear((ndev)->gso_partial_features, __features)
+
+/* helpers for netdev features 'set bit' operation */
+static inline void __netdev_feature_add(int nr, netdev_features_t *src)
+{
+	*src |= __NETIF_F_BIT(nr);
+}
+
+#define netdev_feature_add(nr, src) __netdev_feature_add(nr, &(src))
+
+#define netdev_active_feature_add(ndev, nr) \
+		netdev_feature_add(nr, (ndev)->features)
+
+#define netdev_hw_feature_add(ndev, nr) \
+		netdev_feature_add(nr, (ndev)->hw_features)
+
+#define netdev_wanted_feature_add(ndev, nr) \
+		netdev_feature_add(nr, (ndev)->wanted_features)
+
+#define netdev_vlan_feature_add(ndev, nr) \
+		netdev_feature_add(nr, (ndev)->vlan_features)
+
+#define netdev_hw_enc_feature_add(ndev, nr) \
+		netdev_feature_add(nr, (ndev)->hw_enc_features)
+
+#define netdev_mpls_feature_add(ndev, nr) \
+		netdev_feature_add(nr, (ndev)->mpls_features)
+
+#define netdev_gso_partial_feature_add(ndev, nr) \
+		netdev_feature_add(nr, (ndev)->gso_partial_features)
+
+/* helpers for netdev features 'set bit array' operation */
+static inline void
+__netdev_features_set_array(const struct netdev_feature_set *set,
+			    netdev_features_t *dst)
+{
+	unsigned int i;
+
+	for (i = 0; i < set->cnt; i++)
+		__netdev_feature_add(set->feature_bits[i], dst);
+}
+
+#define netdev_features_set_array(set, dst) \
+		__netdev_features_set_array(set, &(dst))
+
+#define netdev_active_features_set_array(ndev, set) \
+		netdev_features_set_array(set, (ndev)->features)
+
+#define netdev_hw_features_set_array(ndev, set) \
+		netdev_features_set_array(set, (ndev)->hw_features)
+
+#define netdev_wanted_features_set_array(ndev, set) \
+		netdev_features_set_array(set, (ndev)->wanted_features)
+
+#define netdev_vlan_features_set_array(ndev, set) \
+		netdev_features_set_array(set, (ndev)->vlan_features)
+
+#define netdev_hw_enc_features_set_array(ndev, set) \
+		netdev_features_set_array(set, (ndev)->hw_enc_features)
+
+#define netdev_mpls_features_set_array(ndev, set) \
+		netdev_features_set_array(set, (ndev)->mpls_features)
+
+#define netdev_gso_partial_features_set_array(ndev, set) \
+		netdev_features_set_array(set, (ndev)->gso_partial_features)
+
+/* helpers for netdev features 'clear bit' operation */
+static inline void __netdev_feature_del(int nr, netdev_features_t *src)
+{
+	*src &= ~__NETIF_F_BIT(nr);
+}
+
+#define netdev_feature_del(nr, src) __netdev_feature_del(nr, &(src))
+
+#define netdev_active_feature_del(ndev, nr) \
+		netdev_feature_del(nr, (ndev)->features)
+
+#define netdev_hw_feature_del(ndev, nr) \
+		netdev_feature_del(nr, (ndev)->hw_features)
+
+#define netdev_wanted_feature_del(ndev, nr) \
+		netdev_feature_del(nr, (ndev)->wanted_features)
+
+#define netdev_vlan_feature_del(ndev, nr) \
+		netdev_feature_del(nr, (ndev)->vlan_features)
+
+#define netdev_hw_enc_feature_del(ndev, nr) \
+		netdev_feature_del(nr, (ndev)->hw_enc_features)
+
+#define netdev_mpls_feature_del(ndev, nr) \
+		netdev_feature_del(nr, (ndev)->mpls_features)
+
+#define netdev_gso_partial_feature_del(ndev, nr) \
+		netdev_feature_del(nr, (ndev)->gso_partial_features)
+
+/* helpers for netdev features 'clear bit array' operation */
+static inline void
+__netdev_features_clear_array(const struct netdev_feature_set *set,
+			      netdev_features_t *dst)
+{
+	unsigned int i;
+
+	for (i = 0; i < set->cnt; i++)
+		__netdev_feature_del(set->feature_bits[i], dst);
+}
+
+#define netdev_features_clear_array(set, dst) \
+		__netdev_features_clear_array(set, &(dst))
+
+#define netdev_active_features_clear_array(ndev, set) \
+		netdev_features_clear_array(set, (ndev)->features)
+
+#define netdev_hw_features_clear_array(ndev, set) \
+		netdev_features_clear_array(set, (ndev)->hw_features)
+
+#define netdev_wanted_features_clear_array(ndev, set) \
+		netdev_features_clear_array(set, (ndev)->wanted_features)
+
+#define netdev_vlan_features_clear_array(ndev, set) \
+		netdev_features_clear_array(set, (ndev)->vlan_features)
+
+#define netdev_hw_enc_features_clear_array(ndev, set) \
+		netdev_features_clear_array(set, (ndev)->hw_enc_features)
+
+#define netdev_mpls_features_clear_array(ndev, set) \
+		netdev_features_set_array(set, (ndev)->mpls_features)
+
+#define netdev_gso_partial_features_clear_array(ndev, set) \
+		netdev_features_clear_array(set, (ndev)->gso_partial_features)
+
+static inline bool __netdev_features_intersects(const netdev_features_t *feats1,
+						const netdev_features_t *feats2)
+{
+	return (*feats1 & *feats2) > 0;
+}
+
+#define netdev_features_intersects(feats1, feats2)	\
+		__netdev_features_intersects(&(feats1), &(feats2))
+
+#define netdev_active_features_intersects(ndev, __features) \
+		netdev_features_intersects((ndev)->features, __features)
+
+#define netdev_hw_features_intersects(ndev, __features) \
+		netdev_features_intersects((ndev)->hw_features, __features)
+
+#define netdev_wanted_features_intersects(ndev, __features) \
+		netdev_features_intersects((ndev)->wanted_features, __features)
+
+#define netdev_vlan_features_intersects(ndev, __features) \
+		netdev_features_intersects((ndev)->vlan_features, __features)
+
+#define netdev_hw_enc_features_intersects(ndev, __features) \
+		netdev_features_intersects((ndev)->hw_enc_features, __features)
+
+#define netdev_mpls_features_intersects(ndev, __features) \
+		netdev_features_intersects((ndev)->mpls_features, __features)
+
+#define netdev_gso_partial_features_intersects(ndev, __features) \
+		netdev_features_intersects((ndev)->gso_partial_features, __features)
+
+/* helpers for netdev features '=' operation */
+static inline void __netdev_features_copy(netdev_features_t *dst,
+					  const netdev_features_t *src)
+{
+	*dst = *src;
+}
+
+#define netdev_features_copy(dst, src)	__netdev_features_copy(&(dst), &(src))
+
+#define netdev_active_features_copy(ndev, __features)	\
+		netdev_features_copy((ndev)->features, __features)
+
+#define netdev_hw_features_copy(ndev, __features)	\
+		netdev_features_copy((ndev)->hw_features, __features)
+
+#define netdev_wanted_features_copy(ndev, __features)	\
+		netdev_features_copy((ndev)->wanted_features, __features)
+
+#define netdev_vlan_features_copy(ndev, __features)	\
+		netdev_features_copy((ndev)->vlan_features, __features)
+
+#define netdev_hw_enc_features_copy(ndev, __features)	\
+		netdev_features_copy((ndev)->hw_enc_features, __features)
+
+#define netdev_mpls_features_copy(ndev, __features)	\
+		netdev_features_copy((ndev)->mpls_features, __features)
+
+#define netdev_gso_partial_features_copy(ndev, __features)	\
+		netdev_features_copy((ndev)->gso_partial_features, __features)
+
+/* helpers for netdev features 'subset' */
+static inline bool __netdev_features_subset(const netdev_features_t *feats1,
+					    const netdev_features_t *feats2)
+{
+	return (*feats1 & *feats2) == *feats2;
+}
+
+#define netdev_features_subset(feats1, feats2)	\
+		__netdev_features_subset(&(feats1), &(feats2))
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
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 7c2d77d75a88..9d434b4e6e6e 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -11,6 +11,17 @@
 
 typedef u64 netdev_features_t;
 
+struct netdev_feature_set {
+	unsigned int cnt;
+	unsigned short feature_bits[];
+};
+
+#define DECLARE_NETDEV_FEATURE_SET(name, features...)			\
+	const struct netdev_feature_set name = {			\
+		.cnt = sizeof((unsigned short[]){ features }) / sizeof(unsigned short),	\
+		.feature_bits = { features },				\
+	}
+
 enum {
 	NETIF_F_SG_BIT,			/* Scatter/gather IO. */
 	NETIF_F_IP_CSUM_BIT,		/* Can checksum TCP/UDP over IPv4. */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f0068c1ff1df..9bbab3856347 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2345,6 +2345,36 @@ struct net_device {
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
+/* helpers for netdev features 'test bit' operation */
+static inline bool __netdev_feature_test(int nr, const netdev_features_t *src)
+{
+	return (*src & __NETIF_F_BIT(nr)) > 0;
+}
+
+#define netdev_feature_test(nr, __features)	\
+		__netdev_feature_test(nr, &(__features))
+
+#define netdev_active_feature_test(ndev, nr) \
+		netdev_feature_test(nr, (ndev)->features)
+
+#define netdev_hw_feature_test(ndev, nr) \
+		netdev_feature_test(nr, (ndev)->hw_features)
+
+#define netdev_wanted_feature_test(ndev, nr) \
+		netdev_feature_test(nr, (ndev)->wanted_features)
+
+#define netdev_vlan_feature_test(ndev, nr) \
+		netdev_feature_test(nr, (ndev)->vlan_features)
+
+#define netdev_hw_enc_feature_test(ndev, nr) \
+		netdev_feature_test(nr, (ndev)->hw_enc_features)
+
+#define netdev_mpls_feature_test(ndev, nr) \
+		netdev_feature_test(nr, (ndev)->mpls_features)
+
+#define netdev_gso_partial_feature_test(ndev, nr) \
+		netdev_feature_test(nr, (ndev)->gso_partial_features)
+
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
 	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
@@ -4860,24 +4890,6 @@ extern const struct kobj_ns_type_operations net_ns_type_operations;
 
 const char *netdev_drivername(const struct net_device *dev);
 
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
index e1bb41a443c4..7940074bdb27 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/net_tstamp.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
diff --git a/net/core/dev.c b/net/core/dev.c
index d66c73c1c734..fdae614ecffa 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -88,6 +88,7 @@
 #include <linux/interrupt.h>
 #include <linux/if_ether.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/skbuff.h>
-- 
2.33.0

