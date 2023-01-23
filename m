Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E41A678986
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 22:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbjAWV1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 16:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbjAWV1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 16:27:05 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53BE30B15
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 13:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674509224; x=1706045224;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5B/DF/7tPlC8XzJnDANrIsgaqYeH4buvRMHcycAWCts=;
  b=SXo6wvcPidezozKOjRMvfiGXqUUIpK+3Fsqs1C1XPn2R9MaXp1TOTF19
   LT4uUx9NlvXpqr3kRLezr+idEfpGo4Z8IbEsRZh070JftnEScZfGg7Z+8
   zTMl7IKgszHTOIm6WHx626XcV6vwd3jMWYBHMZrG8mK1y+KO4cI43+SFH
   H11Stgbrk3GpmtOTiLNhvjVWOg3afmabw0tijFVGdaCQNR0+2tTa6qJx1
   +32FMlriJd47R8N+Mwck2UAiejREJ+tFxgBD7y+GZrkZ6tp5W4Tte/K3t
   OyhKqa6sJUj1Mwa5IanKqKvYwg6xgHVd0jO5VUcr1ZKpZrqlpdR0LiHnF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="328241880"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="328241880"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 13:27:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="655173678"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="655173678"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by orsmga007.jf.intel.com with ESMTP; 23 Jan 2023 13:27:03 -0800
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, mkubecek@suse.cz, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: [RESEND PATCH ethtool-next v6 1/2] Move code that print rss info into common file
Date:   Mon, 23 Jan 2023 13:25:00 -0800
Message-Id: <20230123212501.1471308-2-sudheer.mogilappagari@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230123212501.1471308-1-sudheer.mogilappagari@intel.com>
References: <20230123212501.1471308-1-sudheer.mogilappagari@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move function that prints rss indirection table and hash key into
common file for use by both netlink and ioctl interface. Changed
function argument to be ring count instead of structure.

Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
---
 common.c  | 36 ++++++++++++++++++++++++++++++++++++
 common.h  |  6 +++++-
 ethtool.c | 42 +++++++-----------------------------------
 3 files changed, 48 insertions(+), 36 deletions(-)

diff --git a/common.c b/common.c
index 2630e73..b8fd4d5 100644
--- a/common.c
+++ b/common.c
@@ -173,3 +173,39 @@ void dump_mdix(u8 mdix, u8 mdix_ctrl)
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
+void print_rss_hkey(u8 *hkey, u32 hkey_size)
+{
+	u32 i;
+
+	printf("RSS hash key:\n");
+	if (!hkey_size || !hkey)
+		printf("Operation not supported\n");
+
+	for (i = 0; i < hkey_size; i++) {
+		if (i == (hkey_size - 1))
+			printf("%02x\n", hkey[i]);
+		else
+			printf("%02x:", hkey[i]);
+	}
+}
diff --git a/common.h b/common.h
index b74fdfa..f975407 100644
--- a/common.h
+++ b/common.h
@@ -8,6 +8,8 @@
 #define ETHTOOL_COMMON_H__
 
 #include "internal.h"
+#include <stddef.h>
+#include <errno.h>
 
 #define KERNEL_VERSION(a, b, c) (((a) << 16) + ((b) << 8) + (c))
 
@@ -41,5 +43,7 @@ extern const struct off_flag_def off_flag_def[OFF_FLAG_DEF_SIZE];
 void print_flags(const struct flag_info *info, unsigned int n_info, u32 value);
 int dump_wol(struct ethtool_wolinfo *wol);
 void dump_mdix(u8 mdix, u8 mdix_ctrl);
-
+void print_indir_table(struct cmd_context *ctx, u64 ring_count,
+		       u32 indir_size, u32 *indir);
+void print_rss_hkey(u8 *hkey, u32 hkey_size);
 #endif /* ETHTOOL_COMMON_H__ */
diff --git a/ethtool.c b/ethtool.c
index 60da8af..ea74684 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -3900,27 +3900,6 @@ static int do_grxclass(struct cmd_context *ctx)
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
@@ -3952,7 +3931,8 @@ static int do_grxfhindir(struct cmd_context *ctx,
 		return 1;
 	}
 
-	print_indir_table(ctx, ring_count, indir->size, indir->ring_index);
+	print_indir_table(ctx, ring_count->data, indir->size,
+			  indir->ring_index);
 
 	free(indir);
 	return 0;
@@ -3967,7 +3947,7 @@ static int do_grxfh(struct cmd_context *ctx)
 	u32 rss_context = 0;
 	u32 i, indir_bytes;
 	unsigned int arg_num = 0;
-	char *hkey;
+	u8 *hkey;
 	int err;
 
 	while (arg_num < ctx->argc) {
@@ -4017,21 +3997,13 @@ static int do_grxfh(struct cmd_context *ctx)
 		return 1;
 	}
 
-	print_indir_table(ctx, &ring_count, rss->indir_size, rss->rss_config);
+	print_indir_table(ctx, ring_count.data, rss->indir_size,
+			  rss->rss_config);
 
 	indir_bytes = rss->indir_size * sizeof(rss->rss_config[0]);
-	hkey = ((char *)rss->rss_config + indir_bytes);
-
-	printf("RSS hash key:\n");
-	if (!rss->key_size)
-		printf("Operation not supported\n");
+	hkey = ((u8 *)rss->rss_config + indir_bytes);
 
-	for (i = 0; i < rss->key_size; i++) {
-		if (i == (rss->key_size - 1))
-			printf("%02x\n", (u8) hkey[i]);
-		else
-			printf("%02x:", (u8) hkey[i]);
-	}
+	print_rss_hkey(hkey, rss->key_size);
 
 	printf("RSS hash function:\n");
 	if (!rss->hfunc) {
-- 
2.31.1

