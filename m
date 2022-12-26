Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2498765651B
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 22:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbiLZVRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 16:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiLZVRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 16:17:06 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1D11083
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 13:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672089425; x=1703625425;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E5572UmhR2mQ3TfvYt3z2iojIxg2RNneWwjwuQU2P5g=;
  b=Gw86SvwAvCOu0t2h/xEbDEF9wq6RH9qz6J25I6DcjAjdGGVmTISzGF60
   Kli9w5R6qEc/wjPyiyTAPdxV2zuAlNb+N/vNG1eL6di+qqi7BQD2hS4gq
   lRDaDFXTjXZt8hDZAgQ7RzeHfHOTZZO4wg+r9qNGvubdXzxwnZm3fmCbT
   ZdxPu+65+0p8jytfkmiZHuLWyt1sdR9rAJY7loVbK52qEXaohNM2IBhkK
   khnyokSrNILh3a1C4ph7Z6AKq+m0J+JksYo1Y2+tBSbPnKhuJ+cFYKlj/
   Tq2wza5g8R7Boq7+GP/NcWCvFGRt/IlDNyHQLYb/mBJTpPNTdfq5hrpGV
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="300969810"
X-IronPort-AV: E=Sophos;i="5.96,276,1665471600"; 
   d="scan'208";a="300969810"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2022 13:17:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="683432753"
X-IronPort-AV: E=Sophos;i="5.96,276,1665471600"; 
   d="scan'208";a="683432753"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by orsmga008.jf.intel.com with ESMTP; 26 Dec 2022 13:17:02 -0800
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: [PATCH ethtool-next v3 1/2] Move code that print rss info into common file
Date:   Mon, 26 Dec 2022 13:12:25 -0800
Message-Id: <20221226211226.2084364-2-sudheer.mogilappagari@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221226211226.2084364-1-sudheer.mogilappagari@intel.com>
References: <20221226211226.2084364-1-sudheer.mogilappagari@intel.com>
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

Move functions that prints rss indirection table and hash key
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
index 60da8af..209dbd1 100644
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
@@ -3965,9 +3945,7 @@ static int do_grxfh(struct cmd_context *ctx)
 	struct ethtool_rxnfc ring_count;
 	struct ethtool_rxfh *rss;
 	u32 rss_context = 0;
-	u32 i, indir_bytes;
-	unsigned int arg_num = 0;
-	char *hkey;
+	unsigned int arg_num = 0, i;
 	int err;
 
 	while (arg_num < ctx->argc) {
@@ -4017,21 +3995,7 @@ static int do_grxfh(struct cmd_context *ctx)
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

