Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73124052C9
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353187AbhIIMrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:47:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353048AbhIIMno (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:43:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CCF96139F;
        Thu,  9 Sep 2021 11:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188542;
        bh=uTNrrX/S4t6/ZBcUg0zRYdoMNiMsoigv8fWLoQZC3gE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DoYVD14g65BUdfzdYsAxMX1K7tPKxasmJxYgZe68JvKzBFxcie+h1mE97i/18EHJD
         zci48pi8CPv2FrlCCO1ReI9L7IjfwGEKdzgD7M6mZR5Qj06Tyz+QLh4C/+jbu5NzyZ
         ksOh5sEHtSoCEq6jPqsL74f4JjX2tTdCX7dEDmIpJLEddWUb+IYPqimfJkMlEVEAnT
         QOJEZbM5BRn+vnNTOBTTBve0YRfiOBqSDNoQLvIFzXeYifLgMxO/xozllF4w9zV/KU
         SPphEdROi2CwzcA+iMi/NwfKyst7KMDL2Gm2Pa5tls+1hN99VkpH+doY6ex3YGe+RI
         s0MQIhS3dndxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 027/109] bpf/tests: Do not PASS tests without actually testing the result
Date:   Thu,  9 Sep 2021 07:53:44 -0400
Message-Id: <20210909115507.147917-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
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
index 5e985ed68b2a..3ae002ced4c7 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6684,7 +6684,14 @@ static int run_one(const struct bpf_prog *fp, struct bpf_test *test)
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

