Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB06B5482
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 19:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731360AbfIQRpp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 17 Sep 2019 13:45:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8196 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725862AbfIQRpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 13:45:45 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8HHhMkH030334
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 10:45:44 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2v31rrrsr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 10:45:44 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 17 Sep 2019 10:45:42 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 9834876081D; Tue, 17 Sep 2019 10:45:40 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 1/2] bpf: fix BTF verification of enums
Date:   Tue, 17 Sep 2019 10:45:37 -0700
Message-ID: <20190917174538.1295523-2-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190917174538.1295523-1-ast@kernel.org>
References: <20190917174538.1295523-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-17_09:2019-09-17,2019-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 lowpriorityscore=0 mlxscore=0 phishscore=0 adultscore=0 bulkscore=0
 mlxlogscore=782 priorityscore=1501 malwarescore=0 spamscore=0
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909170171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vmlinux BTF has enums that are 8 byte and 1 byte in size.
2 byte enum is a valid construct as well.
Fix BTF enum verification to accept those sizes.

Fixes: 69b693f0aefa ("bpf: btf: Introduce BPF Type Format (BTF)")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/btf.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index adb3adcebe3c..722d38e543e9 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2377,9 +2377,8 @@ static s32 btf_enum_check_meta(struct btf_verifier_env *env,
 		return -EINVAL;
 	}
 
-	if (t->size != sizeof(int)) {
-		btf_verifier_log_type(env, t, "Expected size:%zu",
-				      sizeof(int));
+	if (t->size > 8 || !is_power_of_2(t->size)) {
+		btf_verifier_log_type(env, t, "Unexpected size");
 		return -EINVAL;
 	}
 
-- 
2.20.0

