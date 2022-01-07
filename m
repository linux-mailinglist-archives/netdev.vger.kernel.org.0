Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0682E4879AD
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348084AbiAGP0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239726AbiAGP0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 10:26:31 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C4AC061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 07:26:31 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id i187so6226979qkf.5
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 07:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/zj3W0tYHRMca79NMMjQbR3Tonpv4Z0NoFPxF+2yh1Q=;
        b=bfcp8tyh9QLdBs+tXPr0XYTc35fNVAy0gNl0KEwGot2KOoN7FSObIAz1c5qbGjVKGI
         ymlKB7PXsCxVoomJIcYQpbzRB8yBnFbr69WD8/IU/qeksNPqYfO89oRAuOAWcIO6CPtq
         soSKQzTO4CcM2st1U3oGKGySBGXMqdMq+96mc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/zj3W0tYHRMca79NMMjQbR3Tonpv4Z0NoFPxF+2yh1Q=;
        b=qb+X3zbJU9o4T3q1KM0JOb9dgnMcEg2qCFMcucfeqq8Tzw5HCCCnyovEv41NzyVjGy
         mFCgeSsu+ADuMduNqW8rCLYb8dAHTTdidhPxafYhfis/RUeA5oCOmLch3FDMmLnuucBj
         Bw5En5cBj66ILwwgkUOnvzIdjhNE8KzsP/EnA8Uk9y2KId88Cjvczp4D3Lj9z1bTj8pK
         jIT1lZpqvMcFywwq8qTUt0cHp8twdAeJTtCKVefkX6fFdHKfc5Z34n3DhhXLxbqp0v2s
         j4OokqJh59QlHXCns0q2eiTIfKgW+x0KGpuRV9YjcdVQ2FdaB4HvGhQfLNjO3PkN2Dg7
         7eHg==
X-Gm-Message-State: AOAM5326LlqC0qsqC5J7TPgyNpnaJ0uyJdHpFUfr7Pi84KuzTlzwGeyN
        fBbfW0H4JZ4owd4wIlSFepfG88jEumvyCE7S1KfjWg3J188Iw5LhqEVHEwLDPNrLACzC5et9Oy/
        GDIFcKV0UnxYIdxymcFqS5nHR9szCzerQGp33UVFC9EUDU92bCPpVBbVqtraph6DqKxkx2w==
X-Google-Smtp-Source: ABdhPJw69afziiVG0vkeIxtpeF67TtGHOmLJTsUe9X8Q4JWWMbJc1QSywOOXH7THjTCESx91y38IPw==
X-Received: by 2002:a05:620a:2586:: with SMTP id x6mr42973762qko.15.1641569188099;
        Fri, 07 Jan 2022 07:26:28 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id h9sm3441494qkp.106.2022.01.07.07.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 07:26:27 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 2/2] bpftool: Fix error check when calling hashmap__new()
Date:   Fri,  7 Jan 2022 10:26:20 -0500
Message-Id: <20220107152620.192327-2-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107152620.192327-1-mauricio@kinvolk.io>
References: <20220107152620.192327-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hashmap__new() encodes errors with ERR_PTR(), hence it's not valid to
check the returned pointer against NULL and IS_ERR() has to be used
instead.

libbpf_get_error() can't be used in this case as hashmap__new() is not
part of the public libbpf API and it'll continue using ERR_PTR() after
libbpf 1.0.

Fixes: 8f184732b60b ("bpftool: Switch to libbpf's hashmap for pinned paths of BPF objects")
Fixes: 2828d0d75b73 ("bpftool: Switch to libbpf's hashmap for programs/maps in BTF listing")
Fixes: d6699f8e0f83 ("bpftool: Switch to libbpf's hashmap for PIDs/names references")

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
---
 tools/bpf/bpftool/btf.c  | 2 +-
 tools/bpf/bpftool/link.c | 3 ++-
 tools/bpf/bpftool/map.c  | 2 +-
 tools/bpf/bpftool/pids.c | 3 ++-
 tools/bpf/bpftool/prog.c | 2 +-
 5 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 59833125ac0a..a2c665beda87 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -902,7 +902,7 @@ static int do_show(int argc, char **argv)
 				      equal_fn_for_key_as_id, NULL);
 	btf_map_table = hashmap__new(hash_fn_for_key_as_id,
 				     equal_fn_for_key_as_id, NULL);
-	if (!btf_prog_table || !btf_map_table) {
+	if (IS_ERR(btf_prog_table) || IS_ERR(btf_map_table)) {
 		hashmap__free(btf_prog_table);
 		hashmap__free(btf_map_table);
 		if (fd >= 0)
diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 2c258db0d352..97dec81950e5 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2020 Facebook */
 
 #include <errno.h>
+#include <linux/err.h>
 #include <net/if.h>
 #include <stdio.h>
 #include <unistd.h>
@@ -306,7 +307,7 @@ static int do_show(int argc, char **argv)
 	if (show_pinned) {
 		link_table = hashmap__new(hash_fn_for_key_as_id,
 					  equal_fn_for_key_as_id, NULL);
-		if (!link_table) {
+		if (IS_ERR(link_table)) {
 			p_err("failed to create hashmap for pinned paths");
 			return -1;
 		}
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index cc530a229812..c66a3c979b7a 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -699,7 +699,7 @@ static int do_show(int argc, char **argv)
 	if (show_pinned) {
 		map_table = hashmap__new(hash_fn_for_key_as_id,
 					 equal_fn_for_key_as_id, NULL);
-		if (!map_table) {
+		if (IS_ERR(map_table)) {
 			p_err("failed to create hashmap for pinned paths");
 			return -1;
 		}
diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
index 56b598eee043..7c384d10e95f 100644
--- a/tools/bpf/bpftool/pids.c
+++ b/tools/bpf/bpftool/pids.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 /* Copyright (C) 2020 Facebook */
 #include <errno.h>
+#include <linux/err.h>
 #include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -101,7 +102,7 @@ int build_obj_refs_table(struct hashmap **map, enum bpf_obj_type type)
 	libbpf_print_fn_t default_print;
 
 	*map = hashmap__new(hash_fn_for_key_as_id, equal_fn_for_key_as_id, NULL);
-	if (!*map) {
+	if (IS_ERR(*map)) {
 		p_err("failed to create hashmap for PID references");
 		return -1;
 	}
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 2a21d50516bc..33ca834d5f51 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -641,7 +641,7 @@ static int do_show(int argc, char **argv)
 	if (show_pinned) {
 		prog_table = hashmap__new(hash_fn_for_key_as_id,
 					  equal_fn_for_key_as_id, NULL);
-		if (!prog_table) {
+		if (IS_ERR(prog_table)) {
 			p_err("failed to create hashmap for pinned paths");
 			return -1;
 		}
-- 
2.25.1

