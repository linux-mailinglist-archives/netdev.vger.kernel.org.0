Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37AEB11EAFE
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 20:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbfLMTKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 14:10:22 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50234 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbfLMTKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 14:10:22 -0500
Received: by mail-wm1-f67.google.com with SMTP id a5so149759wmb.0;
        Fri, 13 Dec 2019 11:10:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cJcNlOWQkLT6wwP61Be1G3FMcvlED0UM9DnDi1NbxEA=;
        b=pUyKr1UYsNmdk4cSHcVBfUT57J6f8OTffVXe68sA+PU1A0fq8obSMttCQ7aOd7AZz7
         B/9iuHAfh0p9QAtaCgmZgPHBn4fnuZnAUf9kErkDfktlY6Xk8LnwwcktM5UcnstbY5Q3
         vZFm+FPOVJb+oOJGWRpKYm84XotspeIVblkSEvUbQCmgSDTobbaZjflIfsy5j1JYxKil
         V1n8BUggIMxDz7LGl4NrQj/i2D3NTMJauF4D6ILjasxku/pntD8ZPak02dpR0vbOMRok
         BtJIMVWcPJKQvZu4YIk2mm9Y4jnsPHQcZgrsnpMh9N3TOE8MaCwgJNudyMlpee8YrZwK
         OW4Q==
X-Gm-Message-State: APjAAAUZnJs1VyAo0+Wo9Y5HIcqNYYtEHJzjGgPicc/PRPD1pMWGB2xM
        DQObL7IoKskE9GXeOsuu3g8=
X-Google-Smtp-Source: APXvYqzzi1NN8CCqjRg1I7X/0honvUDEI0qwt/sPWl0G+c1yZ7mX5MJAQe5HA5Ue0EyDcIvIEOhXxg==
X-Received: by 2002:a05:600c:21c5:: with SMTP id x5mr14634530wmj.72.1576264218609;
        Fri, 13 Dec 2019 11:10:18 -0800 (PST)
Received: from Omicron ([185.64.192.240])
        by smtp.gmail.com with ESMTPSA id a9sm2059173wmm.15.2019.12.13.11.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 11:10:17 -0800 (PST)
Date:   Fri, 13 Dec 2019 20:10:17 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     bpf@vger.kernel.org
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v2 2/3] bpftool: match programs by name
Message-ID: <b5fc1a5dcfaeb5f16fc80295cdaa606dd2d91534.1576263640.git.paul.chaignon@gmail.com>
References: <cover.1576263640.git.paul.chaignon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1576263640.git.paul.chaignon@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When working with frequently modified BPF programs, both the ID and the
tag may change.  bpftool currently doesn't provide a "stable" way to match
such programs.

This patch implements lookup by name for programs.  The show and dump
commands will return all programs with the given name, whereas other
commands will error out if several programs have the same name.

Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
---
 .../bpf/bpftool/Documentation/bpftool-map.rst |  2 +-
 .../bpftool/Documentation/bpftool-prog.rst    | 12 +++++-----
 tools/bpf/bpftool/bash-completion/bpftool     | 22 ++++++++++++++-----
 tools/bpf/bpftool/main.h                      |  2 +-
 tools/bpf/bpftool/prog.c                      | 22 +++++++++++++++----
 5 files changed, 42 insertions(+), 18 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index 1c0f7146aab0..90d848b5b7d3 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -41,7 +41,7 @@ MAP COMMANDS
 |
 |	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
 |	*DATA* := { [**hex**] *BYTES* }
-|	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
+|	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* | **name** *PROG_NAME* }
 |	*VALUE* := { *DATA* | *MAP* | *PROG* }
 |	*UPDATE_FLAGS* := { **any** | **exist** | **noexist** }
 |	*TYPE* := { **hash** | **array** | **prog_array** | **perf_event_array** | **percpu_hash**
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index d377d0cb7923..64ddf8a4c518 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -33,7 +33,7 @@ PROG COMMANDS
 |	**bpftool** **prog help**
 |
 |	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
-|	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
+|	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* | **name** *PROG_NAME* }
 |	*TYPE* := {
 |		**socket** | **kprobe** | **kretprobe** | **classifier** | **action** |
 |		**tracepoint** | **raw_tracepoint** | **xdp** | **perf_event** | **cgroup/skb** |
@@ -55,8 +55,8 @@ DESCRIPTION
 		  Show information about loaded programs.  If *PROG* is
 		  specified show information only about given programs,
 		  otherwise list all programs currently loaded on the system.
-		  In case of **tag**, *PROG* may match several programs which
-		  will all be shown.
+		  In case of **tag** or **name**, *PROG* may match several
+		  programs which will all be shown.
 
 		  Output will start with program ID followed by program type and
 		  zero or more named attributes (depending on kernel version).
@@ -75,9 +75,9 @@ DESCRIPTION
 		  output in human-readable format. In this case, **opcodes**
 		  controls if raw opcodes should be printed as well.
 
-		  In case of **tag**, *PROG* may match several programs which
-		  will all be dumped.  However, if **file** or **visual** is
-		  specified, *PROG* must match a single program.
+		  In case of **tag** or **name**, *PROG* may match several
+		  programs which will all be dumped.  However, if **file** or
+		  **visual** is specified, *PROG* must match a single program.
 
 		  If **file** is specified, the binary image will instead be
 		  written to *FILE*.
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 70493a6da206..05b5be4a6ef9 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -71,6 +71,12 @@ _bpftool_get_prog_tags()
         command sed -n 's/.*"tag": "\(.*\)",$/\1/p' )" -- "$cur" ) )
 }
 
