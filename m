Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02741BD4F3
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgD2Gp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:45:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53312 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726741AbgD2Gp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:45:56 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T6hwri024522
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 23:45:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ZaYd1vnZHtyNqORY/nAa9zZV9t/FG+SHrQ5G+vFI/P0=;
 b=pCexE0idr15HqS5RHE7TzJHAH2265VaK+lpNY7izmDrDN4b621EPjgm9Otd7rJ3NHiF5
 zd5jtWKcXKqLG3L0DGCdtuL0huiiC3zQu8UiKGs5Wh9dnlSu0sbOlrY9HKnOViyhOC45
 9u0rxigEVGDIfFWy/HToLrtll1yFSXlE8mM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30mk1gs32u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 23:45:54 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 23:45:53 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id A593562E4C2D; Tue, 28 Apr 2020 23:45:47 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v8 bpf-next 1/3] bpf: sharing bpf runtime stats with BPF_ENABLE_STATS
Date:   Tue, 28 Apr 2020 23:45:41 -0700
Message-ID: <20200429064543.634465-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200429064543.634465-1-songliubraving@fb.com>
References: <20200429064543.634465-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_02:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=8 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290054
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
only one type, BPF_STATS_RUN_TIME, is supported. We can extend the
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
 include/uapi/linux/bpf.h       | 11 +++++++
 kernel/bpf/syscall.c           | 57 ++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                | 36 ++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h | 11 +++++++
 5 files changed, 115 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c07b1d2f3824..1262ec460ab3 100644
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
index 0eccafae55bb..7d6024554f57 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -115,6 +115,7 @@ enum bpf_cmd {
 	BPF_LINK_UPDATE,
 	BPF_LINK_GET_FD_BY_ID,
 	BPF_LINK_GET_NEXT_ID,
+	BPF_ENABLE_STATS,
 };
=20
 enum bpf_map_type {
@@ -390,6 +391,12 @@ enum {
  */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
=20
+/* type for BPF_ENABLE_STATS */
+enum bpf_stats_type {
+	/* enabled run_time_ns and run_cnt */
+	BPF_STATS_RUN_TIME =3D 0,
+};
+
 enum bpf_stack_build_id_status {
 	/* user space need an empty entry to identify end of a trace */
 	BPF_STACK_BUILD_ID_EMPTY =3D 0,
@@ -601,6 +608,10 @@ union bpf_attr {
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
index d23c04cbe14f..8691b2cc550d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3872,6 +3872,60 @@ static int bpf_link_get_fd_by_id(const union bpf_a=
ttr *attr)
 	return fd;
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
+	mutex_lock(&bpf_stats_enabled_mutex);
+
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
+#define BPF_ENABLE_STATS_LAST_FIELD enable_stats.type
+
+static int bpf_enable_stats(union bpf_attr *attr)
+{
+
+	if (CHECK_ATTR(BPF_ENABLE_STATS))
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	switch (attr->enable_stats.type) {
+	case BPF_STATS_RUN_TIME:
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
@@ -3996,6 +4050,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __use=
r *, uattr, unsigned int, siz
 		err =3D bpf_obj_get_next_id(&attr, uattr,
 					  &link_idr, &link_idr_lock);
 		break;
+	case BPF_ENABLE_STATS:
+		err =3D bpf_enable_stats(&attr);
+		break;
 	default:
 		err =3D -EINVAL;
 		break;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index e961286d0e14..af08ef0690cb 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -201,6 +201,40 @@ static int max_extfrag_threshold =3D 1000;
=20
 #endif /* CONFIG_SYSCTL */
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
 /*
  * /proc/sys support
  */
@@ -2549,7 +2583,7 @@ static struct ctl_table kern_table[] =3D {
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
index 0eccafae55bb..7d6024554f57 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -115,6 +115,7 @@ enum bpf_cmd {
 	BPF_LINK_UPDATE,
 	BPF_LINK_GET_FD_BY_ID,
 	BPF_LINK_GET_NEXT_ID,
+	BPF_ENABLE_STATS,
 };
=20
 enum bpf_map_type {
@@ -390,6 +391,12 @@ enum {
  */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
=20
+/* type for BPF_ENABLE_STATS */
+enum bpf_stats_type {
+	/* enabled run_time_ns and run_cnt */
+	BPF_STATS_RUN_TIME =3D 0,
+};
+
 enum bpf_stack_build_id_status {
 	/* user space need an empty entry to identify end of a trace */
 	BPF_STACK_BUILD_ID_EMPTY =3D 0,
@@ -601,6 +608,10 @@ union bpf_attr {
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

