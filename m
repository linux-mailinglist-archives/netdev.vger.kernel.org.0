Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B927A58BD2
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 22:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfF0UjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 16:39:23 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:54803 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfF0UjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 16:39:22 -0400
Received: by mail-pg1-f201.google.com with SMTP id t2so1894212pgs.21
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 13:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wmpqaA8NQXdO6WGtxyTFsKvGBi3cmJ5IxgugE2DbD+c=;
        b=n+9wOn9B6n6b81GkZfJsUzVWIQNGyMVRHPFL4hCaXDZt2sDCQPebZPynn3rZywxB3U
         wmYE1L2iULPvhpRKuTC+fgGpBCnOM7s2gCbYOiHy7xEXwK4x/iOgBnfF57BIYE5eu2MY
         /q9GGyLc50X+SyWXIQRXiqEg/tzEM4TK0x8wbIuhuoq9xDq4CrPvHqCKHHiize1tAeFe
         9oouC441AV3kSmni5M0Gp6u3KcDXfq/k9+K4u8/P5s91TsBS1EyqBKY0+tEBFQnhutwY
         hD8RLxWiAvOusyymi1pi+0ip9aBaeF9q4w9EIudULhdynYsmU1RpfSF0mLaUZmAoUc8J
         CWBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wmpqaA8NQXdO6WGtxyTFsKvGBi3cmJ5IxgugE2DbD+c=;
        b=uTScJ6bOaFNHka4KfnhBY6sHxuRZL+fyBaDum4zYaqAXObRCaTWa6OG0kaa4CFpMwd
         80QUCWtlrL24ePMcaFtpgRG1HpLhl7BLj3w5Do01qRrcAR7HUmzwSK5swZYqeYnxwvQp
         eELRYTGX7rqAfZXsk+c7fKp5gkNQy0mpP+wXi5kVcPjl4bc0BYTquIQ7wvLqck4AzxH3
         P72qhZ7z5EzvUNkHjEnXnnFgOCoUMdsj7NIMM7vFjumF1DPPaSaWhJ965VyndfrPMzZE
         i7C/CgqfrSecacMRDoEYSGxV1xRvamrAFaULRo/BOIiFvJpYkb2twFBb212br72iva/s
         mJ6Q==
X-Gm-Message-State: APjAAAXowX9YRMXVzhdcZqv37v6sB2Ny2zj8zVMI1FvpafMSeOKz5KwY
        VlDzDLLdzzOUDR+g6OeHEszqb4dn+h1jYBCl3jky2xs9EEGCcGpz5PMg/KvG93nXh+BF79sm1jE
        qz7jrnoM1BR0jxFSzG94Ewsl2u/4yi1XfERsSCO+SpkXuPgbY9+8v/g==
X-Google-Smtp-Source: APXvYqw2q6HUr47XxzQlBm52aStoFxdMRWfE2X9O0WbUnoTqevuHsyRGGbPPtvAILDujlwoIXsf19fg=
X-Received: by 2002:a63:6143:: with SMTP id v64mr5481712pgb.407.1561667961155;
 Thu, 27 Jun 2019 13:39:21 -0700 (PDT)
Date:   Thu, 27 Jun 2019 13:38:55 -0700
In-Reply-To: <20190627203855.10515-1-sdf@google.com>
Message-Id: <20190627203855.10515-10-sdf@google.com>
Mime-Version: 1.0
References: <20190627203855.10515-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v9 9/9] bpftool: support cgroup sockopt
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>, Martin Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support sockopt prog type and cgroup hooks in the bpftool.

Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Martin Lau <kafai@fb.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst | 7 +++++--
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   | 3 ++-
 tools/bpf/bpftool/bash-completion/bpftool          | 9 ++++++---
 tools/bpf/bpftool/cgroup.c                         | 5 ++++-
 tools/bpf/bpftool/main.h                           | 1 +
 tools/bpf/bpftool/prog.c                           | 3 ++-
 6 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index d80fdde79c22..585f270c2d25 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -29,7 +29,8 @@ CGROUP COMMANDS
 |	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
 |	*ATTACH_TYPE* := { **ingress** | **egress** | **sock_create** | **sock_ops** | **device** |
 |		**bind4** | **bind6** | **post_bind4** | **post_bind6** | **connect4** | **connect6** |
-|		**sendmsg4** | **sendmsg6** | **recvmsg4** | **recvmsg6** | **sysctl** }
+|		**sendmsg4** | **sendmsg6** | **recvmsg4** | **recvmsg6** | **sysctl** |
+|		**getsockopt** | **setsockopt** }
 |	*ATTACH_FLAGS* := { **multi** | **override** }
 
 DESCRIPTION
@@ -90,7 +91,9 @@ DESCRIPTION
                   an unconnected udp4 socket (since 5.2);
 		  **recvmsg6** call to recvfrom(2), recvmsg(2), recvmmsg(2) for
                   an unconnected udp6 socket (since 5.2);
