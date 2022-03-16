Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B264DAF95
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355599AbiCPMZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355603AbiCPMZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:25:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AFC4BB96;
        Wed, 16 Mar 2022 05:24:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 950E2B81AE2;
        Wed, 16 Mar 2022 12:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF676C340EC;
        Wed, 16 Mar 2022 12:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647433479;
        bh=amthMLKww3OhuSeqrOfArnmlqFXStzUsGT7339QZapo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amW3AcTqJ4vtjlzWXr+rJNX1xwGOAkITNrXZd7Io6+fVzFSotPVcXpbOUSziHNm5E
         bi+vp0JMqCN0Uih9mTiV1I1Ij+O8GJFFejiIcHCR0N8uvaiv16CmCxDx+r4KY8nb9V
         vJVkvs6lHZ2GrfRB5RqJb25h77nq+QiqFCz0Eywop4wa7eZHgfW66QjfQeD2tVYhUi
         VMuUbccq75P12325ihzTMiHKVqiwNM2wunaAjv/fpQEKbQWJ8+woliTWiElNiCojuI
         jSEMLczjL/Pf7W15pYwxVWhvaJatEiv4wcwuGp0xq+avJ64q5Jvq6IZhYOTswwM4k6
         aVUObVukfugnQ==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCHv3 bpf-next 01/13] lib/sort: Add priv pointer to swap function
Date:   Wed, 16 Mar 2022 13:24:07 +0100
Message-Id: <20220316122419.933957-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316122419.933957-1-jolsa@kernel.org>
References: <20220316122419.933957-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to have priv pointer in swap callback function.

Following the initial change on cmp callback functions [1]
and adding SWAP_WRAPPER macro to identify sort call of sort_r.

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
[1] 4333fb96ca10 ("media: lib/sort.c: implement sort() variant taking context argument")
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/sort.h  |  2 +-
 include/linux/types.h |  1 +
 lib/sort.c            | 40 ++++++++++++++++++++++++++++++----------
 3 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/include/linux/sort.h b/include/linux/sort.h
index b5898725fe9d..e163287ac6c1 100644
--- a/include/linux/sort.h
+++ b/include/linux/sort.h
@@ -6,7 +6,7 @@
 
 void sort_r(void *base, size_t num, size_t size,
 	    cmp_r_func_t cmp_func,
-	    swap_func_t swap_func,
+	    swap_r_func_t swap_func,
 	    const void *priv);
 
 void sort(void *base, size_t num, size_t size,
diff --git a/include/linux/types.h b/include/linux/types.h
index ac825ad90e44..ea8cf60a8a79 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -226,6 +226,7 @@ struct callback_head {
 typedef void (*rcu_callback_t)(struct rcu_head *head);
 typedef void (*call_rcu_func_t)(struct rcu_head *head, rcu_callback_t func);
 
+typedef void (*swap_r_func_t)(void *a, void *b, int size, const void *priv);
 typedef void (*swap_func_t)(void *a, void *b, int size);
 
 typedef int (*cmp_r_func_t)(const void *a, const void *b, const void *priv);
diff --git a/lib/sort.c b/lib/sort.c
index aa18153864d2..b399bf10d675 100644
--- a/lib/sort.c
+++ b/lib/sort.c
@@ -122,16 +122,27 @@ static void swap_bytes(void *a, void *b, size_t n)
  * a pointer, but small integers make for the smallest compare
  * instructions.
  */
-#define SWAP_WORDS_64 (swap_func_t)0
-#define SWAP_WORDS_32 (swap_func_t)1
-#define SWAP_BYTES    (swap_func_t)2
+#define SWAP_WORDS_64 (swap_r_func_t)0
+#define SWAP_WORDS_32 (swap_r_func_t)1
+#define SWAP_BYTES    (swap_r_func_t)2
+#define SWAP_WRAPPER  (swap_r_func_t)3
+
+struct wrapper {
+	cmp_func_t cmp;
+	swap_func_t swap;
+};
 
 /*
  * The function pointer is last to make tail calls most efficient if the
  * compiler decides not to inline this function.
  */
-static void do_swap(void *a, void *b, size_t size, swap_func_t swap_func)
+static void do_swap(void *a, void *b, size_t size, swap_r_func_t swap_func, const void *priv)
 {
+	if (swap_func == SWAP_WRAPPER) {
+		((const struct wrapper *)priv)->swap(a, b, (int)size);
+		return;
+	}
+
 	if (swap_func == SWAP_WORDS_64)
 		swap_words_64(a, b, size);
 	else if (swap_func == SWAP_WORDS_32)
@@ -139,7 +150,7 @@ static void do_swap(void *a, void *b, size_t size, swap_func_t swap_func)
 	else if (swap_func == SWAP_BYTES)
 		swap_bytes(a, b, size);
 	else
-		swap_func(a, b, (int)size);
+		swap_func(a, b, (int)size, priv);
 }
 
 #define _CMP_WRAPPER ((cmp_r_func_t)0L)
@@ -147,7 +158,7 @@ static void do_swap(void *a, void *b, size_t size, swap_func_t swap_func)
 static int do_cmp(const void *a, const void *b, cmp_r_func_t cmp, const void *priv)
 {
 	if (cmp == _CMP_WRAPPER)
-		return ((cmp_func_t)(priv))(a, b);
+		return ((const struct wrapper *)priv)->cmp(a, b);
 	return cmp(a, b, priv);
 }
 
@@ -198,7 +209,7 @@ static size_t parent(size_t i, unsigned int lsbit, size_t size)
  */
 void sort_r(void *base, size_t num, size_t size,
 	    cmp_r_func_t cmp_func,
-	    swap_func_t swap_func,
+	    swap_r_func_t swap_func,
 	    const void *priv)
 {
 	/* pre-scale counters for performance */
@@ -208,6 +219,10 @@ void sort_r(void *base, size_t num, size_t size,
 	if (!a)		/* num < 2 || size == 0 */
 		return;
 
+	/* called from 'sort' without swap function, let's pick the default */
+	if (swap_func == SWAP_WRAPPER && !((struct wrapper *)priv)->swap)
+		swap_func = NULL;
+
 	if (!swap_func) {
 		if (is_aligned(base, size, 8))
 			swap_func = SWAP_WORDS_64;
@@ -230,7 +245,7 @@ void sort_r(void *base, size_t num, size_t size,
 		if (a)			/* Building heap: sift down --a */
 			a -= size;
 		else if (n -= size)	/* Sorting: Extract root to --n */
-			do_swap(base, base + n, size, swap_func);
+			do_swap(base, base + n, size, swap_func, priv);
 		else			/* Sort complete */
 			break;
 
@@ -257,7 +272,7 @@ void sort_r(void *base, size_t num, size_t size,
 		c = b;			/* Where "a" belongs */
 		while (b != a) {	/* Shift it into place */
 			b = parent(b, lsbit, size);
-			do_swap(base + b, base + c, size, swap_func);
+			do_swap(base + b, base + c, size, swap_func, priv);
 		}
 	}
 }
@@ -267,6 +282,11 @@ void sort(void *base, size_t num, size_t size,
 	  cmp_func_t cmp_func,
 	  swap_func_t swap_func)
 {
-	return sort_r(base, num, size, _CMP_WRAPPER, swap_func, cmp_func);
+	struct wrapper w = {
+		.cmp  = cmp_func,
+		.swap = swap_func,
+	};
+
+	return sort_r(base, num, size, _CMP_WRAPPER, SWAP_WRAPPER, &w);
 }
 EXPORT_SYMBOL(sort);
-- 
2.35.1

