Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFE55D4AC
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfGBQtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:49:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48518 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726150AbfGBQtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:49:15 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x62GlDS1027013
        for <netdev@vger.kernel.org>; Tue, 2 Jul 2019 09:49:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=5C4AqBfyZY174hySphThZbLawdEV5ODb1rqCbW88044=;
 b=Q+BfMswlE2Zr4+48cIEKAtkQLNWpS8itH/2GBcvE/qXIKsVwQ1847l48dzKWAm5eqdLR
 n78qR2oIz4ZS27Eal5HZjpqvSyuE2DvBC+MdNkm1eyVZ4bFmIxWTuet44NLF48WA7Rh0
 gBNzVEmxmBWgE/gLIDNO5mfy7xZichfon1s= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2tga3r08rr-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 09:49:14 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 2 Jul 2019 09:49:08 -0700
Received: by devvm6270.prn2.facebook.com (Postfix, from userid 153359)
        id F076814ABEEE5; Tue,  2 Jul 2019 09:49:06 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Takshak Chahande <ctakshak@fb.com>
Smtp-Origin-Hostname: devvm6270.prn2.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <jakub.kicinski@netronome.com>,
        <daniel@iogearbox.net>, <ctakshak@fb.com>, <kernel-team@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next v2] bpftool: Add BPF_F_QUERY_EFFECTIVE support in bpftool cgroup [show|tree]
Date:   Tue, 2 Jul 2019 09:48:43 -0700
Message-ID: <20190702164843.3662715-1-ctakshak@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=809 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020184
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

So additional "effective" option is introduced to use BPF_F_QUERY_EFFECTIVE
query flag here to list all the effective bpf-programs available for execution
at a specified cgroup.

Reused modified test program test_cgroup_attach from tools/testing/selftests/bpf:
 # ./test_cgroup_attach

With old bpftool (without 'effective' option)

 # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/

 ID       AttachType      AttachFlags     Name
 129      egress          multi           pkt_cntr_1
 130      egress          multi           pkt_cntr_2

 Attached new program pkt_cntr_4 in cg2 gives following:

 # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/cg2/

 ID       AttachType      AttachFlags     Name
 131      egress          override        pkt_cntr_4

 And with 'effective' option it shows all effective programs for cg2:

 # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/cg2/ effective

 ID       AttachType      AttachFlags     Name
 131      egress          override        pkt_cntr_4
 129      egress          override        pkt_cntr_1
 130      egress          override        pkt_cntr_2

Signed-off-by: Takshak Chahande <ctakshak@fb.com>
---
Changelog:

v2:
  - Removed global '-e|--effective' query flag
  - Added 'effective' option after cgroup path argument as proposed by Jakub

 .../bpftool/Documentation/bpftool-cgroup.rst  | 17 +++--
 tools/bpf/bpftool/bash-completion/bpftool     | 15 +++--
 tools/bpf/bpftool/cgroup.c                    | 66 ++++++++++++-------
 3 files changed, 66 insertions(+), 32 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index 585f270c2d25..8c12e8bb5dd4 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -20,8 +20,8 @@ SYNOPSIS
 CGROUP COMMANDS
 ===============
 
-|	**bpftool** **cgroup { show | list }** *CGROUP*
-|	**bpftool** **cgroup tree** [*CGROUP_ROOT*]
+|	**bpftool** **cgroup { show | list }** *CGROUP* [**effective**]
+|	**bpftool** **cgroup tree** [*CGROUP_ROOT*] [**effective**]
 |	**bpftool** **cgroup attach** *CGROUP* *ATTACH_TYPE* *PROG* [*ATTACH_FLAGS*]
 |	**bpftool** **cgroup detach** *CGROUP* *ATTACH_TYPE* *PROG*
 |	**bpftool** **cgroup help**
@@ -35,13 +35,18 @@ CGROUP COMMANDS
 
 DESCRIPTION
 ===========
-	**bpftool cgroup { show | list }** *CGROUP*
+	**bpftool cgroup { show | list }** *CGROUP* [**effective**]
 		  List all programs attached to the cgroup *CGROUP*.
 
 		  Output will start with program ID followed by attach type,
 		  attach flags and program name.
 
-	**bpftool cgroup tree** [*CGROUP_ROOT*]
+		  If **effective** is specified, then it retrieves all the
+		  effective programs that will be executed for events within
+		  a cgroup. This includes inherited along with attached ones
+		  to the cgroup.
+
+	**bpftool cgroup tree** [*CGROUP_ROOT*] [**effective**]
 		  Iterate over all cgroups in *CGROUP_ROOT* and list all
 		  attached programs. If *CGROUP_ROOT* is not specified,
 		  bpftool uses cgroup v2 mountpoint.
@@ -50,6 +55,10 @@ DESCRIPTION
 		  commands: it starts with absolute cgroup path, followed by
 		  program ID, attach type, attach flags and program name.
 
+		  With **effective** it retrieves all the effective programs
+		  that will be executed for events at each cgroup level as
+		  similar to show/list command output for a cgroup.
+
 	**bpftool cgroup attach** *CGROUP* *ATTACH_TYPE* *PROG* [*ATTACH_FLAGS*]
 		  Attach program *PROG* to the cgroup *CGROUP* with attach type
 		  *ATTACH_TYPE* and optional *ATTACH_FLAGS*.
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index ba37095e1f62..b9b76b812dda 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -679,12 +679,15 @@ _bpftool()
             ;;
         cgroup)
             case $command in
