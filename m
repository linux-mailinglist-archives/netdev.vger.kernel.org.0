Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A8579B2D
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730124AbfG2Vf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:35:57 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38277 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730095AbfG2Vf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:35:56 -0400
Received: by mail-qt1-f194.google.com with SMTP id n11so60971697qtl.5
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 14:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Oi+4EM6X8gAo6lYgL8tG+FlAQb8Apl4H9ulbvQZjhQo=;
        b=jum4jDenOpW4oONVWMUy9hu16YgJWT7tnAaAW5Yuc+YbRIeCKFD6h9Bjjoidq28TKL
         FkSY2LSmsMj8IT4W7anRM0Y6maimHJiJSpxh9JwzrSMsJ/leNqzEgLgiOzJumQ0QhR2j
         oPv0Azw02maxSjKViVnSDnoceH5rNa+syuAfSDbT0t6jKuQ/CXbgLO/cd7KOh0lpLtBd
         k4LcgvLlECD66OCFKZGL82yJWtAxzjeC4lEs4cTO5+9+SxijJSJaCvaixKHbv0GRqV8g
         jBFWrDHgWoR8IGAnMb1ZQcsK6dD2hkZ413hFdcUpP0SxrsXedpgMk/d3mCBwIVuTtto6
         e7dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Oi+4EM6X8gAo6lYgL8tG+FlAQb8Apl4H9ulbvQZjhQo=;
        b=K6w5gUAeNyhA+aaUYaJBd9d7j2g3ObIYDCGp1N9c8bYHpeDkyhyLAOwepGEd7z/hEM
         bFx7b4spAPYTKw/kVeb+cnqwjanwaxtsAQD+88o1bim6TA0kSkzn96LjxkPBgJgUT1CQ
         QjngHo8qWzuJhyoXmvZ4dve57PA50SE1B6kc9Y/rhE4d5szUT8YWsw5vQ44Nr4PV839G
         D9wqJ6Qo9WuNI3zTsk27OnEAF7xarS93OijGAI98FcIScjDr3F8xGppbBc0igK7nhO3v
         ltuBmn89LP2fKK/CzAwHGzpb4EbjnB50vrSL4FHCpM4PftkRGWJYV1EnlOUBdCdBXT41
         lc+w==
X-Gm-Message-State: APjAAAX/bLZPBd5AvOurV7XgxauYRDvlVa6d3AaYVjhSeBf8QQ+xhjpp
        /bGv5f3rNYgAep/Q3lX+6bFwTQ==
X-Google-Smtp-Source: APXvYqxWJo1xemqSHGK7YAUSDgT8a11ex2rNQYt2bUEqflgppxN/lfMO0WmO+qlW1gRYL2lBIzgucw==
X-Received: by 2002:ac8:40cc:: with SMTP id f12mr77607585qtm.256.1564436155619;
        Mon, 29 Jul 2019 14:35:55 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l6sm25887470qkc.89.2019.07.29.14.35.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 14:35:54 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@netronome.com, ctakshak@fb.com, kernel-team@fb.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next] tools: bpftool: add support for reporting the effective cgroup progs
Date:   Mon, 29 Jul 2019 14:35:38 -0700
Message-Id: <20190729213538.8960-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Takshak said in the original submission:

With different bpf attach_flags available to attach bpf programs specially
with BPF_F_ALLOW_OVERRIDE and BPF_F_ALLOW_MULTI, the list of effective
bpf-programs available to any sub-cgroups really needs to be available for
easy debugging.

Using BPF_F_QUERY_EFFECTIVE flag, one can get the list of not only attached
bpf-programs to a cgroup but also the inherited ones from parent cgroup.

So a new option is introduced to use BPF_F_QUERY_EFFECTIVE query flag here
to list all the effective bpf-programs available for execution at a specified
cgroup.

Reused modified test program test_cgroup_attach from tools/testing/selftests/bpf:
  # ./test_cgroup_attach

With old bpftool:

 # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/
  ID       AttachType      AttachFlags     Name
  271      egress          multi           pkt_cntr_1
  272      egress          multi           pkt_cntr_2

Attached new program pkt_cntr_4 in cg2 gives following:

 # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/cg2
  ID       AttachType      AttachFlags     Name
  273      egress          override        pkt_cntr_4

And with new "effective" option it shows all effective programs for cg2:

 # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/cg2 effective
  ID       AttachType      AttachFlags     Name
  273      egress          override        pkt_cntr_4
  271      egress          override        pkt_cntr_1
  272      egress          override        pkt_cntr_2

Compared to original submission use a local flag instead of global
option.

We need to clear query_flags on every command, in case batch mode
wants to use varying settings.

Signed-off-by: Takshak Chahande <ctakshak@fb.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
---
 .../bpftool/Documentation/bpftool-cgroup.rst  | 16 +++--
 tools/bpf/bpftool/bash-completion/bpftool     | 15 +++--
 tools/bpf/bpftool/cgroup.c                    | 65 ++++++++++++-------
 3 files changed, 63 insertions(+), 33 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index 585f270c2d25..06a28b07787d 100644
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
@@ -35,13 +35,17 @@ CGROUP COMMANDS
 
 DESCRIPTION
 ===========
