Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD964F0CE
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 00:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfFUWdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 18:33:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2954 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbfFUWdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 18:33:41 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5LMSaPr023674
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 15:33:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=i6Cgonvj4qAvr67RHq/wieL2GtUQPq99XSO2vMx95ZM=;
 b=LQcjwcsffrfDyUlZOoThJRqZ8p9BSIRVv64X9/2InRD+Qsu6w8kWZnMdXPB8GzMuyrzp
 0+3NAIbuM5FscKnyHz5Sds1tUr/FmSzy4OxqcOFxuv1dWF58/cJKes6rwe55/7jADZse
 f8Hlg2em6+w2ZZVfmKTrxP6Dwm3MQ1+b5Hw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t93rurwp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 15:33:39 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 21 Jun 2019 15:33:38 -0700
Received: by devvm6270.prn2.facebook.com (Postfix, from userid 153359)
        id 43E2414455288; Fri, 21 Jun 2019 15:33:37 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Takshak Chahande <ctakshak@fb.com>
Smtp-Origin-Hostname: devvm6270.prn2.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <rdna@fb.com>,
        <ctakshak@fb.com>, <kernel-team@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in bpftool cgroup [show|tree]
Date:   Fri, 21 Jun 2019 15:33:11 -0700
Message-ID: <20190621223311.1380295-1-ctakshak@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-21_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906210171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With different bpf attach_flags available to attach bpf programs specially
with BPF_F_ALLOW_OVERRIDE and BPF_F_ALLOW_MULTI, the list of effective
bpf-programs available to any sub-cgroups really needs to be available for
easy debugging.

Using BPF_F_QUERY_EFFECTIVE flag, one can get the list of not only attached
bpf-programs to a cgroup but also the inherited ones from parent cgroup.

So "-e" option is introduced to use BPF_F_QUERY_EFFECTIVE query flag here to
list all the effective bpf-programs available for execution at a specified
cgroup.

Reused modified test program test_cgroup_attach from tools/testing/selftests/bpf:
  # ./test_cgroup_attach

With old bpftool (without -e option):

  # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/
  ID       AttachType      AttachFlags     Name
  271      egress          multi           pkt_cntr_1
  272      egress          multi           pkt_cntr_2

  Attached new program pkt_cntr_4 in cg2 gives following:

  # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/cg2
  ID       AttachType      AttachFlags     Name
  273      egress          override        pkt_cntr_4

And with new "-e" option it shows all effective programs for cg2:

  # bpftool -e cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/cg2
  ID       AttachType      AttachFlags     Name
  273      egress          override        pkt_cntr_4
  271      egress          override        pkt_cntr_1
  272      egress          override        pkt_cntr_2

Signed-off-by: Takshak Chahande <ctakshak@fb.com>
Acked-by: Andrey Ignatov <rdna@fb.com>
---
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst | 8 +++++++-
 tools/bpf/bpftool/Documentation/bpftool.rst        | 6 +++++-
 tools/bpf/bpftool/bash-completion/bpftool          | 2 +-
 tools/bpf/bpftool/cgroup.c                         | 7 ++++---
 tools/bpf/bpftool/main.c                           | 7 ++++++-
 tools/bpf/bpftool/main.h                           | 3 ++-
 6 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index 36807735e2a5..5e515aac36b3 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -12,7 +12,8 @@ SYNOPSIS
 
 	**bpftool** [*OPTIONS*] **cgroup** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-f** | **--bpffs** } }
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-f** | **--bpffs** }
+	| { **-e** | **--effective** } }
 
 	*COMMANDS* :=
 	{ **show** | **list** | **tree** | **attach** | **detach** | **help** }
@@ -117,6 +118,11 @@ OPTIONS
 		  Print all logs available from libbpf, including debug-level
 		  information.
 
+	-e, --effective
+		  Retrieve effective programs that will execute for events
+		  within a cgroup. This includes inherited along with attached
+		  ones.
+
 EXAMPLES
 ========
 |
diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
index 6a9c52ef84a9..d2f76b55988d 100644
--- a/tools/bpf/bpftool/Documentation/bpftool.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool.rst
@@ -19,7 +19,7 @@ SYNOPSIS
 	*OBJECT* := { **map** | **program** | **cgroup** | **perf** | **net** | **feature** }
 
 	*OPTIONS* := { { **-V** | **--version** } | { **-h** | **--help** }
-	| { **-j** | **--json** } [{ **-p** | **--pretty** }] }
+	| { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-e** | **--effective** } }
 
 	*MAP-COMMANDS* :=
 	{ **show** | **list** | **create** | **dump** | **update** | **lookup** | **getnext**
@@ -71,6 +71,10 @@ OPTIONS
 		  includes logs from libbpf as well as from the verifier, when
 		  attempting to load programs.
 
+	-e, --effective
+		  Retrieve effective programs that will execute for events
+		  within a cgroup. This includes inherited along with attached ones.
+
 SEE ALSO
 ========
 	**bpf**\ (2),
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 2725e27dfa42..72fd832072a3 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -187,7 +187,7 @@ _bpftool()
 
     # Deal with options
     if [[ ${words[cword]} == -* ]]; then
-        local c='--version --json --pretty --bpffs --mapcompat --debug'
+        local c='--version --json --pretty --bpffs --mapcompat --debug --effective'
         COMPREPLY=( $( compgen -W "$c" -- "$cur" ) )
         return 0
     fi
diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 7e22f115c8c1..86f9ac8c4599 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -101,7 +101,8 @@ static int count_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type)
 	__u32 prog_cnt = 0;
 	int ret;
 
-	ret = bpf_prog_query(cgroup_fd, type, 0, NULL, NULL, &prog_cnt);
+	ret = bpf_prog_query(cgroup_fd, type, query_flags, NULL, NULL,
+			     &prog_cnt);
 	if (ret)
 		return -1;
 
@@ -119,8 +120,8 @@ static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 	int ret;
 
 	prog_cnt = ARRAY_SIZE(prog_ids);
-	ret = bpf_prog_query(cgroup_fd, type, 0, &attach_flags, prog_ids,
-			     &prog_cnt);
+	ret = bpf_prog_query(cgroup_fd, type, query_flags, &attach_flags,
+			     prog_ids, &prog_cnt);
 	if (ret)
 		return ret;
 
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 4879f6395c7e..42e9ddfbbbe0 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -27,6 +27,7 @@ bool json_output;
 bool show_pinned;
 bool block_mount;
 bool verifier_logs;
+unsigned int query_flags;
 int bpf_flags;
 struct pinned_obj_table prog_table;
 struct pinned_obj_table map_table;
@@ -327,6 +328,7 @@ int main(int argc, char **argv)
 		{ "mapcompat",	no_argument,	NULL,	'm' },
 		{ "nomount",	no_argument,	NULL,	'n' },
 		{ "debug",	no_argument,	NULL,	'd' },
+		{ "effective",	no_argument,	NULL,	'e' },
 		{ 0 }
 	};
 	int opt, ret;
@@ -342,7 +344,7 @@ int main(int argc, char **argv)
 	hash_init(map_table.table);
 
 	opterr = 0;
-	while ((opt = getopt_long(argc, argv, "Vhpjfmnd",
+	while ((opt = getopt_long(argc, argv, "Vhpjfmnde",
 				  options, NULL)) >= 0) {
 		switch (opt) {
 		case 'V':
@@ -376,6 +378,9 @@ int main(int argc, char **argv)
 			libbpf_set_print(print_all_levels);
 			verifier_logs = true;
 			break;
+		case 'e':
+			query_flags = BPF_F_QUERY_EFFECTIVE;
+			break;
 		default:
 			p_err("unrecognized option '%s'", argv[optind - 1]);
 			if (json_output)
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 28a2a5857e14..fddec15c454a 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -45,7 +45,7 @@
 	"PROG := { id PROG_ID | pinned FILE | tag PROG_TAG }"
 #define HELP_SPEC_OPTIONS						\
 	"OPTIONS := { {-j|--json} [{-p|--pretty}] | {-f|--bpffs} |\n"	\
-	"\t            {-m|--mapcompat} | {-n|--nomount} }"
+	"\t            {-m|--mapcompat} | {-n|--nomount} | {-e|--effective} }"
 #define HELP_SPEC_MAP							\
 	"MAP := { id MAP_ID | pinned FILE }"
 
@@ -92,6 +92,7 @@ extern bool json_output;
 extern bool show_pinned;
 extern bool block_mount;
 extern bool verifier_logs;
+extern unsigned int query_flags;
 extern int bpf_flags;
 extern struct pinned_obj_table prog_table;
 extern struct pinned_obj_table map_table;
-- 
2.17.1

