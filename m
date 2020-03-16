Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C780187419
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 21:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732549AbgCPUdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 16:33:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4812 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732537AbgCPUdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 16:33:37 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02GKLFJY006793
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 13:33:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=YAUYFyGl8iNhKU1xcSzkPALlFq5jHZIIxk/ZsP735eY=;
 b=QxJOZogHLnWyh13Ha6d3duikzhmBko4RiaAAgOKWi68NhGA+rgw/fqFjOjrunxkY9Lj0
 Ce+BElqZUc6TS2GBCk1vxQd3JKdDLF5xzKV4qtS9KhNmdvVIrc6A0SceRcLo1q0PGb/l
 Hv/1YjbJoLkUqp0TUzLHo4LACD9ZoWXUG8E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ysf9qpqq8-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 13:33:36 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 16 Mar 2020 13:33:34 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 2AD5362E20F8; Mon, 16 Mar 2020 13:33:31 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <mcgrof@kernel.org>, <keescook@chromium.org>, <yzaikin@google.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next] bpf: sharing bpf runtime stats with /dev/bpf_stats
Date:   Mon, 16 Mar 2020 13:33:29 -0700
Message-ID: <20200316203329.2747779-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-16_09:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 adultscore=0
 bulkscore=0 suspectscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160086
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
bpf command BPF_ENABLE_RUNTIME_STATS. On success, this command enables
run_time_ns stats and returns a valid fd.

With BPF_ENABLE_RUNTIME_STATS, user space tool would have the following
flow:

  1. Get a fd with BPF_ENABLE_RUNTIME_STATS, and make sure it is valid;
  2. Check program run_time_ns;
  3. Sleep for the monitoring period;
  4. Check program run_time_ns again, calculate the difference;
  5. Close the fd.

Signed-off-by: Song Liu <songliubraving@fb.com>

---
Changes RFC => v2:
1. Add a new bpf command instead of /dev/bpf_stats;
2. Remove the jump_label patch, which is no longer needed;
3. Add a static variable to save previous value of the sysctl.
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/syscall.c           | 43 ++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                | 36 +++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h |  1 +
 5 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4fd91b7c95ea..d542349771df 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -970,6 +970,7 @@ _out:							\
 
 #ifdef CONFIG_BPF_SYSCALL
 DECLARE_PER_CPU(int, bpf_prog_active);
+extern struct mutex bpf_stats_enabled_mutex;
 
 /*
  * Block execution of BPF programs attached to instrumentation (perf,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 40b2d9476268..8285ff37210c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -111,6 +111,7 @@ enum bpf_cmd {
 	BPF_MAP_LOOKUP_AND_DELETE_BATCH,
 	BPF_MAP_UPDATE_BATCH,
 	BPF_MAP_DELETE_BATCH,
+	BPF_ENABLE_RUNTIME_STATS,
 };
 
 enum bpf_map_type {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b2f73ecacced..823dc9de7953 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -24,6 +24,9 @@
 #include <linux/ctype.h>
 #include <linux/nospec.h>
 #include <linux/audit.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/jump_label.h>
 #include <uapi/linux/btf.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
@@ -3550,6 +3553,43 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
 	return err;
 }
 
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
+static const struct file_operations bpf_stats_fops = {
+	.release = bpf_stats_release,
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
+	fd = anon_inode_getfd("bpf-stats", &bpf_stats_fops, NULL, 0);
+	if (fd >= 0)
+		static_key_slow_inc(&bpf_stats_enabled_key.key);
+
+	mutex_unlock(&bpf_stats_enabled_mutex);
+	return fd;
+}
+
+
 SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
 {
 	union bpf_attr attr = {};
@@ -3660,6 +3700,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_MAP_DELETE_BATCH:
 		err = bpf_map_do_batch(&attr, uattr, BPF_MAP_DELETE_BATCH);
 		break;
+	case BPF_ENABLE_RUNTIME_STATS:
+		err = bpf_enable_runtime_stats();
+		break;
 	default:
 		err = -EINVAL;
 		break;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ad5b88a53c5a..14613d1e0b88 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -316,6 +316,40 @@ static int min_extfrag_threshold;
 static int max_extfrag_threshold = 1000;
 #endif
 
+#ifdef CONFIG_BPF_SYSCALL
+static int bpf_stats_handler(struct ctl_table *table, int write,
+			     void __user *buffer, size_t *lenp,
+			     loff_t *ppos)
+{
+	struct static_key *key = (struct static_key *)table->data;
+	int val, ret;
+	static int saved_val;
+	struct ctl_table tmp = {
+		.data   = &val,
+		.maxlen = sizeof(val),
+		.mode   = table->mode,
+		.extra1 = SYSCTL_ZERO,
+		.extra2 = SYSCTL_ONE,
+	};
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	mutex_lock(&bpf_stats_enabled_mutex);
+	val = saved_val;
+	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	if (write && !ret && val != saved_val) {
+		if (val)
+			static_key_slow_inc(key);
+		else
+			static_key_slow_dec(key);
+		saved_val = val;
+	}
+	mutex_unlock(&bpf_stats_enabled_mutex);
+	return ret;
+}
+#endif
+
 static struct ctl_table kern_table[] = {
 	{
 		.procname	= "sched_child_runs_first",
@@ -1256,7 +1290,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &bpf_stats_enabled_key.key,
 		.maxlen		= sizeof(bpf_stats_enabled_key),
 		.mode		= 0644,
-		.proc_handler	= proc_do_static_key,
+		.proc_handler	= bpf_stats_handler,
 	},
 #endif
 #if defined(CONFIG_TREE_RCU)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 40b2d9476268..8285ff37210c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -111,6 +111,7 @@ enum bpf_cmd {
 	BPF_MAP_LOOKUP_AND_DELETE_BATCH,
 	BPF_MAP_UPDATE_BATCH,
 	BPF_MAP_DELETE_BATCH,
+	BPF_ENABLE_RUNTIME_STATS,
 };
 
 enum bpf_map_type {
-- 
2.17.1

