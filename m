Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23AC646654
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiLHBMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiLHBLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:11:48 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D458DFC9
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670461901; x=1701997901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f1RvQVSt6GxSknOKzB283VG+0f4ZuHm+MtyEw1vYzvc=;
  b=mQSEkeZKD0kQVX/QBLPmxxbl89xemdd/LVo9GTHyG44nCaYM3TqjNmaY
   iD5xcd+/fBdNPafcb795KlNDg0DcGxdp9AS+s/HAjPVZY9Tp3XxnZPR94
   Fj/QG2SuBqXZz0QBv5ER7VAChCOfKbcciXUImoCy2CCFnvoJCqhDLU7Vp
   LIa2DzOBaB+TbAFA33Na4cMeOIv1TgZylCzYRxsRjZGSYgo23oX8yvHFj
   o1rzdfO8DmkXuzVXq+VlOSZZkpzO9MyoV98FPK7k45PxbzweRAWqzCcOE
   r8PNgIl1rPHgDOnKFJsONN1OIFVYzlQmIvv61DVb6GWz9ClGi3FO2jRW7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="304672894"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="304672894"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="640445381"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="640445381"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:30 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH ethtool v2 12/13] ethtool: fix leak of memory after realloc
Date:   Wed,  7 Dec 2022 17:11:21 -0800
Message-Id: <20221208011122.2343363-13-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cppcheck finds:
netlink/msgbuff.c:63:2: error: Memory leak: nbuff [memleak]
 return 0;
 ^

This is a pretty common problem with realloc() and just requires handling
the return code correctly which makes us refactor to reuse the structure
free/reinit code that already exists in msgbuf_done().

This fixes the code flow by doing the right thing if realloc() succeeds and
if it fails then being sure to free the original memory and replicate the
steps the original code took.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 netlink/msgbuff.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/netlink/msgbuff.c b/netlink/msgbuff.c
index 216f5b946236..a599cab06014 100644
--- a/netlink/msgbuff.c
+++ b/netlink/msgbuff.c
@@ -15,6 +15,20 @@
 
 #define MAX_MSG_SIZE (4 << 20)		/* 4 MB */
 
+/**
+ * msg_done() - destroy a message buffer
+ * @msgbuff: message buffer
+ *
+ * Free the buffer and reset size and remaining size.
+ */
+void msgbuff_done(struct nl_msg_buff *msgbuff)
+{
+	free(msgbuff->buff);
+	msgbuff->buff = NULL;
+	msgbuff->size = 0;
+	msgbuff->left = 0;
+}
+
 /**
  * msgbuff_realloc() - reallocate buffer if needed
  * @msgbuff:  message buffer
@@ -43,19 +57,16 @@ int msgbuff_realloc(struct nl_msg_buff *msgbuff, unsigned int new_size)
 	if (new_size > MAX_MSG_SIZE)
 		return -EMSGSIZE;
 	nbuff = realloc(msgbuff->buff, new_size);
-	if (!nbuff) {
-		msgbuff->buff = NULL;
-		msgbuff->size = 0;
-		msgbuff->left = 0;
-		return -ENOMEM;
-	}
-	if (nbuff != msgbuff->buff) {
+	if (nbuff) {
 		if (new_size > old_size)
 			memset(nbuff + old_size, '\0', new_size - old_size);
 		msgbuff->nlhdr = (struct nlmsghdr *)(nbuff + nlhdr_off);
 		msgbuff->genlhdr = (struct genlmsghdr *)(nbuff + genlhdr_off);
 		msgbuff->payload = nbuff + payload_off;
 		msgbuff->buff = nbuff;
+	} else {
+		msgbuff_done(msgbuff);
+		return -ENOMEM;
 	}
 	msgbuff->size = new_size;
 	msgbuff->left += (new_size - old_size);
@@ -240,17 +251,3 @@ void msgbuff_init(struct nl_msg_buff *msgbuff)
 {
 	memset(msgbuff, '\0', sizeof(*msgbuff));
 }
-
-/**
- * msg_done() - destroy a message buffer
- * @msgbuff: message buffer
- *
- * Free the buffer and reset size and remaining size.
- */
-void msgbuff_done(struct nl_msg_buff *msgbuff)
-{
-	free(msgbuff->buff);
-	msgbuff->buff = NULL;
-	msgbuff->size = 0;
-	msgbuff->left = 0;
-}
-- 
2.31.1