-                show|list)
-                    _filedir
-                    return 0
-                    ;;
-                tree)
-                    _filedir
+                show|list|tree)
+                    case $cword in
+                        3)
+                            _filedir
+                            ;;
+                        4)
+                            COMPREPLY=( $( compgen -W 'effective' -- "$cur" ) )
+                            ;;
+                    esac
                     return 0
                     ;;
                 attach|detach)
diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 390b89a224f1..09040dbdc20a 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -29,6 +29,7 @@
 	"                        recvmsg4 | recvmsg6 | sysctl |\n"	       \
 	"                        getsockopt | setsockopt }"
 
+static unsigned int query_flags;
 static const char * const attach_type_strings[] = {
 	[BPF_CGROUP_INET_INGRESS] = "ingress",
 	[BPF_CGROUP_INET_EGRESS] = "egress",
@@ -107,7 +108,8 @@ static int count_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type)
 	__u32 prog_cnt = 0;
 	int ret;
 
-	ret = bpf_prog_query(cgroup_fd, type, 0, NULL, NULL, &prog_cnt);
+	ret = bpf_prog_query(cgroup_fd, type, query_flags, NULL, NULL,
+			     &prog_cnt);
 	if (ret)
 		return -1;
 
@@ -125,8 +127,8 @@ static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 	int ret;
 
 	prog_cnt = ARRAY_SIZE(prog_ids);
-	ret = bpf_prog_query(cgroup_fd, type, 0, &attach_flags, prog_ids,
-			     &prog_cnt);
+	ret = bpf_prog_query(cgroup_fd, type, query_flags, &attach_flags,
+			     prog_ids, &prog_cnt);
 	if (ret)
 		return ret;
 
@@ -158,20 +160,32 @@ static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 static int do_show(int argc, char **argv)
 {
 	enum bpf_attach_type type;
+	char *cgroup_path;
 	int cgroup_fd;
 	int ret = -1;
 
-	if (argc < 1) {
+	if (!REQ_ARGS(1)) {
 		p_err("too few parameters for cgroup show");
 		goto exit;
-	} else if (argc > 1) {
-		p_err("too many parameters for cgroup show");
-		goto exit;
 	}
 
-	cgroup_fd = open(argv[0], O_RDONLY);
+	query_flags = 0;
+	cgroup_path = GET_ARG();
+
+	if (argc) {
+		if (argc == 1 && is_prefix(*argv, "effective")) {
+			query_flags |= BPF_F_QUERY_EFFECTIVE;
+			NEXT_ARG();
+		} else {
+			p_err("invalid argument after cgroup path, "
+			      "got: '%s'?, expect only effective", *argv);
+			goto exit;
+		}
+	}
+
+	cgroup_fd = open(cgroup_path, O_RDONLY);
 	if (cgroup_fd < 0) {
-		p_err("can't open cgroup %s", argv[1]);
+		p_err("can't open cgroup %s", cgroup_path);
 		goto exit;
 	}
 
@@ -294,26 +308,34 @@ static char *find_cgroup_root(void)
 
 static int do_show_tree(int argc, char **argv)
 {
+	bool free_cg_root = false;
 	char *cgroup_root;
 	int ret;
 
-	switch (argc) {
-	case 0:
+	query_flags = 0;
+
+	if (!argc) {
 		cgroup_root = find_cgroup_root();
 		if (!cgroup_root) {
 			p_err("cgroup v2 isn't mounted");
 			return -1;
 		}
-		break;
-	case 1:
-		cgroup_root = argv[0];
-		break;
-	default:
-		p_err("too many parameters for cgroup tree");
-		return -1;
+		free_cg_root = true;
+	} else {
+		cgroup_root = GET_ARG();
+
+		if (argc) {
+			if (argc == 1 && is_prefix(*argv, "effective")) {
+				query_flags |= BPF_F_QUERY_EFFECTIVE;
+				NEXT_ARG();
+			} else {
+				p_err("invalid argument after cgroup path, "
+				      "got: '%s'? expect only effective", *argv);
+				return -1;
+			}
+		}
 	}
 
-
 	if (json_output)
 		jsonw_start_array(json_wtr);
 	else
@@ -338,7 +360,7 @@ static int do_show_tree(int argc, char **argv)
 	if (json_output)
 		jsonw_end_array(json_wtr);
 
-	if (argc == 0)
+	if (free_cg_root)
 		free(cgroup_root);
 
 	return ret;
@@ -459,8 +481,8 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s %s { show | list } CGROUP\n"
-		"       %s %s tree [CGROUP_ROOT]\n"
+		"Usage: %s %s { show | list } CGROUP [effective]\n"
+		"       %s %s tree [CGROUP_ROOT] [effective]\n"
 		"       %s %s attach CGROUP ATTACH_TYPE PROG [ATTACH_FLAGS]\n"
 		"       %s %s detach CGROUP ATTACH_TYPE PROG\n"
 		"       %s %s help\n"
-- 
2.17.1

