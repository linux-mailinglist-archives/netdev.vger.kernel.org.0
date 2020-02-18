Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB7A016349E
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 22:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgBRVRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 16:17:44 -0500
Received: from gateway34.websitewelcome.com ([192.185.149.72]:43186 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726339AbgBRVRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 16:17:43 -0500
X-Greylist: delayed 1397 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Feb 2020 16:17:42 EST
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 54A1797BC8
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 14:54:24 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 49sujF7wWRP4z49sujfWl4; Tue, 18 Feb 2020 14:54:24 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=m4fWlpkqGiGuCYq5elOi8k6r3NJ/jeu5oJZInYcenKg=; b=CbuBpuY1RBhmt3aSkHVvglrEFB
        NWBgDXbzUc+YN0NGI+uFQenAPZE0fBuTDXDRIAPZa2Cf7edonY7fc59bQOA3e+hUzZtShQC3QzRxO
        GkteRxVCqTi1LMT56/4A45lovmPF2p8lPOfdqx0o7Hu6un4mfBBVmq7Tuh9Vb0cD4x9QBe2WnJLoc
        DWgv/NPykULMwwCFMWeiZuokAiOeAG1Pati6ViMkSBMQ0oRWG2Z/5lkaRcs/ZctK7cfGRR9LbRwCB
        MtNBLAwZq0mB0XkwwuUFkZNPa6EY4pEf21tPwkOLnmTbpTjR9ErMFR78LQWZECp5jmYXwHcAGQ/tZ
        +lY7NUyg==;
Received: from [200.68.140.26] (port=12800 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j49ss-000Tu7-TY; Tue, 18 Feb 2020 14:54:23 -0600
Date:   Tue, 18 Feb 2020 14:57:05 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] mlxsw: Replace zero-length array with flexible-array
 member
Message-ID: <20200218205705.GA29805@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 200.68.140.26
X-Source-L: No
X-Exim-ID: 1j49ss-000Tu7-TY
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.26]:12800
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 18
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c                    | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c      | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c          | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c          | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c            | 4 ++--
 .../net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c   | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c       | 4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h       | 4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_kvdl.c           | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c             | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c            | 2 +-
 11 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index e9f791c43f20..0d630096a28c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -82,7 +82,7 @@ struct mlxsw_core {
 	struct mlxsw_core_port *ports;
 	unsigned int max_ports;
 	bool fw_flash_in_progress;
-	unsigned long driver_priv[0];
+	unsigned long driver_priv[];
 	/* driver_priv has to be always the last item */
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
index feb4672a5ac0..bd2207f60722 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
@@ -72,7 +72,7 @@ struct mlxsw_afk_key_info {
 						      * is index inside "blocks"
 						      */
 	struct mlxsw_afk_element_usage elusage;
-	const struct mlxsw_afk_block *blocks[0];
+	const struct mlxsw_afk_block *blocks[];
 };
 
 static bool
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c
index 09ee0a807747..a9fff8adc75e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c
@@ -60,7 +60,7 @@ static const struct mlxsw_sp1_kvdl_part_info mlxsw_sp1_kvdl_parts_info[] = {
 
 struct mlxsw_sp1_kvdl_part {
 	struct mlxsw_sp1_kvdl_part_info info;
-	unsigned long usage[0];	/* Entries */
+	unsigned long usage[];	/* Entries */
 };
 
 struct mlxsw_sp1_kvdl {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c
index 8d14770766b4..3a73d654017f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c
@@ -45,7 +45,7 @@ struct mlxsw_sp2_kvdl_part {
 	unsigned int usage_bit_count;
 	unsigned int indexes_per_usage_bit;
 	unsigned int last_allocated_bit;
-	unsigned long usage[0];	/* Usage bits */
+	unsigned long usage[];	/* Usage bits */
 };
 
 struct mlxsw_sp2_kvdl {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 3d3cca596116..9368b93dab38 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -58,7 +58,7 @@ struct mlxsw_sp_acl_ruleset {
 	struct mlxsw_sp_acl_ruleset_ht_key ht_key;
 	struct rhashtable rule_ht;
 	unsigned int ref_count;
-	unsigned long priv[0];
+	unsigned long priv[];
 	/* priv has to be always the last item */
 };
 
@@ -71,7 +71,7 @@ struct mlxsw_sp_acl_rule {
 	u64 last_used;
 	u64 last_packets;
 	u64 last_bytes;
-	unsigned long priv[0];
+	unsigned long priv[];
 	/* priv has to be always the last item */
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
index 3a2de13fcb68..dbd3bebf11ec 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
@@ -13,7 +13,7 @@
 struct mlxsw_sp_acl_bf {
 	struct mutex lock; /* Protects Bloom Filter updates. */
 	unsigned int bank_size;
-	refcount_t refcnt[0];
+	refcount_t refcnt[];
 };
 
 /* Bloom filter uses a crc-16 hash over chunks of data which contain 4 key
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index e993159e8e4c..430da69003d8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -224,7 +224,7 @@ struct mlxsw_sp_acl_tcam_vchunk;
 struct mlxsw_sp_acl_tcam_chunk {
 	struct mlxsw_sp_acl_tcam_vchunk *vchunk;
 	struct mlxsw_sp_acl_tcam_region *region;
-	unsigned long priv[0];
+	unsigned long priv[];
 	/* priv has to be always the last item */
 };
 
@@ -243,7 +243,7 @@ struct mlxsw_sp_acl_tcam_vchunk {
 struct mlxsw_sp_acl_tcam_entry {
 	struct mlxsw_sp_acl_tcam_ventry *ventry;
 	struct mlxsw_sp_acl_tcam_chunk *chunk;
-	unsigned long priv[0];
+	unsigned long priv[];
 	/* priv has to be always the last item */
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h
index 5965913565a5..96437992b102 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h
@@ -20,7 +20,7 @@ struct mlxsw_sp_acl_tcam {
 	struct mutex lock; /* guards vregion list */
 	struct list_head vregion_list;
 	u32 vregion_rehash_intrvl;   /* ms */
-	unsigned long priv[0];
+	unsigned long priv[];
 	/* priv has to be always the last item */
 };
 
@@ -86,7 +86,7 @@ struct mlxsw_sp_acl_tcam_region {
 	char tcam_region_info[MLXSW_REG_PXXX_TCAM_REGION_INFO_LEN];
 	struct mlxsw_afk_key_info *key_info;
 	struct mlxsw_sp *mlxsw_sp;
-	unsigned long priv[0];
+	unsigned long priv[];
 	/* priv has to be always the last item */
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_kvdl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_kvdl.c
index 1e4cdee7bcd7..715ec8ecacba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_kvdl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_kvdl.c
@@ -8,7 +8,7 @@
 
 struct mlxsw_sp_kvdl {
 	const struct mlxsw_sp_kvdl_ops *kvdl_ops;
-	unsigned long priv[0];
+	unsigned long priv[];
 	/* priv has to be always the last item */
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
index 54275624718b..423eedebcd22 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
@@ -68,7 +68,7 @@ struct mlxsw_sp_mr_table {
 	struct list_head route_list;
 	struct rhashtable route_ht;
 	const struct mlxsw_sp_mr_table_ops *ops;
-	char catchall_route_priv[0];
+	char catchall_route_priv[];
 	/* catchall_route_priv has to be always the last item */
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
index 2153bcc4b585..16a130c2f21c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
@@ -67,7 +67,7 @@ struct mlxsw_sp_nve_mc_record {
 	struct mlxsw_sp_nve_mc_list *mc_list;
 	const struct mlxsw_sp_nve_mc_record_ops *ops;
 	u32 kvdl_index;
-	struct mlxsw_sp_nve_mc_entry entries[0];
+	struct mlxsw_sp_nve_mc_entry entries[];
 };
 
 struct mlxsw_sp_nve_mc_list {
-- 
2.25.0

