Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9508475261
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 07:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239994AbhLOGBa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 Dec 2021 01:01:30 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56110 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239976AbhLOGB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 01:01:27 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BF3qjmA015429
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 22:01:27 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3cy8tyrqn9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 22:01:27 -0800
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 22:01:25 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id E3AD726045B34; Tue, 14 Dec 2021 22:01:24 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <peterz@infradead.org>, <x86@kernel.org>,
        Song Liu <song@kernel.org>
Subject: [PATCH v2 bpf-next 5/7] x86/alternative: introduce text_poke_jit
Date:   Tue, 14 Dec 2021 22:01:00 -0800
Message-ID: <20211215060102.3793196-6-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211215060102.3793196-1-song@kernel.org>
References: <20211215060102.3793196-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: VHEDVLUzo_Utlb3HMGOlGWogL3Xr-prN
X-Proofpoint-GUID: VHEDVLUzo_Utlb3HMGOlGWogL3Xr-prN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-15_05,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 mlxscore=0 impostorscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 mlxlogscore=465 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150035
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be used by BPF jit compiler to dump JITed binary to a RWX huge
page, and thus allow multiple BPF programs sharing the a huge (2MB) page.

Signed-off-by: Song Liu <song@kernel.org>
---
 arch/x86/include/asm/text-patching.h |  1 +
 arch/x86/kernel/alternative.c        | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index b7421780e4e9..991058c9b4b1 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -44,6 +44,7 @@ extern void text_poke_early(void *addr, const void *opcode, size_t len);
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void text_poke_sync(void);
 extern void *text_poke_kgdb(void *addr, const void *opcode, size_t len);
+extern void *text_poke_jit(void *addr, const void *opcode, size_t len);
 extern int poke_int3_handler(struct pt_regs *regs);
 extern void text_poke_bp(void *addr, const void *opcode, size_t len, const void *emulate);
 
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 23fb4d51a5da..02c35725cc62 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1102,6 +1102,34 @@ void *text_poke_kgdb(void *addr, const void *opcode, size_t len)
 	return __text_poke(addr, opcode, len);
 }
 
+/**
+ * text_poke_jit - Update instructions on a live kernel by jit engine
+ * @addr: address to modify
+ * @opcode: source of the copy
+ * @len: length to copy, could be more than 2x PAGE_SIZE
+ *
+ * Only module memory taking jit text (e.g. for bpf) should be patched.
+ */
+void *text_poke_jit(void *addr, const void *opcode, size_t len)
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

