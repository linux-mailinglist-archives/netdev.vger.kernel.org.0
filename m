Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3813E3B995
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbfFJQer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:34:47 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:53217 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728329AbfFJQeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:34:46 -0400
Received: by mail-qt1-f202.google.com with SMTP id c48so9482791qta.19
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 09:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LUp0nj+AqZw3G+Fm1Fsn+w6Tf8Ol+e+vk5LYlQtxXeU=;
        b=KobB5gjSPg8Gg1d2ox4dVsG/KCskwyZVD5NwQxnfS+t0vemYKQe/ZWY8J3gw7QKgvB
         IlOKi1ES+dEUijdy7XKsi0SMmcQ4S9CN3w/qFQwfuWrSSHSGaq1R90XdUPSbeH6wFOCJ
         tOkAOcUTavaAkDI9Ktd8qB2W90MdOupfL06RzopEwUjYRLW0MNVA0UMJb1jhYyFjtGku
         sC752PJX8u2UM8koKDXQZxpkLdfH0wRzcutSVv0Wtm5n4JAD9K8jsNrX+d4+NL5HsMTi
         TFcmW8FdkAIF1znUeshZfdEwrXGDIsQl9W5ig/xwEaahQqfaCr/uXxs2wpPf8F2hlCB0
         5krg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LUp0nj+AqZw3G+Fm1Fsn+w6Tf8Ol+e+vk5LYlQtxXeU=;
        b=b6PoEGJVEXrorx8sXK8am+eznauCT09r1cF0C9pmKTpm3uD3wPTBdU83yNJUKNXkcr
         JpOvcnWCKFd+pGCK4mlpFXOThY6JJC9mHXbZSOdGygg9E5rQGi+xC2z86GKApQv4dVzX
         vZejf6v45c6IkYDhvesxssIaZPaRTxCpoTuVsTnAley7aHwjWfH73VplCSIkh0rucXyU
         518Idv23gC/CrpPcJWLP6knDybpBPhkgUP5AgI4NzUYgJ9Aol6jGai4Cpame1Bf+fW8e
         ZrIr9CinU5iuF9Z62T3vND3uEaogvNRCMxEveQTcUK5XGnhsUtkAYVBSci/Vai5o9Z6C
         ddQQ==
X-Gm-Message-State: APjAAAUytS5rq3EfDfk/RGYi4XDDKoqfXDxUJdx2flMubAVrFegu+1AX
        lGl4M1lyT/jgD13OPe6F/sKLPriwo7tmNeGxXD2g8R3h7oULhyMA1h2VKXe1fZaqZPESBdFXcEu
        7GPsX2K9fCAjz0vo+1vD/sFcaWoTSY6ZGq2+93L3RR4VaVXfGtF9GAA==
X-Google-Smtp-Source: APXvYqzD6/dCTu7oopS4u/dAAk/pm10qqlg0uvYqEKjjqlhN4rtxwd6weG0DsIpKXWRsciZHMU98g6Y=
X-Received: by 2002:a05:620a:55c:: with SMTP id o28mr54164589qko.86.1560184484992;
 Mon, 10 Jun 2019 09:34:44 -0700 (PDT)
Date:   Mon, 10 Jun 2019 09:34:21 -0700
In-Reply-To: <20190610163421.208126-1-sdf@google.com>
Message-Id: <20190610163421.208126-9-sdf@google.com>
Mime-Version: 1.0
References: <20190610163421.208126-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH bpf-next v4 8/8] bpftool: support cgroup sockopt
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
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   | 2 +-
 tools/bpf/bpftool/bash-completion/bpftool          | 8 +++++---
 tools/bpf/bpftool/cgroup.c                         | 5 ++++-
 tools/bpf/bpftool/main.h                           | 1 +
 tools/bpf/bpftool/prog.c                           | 3 ++-
 6 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index 36807735e2a5..cac088a320a6 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -29,7 +29,8 @@ CGROUP COMMANDS
 |	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
 |	*ATTACH_TYPE* := { **ingress** | **egress** | **sock_create** | **sock_ops** | **device** |
 |		**bind4** | **bind6** | **post_bind4** | **post_bind6** | **connect4** | **connect6** |
-|		**sendmsg4** | **sendmsg6** | **sysctl** }
+|		**sendmsg4** | **sendmsg6** | **sysctl** | **getsockopt** |
+|		**setsockopt** }
 |	*ATTACH_FLAGS* := { **multi** | **override** }
 
 DESCRIPTION
@@ -86,7 +87,9 @@ DESCRIPTION
 		  unconnected udp4 socket (since 4.18);
 		  **sendmsg6** call to sendto(2), sendmsg(2), sendmmsg(2) for an
 		  unconnected udp6 socket (since 4.18);
