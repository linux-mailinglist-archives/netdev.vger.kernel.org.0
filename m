Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91A664D455
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 01:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiLOAGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 19:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiLOAFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 19:05:45 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E0756D73
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 15:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671062310; x=1702598310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nXQAflAxrY/Ib1yP4tv5u4ncYn2ew+J63x7ANDQR2Ag=;
  b=mOwp8BIhAel25OWPaIxh/o96GizJmZMUezKcooShpD1wPi0y/HgfkxC3
   Jzrd59oWFn5tHYslAIm5nimaba4+7WR6PEyotWdjrcC/PALOmxQGKXiu7
   lgLxtnM62v5a0rE/4yXXhTpblQ4NFPLTirPYlT6ai9pSeaB77hVxHYXfG
   L31uGW4onLvlJSRgmOdzmlfGcNDBcfOUqaoxF+K5q6Tp4hZ+G0g8BH3HR
   w2tZ2COSUk1NvENr5nJHQetnP5yueU42QezXiy6IxA/iODk/AKIrMkwxA
   QHuFfTqlLHyoOtC7bYqkXU7lUHXky8FH79VSjpmdLQZ+E8KxVUITr6S2X
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="301951806"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="301951806"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 15:57:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="773503927"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="773503927"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by orsmga004.jf.intel.com with ESMTP; 14 Dec 2022 15:57:25 -0800
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, kuba@kernel.org, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH ethtool-next v1 2/3] Move code that print rss info into common file
Date:   Wed, 14 Dec 2022 15:54:17 -0800
Message-Id: <20221214235418.1033834-3-sudheer.mogilappagari@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221214235418.1033834-1-sudheer.mogilappagari@intel.com>
References: <20221214235418.1033834-1-sudheer.mogilappagari@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move functions that print rss indirection table and hash key
into common file for use by both netlink and ioctl interface.
Changed function argument to be ring count instead of structure.

Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
---
 common.c  | 43 +++++++++++++++++++++++++++++++++++++++++++
 common.h  |  7 +++++++
 ethtool.c | 44 ++++----------------------------------------
 3 files changed, 54 insertions(+), 40 deletions(-)

diff --git a/common.c b/common.c
index 2630e73..0f2d8c0 100644
--- a/common.c
+++ b/common.c
@@ -173,3 +173,46 @@ void dump_mdix(u8 mdix, u8 mdix_ctrl)
 		fprintf(stdout, "\n");
 	}
 }
+
+void print_indir_table(struct cmd_context *ctx, u64 ring_count,
+		       u32 indir_size, u32 *indir)
+{
+	u32 i;
+
+	printf("RX flow hash indirection table for %s with %llu RX ring(s):\n",
+	       ctx->devname, ring_count);
+
+	if (!indir_size)
+		printf("Operation not supported\n");
+
+	for (i = 0; i < indir_size; i++) {
+		if (i % 8 == 0)
+			printf("%5u: ", i);
+		printf(" %5u", indir[i]);
+		if (i % 8 == 7 || i == indir_size - 1)
+			fputc('\n', stdout);
+	}
+}
+
+void print_rss_info(struct cmd_context *ctx, u64 ring_count,
+		    struct ethtool_rxfh *rss)
+{
+	u32 i, indir_bytes;
+	char *hkey;
+
+	print_indir_table(ctx, ring_count, rss->indir_size, rss->rss_config);
+
+	indir_bytes = rss->indir_size * sizeof(rss->rss_config[0]);
+	hkey = ((char *)rss->rss_config + indir_bytes);
+
+	printf("RSS hash key:\n");
+	if (!rss->key_size)
+		printf("Operation not supported\n");
+
+	for (i = 0; i < rss->key_size; i++) {
+		if (i == (rss->key_size - 1))
+			printf("%02x\n", (u8)hkey[i]);
+		else
+			printf("%02x:", (u8)hkey[i]);
+	}
+}
diff --git a/common.h b/common.h
index b74fdfa..8589714 100644
--- a/common.h
+++ b/common.h
@@ -8,6 +8,8 @@
 #define ETHTOOL_COMMON_H__
 
 #include "internal.h"
+#include <stddef.h>
+#include <errno.h>
 
 #define KERNEL_VERSION(a, b, c) (((a) << 16) + ((b) << 8) + (c))
 
@@ -41,5 +43,10 @@ extern const struct off_flag_def off_flag_def[OFF_FLAG_DEF_SIZE];
 void print_flags(const struct flag_info *info, unsigned int n_info, u32 value);
 int dump_wol(struct ethtool_wolinfo *wol);
 void dump_mdix(u8 mdix, u8 mdix_ctrl);
+void print_indir_table(struct cmd_context *ctx, u64 ring_count,
+		       u32 indir_size, u32 *indir);
+
+void print_rss_info(struct cmd_context *ctx, u64 ring_count,
+		    struct ethtool_rxfh *rss);
 
 #endif /* ETHTOOL_COMMON_H__ */
diff --git a/ethtool.c b/ethtool.c
index 3207e49..0971074 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -3880,27 +3880,6 @@ static int do_grxclass(struct cmd_context *ctx)
 	return err ? 1 : 0;
 }
 
-static void print_indir_table(struct cmd_context *ctx,
-			      struct ethtool_rxnfc *ring_count,
-			      u32 indir_size, u32 *indir)
-{
-	u32 i;
-
-	printf("RX flow hash indirection table for %s with %llu RX ring(s):\n",
-	       ctx->devname, ring_count->data);
-
-	if (!indir_size)
-		printf("Operation not supported\n");
-
-	for (i = 0; i < indir_size; i++) {
-		if (i % 8 == 0)
-			printf("%5u: ", i);
-		printf(" %5u", indir[i]);
-		if (i % 8 == 7 || i == indir_size - 1)
-			fputc('\n', stdout);
-	}
-}
-
 static int do_grxfhindir(struct cmd_context *ctx,
 			 struct ethtool_rxnfc *ring_count)
 {
@@ -3932,7 +3911,8 @@ static int do_grxfhindir(struct cmd_context *ctx,
 		return 1;
 	}
 
-	print_indir_table(ctx, ring_count, indir->size, indir->ring_index);
+	print_indir_table(ctx, ring_count->data, indir->size,
+			  indir->ring_index);
 
 	free(indir);
 	return 0;
@@ -3945,9 +3925,7 @@ static int do_grxfh(struct cmd_context *ctx)
 	struct ethtool_rxnfc ring_count;
 	struct ethtool_rxfh *rss;
 	u32 rss_context = 0;
-	u32 i, indir_bytes;
-	unsigned int arg_num = 0;
-	char *hkey;
+	unsigned int arg_num = 0, i;
 	int err;
 
 	while (arg_num < ctx->argc) {
@@ -3997,21 +3975,7 @@ static int do_grxfh(struct cmd_context *ctx)
 		return 1;
 	}
 
-	print_indir_table(ctx, &ring_count, rss->indir_size, rss->rss_config);
-
-	indir_bytes = rss->indir_size * sizeof(rss->rss_config[0]);
-	hkey = ((char *)rss->rss_config + indir_bytes);
-
-	printf("RSS hash key:\n");
-	if (!rss->key_size)
-		printf("Operation not supported\n");
-
-	for (i = 0; i < rss->key_size; i++) {
-		if (i == (rss->key_size - 1))
-			printf("%02x\n", (u8) hkey[i]);
-		else
-			printf("%02x:", (u8) hkey[i]);
-	}
+	print_rss_info(ctx, ring_count.data, rss);
 
 	printf("RSS hash function:\n");
 	if (!rss->hfunc) {
-- 
2.31.1

