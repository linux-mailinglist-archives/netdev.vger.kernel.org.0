Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7A64965F3
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 20:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbiAUTuN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Jan 2022 14:50:13 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61954 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232684AbiAUTtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 14:49:55 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 20LG5AEL005019
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 11:49:55 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3dqhyy5j1y-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 11:49:54 -0800
Received: from twshared18912.14.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 21 Jan 2022 11:49:51 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 4E498284A5F31; Fri, 21 Jan 2022 11:49:39 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <peterz@infradead.org>, <x86@kernel.org>,
        Song Liu <song@kernel.org>
Subject: [PATCH v6 bpf-next 5/7] x86/alternative: introduce text_poke_copy
Date:   Fri, 21 Jan 2022 11:49:24 -0800
Message-ID: <20220121194926.1970172-6-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121194926.1970172-1-song@kernel.org>
References: <20220121194926.1970172-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: zgNLuR4faMIPq18A0mYKhXzKs2554b-b
X-Proofpoint-ORIG-GUID: zgNLuR4faMIPq18A0mYKhXzKs2554b-b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_09,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 mlxscore=0 spamscore=0 mlxlogscore=372
 phishscore=0 impostorscore=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210128
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be used by BPF jit compiler to dump JITed binary to a RX huge
page, and thus allow multiple BPF programs sharing the a huge (2MB) page.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Song Liu <song@kernel.org>
---
 arch/x86/include/asm/text-patching.h |  1 +
 arch/x86/kernel/alternative.c        | 32 ++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index b7421780e4e9..4cc18ba1b75e 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -44,6 +44,7 @@ extern void text_poke_early(void *addr, const void *opcode, size_t len);
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void text_poke_sync(void);
 extern void *text_poke_kgdb(void *addr, const void *opcode, size_t len);
+extern void *text_poke_copy(void *addr, const void *opcode, size_t len);
 extern int poke_int3_handler(struct pt_regs *regs);
 extern void text_poke_bp(void *addr, const void *opcode, size_t len, const void *emulate);
 
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 23fb4d51a5da..903a415c19fa 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1102,6 +1102,38 @@ void *text_poke_kgdb(void *addr, const void *opcode, size_t len)
 	return __text_poke(addr, opcode, len);
 }
 
+/**
+ * text_poke_copy - Copy instructions into (an unused part of) RX memory
+ * @addr: address to modify
+ * @opcode: source of the copy
+ * @len: length to copy, could be more than 2x PAGE_SIZE
+ *
+ * Not safe against concurrent execution; useful for JITs to dump
+ * new code blocks into unused regions of RX memory. Can be used in
+ * conjunction with synchronize_rcu_tasks() to wait for existing
+ * execution to quiesce after having made sure no existing functions
+ * pointers are live.
+ */
+void *text_poke_copy(void *addr, const void *opcode, size_t len)
+{
+	unsigned long start = (unsigned long)addr;
+	size_t patched = 0;
+
+	if (WARN_ON_ONCE(core_kernel_text(start)))
+		return NULL;
+
+	while (patched < len) {
+		unsigned long ptr = start + patched;
+		size_t s;
+
+		s = min_t(size_t, PAGE_SIZE * 2 - offset_in_page(ptr), len - patched);
+
+		__text_poke((void *)ptr, opcode + patched, s);
+		patched += s;
+	}
+	return addr;
+}
+
 static void do_sync_core(void *info)
 {
 	sync_core();
-- 
2.30.2

