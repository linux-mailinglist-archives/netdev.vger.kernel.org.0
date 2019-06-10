Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 024923BE1E
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389948AbfFJVIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:08:55 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:39750 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389714AbfFJVIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:08:55 -0400
Received: by mail-qt1-f201.google.com with SMTP id o16so10052017qtj.6
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 14:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LUp0nj+AqZw3G+Fm1Fsn+w6Tf8Ol+e+vk5LYlQtxXeU=;
        b=Qr4QnfqUnUg/XPwC7g4dXQn+zzihbSyDRPERJFM21Hm4TwDlTjilaIxNAHgASdhXnw
         fFT88B/rUJ8jPiQ6/D+MmhaozKy03V84s0dv4CgyngggXg6nrIAFnt3v+ZDvRasFJAq2
         U8jxi+f+d9ZGV/nHYdB1Se61fs4mqd4sFYZkDhUja7xudphZMxpfnooXhQfTKbIyrH4x
         Ii9Ru6uGzvYE9RTrNKcsznFefKaLYSLJNEQ28hjFsrjzS90du9pF7jXKMxdg89DNA1W2
         U+Lf1XtOw62D/k5IMAejGVNYZhn5UcSp/G2zfEIQxrAAOYrRqLtXPrYsq0EFkAyxCXLJ
         yxag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LUp0nj+AqZw3G+Fm1Fsn+w6Tf8Ol+e+vk5LYlQtxXeU=;
        b=YdnGGHJcV62EwPSSLkUX8J+cNgr+4bSm08GGI8twe1VTfg4y1Grwx1xLMbQ22dptcq
         V1DYle5+7vvVRweU+cTWiHXOxSKrRe2Areh9/4E5ElqHYNWN8C22CH6+EjlRbC+Y3bu+
         6h5Cu28eN2Pv7PTaQSbTKSLJnVZPEJ76VG8sroNSl9A1Nypxql8cljlHZTC0uQhv1f94
         V05q+Jr1yxwnAhg2YeESYt1ZZZ79HYMizuc0j5sJDqCOW9IRD40VdA0CxPKJ9E5zh2S2
         DKIpgJ7bu8YZXCX3zN1a/54NMrF0pUwKtU3hNr9YEFbrOPfA+f/IZark2zJwYRoXczrb
         ffqw==
X-Gm-Message-State: APjAAAVuWkJMYr9fmkBTCUneuIkgpG8pIbnY3h4usSIVpiZqVZFfLpVY
        S8EGmIvqPJmIQek75d9+Yz3z//XqvL84xz250kQAWt8yHpnvivWmKY3nQ8ozUfEQYtPGIxBgjvq
        GCPcPofhDWQnFDkW6gFPscjGzYn/kRY+Vllt/GzU2IjlHy3xW76r9dw==
X-Google-Smtp-Source: APXvYqxiqVHQykSUTUM2skzxR6ol3sY+RTBGC14LRbbDbX4PwM+IlmfDSUPJbsRc58v2vfM+XPyFAys=
X-Received: by 2002:a0c:d0ab:: with SMTP id z40mr5367513qvg.216.1560200933777;
 Mon, 10 Jun 2019 14:08:53 -0700 (PDT)
Date:   Mon, 10 Jun 2019 14:08:30 -0700
In-Reply-To: <20190610210830.105694-1-sdf@google.com>
Message-Id: <20190610210830.105694-9-sdf@google.com>
Mime-Version: 1.0
References: <20190610210830.105694-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH bpf-next v5 8/8] bpftool: support cgroup sockopt
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

