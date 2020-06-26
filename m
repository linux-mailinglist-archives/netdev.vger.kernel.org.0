Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D56520AF74
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 12:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgFZKOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 06:14:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41563 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726553AbgFZKOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 06:14:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593166440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W4+ceX7JMNdGMHNH3q1RRnw54qKb0HRZMd51u5WVVbk=;
        b=cxqh5V8KLNplIKrOsKDu894tVRQnS5cqWTSvVtcS3pywe7iZBP0/wS+dT0myyylFiiwPFK
        F3S9g/Z+mxpCs+KlfyU6HgsJOMDZ0aPwvh80oKDA+ZOmc2LYmznVZVZ16DzS5yCSG9WoR7
        ITyzy/Htwhb+yWFe10nC5b7kFsgaW1E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-BqJ-Se_pOweKu962Ch8NNA-1; Fri, 26 Jun 2020 06:13:58 -0400
X-MC-Unique: BqJ-Se_pOweKu962Ch8NNA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BBD418585A2;
        Fri, 26 Jun 2020 10:13:57 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-92.ams2.redhat.com [10.36.114.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 738145D9C5;
        Fri, 26 Jun 2020 10:13:56 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 3/4] mptcp: move crypto test to KUNIT
Date:   Fri, 26 Jun 2020 12:12:48 +0200
Message-Id: <4ec5d5fd6f88896de9e85046320f1bf1c05ab396.1593159603.git.pabeni@redhat.com>
In-Reply-To: <cover.1593159603.git.pabeni@redhat.com>
References: <cover.1593159603.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

currently MPTCP uses a custom hook to executed unit tests at
boot time. Let's use the KUNIT framework instead.
Additionally move the relevant code to a separate file and
export the function needed by the test when self-tests
are build as a module.

Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/Kconfig       | 20 ++++++++----
 net/mptcp/Makefile      |  3 ++
 net/mptcp/crypto.c      | 63 ++----------------------------------
 net/mptcp/crypto_test.c | 72 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+), 67 deletions(-)
 create mode 100644 net/mptcp/crypto_test.c

diff --git a/net/mptcp/Kconfig b/net/mptcp/Kconfig
index a9ed3bf1d93f..d7d5f9349366 100644
--- a/net/mptcp/Kconfig
+++ b/net/mptcp/Kconfig
@@ -18,12 +18,20 @@ config MPTCP_IPV6
 	select IPV6
 	default y
 
-config MPTCP_HMAC_TEST
-	bool "Tests for MPTCP HMAC implementation"
+endif
+
+config MPTCP_KUNIT_TESTS
+	tristate "This builds the MPTCP KUnit tests" if !KUNIT_ALL_TESTS
+	select MPTCP
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
 	help
-	  This option enable boot time self-test for the HMAC implementation
-	  used by the MPTCP code
+	  Currently covers the MPTCP crypto helpers.
+	  Only useful for kernel devs running KUnit test harness and are not
+	  for inclusion into a production build.
 
-	  Say N if you are unsure.
+	  For more information on KUnit and unit tests in general please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
 
-endif
diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index baa0640527c7..f9039804207b 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -3,3 +3,6 @@ obj-$(CONFIG_MPTCP) += mptcp.o
 
 mptcp-y := protocol.o subflow.o options.o token.o crypto.o ctrl.o pm.o diag.o \
 	   mib.o pm_netlink.o
+
+mptcp_crypto_test-objs := crypto_test.o
+obj-$(CONFIG_MPTCP_KUNIT_TESTS) += mptcp_crypto_test.o
\ No newline at end of file
diff --git a/net/mptcp/crypto.c b/net/mptcp/crypto.c
index 3d980713a9e2..6c4ea979dfd4 100644
--- a/net/mptcp/crypto.c
+++ b/net/mptcp/crypto.c
@@ -87,65 +87,6 @@ void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac)
 	sha256_final(&state, (u8 *)hmac);
 }
 