-		  **sysctl** sysctl access (since 5.2).
+		  **sysctl** sysctl access (since 5.2);
+		  **getsockopt** call to getsockopt (since 5.3);
+		  **setsockopt** call to setsockopt (since 5.3).
 
 	**bpftool cgroup detach** *CGROUP* *ATTACH_TYPE* *PROG*
 		  Detach *PROG* from the cgroup *CGROUP* and attach type
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 228a5c863cc7..c6bade35032c 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -40,7 +40,7 @@ PROG COMMANDS
 |		**lwt_seg6local** | **sockops** | **sk_skb** | **sk_msg** | **lirc_mode2** |
 |		**cgroup/bind4** | **cgroup/bind6** | **cgroup/post_bind4** | **cgroup/post_bind6** |
 |		**cgroup/connect4** | **cgroup/connect6** | **cgroup/sendmsg4** | **cgroup/sendmsg6** |
-|		**cgroup/sysctl**
+|		**cgroup/sysctl** | **cgroup/getsockopt** | **cgroup/setsockopt**
 |	}
 |       *ATTACH_TYPE* := {
 |		**msg_verdict** | **stream_verdict** | **stream_parser** | **flow_dissector**
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 2725e27dfa42..7afb8b6fbaaa 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -378,7 +378,8 @@ _bpftool()
                                 cgroup/connect4 cgroup/connect6 \
                                 cgroup/sendmsg4 cgroup/sendmsg6 \
                                 cgroup/post_bind4 cgroup/post_bind6 \
-                                cgroup/sysctl" -- \
+                                cgroup/sysctl cgroup/getsockopt \
+                                cgroup/setsockopt" -- \
                                                    "$cur" ) )
                             return 0
                             ;;
@@ -688,7 +689,8 @@ _bpftool()
                 attach|detach)
                     local ATTACH_TYPES='ingress egress sock_create sock_ops \
                         device bind4 bind6 post_bind4 post_bind6 connect4 \
-                        connect6 sendmsg4 sendmsg6 sysctl'
+                        connect6 sendmsg4 sendmsg6 sysctl getsockopt \
+                        setsockopt'
                     local ATTACH_FLAGS='multi override'
                     local PROG_TYPE='id pinned tag'
                     case $prev in
@@ -698,7 +700,7 @@ _bpftool()
                             ;;
                         ingress|egress|sock_create|sock_ops|device|bind4|bind6|\
                         post_bind4|post_bind6|connect4|connect6|sendmsg4|\
-                        sendmsg6|sysctl)
+                        sendmsg6|sysctl|getsockopt|setsockopt)
                             COMPREPLY=( $( compgen -W "$PROG_TYPE" -- \
                                 "$cur" ) )
                             return 0
diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 7e22f115c8c1..3083f2e4886e 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -25,7 +25,8 @@
 	"       ATTACH_TYPE := { ingress | egress | sock_create |\n"	       \
 	"                        sock_ops | device | bind4 | bind6 |\n"	       \
 	"                        post_bind4 | post_bind6 | connect4 |\n"       \
-	"                        connect6 | sendmsg4 | sendmsg6 | sysctl }"
+	"                        connect6 | sendmsg4 | sendmsg6 | sysctl |\n"  \
+	"                        getsockopt | setsockopt }"
 
 static const char * const attach_type_strings[] = {
 	[BPF_CGROUP_INET_INGRESS] = "ingress",
@@ -42,6 +43,8 @@ static const char * const attach_type_strings[] = {
 	[BPF_CGROUP_UDP4_SENDMSG] = "sendmsg4",
 	[BPF_CGROUP_UDP6_SENDMSG] = "sendmsg6",
 	[BPF_CGROUP_SYSCTL] = "sysctl",
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
index 1f209c80d906..a201e1c83346 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1070,7 +1070,8 @@ static int do_help(int argc, char **argv)
 		"                 sk_reuseport | flow_dissector | cgroup/sysctl |\n"
 		"                 cgroup/bind4 | cgroup/bind6 | cgroup/post_bind4 |\n"
 		"                 cgroup/post_bind6 | cgroup/connect4 | cgroup/connect6 |\n"
-		"                 cgroup/sendmsg4 | cgroup/sendmsg6 }\n"
+		"                 cgroup/sendmsg4 | cgroup/sendmsg6 | cgroup/getsockopt |\n"
+		"                 cgroup/setsockopt }\n"
 		"       ATTACH_TYPE := { msg_verdict | stream_verdict | stream_parser |\n"
 		"                        flow_dissector }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

