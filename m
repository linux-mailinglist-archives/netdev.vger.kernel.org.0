Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8431403CA
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 07:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgAQGIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 01:08:22 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63214 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726903AbgAQGIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 01:08:21 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00H64EPl009878
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 22:08:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=kNd14TxNovgfLwfBRp3kbrtYbPEPePHa8IgWaENGHL0=;
 b=Rr7EB3cOMr3QkZY5YJwhZh2wi4rDYmtWjbItEOEX4afM2kvbgY8vHQloOsv4eWiiQre7
 9p4pDHT5S5iX20m7DcqAYMAlm4hXVHc5D50wyy/oyOctgyJyAwG37vNzoX2hn5/Qcp3A
 +QVh476S1IoEtRSabPFcuYGJB9FUc8DGMlU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xk0rphb1e-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 22:08:20 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 16 Jan 2020 22:08:17 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 2E10C2EC1745; Thu, 16 Jan 2020 22:08:13 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/4] bpftool: avoid const discard compilation warning
Date:   Thu, 16 Jan 2020 22:08:01 -0800
Message-ID: <20200117060801.1311525-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200117060801.1311525-1-andriin@fb.com>
References: <20200117060801.1311525-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_06:2020-01-16,2020-01-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0 mlxlogscore=570
 mlxscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001170047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid compilation warning in bpftool when assigning disassembler_options by
casting explicitly to non-const pointer.

Fixes: 3ddeac6705ab ("tools: bpftool: use 4 context mode for the NFP disasm")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/jit_disasm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/jit_disasm.c b/tools/bpf/bpftool/jit_disasm.c
index bfed711258ce..22ef85b0f86c 100644
--- a/tools/bpf/bpftool/jit_disasm.c
+++ b/tools/bpf/bpftool/jit_disasm.c
@@ -119,7 +119,7 @@ void disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
 	info.arch = bfd_get_arch(bfdf);
 	info.mach = bfd_get_mach(bfdf);
 	if (disassembler_options)
-		info.disassembler_options = disassembler_options;
+		info.disassembler_options = (char *)disassembler_options;
 	info.buffer = image;
 	info.buffer_length = len;
 
-- 
2.17.1

