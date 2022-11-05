Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C457061A659
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 01:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiKEARb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 20:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiKEARa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 20:17:30 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B602495F;
        Fri,  4 Nov 2022 17:17:29 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667607448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pUOvizM6L+kmDJhUYDsdrvxDq5DlQT7btcmJjsQ/ZR8=;
        b=of0T1TMZEl0u/ZvUgKSMKOzjDxCwOYtU4d3R5BnLJ/NHukBDWrl3tU5CXvKabBJsDHHEUc
        TF3M56Lv4OVBSkd7nzV5HlnB6zDwTmXe/yWklnQfx5cf0lFJYpINazZ/3/8Rx1x34s5TS8
        7oQnmu16EGOguiNGFumrQIIT1aVw5LI=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com,
        Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH bpf-next 2/3] selftests/bpf: Fix incorrect ASSERT in the tcp_hdr_options test
Date:   Fri,  4 Nov 2022 17:17:12 -0700
Message-Id: <20221105001713.1347122-3-martin.lau@linux.dev>
In-Reply-To: <20221105001713.1347122-1-martin.lau@linux.dev>
References: <20221105001713.1347122-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

This patch fixes the incorrect ASSERT test in tcp_hdr_options during
the CHECK to ASSERT macro cleanup.

Cc: Wang Yufen <wangyufen@huawei.com>
Fixes: 3082f8cd4ba3 ("selftests/bpf: Convert tcp_hdr_options test to ASSERT_* macros")
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
index 617bbce6ef8f..57191773572a 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
@@ -485,7 +485,7 @@ static void misc(void)
 			goto check_linum;
 
 		ret = read(sk_fds.passive_fd, recv_msg, sizeof(recv_msg));
-		if (ASSERT_EQ(ret, sizeof(send_msg), "read(msg)"))
+		if (!ASSERT_EQ(ret, sizeof(send_msg), "read(msg)"))
 			goto check_linum;
 	}
 
@@ -539,7 +539,7 @@ void test_tcp_hdr_options(void)
 		goto skel_destroy;
 
 	cg_fd = test__join_cgroup(CG_NAME);
-	if (ASSERT_GE(cg_fd, 0, "join_cgroup"))
+	if (!ASSERT_GE(cg_fd, 0, "join_cgroup"))
 		goto skel_destroy;
 
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
-- 
2.30.2

