Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A31111EB08
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 20:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbfLMTKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 14:10:44 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45529 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbfLMTKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 14:10:43 -0500
Received: by mail-wr1-f67.google.com with SMTP id j42so588687wrj.12;
        Fri, 13 Dec 2019 11:10:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nnB/KMyJMkzJcCukrwzErV41PKLe/hQ20LgG9M3lELU=;
        b=l0vXfB9eto0rZvEB+jqQY18rAooXgtNZuOehv6klFDfLhJ/DFXLi5+PV1rpbLS/SiB
         EUxNbXw4PzpqVbhdhY/fJDUZNSt1QWRK3cPTaWwRuw1BEZp60uTaQlQLGNOONohf35G8
         L5nSwM0ouisXZHu2XJOb5yMPJzYmUcgham8KH4tfB7gUh3A8ZnIp7QJbd20LDzoAO+5J
         jBNrz4LG46hyDF0cCyAbZhE04eF1ubKKyPNWEqOCKMqp1TfVejUW8NrZEXoQw/p8Eki2
         Jo6TlL47K5/LOuqzTP1fAiLz2t4kRb6RIGhRuFY73rtIoGJwp18JkqqzpTm214FlyDdc
         Vf+Q==
X-Gm-Message-State: APjAAAXmi1HSabAny20FIU9+oVhIUIFqW9R+Ebj7nXinzjcmyrBRLPMW
        kDpU4S+ws60AILBkFrCih+asSah65G0XKQ==
X-Google-Smtp-Source: APXvYqy+Jz7dTTxjD8XH7jpZ40GtzAX6mJ91i79fGEGWhdRVIew9EDUiv6WSbPDtEkkv+IU6cbSAqA==
X-Received: by 2002:adf:a109:: with SMTP id o9mr15414490wro.189.1576264238405;
        Fri, 13 Dec 2019 11:10:38 -0800 (PST)
Received: from Omicron ([185.64.192.240])
        by smtp.gmail.com with ESMTPSA id f12sm11522266wmf.28.2019.12.13.11.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 11:10:37 -0800 (PST)
Date:   Fri, 13 Dec 2019 20:10:37 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     bpf@vger.kernel.org
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v2 3/3] bpftool: match maps by name
Message-ID: <8de1c9f273860b3ea1680502928f4da2336b853e.1576263640.git.paul.chaignon@gmail.com>
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

This patch implements lookup by name for maps and changes the behavior of
lookups by tag to be consistent with prog subcommands.  Similarly to
program subcommands, the show and dump commands will return all maps with
the given name (or tag), whereas other commands will error out if several
maps have the same name (resp. tag).

When a map has BTF info, it is dumped in JSON with available BTF info.
This patch requires that all matched maps have BTF info before switching
the output format to JSON.

Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
---
 .../bpf/bpftool/Documentation/bpftool-map.rst |  10 +-
 tools/bpf/bpftool/bash-completion/bpftool     | 131 +++++-
 tools/bpf/bpftool/main.h                      |   2 +-
 tools/bpf/bpftool/map.c                       | 384 ++++++++++++++----
 4 files changed, 439 insertions(+), 88 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index 90d848b5b7d3..cdeae8ae90ba 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -39,7 +39,7 @@ MAP COMMANDS
 |	**bpftool** **map freeze**     *MAP*
 |	**bpftool** **map help**
 |
-|	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
+|	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* | **name** *MAP_NAME* }
 |	*DATA* := { [**hex**] *BYTES* }
 |	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* | **name** *PROG_NAME* }
 |	*VALUE* := { *DATA* | *MAP* | *PROG* }
@@ -55,8 +55,9 @@ DESCRIPTION
 ===========
 	**bpftool map { show | list }**   [*MAP*]
 		  Show information about loaded maps.  If *MAP* is specified
-		  show information only about given map, otherwise list all
-		  maps currently loaded on the system.
+		  show information only about given maps, otherwise list all
+		  maps currently loaded on the system.  In case of **name**,
+		  *MAP* may match several maps which will all be shown.
 
 		  Output will start with map ID followed by map type and
 		  zero or more named attributes (depending on kernel version).
