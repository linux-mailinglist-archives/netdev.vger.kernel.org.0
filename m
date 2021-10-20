Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34EC435620
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 00:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhJTWw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 18:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhJTWwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 18:52:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CF8C061749
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 15:50:10 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x16-20020a25b910000000b005b6b7f2f91cso33122536ybj.1
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 15:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IVE/piZYMfCN/8vNlj6ypJYg+hJVjEv4ETpgE1DWPkc=;
        b=Xm7K4CSy9QU/heCdguK6sWSiqqpgp2GxJ3F21bZ5Z5QJSrdjveRE0ifzKuoINW0+Jo
         PB0SE3OZM2+Bh0KKZny2/LqYCk1mqw78U0H1aF8RLpRyDYn8zxrkLUH6uffEfyWGZN/A
         SI+nulG5N8IqQBROu5ss+UcMTM4tdiad8vc2548c96uWsZFbnbqujHv+4sVi9eLeIvt4
         3WLXfBuc8twoVvnZG9WvNR0EXZ5lw7flOzU5Kd1gUfRBX/u28C1XVaCPamTpQk6hLuzS
         UBg/Mayl6Q/jCCfX1E5sr/unDy+SBOSqwa3CLZusPOn6v6D+lOR7klGO7Ijsti9pUwr8
         uMfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IVE/piZYMfCN/8vNlj6ypJYg+hJVjEv4ETpgE1DWPkc=;
        b=z/r/FSJvwQhY2LK7w+ZPVPeUHeKEK6CQO814x4s4UWnaw/MEwYVAC/5SC+Ryljwxkq
         PM75ZBkmlyCetzRn5rurZJNjSFqRlSWAmyNP8ikZk49Snns+gnCZSaaXdMiLteSWC660
         wSznIQpieh69kv1A0X2gxp9um8SNPCkStM3ySZ6F4hcRYXNK01uGAiugSkv1xkVwAN3L
         v2Hx4rd9qohFFNN+k95VwfzX43ByfGGKNDBHx2tzUgUCaPxxoqrnJNTeaItledL9+ujv
         WcBpjaD3dYojf9ZyEsK7k7cok8yrAXWj9FbtZkXug3PuUcflo9MDWGAD+YM7Q20KOHiq
         SS8A==
X-Gm-Message-State: AOAM533iAKxIBQpZxK+mP6muKo0RrXcGuBzPGirq7abI7YJ1ce5mxpdo
        yw9IVHjqbn6woAcV4N5l0R1aAzuoJEhvS7oJZZH6ui5h7ERJXYvoyfWMux7Zd91CxwexCleN7Ha
        C2vGzat/Y4WD1lbY9BKNeMGmS8urb1bMVQOsxMYKuoZ+jcMhZ4yE2fg==
X-Google-Smtp-Source: ABdhPJwrxuL8yxaLm9w+iSzzbrRZGAILvP2jZ/bpqvkeTNgCJdHL2LSipZ07aeQHLMJQwmPwJZlDbx0=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:dcf9:6f58:d879:8452])
 (user=sdf job=sendgmr) by 2002:a25:9c87:: with SMTP id y7mr2100103ybo.102.1634770209524;
 Wed, 20 Oct 2021 15:50:09 -0700 (PDT)
Date:   Wed, 20 Oct 2021 15:50:03 -0700
In-Reply-To: <20211020225005.2986729-1-sdf@google.com>
Message-Id: <20211020225005.2986729-2-sdf@google.com>
Mime-Version: 1.0
References: <20211020225005.2986729-1-sdf@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH bpf-next v3 1/3] libbpf: use func name when pinning programs
 with LIBBPF_STRICT_SEC_NAME
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't use section name anymore because they are not unique
and pinning objects with multiple programs with the same
progtype/secname will fail.

Closes: https://github.com/libbpf/libbpf/issues/273
Fixes: 33a2c75c55e2 ("libbpf: add internal pin_name"0
Cc: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/libbpf.c        | 13 +++++++++++--
 tools/lib/bpf/libbpf_legacy.h |  3 +++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 760c7e346603..7f48eeb3ca82 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -285,7 +285,7 @@ struct bpf_program {
 	size_t sub_insn_off;
 
 	char *name;
-	/* sec_name with / replaced by _; makes recursive pinning
+	/* name with / replaced by _; makes recursive pinning
 	 * in bpf_object__pin_programs easier
 	 */
 	char *pin_name;
@@ -614,7 +614,16 @@ static char *__bpf_program__pin_name(struct bpf_program *prog)
 {
 	char *name, *p;
 
-	name = p = strdup(prog->sec_name);
+	if (libbpf_mode & LIBBPF_STRICT_SEC_NAME)
+		name = strdup(prog->name);
+	else
+		name = strdup(prog->sec_name);
+
+	if (!name)
+		return NULL;
+
+	p = name;
+
 	while ((p = strchr(p, '/')))
 		*p = '_';
 
diff --git a/tools/lib/bpf/libbpf_legacy.h b/tools/lib/bpf/libbpf_legacy.h
index 74e6f860f703..a51f34637442 100644
--- a/tools/lib/bpf/libbpf_legacy.h
+++ b/tools/lib/bpf/libbpf_legacy.h
@@ -52,6 +52,9 @@ enum libbpf_strict_mode {
 	 * allowed, with LIBBPF_STRICT_SEC_PREFIX this will become
 	 * unrecognized by libbpf and would have to be just SEC("xdp") and
 	 * SEC("xdp") and SEC("perf_event").
+	 *
+	 * Note, in this mode the program pin path will based on the
+	 * function name instead of section name.
 	 */
 	LIBBPF_STRICT_SEC_NAME = 0x04,
 
-- 
2.33.0.1079.g6e70778dc9-goog

