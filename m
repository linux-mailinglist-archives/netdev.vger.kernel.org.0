Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1F626440B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 12:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbgIJK2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 06:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730994AbgIJK1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 06:27:25 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2807DC061796
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 03:27:07 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e16so6133202wrm.2
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 03:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XC0iDw6777QFQ54Z7stSWW/UTmCzF7IOhEeUMJqpmVE=;
        b=uraQML+1Cin1yukPe13IaWUaxZ+T7AUnXo9TCP30M1AqnoT5zi5+VhOQKynIgiP1C8
         3mXapMQHt23CkFT/undoioMr+TscDmGiv1VsDLZ4jQ4Xxei/o7azhRn+pwVM/z0q2F+B
         ECH7yiF7pCjz+bXHZpaf4m45cUJifG/dPFjbCHhSVVAlnCIqM+ljQHt4EK0+0xpo7jYp
         DAGllqo40vKCeTebTvmi2i1hZyF/m3EG3Y2Kxxoe3MamI+W8VAxqdvawyTiCSBGiGjnw
         0f86F4MhwhZl81ZQOjbudfCJOFp+aphnRRnuvj7kP8DQ9sxQp25GcMHMDZL9RyO8VptE
         kc5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XC0iDw6777QFQ54Z7stSWW/UTmCzF7IOhEeUMJqpmVE=;
        b=FfCAPj3285a2OUVUewSTyBcpEcLqgIj377mtYsdICPiNZuPW5K1TonJR8hZsx7kgbI
         +v05fO5sWQq6JdhUi/Q4W4x2QwLTDouZqqh7xkSZKX8R1I6XuqTkW7g8HxY425jIVMmt
         mtkKNYSbwqZsV8pdPfY6Bn53oKhvjzqLr8ytxQvxRlp7a+e3IHIB/esxsw/KFWvrHydp
         w0Du7c7IIcWHN0UA6QEFCSBYJfSwN7RYPOJN7Vc+/0eXpEyprPzpReo//e2ZIQRjs60x
         CzwTKfC7mJoPnCKD9cAUiZ7zM7YgFXgwVNQBUfLRqWQa9PnuyNyasO8g9HpS2a9/C2V3
         FGmA==
X-Gm-Message-State: AOAM530TB4g4Ecmi/wWm3JGiYs7DH527YJYkRM35k3LFGoPnUJqEgj2D
        /CjBjbS9lfxqIwll3OrgN7/IGA==
X-Google-Smtp-Source: ABdhPJw03BQjuVXI10qJXEcfKLhaSU/Mz7OegpQSOyDcv3P0H39LmKMc1gOw46O2R7/7udYa6pY12g==
X-Received: by 2002:a05:6000:151:: with SMTP id r17mr8018232wrx.311.1599733625697;
        Thu, 10 Sep 2020 03:27:05 -0700 (PDT)
Received: from localhost.localdomain ([194.35.119.178])
        by smtp.gmail.com with ESMTPSA id h186sm3039494wmf.24.2020.09.10.03.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 03:27:05 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v3 3/3] tools: bpftool: add "inner_map" to "bpftool map create" outer maps
Date:   Thu, 10 Sep 2020 11:26:52 +0100
Message-Id: <20200910102652.10509-4-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200910102652.10509-1-quentin@isovalent.com>
References: <20200910102652.10509-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no support for creating maps of types array-of-map or
hash-of-map in bpftool. This is because the kernel needs an inner_map_fd
to collect metadata on the inner maps to be supported by the new map,
but bpftool does not provide a way to pass this file descriptor.

Add a new optional "inner_map" keyword that can be used to pass a
reference to a map, retrieve a fd to that map, and pass it as the
inner_map_fd.

Add related documentation and bash completion. Note that we can
reference the inner map by its name, meaning we can have several times
the keyword "name" with different meanings (mandatory outer map name,
and possibly a name to use to find the inner_map_fd). The bash
completion will offer it just once, and will not suggest "name" on the
following command:

    # bpftool map create /sys/fs/bpf/my_outer_map type hash_of_maps \
        inner_map name my_inner_map [TAB]

