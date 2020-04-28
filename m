Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E911BB337
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 03:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgD1BEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 21:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgD1BD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 21:03:58 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC09520728;
        Tue, 28 Apr 2020 01:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588035838;
        bh=BKCpSG/2cldKziJ1GnfbVna4hwN4ee2myzzzleIlH8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vuguE3IqmnBTeRnN0pu3nt9fOVlcGYF9OnpZi7qh90epgbcGkyZNXk0hY2kSAtG9q
         nc+gePr/M4d9h1kMXOzwU2JOmRfaFRPFDyo2hpKC7xqkbcU3M6FToYhJcnNuBNuEH+
         LvBCHfUVMn4Gya7zRND9PMq0EhjbcCCwP2l1JA2M=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     keescook@chromium.org, shuah@kernel.org, netdev@vger.kernel.org,
        luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, Tim.Bird@sony.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v6 1/5] kselftest: factor out list manipulation to a helper
Date:   Mon, 27 Apr 2020 18:03:47 -0700
Message-Id: <20200428010351.331260-2-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200428010351.331260-1-kuba@kernel.org>
References: <20200428010351.331260-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees suggest to factor out the list append code to a macro,
since following commits need it, which leads to code duplication.

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
---
 tools/testing/selftests/kselftest_harness.h | 42 ++++++++++++---------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 2bb8c81fc0b4..77f754854f0d 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -631,6 +631,29 @@
 	} \
 } while (0); OPTIONAL_HANDLER(_assert)
 
+/* List helpers */
+#define __LIST_APPEND(head, item) \
+{ \
+	/* Circular linked list where only prev is circular. */ \
+	if (head == NULL) { \
+		head = item; \
+		item->next = NULL; \
+		item->prev = item; \
+		return;	\
+	} \
+	if (__constructor_order == _CONSTRUCTOR_ORDER_FORWARD) { \
+		item->next = NULL; \
+		item->prev = head->prev; \
+		item->prev->next = item; \
+		head->prev = item; \
+	} else { \
+		item->next = head; \
+		item->next->prev = item; \
+		item->prev = item; \
+		head = item; \
+	} \
+}
+
 /* Contains all the information for test execution and status checking. */
 struct __test_metadata {
 	const char *name;
@@ -667,24 +690,7 @@ static int __constructor_order;
 static inline void __register_test(struct __test_metadata *t)
 {
 	__test_count++;
-	/* Circular linked list where only prev is circular. */
-	if (__test_list == NULL) {
-		__test_list = t;
-		t->next = NULL;
-		t->prev = t;
-		return;
-	}
-	if (__constructor_order == _CONSTRUCTOR_ORDER_FORWARD) {
-		t->next = NULL;
-		t->prev = __test_list->prev;
-		t->prev->next = t;
-		__test_list->prev = t;
-	} else {
-		t->next = __test_list;
-		t->next->prev = t;
-		t->prev = t;
-		__test_list = t;
-	}
+	__LIST_APPEND(__test_list, t);
 }
 
 static inline int __bail(int for_realz, bool no_print, __u8 step)
-- 
2.25.4

