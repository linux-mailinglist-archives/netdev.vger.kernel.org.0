Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F35BCC802
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 07:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfJEFD2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Oct 2019 01:03:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62526 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726774AbfJEFD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 01:03:27 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x954xMmk004907
        for <netdev@vger.kernel.org>; Fri, 4 Oct 2019 22:03:26 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ved839s9n-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 22:03:26 -0700
Received: from 2401:db00:2050:5076:face:0:7:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 4 Oct 2019 22:03:25 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 13D6176091D; Fri,  4 Oct 2019 22:03:23 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 04/10] libbpf: auto-detect btf_id of raw_tracepoint
Date:   Fri, 4 Oct 2019 22:03:08 -0700
Message-ID: <20191005050314.1114330-5-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191005050314.1114330-1-ast@kernel.org>
References: <20191005050314.1114330-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-05_02:2019-10-03,2019-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=988
 mlxscore=0 impostorscore=0 clxscore=1034 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=3 adultscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910050044
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For raw tracepoint program types libbpf will try to find
btf_id of raw tracepoint in vmlinux's BTF.
It's a responsiblity of bpf program author to annotate the program
with SEC("raw_tracepoint/name") where "name" is a valid raw tracepoint.
If "name" is indeed a valid raw tracepoint then in-kernel BTF
will have "btf_trace_##name" typedef that points to function
prototype of that raw tracepoint. BTF description captures
exact argument the kernel C code is passing into raw tracepoint.
The kernel verifier will check the types while loading bpf program.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/libbpf.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e0276520171b..0e6f7b41c521 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4591,6 +4591,22 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 			continue;
 		*prog_type = section_names[i].prog_type;
 		*expected_attach_type = section_names[i].expected_attach_type;
+		if (*prog_type == BPF_PROG_TYPE_RAW_TRACEPOINT) {
+			struct btf *btf = bpf_core_find_kernel_btf();
+			char raw_tp_btf_name[128] = "btf_trace_";
+			int ret;
+
+			if (IS_ERR(btf))
+				/* lack of kernel BTF is not a failure */
+				return 0;
+			/* append "btf_trace_" prefix per kernel convention */
+			strcpy(raw_tp_btf_name + sizeof("btf_trace_") - 1,
+			       name + section_names[i].len);
+			ret = btf__find_by_name(btf, raw_tp_btf_name);
+			if (ret > 0)
+				*expected_attach_type = ret;
+			btf__free(btf);
+		}
 		return 0;
 	}
 	pr_warning("failed to guess program type based on ELF section name '%s'\n", name);
-- 
2.20.0

