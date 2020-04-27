Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C49F1BB216
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 01:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgD0Xoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 19:44:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62338 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726271AbgD0Xoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 19:44:37 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RNemHB000483
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:44:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=4Nr5kW5zN85Qw9/O6WloYn6CKqpyiv9fLB56zEQr2XU=;
 b=V4Tl3/owd3CqBrEvUe4KBvZksWClJZl6MKkLPJF87MJQ+9tYaZW3JFsbPPnAsDkiOYaL
 y3QPMTPeGYxosD3K0gm99fpxlytbtY/gTgj+g1gweGBDbBU/vqYC75FJ5F6rgci90i/+
 pJeU7oCpLYlp13k67Opuws0rrgEWMZhlzGI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n57q380w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:44:37 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 16:44:36 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 0A70162E3380; Mon, 27 Apr 2020 16:44:32 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v5 bpf-next 1/3] bpf: sharing bpf runtime stats with BPF_ENABLE_STATS
Date:   Mon, 27 Apr 2020 16:44:21 -0700
Message-ID: <20200427234423.998085-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427234423.998085-1-songliubraving@fb.com>
References: <20200427234423.998085-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_17:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004270193
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, sysctl kernel.bpf_stats_enabled controls BPF runtime stats.
Typical userspace tools use kernel.bpf_stats_enabled as follows:

  1. Enable kernel.bpf_stats_enabled;
  2. Check program run_time_ns;
  3. Sleep for the monitoring period;
  4. Check program run_time_ns again, calculate the difference;
  5. Disable kernel.bpf_stats_enabled.

The problem with this approach is that only one userspace tool can toggle
this sysctl. If multiple tools toggle the sysctl at the same time, the
measurement may be inaccurate.

To fix this problem while keep backward compatibility, introduce a new
bpf command BPF_ENABLE_STATS. On success, this command enables stats and
returns a valid fd. BPF_ENABLE_STATS takes argument "type". Currently,
only one type, BPF_STATS_RUNTIME_CNT, is supported. We can extend the
command to support other types of stats in the future.

With BPF_ENABLE_STATS, user space tool would have the following flow:

  1. Get a fd with BPF_ENABLE_STATS, and make sure it is valid;
  2. Check program run_time_ns;
  3. Sleep for the monitoring period;
  4. Check program run_time_ns again, calculate the difference;
  5. Close the fd.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 11 ++++++++
 kernel/bpf/syscall.c           | 50 ++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                | 36 +++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h | 11 ++++++++
 5 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 10960cfabea4..09ba490a0500 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -987,6 +987,7 @@ _out:							\
=20
 #ifdef CONFIG_BPF_SYSCALL
 DECLARE_PER_CPU(int, bpf_prog_active);
+extern struct mutex bpf_stats_enabled_mutex;
=20
 /*
  * Block execution of BPF programs attached to instrumentation (perf,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4a6c47f3febe..fd7c64139f21 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -113,6 +113,7 @@ enum bpf_cmd {
 	BPF_MAP_DELETE_BATCH,
 	BPF_LINK_CREATE,
 	BPF_LINK_UPDATE,
+	BPF_ENABLE_STATS,
 };
=20
 enum bpf_map_type {
@@ -379,6 +380,12 @@ enum {
  */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
=20
+/* type for BPF_ENABLE_STATS */
+enum bpf_stats_type {
+	/* enabled run_time_ns and run_cnt */
+	BPF_STATS_RUNTIME_CNT =3D 0,
+};
+
 enum bpf_stack_build_id_status {
 	/* user space need an empty entry to identify end of a trace */
 	BPF_STACK_BUILD_ID_EMPTY =3D 0,
@@ -589,6 +596,10 @@ union bpf_attr {
 		__u32		old_prog_fd;
 	} link_update;
=20
+	struct { /* struct used by BPF_ENABLE_STATS command */
+		__u32		type;
+	} enable_stats;
+
 } __attribute__((aligned(8)));
