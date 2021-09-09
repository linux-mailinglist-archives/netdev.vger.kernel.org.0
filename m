Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0C740548B
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357085AbhIIM7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244313AbhIIMxe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:53:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 917B863249;
        Thu,  9 Sep 2021 11:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188669;
        bh=AJpXbpPOr7yKBsBlNIWWsMTSvBZzIz7cDKjO3sAlSOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fo+0K3u7hRewWv9+IVw7NIPWDTUwPkZ8EPefVxnAlvlfRh5qfpk0YUJ7QDoEkxzUy
         MXER7VEwbJHxLARdhZZ0966lFDzc5qD0jmXQ8A6qYwtpWBHxi3wK0kV655EhsYxFmf
         j14B27sDyLfjKGypmPUZTbbHHvwayOwJJXdw89UEbMhU1BRF953nqaPSgMor+ZqdJa
         gGma8Lo2M58Qus11ZzIoZrAMIV0wYzA5Rk8kC0IocvlZy4Yrjx+yuHW3gCO3BuaBAv
         HADko+IKIqmAMmlpe8b84kll+AVnn+YBlcyWnieWw/PckIiTIyDr6H7I+uMRR51btU
         WOGi9tWchnnlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 18/74] bpf/tests: Do not PASS tests without actually testing the result
Date:   Thu,  9 Sep 2021 07:56:30 -0400
Message-Id: <20210909115726.149004-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
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
index 98074a3bc161..49d79079e8b3 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6687,7 +6687,14 @@ static int run_one(const struct bpf_prog *fp, struct bpf_test *test)
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