Fixing that specific case seems too convoluted. Completion will work as
expected, however, if the outer map name comes first and the "inner_map
name ..." is passed second.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 .../bpf/bpftool/Documentation/bpftool-map.rst | 10 +++-
 tools/bpf/bpftool/bash-completion/bpftool     | 22 ++++++++-
 tools/bpf/bpftool/map.c                       | 48 +++++++++++++------
 3 files changed, 62 insertions(+), 18 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index 083db6c2fc67..ca9d62d7e0bd 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -23,7 +23,8 @@ MAP COMMANDS
 
 |	**bpftool** **map** { **show** | **list** }   [*MAP*]
 |	**bpftool** **map create**     *FILE* **type** *TYPE* **key** *KEY_SIZE* **value** *VALUE_SIZE* \
-|		**entries** *MAX_ENTRIES* **name** *NAME* [**flags** *FLAGS*] [**dev** *NAME*]
+|		**entries** *MAX_ENTRIES* **name** *NAME* [**flags** *FLAGS*] [**inner_map** *MAP*] \
+|		[**dev** *NAME*]
 |	**bpftool** **map dump**       *MAP*
 |	**bpftool** **map update**     *MAP* [**key** *DATA*] [**value** *VALUE*] [*UPDATE_FLAGS*]
 |	**bpftool** **map lookup**     *MAP* [**key** *DATA*]
@@ -67,7 +68,7 @@ DESCRIPTION
 		  maps. On such kernels bpftool will automatically emit this
 		  information as well.
 
-	**bpftool map create** *FILE* **type** *TYPE* **key** *KEY_SIZE* **value** *VALUE_SIZE*  **entries** *MAX_ENTRIES* **name** *NAME* [**flags** *FLAGS*] [**dev** *NAME*]
+	**bpftool map create** *FILE* **type** *TYPE* **key** *KEY_SIZE* **value** *VALUE_SIZE*  **entries** *MAX_ENTRIES* **name** *NAME* [**flags** *FLAGS*] [**inner_map** *MAP*] [**dev** *NAME*]
 		  Create a new map with given parameters and pin it to *bpffs*
 		  as *FILE*.
 
@@ -75,6 +76,11 @@ DESCRIPTION
 		  desired flags, e.g. 1024 for **BPF_F_MMAPABLE** (see bpf.h
 		  UAPI header for existing flags).
 
+		  To create maps of type array-of-maps or hash-of-maps, the
+		  **inner_map** keyword must be used to pass an inner map. The
+		  kernel needs it to collect metadata related to the inner maps
+		  that the new map will work with.
+
 		  Keyword **dev** expects a network interface name, and is used
 		  to request hardware offload for the map.
 
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 7b68e3c0a5fb..3f1da30c4da6 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -709,9 +709,26 @@ _bpftool()
                                                    "$cur" ) )
                             return 0
                             ;;
-                        key|value|flags|name|entries)
+                        key|value|flags|entries)
                             return 0
                             ;;
+                        inner_map)
+                            COMPREPLY=( $( compgen -W "$MAP_TYPE" -- "$cur" ) )
+                            return 0
+                            ;;
+                        id)
+                            _bpftool_get_map_ids
+                            ;;
+                        name)
+                            case $pprev in
+                                inner_map)
+                                    _bpftool_get_map_names
+                                    ;;
+                                *)
+                                    return 0
+                                    ;;
+                            esac
+                            ;;
                         *)
                             _bpftool_once_attr 'type'
                             _bpftool_once_attr 'key'
@@ -719,6 +736,9 @@ _bpftool()
                             _bpftool_once_attr 'entries'
                             _bpftool_once_attr 'name'
                             _bpftool_once_attr 'flags'
