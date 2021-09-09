Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BF44057EF
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351956AbhIINoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:44:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356614AbhIIMzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:55:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49BED613D2;
        Thu,  9 Sep 2021 11:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188690;
        bh=BZvm1toZ3Z9QlyIH9RMnJNT1diE06Fi3/45GUdOHi9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xk0/nyqvCn1QfSLE8Woty1BbZfxXsFBnQaNYiTiTyf6VMVMhhrILhoIoZvU2Xu5OK
         7qxIZgBiDwdHgJhu5laH+WjDAr49RPh0Aa31qFmW7pdoUbcUjeZ4+aDbxwexPDPIsM
         QPJxFSsxJIAMvvn2JKSMjO/leeUA0av30TFEDtyJFMbw2TgmNmC9RH9Re1mCy7gHKL
         /deKQX46l3pqElg78JoTCIFGd73WbvLSWbwsP1ee9OmuQAnD95jDy67KX9YC/XQlTU
         1aiuJve5npcTtEFYDgp/DPGAKuMHsUG07kPpSBaRIyjuCOmfYcQ8GTg9SujxofB6aR
         EtFeswrivXhnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 35/74] bpf: Fix off-by-one in tail call count limiting
Date:   Thu,  9 Sep 2021 07:56:47 -0400
Message-Id: <20210909115726.149004-35-sashal@kernel.org>
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
index d2b6d2459aad..b4a35c11bc92 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1198,7 +1198,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 
 		if (unlikely(index >= array->map.max_entries))
 			goto out;
-		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
+		if (unlikely(tail_call_cnt >= MAX_TAIL_CALL_CNT))
 			goto out;
 
 		tail_call_cnt++;
-- 
2.30.2

