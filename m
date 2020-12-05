Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F712CF922
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 04:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgLEDKg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 4 Dec 2020 22:10:36 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21514 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727245AbgLEDKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 22:10:36 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B534L83002455
        for <netdev@vger.kernel.org>; Fri, 4 Dec 2020 19:09:55 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 357tfmt7r0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 19:09:55 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 19:09:54 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1BB8E2ECABAC; Fri,  4 Dec 2020 19:09:53 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH bpf-next] bpf: return -EOPNOTSUPP when attaching to non-kernel BTF
Date:   Fri, 4 Dec 2020 19:09:51 -0800
Message-ID: <20201205030952.520743-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_13:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 suspectscore=8
 malwarescore=0 clxscore=1034 spamscore=0 bulkscore=0 mlxlogscore=988
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012050019
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return -EOPNOTSUPP if tracing BPF program is attempted to be attached with
specified attach_btf_obj_fd pointing to non-kernel (neither vmlinux nor
module) BTF object. This scenario might be supported in the future and isn't
outright invalid, so -EINVAL isn't the most appropriate error code.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 kernel/bpf/syscall.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 0cd3cc2af9c1..7e2bf671c6db 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2121,8 +2121,11 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 			if (IS_ERR(attach_btf))
 				return -EINVAL;
 			if (!btf_is_kernel(attach_btf)) {
+				/* attaching through specifying bpf_prog's BTF
+				 * objects directly might be supported eventually
+				 */
 				btf_put(attach_btf);
-				return -EINVAL;
+				return -EOPNOTSUPP;
 			}
 		}
 	} else if (attr->attach_btf_id) {
-- 
2.24.1