-#ifdef CONFIG_MPTCP_HMAC_TEST
-struct test_cast {
-	char *key;
-	char *msg;
-	char *result;
-};
-
-/* we can't reuse RFC 4231 test vectors, as we have constraint on the
- * input and key size.
- */
-static struct test_cast tests[] = {
-	{
-		.key = "0b0b0b0b0b0b0b0b",
-		.msg = "48692054",
-		.result = "8385e24fb4235ac37556b6b886db106284a1da671699f46db1f235ec622dcafa",
-	},
-	{
-		.key = "aaaaaaaaaaaaaaaa",
-		.msg = "dddddddd",
-		.result = "2c5e219164ff1dca1c4a92318d847bb6b9d44492984e1eb71aff9022f71046e9",
-	},
-	{
-		.key = "0102030405060708",
-		.msg = "cdcdcdcd",
-		.result = "e73b9ba9969969cefb04aa0d6df18ec2fcc075b6f23b4d8c4da736a5dbbc6e7d",
-	},
-};
-
-static int __init test_mptcp_crypto(void)
-{
-	char hmac[32], hmac_hex[65];
-	u32 nonce1, nonce2;
-	u64 key1, key2;
-	u8 msg[8];
-	int i, j;
-
-	for (i = 0; i < ARRAY_SIZE(tests); ++i) {
-		/* mptcp hmap will convert to be before computing the hmac */
-		key1 = be64_to_cpu(*((__be64 *)&tests[i].key[0]));
-		key2 = be64_to_cpu(*((__be64 *)&tests[i].key[8]));
-		nonce1 = be32_to_cpu(*((__be32 *)&tests[i].msg[0]));
-		nonce2 = be32_to_cpu(*((__be32 *)&tests[i].msg[4]));
-
-		put_unaligned_be32(nonce1, &msg[0]);
-		put_unaligned_be32(nonce2, &msg[4]);
-
-		mptcp_crypto_hmac_sha(key1, key2, msg, 8, hmac);
-		for (j = 0; j < 32; ++j)
-			sprintf(&hmac_hex[j << 1], "%02x", hmac[j] & 0xff);
-		hmac_hex[64] = 0;
-
-		if (memcmp(hmac_hex, tests[i].result, 64))
-			pr_err("test %d failed, got %s expected %s", i,
-			       hmac_hex, tests[i].result);
-		else
-			pr_info("test %d [ ok ]", i);
-	}
-	return 0;
-}
-
-late_initcall(test_mptcp_crypto);
+#if IS_MODULE(CONFIG_MPTCP_KUNIT_TESTS)
+EXPORT_SYMBOL_GPL(mptcp_crypto_hmac_sha);
 #endif
diff --git a/net/mptcp/crypto_test.c b/net/mptcp/crypto_test.c
new file mode 100644
index 000000000000..017248dea038
--- /dev/null
+++ b/net/mptcp/crypto_test.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <kunit/test.h>
+
+#include "protocol.h"
+
+struct test_case {
+	char *key;
+	char *msg;
+	char *result;
+};
+
+/* we can't reuse RFC 4231 test vectors, as we have constraint on the
+ * input and key size.
+ */
+static struct test_case tests[] = {
+	{
+		.key = "0b0b0b0b0b0b0b0b",
+		.msg = "48692054",
+		.result = "8385e24fb4235ac37556b6b886db106284a1da671699f46db1f235ec622dcafa",
+	},
+	{
+		.key = "aaaaaaaaaaaaaaaa",
+		.msg = "dddddddd",
+		.result = "2c5e219164ff1dca1c4a92318d847bb6b9d44492984e1eb71aff9022f71046e9",
+	},
+	{
+		.key = "0102030405060708",
+		.msg = "cdcdcdcd",
+		.result = "e73b9ba9969969cefb04aa0d6df18ec2fcc075b6f23b4d8c4da736a5dbbc6e7d",
+	},
+};
+
+static void mptcp_crypto_test_basic(struct kunit *test)
+{
+	char hmac[32], hmac_hex[65];
+	u32 nonce1, nonce2;
+	u64 key1, key2;
+	u8 msg[8];
+	int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(tests); ++i) {
+		/* mptcp hmap will convert to be before computing the hmac */
+		key1 = be64_to_cpu(*((__be64 *)&tests[i].key[0]));
+		key2 = be64_to_cpu(*((__be64 *)&tests[i].key[8]));
+		nonce1 = be32_to_cpu(*((__be32 *)&tests[i].msg[0]));
+		nonce2 = be32_to_cpu(*((__be32 *)&tests[i].msg[4]));
+
+		put_unaligned_be32(nonce1, &msg[0]);
+		put_unaligned_be32(nonce2, &msg[4]);
+
+		mptcp_crypto_hmac_sha(key1, key2, msg, 8, hmac);
+		for (j = 0; j < 32; ++j)
+			sprintf(&hmac_hex[j << 1], "%02x", hmac[j] & 0xff);
+		hmac_hex[64] = 0;
+
+		KUNIT_EXPECT_STREQ(test, &hmac_hex[0], tests[i].result);
+	}
+}
+
+static struct kunit_case mptcp_crypto_test_cases[] = {
+	KUNIT_CASE(mptcp_crypto_test_basic),
+	{}
+};
+
+static struct kunit_suite mptcp_crypto_suite = {
+	.name = "mptcp-crypto",
+	.test_cases = mptcp_crypto_test_cases,
+};
+
+kunit_test_suite(mptcp_crypto_suite);
+
+MODULE_LICENSE("GPL");
-- 
2.26.2

