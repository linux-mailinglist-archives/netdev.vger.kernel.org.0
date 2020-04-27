Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DF21BAEF8
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgD0UMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:12:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27166 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726691AbgD0UMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:12:44 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RKAosM031163
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Da6UDGt3lG2iJVQ0cQ3wR/0fwkL13a9PMcM4yHMVWog=;
 b=eUUBi/NPNr09GAcpKGrLP3XD31+rr6w1IatSyM/gbbk9d4M4BwRPN4p45+mLnQdqo6WF
 bvUsXK1tEOYUvozuMHWKitPfwj+NKCrNd7woXoR5BL3F2XQkc91KFARUW1eO1nxfar3N
 qJ9Vwz4IPRDAOJD5I3iP0M3WpWlpzQJ/5wY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n57q245v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:44 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 13:12:43 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 9FA583700871; Mon, 27 Apr 2020 13:12:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v1 06/19] bpf: support bpf tracing/iter programs for BPF_LINK_UPDATE
Date:   Mon, 27 Apr 2020 13:12:41 -0700
Message-ID: <20200427201241.2995075-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427201235.2994549-1-yhs@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004270164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added BPF_LINK_UPDATE support for tracing/iter programs.
This way, a file based bpf iterator, which holds a reference
to the link, can have its bpf program updated without
creating new files.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h   |  2 ++
 kernel/bpf/bpf_iter.c | 29 +++++++++++++++++++++++++++++
 kernel/bpf/syscall.c  |  5 +++++
 3 files changed, 36 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 60ecb73d8f6d..4fc39d9b5cd0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1131,6 +1131,8 @@ struct bpf_prog *bpf_iter_get_prog(struct seq_file =
*seq, u32 priv_data_size,
 				   u64 *session_id, u64 *seq_num, bool is_last);
 int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
 int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *pr=
og);
+int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_pr=
og,
+			  struct bpf_prog *new_prog);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 9532e7bcb8e1..fc1ce5ee5c3f 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -23,6 +23,9 @@ static struct list_head targets;
 static struct mutex targets_mutex;
 static bool bpf_iter_inited =3D false;
=20
+/* protect bpf_iter_link.link->prog upddate */
+static struct mutex bpf_iter_mutex;
+
 int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
 {
 	struct bpf_iter_target_info *tinfo;
@@ -33,6 +36,7 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
 	if (!bpf_iter_inited) {
 		INIT_LIST_HEAD(&targets);
 		mutex_init(&targets_mutex);
+		mutex_init(&bpf_iter_mutex);
 		bpf_iter_inited =3D true;
 	}
=20
@@ -121,3 +125,28 @@ int bpf_iter_link_attach(const union bpf_attr *attr,=
 struct bpf_prog *prog)
 		kfree(link);
 	return err;
 }
+
+int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_pr=
og,
+			  struct bpf_prog *new_prog)
+{
+	int ret =3D 0;
+
+	mutex_lock(&bpf_iter_mutex);
+	if (old_prog && link->prog !=3D old_prog) {
+		ret =3D -EPERM;
+		goto out_unlock;
+	}
+
+	if (link->prog->type !=3D new_prog->type ||
+	    link->prog->expected_attach_type !=3D new_prog->expected_attach_typ=
e ||
+	    strcmp(link->prog->aux->attach_func_name, new_prog->aux->attach_fun=
c_name)) {
+		ret =3D -EINVAL;
+		goto out_unlock;
+	}
+
+	link->prog =3D new_prog;
+
+out_unlock:
+	mutex_unlock(&bpf_iter_mutex);
+	return ret;
+}
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8741b5e11c85..b7af4f006f2e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3679,6 +3679,11 @@ static int link_update(union bpf_attr *attr)
 		goto out_put_progs;
 	}
 #endif
+
+	if (link->ops =3D=3D &bpf_iter_link_lops) {
+		ret =3D bpf_iter_link_replace(link, old_prog, new_prog);
+		goto out_put_progs;
+	}
 	ret =3D -EINVAL;
=20
 out_put_progs:
--=20
2.24.1

