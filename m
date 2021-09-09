Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BB1404AFA
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240664AbhIILuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241724AbhIILrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:47:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FF0761252;
        Thu,  9 Sep 2021 11:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187796;
        bh=s6XsWzVWqD2vMfqoDgZZEKdCdulOgvw3qFos1Sot6d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RoN64ATk8rF8doMIyYjY4GyC6apzMH7ru6q9kCDOj1JqqSHWmxstc7iTtRKny7dcL
         OtD0Yh4LapIMxGSWFSuL3rYM3aqAINa4VJZLxN8GKHhsItso9WHBkXe4pTJeMh3s+f
         0BHgtHPkJ2N41+dFX5ft8DKfupcf3eU94mcGZ5Sts19AVpDXMpSNJf6TiNjGPHkpNE
         8WH6z1VDsATn5D6CHA//mlI7ivEliQ7WAj6rshGlxU6LdFGBUkIu4G+YfJLcP35yI/
         LKiEZXI6Guv7qtjyfV33ZNIV7bLD19w1o6M4BQ9F0OArzQXad5Zcg27xKVQci4PV6D
         tkFbMfIXdJQJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 101/252] bpf: Fix off-by-one in tail call count limiting
Date:   Thu,  9 Sep 2021 07:38:35 -0400
Message-Id: <20210909114106.141462-101-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit b61a28cf11d61f512172e673b8f8c4a6c789b425 ]

Before, the interpreter allowed up to MAX_TAIL_CALL_CNT + 1 tail calls.
Now precisely MAX_TAIL_CALL_CNT is allowed, which is in line with the
behavior of the x86 JITs.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20210728164741.350370-1-johan.almbladh@anyfinetworks.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 0a28a8095d3e..82af6279992d 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1564,7 +1564,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 
 		if (unlikely(index >= array->map.max_entries))
 			goto out;
-		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
+		if (unlikely(tail_call_cnt >= MAX_TAIL_CALL_CNT))
 			goto out;
 
 		tail_call_cnt++;
-- 
2.30.2

