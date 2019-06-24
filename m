Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E55A51891
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbfFXQY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:24:59 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:50848 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731930AbfFXQY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:24:56 -0400
Received: by mail-pf1-f201.google.com with SMTP id h27so9852829pfq.17
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EfgnC8pfVZNk/KTc0n9v3CAEQ82DZ1hKaslBIVETbYc=;
        b=qOtywTYcLpN2E24m0OZUY6Fv3nKPavGEYoCPfC70pIdnEmZoGd5Q3EDvHZDFwgNjkh
         9JXqw+yfS3anhYpEhrJqjseagWH551SX1JcL931lDMN1GATiYfY8V3H1wyjxpBFhOhGn
         XtQ2CpPk80jkyrrcdfGZ/NIHWTbCISYGiLKG5gCOh4huwcLPot2fylnqGcgsqDiBP+Gp
         q9efGYEs3o+4vOeYxI7zUFM2ky/JEfiXJEZFyc0iAS1Rv45bZQEf9p71PUsI+7J2NbTm
         Su+gkBdBO21zQCm4zkeua6LYRNVKOYljN7tXLHSk76abTlXbtw9dGbIXDQ69y2kAQClV
         j4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EfgnC8pfVZNk/KTc0n9v3CAEQ82DZ1hKaslBIVETbYc=;
        b=nqlfM4R+3nf2PzPUOxLF8YCzXIv87myDBOHLuTbFqF8+BBzBI5v+GC6/BmPZqFF7Fy
         aPqSvEgm41H0qTbaJ0G2Kw4fIZtVraAPq1EYiScgGawC1shUDndVc+Ya3tU9rEIXgb/M
         cL7e8dJ2Gyb4bOCqLOFMt7nh8LTch8maNZMxRySmkLthD6LMb7nGO6y3aj+HTNNAjiBO
         AXE8klq/vLp7GBQ5KXsnL/6OIWQTSa5sXVdtookThg3inBBzjHWPEfOLmCgDYA7tt7qC
         PvvBAAcmGCjtQEDZjYv+I5uN0XJ2FWh5g0p9lB5LtPvxxITp8DgWS1SN9aezvlkPzZt7
         Z5yw==
X-Gm-Message-State: APjAAAUuO+3FwfiFQfD4sGX61rDl6FfY+ERUl+SLVbLIJOYvRDths+n2
        sIxP7QlFA/pzxDnkEAWOD0EKxCigo7VMQnp1F15FvTZbYrbDmUoMlry7hL3mV2nLl6sGOQSr8Nk
        wUeJJNXD9WACf2ONLQMFS8KQJ9dbyTYQUkLPYBPRI4akUTzsdevvjcg==
X-Google-Smtp-Source: APXvYqzWyzaN31Nj0t4SY4KBuWHtwZgGnz5nQH7HeiV9VX8ELbLAbCHjGPEzT6e5spVj+TJPv73Wuc0=
X-Received: by 2002:a63:1c59:: with SMTP id c25mr33275578pgm.395.1561393495760;
 Mon, 24 Jun 2019 09:24:55 -0700 (PDT)
Date:   Mon, 24 Jun 2019 09:24:29 -0700
In-Reply-To: <20190624162429.16367-1-sdf@google.com>
Message-Id: <20190624162429.16367-10-sdf@google.com>
Mime-Version: 1.0
References: <20190624162429.16367-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v8 9/9] bpftool: support cgroup sockopt
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Martin Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support sockopt prog type and cgroup hooks in the bpftool.

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
index 324df15bf4cc..6ac98f08e9d0 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -30,7 +30,8 @@ CGROUP COMMANDS
 |	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
 |	*ATTACH_TYPE* := { **ingress** | **egress** | **sock_create** | **sock_ops** | **device** |
 |		**bind4** | **bind6** | **post_bind4** | **post_bind6** | **connect4** | **connect6** |
-|		**sendmsg4** | **sendmsg6** | **recvmsg4** | **recvmsg6** | **sysctl** }
+|		**sendmsg4** | **sendmsg6** | **recvmsg4** | **recvmsg6** | **sysctl** |
+|		**getsockopt** | **setsockopt** }
 |	*ATTACH_FLAGS* := { **multi** | **override** }
 
 DESCRIPTION
@@ -91,7 +92,9 @@ DESCRIPTION
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
index c98cb99867f6..08f35c787ab6 100644
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
index 1bb2a751107a..24937891bc48 100644
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
index fddec15c454a..fb0ba77e6722 100644
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

