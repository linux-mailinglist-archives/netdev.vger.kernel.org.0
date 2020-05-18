Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EE41D8B3C
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 00:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgERWqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 18:46:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:57882 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728266AbgERWqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 18:46:03 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jaoWE-0000cY-Ok; Tue, 19 May 2020 00:45:58 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, rdna@fb.com,
        sdf@google.com, andrii.nakryiko@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v2 3/4] bpf, bpftool: enable get{peer,sock}name attach types
Date:   Tue, 19 May 2020 00:45:47 +0200
Message-Id: <9765b3d03e4c29210c4df56a9cc7e52f5f7bb5ef.1589841594.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1589841594.git.daniel@iogearbox.net>
References: <cover.1589841594.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25816/Mon May 18 14:17:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make bpftool aware and add the new get{peer,sock}name attach types to its
cli, documentation and bash completion to allow attachment/detachment of
sock_addr programs there.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Andrey Ignatov <rdna@fb.com>
---
 .../bpf/bpftool/Documentation/bpftool-cgroup.rst  | 10 +++++++---
 tools/bpf/bpftool/Documentation/bpftool-prog.rst  |  3 ++-
 tools/bpf/bpftool/bash-completion/bpftool         | 15 +++++++++------
 tools/bpf/bpftool/cgroup.c                        |  7 ++++---
 tools/bpf/bpftool/main.h                          |  4 ++++
 tools/bpf/bpftool/prog.c                          |  6 ++++--
 6 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index e4d9da654e84..a226aee3574f 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -29,8 +29,8 @@ CGROUP COMMANDS
 |	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
 |	*ATTACH_TYPE* := { **ingress** | **egress** | **sock_create** | **sock_ops** | **device** |
 |		**bind4** | **bind6** | **post_bind4** | **post_bind6** | **connect4** | **connect6** |
-|		**sendmsg4** | **sendmsg6** | **recvmsg4** | **recvmsg6** | **sysctl** |
-|		**getsockopt** | **setsockopt** }
+|               **getpeername4** | **getpeername6** | **getsockname4** | **getsockname6** | **sendmsg4** |
+|               **sendmsg6** | **recvmsg4** | **recvmsg6** | **sysctl** | **getsockopt** | **setsockopt** }
 |	*ATTACH_FLAGS* := { **multi** | **override** }
 
 DESCRIPTION
@@ -101,7 +101,11 @@ DESCRIPTION
                   an unconnected udp6 socket (since 5.2);
 		  **sysctl** sysctl access (since 5.2);
 		  **getsockopt** call to getsockopt (since 5.3);
-		  **setsockopt** call to setsockopt (since 5.3).
+		  **setsockopt** call to setsockopt (since 5.3);
+		  **getpeername4** call to getpeername(2) for an inet4 socket (since 5.8);
+		  **getpeername6** call to getpeername(2) for an inet6 socket (since 5.8);
+		  **getsockname4** call to getsockname(2) for an inet4 socket (since 5.8);
+		  **getsockname6** call to getsockname(2) for an inet6 socket (since 5.8).
 
 	**bpftool cgroup detach** *CGROUP* *ATTACH_TYPE* *PROG*
 		  Detach *PROG* from the cgroup *CGROUP* and attach type
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 5948e9d89c8d..2b254959d488 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -41,7 +41,8 @@ PROG COMMANDS
 |		**cgroup/sock** | **cgroup/dev** | **lwt_in** | **lwt_out** | **lwt_xmit** |
 |		**lwt_seg6local** | **sockops** | **sk_skb** | **sk_msg** | **lirc_mode2** |
 |		**cgroup/bind4** | **cgroup/bind6** | **cgroup/post_bind4** | **cgroup/post_bind6** |
-|		**cgroup/connect4** | **cgroup/connect6** | **cgroup/sendmsg4** | **cgroup/sendmsg6** |
+|		**cgroup/connect4** | **cgroup/connect6** | **cgroup/getpeername4** | **cgroup/getpeername6** |
+|               **cgroup/getsockname4** | **cgroup/getsockname6** | **cgroup/sendmsg4** | **cgroup/sendmsg6** |
 |		**cgroup/recvmsg4** | **cgroup/recvmsg6** | **cgroup/sysctl** |
 |		**cgroup/getsockopt** | **cgroup/setsockopt** |
 |		**struct_ops** | **fentry** | **fexit** | **freplace**
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 9f0f20e73b87..25b25aca1112 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -472,6 +472,8 @@ _bpftool()
                                 lwt_seg6local sockops sk_skb sk_msg \
                                 lirc_mode2 cgroup/bind4 cgroup/bind6 \
                                 cgroup/connect4 cgroup/connect6 \
+                                cgroup/getpeername4 cgroup/getpeername6 \
+                                cgroup/getsockname4 cgroup/getsockname6 \
                                 cgroup/sendmsg4 cgroup/sendmsg6 \
                                 cgroup/recvmsg4 cgroup/recvmsg6 \
                                 cgroup/post_bind4 cgroup/post_bind6 \
