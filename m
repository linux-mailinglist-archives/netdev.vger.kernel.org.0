Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B5733E763
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 04:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhCQDDx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Mar 2021 23:03:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58312 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229877AbhCQDD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 23:03:28 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12H2wYp4002577
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 20:03:28 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 379ee5qrhn-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 20:03:28 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 16 Mar 2021 20:03:27 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 59B112ED23D6; Tue, 16 Mar 2021 20:03:25 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 4/4] bpftool: treat compilation warnings as errors
Date:   Tue, 16 Mar 2021 20:03:12 -0700
Message-ID: <20210317030312.802233-5-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210317030312.802233-1-andrii@kernel.org>
References: <20210317030312.802233-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_09:2021-03-16,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103170023
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make bpftool compilation stricter and treat all compilation warnigs as errors.

Depending on libbfd version on the system, jit_disasm.c might trigger the
following compilation warning-turned-error:

jit_disasm.c: In function ‘disasm_print_insn’:
jit_disasm.c:121:29: error: assignment discards ‘const’ qualifier from pointer
target type [-Werror=discarded-qualifiers]
   info.disassembler_options = disassembler_options;
                                ^

This was fixed in libbfd, but older versions of the library are still widely
used. So disable -Wdiscarded-qualifiers for that particular line of code.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/bpf/bpftool/Makefile     | 3 ++-
 tools/bpf/bpftool/jit_disasm.c | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index b3073ae84018..59de954faaf5 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -56,7 +56,8 @@ prefix ?= /usr/local
 bash_compdir ?= /usr/share/bash-completion/completions
 
 CFLAGS += -O2
-CFLAGS += -W -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers
+CFLAGS += -W -Wall -Wextra -Werror
+CFLAGS += -Wno-unused-parameter -Wno-missing-field-initializers
 CFLAGS += $(filter-out -Wswitch-enum -Wnested-externs,$(EXTRA_WARNINGS))
 CFLAGS += -DPACKAGE='"bpftool"' -D__EXPORTED_HEADERS__ \
 	-I$(if $(OUTPUT),$(OUTPUT),.) \
diff --git a/tools/bpf/bpftool/jit_disasm.c b/tools/bpf/bpftool/jit_disasm.c
index e7e7eee9f172..48bc7f7a542f 100644
--- a/tools/bpf/bpftool/jit_disasm.c
+++ b/tools/bpf/bpftool/jit_disasm.c
@@ -118,7 +118,10 @@ void disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
 	info.arch = bfd_get_arch(bfdf);
 	info.mach = bfd_get_mach(bfdf);
 	if (disassembler_options)
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wdiscarded-qualifiers"
 		info.disassembler_options = disassembler_options;
+#pragma GCC diagnostic push
 	info.buffer = image;
 	info.buffer_length = len;
 
-- 
2.30.2

