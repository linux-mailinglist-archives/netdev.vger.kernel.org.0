Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114EA2AE746
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 05:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgKKEHA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 Nov 2020 23:07:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58464 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725852AbgKKEHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 23:07:00 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AB3xGrK014899
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 20:06:58 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34qye8jvkk-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 20:06:58 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 10 Nov 2020 20:06:57 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6880A2EC9377; Tue, 10 Nov 2020 20:06:51 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH bpf-next] bpf: compile out btf_parse_module() if module BTF is not enabled
Date:   Tue, 10 Nov 2020 20:06:45 -0800
Message-ID: <20201111040645.903494-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-11_01:2020-11-10,2020-11-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=8 malwarescore=0 spamscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110018
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure btf_parse_module() is compiled out if module BTFs are not enabled.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 36e68442d1af ("bpf: Load and verify kernel module BTFs")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 kernel/bpf/btf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0f1fd2669d69..6b2d508b33d4 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4478,6 +4478,8 @@ struct btf *btf_parse_vmlinux(void)
 	return ERR_PTR(err);
 }
 
+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+
 static struct btf *btf_parse_module(const char *module_name, const void *data, unsigned int data_size)
 {
 	struct btf_verifier_env *env = NULL;
@@ -4547,6 +4549,8 @@ static struct btf *btf_parse_module(const char *module_name, const void *data, u
 	return ERR_PTR(err);
 }
 
+#endif /* CONFIG_DEBUG_INFO_BTF_MODULES */
+
 struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
 {
 	struct bpf_prog *tgt_prog = prog->aux->dst_prog;
-- 
2.24.1

