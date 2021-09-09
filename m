Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00D3405649
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359456AbhIINTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358648AbhIINJN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:09:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69A20632C0;
        Thu,  9 Sep 2021 12:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188852;
        bh=HXg2EAsfswgdaMEqXNZyPHVaUwaK6K60ROOA+Oof4n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S00XlqBLggCjw8ObQQUCfsO0AotaXVAdb0TJiDBLykqdc7UfED0CufLCCVbnr9me+
         eFbpHbGwmqtMRdAnrho52IwASLKam2VjN9iKTiXGvopA270ZvAYiJRQTk82vZ70Pmy
         nQzfq5Yd/1ZG9tNlm4NPui4ZxxNW5iRLfW7v2UVPSG/9X71OCfojT7I9aXO7Jx4ADk
         6e3k5G3amfNAHKfJbw8Hq7LS0gi8jTCdxoYOUHHL2ojYHaOmG/82IcJweTiP3xLjU2
         /bXkZFfkGSSQ02Dws+wGKtbOpwfFRCuPFb7Z1iL+FQ3wpuYGnowV6CKq2q2XB7AOlY
         1rE94ZZRfJ2zA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 29/48] bpf: Fix off-by-one in tail call count limiting
Date:   Thu,  9 Sep 2021 07:59:56 -0400
Message-Id: <20210909120015.150411-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120015.150411-1-sashal@kernel.org>
References: <20210909120015.150411-1-sashal@kernel.org>
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
index df2ebce927ec..3e1d03512a4f 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -774,7 +774,7 @@ static unsigned int __bpf_prog_run(void *ctx, const struct bpf_insn *insn)
 
 		if (unlikely(index >= array->map.max_entries))
 			goto out;
-		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
+		if (unlikely(tail_call_cnt >= MAX_TAIL_CALL_CNT))
 			goto out;
 
 		tail_call_cnt++;
-- 
2.30.2

