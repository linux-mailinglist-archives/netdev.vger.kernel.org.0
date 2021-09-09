Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B3D404E7D
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244683AbhIIMMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348518AbhIIMHo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:07:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D867E61250;
        Thu,  9 Sep 2021 11:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188068;
        bh=qAjnl9fZBFF30EAQJawikxCXtJtytrTUzqXnRJgkWZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WFRk5EHEoYooePO0ZRyWuCDqZTbKsoODwOw8Qg7OjTuTgig863jVEZO/u/LVqoAfi
         TFMAz6EUu9D/L6lQvEiIjPwlzr7COG/Asw8YP0v0Jdu9jvhbyI4M7nstfZMBRSvSb5
         r+j1z5gVerOejbAdNVELdFpFX+0GF661xsa5sQp6adONyRpKHUNO4eOpOzqG4DKuBm
         jpuKY23EegsCH1+c5t5DNwovqBrBgwNckdN5TSyHZkpR1g4nWuTn+L0n43dw1XYXOn
         pLqB0yCW4Wv5Tl+Y3HG83JV+B1723Db2gR/Lwr26tr2yw/m4Ur+YVZ8fVsIVPODlRG
         kIGqTdTg2e4Pw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 056/219] bpf/tests: Do not PASS tests without actually testing the result
Date:   Thu,  9 Sep 2021 07:43:52 -0400
Message-Id: <20210909114635.143983-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index f826df50355b..acf825d81671 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6659,7 +6659,14 @@ static int run_one(const struct bpf_prog *fp, struct bpf_test *test)
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