@@ -66,7 +67,8 @@ DESCRIPTION
 		  as *FILE*.
 
 	**bpftool map dump**    *MAP*
-		  Dump all entries in a given *MAP*.
+		  Dump all entries in a given *MAP*.  In case of **name**,
+		  *MAP* may match several maps which will all be dumped.
 
 	**bpftool map update**  *MAP* [**key** *DATA*] [**value** *VALUE*] [*UPDATE_FLAGS*]
 		  Update map entry for a given *KEY*.
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 05b5be4a6ef9..21c676a1eeb1 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -59,6 +59,21 @@ _bpftool_get_map_ids_for_type()
         command sed -n 's/.*"id": \(.*\),$/\1/p' )" -- "$cur" ) )
 }
 
+_bpftool_get_map_names()
+{
+    COMPREPLY+=( $( compgen -W "$( bpftool -jp map  2>&1 | \
+        command sed -n 's/.*"name": \(.*\),$/\1/p' )" -- "$cur" ) )
+}
+
+# Takes map type and adds matching map names to the list of suggestions.
+_bpftool_get_map_names_for_type()
+{
+    local type="$1"
+    COMPREPLY+=( $( compgen -W "$( bpftool -jp map  2>&1 | \
+        command grep -C2 "$type" | \
+        command sed -n 's/.*"name": \(.*\),$/\1/p' )" -- "$cur" ) )
+}
+
 _bpftool_get_prog_ids()
 {
     COMPREPLY+=( $( compgen -W "$( bpftool -jp prog 2>&1 | \
@@ -186,6 +201,52 @@ _bpftool_map_update_get_id()
     esac
 }
 
+_bpftool_map_update_get_name()
+{
+    local command="$1"
+
+    # Is it the map to update, or a map to insert into the map to update?
+    # Search for "value" keyword.
+    local idx value
+    for (( idx=7; idx < ${#words[@]}-1; idx++ )); do
+        if [[ ${words[idx]} == "value" ]]; then
+            value=1
+            break
+        fi
+    done
+    if [[ $value -eq 0 ]]; then
+        case "$command" in
+            push)
+                _bpftool_get_map_names_for_type stack
+                ;;
+            enqueue)
+                _bpftool_get_map_names_for_type queue
+                ;;
+            *)
+                _bpftool_get_map_names
+                ;;
+        esac
+        return 0
+    fi
+
+    # Name to complete is for a value. It can be either prog name or map name. This
+    # depends on the type of the map to update.
+    local type=$(_bpftool_map_guess_map_type)
+    case $type in
+        array_of_maps|hash_of_maps)
+            _bpftool_get_map_names
+            return 0
+            ;;
+        prog_array)
+            _bpftool_get_prog_names
+            return 0
+            ;;
+        *)
+            return 0
+            ;;
+    esac
+}
+
 _bpftool()
 {
     local cur prev words objword
@@ -207,10 +268,6 @@ _bpftool()
             _bpftool_get_prog_tags
             return 0
             ;;
-        name)
-            _bpftool_get_prog_names
-            return 0
-            ;;
         dev)
             _sysfs_get_netdevs
             return 0
@@ -261,7 +318,8 @@ _bpftool()
     # Completion depends on object and command in use
     case $object in
         prog)
-            # Complete id, only for subcommands that use prog (but no map) ids
+            # Complete id and name, only for subcommands that use prog (but no
+            # map) ids/names.
             case $command in
                 show|list|dump|pin)
                     case $prev in
@@ -269,12 +327,16 @@ _bpftool()
                             _bpftool_get_prog_ids
                             return 0
                             ;;
+                        name)
+                            _bpftool_get_prog_names
+                            return 0
+                            ;;
                     esac
                     ;;
             esac
 
             local PROG_TYPE='id pinned tag name'
-            local MAP_TYPE='id pinned'
+            local MAP_TYPE='id pinned name'
             case $command in
                 show|list)
                     [[ $prev != "$command" ]] && return 0