-		  **sysctl** sysctl access (since 5.2).
+		  **sysctl** sysctl access (since 5.2);
+		  **getsockopt** call to getsockopt (since 5.3);
+		  **setsockopt** call to setsockopt (since 5.3).
 
 	**bpftool cgroup detach** *CGROUP* *ATTACH_TYPE* *PROG*
 		  Detach *PROG* from the cgroup *CGROUP* and attach type
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 55dd06517a3b..1df637f85f94 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -40,7 +40,8 @@ PROG COMMANDS
 |		**lwt_seg6local** | **sockops** | **sk_skb** | **sk_msg** | **lirc_mode2** |
 |		**cgroup/bind4** | **cgroup/bind6** | **cgroup/post_bind4** | **cgroup/post_bind6** |
 |		**cgroup/connect4** | **cgroup/connect6** | **cgroup/sendmsg4** | **cgroup/sendmsg6** |
-|		**cgroup/recvmsg4** | **cgroup/recvmsg6** | **cgroup/sysctl**
+|		**cgroup/recvmsg4** | **cgroup/recvmsg6** | **cgroup/sysctl** |
+|		**cgroup/getsockopt** | **cgroup/setsockopt**
 |	}
 |       *ATTACH_TYPE* := {
 |		**msg_verdict** | **stream_verdict** | **stream_parser** | **flow_dissector**
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index a17e84c67498..ba37095e1f62 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -379,7 +379,8 @@ _bpftool()
                                 cgroup/sendmsg4 cgroup/sendmsg6 \
                                 cgroup/recvmsg4 cgroup/recvmsg6 \
                                 cgroup/post_bind4 cgroup/post_bind6 \
-                                cgroup/sysctl" -- \
+                                cgroup/sysctl cgroup/getsockopt \
+                                cgroup/setsockopt" -- \
                                                    "$cur" ) )
                             return 0
                             ;;
@@ -689,7 +690,8 @@ _bpftool()
                 attach|detach)
                     local ATTACH_TYPES='ingress egress sock_create sock_ops \
                         device bind4 bind6 post_bind4 post_bind6 connect4 \
-                        connect6 sendmsg4 sendmsg6 recvmsg4 recvmsg6 sysctl'
+                        connect6 sendmsg4 sendmsg6 recvmsg4 recvmsg6 sysctl \
+                        getsockopt setsockopt'
                     local ATTACH_FLAGS='multi override'
                     local PROG_TYPE='id pinned tag'
                     case $prev in
@@ -699,7 +701,8 @@ _bpftool()
                             ;;
                         ingress|egress|sock_create|sock_ops|device|bind4|bind6|\
                         post_bind4|post_bind6|connect4|connect6|sendmsg4|\
-                        sendmsg6|recvmsg4|recvmsg6|sysctl)
+                        sendmsg6|recvmsg4|recvmsg6|sysctl|getsockopt|\
+                        setsockopt)
                             COMPREPLY=( $( compgen -W "$PROG_TYPE" -- \
                                 "$cur" ) )
                             return 0
diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 73ec8ea33fb4..390b89a224f1 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -26,7 +26,8 @@
 	"                        sock_ops | device | bind4 | bind6 |\n"	       \
 	"                        post_bind4 | post_bind6 | connect4 |\n"       \
 	"                        connect6 | sendmsg4 | sendmsg6 |\n"           \
-	"                        recvmsg4 | recvmsg6 | sysctl }"
+	"                        recvmsg4 | recvmsg6 | sysctl |\n"	       \
+	"                        getsockopt | setsockopt }"
 
 static const char * const attach_type_strings[] = {
 	[BPF_CGROUP_INET_INGRESS] = "ingress",
@@ -45,6 +46,8 @@ static const char * const attach_type_strings[] = {
 	[BPF_CGROUP_SYSCTL] = "sysctl",
 	[BPF_CGROUP_UDP4_RECVMSG] = "recvmsg4",
 	[BPF_CGROUP_UDP6_RECVMSG] = "recvmsg6",
+	[BPF_CGROUP_GETSOCKOPT] = "getsockopt",
+	[BPF_CGROUP_SETSOCKOPT] = "setsockopt",
 	[__MAX_BPF_ATTACH_TYPE] = NULL,
 };
 
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 28a2a5857e14..9c5d9c80f71e 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -74,6 +74,7 @@ static const char * const prog_type_name[] = {
 	[BPF_PROG_TYPE_SK_REUSEPORT]		= "sk_reuseport",
 	[BPF_PROG_TYPE_FLOW_DISSECTOR]		= "flow_dissector",
 	[BPF_PROG_TYPE_CGROUP_SYSCTL]		= "cgroup_sysctl",
+	[BPF_PROG_TYPE_CGROUP_SOCKOPT]		= "cgroup_sockopt",
 };
 
 extern const char * const map_type_name[];
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index f1a831f05010..9b0db5d14e31 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1071,7 +1071,8 @@ static int do_help(int argc, char **argv)
 		"                 cgroup/bind4 | cgroup/bind6 | cgroup/post_bind4 |\n"
 		"                 cgroup/post_bind6 | cgroup/connect4 | cgroup/connect6 |\n"
 		"                 cgroup/sendmsg4 | cgroup/sendmsg6 | cgroup/recvmsg4 |\n"
-		"                 cgroup/recvmsg6 }\n"
+		"                 cgroup/recvmsg6 | cgroup/getsockopt |\n"
+		"                 cgroup/setsockopt }\n"
 		"       ATTACH_TYPE := { msg_verdict | stream_verdict | stream_parser |\n"
 		"                        flow_dissector }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
-- 
2.22.0.410.gd8fdbe21b5-goog

