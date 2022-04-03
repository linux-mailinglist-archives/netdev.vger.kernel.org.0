Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F1D4F0A53
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 16:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359078AbiDCOpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 10:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359066AbiDCOpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 10:45:13 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386063388D;
        Sun,  3 Apr 2022 07:43:20 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y10so6682514pfa.7;
        Sun, 03 Apr 2022 07:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WSiOa7a2+6arsE8Kmiwhve3HvAwmlZuKMpROItnSNl8=;
        b=W3793xmTSpKlfp98wRoQUpjy+9NUO+i++6tMx2Tx3mtUHEnT/uURSD2tsZy5OTffkB
         DusF3ye0oSQLRn5y1PMWaKe+p0L+HR061su2LaMWQH3xboblxP49maWjnMGlYg8oagjx
         s2+h7xrRPKZsQPZEIVfrMTnd++jrl7Zge67KrwqpRyjw5X5YjAFeUs8tUasKQreldEuY
         SJlxsZSWVHdJeL8jvYv+gCXPf9EsfuiEH7xa5b4izjgWSawhXgUU6HcZ0wrQu4x5y15G
         +CufNixj2yna+y+ktqQm38plIbEP8UZ1uZwN/nMWOIOz4dNB4KRwJuIszvkGTI9LMoTO
         wiPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WSiOa7a2+6arsE8Kmiwhve3HvAwmlZuKMpROItnSNl8=;
        b=p9MbdUPQHikDjeVi68A2RNAiBzT5NMdNxT2ZM2Bk9Y4nwHhCeJHT/WiTpNVckoRLwq
         ASMSsqiRlhrKEmhmU9BrrFjqhlB0OdkoWcq/aQpN4lSR4oFjIpSkHy3cEJbv4BR7p2+1
         sL/084Am+8IhTyhH+Fn3U9SShirYccxY/gl2NG5GjoeGP2UGj2J0d1BFha2JtIuaxCIp
         PEqkX9YY1vksTqbTBfkegiBxTqDQGoO+4V929IL0GiW3FKVyg1vhI5kFwz4lX72f1Po8
         o4Jy2otv48nkuVytcWkb6xo6XSjETNjp/VNj6hrvNd2sNQSAzxCftLHd8/6zTxe/Ha0u
         X+aw==
X-Gm-Message-State: AOAM531VNT767VeCASyfjMARZDLxAVMjxd01fI5cDdG4sVojeNKDUHmt
        G9OqvGOjVLMz9p7aSSiFl2Y=
X-Google-Smtp-Source: ABdhPJxPiaWNrR1RLL8662JvlVJe4BoIw34MBChcU/D4sc7OcrQ/NO+LcgJ0S00wmq/q16Sls70Tqg==
X-Received: by 2002:a63:3489:0:b0:398:7008:bb25 with SMTP id b131-20020a633489000000b003987008bb25mr22272671pga.242.1648996999692;
        Sun, 03 Apr 2022 07:43:19 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:51a7:5400:3ff:feee:9f61])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm9464910pfl.44.2022.04.03.07.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 07:43:19 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v2 9/9] bpf: bpftool: Remove useless rlimit setting
Date:   Sun,  3 Apr 2022 14:43:00 +0000
Message-Id: <20220403144300.6707-10-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220403144300.6707-1-laoar.shao@gmail.com>
References: <20220403144300.6707-1-laoar.shao@gmail.com>
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
 tools/bpf/bpftool/common.c     | 7 -------
 tools/bpf/bpftool/feature.c    | 2 --
 tools/bpf/bpftool/main.h       | 2 --
 tools/bpf/bpftool/map.c        | 2 --
 tools/bpf/bpftool/pids.c       | 1 -
 tools/bpf/bpftool/prog.c       | 3 ---
 tools/bpf/bpftool/struct_ops.c | 2 --
 7 files changed, 19 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 0c1e06cf50b9..6b1e67851690 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -119,13 +119,6 @@ static bool is_bpffs(char *path)
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
index 290998c82de1..19c484e63da4 100644
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
index bc4e05542c2b..d5ba3b6f30ae 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1603,8 +1603,6 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 		}
 	}
 
-	set_max_rlimit();
-
 	if (verifier_logs)
 		/* log_level1 + log_level2 + stats, but not stable UAPI */
 		open_opts.kernel_log_level = 1 + 2 + 4;
@@ -2302,7 +2300,6 @@ static int do_profile(int argc, char **argv)
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

