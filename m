Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6055654C751
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 13:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344257AbiFOLWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 07:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344316AbiFOLWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 07:22:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD1F50E1A;
        Wed, 15 Jun 2022 04:22:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4945861741;
        Wed, 15 Jun 2022 11:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12076C34115;
        Wed, 15 Jun 2022 11:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655292129;
        bh=9KBmkpVrjLKF7VZsEwiMYlvXT5Md1t15jLSCYpzbFyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=md6gTN8T4TdKWQ6dK4cyQmbLe0XH8UxrZXNCdrR2d6/kbTAHsiYR1rqdSmdehYhVF
         Pk+92WukPEoub1POvGR7ax8c2Jfc4Aw4rdPS8BavA1wSsfK5ob7w1uUPI5Z7Edg9Gi
         qNpgY0XowRScd26YotgbQI/mP6CVcpPkKoJYiXwAR2cnapmy6MDKVHGY1CqH0JGPZr
         Y4N9QD2BZg+qtvcPQhqdSwcQ/n7IEL0MPpHWyCGeA3cKTyP6U7qOmYK/RyKEFsmjKP
         teUnP9Hq9wuRYU6cQ0GYAk+/E6jLC4UbmVDveYinpxgsXqvPwLu3ODvCOK9yPv7isl
         grDiJbf+3HVSQ==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCHv3 bpf 4/4] selftest/bpf: Fix kprobe_multi bench test
Date:   Wed, 15 Jun 2022 13:21:18 +0200
Message-Id: <20220615112118.497303-5-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220615112118.497303-1-jolsa@kernel.org>
References: <20220615112118.497303-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With [1] the available_filter_functions file contains records
starting with __ftrace_invalid_address___ and marking disabled
entries.

We need to filter them out for the bench test to pass only
resolvable symbols to kernel.

[1] commit b39181f7c690 ("ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding weak function")

Fixes: b39181f7c690 ("ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding weak function")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index 586dc52d6fb9..5b93d5d0bd93 100644
--- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -364,6 +364,9 @@ static int get_syms(char ***symsp, size_t *cntp)
 			continue;
 		if (!strncmp(name, "rcu_", 4))
 			continue;
+		if (!strncmp(name, "__ftrace_invalid_address__",
+			     sizeof("__ftrace_invalid_address__") - 1))
+			continue;
 		err = hashmap__add(map, name, NULL);
 		if (err) {
 			free(name);
-- 
2.35.3

