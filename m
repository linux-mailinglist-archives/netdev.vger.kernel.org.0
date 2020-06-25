Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E050A20A0AD
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 16:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405388AbgFYOON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 10:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405286AbgFYOOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 10:14:11 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6E6C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 07:14:10 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id n23so6690053ljh.7
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 07:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sAqsIP04ByaDq2EDPMw15fX7T2DXBmYi0FY+Hk/6H0s=;
        b=LXqihZhgYvEEw9G7kGkmPezGcQva2huxgiPIkRxdA0ZkYJEIF+CDkPoSkWUUfFpyeV
         bZHGXOuy2hQG4ZEsqn86Ln3CYqJtrwmHKQYt0vZkEaprggM2zf9/SEX3dUyeNpl9jdeF
         RTot7q5lzBT2uG0937nXfFMczym8EYvtaSFTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sAqsIP04ByaDq2EDPMw15fX7T2DXBmYi0FY+Hk/6H0s=;
        b=AXEvPzJSyMig5IM3NV4kTBPWg4LZcl43B0nVdxLVwoFeoO9TMI/V1DHO0X3qT428w4
         +ew8dUIP4W7QKHepo1+KlCJcnTwVNv2W9M5yo42ZEJzexqf8CE44/JYOl4yomb/hcq6+
         RrDm6I7b8DJJnInLXAjpqSxqdOz7gUrtiuGe0LmngHVsNpmWMaK5FMlYDvLlTYolUaY4
         v3jtnxJIknPJeM2xb4P54zHkugi68uNFk8j09v9eJ2acjPRnF9bluAynsba/ZMrtAuGf
         Pr+gu67ecgtasQG3/nW6DiX6tFq6nJVPitxyOcmlp/MCmeo05/bUiF51e6HqpqRuU4VS
         K/iw==
X-Gm-Message-State: AOAM531OWiLDO7yl3EbGKIFw9AVzjYGV7TNSJAIx15dT9x/rl/HyNeBI
        3fi2sKqXuUyID1TYFh2hTQmZRA==
X-Google-Smtp-Source: ABdhPJwsHCl1XIp3EiYzINeyRwCHt4OnAV12U94LXF7dvJhP/a6B4kIl1kovM6RPW18+NLVapg6WRQ==
X-Received: by 2002:a2e:1508:: with SMTP id s8mr16038125ljd.52.1593094449209;
        Thu, 25 Jun 2020 07:14:09 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id z84sm3952142lfa.54.2020.06.25.07.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 07:14:08 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next v3 4/4] selftests/bpf: Test updating flow_dissector link with same program
Date:   Thu, 25 Jun 2020 16:13:57 +0200
Message-Id: <20200625141357.910330-5-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200625141357.910330-1-jakub@cloudflare.com>
References: <20200625141357.910330-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This case, while not particularly useful, is worth covering because we
expect the operation to succeed as opposed when re-attaching the same
program directly with PROG_ATTACH.

While at it, update the tests summary that fell out of sync when tests
extended to cover links.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../bpf/prog_tests/flow_dissector_reattach.c  | 32 ++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
index 15cb554a66d8..a2db3b0f84db 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
@@ -1,9 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Test that the flow_dissector program can be updated with a single
- * syscall by attaching a new program that replaces the existing one.
- *
- * Corner case - the same program cannot be attached twice.
+ * Tests for attaching, detaching, and replacing flow_dissector BPF program.
  */
 
 #define _GNU_SOURCE
@@ -308,6 +305,31 @@ static void test_link_update_replace_old_prog(int netns, int prog1, int prog2)
 	CHECK_FAIL(prog_is_attached(netns));
 }
 
+static void test_link_update_same_prog(int netns, int prog1, int prog2)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, create_opts);
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, update_opts);
+	int err, link;
+
+	link = bpf_link_create(prog1, netns, BPF_FLOW_DISSECTOR, &create_opts);
+	if (CHECK_FAIL(link < 0)) {
+		perror("bpf_link_create(prog1)");
+		return;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	/* Expect success updating the prog with the same one */
+	update_opts.flags = 0;
+	update_opts.old_prog_fd = 0;
+	err = bpf_link_update(link, prog1, &update_opts);
+	if (CHECK_FAIL(err))
+		perror("bpf_link_update");
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	close(link);
+	CHECK_FAIL(prog_is_attached(netns));
+}
+
 static void test_link_update_invalid_opts(int netns, int prog1, int prog2)
 {
 	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, create_opts);
@@ -571,6 +593,8 @@ static void run_tests(int netns)
 		  test_link_update_no_old_prog },
 		{ "link update with replace old prog",
 		  test_link_update_replace_old_prog },
+		{ "link update with same prog",
+		  test_link_update_same_prog },
 		{ "link update invalid opts",
 		  test_link_update_invalid_opts },
 		{ "link update invalid prog",
-- 
2.25.4

