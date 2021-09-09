Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9676405524
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355149AbhIINI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:08:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357658AbhIINDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:03:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E61DC6328B;
        Thu,  9 Sep 2021 11:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188779;
        bh=H+isFLhv7fXZadAnSAxSil/y1Hb6bZxn8GmeSiUGOhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9lxA/pyBd8kAXRPYrXb/kW7V0rs+F5l/l3bKmqoLWXAXCvho4S7RKTCAWTeKgGnn
         E/gzKyFYYVXD9E5SXw6rPa7zAHTqY1R5moycTiHKmOHkb696PCgSDlNVq0Uqzb9FW3
         9k5wDkgofrTMF5H4nbwMx1+TEC52TrcZ9653Pw1sWm+qGm1RfAkJmCi03693pMtKdX
         fo7NDNDI/IzCb6yrzROUwoDwsF+HQdKf8ZxOrgUwVT94dqB4UTwxw64xUzhgPiJdRH
         mcMJQbrA+yIMro03vhYF9Cd43xvs6fkZoYezwoheIml/9WDKZ16kSC3hP5AJcIqsfV
         3jeDsSSU3RCmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 31/59] bpf: Fix off-by-one in tail call count limiting
Date:   Thu,  9 Sep 2021 07:58:32 -0400
Message-Id: <20210909115900.149795-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
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
index e7211b0fa27c..1d19f4fa7f44 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1095,7 +1095,7 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
 
 		if (unlikely(index >= array->map.max_entries))
 			goto out;
-		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
+		if (unlikely(tail_call_cnt >= MAX_TAIL_CALL_CNT))
 			goto out;
 
 		tail_call_cnt++;
-- 
2.30.2

