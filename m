Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB01438F79E
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 03:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhEYBlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 21:41:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3655 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhEYBlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 21:41:39 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FpxWN3CbZzNxF3;
        Tue, 25 May 2021 09:36:32 +0800 (CST)
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 09:40:08 +0800
Received: from huawei.com (10.175.101.6) by dggema772-chm.china.huawei.com
 (10.1.198.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 25
 May 2021 09:40:07 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <quentin@isovalent.com>, <liujian56@huawei.com>, <sdf@google.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: [PATCH v3] bpftool: Add sock_release help info for cgroup attach/prog load command
Date:   Tue, 25 May 2021 09:41:39 +0800
Message-ID: <20210525014139.323859-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema772-chm.china.huawei.com (10.1.198.214)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The help information is not added when the function is added.
Here add the missing information to its cli, documentation and bash completion.

Fixes: db94cc0b4805 ("bpftool: Add support for BPF_CGROUP_INET_SOCK_RELEASE")
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
v1 -> v2:
     Add changelog text.
v2 -> v3:
     Also change prog cli help info, documentation and bash completion mentioned by Quentin.
     So the subject was also changed.

 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst | 4 +++-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   | 2 +-
 tools/bpf/bpftool/bash-completion/bpftool          | 6 +++---
 tools/bpf/bpftool/cgroup.c                         | 3 ++-
 tools/bpf/bpftool/prog.c                           | 2 +-
 5 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index 790944c35602..baee8591ac76 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -30,7 +30,8 @@ CGROUP COMMANDS
 |	*ATTACH_TYPE* := { **ingress** | **egress** | **sock_create** | **sock_ops** | **device** |
 |		**bind4** | **bind6** | **post_bind4** | **post_bind6** | **connect4** | **connect6** |
 |               **getpeername4** | **getpeername6** | **getsockname4** | **getsockname6** | **sendmsg4** |
-|               **sendmsg6** | **recvmsg4** | **recvmsg6** | **sysctl** | **getsockopt** | **setsockopt** }
+|               **sendmsg6** | **recvmsg4** | **recvmsg6** | **sysctl** | **getsockopt** | **setsockopt** |
+|               **sock_release** }
 |	*ATTACH_FLAGS* := { **multi** | **override** }
 
 DESCRIPTION
@@ -106,6 +107,7 @@ DESCRIPTION
 		  **getpeername6** call to getpeername(2) for an inet6 socket (since 5.8);
 		  **getsockname4** call to getsockname(2) for an inet4 socket (since 5.8);
 		  **getsockname6** call to getsockname(2) for an inet6 socket (since 5.8).
+		  **sock_release** closing an userspace inet socket (since 5.9).
 
 	**bpftool cgroup detach** *CGROUP* *ATTACH_TYPE* *PROG*
 		  Detach *PROG* from the cgroup *CGROUP* and attach type
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 358c7309d419..fe1b38e7e887 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -44,7 +44,7 @@ PROG COMMANDS
 |		**cgroup/connect4** | **cgroup/connect6** | **cgroup/getpeername4** | **cgroup/getpeername6** |
 |               **cgroup/getsockname4** | **cgroup/getsockname6** | **cgroup/sendmsg4** | **cgroup/sendmsg6** |
 |		**cgroup/recvmsg4** | **cgroup/recvmsg6** | **cgroup/sysctl** |
-|		**cgroup/getsockopt** | **cgroup/setsockopt** |
+|		**cgroup/getsockopt** | **cgroup/setsockopt** | **cgroup/sock_release** |
 |		**struct_ops** | **fentry** | **fexit** | **freplace** | **sk_lookup**
 |	}
 |       *ATTACH_TYPE* := {
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index d67518bcbd44..cc33c5824a2f 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -478,7 +478,7 @@ _bpftool()
                                 cgroup/recvmsg4 cgroup/recvmsg6 \
                                 cgroup/post_bind4 cgroup/post_bind6 \
                                 cgroup/sysctl cgroup/getsockopt \
-                                cgroup/setsockopt struct_ops \
+                                cgroup/setsockopt cgroup/sock_release struct_ops \
                                 fentry fexit freplace sk_lookup" -- \
                                                    "$cur" ) )
                             return 0
@@ -1021,7 +1021,7 @@ _bpftool()
                         device bind4 bind6 post_bind4 post_bind6 connect4 connect6 \
                         getpeername4 getpeername6 getsockname4 getsockname6 \
                         sendmsg4 sendmsg6 recvmsg4 recvmsg6 sysctl getsockopt \
-                        setsockopt'
+                        setsockopt sock_release'
                     local ATTACH_FLAGS='multi override'
                     local PROG_TYPE='id pinned tag name'
                     case $prev in
@@ -1032,7 +1032,7 @@ _bpftool()
                         ingress|egress|sock_create|sock_ops|device|bind4|bind6|\
                         post_bind4|post_bind6|connect4|connect6|getpeername4|\
                         getpeername6|getsockname4|getsockname6|sendmsg4|sendmsg6|\
-                        recvmsg4|recvmsg6|sysctl|getsockopt|setsockopt)
+                        recvmsg4|recvmsg6|sysctl|getsockopt|setsockopt|sock_release)
                             COMPREPLY=( $( compgen -W "$PROG_TYPE" -- \
                                 "$cur" ) )
                             return 0
diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index d901cc1b904a..6e53b1d393f4 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -28,7 +28,8 @@
 	"                        connect6 | getpeername4 | getpeername6 |\n"   \
 	"                        getsockname4 | getsockname6 | sendmsg4 |\n"   \
 	"                        sendmsg6 | recvmsg4 | recvmsg6 |\n"           \
-	"                        sysctl | getsockopt | setsockopt }"
+	"                        sysctl | getsockopt | setsockopt |\n"	       \
+	"                        sock_release }"
 
 static unsigned int query_flags;
 
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 3f067d2d7584..da4846c9856a 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -2138,7 +2138,7 @@ static int do_help(int argc, char **argv)
 		"                 cgroup/getpeername4 | cgroup/getpeername6 |\n"
 		"                 cgroup/getsockname4 | cgroup/getsockname6 | cgroup/sendmsg4 |\n"
 		"                 cgroup/sendmsg6 | cgroup/recvmsg4 | cgroup/recvmsg6 |\n"
-		"                 cgroup/getsockopt | cgroup/setsockopt |\n"
+		"                 cgroup/getsockopt | cgroup/setsockopt | cgroup/sock_release |\n"
 		"                 struct_ops | fentry | fexit | freplace | sk_lookup }\n"
 		"       ATTACH_TYPE := { msg_verdict | stream_verdict | stream_parser |\n"
 		"                        flow_dissector }\n"
-- 
2.17.1

