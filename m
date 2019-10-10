Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA722D1F59
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732679AbfJJEPW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Oct 2019 00:15:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27604 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729349AbfJJEPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:15:20 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9A4E6eR014695
        for <netdev@vger.kernel.org>; Wed, 9 Oct 2019 21:15:19 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vhfsdutyx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:15:19 -0700
Received: from 2401:db00:2050:5102:face:0:3b:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 9 Oct 2019 21:15:18 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 7CD41760CF9; Wed,  9 Oct 2019 21:15:17 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 07/12] bpf: attach raw_tp program with BTF via type name
Date:   Wed, 9 Oct 2019 21:14:58 -0700
Message-ID: <20191010041503.2526303-8-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010041503.2526303-1-ast@kernel.org>
References: <20191010041503.2526303-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_02:2019-10-08,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=4
 clxscore=1034 mlxlogscore=893 spamscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100037
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BTF type id specified at program load time has all
necessary information to attach that program to raw tracepoint.
Use kernel type name to find raw tracepoint.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/syscall.c | 67 +++++++++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 23 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b56c482c9760..03f36e73d84a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1816,17 +1816,49 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 	struct bpf_raw_tracepoint *raw_tp;
 	struct bpf_raw_event_map *btp;
 	struct bpf_prog *prog;
-	char tp_name[128];
+	const char *tp_name;
+	char buf[128];
 	int tp_fd, err;
 
-	if (strncpy_from_user(tp_name, u64_to_user_ptr(attr->raw_tracepoint.name),
-			      sizeof(tp_name) - 1) < 0)
-		return -EFAULT;
-	tp_name[sizeof(tp_name) - 1] = 0;
+	prog = bpf_prog_get(attr->raw_tracepoint.prog_fd);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	if (prog->type != BPF_PROG_TYPE_RAW_TRACEPOINT &&
+	    prog->type != BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE) {
+		err = -EINVAL;
+		goto out_put_prog;
+	}
+
+	if (prog->type == BPF_PROG_TYPE_RAW_TRACEPOINT &&
+	    prog->aux->attach_btf_id) {
+		if (attr->raw_tracepoint.name) {
+			/* raw_tp name should not be specified in raw_tp
+			 * programs that were verified via in-kernel BTF info
+			 */
+			err = -EINVAL;
+			goto out_put_prog;
+		}
+		/* raw_tp name is taken from type name instead */
+		tp_name = kernel_type_name(prog->aux->attach_btf_id);
+		/* skip the prefix */
+		tp_name += sizeof("btf_trace_") - 1;
+	} else {
+		if (strncpy_from_user(buf,
+				      u64_to_user_ptr(attr->raw_tracepoint.name),
+				      sizeof(buf) - 1) < 0) {
+			err = -EFAULT;
+			goto out_put_prog;
+		}
+		buf[sizeof(buf) - 1] = 0;
+		tp_name = buf;
+	}
 
 	btp = bpf_get_raw_tracepoint(tp_name);
-	if (!btp)
-		return -ENOENT;
+	if (!btp) {
+		err = -ENOENT;
+		goto out_put_prog;
+	}
 
 	raw_tp = kzalloc(sizeof(*raw_tp), GFP_USER);
 	if (!raw_tp) {
@@ -1834,38 +1866,27 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 		goto out_put_btp;
 	}
 	raw_tp->btp = btp;
-
-	prog = bpf_prog_get(attr->raw_tracepoint.prog_fd);
-	if (IS_ERR(prog)) {
-		err = PTR_ERR(prog);
-		goto out_free_tp;
-	}
-	if (prog->type != BPF_PROG_TYPE_RAW_TRACEPOINT &&
-	    prog->type != BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE) {
-		err = -EINVAL;
-		goto out_put_prog;
-	}
+	raw_tp->prog = prog;
 
 	err = bpf_probe_register(raw_tp->btp, prog);
 	if (err)
-		goto out_put_prog;
+		goto out_free_tp;
 
-	raw_tp->prog = prog;
 	tp_fd = anon_inode_getfd("bpf-raw-tracepoint", &bpf_raw_tp_fops, raw_tp,
 				 O_CLOEXEC);
 	if (tp_fd < 0) {
 		bpf_probe_unregister(raw_tp->btp, prog);
 		err = tp_fd;
-		goto out_put_prog;
+		goto out_free_tp;
 	}
 	return tp_fd;
 
-out_put_prog:
-	bpf_prog_put(prog);
 out_free_tp:
 	kfree(raw_tp);
 out_put_btp:
 	bpf_put_raw_tracepoint(btp);
+out_put_prog:
+	bpf_prog_put(prog);
 	return err;
 }
 
-- 
2.23.0

