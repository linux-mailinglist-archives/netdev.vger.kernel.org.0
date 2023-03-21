Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F606C2789
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 02:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjCUBlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 21:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbjCUBld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 21:41:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38485BDC6;
        Mon, 20 Mar 2023 18:41:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9BD7B810AB;
        Tue, 21 Mar 2023 01:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E49C433D2;
        Tue, 21 Mar 2023 01:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679362888;
        bh=pZlb1qOOkLSZXMdrl8cVqKo/TNTTMcqYADte+v1sIz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ho8jUq0ZNsMUGqJPpPsSjRZQJw1YyEq+WXYJoUMA1yB2sol4XWcX1SXoK+In+vuDI
         mtMJdBFf6JdJMvOK1CLGISRjYnVhf5wxGSZgNfZacPR0+Grsgxz2ROlD5pvUgrGY/r
         6DnrN/kONDImDZfKiYaa2wz4XfFKR2UTry9rsA/me/llKX2yOvIkpM0NBXA4TcdUrl
         /pVqm3+VfJHBtmoMgvs3JemwbOOzlxdt2dYyBaxj2JAJThXpUIyfJb7mVHcGxnr3Ee
         D8Mcwx/G19SSJuVK9WfaFy+LCWwgbKm1o5EPAcpd6FrXQ3PCJw6mZTGu4aNri0SEvB
         niwabdpbowY+g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     martin.lau@linux.dev
Cc:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v2 3/3] net: skbuff: move the fields BPF cares about directly next to the offset marker
Date:   Mon, 20 Mar 2023 18:41:15 -0700
Message-Id: <20230321014115.997841-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321014115.997841-1-kuba@kernel.org>
References: <20230321014115.997841-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid more possible BPF dependencies with moving bitfields
around keep the fields BPF cares about right next to the offset
marker.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
v2: fix the assembly in tstamp test
---
 include/linux/skbuff.h                         | 18 +++++++++---------
 .../selftests/bpf/prog_tests/ctx_rewrite.c     |  8 ++++----
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 36d31e74db37..6aeb0e7b9511 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -947,15 +947,15 @@ struct sk_buff {
 	/* private: */
 	__u8			__mono_tc_offset[0];
 	/* public: */
-	__u8			remcsum_offload:1;
-	__u8			csum_complete_sw:1;
-	__u8			csum_level:2;
-	__u8			dst_pending_confirm:1;
 	__u8			mono_delivery_time:1;	/* See SKB_MONO_DELIVERY_TIME_MASK */
 #ifdef CONFIG_NET_CLS_ACT
-	__u8			tc_skip_classify:1;
 	__u8			tc_at_ingress:1;	/* See TC_AT_INGRESS_MASK */
+	__u8			tc_skip_classify:1;
 #endif
+	__u8			remcsum_offload:1;
+	__u8			csum_complete_sw:1;
+	__u8			csum_level:2;
+	__u8			dst_pending_confirm:1;
 
 	__u8			l4_hash:1;
 	__u8			sw_hash:1;
@@ -1072,11 +1072,11 @@ struct sk_buff {
  * around, you also must adapt these constants.
  */
 #ifdef __BIG_ENDIAN_BITFIELD
-#define TC_AT_INGRESS_MASK		(1 << 0)
-#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 2)
+#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 7)
+#define TC_AT_INGRESS_MASK		(1 << 6)
 #else
-#define TC_AT_INGRESS_MASK		(1 << 7)
-#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 5)
+#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 0)
+#define TC_AT_INGRESS_MASK		(1 << 1)
 #endif
 #define SKB_BF_MONO_TC_OFFSET		offsetof(struct sk_buff, __mono_tc_offset)
 
diff --git a/tools/testing/selftests/bpf/prog_tests/ctx_rewrite.c b/tools/testing/selftests/bpf/prog_tests/ctx_rewrite.c
index ae7b6e50e405..4951aa978f33 100644
--- a/tools/testing/selftests/bpf/prog_tests/ctx_rewrite.c
+++ b/tools/testing/selftests/bpf/prog_tests/ctx_rewrite.c
@@ -69,15 +69,15 @@ static struct test_case test_cases[] = {
 	{
 		N(SCHED_CLS, struct __sk_buff, tstamp),
 		.read  = "r11 = *(u8 *)($ctx + sk_buff::__mono_tc_offset);"
-			 "w11 &= 160;"
-			 "if w11 != 0xa0 goto pc+2;"
+			 "w11 &= 3;"
+			 "if w11 != 0x3 goto pc+2;"
 			 "$dst = 0;"
 			 "goto pc+1;"
 			 "$dst = *(u64 *)($ctx + sk_buff::tstamp);",
 		.write = "r11 = *(u8 *)($ctx + sk_buff::__mono_tc_offset);"
-			 "if w11 & 0x80 goto pc+1;"
+			 "if w11 & 0x2 goto pc+1;"
 			 "goto pc+2;"
-			 "w11 &= -33;"
+			 "w11 &= -2;"
 			 "*(u8 *)($ctx + sk_buff::__mono_tc_offset) = r11;"
 			 "*(u64 *)($ctx + sk_buff::tstamp) = $src;",
 	},
-- 
2.39.2

