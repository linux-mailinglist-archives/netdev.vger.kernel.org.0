Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5E5348840
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 06:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhCYFL7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Mar 2021 01:11:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27572 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229666AbhCYFLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 01:11:36 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12P59JMO029511
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 22:11:35 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 37fjdmaxbx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 22:11:35 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 22:11:34 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6480F2ED2C80; Wed, 24 Mar 2021 22:11:33 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH bpf-next] libbpf: preserve empty DATASEC BTFs during static linking
Date:   Wed, 24 Mar 2021 22:11:31 -0700
Message-ID: <20210325051131.984322-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-24_14:2021-03-24,2021-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 bulkscore=0 suspectscore=0 mlxscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103250037
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that BPF static linker preserves all DATASEC BTF types, even if some of
them might not have any variable information at all. It's not completely clear
in which cases Clang chooses to not emit variable information, so adding
reliable repro is hard. But manual testing showed that this work correctly.

Reported-by: Alexei Starovoitov <ast@kernel.org>
Fixes: 8fd27bf69b86 ("libbpf: Add BPF static linker BTF and BTF.ext support")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/linker.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 5e0aa2f2c0ca..2c43943da30c 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -94,6 +94,7 @@ struct dst_sec {
 	int sec_sym_idx;
 
 	/* section's DATASEC variable info, emitted on BTF finalization */
+	bool has_btf;
 	int sec_var_cnt;
 	struct btf_var_secinfo *sec_vars;
 
@@ -1436,6 +1437,15 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
 			continue;
 		dst_sec = &linker->secs[src_sec->dst_id];
 
+		/* Mark section as having BTF regardless of the presence of
+		 * variables. It seems to happen sometimes when BPF object
+		 * file has only static variables inside functions, not
+		 * globally, that DATASEC BTF with zero variables will be
+		 * emitted by Clang. We need to preserve such empty BTF and
+		 * just set correct section size.
+		 */
+		dst_sec->has_btf = true;
+
 		t = btf__type_by_id(obj->btf, src_sec->sec_type_id);
 		src_var = btf_var_secinfos(t);
 		n = btf_vlen(t);
@@ -1717,7 +1727,7 @@ static int finalize_btf(struct bpf_linker *linker)
 	for (i = 1; i < linker->sec_cnt; i++) {
 		struct dst_sec *sec = &linker->secs[i];
 
-		if (!sec->sec_var_cnt)
+		if (!sec->has_btf)
 			continue;
 
 		id = btf__add_datasec(btf, sec->sec_name, sec->sec_sz);
-- 
2.30.2

