Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE8241C931
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345753AbhI2QCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:22 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23242 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344197AbhI2P7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:43 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLbl5WkJz8tSw;
        Wed, 29 Sep 2021 23:57:07 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:00 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:58 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 023/167] net: add netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:10 +0800
Message-ID: <20210929155334.12454-24-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the prototype of netdev_features_t will be changed from
u64 to unsigned long *, so it's necessary to add a set of
helpers to do the logic operation.

This is a temporary patch, used to compatible with the
current prototype of netdev_features_t. The parameters styles
are not consistent for among these helpers, in order to minimize
the modification when change the netdev_features_t to bitmap.

It also introduce a new macro NETDEV_FEATURE_DWORDS, used for
scenario define the features as an array, so it can be
initialized when define structure.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 include/linux/netdev_features.h | 135 ++++++++++++++++++++++++++++++++
 1 file changed, 135 insertions(+)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 2c6b9e416225..b3fa05c88eef 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -101,6 +101,8 @@ enum {
 	/**/NETDEV_FEATURE_COUNT
 };
 
+#define NETDEV_FEATURE_DWORDS	DIV_ROUND_UP(NETDEV_FEATURE_COUNT, 64)
+
 /* copy'n'paste compression ;) */
 #define __NETIF_F_BIT(bit)	((netdev_features_t)1 << (bit))
 #define __NETIF_F(name)		__NETIF_F_BIT(NETIF_F_##name##_BIT)
@@ -261,4 +263,137 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 				 NETIF_F_GSO_UDP_TUNNEL |		\
 				 NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
+static inline void netdev_feature_zero(netdev_features_t *dst)
+{
+	*dst = 0;
+}
+
+static inline void netdev_feature_fill(netdev_features_t *dst)
+{
+	*dst = ~0;
+}
+
+static inline void netdev_feature_copy(netdev_features_t *dst,
+				       const netdev_features_t src)
+{
+	*dst = src;
+}
+
+static inline void netdev_feature_and(netdev_features_t *dst,
+				      const netdev_features_t a,
+				      const netdev_features_t b)
+{
+	*dst = a & b;
+}
+
+static inline void netdev_feature_or(netdev_features_t *dst,
+				     const netdev_features_t a,
+				     const netdev_features_t b)
+{
+	*dst = a | b;
+}
+
+static inline void netdev_feature_xor(netdev_features_t *dst,
+				      const netdev_features_t a,
+				      const netdev_features_t b)
+{
+	*dst = a ^ b;
+}
+
+static inline bool netdev_feature_empty(netdev_features_t src)
+{
+	return src == 0;
+}
+
+static inline bool netdev_feature_equal(const netdev_features_t src1,
+					const netdev_features_t src2)
+{
+	return src1 == src2;
+}
+
+static inline int netdev_feature_andnot(netdev_features_t *dst,
+					const netdev_features_t src1,
+					const netdev_features_t src2)
+{
+	*dst = src1 & ~src2;
+	return 0;
+}
+
+static inline void netdev_feature_set_bit(int nr, netdev_features_t *addr)
+{
+	*addr |= __NETIF_F_BIT(nr);
+}
+
+static inline void netdev_feature_clear_bit(int nr, netdev_features_t *addr)
+{
+	*addr &= ~(__NETIF_F_BIT(nr));
+}
+
+static inline void netdev_feature_mod_bit(int nr, netdev_features_t *addr,
+					  int set)
+{
+	if (set)
+		netdev_feature_set_bit(nr, addr);
+	else
+		netdev_feature_clear_bit(nr, addr);
+}
+
+static inline void netdev_feature_change_bit(int nr, netdev_features_t *addr)
+{
+	*addr ^= __NETIF_F_BIT(nr);
+}
+
+static inline int netdev_feature_test_bit(int nr, const netdev_features_t addr)
+{
+	return (addr & __NETIF_F_BIT(nr)) > 0;
+}
+
+static inline void netdev_feature_set_bit_array(const int *array,
+						int array_size,
+						netdev_features_t *addr)
+{
+	int i;
+
+	for (i = 0; i < array_size; i++)
+		netdev_feature_set_bit(array[i], addr);
+}
+
+/* only be used for the first 64 bits features */
+static inline void netdev_feature_set_bits(u64 bits, netdev_features_t *addr)
+{
+	*addr |= bits;
+}
+
+/* only be used for the first 64 bits features */
+static inline void netdev_feature_clear_bits(u64 bits, netdev_features_t *addr)
+{
+	*addr &= ~bits;
+}
+
+/* only be used for the first 64 bits features */
+static inline bool netdev_feature_test_bits(u64 bits,
+					    const netdev_features_t addr)
+{
+	return (addr & bits) > 0;
+}
+
+/* only be used for the first 64 bits features */
+static inline void netdev_feature_and_bits(u64 bits,
+					   netdev_features_t *addr)
+{
+	*addr &= bits;
+}
+
+static inline int netdev_feature_intersects(const netdev_features_t src1,
+					    const netdev_features_t src2)
+{
+	return (src1 & src2) > 0;
+}
+
+static inline int netdev_feature_subset(const netdev_features_t src1,
+					const netdev_features_t src2)
+{
+	return (src1 & src2) == src2;
+}
+
 #endif	/* _LINUX_NETDEV_FEATURES_H */
-- 
2.33.0

