Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0A2414750C
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 00:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgAWXvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 18:51:48 -0500
Received: from mail-vk1-f201.google.com ([209.85.221.201]:47472 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729976AbgAWXvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 18:51:48 -0500
Received: by mail-vk1-f201.google.com with SMTP id n9so73862vkc.14
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 15:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kt/eV/TaltYH1vknvG4QX+x8MYpfU54+vE5TUC0K9SE=;
        b=JHOH19tfWiApPdUjcL24qhpzwtZeJCMpSFxavIX5Reihh7EhQtEc1aOVm/9beSzDJN
         pq/w/8nsjBb+2Q9147H0/rFjGPj5F8F+9LKWlJAsj9V5w1InN6mo5EzyNsQwdR7vyWgq
         LtOIpndRQsi7Ph7hX4ONXVdsFfxB4SbxZZR8B1lAx0ML6R1RqwdqNENLvGgUc+hIrRY5
         MGsdB5NNzPulmN/9wT2UjsUqa6fPUU5NVO8AOH655I5RUyN05iD+xqSwqh6tcI0BeX/S
         PA1caewAQ+85UvcaISimcj7budalsJmuDWWmBv4tLJqkvLZPdCd51oZ44rux23V6pL7V
         W6vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kt/eV/TaltYH1vknvG4QX+x8MYpfU54+vE5TUC0K9SE=;
        b=SWjRJ/119Z372rlI/W0T/0McgGwoMWoAnFHCvJuus/1Cde4DMK+O9s2oR+mKtH5Gpy
         TEE1NuSK/iiIWMgtCDBmywkiARL2WbjenfaXHx/6dj10l01TeifOMNGK7SB8/Gq/tQKw
         r1O4QmgyDKPHuefdQTDYjjR5dRtCgVkSB5gKu4cT5BkEhQ4lyLen3UVVFCP7HG/cuRX/
         1t8mzzIctHmTphFa2ocn1wvcf7uTuQBWCeDt5G4QL6rIX1BOaAlErlq7FxMPcYbS9qVa
         Zwz/KxgPIeM35+Tu/qDQkml9vlpPHZ6O8u+XhAS6KgeL7h4UEF7QjFbgJDqs9EX+ihBz
         yj8A==
X-Gm-Message-State: APjAAAXNHKkhYbgIkPKQxn7uZkmKQkqbR9Y6gwiQ28W6FQ4BP6u1a2HN
        6V/nk0d802aFvR69eatIsK3+S8GR7LlSSzb50jVHXwL34TwF17tfEc3NHwXrgcT7XMqdHpMMN9s
        L0+zRz7X8CcgMvBqx/DlmTZ7Rp4Qn3FnjPX/SGj3MhnTULwZ+QQ4OsA==
X-Google-Smtp-Source: APXvYqzeVOvhxOIfHSkIpCgyg+Q0s6sQmTyRZ4GcivvYoIX6ba2d0bU9GjE5kSTvcxdtrajNWLqtGWE=
X-Received: by 2002:a67:fe50:: with SMTP id m16mr626134vsr.114.1579823507273;
 Thu, 23 Jan 2020 15:51:47 -0800 (PST)
Date:   Thu, 23 Jan 2020 15:51:44 -0800
Message-Id: <20200123235144.93610-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH bpf-next] selftests/bpf: initialize duration variable before using
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        John Sperbeck <jsperbeck@google.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Sperbeck <jsperbeck@google.com>

The 'duration' variable is referenced in the CHECK() macro, and there are
some uses of the macro before 'duration' is set.  The clang compiler
(validly) complains about this.

Sample error:

.../selftests/bpf/prog_tests/fexit_test.c:23:6: warning: variable 'duration' is uninitialized when used here [-Wuninitialized]
        if (CHECK(err, "prog_load sched cls", "err %d errno %d\n", err, errno))
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.../selftests/bpf/test_progs.h:134:25: note: expanded from macro 'CHECK'
        if (CHECK(err, "prog_load sched cls", "err %d errno %d\n", err, errno))
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        _CHECK(condition, tag, duration, format)
                               ^~~~~~~~

Signed-off-by: John Sperbeck <jsperbeck@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/prog_tests/fentry_test.c   | 2 +-
 tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c | 2 +-
 tools/testing/selftests/bpf/prog_tests/fexit_test.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
index e1a379f5f7d2..5cc06021f27d 100644
--- a/tools/testing/selftests/bpf/prog_tests/fentry_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
@@ -9,7 +9,7 @@ void test_fentry_test(void)
 	struct test_pkt_access *pkt_skel = NULL;
 	struct fentry_test *fentry_skel = NULL;
 	int err, pkt_fd, i;
-	__u32 duration, retval;
+	__u32 duration = 0, retval;
 	__u64 *result;
 
 	pkt_skel = test_pkt_access__open_and_load();
diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index db5c74d2ce6d..cde463af7071 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -11,7 +11,7 @@ static void test_fexit_bpf2bpf_common(const char *obj_file,
 	int err, pkt_fd, i;
 	struct bpf_link **link = NULL;
 	struct bpf_program **prog = NULL;
-	__u32 duration, retval;
+	__u32 duration = 0, retval;
 	struct bpf_map *data_map;
 	const int zero = 0;
 	u64 *result = NULL;
diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_test.c b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
index f99013222c74..d2c3655dd7a3 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
@@ -13,7 +13,7 @@ void test_fexit_test(void)
 	int err, pkt_fd, kfree_skb_fd, i;
 	struct bpf_link *link[6] = {};
 	struct bpf_program *prog[6];
-	__u32 duration, retval;
+	__u32 duration = 0, retval;
 	struct bpf_map *data_map;
 	const int zero = 0;
 	u64 result[6];
-- 
2.25.0.341.g760bfbb309-goog

