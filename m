Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A2B51E2EE
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 03:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356330AbiEGBPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 21:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236738AbiEGBPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 21:15:06 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91B36AA70
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 18:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651885881; x=1683421881;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+WP5HV16Ll6cJEkkJKg09T/1vlyZjLtqzjna7HLtFck=;
  b=P0ev2LeezTAaYNHFEfOcavZ+ri3J8oVu6ogOrQcwnQJm6JIkgmF4wEOm
   9fzZmsmDkZF/ac1uhJIV+J4uzRf5CqOASKKKa3ljDO/37ok+4m2agk0+7
   MH7DwuzeQjnUd9W9b0Np/J5pGOZhbq/+rP++mYJjddJrmNrvailESxTMT
   CjMhcaCoZbxYQHoPbH0h/9fASMcwqvEVLpRj8DvO9/1iu5mHn5td6ldWL
   NiX00pWBYjSzaY0mOjkTu0ArbYIlHEKSnjiBoTqNrb8aWZfZ+k4+GyiW7
   MzU6HevwMGnnxE7332Sf5QXs4wIuWEIeI5N2vUbzzNm+GdHMMCeK7Ru4M
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="268759883"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="268759883"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 18:11:21 -0700
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="812632839"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.70])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 18:11:21 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>, davem@davemloft.net,
        kuba@kernel.org, alexander.lobakin@intel.com, talgi@nvidia.com
Subject: [PATCH net v2] dim: initialize all struct fields
Date:   Fri,  6 May 2022 18:10:38 -0700
Message-Id: <20220507011038.14568-1-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

Use the commonly accepted style to indicate to the compiler that we
know what we're doing, and add a comma at the end of each struct
initializer to clean up the issue, and use explicit initializers
for the fields we are initializing which makes the compiler happy.

While here and fixing these lines, clean up the code slightly with
a fix for the super long lines by removing the word "_MODERATION" from a
couple defines only used in this file.

Fixes: f8be17b81d44 ("lib/dim: Fix -Wunused-const-variable warnings")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
--
v2: addressed comments by changing to commonly accepted style,
    and removed structure init macro. Switched init to inline-explicit.
---
 lib/dim/net_dim.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/lib/dim/net_dim.c b/lib/dim/net_dim.c
index 06811d866775..53f6b9c6e936 100644
--- a/lib/dim/net_dim.c
+++ b/lib/dim/net_dim.c
@@ -12,41 +12,41 @@
  *        Each profile size must be of NET_DIM_PARAMS_NUM_PROFILES
  */
 #define NET_DIM_PARAMS_NUM_PROFILES 5
-#define NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE 256
-#define NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE 128
+#define NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE 256
+#define NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE 128
 #define NET_DIM_DEF_PROFILE_CQE 1
 #define NET_DIM_DEF_PROFILE_EQE 1
 
 #define NET_DIM_RX_EQE_PROFILES { \
-	{1,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{8,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{64,  NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{128, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{256, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
+	{.usec = 1,   .pkts = NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE,}, \
+	{.usec = 8,   .pkts = NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE,}, \
+	{.usec = 64,  .pkts = NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE,}, \
+	{.usec = 128, .pkts = NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE,}, \
+	{.usec = 256, .pkts = NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE,}  \
 }
 
 #define NET_DIM_RX_CQE_PROFILES { \
-	{2,  256},             \
-	{8,  128},             \
-	{16, 64},              \
-	{32, 64},              \
-	{64, 64}               \
+	{.usec = 2,  .pkts = 256,},             \
+	{.usec = 8,  .pkts = 128,},             \
+	{.usec = 16, .pkts = 64,},              \
+	{.usec = 32, .pkts = 64,},              \
+	{.usec = 64, .pkts = 64,}               \
 }
 
 #define NET_DIM_TX_EQE_PROFILES { \
-	{1,   NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{8,   NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{32,  NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{64,  NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{128, NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE}   \
+	{.usec = 1,   .pkts = NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE,},  \
+	{.usec = 8,   .pkts = NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE,},  \
+	{.usec = 32,  .pkts = NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE,},  \
+	{.usec = 64,  .pkts = NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE,},  \
+	{.usec = 128, .pkts = NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE,}   \
 }
 
 #define NET_DIM_TX_CQE_PROFILES { \
-	{5,  128},  \
-	{8,  64},  \
-	{16, 32},  \
-	{32, 32},  \
-	{64, 32}   \
+	{.usec = 5,  .pkts = 128,},  \
+	{.usec = 8,  .pkts = 64,},  \
+	{.usec = 16, .pkts = 32,},  \
+	{.usec = 32, .pkts = 32,},  \
+	{.usec = 64, .pkts = 32,}   \
 }
 
 static const struct dim_cq_moder
-- 
2.34.1

