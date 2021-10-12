Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E73842A930
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhJLQR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhJLQR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 12:17:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4502C061745
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 09:15:54 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q193-20020a252aca000000b005ba63482993so19261792ybq.0
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 09:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1fprwygtfcbW4YsIOZabVxvRcnD8jzC8e3Grk+JtWJM=;
        b=eIJzWdq4FqJxjYSYrWTzyPf4aRvaZ4BUXVxKKqyI0/9L/UZsNlnIRt4wg+e/raLxE2
         TU0SpC6qcKDauHj0119LFPg/QRAWb00seCJZi2uiIfv50LTtHtfmpL8NnnJDEVmJ4Ler
         h6+ev/h7tf6yW0a8neMPjNPdokA8jiENwR7OoIiBxTNv7uDYhSHPlolIvsmrB6pKeJWU
         tgG/Cb6oFLRXCjcQ1SIqUhHeLnLXON09vlhgRfkIJlCrusYh64MTCNbOCXga0tbomaPI
         7tyCG6+BEQpSwjX2Ka75FzwgA0kwkX0TpHvwAghB+elyo3cELjDqEtnrK+4LaAZn/0Ga
         ASJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1fprwygtfcbW4YsIOZabVxvRcnD8jzC8e3Grk+JtWJM=;
        b=hKcOJLAYjFYLETOOLKuxdw4/yOqecqTJ//7NX+sp7OiUTyLzCUycMaIESU2z0O/qjU
         WgLUoAexVbdnbcMRK6/+emOGDYVFyPLTCvxBj70vPjE/inNc6mxlzI7E/wPzKtnCOQtk
         h9tQPA1HUVaSlMWWxwbL+eBkojS2EX7RAoScEgJ0M7bpfm8+/s8CHPEderlBIh0zlaGn
         BaqoJjgfj7jOOgWYrrHGXw/mXkXX89IzpvQxsQnRdw80xTh/0ilOcpFd7n34OtxSGKQw
         8LNIvxKtHHnUnB5L1Afbr9G2gTR82dJRFK/bSPuYCPEUFvXcNSYx2goqe/IH8UUmf3tO
         /AvA==
X-Gm-Message-State: AOAM531KR8D62TwuHxLtKn6edrY+xZ3ZtUFcLmDjFTozfDvnZMMMYoht
        rH38az1hn4KO8u+lFJCN8Ea95JrQ+uvomIf+PZltDEGDXtQklPbhg62jpugKJ/8Q6cCKnpkr39a
        fv/fq8efB/mLRDxeVNH1gTeerYJ2w1WlczSuX45wN1U+8FHOOZhtvFQ==
X-Google-Smtp-Source: ABdhPJwofZ85WPvbeKvSYlN0n5Fu8ww/Y1Q/yrh2BMwd8ds19k5TfOmnVwYrLMbnfcP3rZ6zDZqLGvs=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:4060:335c:dc47:9fc2])
 (user=sdf job=sendgmr) by 2002:a25:ccd1:: with SMTP id l200mr29997924ybf.140.1634055354057;
 Tue, 12 Oct 2021 09:15:54 -0700 (PDT)
Date:   Tue, 12 Oct 2021 09:15:44 -0700
In-Reply-To: <20211012161544.660286-1-sdf@google.com>
Message-Id: <20211012161544.660286-4-sdf@google.com>
Mime-Version: 1.0
References: <20211012161544.660286-1-sdf@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH bpf-next v2 3/3] selftests/bpf: fix flow dissector tests
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