@@ -325,6 +387,9 @@ _bpftool()
                                 id)
                                     _bpftool_get_prog_ids
                                     ;;
+                                name)
+                                    _bpftool_get_map_names
+                                    ;;
                                 pinned)
                                     _filedir
                                     ;;
@@ -345,6 +410,9 @@ _bpftool()
                                 id)
                                     _bpftool_get_map_ids
                                     ;;
+                                name)
+                                    _bpftool_get_map_names
+                                    ;;
                                 pinned)
                                     _filedir
                                     ;;
@@ -409,6 +477,10 @@ _bpftool()
                             _bpftool_get_map_ids
                             return 0
                             ;;
+                        name)
+                            _bpftool_get_map_names
+                            return 0
+                            ;;
                         pinned|pinmaps)
                             _filedir
                             return 0
@@ -457,7 +529,7 @@ _bpftool()
             esac
             ;;
         map)
-            local MAP_TYPE='id pinned'
+            local MAP_TYPE='id pinned name'
             case $command in
                 show|list|dump|peek|pop|dequeue|freeze)
                     case $prev in
@@ -483,6 +555,24 @@ _bpftool()
                             esac
                             return 0
                             ;;
+                        name)
+                            case "$command" in
+                                peek)
+                                    _bpftool_get_map_names_for_type stack
+                                    _bpftool_get_map_names_for_type queue
+                                    ;;
+                                pop)
+                                    _bpftool_get_map_names_for_type stack
+                                    ;;
+                                dequeue)
+                                    _bpftool_get_map_names_for_type queue
+                                    ;;
+                                *)
+                                    _bpftool_get_map_names
+                                    ;;
+                            esac
+                            return 0
+                            ;;
                         *)
                             return 0
                             ;;
@@ -530,6 +620,10 @@ _bpftool()
                             _bpftool_get_map_ids
                             return 0
                             ;;
+                        name)
+                            _bpftool_get_map_names
+                            return 0
+                            ;;
                         key)
                             COMPREPLY+=( $( compgen -W 'hex' -- "$cur" ) )
                             ;;
@@ -555,6 +649,10 @@ _bpftool()
                             _bpftool_map_update_get_id $command
                             return 0
                             ;;
+                        name)
+                            _bpftool_map_update_get_name $command
+                            return 0
+                            ;;
                         key)
                             COMPREPLY+=( $( compgen -W 'hex' -- "$cur" ) )
                             ;;
@@ -563,7 +661,7 @@ _bpftool()
                             # map, depending on the type of the map to update.
                             case "$(_bpftool_map_guess_map_type)" in
                                 array_of_maps|hash_of_maps)
-                                    local MAP_TYPE='id pinned'
+                                    local MAP_TYPE='id pinned name'
                                     COMPREPLY+=( $( compgen -W "$MAP_TYPE" \
                                         -- "$cur" ) )
                                     return 0
@@ -631,6 +729,10 @@ _bpftool()
                             _bpftool_get_map_ids_for_type perf_event_array
                             return 0
                             ;;
+                        name)
+                            _bpftool_get_map_names_for_type perf_event_array
+                            return 0
+                            ;;
                         cpu)
                             return 0
                             ;;
@@ -655,7 +757,7 @@ _bpftool()
             ;;
         btf)
             local PROG_TYPE='id pinned tag name'
-            local MAP_TYPE='id pinned'
+            local MAP_TYPE='id pinned name'
             case $command in
                 dump)
                     case $prev in
@@ -686,6 +788,17 @@ _bpftool()
                             esac
                             return 0
                             ;;
+                        name)
+                            case $pprev in
+                                prog)
+                                    _bpftool_get_prog_names
+                                    ;;
+                                map)
+                                    _bpftool_get_map_names
+                                    ;;
+                            esac
+                            return 0
+                            ;;
                         format)
                             COMPREPLY=( $( compgen -W "c raw" -- "$cur" ) )
                             ;;
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index a7ead7bb9447..81890f4c8cca 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -47,7 +47,7 @@
 	"OPTIONS := { {-j|--json} [{-p|--pretty}] | {-f|--bpffs} |\n"	\
 	"\t            {-m|--mapcompat} | {-n|--nomount} }"
 #define HELP_SPEC_MAP							\
