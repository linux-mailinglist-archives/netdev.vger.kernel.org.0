Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47F96EE380
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 15:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbjDYN4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 09:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbjDYN4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 09:56:25 -0400
Received: from out-13.mta0.migadu.com (out-13.mta0.migadu.com [IPv6:2001:41d0:1004:224b::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9401B2100
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 06:56:23 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682430981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MXXnD2d1ao8j3z+jt3We3HNASn17nNtDEHjg8zEIU58=;
        b=VIYntA31qStvzu9yKLkptRR+NPY9JoT20ZO5Af0QoE3zOuPy+7U1PVPE148kSUV5ydeUyF
        pJzkPFBg/je4cjE3oIGnB1rDrpUqDJmXNsERc7nrTPLfsEUfPXCF+4bcVy6S+otpSR7Lg7
        Tx6ynPPmuNtg0YY1f+UiSvKbQxNjjKc=
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     cai.huoqing@linux.dev
Cc:     Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rhashtable-test: Make use of rhashtable_walk_peek
Date:   Tue, 25 Apr 2023 21:56:17 +0800
Message-Id: <20230425135617.77907-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        TO_EQ_FM_DIRECT_MX,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an example usage of rhashtable_walk_peek to test_bucket_stats.

Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
---
 lib/test_rhashtable.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/test_rhashtable.c b/lib/test_rhashtable.c
index c20f6cb4bf55..b1c3316b9bde 100644
--- a/lib/test_rhashtable.c
+++ b/lib/test_rhashtable.c
@@ -177,6 +177,7 @@ static void test_bucket_stats(struct rhashtable *ht, unsigned int entries)
 	unsigned int total = 0, chain_len = 0;
 	struct rhashtable_iter hti;
 	struct rhash_head *pos;
+	struct test_obj *obj;
 
 	rhashtable_walk_enter(ht, &hti);
 	rhashtable_walk_start(&hti);
@@ -192,6 +193,13 @@ static void test_bucket_stats(struct rhashtable *ht, unsigned int entries)
 			break;
 		}
 
+		/* Here's an example usage of rhashtable_walk_peek */
+		obj = rhashtable_walk_peek(&hti);
+		if (!obj) {
+			pr_warn("Test failed: rhashtable_walk_peek() error\n");
+			break;
+		}
+
 		total++;
 	}
 
-- 
2.34.1

