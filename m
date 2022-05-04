Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917E851AD67
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 20:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbiEDTDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 15:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377429AbiEDTDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 15:03:05 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1F322538
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 11:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651690768; x=1683226768;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WrGV7F30JkYXEymN24RAqoZyTyxP0MbDhc+my+s9BWc=;
  b=LEph+7VWMtAM8mwxpAolnchamLYaHJk7r7Hx08YY8MpTCbLq/yh1wL7U
   OFhOQP6L8Ieya8D4tBGTNzcgnkzvCXvKcEMdsoqeAyfxjXHfWckCybnTX
   XKFnm2C7DRwU+P8k3kY6MHMGgWCNGBGd2x8EtKzYvkbLbtUojRCK2mjJ6
   h93LqqZUHlYYVVfJ/g1ju2A5jsYbOvcjKz59Nfjnkb5YMWG93VP3N1zCh
   JKPAI+gKt3a6+jFE0kvAnN02Dh7ninvVAfHasEgL5YJRdE7ZLAKr37QIv
   eqmLx5TWCnWnjacVXQD8MxcWOKPsBtgaTVGReeTLy+fs2JvIIptVcwYb/
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="267752297"
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="267752297"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 11:59:28 -0700
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="562869482"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.70])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 11:59:28 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        alexandr.lobakin@intel.com
Subject: [PATCH net v1] dim: initialize all struct fields
Date:   Wed,  4 May 2022 11:58:32 -0700
Message-Id: <20220504185832.1855538-1-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The W=2 build pointed out that the code wasn't initializing all the
variables in the dim_cq_moder declarations with the struct initializers.
The net change here is zero since these structs were already static
const globals and were initialized with zeros by the compiler, but
removing compiler warnings has value in and of itself.

lib/dim/net_dim.c: At top level:
lib/dim/net_dim.c:54:9: warning: missing initializer for field ‘comps’ of ‘const struct dim_cq_moder’ [-Wmissing-field-initializers]
   54 |         NET_DIM_RX_EQE_PROFILES,
      |         ^~~~~~~~~~~~~~~~~~~~~~~
In file included from lib/dim/net_dim.c:6:
./include/linux/dim.h:45:13: note: ‘comps’ declared here
   45 |         u16 comps;
      |             ^~~~~

and repeats for the tx struct, and once you fix the comps entry then
the cq_period_mode field needs the same treatment.

Add the necessary initializers so that the fields in the struct all have
explicit values.

While here and fixing these lines, clean up the code slightly with
a conversion to explicit field initializers from anonymous ones, and fix
the super long lines by removing the word "_MODERATION" from a couple
defines only used in this file.
anon to explicit conversion example similar to used in this patch:
- struct foo foo_struct = { a, b}
+ struct foo foo_struct = { .foo_a = a, .foo_b = b)

Fixes: f8be17b81d44 ("lib/dim: Fix -Wunused-const-variable warnings")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 lib/dim/net_dim.c | 55 ++++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 24 deletions(-)

diff --git a/lib/dim/net_dim.c b/lib/dim/net_dim.c
index 06811d866775..286b5220e360 100644
--- a/lib/dim/net_dim.c
+++ b/lib/dim/net_dim.c
@@ -12,41 +12,48 @@
  *        Each profile size must be of NET_DIM_PARAMS_NUM_PROFILES
  */
 #define NET_DIM_PARAMS_NUM_PROFILES 5
-#define NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE 256
-#define NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE 128
+#define NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE 256
+#define NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE 128
 #define NET_DIM_DEF_PROFILE_CQE 1
 #define NET_DIM_DEF_PROFILE_EQE 1
 
+#define DIM_CQ_MODER(u, p, c, m) { \
+	.usec = (u),		   \
+	.pkts = (p),		   \
+	.comps = (c),		   \
+	.cq_period_mode = (m)	   \
+}
+
 #define NET_DIM_RX_EQE_PROFILES { \
-	{1,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{8,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{64,  NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{128, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{256, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
+	DIM_CQ_MODER(1,   NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE, 0, 0), \
+	DIM_CQ_MODER(8,   NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE, 0, 0), \
+	DIM_CQ_MODER(64,  NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE, 0, 0), \
+	DIM_CQ_MODER(128, NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE, 0, 0), \
+	DIM_CQ_MODER(256, NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE, 0, 0)  \
 }
 
-#define NET_DIM_RX_CQE_PROFILES { \
-	{2,  256},             \
-	{8,  128},             \
-	{16, 64},              \
-	{32, 64},              \
-	{64, 64}               \
+#define NET_DIM_RX_CQE_PROFILES {	\
+	DIM_CQ_MODER(2, 256, 0, 0),	\
+	DIM_CQ_MODER(8, 128, 0, 0),	\
+	DIM_CQ_MODER(16, 64, 0, 0),	\
+	DIM_CQ_MODER(32, 64, 0, 0),	\
+	DIM_CQ_MODER(64, 64, 0, 0)	\
 }
 
 #define NET_DIM_TX_EQE_PROFILES { \
-	{1,   NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{8,   NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{32,  NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{64,  NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{128, NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE}   \
+	DIM_CQ_MODER(1,   NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE, 0, 0), \
+	DIM_CQ_MODER(8,   NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE, 0, 0), \
+	DIM_CQ_MODER(32,  NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE, 0, 0), \
+	DIM_CQ_MODER(64,  NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE, 0, 0), \
+	DIM_CQ_MODER(128, NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE, 0, 0)  \
 }
 
-#define NET_DIM_TX_CQE_PROFILES { \
-	{5,  128},  \
-	{8,  64},  \
-	{16, 32},  \
-	{32, 32},  \
-	{64, 32}   \
+#define NET_DIM_TX_CQE_PROFILES {	\
+	DIM_CQ_MODER(5, 128, 0, 0),	\
+	DIM_CQ_MODER(8,  64, 0, 0),	\
+	DIM_CQ_MODER(16, 32, 0, 0),	\
+	DIM_CQ_MODER(32, 32, 0, 0),	\
+	DIM_CQ_MODER(64, 32, 0, 0)	\
 }
 
 static const struct dim_cq_moder

base-commit: a0df71948e9548de819a6f1da68f5f1742258a52
-- 
2.34.1

