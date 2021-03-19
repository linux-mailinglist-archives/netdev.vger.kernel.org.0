Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91FA342747
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhCSU7y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Mar 2021 16:59:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22420 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230218AbhCSU7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 16:59:22 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JKuRiM005100
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 13:59:22 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37bs1wd1v1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 13:59:22 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 19 Mar 2021 13:59:21 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 41FA52ED268B; Fri, 19 Mar 2021 13:59:15 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH bpf-next 2/3] libbpf: skip BTF fixup if object file has no BTF
Date:   Fri, 19 Mar 2021 13:59:08 -0700
Message-ID: <20210319205909.1748642-3-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210319205909.1748642-1-andrii@kernel.org>
References: <20210319205909.1748642-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_12:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190143
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Skip BTF fixup step when input object file is missing BTF altogether.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Fixes: 8fd27bf69b86 ("libbpf: Add BPF static linker BTF and BTF.ext support")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/linker.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index b4fff912dce2..5e0aa2f2c0ca 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -1313,6 +1313,9 @@ static int linker_fixup_btf(struct src_obj *obj)
 	struct src_sec *sec;
 	int i, j, n, m;
 
+	if (!obj->btf)
+		return 0;
+
 	n = btf__get_nr_types(obj->btf);
 	for (i = 1; i <= n; i++) {
 		struct btf_var_secinfo *vi;
-- 
2.30.2

