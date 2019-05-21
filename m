Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9C8125AAF
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 01:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfEUXJs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 May 2019 19:09:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45966 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726434AbfEUXJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 19:09:47 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4LN7sCP020417
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 16:09:46 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2smcnptyct-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 16:09:46 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 21 May 2019 16:09:44 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id C0A47760BE8; Tue, 21 May 2019 16:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/3] bpf: bump jmp sequence limit
Date:   Tue, 21 May 2019 16:09:37 -0700
Message-ID: <20190521230939.2149151-2-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190521230939.2149151-1-ast@kernel.org>
References: <20190521230939.2149151-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-21_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=929 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905210144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The limit of 1024 subsequent jumps was causing otherwise valid
programs to be rejected. Bump it to 8192 and make the error more verbose.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 082f6eefb1c4..4113e829616d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -176,7 +176,7 @@ struct bpf_verifier_stack_elem {
 	struct bpf_verifier_stack_elem *next;
 };
 
-#define BPF_COMPLEXITY_LIMIT_STACK	1024
+#define BPF_COMPLEXITY_LIMIT_JMP_SEQ	8192
 #define BPF_COMPLEXITY_LIMIT_STATES	64
 
 #define BPF_MAP_PTR_UNPRIV	1UL
@@ -782,8 +782,9 @@ static struct bpf_verifier_state *push_stack(struct bpf_verifier_env *env,
 	if (err)
 		goto err;
 	elem->st.speculative |= speculative;
-	if (env->stack_size > BPF_COMPLEXITY_LIMIT_STACK) {
-		verbose(env, "BPF program is too complex\n");
+	if (env->stack_size > BPF_COMPLEXITY_LIMIT_JMP_SEQ) {
+		verbose(env, "The sequence of %d jumps is too complex.\n",
+			env->stack_size);
 		goto err;
 	}
 	return &elem->st;
-- 
2.20.0

