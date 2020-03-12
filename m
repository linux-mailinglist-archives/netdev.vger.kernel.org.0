Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAC2183898
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgCLS0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:26:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32920 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbgCLS0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:26:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id a25so8803030wrd.0
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KIhZ0tVM9yZO9gvswOz7Wk6QPkMWOulH19S5SPkuvfw=;
        b=n4pS0PRXdQdpMIexENXZcbAGcpVBpTAEgPxlHvaATYeh8ffKmEVMkttW6OIcTFNVSP
         84hoKxARrHMyCkEZrbauqKHa7GBFcCpAsWgoxHO0LZzOUOJ9gyrzXfGUUfu6lYxEwPZC
         P3ufVo8i/OCpPUw0IF4Po91UoJzEkxs1yEyqUW06L9qfY+TrESIy5Ap+E6JeRH/V3Dz2
         CvYDY2kOmPDw04pU77XJqBiEgjyJaHvhvZHKYlfz9uKHgFMH65k8+L8WZOqMQTmtHSWb
         Fcwgxks/YGOadS/P9VPF6CXJRxDUrw4qYVdUdDCoMIHccTs4pvORSJuAa47siPkzZW90
         JWFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KIhZ0tVM9yZO9gvswOz7Wk6QPkMWOulH19S5SPkuvfw=;
        b=HMCkDIMvVYWjbSbKEpDVUWVrqi6AQ2SYMOXfdHD/K4crR1q8p1i5UtVXvKmvuKrckO
         87Twa8W8e2QI6g4yqBc+XKuLcKDCpzLEfjvUQZNYcEeOHUtZPaRjTBcC+uzxmnmOxxx2
         RNFqCHEICLJFLU18shIZfaTYtGdIekVcHtIwfCBOviLNbR6d2Be8OeYb0I8yQ3rzvqCP
         ZmDxZvkQHIkWsrA/8fIFgZ6nc7ZYe9IPlNAreiVHR8SHQUdyctuEnVcICWZIei20ig7A
         Q8iJxsHl2rMmV1Ux9yUwiMJJ4Y4tBE99QpYo/bbZJusxmLnHb3gypVj0jKOE3u4FUV5T
         xGbQ==
X-Gm-Message-State: ANhLgQ3bU4FI4fL+NWS9EApvEd6xk7yHQ9ts/n9sxzhjOd3OHdClVPsy
        6BM6BP/H0u7cGJ0kKBu7yEeZ/oPq/Mk=
X-Google-Smtp-Source: ADFU+vu12LETaaO5MyFn9/1C4zI9XB72gB2ln1fGcttGD2OyAJP31lVhcOxQCnD92HgJXVjKRvgcLA==
X-Received: by 2002:adf:ea02:: with SMTP id q2mr12180374wrm.222.1584037565216;
        Thu, 12 Mar 2020 11:26:05 -0700 (PDT)
Received: from localhost.localdomain ([194.35.118.177])
        by smtp.gmail.com with ESMTPSA id r9sm6379134wma.47.2020.03.12.11.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 11:26:04 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 1/2] tools: bpftool: allow all prog/map handles for pinning objects
Date:   Thu, 12 Mar 2020 18:25:54 +0000
Message-Id: <20200312182555.945-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312182555.945-1-quentin@isovalent.com>
References: <20200312182555.945-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation and interactive help for bpftool have always explained
that the regular handles for programs (id|name|tag|pinned) and maps
(id|name|pinned) can be passed to the utility when attempting to pin
objects (bpftool prog pin PROG / bpftool map pin MAP).

THIS IS A LIE!! The tool actually accepts only ids, as the parsing is
done in do_pin_any() in common.c instead of reusing the parsing
functions that have long been generic for program and map handles.

Instead of fixing the doc, fix the code. It is trivial to reuse the
generic parsing, and to simplify do_pin_any() in the process.

Do not accept to pin multiple objects at the same time with
prog_parse_fds() or map_parse_fds() (this would require a more complex
syntax for passing multiple sysfs paths and validating that they
correspond to the number of e.g. programs we find for a given name or
tag).

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/common.c | 39 +++++---------------------------------
 tools/bpf/bpftool/main.h   |  2 +-
 tools/bpf/bpftool/map.c    |  2 +-
 tools/bpf/bpftool/prog.c   |  2 +-
 4 files changed, 8 insertions(+), 37 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index b75b8ec5469c..92e51a62bd72 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -211,44 +211,15 @@ int do_pin_fd(int fd, const char *name)
 	return err;
 }
 
-int do_pin_any(int argc, char **argv, int (*get_fd_by_id)(__u32))
+int do_pin_any(int argc, char **argv, int (*get_fd)(int *, char ***))
 {
-	unsigned int id;
-	char *endptr;
-	int err;
 	int fd;
 
-	if (argc < 3) {
-		p_err("too few arguments, id ID and FILE path is required");
-		return -1;
-	} else if (argc > 3) {
-		p_err("too many arguments");
-		return -1;
-	}
-
-	if (!is_prefix(*argv, "id")) {
-		p_err("expected 'id' got %s", *argv);
-		return -1;
-	}
-	NEXT_ARG();
-
-	id = strtoul(*argv, &endptr, 0);
-	if (*endptr) {
-		p_err("can't parse %s as ID", *argv);
-		return -1;
-	}
-	NEXT_ARG();
-
-	fd = get_fd_by_id(id);
-	if (fd < 0) {
-		p_err("can't open object by id (%u): %s", id, strerror(errno));
-		return -1;
-	}
-
-	err = do_pin_fd(fd, *argv);
+	fd = get_fd(&argc, &argv);
+	if (fd < 0)
+		return fd;
 
-	close(fd);
-	return err;
+	return do_pin_fd(fd, *argv);
 }
 
 const char *get_fd_type_name(enum bpf_obj_type type)
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 724ef9d941d3..d57972dd0f2b 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -146,7 +146,7 @@ char *get_fdinfo(int fd, const char *key);
 int open_obj_pinned(char *path, bool quiet);
 int open_obj_pinned_any(char *path, enum bpf_obj_type exp_type);
 int mount_bpffs_for_pin(const char *name);
-int do_pin_any(int argc, char **argv, int (*get_fd_by_id)(__u32));
+int do_pin_any(int argc, char **argv, int (*get_fd_by_id)(int *, char ***));
 int do_pin_fd(int fd, const char *name);
 
 int do_prog(int argc, char **arg);
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index e6c85680b34d..693a632f6813 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -1384,7 +1384,7 @@ static int do_pin(int argc, char **argv)
 {
 	int err;
 
-	err = do_pin_any(argc, argv, bpf_map_get_fd_by_id);
+	err = do_pin_any(argc, argv, map_parse_fd);
 	if (!err && json_output)
 		jsonw_null(json_wtr);
 	return err;
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 576ddd82bc96..6e3d69f06b60 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -813,7 +813,7 @@ static int do_pin(int argc, char **argv)
 {
 	int err;
 
-	err = do_pin_any(argc, argv, bpf_prog_get_fd_by_id);
+	err = do_pin_any(argc, argv, prog_parse_fd);
 	if (!err && json_output)
 		jsonw_null(json_wtr);
 	return err;
-- 
2.20.1

