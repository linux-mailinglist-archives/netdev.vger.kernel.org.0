Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEB1A91FC
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733029AbfIDSni convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Sep 2019 14:43:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4510 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732682AbfIDSni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 14:43:38 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x84IhLmQ032563
        for <netdev@vger.kernel.org>; Wed, 4 Sep 2019 11:43:37 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2usu2fp5cy-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 11:43:37 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 4 Sep 2019 11:43:36 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 4FC587609CE; Wed,  4 Sep 2019 11:43:35 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <peterz@infradead.org>,
        <luto@amacapital.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-api@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 1/3] capability: introduce CAP_BPF and CAP_TRACING
Date:   Wed, 4 Sep 2019 11:43:33 -0700
Message-ID: <20190904184335.360074-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-04_05:2019-09-04,2019-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 impostorscore=0 clxscore=1034 suspectscore=1
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909040187
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split BPF and perf/tracing operations that are allowed under
CAP_SYS_ADMIN into corresponding CAP_BPF and CAP_TRACING.
For backward compatibility include them in CAP_SYS_ADMIN as well.

The end result provides simple safety model for applications that use BPF:
- for tracing program types
  BPF_PROG_TYPE_{KPROBE, TRACEPOINT, PERF_EVENT, RAW_TRACEPOINT, etc}
  use CAP_BPF and CAP_TRACING
- for networking program types
  BPF_PROG_TYPE_{SCHED_CLS, XDP, CGROUP_SKB, SK_SKB, etc}
  use CAP_BPF and CAP_NET_ADMIN

There are few exceptions from this simple rule:
- bpf_trace_printk() is allowed in networking programs, but it's using
  ftrace mechanism, hence this helper needs additional CAP_TRACING.
- cpumap is used by XDP programs. Currently it's kept under CAP_SYS_ADMIN,
  but could be relaxed to CAP_NET_ADMIN in the future.
- BPF_F_ZERO_SEED flag for hash/lru map is allowed under CAP_SYS_ADMIN only
  to discourage production use.
- BPF HW offload is allowed under CAP_SYS_ADMIN.
- cg_sysctl, cg_device, lirc program types are neither networking nor tracing.
  They can be loaded under CAP_BPF, but attach is allowed under CAP_NET_ADMIN.
  This will be cleaned up in the future.

userid=nobody + (CAP_TRACING | CAP_NET_ADMIN) + CAP_BPF is safer than
typical setup with userid=root and sudo by existing bpf applications.
It's not secure, since these capabilities:
- allow bpf progs access arbitrary memory
- let tasks access any bpf map
- let tasks attach/detach any bpf prog

bpftool, bpftrace, bcc tools binaries should not be installed with
cap_bpf+cap_tracing, since unpriv users will be able to read kernel secrets.

CAP_BPF, CAP_NET_ADMIN, CAP_TRACING are roughly equal in terms of
damage they can make to the system.
Example:
CAP_NET_ADMIN can stop network traffic. CAP_BPF can write into map
and if that map is used by firewall-like bpf prog the network traffic
may stop.
CAP_BPF allows many bpf prog_load commands in parallel. The verifier
may consume large amount of memory and significantly slow down the system.
CAP_TRACING allows many kprobes that can slow down the system.

In the future more fine-grained bpf permissions may be added.

v2->v3:
- dropped ftrace and kallsyms from CAP_TRACING description.
  In the future these mechanisms can start using it too.
- added CAP_SYS_ADMIN backward compatibility.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/capability.h          | 18 +++++++++++
 include/uapi/linux/capability.h     | 48 ++++++++++++++++++++++++++++-
 security/selinux/include/classmap.h |  4 +--
 3 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index ecce0f43c73a..13eb49c75797 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -247,6 +247,24 @@ static inline bool ns_capable_setid(struct user_namespace *ns, int cap)
 	return true;
 }
 #endif /* CONFIG_MULTIUSER */