+                            if _bpftool_search_list 'array_of_maps' 'hash_of_maps'; then
+                                _bpftool_once_attr 'inner_map'
+                            fi
                             _bpftool_once_attr 'dev'
                             return 0
                             ;;
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index d8581d5e98a1..a7efbd84fbcc 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -1250,7 +1250,7 @@ static int do_create(int argc, char **argv)
 {
 	struct bpf_create_map_attr attr = { NULL, };
 	const char *pinfile;
-	int err, fd;
+	int err = -1, fd;
 
 	if (!REQ_ARGS(7))
 		return -1;
@@ -1265,13 +1265,13 @@ static int do_create(int argc, char **argv)
 
 			if (attr.map_type) {
 				p_err("map type already specified");
-				return -1;
+				goto exit;
 			}
 
 			attr.map_type = map_type_from_str(*argv);
 			if ((int)attr.map_type < 0) {
 				p_err("unrecognized map type: %s", *argv);
-				return -1;
+				goto exit;
 			}
 			NEXT_ARG();
 		} else if (is_prefix(*argv, "name")) {
@@ -1280,43 +1280,56 @@ static int do_create(int argc, char **argv)
 		} else if (is_prefix(*argv, "key")) {
 			if (parse_u32_arg(&argc, &argv, &attr.key_size,
 					  "key size"))
-				return -1;
+				goto exit;
 		} else if (is_prefix(*argv, "value")) {
 			if (parse_u32_arg(&argc, &argv, &attr.value_size,
 					  "value size"))
-				return -1;
+				goto exit;
 		} else if (is_prefix(*argv, "entries")) {
 			if (parse_u32_arg(&argc, &argv, &attr.max_entries,
 					  "max entries"))
-				return -1;
+				goto exit;
 		} else if (is_prefix(*argv, "flags")) {
 			if (parse_u32_arg(&argc, &argv, &attr.map_flags,
 					  "flags"))
-				return -1;
+				goto exit;
 		} else if (is_prefix(*argv, "dev")) {
 			NEXT_ARG();
 
 			if (attr.map_ifindex) {
 				p_err("offload device already specified");
-				return -1;
+				goto exit;
 			}
 
 			attr.map_ifindex = if_nametoindex(*argv);
 			if (!attr.map_ifindex) {
 				p_err("unrecognized netdevice '%s': %s",
 				      *argv, strerror(errno));
-				return -1;
+				goto exit;
 			}
 			NEXT_ARG();
+		} else if (is_prefix(*argv, "inner_map")) {
+			struct bpf_map_info info = {};
+			__u32 len = sizeof(info);
+			int inner_map_fd;
+
+			NEXT_ARG();
+			if (!REQ_ARGS(2))
+				usage();
+			inner_map_fd = map_parse_fd_and_info(&argc, &argv,
+							     &info, &len);
+			if (inner_map_fd < 0)
+				return -1;
+			attr.inner_map_fd = inner_map_fd;
 		} else {
 			p_err("unknown arg %s", *argv);
-			return -1;
+			goto exit;
 		}
 	}
 
 	if (!attr.name) {
 		p_err("map name not specified");
-		return -1;
+		goto exit;
 	}
 
 	set_max_rlimit();
@@ -1324,17 +1337,22 @@ static int do_create(int argc, char **argv)
 	fd = bpf_create_map_xattr(&attr);
 	if (fd < 0) {
 		p_err("map create failed: %s", strerror(errno));
-		return -1;
+		goto exit;
 	}
 
 	err = do_pin_fd(fd, pinfile);
 	close(fd);
 	if (err)
-		return err;
+		goto exit;
 
 	if (json_output)
 		jsonw_null(json_wtr);
-	return 0;
+
+exit:
+	if (attr.inner_map_fd > 0)
+		close(attr.inner_map_fd);
+
+	return err;
 }
 
 static int do_pop_dequeue(int argc, char **argv)
@@ -1420,7 +1438,7 @@ static int do_help(int argc, char **argv)
 		"Usage: %1$s %2$s { show | list }   [MAP]\n"
 		"       %1$s %2$s create     FILE type TYPE key KEY_SIZE value VALUE_SIZE \\\n"
 		"                                  entries MAX_ENTRIES name NAME [flags FLAGS] \\\n"
-		"                                  [dev NAME]\n"
+		"                                  [inner_map MAP] [dev NAME]\n"
 		"       %1$s %2$s dump       MAP\n"
 		"       %1$s %2$s update     MAP [key DATA] [value VALUE] [UPDATE_FLAGS]\n"
 		"       %1$s %2$s lookup     MAP [key DATA]\n"
-- 
2.25.1

