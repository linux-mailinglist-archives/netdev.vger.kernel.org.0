Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F5A4293EC
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 17:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239263AbhJKP6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 11:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239185AbhJKP6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 11:58:45 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222B8C061745
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:56:45 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i83-20020a256d56000000b005b706d1417bso23725278ybc.6
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1fprwygtfcbW4YsIOZabVxvRcnD8jzC8e3Grk+JtWJM=;
        b=acHksIX1r/8ym8r3mcUiAHJiG/aB1WLWYBa1rzH8qotA6iltqOeIW352rDjzhVcPeu
         sK72tkrbKEOLuc08Gm3GrlCIujGN6EiKEaCiKTjDtPFu7IEfm1Bwo1QFH8jCfi2Q0GbS
         Ehpal5CP3TBxS+fpO8MoH2BFGQnWz+vd84a+nOFiQC2YWlX8MZnu4WDU9EZq2r3DJHqe
         98ccUIZGYmHjOevvyZtXiUOmTSRjxgqDnn7du3Z6w9Z+rIB5y/F2M1i5LzU9FfZokS//
         wbsyzP/60eE0SlgFda0PowblhM+xHRN2yj6JgSOMNSrHEMICqGvnfSRqFhPg86gJtJ0f
         ceEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1fprwygtfcbW4YsIOZabVxvRcnD8jzC8e3Grk+JtWJM=;
        b=COBSM2eErsKToagT4CFwhGIMCa/HIoYgUY8Hf98qxiPd692S7VZtoMBwlRhDuCKh8A
         +zrJO1/hr3k0vBijrUrNj61GAeujHh57JulLFQAQQ/rLHxq5SL+M+g+w/oOoJ1nlT+2Q
         EPpxd+vFOrHS8uZ6n1KhQ4hyIpN3Kh7y4MfkbV5FDkHOyP04OTFe3HMV/zchFimHv9CD
         1YGSgnSLRT2A1UtIyzGNiVkJ/+FRHdAYiW7q6vZoHluUbt4mZsK0DEAO00TwFj04v1WF
         C/3SaQu91bpELwyV/07yusn9qSDPLpq8DpoJ9I8Pwq+djg2w8DPahh2Z1W/UA45Mlpcq
         OP6Q==
X-Gm-Message-State: AOAM531p5ZEV3peo10tSzN9dXRddQhTjz6LMLAdz9xaBjVoCbeeUmIKR
        vtK6Z053JV0ogJI5wVZx9FYyUrcRIsDPmo9oreuMMuzpVy67h9xWbb/NEoddtWvrAU9+VKCihO7
        g6CrJnByKfBdjniWTkRV/RbvlDNfNU58cHP/EubZAKsLBkCEaYkq0yg==
X-Google-Smtp-Source: ABdhPJx5e1GqC9IWMQH/lXACJKPoqNtS1nirnDoyePiBKancAXAZmoNUWaSCHdAvS4LU+Jrlo65xKkI=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:8bf5:656e:8f83:7b2d])
 (user=sdf job=sendgmr) by 2002:a25:90b:: with SMTP id 11mr21962569ybj.192.1633967804302;
 Mon, 11 Oct 2021 08:56:44 -0700 (PDT)
Date:   Mon, 11 Oct 2021 08:56:36 -0700
In-Reply-To: <20211011155636.2666408-1-sdf@google.com>
Message-Id: <20211011155636.2666408-3-sdf@google.com>
Mime-Version: 1.0
References: <20211011155636.2666408-1-sdf@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH bpf-next 3/3] selftests/bpf: fix flow dissector tests
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- update custom loader to search by name, not section name
- update bpftool commands to use proper pin path

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/flow_dissector_load.c        | 18 +++++++++++-------
 .../selftests/bpf/flow_dissector_load.h        | 10 ++--------
 .../selftests/bpf/test_flow_dissector.sh       | 10 +++++-----
 3 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/flow_dissector_load.c b/tools/testing/selftests/bpf/flow_dissector_load.c
index 3fd83b9dc1bf..87fd1aa323a9 100644
--- a/tools/testing/selftests/bpf/flow_dissector_load.c
+++ b/tools/testing/selftests/bpf/flow_dissector_load.c
@@ -17,7 +17,7 @@
 const char *cfg_pin_path = "/sys/fs/bpf/flow_dissector";
 const char *cfg_map_name = "jmp_table";
 bool cfg_attach = true;
-char *cfg_section_name;
+char *cfg_prog_name;
 char *cfg_path_name;
 
 static void load_and_attach_program(void)
