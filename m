Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7D1347F5E
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 18:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbhCXRat convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 24 Mar 2021 13:30:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54544 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237030AbhCXRaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 13:30:18 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12OHT1cT020868
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 10:30:17 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37fpghpana-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 10:30:17 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 10:30:01 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 503682ED2BAA; Wed, 24 Mar 2021 10:29:57 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next] libbpf: constify few bpf_program getters
Date:   Wed, 24 Mar 2021 10:29:41 -0700
Message-ID: <20210324172941.2609884-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-24_13:2021-03-24,2021-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=920 priorityscore=1501 suspectscore=0 malwarescore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103240127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_program__get_type() and bpf_program__get_expected_attach_type() shouldn't
modify given bpf_program, so mark input parameter as const struct bpf_program.
This eliminates unnecessary compilation warnings or explicit casts in user
programs.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c | 4 ++--
 tools/lib/bpf/libbpf.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 058b643cbcb1..cac56381ee59 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8457,7 +8457,7 @@ int bpf_program__nth_fd(const struct bpf_program *prog, int n)
 	return fd;
 }
 
-enum bpf_prog_type bpf_program__get_type(struct bpf_program *prog)
+enum bpf_prog_type bpf_program__get_type(const struct bpf_program *prog)
 {
 	return prog->type;
 }
@@ -8502,7 +8502,7 @@ BPF_PROG_TYPE_FNS(extension, BPF_PROG_TYPE_EXT);
 BPF_PROG_TYPE_FNS(sk_lookup, BPF_PROG_TYPE_SK_LOOKUP);
 
 enum bpf_attach_type
-bpf_program__get_expected_attach_type(struct bpf_program *prog)
+bpf_program__get_expected_attach_type(const struct bpf_program *prog)
 {
 	return prog->expected_attach_type;
 }
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index a1a424b9b8ff..89ade7d7b31c 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -361,12 +361,12 @@ LIBBPF_API int bpf_program__set_struct_ops(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_extension(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_sk_lookup(struct bpf_program *prog);
 
-LIBBPF_API enum bpf_prog_type bpf_program__get_type(struct bpf_program *prog);
+LIBBPF_API enum bpf_prog_type bpf_program__get_type(const struct bpf_program *prog);
 LIBBPF_API void bpf_program__set_type(struct bpf_program *prog,
 				      enum bpf_prog_type type);
 
 LIBBPF_API enum bpf_attach_type
-bpf_program__get_expected_attach_type(struct bpf_program *prog);
+bpf_program__get_expected_attach_type(const struct bpf_program *prog);
 LIBBPF_API void
 bpf_program__set_expected_attach_type(struct bpf_program *prog,
 				      enum bpf_attach_type type);
-- 
2.30.2

