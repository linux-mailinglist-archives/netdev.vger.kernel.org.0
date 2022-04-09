Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153A24FA7E2
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 15:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241824AbiDINCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 09:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241808AbiDINCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 09:02:30 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCD52AC6A;
        Sat,  9 Apr 2022 06:00:21 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id y6so10207411plg.2;
        Sat, 09 Apr 2022 06:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hu/Qk8pU/RtSP5OyEpmAQqQFqcbfnTgoFkZtrMGbO9o=;
        b=bMwrNInyjfvFQ3Acms2Be+var6QhphMrI5DYKCGayNlTMHVidqUQOh4UaLvLDDjGpX
         UVD9x/VPfChiHIBd8kgVCk6KBKlJczTArX0aaDiORXxl/Ymbp7he7IlI2pX5y32L142G
         QaMivrGi73bL/4a5aCTBizBOYhsVKoNpRs11OYmxbdJY9N/uwJlF0SfJHih4856uK9jf
         HWxL62U7o5e7Pgpgk1YgXK5tfZFNX7aZhmGo6LpAPMsICt2k2Tg5UFs9+3WkbrEZFO9C
         UuFky9uS+zSkpsoRVu6YOWq1iJSDr5Lae1XMjkJ47zTuYhGvKEQE0ZOMKUZ6SwPQ6iXE
         aCrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hu/Qk8pU/RtSP5OyEpmAQqQFqcbfnTgoFkZtrMGbO9o=;
        b=rcfFUrd8Zn1GOgE8JTA61yhEUnBtVzMH9Nk9nN6tPo0t8RAmfGaGgmLcwQr481KhVV
         SKx4yV5uaVX0P7a9lxHJ3S2FiJidXEj6i33iPiZMVzPqs6zIxKk0IQTSZtdRojYIDGA6
         2vJhiI1/H8AEbQAMh04hvcZXJAwhM+CMpyn/SBV0325FezY+beenkpMzT/Hjnn9IGGA/
         obt9KNfSP3KoNLCsFCZYi7SJRBsAOPZdUxyR5Qczxs44tIPN+l2MnV9XhXZXFg3GEDr1
         AHoOKxFLphz/tBv30mVl3a7X83AaeirPcGy/EvdQvzKJyG/tT4ku7ozW0znbHG/H4lCu
         lIDA==
X-Gm-Message-State: AOAM531X3JCJxBzivX6s5qGIV+SkUZxtP0k4h6ZUeh1nG1msjXFCFfvy
        ektURNDTqTsPySudrOY5BDw=
X-Google-Smtp-Source: ABdhPJxQ0TPKMg5v3fzhdv0F7YzI7EFdnYV81iNNRCoWIgzAOReXCssd565uGzbp3YL6K2d5/BnXlg==
X-Received: by 2002:a17:903:2312:b0:158:4891:9cc with SMTP id d18-20020a170903231200b00158489109ccmr828480plh.138.1649509215650;
        Sat, 09 Apr 2022 06:00:15 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s10-20020a63a30a000000b003987eaef296sm24671871pge.44.2022.04.09.06.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 06:00:15 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v4 3/4] bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
Date:   Sat,  9 Apr 2022 12:59:57 +0000
Message-Id: <20220409125958.92629-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220409125958.92629-1-laoar.shao@gmail.com>
References: <20220409125958.92629-1-laoar.shao@gmail.com>
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

We have switched to memcg-based memory accouting and thus the rlimit is
not needed any more. LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK was introduced in
libbpf for backward compatibility, so we can use it instead now.

libbpf_set_strict_mode always return 0, so we don't need to check whether
the return value is 0 or not.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/bpf/bpftool/common.c     | 8 --------
 tools/bpf/bpftool/feature.c    | 2 --
 tools/bpf/bpftool/main.c       | 6 +++---
 tools/bpf/bpftool/main.h       | 2 --
 tools/bpf/bpftool/map.c        | 2 --
 tools/bpf/bpftool/pids.c       | 1 -
 tools/bpf/bpftool/prog.c       | 3 ---
 tools/bpf/bpftool/struct_ops.c | 2 --
 8 files changed, 3 insertions(+), 23 deletions(-)

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
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index e81227761f5d..9062ef2b8767 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -507,9 +507,9 @@ int main(int argc, char **argv)
 		 * It will still be rejected if users use LIBBPF_STRICT_ALL
 		 * mode for loading generated skeleton.
 		 */
-		ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS);
-		if (ret)
-			p_err("failed to enable libbpf strict mode: %d", ret);
+		libbpf_set_strict_mode(LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS);
+	} else {
+		libbpf_set_strict_mode(LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK);
 	}
 
 	argc -= optind;
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

