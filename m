Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D32B33E783
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 04:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhCQDNj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Mar 2021 23:13:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40338 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229657AbhCQDNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 23:13:21 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12H37GN9006095
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 20:13:20 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 37armw5kjr-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 20:13:20 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 16 Mar 2021 20:13:07 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 628712ED23D6; Tue, 16 Mar 2021 20:13:01 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 1/4] bpftool: generate NULL definition in vmlinux.h
Date:   Tue, 16 Mar 2021 20:12:54 -0700
Message-ID: <20210317031257.846314-2-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210317031257.846314-1-andrii@kernel.org>
References: <20210317031257.846314-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_09:2021-03-16,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 clxscore=1015 mlxlogscore=999
 phishscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103170024
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given that vmlinux.h is not compatible with headers like stdint.h, NULL poses
an annoying problem: it is defined as #define, so is not captured in BTF, so
is not emitted into vmlinux.h. This leads to users either sticking to explicit
0, or defining their own NULL (as progs/skb_pkt_end.c does).

It's pretty trivial for bpftool to generate NULL definition, though, so let's
just do that. This might cause compilation warning for existing BPF
applications:

  progs/skb_pkt_end.c:7:9: warning: 'NULL' macro redefined [-Wmacro-redefined]
  #define NULL 0
          ^
  /tmp/linux/tools/testing/selftests/bpf/tools/include/vmlinux.h:4:9: note: previous definition is here
  #define NULL ((void *)0)
	  ^

It is trivial to fix, though, so long-term benefits outweight temporary
inconveniences.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/bpf/bpftool/btf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 62953bbf68b4..ff6a76632873 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -405,6 +405,8 @@ static int dump_btf_c(const struct btf *btf,
 	printf("#ifndef __VMLINUX_H__\n");
 	printf("#define __VMLINUX_H__\n");
 	printf("\n");
+	printf("#define NULL ((void *)0)\n");
+	printf("\n");
 	printf("#ifndef BPF_NO_PRESERVE_ACCESS_INDEX\n");
 	printf("#pragma clang attribute push (__attribute__((preserve_access_index)), apply_to = record)\n");
 	printf("#endif\n\n");
-- 
2.30.2

