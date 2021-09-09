Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BDF404EB1
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbhIIMNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:13:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243395AbhIIMLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:11:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 561C661A05;
        Thu,  9 Sep 2021 11:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188108;
        bh=wTkFVaW6fkoU9QG9knrcCG0f55YhqKPa8D5jng3jo6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFztGKd+yLi9fhFtzKFzOGTOR/GCBVbpUClY0M5ryIyAhAl3k4ihxrds9unUGOfek
         rMAL+7vIE1xlqtcUNQWbYRvfupZt20sXubE7oq6f+pHasj/CbB7GpzxY8kuxTEtXpQ
         PdhMAZra/LDfT4TsF1yCM7x5bis1LW82YV5En0LqV4bewPvvryPHeB6zE3zrwtJKTp
         aVPpv6dFL/2ju+VipfF7o3TX8DkqzyxnDseQqBEuOqrkmqvspqRi9QBe2Xg7OjCIug
         LIiarFy69/k9DEo2sIsX4QH8JOuImbu19ygzccNtDKlXDiVRHXMmEARyM3ChBGp6pb
         0R51WwhBskNcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 087/219] bpf: Fix off-by-one in tail call count limiting
Date:   Thu,  9 Sep 2021 07:44:23 -0400
Message-Id: <20210909114635.143983-87-sashal@kernel.org>
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
index b1a5fc04492b..fe807b203a6f 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1562,7 +1562,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 
 		if (unlikely(index >= array->map.max_entries))
 			goto out;
-		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
+		if (unlikely(tail_call_cnt >= MAX_TAIL_CALL_CNT))
 			goto out;
 
 		tail_call_cnt++;
-- 
2.30.2

