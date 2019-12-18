Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5668A124967
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfLROXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:23:52 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33524 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfLROXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 09:23:51 -0500
Received: by mail-wr1-f67.google.com with SMTP id b6so2528171wrq.0;
        Wed, 18 Dec 2019 06:23:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qmE71Trq36jHx4Xg3DkVQdACDKp8yxbFOBYUuZJd0+0=;
        b=SuJoKzzy4FAV1HhaVwWY0lxgBiC4RYvRuU2IxGHNGpC6dlVwaMiL/A90hpPM/IfyEa
         iD7tjxdJMzYY74VJ8RNkmtG0IkVytU/45W1bCqWjyVl3IeOLgVr4W8dOiRrVqGqTR2/I
         hHmbJ7wEOS1XuqBsjmvDks/ITaCzPcmcMsySYYRn2HJTWTrX9oZjMrLjr8vktuCrjwko
         6J6LDylivWN/4c2ufEkXTw0BpvqrioH9/HS2RH3M1g4Xxk7Ruyvh0dJnG1TmVZdS3Gvi
         Xs+UD2gxFhl60DTuCBA3M44efeEoMHXNK+l3o5aOMYyPXF3zGhxdGw4/z6+Svt67+zBV
         7J5A==
X-Gm-Message-State: APjAAAVOKXvmTHhfgURPFcmRNZiR6GS8pYSVkjuXdQyWV5g/rTksKM5H
        Tdfe5mA/kR5a8OaNkpkLh40=
X-Google-Smtp-Source: APXvYqwUjJgkCyOeuFc/yaSnZME/ZmeiCCPVMIyCnYHk45cIOibOv7j/ifQiWL4Y5wJ8789jozAzfA==
X-Received: by 2002:a5d:4807:: with SMTP id l7mr3308415wrq.64.1576679028754;
        Wed, 18 Dec 2019 06:23:48 -0800 (PST)
Received: from Omicron ([217.76.31.1])
        by smtp.gmail.com with ESMTPSA id w13sm2778926wru.38.2019.12.18.06.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 06:23:47 -0800 (PST)
Date:   Wed, 18 Dec 2019 15:23:47 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     bpf@vger.kernel.org
Cc:     paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next 3/3] bpftool: Support single-cpu updates for per-cpu
 maps
Message-ID: <7adf11a446e02080d84eb4c7152078d1912a5454.1576673843.git.paul.chaignon@orange.com>
References: <cover.1576673841.git.paul.chaignon@orange.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1576673841.git.paul.chaignon@orange.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the new BPF_CPU flag in bpftool, to enable
single-cpu updates of per-cpu maps.  It can be combined with existing
flags; for example, to update the value for key 0 on CPU 9 only if it
doesn't already exist:

  bpftool map update key 0 0 0 0 value 1 0 0 0 noexist cpu 9

Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
---
 .../bpf/bpftool/Documentation/bpftool-map.rst | 13 ++--
 tools/bpf/bpftool/bash-completion/bpftool     |  2 +-
 tools/bpf/bpftool/map.c                       | 70 ++++++++++++++-----
 3 files changed, 61 insertions(+), 24 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index cdeae8ae90ba..72aa9b72f08f 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -25,7 +25,7 @@ MAP COMMANDS
 |	**bpftool** **map create**     *FILE* **type** *TYPE* **key** *KEY_SIZE* **value** *VALUE_SIZE* \
 |		**entries** *MAX_ENTRIES* **name** *NAME* [**flags** *FLAGS*] [**dev** *NAME*]
 |	**bpftool** **map dump**       *MAP*
-|	**bpftool** **map update**     *MAP* [**key** *DATA*] [**value** *VALUE*] [*UPDATE_FLAGS*]
+|	**bpftool** **map update**     *MAP* [**key** *DATA*] [**value** *VALUE*] [*UPDATE_FLAGS*]...
 |	**bpftool** **map lookup**     *MAP* [**key** *DATA*]
 |	**bpftool** **map getnext**    *MAP* [**key** *DATA*]
 |	**bpftool** **map delete**     *MAP*  **key** *DATA*
@@ -43,7 +43,7 @@ MAP COMMANDS
 |	*DATA* := { [**hex**] *BYTES* }
 |	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* | **name** *PROG_NAME* }
 |	*VALUE* := { *DATA* | *MAP* | *PROG* }
