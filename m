Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFAE2965F6
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 22:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900969AbgJVU1z convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 16:27:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52852 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895043AbgJVU1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 16:27:55 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09MK4WNR008120
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 13:27:54 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34b07sd9mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 13:27:54 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 22 Oct 2020 13:27:53 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 671D32EC8370; Thu, 22 Oct 2020 13:27:48 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf] selftest/bpf: fix profiler test using CO-RE relocation for enums
Date:   Thu, 22 Oct 2020 13:27:38 -0700
Message-ID: <20201022202739.3667367-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_15:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=638 spamscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 adultscore=0 priorityscore=1501 suspectscore=8
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010220131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of hard-coding invalid pids_cgrp_id, use Kconfig to detect the
presence of that enum value and CO-RE to capture its actual value in the
hosts's kernel.

Tested-by: Song Liu <songliubraving@fb.com>
Fixes: 03d4d13fab3f ("selftests/bpf: Add profiler test")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/progs/profiler.inc.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/testing/selftests/bpf/progs/profiler.inc.h
index 00578311a423..30982a7e4d0f 100644
--- a/tools/testing/selftests/bpf/progs/profiler.inc.h
+++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
@@ -243,7 +243,10 @@ static ino_t get_inode_from_kernfs(struct kernfs_node* node)
 	}
 }
 
-int pids_cgrp_id = 1;
+extern bool CONFIG_CGROUP_PIDS __kconfig __weak;
+enum cgroup_subsys_id___local {
+	pids_cgrp_id___local = 123, /* value doesn't matter */
+};
 
 static INLINE void* populate_cgroup_info(struct cgroup_data_t* cgroup_data,
 					 struct task_struct* task,
@@ -253,7 +256,9 @@ static INLINE void* populate_cgroup_info(struct cgroup_data_t* cgroup_data,
 		BPF_CORE_READ(task, nsproxy, cgroup_ns, root_cset, dfl_cgrp, kn);
 	struct kernfs_node* proc_kernfs = BPF_CORE_READ(task, cgroups, dfl_cgrp, kn);
 
-	if (ENABLE_CGROUP_V1_RESOLVER) {
+	if (ENABLE_CGROUP_V1_RESOLVER && CONFIG_CGROUP_PIDS) {
+		int cgrp_id = bpf_core_enum_value(enum cgroup_subsys_id___local,
+						  pids_cgrp_id___local);
 #ifdef UNROLL
 #pragma unroll
 #endif
@@ -262,7 +267,7 @@ static INLINE void* populate_cgroup_info(struct cgroup_data_t* cgroup_data,
 				BPF_CORE_READ(task, cgroups, subsys[i]);
 			if (subsys != NULL) {
 				int subsys_id = BPF_CORE_READ(subsys, ss, id);
-				if (subsys_id == pids_cgrp_id) {
+				if (subsys_id == cgrp_id) {
 					proc_kernfs = BPF_CORE_READ(subsys, cgroup, kn);
 					root_kernfs = BPF_CORE_READ(subsys, ss, root, kf_root, kn);
 					break;
-- 
2.24.1

