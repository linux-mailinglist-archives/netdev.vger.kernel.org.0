Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02B528690F
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgJGUaD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 7 Oct 2020 16:30:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36314 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728476AbgJGUaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 16:30:02 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 097KSi6p017778
        for <netdev@vger.kernel.org>; Wed, 7 Oct 2020 13:30:01 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 33xmypddke-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 13:30:01 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 7 Oct 2020 13:29:59 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 787222EC7B90; Wed,  7 Oct 2020 13:29:54 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v2 bpf-next 3/4] libbpf: allow specifying both ELF and raw BTF for CO-RE BTF override
Date:   Wed, 7 Oct 2020 13:29:45 -0700
Message-ID: <20201007202946.3684483-4-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201007202946.3684483-1-andrii@kernel.org>
References: <20201007202946.3684483-1-andrii@kernel.org>
MIME-Version: 1.0
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 phishscore=0 malwarescore=0 impostorscore=0 suspectscore=8
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

Use generalized BTF parsing logic, making it possible to parse BTF both from
ELF file, as well as a raw BTF dump. This makes it easier to write custom
tests with manually generated BTFs.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 032cf0049ddb..105cb8ad1d75 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5842,7 +5842,7 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 		return 0;
 
 	if (targ_btf_path)
-		targ_btf = btf__parse_elf(targ_btf_path, NULL);
+		targ_btf = btf__parse(targ_btf_path, NULL);
 	else
 		targ_btf = obj->btf_vmlinux;
 	if (IS_ERR_OR_NULL(targ_btf)) {
-- 
2.24.1

