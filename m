Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE143EA8BB
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 18:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbhHLQrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 12:47:48 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:49923 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbhHLQrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 12:47:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628786843; x=1660322843;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QRV3Ow9wWvofOCrN/t/cGp/h+xAxQcc40+F6iXsoHEg=;
  b=KoE+fFXaB7V+gLRI8qshoYPmzFUgrZ/oXZG7rOI/pTNnVewi1ssFXAY+
   kDKqdUYdgYCfGWAWVIYGzTI5pgfsNvl9x4VZhBkaqZaxSuSvRaAaHlbBe
   hd6qWOhxipQXDcsWuhv6QbRsP+kXWRMtXgr18ki6+bnoYJ+H333B0KmdN
   I=;
X-IronPort-AV: E=Sophos;i="5.84,316,1620691200"; 
   d="scan'208";a="129059615"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-c7f73527.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 12 Aug 2021 16:47:22 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7f73527.us-east-1.amazon.com (Postfix) with ESMTPS id B12F0C2FF7;
        Thu, 12 Aug 2021 16:47:18 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 12 Aug 2021 16:47:13 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.153) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 12 Aug 2021 16:47:09 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v5 bpf-next 4/4] selftest/bpf: Extend the bpf_snprintf() test for "%c".
Date:   Fri, 13 Aug 2021 01:45:57 +0900
Message-ID: <20210812164557.79046-5-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812164557.79046-1-kuniyu@amazon.co.jp>
References: <20210812164557.79046-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.153]
X-ClientProxiedBy: EX13d09UWA003.ant.amazon.com (10.43.160.227) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a "positive" pattern for "%c", which intentionally uses a
__u32 value (0x64636261, "dbca") to print a single character "a".  If the
implementation went wrong, other 3 bytes might show up as the part of the
latter "%+05s".

Also, this patch adds two "negative" patterns for wide character.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 tools/testing/selftests/bpf/prog_tests/snprintf.c | 4 +++-
 tools/testing/selftests/bpf/progs/test_snprintf.c | 7 ++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/snprintf.c b/tools/testing/selftests/bpf/prog_tests/snprintf.c
index dffbcaa1ec98..f77d7def7fed 100644
--- a/tools/testing/selftests/bpf/prog_tests/snprintf.c
+++ b/tools/testing/selftests/bpf/prog_tests/snprintf.c
@@ -19,7 +19,7 @@
 #define EXP_ADDR_OUT "0000000000000000 ffff00000add4e55 "
 #define EXP_ADDR_RET sizeof(EXP_ADDR_OUT "unknownhashedptr")
 
-#define EXP_STR_OUT  "str1 longstr"
+#define EXP_STR_OUT  "str1         a longstr"
 #define EXP_STR_RET  sizeof(EXP_STR_OUT)
 
 #define EXP_OVER_OUT "%over"
@@ -114,6 +114,8 @@ void test_snprintf_negative(void)
 	ASSERT_ERR(load_single_snprintf("%"), "invalid specifier 3");
 	ASSERT_ERR(load_single_snprintf("%12345678"), "invalid specifier 4");
 	ASSERT_ERR(load_single_snprintf("%--------"), "invalid specifier 5");
+	ASSERT_ERR(load_single_snprintf("%lc"), "invalid specifier 6");
+	ASSERT_ERR(load_single_snprintf("%llc"), "invalid specifier 7");
 	ASSERT_ERR(load_single_snprintf("\x80"), "non ascii character");
 	ASSERT_ERR(load_single_snprintf("\x1"), "non printable character");
 }
diff --git a/tools/testing/selftests/bpf/progs/test_snprintf.c b/tools/testing/selftests/bpf/progs/test_snprintf.c
index e2ad26150f9b..afc2c583125b 100644
--- a/tools/testing/selftests/bpf/progs/test_snprintf.c
+++ b/tools/testing/selftests/bpf/progs/test_snprintf.c
@@ -40,6 +40,7 @@ int handler(const void *ctx)
 	/* Convenient values to pretty-print */
 	const __u8 ex_ipv4[] = {127, 0, 0, 1};
 	const __u8 ex_ipv6[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1};
+	const __u32 chr1 = 0x64636261; /* dcba */
 	static const char str1[] = "str1";
 	static const char longstr[] = "longstr";
 
@@ -59,9 +60,9 @@ int handler(const void *ctx)
 	/* Kernel pointers */
 	addr_ret = BPF_SNPRINTF(addr_out, sizeof(addr_out), "%pK %px %p",
 				0, 0xFFFF00000ADD4E55, 0xFFFF00000ADD4E55);
-	/* Strings embedding */
-	str_ret  = BPF_SNPRINTF(str_out, sizeof(str_out), "%s %+05s",
-				str1, longstr);
+	/* Strings and single-byte character embedding */
+	str_ret  = BPF_SNPRINTF(str_out, sizeof(str_out), "%s % 9c %+05s",
+				str1, chr1, longstr);
 	/* Overflow */
 	over_ret = BPF_SNPRINTF(over_out, sizeof(over_out), "%%overflow");
 	/* Padding of fixed width numbers */
-- 
2.30.2

