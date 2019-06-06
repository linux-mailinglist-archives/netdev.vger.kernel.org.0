Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0635037F2D
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfFFU7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 16:59:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47764 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726656AbfFFU7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 16:59:47 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x56KwOrM009812
        for <netdev@vger.kernel.org>; Thu, 6 Jun 2019 13:59:46 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2sy71g0udx-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 13:59:46 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Jun 2019 13:59:45 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id C86C423327D58; Thu,  6 Jun 2019 13:59:43 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <bjorn.topel@intel.com>, <magnus.karlsson@intel.com>,
        <toke@redhat.com>, <brouer@redhat.com>, <daniel@iogearbox.net>,
        <ast@kernel.org>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH v5 3/4] tools/bpf: Add bpf_map_lookup_elem selftest for xskmap
Date:   Thu, 6 Jun 2019 13:59:42 -0700
Message-ID: <20190606205943.818795-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606205943.818795-1-jonathan.lemon@gmail.com>
References: <20190606205943.818795-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=654 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check that bpf_map_lookup_elem lookup and structure
access operats correctly.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 tools/testing/selftests/bpf/verifier/sock.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/sock.c b/tools/testing/selftests/bpf/verifier/sock.c
index b31cd2cf50d0..9ed192e14f5f 100644
--- a/tools/testing/selftests/bpf/verifier/sock.c
+++ b/tools/testing/selftests/bpf/verifier/sock.c
@@ -498,3 +498,21 @@
 	.result = REJECT,
 	.errstr = "cannot pass map_type 24 into func bpf_map_lookup_elem",
 },
+{
+	"bpf_map_lookup_elem(xskmap, &key); xs->queue_id",
+	.insns = {
+	BPF_ST_MEM(BPF_W, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_xdp_sock, queue_id)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_xskmap = { 3 },
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.result = ACCEPT,
+},
-- 
2.17.1