-|	*UPDATE_FLAGS* := { **any** | **exist** | **noexist** }
+|	*UPDATE_FLAGS* := { **any** | **exist** | **noexist** | **cpu** *CPU_ID* }
 |	*TYPE* := { **hash** | **array** | **prog_array** | **perf_event_array** | **percpu_hash**
 |		| **percpu_array** | **stack_trace** | **cgroup_array** | **lru_hash**
 |		| **lru_percpu_hash** | **lpm_trie** | **array_of_maps** | **hash_of_maps**
@@ -73,9 +73,12 @@ DESCRIPTION
 	**bpftool map update**  *MAP* [**key** *DATA*] [**value** *VALUE*] [*UPDATE_FLAGS*]
 		  Update map entry for a given *KEY*.
 
-		  *UPDATE_FLAGS* can be one of: **any** update existing entry
-		  or add if doesn't exit; **exist** update only if entry already
-		  exists; **noexist** update only if entry doesn't exist.
+		  *UPDATE_FLAGS* can be: **any** update existing entry or add
+		  if doesn't exit; **exist** update only if entry already
+		  exists; **noexist** update only if entry doesn't exist;
+		  **cpu** update only value for given *CPU_ID* in per-CPU map.
+		  Only one of **any**, **exist**, and **noexist** can be
+		  specified.
 
 		  If the **hex** keyword is provided in front of the bytes
 		  sequence, the bytes are parsed as hexadeximal values, even if
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 754d8395e451..116bf3dffb47 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -689,7 +689,7 @@ _bpftool()
                             esac
 
                             _bpftool_once_attr 'key'
-                            local UPDATE_FLAGS='any exist noexist'
+                            local UPDATE_FLAGS='any exist noexist cpu'
                             for (( idx=3; idx < ${#words[@]}-1; idx++ )); do
                                 if [[ ${words[idx]} == 'value' ]]; then
                                     # 'value' is present, but is not the last
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index c01f76fa6876..da1455f460b1 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -470,9 +470,10 @@ static void fill_per_cpu_value(struct bpf_map_info *info, void *value)
 		memcpy(value + i * step, value, info->value_size);
 }
 
-static int parse_elem(char **argv, struct bpf_map_info *info,
-		      void *key, void *value, __u32 key_size, __u32 value_size,
-		      __u32 *flags, __u32 **value_fd)
+static int
+__parse_elem(char **argv, struct bpf_map_info *info, void *key, void *value,
+	     __u32 key_size, __u32 value_size, __u64 *flags, __u32 **value_fd,
+	     bool any_flag)
 {
 	if (!*argv) {
 		if (!key && !value)
@@ -494,8 +495,8 @@ static int parse_elem(char **argv, struct bpf_map_info *info,
 		if (!argv)
 			return -1;
 
-		return parse_elem(argv, info, NULL, value, key_size, value_size,
-				  flags, value_fd);
+		return __parse_elem(argv, info, NULL, value, key_size,
+				    value_size, flags, value_fd, any_flag);
 	} else if (is_prefix(*argv, "value")) {
 		int fd;
 
@@ -556,30 +557,63 @@ static int parse_elem(char **argv, struct bpf_map_info *info,
 			fill_per_cpu_value(info, value);
 		}
 
-		return parse_elem(argv, info, key, NULL, key_size, value_size,
-				  flags, NULL);
+		return __parse_elem(argv, info, key, NULL, key_size,
+				    value_size, flags, NULL, any_flag);
 	} else if (is_prefix(*argv, "any") || is_prefix(*argv, "noexist") ||
 		   is_prefix(*argv, "exist")) {
-		if (!flags) {
+		if (any_flag || *flags & (BPF_NOEXIST | BPF_EXIST)) {
 			p_err("flags specified multiple times: %s", *argv);
 			return -1;
 		}
 
-		if (is_prefix(*argv, "any"))
-			*flags = BPF_ANY;
-		else if (is_prefix(*argv, "noexist"))
-			*flags = BPF_NOEXIST;
-		else if (is_prefix(*argv, "exist"))
-			*flags = BPF_EXIST;
+		if (is_prefix(*argv, "any")) {
+			*flags |= BPF_ANY;
+			any_flag = true;
+		} else if (is_prefix(*argv, "noexist")) {
+			*flags |= BPF_NOEXIST;
+		} else if (is_prefix(*argv, "exist")) {
+			*flags |= BPF_EXIST;
+		}
+
+		return __parse_elem(argv + 1, info, key, value, key_size,
+				    value_size, flags, value_fd, any_flag);
+	} else if (is_prefix(*argv, "cpu")) {
+		unsigned long long cpuid;
+		char *endptr;
+
+		if (*flags & BPF_CPU) {
+			p_err("flags specified multiple times: %s", *argv);
+			return -1;
+		}
 
-		return parse_elem(argv + 1, info, key, value, key_size,
-				  value_size, NULL, value_fd);
+		cpuid = strtoull(*(argv + 1), &endptr, 0);
+		if (*endptr) {
+			p_err("can't parse CPU id %s", *(argv + 1));
+			return -1;
+		}
+		if (cpuid >= get_possible_cpus()) {
+			p_err("incorrect value for CPU id");
+			return -1;
+		}
+
+		*flags |= (cpuid << 32) | BPF_CPU;
+
+		return __parse_elem(argv + 2, info, key, value, key_size,
+				    value_size, flags, value_fd, any_flag);
 	}
 
 	p_err("expected key or value, got: %s", *argv);
 	return -1;
 }
 
+static int
+parse_elem(char **argv, struct bpf_map_info *info, void *key, void *value,
+	   __u32 key_size, __u32 value_size, __u64 *flags, __u32 **value_fd)
+{
+	return __parse_elem(argv, info, key, value, key_size, value_size,
+			    flags, value_fd, false);
+}
+
 static void show_map_header_json(struct bpf_map_info *info, json_writer_t *wtr)
 {
 	jsonw_uint_field(wtr, "id", info->id);
@@ -1114,7 +1148,7 @@ static int do_update(int argc, char **argv)
 	struct bpf_map_info info = {};
 	__u32 len = sizeof(info);
 	__u32 *value_fd = NULL;
-	__u32 flags = BPF_ANY;
+	__u64 flags = BPF_ANY;
 	void *key, *value;
 	int fd, err;
 
@@ -1558,7 +1592,7 @@ static int do_help(int argc, char **argv)
 		"       DATA := { [hex] BYTES }\n"
 		"       " HELP_SPEC_PROGRAM "\n"
 		"       VALUE := { DATA | MAP | PROG }\n"
-		"       UPDATE_FLAGS := { any | exist | noexist }\n"
+		"       UPDATE_FLAGS := { any | exist | noexist | cpu CPU_ID }\n"
 		"       TYPE := { hash | array | prog_array | perf_event_array | percpu_hash |\n"
 		"                 percpu_array | stack_trace | cgroup_array | lru_hash |\n"
 		"                 lru_percpu_hash | lpm_trie | array_of_maps | hash_of_maps |\n"
-- 
2.24.0

