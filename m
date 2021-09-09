Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D837405123
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346564AbhIIMdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:33:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350885AbhIIM2R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:28:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55BD061AFC;
        Thu,  9 Sep 2021 11:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188334;
        bh=zFSR/y0zf3mMjO+hWHcjRXVdXR3DnvExAtTzipWi3QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwjTN7Nxd6LzAxlWSCMo1C8jLT+Ipy3a6cIQV8pELF7n9JGzQ7QO5ABzgrjWgGdF9
         nGa5Xo6MkdBxHRQ5JR3hr5xrkKIVfj3UXwnePFZdwjsu/7lB2ieuDR7oNhzbsb7q+2
         vHjzMZv8jdG2pLR55U0Td8+Qy1qjkuO9CCFIiYXa8eqhDAUPumsJjQ0UeJDkJSeVhJ
         9AIzEvZJOVF1ZwsJp8OR5ztIEkKFT4WhEfcJgbyeoX1n2TdMPWJ8mrI5oIw0C2eDNu
         Z1Tsix8Yok/Y+njBAt5UyhgLx3jUwWdZ7smmgiye2Vw8UQGNPmfFQinMiJ3Z+yaDxI
         vRwAJ13E2Tz7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 043/176] bpf/tests: Do not PASS tests without actually testing the result
Date:   Thu,  9 Sep 2021 07:49:05 -0400
Message-Id: <20210909115118.146181-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit 2b7e9f25e590726cca76700ebdb10e92a7a72ca1 ]

Each test case can have a set of sub-tests, where each sub-test can
run the cBPF/eBPF test snippet with its own data_size and expected
result. Before, the end of the sub-test array was indicated by both
data_size and result being zero. However, most or all of the internal
eBPF tests has a data_size of zero already. When such a test also had
an expected value of zero, the test was never run but reported as
PASS anyway.

Now the test runner always runs the first sub-test, regardless of the
data_size and result values. The sub-test array zero-termination only
applies for any additional sub-tests.

There are other ways fix it of course, but this solution at least
removes the surprise of eBPF tests with a zero result always succeeding.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210721103822.3755111-1-johan.almbladh@anyfinetworks.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_bpf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index ca8eef2f6442..4a9137c8551a 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6664,7 +6664,14 @@ static int run_one(const struct bpf_prog *fp, struct bpf_test *test)
 		u64 duration;
 		u32 ret;
 
-		if (test->test[i].data_size == 0 &&
+		/*
+		 * NOTE: Several sub-tests may be present, in which case
+		 * a zero {data_size, result} tuple indicates the end of
+		 * the sub-test array. The first test is always run,
+		 * even if both data_size and result happen to be zero.
+		 */
+		if (i > 0 &&
+		    test->test[i].data_size == 0 &&
 		    test->test[i].result == 0)
 			break;
 
-- 
2.30.2

