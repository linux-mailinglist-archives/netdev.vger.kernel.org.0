Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E37422A8AC
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgGWGPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:15:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60186 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726141AbgGWGPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:15:40 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06N69n1N020018
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 23:15:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=k24QbokE9aX9nRasEeGjVF0GQRdNwwU03AMNX29hlWw=;
 b=Zzu8Ovl0Jbj9OO2glEsbg3RqxHsXoFhg+lpP2diawRDHx42JDjIJfMkpblz4+IjsSf5H
 h0z1vtPrLzseVjIHG6odUPtmJlzeiE6GQmP2es8f9zsnI/ncsWhBkvUPVZqbvQwlSJ41
 p/o9+ixZoVENyDNZSbMApfgBy8KpQKx1Q2w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32et5ktrtj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 23:15:39 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 23:15:37 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 257B43705266; Wed, 22 Jul 2020 23:15:35 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 02/13] bpf: refactor to provide aux info to bpf_iter_init_seq_priv_t
Date:   Wed, 22 Jul 2020 23:15:35 -0700
Message-ID: <20200723061535.2099990-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200723061533.2099842-1-yhs@fb.com>
References: <20200723061533.2099842-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_02:2020-07-22,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 phishscore=0 adultscore=0 priorityscore=1501
 suspectscore=8 malwarescore=0 bulkscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 mlxlogscore=942 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007230050
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
index 127067f71fd4..ef52717336cf 100644
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
@@ -1198,6 +1200,9 @@ int bpf_obj_get_user(const char __user *pathname, i=
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
index 6d9cd23869bf..232df29793e9 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -293,7 +293,7 @@ static void task_file_seq_stop(struct seq_file *seq, =
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
index 5e029c0c0907..09fea0650009 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2921,7 +2921,7 @@ static struct pernet_operations __net_initdata tcp_=
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
@@ -2933,7 +2933,7 @@ static int bpf_iter_init_tcp(void *priv_data)
=20
 	afinfo->family =3D AF_UNSPEC;
 	st->bpf_seq_afinfo =3D afinfo;
-	ret =3D bpf_iter_init_seq_net(priv_data);
+	ret =3D bpf_iter_init_seq_net(priv_data, aux);
 	if (ret)
 		kfree(afinfo);
 	return ret;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 6879ff80c3d0..9397690b3737 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3179,7 +3179,7 @@ static struct pernet_operations __net_initdata udp_=
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
@@ -3192,7 +3192,7 @@ static int bpf_iter_init_udp(void *priv_data)
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