+
+static inline bool capable_bpf(void)
+{
+	return capable(CAP_SYS_ADMIN) || capable(CAP_BPF);
+}
+static inline bool capable_tracing(void)
+{
+	return capable(CAP_SYS_ADMIN) || capable(CAP_TRACING);
+}
+static inline bool capable_bpf_tracing(void)
+{
+	return capable(CAP_SYS_ADMIN) || (capable(CAP_BPF) && capable(CAP_TRACING));
+}
+static inline bool capable_bpf_net_admin(void)
+{
+	return (capable(CAP_SYS_ADMIN) || capable(CAP_BPF)) && capable(CAP_NET_ADMIN);
+}
+
 extern bool privileged_wrt_inode_uidgid(struct user_namespace *ns, const struct inode *inode);
 extern bool capable_wrt_inode_uidgid(const struct inode *inode, int cap);
 extern bool file_ns_capable(const struct file *file, struct user_namespace *ns, int cap);
diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index 240fdb9a60f6..fb71dee0ac2b 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -366,8 +366,54 @@ struct vfs_ns_cap_data {
 
 #define CAP_AUDIT_READ		37
 
+/*
+ * CAP_BPF allows the following BPF operations:
+ * - Loading all types of BPF programs
+ * - Creating all types of BPF maps except:
+ *    - stackmap that needs CAP_TRACING
+ *    - devmap that needs CAP_NET_ADMIN
+ *    - cpumap that needs CAP_SYS_ADMIN
+ * - Advanced verifier features
+ *   - Indirect variable access
+ *   - Bounded loops
+ *   - BPF to BPF function calls
+ *   - Scalar precision tracking
+ *   - Larger complexity limits
+ *   - Dead code elimination
+ *   - And potentially other features
+ * - Use of pointer-to-integer conversions in BPF programs
+ * - Bypassing of speculation attack hardening measures
+ * - Loading BPF Type Format (BTF) data
+ * - Iterate system wide loaded programs, maps, BTF objects
+ * - Retrieve xlated and JITed code of BPF programs
+ * - Access maps and programs via id
+ * - Use bpf_spin_lock() helper
+ *
+ * CAP_BPF and CAP_TRACING together allow the following:
+ * - bpf_probe_read to read arbitrary kernel memory
+ * - bpf_trace_printk to print data to ftrace ring buffer
+ * - Attach to raw_tracepoint
+ * - Query association between kprobe/tracepoint and bpf program
+ *
+ * CAP_BPF and CAP_NET_ADMIN together allow the following:
+ * - Attach to cgroup-bpf hooks and query
+ * - skb, xdp, flow_dissector test_run command
+ *
+ * CAP_NET_ADMIN allows:
+ * - Attach networking bpf programs to xdp, tc, lwt, flow dissector
+ */
+#define CAP_BPF			38
+
+/*
+ * CAP_TRACING allows:
+ * - Full use of perf_event_open(), similarly to the effect of
+ *   kernel.perf_event_paranoid == -1
+ * - Creation of [ku][ret]probe
+ * - Attach tracing bpf programs to perf events
+ */
+#define CAP_TRACING		39
 
-#define CAP_LAST_CAP         CAP_AUDIT_READ
+#define CAP_LAST_CAP         CAP_TRACING
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 201f7e588a29..0b364e245163 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -26,9 +26,9 @@
 	    "audit_control", "setfcap"
 
 #define COMMON_CAP2_PERMS  "mac_override", "mac_admin", "syslog", \
-		"wake_alarm", "block_suspend", "audit_read"
+		"wake_alarm", "block_suspend", "audit_read", "bpf", "tracing"
 
-#if CAP_LAST_CAP > CAP_AUDIT_READ
+#if CAP_LAST_CAP > CAP_TRACING
 #error New capability defined, please update COMMON_CAP2_PERMS.
 #endif
 
-- 
2.20.0