-	**bpftool cgroup { show | list }** *CGROUP*
+	**bpftool cgroup { show | list }** *CGROUP* [**effective**]
 		  List all programs attached to the cgroup *CGROUP*.
 
 		  Output will start with program ID followed by attach type,
 		  attach flags and program name.
 
-	**bpftool cgroup tree** [*CGROUP_ROOT*]
+		  If **effective** is specified retrieve effective programs that
+		  will execute for events within a cgroup. This includes
+		  inherited along with attached ones.
+
+	**bpftool cgroup tree** [*CGROUP_ROOT*] [**effective**]
 		  Iterate over all cgroups in *CGROUP_ROOT* and list all
 		  attached programs. If *CGROUP_ROOT* is not specified,
 		  bpftool uses cgroup v2 mountpoint.
@@ -50,6 +54,10 @@ DESCRIPTION
 		  commands: it starts with absolute cgroup path, followed by
 		  program ID, attach type, attach flags and program name.
 
+		  If **effective** is specified retrieve effective programs that
+		  will execute for events within a cgroup. This includes
+		  inherited along with attached ones.
+
 	**bpftool cgroup attach** *CGROUP* *ATTACH_TYPE* *PROG* [*ATTACH_FLAGS*]
 		  Attach program *PROG* to the cgroup *CGROUP* with attach type
 		  *ATTACH_TYPE* and optional *ATTACH_FLAGS*.
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 6b961a5ed100..df16c5415444 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -710,12 +710,15 @@ _bpftool()
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
index f3c05b08c68c..339c2c78b8e4 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -29,6 +29,8 @@
 	"                        recvmsg4 | recvmsg6 | sysctl |\n"	       \
 	"                        getsockopt | setsockopt }"
 
+static unsigned int query_flags;
+
 static const char * const attach_type_strings[] = {
 	[BPF_CGROUP_INET_INGRESS] = "ingress",
 	[BPF_CGROUP_INET_EGRESS] = "egress",
@@ -107,7 +109,8 @@ static int count_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type)
 	__u32 prog_cnt = 0;
 	int ret;
 
-	ret = bpf_prog_query(cgroup_fd, type, 0, NULL, NULL, &prog_cnt);
+	ret = bpf_prog_query(cgroup_fd, type, query_flags, NULL,
+			     NULL, &prog_cnt);
 	if (ret)
 		return -1;
 
@@ -125,8 +128,8 @@ static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 	int ret;
 
 	prog_cnt = ARRAY_SIZE(prog_ids);
-	ret = bpf_prog_query(cgroup_fd, type, 0, &attach_flags, prog_ids,
-			     &prog_cnt);
+	ret = bpf_prog_query(cgroup_fd, type, query_flags, &attach_flags,
+			     prog_ids, &prog_cnt);
 	if (ret)
 		return ret;
 
@@ -158,20 +161,30 @@ static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 static int do_show(int argc, char **argv)
 {
 	enum bpf_attach_type type;
+	const char *path;
 	int cgroup_fd;
 	int ret = -1;
 
-	if (argc < 1) {
-		p_err("too few parameters for cgroup show");
-		goto exit;
-	} else if (argc > 1) {
-		p_err("too many parameters for cgroup show");
-		goto exit;
+	query_flags = 0;
+
+	if (!REQ_ARGS(1))
+		return -1;
+	path = GET_ARG();
+
+	while (argc) {
+		if (is_prefix(*argv, "effective")) {
+			query_flags |= BPF_F_QUERY_EFFECTIVE;
+			NEXT_ARG();
+		} else {
+			p_err("expected no more arguments, 'effective', got: '%s'?",
+			      *argv);
+			return -1;
+		}
 	}
 
-	cgroup_fd = open(argv[0], O_RDONLY);
+	cgroup_fd = open(path, O_RDONLY);
 	if (cgroup_fd < 0) {
-		p_err("can't open cgroup %s", argv[0]);
+		p_err("can't open cgroup %s", path);
 		goto exit;
 	}
 
@@ -297,23 +310,29 @@ static int do_show_tree(int argc, char **argv)
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
+	} else {
+		cgroup_root = GET_ARG();
+
+		while (argc) {
+			if (is_prefix(*argv, "effective")) {
+				query_flags |= BPF_F_QUERY_EFFECTIVE;
+				NEXT_ARG();
+			} else {
+				p_err("expected no more arguments, 'effective', got: '%s'?",
+				      *argv);
+				return -1;
+			}
+		}
 	}
 
-
 	if (json_output)
 		jsonw_start_array(json_wtr);
 	else
@@ -459,8 +478,8 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s %s { show | list } CGROUP\n"
-		"       %s %s tree [CGROUP_ROOT]\n"
+		"Usage: %s %s { show | list } CGROUP [**effective**]\n"
+		"       %s %s tree [CGROUP_ROOT] [**effective**]\n"
 		"       %s %s attach CGROUP ATTACH_TYPE PROG [ATTACH_FLAGS]\n"
 		"       %s %s detach CGROUP ATTACH_TYPE PROG\n"
 		"       %s %s help\n"
-- 
2.21.0

