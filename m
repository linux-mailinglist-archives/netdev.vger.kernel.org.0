Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353DA34A08A
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 05:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhCZEb0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Mar 2021 00:31:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40060 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230239AbhCZEaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 00:30:55 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12Q4T5AM015898
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 21:30:54 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37h13ct1qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 21:30:54 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 25 Mar 2021 21:30:53 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CF18F2ED2DAE; Thu, 25 Mar 2021 21:30:40 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH v2 bpf-next] libbpf: preserve empty DATASEC BTFs during static linking
Date:   Thu, 25 Mar 2021 21:30:36 -0700
Message-ID: <20210326043036.3081011-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: o3OdQDHf0yEzccq58pPfR3-FF7hv1x_r
X-Proofpoint-GUID: o3OdQDHf0yEzccq58pPfR3-FF7hv1x_r
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-26_01:2021-03-25,2021-03-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0
 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260031
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that BPF static linker preserves all DATASEC BTF types, even if some of
them might not have any variable information at all. This may happen if the
compiler promotes local initialized variable contents into .rodata section and
there are no global or static functions in the program.

For example,

  $ cat t.c
  struct t { char a; char b; char c; };
  void bar(struct t*);
  void find() {
     struct t tmp = {1, 2, 3};
     bar(&tmp);
  }

  $ clang -target bpf -O2 -g -S t.c
         .long   104                             # BTF_KIND_DATASEC(id = 8)
         .long   251658240                       # 0xf000000
         .long   0

         .ascii  ".rodata"                       # string offset=104

  $ clang -target bpf -O2 -g -c t.c
  $ readelf -S t.o | grep data
     [ 4] .rodata           PROGBITS         0000000000000000  00000090

Acked-by: Yonghong Song <yhs@fb.com>
Reported-by: Alexei Starovoitov <ast@kernel.org>
Fixes: 8fd27bf69b86 ("libbpf: Add BPF static linker BTF and BTF.ext support")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/linker.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 5e0aa2f2c0ca..a29d62ff8041 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -94,6 +94,7 @@ struct dst_sec {
 	int sec_sym_idx;
 
 	/* section's DATASEC variable info, emitted on BTF finalization */
+	bool has_btf;
 	int sec_var_cnt;
 	struct btf_var_secinfo *sec_vars;
 
@@ -1436,6 +1437,16 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
 			continue;
 		dst_sec = &linker->secs[src_sec->dst_id];
 
+		/* Mark section as having BTF regardless of the presence of
+		 * variables. In some cases compiler might generate empty BTF
+		 * with no variables information. E.g., when promoting local
+		 * array/structure variable initial values and BPF object
+		 * file otherwise has no read-only static variables in
+		 * .rodata. We need to preserve such empty BTF and just set
+		 * correct section size.
+		 */
+		dst_sec->has_btf = true;
+
 		t = btf__type_by_id(obj->btf, src_sec->sec_type_id);
 		src_var = btf_var_secinfos(t);
 		n = btf_vlen(t);
@@ -1717,7 +1728,7 @@ static int finalize_btf(struct bpf_linker *linker)
 	for (i = 1; i < linker->sec_cnt; i++) {
 		struct dst_sec *sec = &linker->secs[i];
 
-		if (!sec->sec_var_cnt)
+		if (!sec->has_btf)
 			continue;
 
 		id = btf__add_datasec(btf, sec->sec_name, sec->sec_sz);
-- 
2.30.2

