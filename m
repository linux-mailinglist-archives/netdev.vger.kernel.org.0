Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACA4229F9E
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 20:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732575AbgGVSt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 14:49:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52350 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732437AbgGVSty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 14:49:54 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MIZLsK000877
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 11:49:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Qk19kIwjkqB1A54V2/PyYa8XpSAaPmHnZ6msm3VbtSw=;
 b=Vtv6vGJ+8HR+ReJRKcvocoxrneI9K4WWcRPmtGuRjtdhGQOGkxBL0kVCas8oCjt0crDy
 AEZxHZefkMaxXPUY7WWpXlckbRurg3QDD8y6TlNj/itAs/X3qURTUb90HY10jb0SA6uT
 DvuGaQDON589UEi6bz9HTUqaED1l1MBM2RA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32esyure16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 11:49:53 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 11:49:52 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 4041C3702F09; Wed, 22 Jul 2020 11:49:47 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 02/13] bpf: refactor to provide aux info to bpf_iter_init_seq_priv_t
Date:   Wed, 22 Jul 2020 11:49:47 -0700
Message-ID: <20200722184947.3777239-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200722184945.3777103-1-yhs@fb.com>
References: <20200722184945.3777103-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_10:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 suspectscore=8 impostorscore=0 mlxlogscore=932 phishscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007220119
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch refactored target bpf_iter_init_seq_priv_t callback
function to accept additional information. This will be needed
in later patches for map element targets since a particular
map should be passed to traverse elements for that particular
map. In the future, other information may be passed to target
as well, e.g., pid, cgroup id, etc. to customize the iterator.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 fs/proc/proc_net.c      | 2 +-
 include/linux/bpf.h     | 7 ++++++-
 include/linux/proc_fs.h | 3 ++-
 kernel/bpf/bpf_iter.c   | 2 +-
 kernel/bpf/task_iter.c  | 2 +-
 net/ipv4/tcp_ipv4.c     | 4 ++--
 net/ipv4/udp.c          | 4 ++--
 7 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index dba63b2429f0..ed8a6306990c 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -98,7 +98,7 @@ static const struct proc_ops proc_net_seq_ops =3D {
 	.proc_release	=3D seq_release_net,
 };
=20
-int bpf_iter_init_seq_net(void *priv_data)
+int bpf_iter_init_seq_net(void *priv_data, struct bpf_iter_aux_info *aux=
)
 {
 #ifdef CONFIG_NET_NS
 	struct seq_net_private *p =3D priv_data;
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cb14fbe68a75..392fd4cb2996 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -33,11 +33,13 @@ struct btf;
 struct btf_type;
 struct exception_table_entry;
 struct seq_operations;
+struct bpf_iter_aux_info;
=20
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
=20
-typedef int (*bpf_iter_init_seq_priv_t)(void *private_data);
+typedef int (*bpf_iter_init_seq_priv_t)(void *private_data,
+					struct bpf_iter_aux_info *aux);
 typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
 struct bpf_iter_seq_info {
 	const struct seq_operations *seq_ops;
@@ -1197,6 +1199,9 @@ int bpf_obj_get_user(const char __user *pathname, i=
nt flags);
 	extern int bpf_iter_ ## target(args);			\
 	int __init bpf_iter_ ## target(args) { return 0; }
=20
+struct bpf_iter_aux_info {
+};
+
 #define BPF_ITER_CTX_ARG_MAX 2
 struct bpf_iter_reg {
 	const char *target;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index d1eed1b43651..2df965cd0974 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -133,7 +133,8 @@ struct proc_dir_entry *proc_create_net_single_write(c=
onst char *name, umode_t mo
 						    void *data);
 extern struct pid *tgid_pidfd_to_pid(const struct file *file);
=20
-extern int bpf_iter_init_seq_net(void *priv_data);
+struct bpf_iter_aux_info;
+extern int bpf_iter_init_seq_net(void *priv_data, struct bpf_iter_aux_in=
fo *aux);
 extern void bpf_iter_fini_seq_net(void *priv_data);
=20
 #ifdef CONFIG_PROC_PID_ARCH_STATUS
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 5b2387d6aa1f..8fa94cb1b5a0 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -442,7 +442,7 @@ static int prepare_seq_file(struct file *file, struct=
 bpf_iter_link *link)
 	}
=20
 	if (tinfo->reg_info->seq_info->init_seq_private) {
-		err =3D tinfo->reg_info->seq_info->init_seq_private(priv_data->target_=
private);
+		err =3D tinfo->reg_info->seq_info->init_seq_private(priv_data->target_=
private, NULL);
 		if (err)
 			goto release_seq_file;
 	}
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 5e387e2cd309..eca3d80cdfd4 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -291,7 +291,7 @@ static void task_file_seq_stop(struct seq_file *seq, =
void *v)
 	}
 }
=20
-static int init_seq_pidns(void *priv_data)
+static int init_seq_pidns(void *priv_data, struct bpf_iter_aux_info *aux=
)
 {
 	struct bpf_iter_seq_task_common *common =3D priv_data;
=20
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 4ef85c97c183..fbe7ce58f23d 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2929,7 +2929,7 @@ static struct pernet_operations __net_initdata tcp_=
sk_ops =3D {
 DEFINE_BPF_ITER_FUNC(tcp, struct bpf_iter_meta *meta,
 		     struct sock_common *sk_common, uid_t uid)
=20
-static int bpf_iter_init_tcp(void *priv_data)
+static int bpf_iter_init_tcp(void *priv_data, struct bpf_iter_aux_info *=
aux)
 {
 	struct tcp_iter_state *st =3D priv_data;
 	struct tcp_seq_afinfo *afinfo;
@@ -2941,7 +2941,7 @@ static int bpf_iter_init_tcp(void *priv_data)
=20
 	afinfo->family =3D AF_UNSPEC;
 	st->bpf_seq_afinfo =3D afinfo;
-	ret =3D bpf_iter_init_seq_net(priv_data);
+	ret =3D bpf_iter_init_seq_net(priv_data, aux);
 	if (ret)
 		kfree(afinfo);
 	return ret;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 1c017427330f..50da385aae81 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3206,7 +3206,7 @@ static struct pernet_operations __net_initdata udp_=
sysctl_ops =3D {
 DEFINE_BPF_ITER_FUNC(udp, struct bpf_iter_meta *meta,
 		     struct udp_sock *udp_sk, uid_t uid, int bucket)
=20
-static int bpf_iter_init_udp(void *priv_data)
+static int bpf_iter_init_udp(void *priv_data, struct bpf_iter_aux_info *=
aux)
 {
 	struct udp_iter_state *st =3D priv_data;
 	struct udp_seq_afinfo *afinfo;
@@ -3219,7 +3219,7 @@ static int bpf_iter_init_udp(void *priv_data)
 	afinfo->family =3D AF_UNSPEC;
 	afinfo->udp_table =3D &udp_table;
 	st->bpf_seq_afinfo =3D afinfo;
-	ret =3D bpf_iter_init_seq_net(priv_data);
+	ret =3D bpf_iter_init_seq_net(priv_data, aux);
 	if (ret)
 		kfree(afinfo);
 	return ret;
--=20
2.24.1

