Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5484E49142D
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244444AbiARCUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244610AbiARCUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:20:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4CFC061769;
        Mon, 17 Jan 2022 18:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72781612CE;
        Tue, 18 Jan 2022 02:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAD6C36AE3;
        Tue, 18 Jan 2022 02:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472413;
        bh=/EAeO4xUnZVlE4J3vuK3DNqUta/S6QmR1xXciBHU+t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRjsISKW9FsKmQjto0PAeweRHNs9RFU04pLSubdHv6wLDajEj/XoldmB8oYCW5sCN
         68pWutTlPAk/7B5zTaxhX1FLZ+/ruQJoboWUdncqeIgtCaLq1vrw0LGOItWNRJCuCo
         g6UVBv9lM72BI+UVSIm6WhbkIlrp4SB4JaidZP8chQtkFU5+OlOIHAEnEgJbRMTkTj
         OKmnvY8fzddC0JIYzsb/WpqovFg3+lYI+7e6NUBs8iJlXn/KVUYEx5odHYiLRpgQio
         Q4lcUF3d9HPmFGBhJenHVxvtdyr13lw350x/zfHqWc43Fv28hwKPL3aWrptxobzSpn
         BlYN0X22IJG5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Hengqi Chen <hengqi.chen@gmail.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        daniel@iogearbox.net, kuniyu@amazon.co.jp, sunyucong@gmail.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 013/217] selftests/bpf: Destroy XDP link correctly
Date:   Mon, 17 Jan 2022 21:16:16 -0500
Message-Id: <20220118021940.1942199-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index 7589c03fd26be..eb2feaac81fe2 100644
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

