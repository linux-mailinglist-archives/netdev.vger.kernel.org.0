Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7DF46CB62
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243743AbhLHDIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:08:22 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:29159 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243805AbhLHDIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 22:08:15 -0500
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4J825n31pfzXdf9;
        Wed,  8 Dec 2021 11:02:37 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.58) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 11:04:42 +0800
From:   Xiu Jianfeng <xiujianfeng@huawei.com>
To:     <akpm@linux-foundation.org>, <keescook@chromium.org>,
        <laniel_francis@privacyrequired.com>,
        <andriy.shevchenko@linux.intel.com>, <adobriyan@gmail.com>,
        <linux@roeck-us.net>, <andreyknvl@gmail.com>, <dja@axtens.net>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: [PATCH -next 1/2] string.h: Introduce memset_range() for wiping members
Date:   Wed, 8 Dec 2021 11:04:50 +0800
Message-ID: <20211208030451.219751-2-xiujianfeng@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211208030451.219751-1-xiujianfeng@huawei.com>
References: <20211208030451.219751-1-xiujianfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Motivated by memset_after() and memset_startat(), introduce a new helper,
memset_range() that takes the target struct instance, the byte to write,
and two member names where zeroing should start and end.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
---
 include/linux/string.h | 20 ++++++++++++++++++++
 lib/memcpy_kunit.c     | 12 ++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index b6572aeca2f5..7f19863253f2 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -291,6 +291,26 @@ void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
 	       sizeof(*(obj)) - offsetof(typeof(*(obj)), member));	\
 })
 
+/**
+ * memset_range - Set a value ranging from member1 to member2, boundary included.
+ *
+ * @obj: Address of target struct instance
+ * @v: Byte value to repeatedly write
+ * @member1: struct member to start writing at
+ * @member2: struct member where writing should stop
+ *
+ */
+#define memset_range(obj, v, member_1, member_2)			\
+({									\
+	u8 *__ptr = (u8 *)(obj);					\
+	typeof(v) __val = (v);						\
+	BUILD_BUG_ON(offsetof(typeof(*(obj)), member_1) >		\
+		     offsetof(typeof(*(obj)), member_2));		\
+	memset(__ptr + offsetof(typeof(*(obj)), member_1), __val,	\
+	       offsetofend(typeof(*(obj)), member_2) -			\
+	       offsetof(typeof(*(obj)), member_1));			\
+})
+
 /**
  * str_has_prefix - Test if a string has a given prefix
  * @str: The string to test
diff --git a/lib/memcpy_kunit.c b/lib/memcpy_kunit.c
index 62f8ffcbbaa3..0dd800412455 100644
--- a/lib/memcpy_kunit.c
+++ b/lib/memcpy_kunit.c
@@ -229,6 +229,13 @@ static void memset_test(struct kunit *test)
 			  0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79,
 			},
 	};
+	struct some_bytes range = {
+		.data = { 0x30, 0x30, 0x30, 0x30, 0x81, 0x81, 0x81, 0x30,
+			  0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
+			  0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
+			  0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
+			},
+	};
 	struct some_bytes dest = { };
 	int count, value;
 	u8 *ptr;
@@ -269,6 +276,11 @@ static void memset_test(struct kunit *test)
 	dest = control;
 	memset_startat(&dest, 0x79, four);
 	compare("memset_startat()", dest, startat);
+
+	/* Verify memset_range() */
+	dest = control;
+	memset_range(&dest, 0x81, two, three);
+	compare("memset_range()", dest, range);
 #undef TEST_OP
 }
 
-- 
2.17.1