@@ -25,7 +25,11 @@ static void load_and_attach_program(void)
 	int prog_fd, ret;
 	struct bpf_object *obj;
 
-	ret = bpf_flow_load(&obj, cfg_path_name, cfg_section_name,
+	ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+	if (ret)
+		error(1, 0, "failed to enable libbpf strict mode: %d", ret);
+
+	ret = bpf_flow_load(&obj, cfg_path_name, cfg_prog_name,
 			    cfg_map_name, NULL, &prog_fd, NULL);
 	if (ret)
 		error(1, 0, "bpf_flow_load %s", cfg_path_name);
@@ -75,15 +79,15 @@ static void parse_opts(int argc, char **argv)
 			break;
 		case 'p':
 			if (cfg_path_name)
-				error(1, 0, "only one prog name can be given");
+				error(1, 0, "only one path can be given");
 
 			cfg_path_name = optarg;
 			break;
 		case 's':
-			if (cfg_section_name)
-				error(1, 0, "only one section can be given");
+			if (cfg_prog_name)
+				error(1, 0, "only one prog can be given");
 
-			cfg_section_name = optarg;
+			cfg_prog_name = optarg;
 			break;
 		}
 	}
@@ -94,7 +98,7 @@ static void parse_opts(int argc, char **argv)
 	if (cfg_attach && !cfg_path_name)
 		error(1, 0, "must provide a path to the BPF program");
 
-	if (cfg_attach && !cfg_section_name)
+	if (cfg_attach && !cfg_prog_name)
 		error(1, 0, "must provide a section name");
 }
 
diff --git a/tools/testing/selftests/bpf/flow_dissector_load.h b/tools/testing/selftests/bpf/flow_dissector_load.h
index 7290401ec172..9d0acc2fc6cc 100644
--- a/tools/testing/selftests/bpf/flow_dissector_load.h
+++ b/tools/testing/selftests/bpf/flow_dissector_load.h
@@ -7,7 +7,7 @@
 
 static inline int bpf_flow_load(struct bpf_object **obj,
 				const char *path,
-				const char *section_name,
+				const char *prog_name,
 				const char *map_name,
 				const char *keys_map_name,
 				int *prog_fd,
@@ -23,13 +23,7 @@ static inline int bpf_flow_load(struct bpf_object **obj,
 	if (ret)
 		return ret;
 
-	main_prog = NULL;
-	bpf_object__for_each_program(prog, *obj) {
-		if (strcmp(section_name, bpf_program__section_name(prog)) == 0) {
-			main_prog = prog;
-			break;
-		}
-	}
+	main_prog = bpf_object__find_program_by_name(*obj, prog_name);
 	if (!main_prog)
 		return -1;
 
diff --git a/tools/testing/selftests/bpf/test_flow_dissector.sh b/tools/testing/selftests/bpf/test_flow_dissector.sh
index 174b72a64a4c..dbd91221727d 100755
--- a/tools/testing/selftests/bpf/test_flow_dissector.sh
+++ b/tools/testing/selftests/bpf/test_flow_dissector.sh
@@ -26,22 +26,22 @@ if [[ -z $(ip netns identify $$) ]]; then
 			type flow_dissector
 
 		if ! unshare --net $bpftool prog attach pinned \
-			/sys/fs/bpf/flow/flow_dissector flow_dissector; then
+			/sys/fs/bpf/flow/_dissect flow_dissector; then
 			echo "Unexpected unsuccessful attach in namespace" >&2
 			err=1
 		fi
 
-		$bpftool prog attach pinned /sys/fs/bpf/flow/flow_dissector \
+		$bpftool prog attach pinned /sys/fs/bpf/flow/_dissect \
 			flow_dissector
 
 		if unshare --net $bpftool prog attach pinned \
-			/sys/fs/bpf/flow/flow_dissector flow_dissector; then
+			/sys/fs/bpf/flow/_dissect flow_dissector; then
 			echo "Unexpected successful attach in namespace" >&2
 			err=1
 		fi
 
 		if ! $bpftool prog detach pinned \
-			/sys/fs/bpf/flow/flow_dissector flow_dissector; then
+			/sys/fs/bpf/flow/_dissect flow_dissector; then
 			echo "Failed to detach flow dissector" >&2
 			err=1
 		fi
@@ -95,7 +95,7 @@ else
 fi
 
 # Attach BPF program
-./flow_dissector_load -p bpf_flow.o -s flow_dissector
+./flow_dissector_load -p bpf_flow.o -s _dissect
 
 # Setup
 tc qdisc add dev lo ingress
-- 
2.33.0.882.g93a45727a2-goog