+_bpftool_get_prog_names()
+{
+    COMPREPLY+=( $( compgen -W "$( bpftool -jp prog 2>&1 | \
+        command sed -n 's/.*"name": "\(.*\)",$/\1/p' )" -- "$cur" ) )
+}
+
 _bpftool_get_btf_ids()
 {
     COMPREPLY+=( $( compgen -W "$( bpftool -jp btf 2>&1 | \
@@ -201,6 +207,10 @@ _bpftool()
             _bpftool_get_prog_tags
             return 0
             ;;
+        name)
+            _bpftool_get_prog_names
+            return 0
+            ;;
         dev)
             _sysfs_get_netdevs
             return 0
@@ -263,7 +273,7 @@ _bpftool()
                     ;;
             esac
 
-            local PROG_TYPE='id pinned tag'
+            local PROG_TYPE='id pinned tag name'
             local MAP_TYPE='id pinned'
             case $command in
                 show|list)
@@ -559,7 +569,7 @@ _bpftool()
                                     return 0
                                     ;;
                                 prog_array)
-                                    local PROG_TYPE='id pinned tag'
+                                    local PROG_TYPE='id pinned tag name'
                                     COMPREPLY+=( $( compgen -W "$PROG_TYPE" \
                                         -- "$cur" ) )
                                     return 0
@@ -644,7 +654,7 @@ _bpftool()
             esac
             ;;
         btf)
-            local PROG_TYPE='id pinned tag'
+            local PROG_TYPE='id pinned tag name'
             local MAP_TYPE='id pinned'
             case $command in
                 dump)
@@ -735,7 +745,7 @@ _bpftool()
                         connect6 sendmsg4 sendmsg6 recvmsg4 recvmsg6 sysctl \
                         getsockopt setsockopt'
                     local ATTACH_FLAGS='multi override'
-                    local PROG_TYPE='id pinned tag'
+                    local PROG_TYPE='id pinned tag name'
                     case $prev in
                         $command)
                             _filedir
@@ -760,7 +770,7 @@ _bpftool()
                             elif [[ "$command" == "attach" ]]; then
                                 # We have an attach type on the command line,
                                 # but it is not the previous word, or
-                                # "id|pinned|tag" (we already checked for
+                                # "id|pinned|tag|name" (we already checked for
                                 # that). This should only leave the case when
                                 # we need attach flags for "attach" commamnd.
                                 _bpftool_one_of_list "$ATTACH_FLAGS"
@@ -786,7 +796,7 @@ _bpftool()
             esac
             ;;
         net)
-            local PROG_TYPE='id pinned tag'
+            local PROG_TYPE='id pinned tag name'
             local ATTACH_TYPES='xdp xdpgeneric xdpdrv xdpoffload'
             case $command in
                 show|list)
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 2899095f8254..a7ead7bb9447 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -42,7 +42,7 @@
 #define BPF_TAG_FMT	"%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx"
 
 #define HELP_SPEC_PROGRAM						\
-	"PROG := { id PROG_ID | pinned FILE | tag PROG_TAG }"
+	"PROG := { id PROG_ID | pinned FILE | tag PROG_TAG | name PROG_NAME }"
 #define HELP_SPEC_OPTIONS						\
 	"OPTIONS := { {-j|--json} [{-p|--pretty}] | {-f|--bpffs} |\n"	\
 	"\t            {-m|--mapcompat} | {-n|--nomount} }"
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 37948c47aabd..2221bae037f1 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -82,7 +82,7 @@ static void print_boot_time(__u64 nsecs, char *buf, unsigned int size)
 		strftime(buf, size, "%FT%T%z", &load_tm);
 }
 
-static int prog_fd_by_tag(unsigned char *tag, int **fds)
+static int prog_fd_by_nametag(void *nametag, int **fds, bool tag)
 {
 	unsigned int id = 0;
 	int fd, nb_fds = 0;
@@ -116,7 +116,8 @@ static int prog_fd_by_tag(unsigned char *tag, int **fds)
 			goto err_close_fd;
 		}
 
-		if (memcmp(tag, info.tag, BPF_TAG_SIZE)) {
+		if ((tag && memcmp(nametag, info.tag, BPF_TAG_SIZE)) ||
+		    (!tag && strncmp(nametag, info.name, BPF_OBJ_NAME_LEN))) {
 			close(fd);
 			continue;
 		}
@@ -174,7 +175,20 @@ static int prog_parse_fds(int *argc, char ***argv, int **fds)
 		}
 		NEXT_ARGP();
 
-		return prog_fd_by_tag(tag, fds);
+		return prog_fd_by_nametag(tag, fds, true);
+	} else if (is_prefix(**argv, "name")) {
+		char *name;
+
+		NEXT_ARGP();
+
+		name = **argv;
+		if (strlen(name) > BPF_OBJ_NAME_LEN - 1) {
+			p_err("can't parse name");
+			return -1;
+		}
+		NEXT_ARGP();
+
+		return prog_fd_by_nametag(name, fds, false);
 	} else if (is_prefix(**argv, "pinned")) {
 		char *path;
 
@@ -189,7 +203,7 @@ static int prog_parse_fds(int *argc, char ***argv, int **fds)
 		return 1;
 	}
 
-	p_err("expected 'id', 'tag' or 'pinned', got: '%s'?", **argv);
+	p_err("expected 'id', 'tag', 'name' or 'pinned', got: '%s'?", **argv);
 	return -1;
 }
 
-- 
2.24.0