=20
 /* The description below is an attempt at providing documentation to eBP=
F
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 7626b8024471..1740a87b99f3 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3663,6 +3663,53 @@ static int link_update(union bpf_attr *attr)
 	return ret;
 }
=20
+DEFINE_MUTEX(bpf_stats_enabled_mutex);
+
+static int bpf_stats_release(struct inode *inode, struct file *file)
+{
+	mutex_lock(&bpf_stats_enabled_mutex);
+	static_key_slow_dec(&bpf_stats_enabled_key.key);
+	mutex_unlock(&bpf_stats_enabled_mutex);
+	return 0;
+}
+
+static const struct file_operations bpf_stats_fops =3D {
+	.release =3D bpf_stats_release,
+};
+
+static int bpf_enable_runtime_stats(void)
+{
+	int fd;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	mutex_lock(&bpf_stats_enabled_mutex);
+	/* Set a very high limit to avoid overflow */
+	if (static_key_count(&bpf_stats_enabled_key.key) > INT_MAX / 2) {
+		mutex_unlock(&bpf_stats_enabled_mutex);
+		return -EBUSY;
+	}
+
+	fd =3D anon_inode_getfd("bpf-stats", &bpf_stats_fops, NULL, 0);
+	if (fd >=3D 0)
+		static_key_slow_inc(&bpf_stats_enabled_key.key);
+
+	mutex_unlock(&bpf_stats_enabled_mutex);
+	return fd;
+}
+
+static int bpf_enable_stats(union bpf_attr *attr)
+{
+	switch (attr->enable_stats.type) {
+	case BPF_STATS_RUNTIME_CNT:
+		return bpf_enable_runtime_stats();
+	default:
+		break;
+	}
+	return -EINVAL;
+}
+
 SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned =
int, size)
 {
 	union bpf_attr attr;
@@ -3780,6 +3827,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __use=
r *, uattr, unsigned int, siz
 	case BPF_LINK_UPDATE:
 		err =3D link_update(&attr);
 		break;
+	case BPF_ENABLE_STATS:
+		err =3D bpf_enable_stats(&attr);
+		break;
 	default:
 		err =3D -EINVAL;
 		break;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8a176d8727a3..2d72f4ad3063 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -304,6 +304,40 @@ static int min_extfrag_threshold;
 static int max_extfrag_threshold =3D 1000;
 #endif
=20
+#ifdef CONFIG_BPF_SYSCALL
+static int bpf_stats_handler(struct ctl_table *table, int write,
+			     void __user *buffer, size_t *lenp,
+			     loff_t *ppos)
+{
+	struct static_key *key =3D (struct static_key *)table->data;
+	static int saved_val;
+	int val, ret;
+	struct ctl_table tmp =3D {
+		.data   =3D &val,
+		.maxlen =3D sizeof(val),
+		.mode   =3D table->mode,
+		.extra1 =3D SYSCTL_ZERO,
+		.extra2 =3D SYSCTL_ONE,
+	};
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	mutex_lock(&bpf_stats_enabled_mutex);
+	val =3D saved_val;
+	ret =3D proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	if (write && !ret && val !=3D saved_val) {
+		if (val)
+			static_key_slow_inc(key);
+		else
+			static_key_slow_dec(key);
+		saved_val =3D val;
+	}
+	mutex_unlock(&bpf_stats_enabled_mutex);
+	return ret;
+}
+#endif
+
 static struct ctl_table kern_table[] =3D {
 	{
 		.procname	=3D "sched_child_runs_first",
@@ -1244,7 +1278,7 @@ static struct ctl_table kern_table[] =3D {
 		.data		=3D &bpf_stats_enabled_key.key,
 		.maxlen		=3D sizeof(bpf_stats_enabled_key),
 		.mode		=3D 0644,
-		.proc_handler	=3D proc_do_static_key,
+		.proc_handler	=3D bpf_stats_handler,
 	},
 #endif
 #if defined(CONFIG_TREE_RCU)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 4a6c47f3febe..fd7c64139f21 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -113,6 +113,7 @@ enum bpf_cmd {
 	BPF_MAP_DELETE_BATCH,
 	BPF_LINK_CREATE,
 	BPF_LINK_UPDATE,
+	BPF_ENABLE_STATS,
 };
=20
 enum bpf_map_type {
@@ -379,6 +380,12 @@ enum {
  */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
=20
+/* type for BPF_ENABLE_STATS */
+enum bpf_stats_type {
+	/* enabled run_time_ns and run_cnt */
+	BPF_STATS_RUNTIME_CNT =3D 0,
+};
+
 enum bpf_stack_build_id_status {
 	/* user space need an empty entry to identify end of a trace */
 	BPF_STACK_BUILD_ID_EMPTY =3D 0,
@@ -589,6 +596,10 @@ union bpf_attr {
 		__u32		old_prog_fd;
 	} link_update;
=20
+	struct { /* struct used by BPF_ENABLE_STATS command */
+		__u32		type;
+	} enable_stats;
+
 } __attribute__((aligned(8)));
=20
 /* The description below is an attempt at providing documentation to eBP=
F
--=20
2.24.1

