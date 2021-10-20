Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BC6435624
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 00:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhJTWwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 18:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhJTWw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 18:52:28 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31D8C061749
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 15:50:13 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id r13-20020a17090a1bcd00b001a1b1747cd2so396669pjr.9
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 15:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cW6HnFPnxVttXYlllvO2YbONJSMhxty7Sc5+0SAjPIg=;
        b=jtgkvZuItEYvDKVEAy/vvYC549Z1ccriJUPqqcHb29Pj1nKLN7L3GhYJ7VB/LrbJWD
         PdWw7lga9wxwhTNbkaxN+9O30u++b3Iu0A+97TjrCkCYZVKaIXzxH05xGw/jRvOA/ZXy
         J5bdKCrfi52rGvgtvGt7K5K5dm3vBzxyu0yMgyE2Mij48RIgt3ykic6s9DjYUzo+HDm3
         DoxPstc+A/nL7wt/EAfYqkuSlWV9mZtGyz1im66s86QHHqyomBnDu0b0fQYfKjNaB+PL
         Gw4MypL7Y/dIRBZhgvGXTZjwHRMUCn+U3/TbIsGk952TwcRJz2HCyObUqxd+MbrKOQz5
         Lfqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cW6HnFPnxVttXYlllvO2YbONJSMhxty7Sc5+0SAjPIg=;
        b=HjREs6G+ciuOx0MNMb3xwFdVbODbMAIYGeE4s8f6FHXI2nX2tEk6/OL7tzH1jqlsec
         q/FVxQFO5b0hK/lge+0n5CECRASUeymqKWRsUniaXwdOWmaWde2XHdOYcja/SAT8krSy
         vSgE59xsB2PtPR0H4SOkss4NwmDo+Dmxs0RChumnAaLGPoL/j6PNK3xcfgoWWcdX+Lr7
         V2WdE2W60+XM9Af6rGjMF6JGto9JPY+tf4mIHIDgPW04mxbsNfnRh5Bi7oOHVOJV84QZ
         0fo0l+zIGaNk/YoFd0vCvf5YCWa45CtJ8pM5XvXlAIrbgOSD1WT7C98MGCgFayCnZXRc
         bBzQ==
X-Gm-Message-State: AOAM532R8SNO/YOo0mGPA1+19WF7vUadyhVvBQQz+pHJtgcIZbOSZnDD
        cGDE46ny8j7U/HX5zDyGuAJ+i7/qwjRJNhZD4jPhugYyS64jEz42MPGUZzD9TCbePeBzYqSf4HO
        9W+G2ZLpvqITfkhvbfn5Y/e4ZTWHQExZ9LQLI5GE5GasULZx2wMMBxw==
X-Google-Smtp-Source: ABdhPJyGJrI+IYbh6uloCgmkr4dCkC6+p5FlygHxsXU+AT33iBaLYb4J8Vu5kLVCmyHXRONJ2uMprno=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:dcf9:6f58:d879:8452])
 (user=sdf job=sendgmr) by 2002:a17:902:7ec2:b0:13d:b563:c39 with SMTP id
 p2-20020a1709027ec200b0013db5630c39mr1856094plb.14.1634770213341; Wed, 20 Oct
 2021 15:50:13 -0700 (PDT)
Date:   Wed, 20 Oct 2021 15:50:05 -0700
In-Reply-To: <20211020225005.2986729-1-sdf@google.com>
Message-Id: <20211020225005.2986729-4-sdf@google.com>
Mime-Version: 1.0
References: <20211020225005.2986729-1-sdf@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH bpf-next v3 3/3] selftests/bpf: fix flow dissector tests
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
2.33.0.1079.g6e70778dc9-goog