-	"MAP := { id MAP_ID | pinned FILE }"
+	"MAP := { id MAP_ID | pinned FILE | name MAP_NAME }"
 
 static const char * const prog_type_name[] = {
 	[BPF_PROG_TYPE_UNSPEC]			= "unspec",
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index de61d73b9030..c01f76fa6876 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -91,10 +91,66 @@ static void *alloc_value(struct bpf_map_info *info)
 		return malloc(info->value_size);
 }
 
-int map_parse_fd(int *argc, char ***argv)
+static int map_fd_by_name(char *name, int **fds)
 {
-	int fd;
+	unsigned int id = 0;
+	int fd, nb_fds = 0;
+	void *tmp;
+	int err;
+
+	while (true) {
+		struct bpf_map_info info = {};
+		__u32 len = sizeof(info);
+
+		err = bpf_map_get_next_id(id, &id);
+		if (err) {
+			if (errno != ENOENT) {
+				p_err("%s", strerror(errno));
+				goto err_close_fds;
+			}
+			return nb_fds;
+		}
+
+		fd = bpf_map_get_fd_by_id(id);
+		if (fd < 0) {
+			p_err("can't get map by id (%u): %s",
+			      id, strerror(errno));
+			goto err_close_fds;
+		}
+
+		err = bpf_obj_get_info_by_fd(fd, &info, &len);
+		if (err) {
+			p_err("can't get map info (%u): %s",
+			      id, strerror(errno));
+			goto err_close_fd;
+		}
+
+		if (strncmp(name, info.name, BPF_OBJ_NAME_LEN)) {
+			close(fd);
+			continue;
+		}
+
+		if (nb_fds > 0) {
+			tmp = realloc(*fds, (nb_fds + 1) * sizeof(int));
+			if (!tmp) {
+				p_err("failed to realloc");
+				goto err_close_fd;
+			}
+			*fds = tmp;
+		}
+		(*fds)[nb_fds++] = fd;
+	}
+
+err_close_fd:
+	close(fd);
+err_close_fds:
+	while (--nb_fds >= 0)
+		close((*fds)[nb_fds]);
+	return -1;
+}
 
+static int map_parse_fds(int *argc, char ***argv, int **fds)
+{
 	if (is_prefix(**argv, "id")) {
 		unsigned int id;
 		char *endptr;
@@ -108,10 +164,25 @@ int map_parse_fd(int *argc, char ***argv)
 		}
 		NEXT_ARGP();
 
-		fd = bpf_map_get_fd_by_id(id);
-		if (fd < 0)
+		(*fds)[0] = bpf_map_get_fd_by_id(id);
+		if ((*fds)[0] < 0) {
 			p_err("get map by id (%u): %s", id, strerror(errno));
-		return fd;
+			return -1;
+		}
+		return 1;
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
+		return map_fd_by_name(name, fds);
 	} else if (is_prefix(**argv, "pinned")) {
 		char *path;
 
@@ -120,13 +191,43 @@ int map_parse_fd(int *argc, char ***argv)
 		path = **argv;
 		NEXT_ARGP();
 
-		return open_obj_pinned_any(path, BPF_OBJ_MAP);
+		(*fds)[0] = open_obj_pinned_any(path, BPF_OBJ_MAP);
+		if ((*fds)[0] < 0)
+			return -1;
+		return 1;
 	}
 
-	p_err("expected 'id' or 'pinned', got: '%s'?", **argv);
+	p_err("expected 'id', 'name' or 'pinned', got: '%s'?", **argv);
 	return -1;
 }
 
