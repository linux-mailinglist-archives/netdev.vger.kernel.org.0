Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21FB25FFBE
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbgIGQhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730912AbgIGQgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:36:44 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FC1C061756
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 09:36:44 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z9so14756718wmk.1
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 09:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WYfb4HWcJBJMQdB3pqwUW7b6FRg6vrPe0DE1icCl/CA=;
        b=LzeUHCuPZgMZRfyTCiGhiPj0Iflpe7PNnruPAN6w9rHEYIgOofCgNsdottEDdUZzzx
         v/3N/z9QhGEzjWwnnKEqg2yuQhCAcmfNPd3T5Nb7/gdcmoLt28bhjz9L1Z+ZnueZ5pQy
         iEUrx/9VJ8m2qX5lCYxk634Sq9sDLqPGx9bV8usWHXuZiP5Jc++p3W4bkeJ6YVcGg1aN
         fRExS71wkvoWj5cYfjbUXefTIllrBfeECeQuwaKCbf+Rk1uNmurp9dUaLyDEwpX2IZuQ
         KcEn9APPEJFSMQq3ZIOd88E81HeovixVVvsaNsBGCT3E2IPNTkA8W6yI1wPSXueLaQZ8
         R7xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WYfb4HWcJBJMQdB3pqwUW7b6FRg6vrPe0DE1icCl/CA=;
        b=YmAVKukyZ1tAa8+2S53eqnWYJ09ucsRz1tS0rTrt9xzATb1dqCpL9q583RFx/h2eRJ
         fHkb3mEQ5/TgcOFyJtC8csmbTnPoDRC2f04z9Fo/RZ2NXsPVRa6HZcTxhUH/92SOPk4P
         X301Sirh1bK2uWBkCdqXT53cIUc/DbMt/zCiCSXhMYt646CgUiHyCRTnsxeS1368GvLV
         kLKM00CzqrzKZCnDQoVq6JEKUJZXq4gnJ4S9B4hMK/p8AXIExFXcnFY07zIuCVkPHCUE
         Kcw3yFm8BpqAjbxTTeMcrNUfWdS1SjafmNlsJ5ykPRSBwLH9bXkfFxYVPAm5DPiDsG0c
         8hGw==
X-Gm-Message-State: AOAM5301pBn74ux/w5iOEXEUTb2g/OUE0VBdNeJ9eKPBU+magNwy1lqs
        TQqN/pnBmznVjz7I/saG5VdFeQ==
X-Google-Smtp-Source: ABdhPJxgf3Ms4f6Cfdx5mGCULGYbEwJdDPdE2IxsiiANVmfaw0JFm5LRMCB3noqsG9vKJF8bqxJ+hg==
X-Received: by 2002:a1c:234d:: with SMTP id j74mr125626wmj.157.1599496602801;
        Mon, 07 Sep 2020 09:36:42 -0700 (PDT)
Received: from localhost.localdomain ([194.35.119.17])
        by smtp.gmail.com with ESMTPSA id p11sm26443677wma.11.2020.09.07.09.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 09:36:42 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v2 2/2] tools: bpftool: add "inner_map" to "bpftool map create" outer maps
Date:   Mon,  7 Sep 2020 17:36:34 +0100
Message-Id: <20200907163634.27469-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200907163634.27469-1-quentin@isovalent.com>
References: <20200907163634.27469-1-quentin@isovalent.com>
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
index c8159cb4fb1e..7370fdd57de3 100644
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

