Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8253D8667
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390978AbfJPDZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:25:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7258 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390970AbfJPDZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:25:30 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9G3PK1j030313
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:25:29 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnpry107r-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:25:28 -0700
Received: from 2401:db00:2120:81ca:face:0:31:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Oct 2019 20:25:21 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 002EE760F32; Tue, 15 Oct 2019 20:25:20 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 07/11] bpf: attach raw_tp program with BTF via type name
Date:   Tue, 15 Oct 2019 20:25:01 -0700
Message-ID: <20191016032505.2089704-8-ast@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016032505.2089704-1-ast@kernel.org>
References: <20191016032505.2089704-1-ast@kernel.org>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_01:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 suspectscore=4 clxscore=1015 priorityscore=1501
 spamscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 mlxlogscore=922 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160029
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BTF type id specified at program load time has all
necessary information to attach that program to raw tracepoint.
Use kernel type name to find raw tracepoint.

Add missing CHECK_ATTR() condition.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
There is a tiny chance that CHECK_ATTR() may break some user space.
In such case the CHECK_ATTR change will be reverted.
---
 kernel/bpf/syscall.c | 70 +++++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 23 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b56c482c9760..523e3ac15a08 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1816,17 +1816,52 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
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
+	if (CHECK_ATTR(BPF_RAW_TRACEPOINT_OPEN))
+		return -EINVAL;
+
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
@@ -1834,38 +1869,27 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
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
2.17.1