+int map_parse_fd(int *argc, char ***argv)
+{
+	int *fds = NULL;
+	int nb_fds, fd;
+
+	fds = malloc(sizeof(int));
+	if (!fds) {
+		p_err("mem alloc failed");
+		return -1;
+	}
+	nb_fds = map_parse_fds(argc, argv, &fds);
+	if (nb_fds != 1) {
+		if (nb_fds > 1) {
+			p_err("several maps match this handle");
+			while (nb_fds--)
+				close(fds[nb_fds]);
+		}
+		fd = -1;
+		goto exit_free;
+	}
+
+	fd = fds[0];
+exit_free:
+	free(fds);
+	return fd;
+}
+
 int map_parse_fd_and_info(int *argc, char ***argv, void *info, __u32 *info_len)
 {
 	int err;
@@ -479,6 +580,21 @@ static int parse_elem(char **argv, struct bpf_map_info *info,
 	return -1;
 }
 
+static void show_map_header_json(struct bpf_map_info *info, json_writer_t *wtr)
+{
+	jsonw_uint_field(wtr, "id", info->id);
+	if (info->type < ARRAY_SIZE(map_type_name))
+		jsonw_string_field(wtr, "type", map_type_name[info->type]);
+	else
+		jsonw_uint_field(wtr, "type", info->type);
+
+	if (*info->name)
+		jsonw_string_field(wtr, "name", info->name);
+
+	jsonw_name(wtr, "flags");
+	jsonw_printf(wtr, "%d", info->map_flags);
+}
+
 static int show_map_close_json(int fd, struct bpf_map_info *info)
 {
 	char *memlock, *frozen_str;
@@ -489,18 +605,7 @@ static int show_map_close_json(int fd, struct bpf_map_info *info)
 
 	jsonw_start_object(json_wtr);
 
-	jsonw_uint_field(json_wtr, "id", info->id);
-	if (info->type < ARRAY_SIZE(map_type_name))
-		jsonw_string_field(json_wtr, "type",
-				   map_type_name[info->type]);
-	else
-		jsonw_uint_field(json_wtr, "type", info->type);
-
-	if (*info->name)
-		jsonw_string_field(json_wtr, "name", info->name);
-
-	jsonw_name(json_wtr, "flags");
-	jsonw_printf(json_wtr, "%d", info->map_flags);
+	show_map_header_json(info, json_wtr);
 
 	print_dev_json(info->ifindex, info->netns_dev, info->netns_ino);
 
@@ -561,14 +666,8 @@ static int show_map_close_json(int fd, struct bpf_map_info *info)
 	return 0;
 }
 
-static int show_map_close_plain(int fd, struct bpf_map_info *info)
+static void show_map_header_plain(struct bpf_map_info *info)
 {
-	char *memlock, *frozen_str;
-	int frozen = 0;
-
-	memlock = get_fdinfo(fd, "memlock");
-	frozen_str = get_fdinfo(fd, "frozen");
-
 	printf("%u: ", info->id);
 	if (info->type < ARRAY_SIZE(map_type_name))
 		printf("%s  ", map_type_name[info->type]);
@@ -581,6 +680,17 @@ static int show_map_close_plain(int fd, struct bpf_map_info *info)
 	printf("flags 0x%x", info->map_flags);
 	print_dev_plain(info->ifindex, info->netns_dev, info->netns_ino);
 	printf("\n");
+}
+
+static int show_map_close_plain(int fd, struct bpf_map_info *info)
+{
+	char *memlock, *frozen_str;
+	int frozen = 0;
+
+	memlock = get_fdinfo(fd, "memlock");
+	frozen_str = get_fdinfo(fd, "frozen");
+
+	show_map_header_plain(info);
 	printf("\tkey %uB  value %uB  max_entries %u",
 	       info->key_size, info->value_size, info->max_entries);
 
@@ -642,6 +752,50 @@ static int show_map_close_plain(int fd, struct bpf_map_info *info)
 	return 0;
 }
 
+static int do_show_subset(int argc, char **argv)
+{
+	struct bpf_map_info info = {};
+	__u32 len = sizeof(info);
+	int *fds = NULL;
+	int nb_fds, i;
+	int err = -1;
+
+	fds = malloc(sizeof(int));
+	if (!fds) {
+		p_err("mem alloc failed");
+		return -1;
+	}
+	nb_fds = map_parse_fds(&argc, &argv, &fds);
+	if (nb_fds < 1)
+		goto exit_free;
+
+	if (json_output && nb_fds > 1)
+		jsonw_start_array(json_wtr);	/* root array */
+	for (i = 0; i < nb_fds; i++) {
+		err = bpf_obj_get_info_by_fd(fds[i], &info, &len);
+		if (err) {
+			p_err("can't get map info: %s",
+			      strerror(errno));
+			for (; i < nb_fds; i++)
+				close(fds[i]);
+			break;
+		}
+
+		if (json_output)
+			show_map_close_json(fds[i], &info);
+		else
+			show_map_close_plain(fds[i], &info);
+
+		close(fds[i]);
+	}
+	if (json_output && nb_fds > 1)
+		jsonw_end_array(json_wtr);	/* root array */
+
+exit_free:
+	free(fds);
+	return err;
+}
+
 static int do_show(int argc, char **argv)
 {
 	struct bpf_map_info info = {};
@@ -653,16 +807,8 @@ static int do_show(int argc, char **argv)
 	if (show_pinned)
 		build_pinned_obj_table(&map_table, BPF_OBJ_MAP);
 
-	if (argc == 2) {
-		fd = map_parse_fd_and_info(&argc, &argv, &info, &len);
-		if (fd < 0)
-			return -1;
-
-		if (json_output)
-			return show_map_close_json(fd, &info);
-		else
-			return show_map_close_plain(fd, &info);
-	}
+	if (argc == 2)
+		return do_show_subset(argc, argv);
 
 	if (argc)
 		return BAD_ARG();
@@ -765,26 +911,49 @@ static int dump_map_elem(int fd, void *key, void *value,
 	return 0;
 }
 
-static int do_dump(int argc, char **argv)
+static int maps_have_btf(int *fds, int nb_fds)
 {
 	struct bpf_map_info info = {};
-	void *key, *value, *prev_key;
-	unsigned int num_elems = 0;
 	__u32 len = sizeof(info);
-	json_writer_t *btf_wtr;
 	struct btf *btf = NULL;
-	int err;
-	int fd;
+	int err, i;
 
-	if (argc != 2)
-		usage();
+	for (i = 0; i < nb_fds; i++) {
+		err = bpf_obj_get_info_by_fd(fds[i], &info, &len);
+		if (err) {
+			p_err("can't get map info: %s", strerror(errno));
+			goto err_close;
+		}
 
-	fd = map_parse_fd_and_info(&argc, &argv, &info, &len);
-	if (fd < 0)
-		return -1;
+		err = btf__get_from_id(info.btf_id, &btf);
+		if (err) {
+			p_err("failed to get btf");
+			goto err_close;
+		}
 
-	key = malloc(info.key_size);
-	value = alloc_value(&info);
+		if (!btf)
+			return 0;
+	}
+
+	return 1;
+
+err_close:
+	for (; i < nb_fds; i++)
+		close(fds[i]);
+	return -1;
+}
+
+static int
+map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
+	 bool enable_btf, bool show_header)
+{
+	void *key, *value, *prev_key;
+	unsigned int num_elems = 0;
+	struct btf *btf = NULL;
+	int err;
+
+	key = malloc(info->key_size);
+	value = alloc_value(info);
 	if (!key || !value) {
 		p_err("mem alloc failed");
 		err = -1;
@@ -793,30 +962,32 @@ static int do_dump(int argc, char **argv)
 
 	prev_key = NULL;
 
-	err = btf__get_from_id(info.btf_id, &btf);
-	if (err) {
-		p_err("failed to get btf");
-		goto exit_free;
+	if (enable_btf) {
+		err = btf__get_from_id(info->btf_id, &btf);
+		if (err || !btf) {
+			/* enable_btf is true only if we've already checked
+			 * that all maps have BTF information.
+			 */
+			p_err("failed to get btf");
+			goto exit_free;
+		}
 	}
 
-	if (json_output)
-		jsonw_start_array(json_wtr);
-	else
-		if (btf) {
-			btf_wtr = get_btf_writer();
-			if (!btf_wtr) {
-				p_info("failed to create json writer for btf. falling back to plain output");
-				btf__free(btf);
-				btf = NULL;
-			} else {
-				jsonw_start_array(btf_wtr);
-			}
+	if (wtr) {
+		if (show_header) {
+			jsonw_start_object(wtr);	/* map object */
+			show_map_header_json(info, wtr);
+			jsonw_name(wtr, "elements");
 		}
+		jsonw_start_array(wtr);		/* elements */
+	} else if (show_header) {
+		show_map_header_plain(info);
+	}
 
-	if (info.type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY &&
-	    info.value_size != 8)
+	if (info->type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY &&
+	    info->value_size != 8)
 		p_info("Warning: cannot read values from %s map with value_size != 8",
-		       map_type_name[info.type]);
+		       map_type_name[info->type]);
 	while (true) {
 		err = bpf_map_get_next_key(fd, prev_key, key);
 		if (err) {
@@ -824,15 +995,14 @@ static int do_dump(int argc, char **argv)
 				err = 0;
 			break;
 		}
-		num_elems += dump_map_elem(fd, key, value, &info, btf, btf_wtr);
+		num_elems += dump_map_elem(fd, key, value, info, btf, wtr);
 		prev_key = key;
 	}
 
-	if (json_output)
-		jsonw_end_array(json_wtr);
-	else if (btf) {
-		jsonw_end_array(btf_wtr);
-		jsonw_destroy(&btf_wtr);
+	if (wtr) {
+		jsonw_end_array(wtr);	/* elements */
+		if (show_header)
+			jsonw_end_object(wtr);	/* map object */
 	} else {
 		printf("Found %u element%s\n", num_elems,
 		       num_elems != 1 ? "s" : "");
@@ -847,6 +1017,72 @@ static int do_dump(int argc, char **argv)
 	return err;
 }
 
+static int do_dump(int argc, char **argv)
+{
+	json_writer_t *wtr = NULL, *btf_wtr = NULL;
+	struct bpf_map_info info = {};
+	int nb_fds, i = 0, btf = 0;
+	__u32 len = sizeof(info);
+	int *fds = NULL;
+	int err = -1;
+
+	if (argc != 2)
+		usage();
+
+	fds = malloc(sizeof(int));
+	if (!fds) {
+		p_err("mem alloc failed");
+		return -1;
+	}
+	nb_fds = map_parse_fds(&argc, &argv, &fds);
+	if (nb_fds < 1)
+		goto exit_free;
+
+	if (json_output) {
+		wtr = json_wtr;
+	} else {
+		btf = maps_have_btf(fds, nb_fds);
+		if (btf < 0)
+			goto exit_close;
+		if (btf) {
+			btf_wtr = get_btf_writer();
+			if (btf_wtr) {
+				wtr = btf_wtr;
+			} else {
+				p_info("failed to create json writer for btf. falling back to plain output");
+				btf = 0;
+			}
+		}
+	}
+
+	if (wtr && nb_fds > 1)
+		jsonw_start_array(wtr);	/* root array */
+	for (i = 0; i < nb_fds; i++) {
+		if (bpf_obj_get_info_by_fd(fds[i], &info, &len)) {
+			p_err("can't get map info: %s", strerror(errno));
+			break;
+		}
+		err = map_dump(fds[i], &info, wtr, btf, nb_fds > 1);
+		if (!wtr && i != nb_fds - 1)
+			printf("\n");
+
+		if (err)
+			break;
+		close(fds[i]);
+	}
+	if (wtr && nb_fds > 1)
+		jsonw_end_array(wtr);	/* root array */
+
+	if (btf)
+		jsonw_destroy(&btf_wtr);
+exit_close:
+	for (; i < nb_fds; i++)
+		close(fds[i]);
+exit_free:
+	free(fds);
+	return err;
+}
+
 static int alloc_key_value(struct bpf_map_info *info, void **key, void **value)
 {
 	*key = NULL;
-- 
2.24.0

