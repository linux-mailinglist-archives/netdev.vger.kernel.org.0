Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4152E4916EB
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344698AbiARChN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:37:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43664 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345962AbiARCcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:32:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2970CB81235;
        Tue, 18 Jan 2022 02:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B010BC36AE3;
        Tue, 18 Jan 2022 02:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473136;
        bh=2tE7hxKGMOMC5KAqc0el4iqpnPASZIZxwjjzSAZrSyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NfzuODy+goaTFfscNkKdb/88iTrStnaUA4eAtz9uHp7IK/g0ciVitiNiUcloFqJ7q
         uHgj04oc55MYD0JkT3L1BBuMi0CWMQh2lmuvFsBZ1IkORj9pHnQxizqoxvzj5FJd+m
         Y9XIZrpmovVPv/Ym6NJCqgBSZIOM/UGytNwe1sMXSKIo0vLPjjnDkuwdoMAcr3539Q
         chsk6WH8kj+wSiLrAC1ttwAMubD1EpvzXhMK3M36r2r9sZ3pGkvdqJI6/ge/rTvL/d
         Vo/uZULpp/WYjyENwzBUjwjUEbY+C3P2u1RyutHLSJFVktDi/4QzksMFBsic4PbPAq
         DDmKVxrPFOV2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Hengqi Chen <hengqi.chen@gmail.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        daniel@iogearbox.net, kuniyu@amazon.co.jp, edumazet@google.com,
        sunyucong@gmail.com, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 009/188] selftests/bpf: Destroy XDP link correctly
Date:   Mon, 17 Jan 2022 21:28:53 -0500
Message-Id: <20220118023152.1948105-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit f91231eeeed752119f49eb6620cae44ec745a007 ]

bpf_link__detach() was confused with bpf_link__destroy() and leaves
leaked FD in the process. Fix the problem.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Hengqi Chen <hengqi.chen@gmail.com>
Link: https://lore.kernel.org/bpf/20211107165521.9240-9-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
index 59adb4715394f..3c85247f96f95 100644
--- a/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
+++ b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
@@ -204,8 +204,8 @@ static int pass_ack(struct migrate_reuseport_test_case *test_case)
 {
 	int err;
 
-	err = bpf_link__detach(test_case->link);
-	if (!ASSERT_OK(err, "bpf_link__detach"))
+	err = bpf_link__destroy(test_case->link);
+	if (!ASSERT_OK(err, "bpf_link__destroy"))
 		return -1;
 
 	test_case->link = NULL;
-- 
2.34.1

