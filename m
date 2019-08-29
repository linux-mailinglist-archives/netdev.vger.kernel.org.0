Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86F8A10AE
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 07:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbfH2FM5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Aug 2019 01:12:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61740 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725826AbfH2FM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 01:12:57 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7T5AsrR012326
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 22:12:56 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2unvnk33ht-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 22:12:55 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 22:12:54 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 9A0A3760F54; Wed, 28 Aug 2019 22:12:53 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <luto@amacapital.net>
CC:     <davem@davemloft.net>, <peterz@infradead.org>,
        <rostedt@goodmis.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-api@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and CAP_TRACING
Date:   Wed, 28 Aug 2019 22:12:51 -0700
Message-ID: <20190829051253.1927291-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_03:2019-08-28,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=1 mlxscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1034 priorityscore=1501 mlxlogscore=960
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1908290056
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CAP_BPF allows the following BPF operations:
- Loading all types of BPF programs
- Creating all types of BPF maps except:
   - stackmap that needs CAP_TRACING
   - devmap that needs CAP_NET_ADMIN
   - cpumap that needs CAP_SYS_ADMIN
- Advanced verifier features
  - Indirect variable access
  - Bounded loops
  - BPF to BPF function calls
  - Scalar precision tracking
  - Larger complexity limits
  - Dead code elimination
  - And potentially other features
- Use of pointer-to-integer conversions in BPF programs
- Bypassing of speculation attack hardening measures
- Loading BPF Type Format (BTF) data
- Iterate system wide loaded programs, maps, BTF objects
- Retrieve xlated and JITed code of BPF programs
- Access maps and programs via id
- Use bpf_spin_lock() helper

CAP_BPF and CAP_TRACING together allow the following:
- bpf_probe_read to read arbitrary kernel memory
- bpf_trace_printk to print data to ftrace ring buffer
- Attach to raw_tracepoint
- Query association between kprobe/tracepoint and bpf program

CAP_BPF and CAP_NET_ADMIN together allow the following:
- Attach to cgroup-bpf hooks and query
- skb, xdp, flow_dissector test_run command

CAP_NET_ADMIN allows:
- Attach networking bpf programs to xdp, tc, lwt, flow dissector

CAP_TRACING allows:
- Full use of perf_event_open(), similarly to the effect of
  kernel.perf_event_paranoid == -1
- Full use of tracefs
- Creation of [ku][ret]probe
- Accessing arbitrary kernel memory via kprobe + probe_kernel_read
- Attach tracing bpf programs to perf events
- Access to kallsyms

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/uapi/linux/capability.h     | 51 ++++++++++++++++++++++++++++-
 security/selinux/include/classmap.h |  4 +--
 2 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index 240fdb9a60f6..664e07d12888 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -366,8 +366,57 @@ struct vfs_ns_cap_data {
 
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
+ * - Full use of tracefs
+ * - Creation of [ku][ret]probe
+ * - Accessing arbitrary kernel memory via kprobe + probe_kernel_read
+ * - Attach tracing bpf programs to perf events
+ * - Access to kallsyms
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

