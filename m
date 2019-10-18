Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3B4DBD85
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 08:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407016AbfJRGJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 02:09:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58526 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392117AbfJRGJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 02:09:36 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9I65erP020111
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 23:09:35 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vq5d88f14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 23:09:35 -0700
Received: from 2401:db00:2050:5076:face:0:1f:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 17 Oct 2019 23:09:34 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 7A84D760F52; Thu, 17 Oct 2019 23:09:33 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf: fix bpf_attr.attach_btf_id check
Date:   Thu, 17 Oct 2019 23:09:33 -0700
Message-ID: <20191018060933.2950231-1-ast@kernel.org>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_01:2019-10-17,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=660 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 suspectscore=1 adultscore=0 phishscore=0 clxscore=1034 mlxscore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910180059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only raw_tracepoint program type can have bpf_attr.attach_btf_id >= 0.
Make sure to reject other program types that accidentally set it to non-zero.

Fixes: ccfe29eb29c2 ("bpf: Add attach_btf_id attribute to program load")
Reported-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/syscall.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 523e3ac15a08..16ea3c0db4f6 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1570,6 +1570,17 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 			   enum bpf_attach_type expected_attach_type,
 			   u32 btf_id)
 {
+	switch (prog_type) {
+	case BPF_PROG_TYPE_RAW_TRACEPOINT:
+		if (btf_id > BTF_MAX_TYPE)
+			return -EINVAL;
+		break;
+	default:
+		if (btf_id)
+			return -EINVAL;
+		break;
+	}
+
 	switch (prog_type) {
 	case BPF_PROG_TYPE_CGROUP_SOCK:
 		switch (expected_attach_type) {
@@ -1610,13 +1621,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		default:
 			return -EINVAL;
 		}
-	case BPF_PROG_TYPE_RAW_TRACEPOINT:
-		if (btf_id > BTF_MAX_TYPE)
-			return -EINVAL;
-		return 0;
 	default:
-		if (btf_id)
-			return -EINVAL;
 		return 0;
 	}
 }
-- 
2.17.1

