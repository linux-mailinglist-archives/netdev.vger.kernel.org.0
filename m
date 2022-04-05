Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237F34F4002
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387213AbiDEOar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344603AbiDEOXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:23:34 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054216E57D;
        Tue,  5 Apr 2022 06:09:51 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id bo5so12049081pfb.4;
        Tue, 05 Apr 2022 06:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=viexwUu6gnOnfIlYwhyzP+WSqVfYyHd1EwzTfJFHZY4=;
        b=nPPziC8khx4ZMAODfwzHa85gBNwjsRXugR8TTtPF7f9QdLZj1Jizd0gjzQy6hSsoiu
         NRwWLXwd7njSn+2RzIapMw4pHcMonOfxa+AQOy8lXvp+iq3q4mDIgDdWxg+5CiRRfW9m
         j1u+wj2YNdMZR5nXCLtEoYCX/fdsm4ff9A4eWFFvVYP5BZl9CweGg9hzFm6zvWHpGGsd
         LCYnkFUNOzz/IuXJ/eMmAZIyRhv8dK91TmTLEorB8u+VtMcsJZVauuOBQiZl37Ai4Q7R
         3I8cRtWJpBHTuh3YjVq1e+seAqhiAYG41k/6eTSRm3nJiOx0+IkJTpE0y61J+6XjAUAG
         njXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=viexwUu6gnOnfIlYwhyzP+WSqVfYyHd1EwzTfJFHZY4=;
        b=J0wtzGtlDji3Zjt2Oe4aheW2tdkq2M+BQGAaehTP7DBWSlNaAxtDzoYzXiMoi7wRdH
         2vdrKcWvLjSIH3OoVvxpW3RdzTYkEZZ1xI193FzlKDRUO83+CPzAGaNNFnmPZ33rKJCP
         fnM6Gi+hgQwGVHEx5YhPY32L2437n6i746MQ48dd3odzJXGzSQJZS8jHTIGLRGgatj3a
         GMzXabt94XBpVCVCZPsKv83oeheYLnC7hg6qLWD3Le/hWdaCIczKNMXiZaVVbWBbWbtR
         bKmz1ZZwU7yjYE6C+9TKWKNn3hKNFR5hj2aryOwNt3qDPa+5MJJiOq/xyTRw/LL//XRf
         h8zA==
X-Gm-Message-State: AOAM533RGVTjWPT1JFAjT14io9SeJQQ5tplpMS4I/qHI4MUxb2lLwoqC
        iyjiGKRlDM/UJ61joQlFYIc=
X-Google-Smtp-Source: ABdhPJzz8Z80hgaw7IgYqAslbwHdj0QKDlGnoyg4O/lXKfpHYZ2L2hSGuBJL27+FCuzrgHcdhuQrrQ==
X-Received: by 2002:a65:6951:0:b0:381:f10:ccaa with SMTP id w17-20020a656951000000b003810f10ccaamr2723596pgq.587.1649164190512;
        Tue, 05 Apr 2022 06:09:50 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:50 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 26/27] bpf: bpftool: remove RLIMIT_MEMLOCK
Date:   Tue,  5 Apr 2022 13:08:57 +0000
Message-Id: <20220405130858.12165-27-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220405130858.12165-1-laoar.shao@gmail.com>
References: <20220405130858.12165-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we have already set LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK, we don't need to
bump RLIMIT_MEMLOCK any more.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/bpf/bpftool/common.c     | 8 --------
 tools/bpf/bpftool/feature.c    | 2 --
 tools/bpf/bpftool/main.h       | 2 --
 tools/bpf/bpftool/map.c        | 2 --
 tools/bpf/bpftool/pids.c       | 1 -
 tools/bpf/bpftool/prog.c       | 3 ---
 tools/bpf/bpftool/struct_ops.c | 2 --
 7 files changed, 20 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 0c1e06cf50b9..c740142c24d8 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -17,7 +17,6 @@
 #include <linux/magic.h>
 #include <net/if.h>
 #include <sys/mount.h>
-#include <sys/resource.h>
 #include <sys/stat.h>
 #include <sys/vfs.h>
 
@@ -119,13 +118,6 @@ static bool is_bpffs(char *path)
 	return (unsigned long)st_fs.f_type == BPF_FS_MAGIC;
 }
 
-void set_max_rlimit(void)
-{
-	struct rlimit rinf = { RLIM_INFINITY, RLIM_INFINITY };
-
-	setrlimit(RLIMIT_MEMLOCK, &rinf);
-}
-
 static int
 mnt_fs(const char *target, const char *type, char *buff, size_t bufflen)
 {
diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index f041c4a6a1f2..be130e35462f 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -1136,8 +1136,6 @@ static int do_probe(int argc, char **argv)
 	__u32 ifindex = 0;
 	char *ifname;
 
-	set_max_rlimit();
-
 	while (argc) {
 		if (is_prefix(*argv, "kernel")) {
 			if (target != COMPONENT_UNSPEC) {
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 6e9277ffc68c..aa99ffab451a 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -102,8 +102,6 @@ int detect_common_prefix(const char *arg, ...);
 void fprint_hex(FILE *f, void *arg, unsigned int n, const char *sep);
 void usage(void) __noreturn;
 
-void set_max_rlimit(void);
-
 int mount_tracefs(const char *target);
 
 struct obj_ref {
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index c26378f20831..877387ef79c7 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -1342,8 +1342,6 @@ static int do_create(int argc, char **argv)
 		goto exit;
 	}
 
-	set_max_rlimit();
-
 	fd = bpf_map_create(map_type, map_name, key_size, value_size, max_entries, &attr);
 	if (fd < 0) {
 		p_err("map create failed: %s", strerror(errno));
diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
index bb6c969a114a..e2d00d3cd868 100644
--- a/tools/bpf/bpftool/pids.c
+++ b/tools/bpf/bpftool/pids.c
@@ -108,7 +108,6 @@ int build_obj_refs_table(struct hashmap **map, enum bpf_obj_type type)
 		p_err("failed to create hashmap for PID references");
 		return -1;
 	}
-	set_max_rlimit();
 
 	skel = pid_iter_bpf__open();
 	if (!skel) {
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 8643b37d4e43..5c2c63df92e8 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1604,8 +1604,6 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 		}
 	}
 
-	set_max_rlimit();
-
 	if (verifier_logs)
 		/* log_level1 + log_level2 + stats, but not stable UAPI */
 		open_opts.kernel_log_level = 1 + 2 + 4;
@@ -2303,7 +2301,6 @@ static int do_profile(int argc, char **argv)
 		}
 	}
 
-	set_max_rlimit();
 	err = profiler_bpf__load(profile_obj);
 	if (err) {
 		p_err("failed to load profile_obj");
diff --git a/tools/bpf/bpftool/struct_ops.c b/tools/bpf/bpftool/struct_ops.c
index e08a6ff2866c..2535f079ed67 100644
--- a/tools/bpf/bpftool/struct_ops.c
+++ b/tools/bpf/bpftool/struct_ops.c
@@ -501,8 +501,6 @@ static int do_register(int argc, char **argv)
 	if (libbpf_get_error(obj))
 		return -1;
 
-	set_max_rlimit();
-
 	if (bpf_object__load(obj)) {
 		bpf_object__close(obj);
 		return -1;
-- 
2.17.1