@@ -966,9 +968,10 @@ _bpftool()
                     ;;
                 attach|detach)
                     local ATTACH_TYPES='ingress egress sock_create sock_ops \
-                        device bind4 bind6 post_bind4 post_bind6 connect4 \
-                        connect6 sendmsg4 sendmsg6 recvmsg4 recvmsg6 sysctl \
-                        getsockopt setsockopt'
+                        device bind4 bind6 post_bind4 post_bind6 connect4 connect6 \
+                        getpeername4 getpeername6 getsockname4 getsockname6 \
+                        sendmsg4 sendmsg6 recvmsg4 recvmsg6 sysctl getsockopt \
+                        setsockopt'
                     local ATTACH_FLAGS='multi override'
                     local PROG_TYPE='id pinned tag name'
                     case $prev in
@@ -977,9 +980,9 @@ _bpftool()
                             return 0
                             ;;
                         ingress|egress|sock_create|sock_ops|device|bind4|bind6|\
-                        post_bind4|post_bind6|connect4|connect6|sendmsg4|\
-                        sendmsg6|recvmsg4|recvmsg6|sysctl|getsockopt|\
-                        setsockopt)
+                        post_bind4|post_bind6|connect4|connect6|getpeername4|\
+                        getpeername6|getsockname4|getsockname6|sendmsg4|sendmsg6|\
+                        recvmsg4|recvmsg6|sysctl|getsockopt|setsockopt)
                             COMPREPLY=( $( compgen -W "$PROG_TYPE" -- \
                                 "$cur" ) )
                             return 0
diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 1693c802bb20..27931db421d8 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -25,9 +25,10 @@
 	"       ATTACH_TYPE := { ingress | egress | sock_create |\n"	       \
 	"                        sock_ops | device | bind4 | bind6 |\n"	       \
 	"                        post_bind4 | post_bind6 | connect4 |\n"       \
-	"                        connect6 | sendmsg4 | sendmsg6 |\n"           \
-	"                        recvmsg4 | recvmsg6 | sysctl |\n"	       \
-	"                        getsockopt | setsockopt }"
+	"                        connect6 | getpeername4 | getpeername6 |\n"   \
+	"                        getsockname4 | getsockname6 | sendmsg4 |\n"   \
+	"                        sendmsg6 | recvmsg4 | recvmsg6 |\n"           \
+	"                        sysctl | getsockopt | setsockopt }"
 
 static unsigned int query_flags;
 
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index f89ac70ef973..5cdf0bc049bd 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -100,6 +100,10 @@ static const char * const attach_type_name[__MAX_BPF_ATTACH_TYPE] = {
 	[BPF_CGROUP_INET6_CONNECT] = "connect6",
 	[BPF_CGROUP_INET4_POST_BIND] = "post_bind4",
 	[BPF_CGROUP_INET6_POST_BIND] = "post_bind6",
+	[BPF_CGROUP_INET4_GETPEERNAME] = "getpeername4",
+	[BPF_CGROUP_INET6_GETPEERNAME] = "getpeername6",
+	[BPF_CGROUP_INET4_GETSOCKNAME] = "getsockname4",
+	[BPF_CGROUP_INET6_GETSOCKNAME] = "getsockname6",
 	[BPF_CGROUP_UDP4_SENDMSG] = "sendmsg4",
 	[BPF_CGROUP_UDP6_SENDMSG] = "sendmsg6",
 	[BPF_CGROUP_SYSCTL] = "sysctl",
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index b6e5ba568f98..245f941fdbcf 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -2012,8 +2012,10 @@ static int do_help(int argc, char **argv)
 		"                 sk_reuseport | flow_dissector | cgroup/sysctl |\n"
 		"                 cgroup/bind4 | cgroup/bind6 | cgroup/post_bind4 |\n"
 		"                 cgroup/post_bind6 | cgroup/connect4 | cgroup/connect6 |\n"
-		"                 cgroup/sendmsg4 | cgroup/sendmsg6 | cgroup/recvmsg4 |\n"
-		"                 cgroup/recvmsg6 | cgroup/getsockopt | cgroup/setsockopt |\n"
+		"                 cgroup/getpeername4 | cgroup/getpeername6 |\n"
+		"                 cgroup/getsockname4 | cgroup/getsockname6 | cgroup/sendmsg4 |\n"
+		"                 cgroup/sendmsg6 | cgroup/recvmsg4 | cgroup/recvmsg6 |\n"
+		"                 cgroup/getsockopt | cgroup/setsockopt |\n"
 		"                 struct_ops | fentry | fexit | freplace }\n"
 		"       ATTACH_TYPE := { msg_verdict | stream_verdict | stream_parser |\n"
 		"                        flow_dissector }\n"
-- 
2.21.0

