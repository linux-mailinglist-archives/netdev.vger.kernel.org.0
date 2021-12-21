Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF4247B7A6
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhLUCAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:00:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34068 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbhLUB7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:59:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01FE2B81107;
        Tue, 21 Dec 2021 01:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E61C36AE9;
        Tue, 21 Dec 2021 01:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051990;
        bh=q56eBt40rjHg0j3kYwQn+NOQ7lgB5BPallT4lmOza94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTW12Lwd/1T2x2yp9blT1wnv8+HxwS2lhaIKMVUF2Pw+OofoWalkaJV0xCUrkaf/s
         nbmx8CV5dq6FcmTj3q+wzugk+U5Mz3fXWf73hCNJ6xpaLq7dGTJzpQlk4poTLFleCC
         cfx75RYJAQIOA+T0fML3q2bPuZLp9BIEwBJcYOWkB6P80u27NDemwkiIN1oRDZ/Ncc
         hUmvejHYWCDlmuc8N0JFgtd6diTdQfLKBD5v6ed+Xs1lFEJAD+aEDBxPGqSBgfNkEH
         m8/BxehQD59iqYqHwTGP9npBMV519V5Sacj1DHLt53RVYmp9Q1k8ZK7LtK3XQw6gPi
         yn8wyVI7IwKaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 18/19] bpf: Make 32->64 bounds propagation slightly more robust
Date:   Mon, 20 Dec 2021 20:59:13 -0500
Message-Id: <20211221015914.116767-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015914.116767-1-sashal@kernel.org>
References: <20211221015914.116767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit e572ff80f05c33cd0cb4860f864f5c9c044280b6 ]

Make the bounds propagation in __reg_assign_32_into_64() slightly more
robust and readable by aligning it similarly as we did back in the
__reg_combine_64_into_32() counterpart. Meaning, only propagate or
pessimize them as a smin/smax pair.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 95ab3f243acde..2d9e04fc696a6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1249,22 +1249,28 @@ static void __reg_bound_offset(struct bpf_reg_state *reg)
 	reg->var_off = tnum_or(tnum_clear_subreg(var64_off), var32_off);
 }
 
+static bool __reg32_bound_s64(s32 a)
+{
+	return a >= 0 && a <= S32_MAX;
+}
+
 static void __reg_assign_32_into_64(struct bpf_reg_state *reg)
 {
 	reg->umin_value = reg->u32_min_value;
 	reg->umax_value = reg->u32_max_value;
-	/* Attempt to pull 32-bit signed bounds into 64-bit bounds
-	 * but must be positive otherwise set to worse case bounds
-	 * and refine later from tnum.
+
+	/* Attempt to pull 32-bit signed bounds into 64-bit bounds but must
+	 * be positive otherwise set to worse case bounds and refine later
+	 * from tnum.
 	 */
-	if (reg->s32_min_value >= 0 && reg->s32_max_value >= 0)
-		reg->smax_value = reg->s32_max_value;
-	else
-		reg->smax_value = U32_MAX;
-	if (reg->s32_min_value >= 0)
+	if (__reg32_bound_s64(reg->s32_min_value) &&
+	    __reg32_bound_s64(reg->s32_max_value)) {
 		reg->smin_value = reg->s32_min_value;
-	else
+		reg->smax_value = reg->s32_max_value;
+	} else {
 		reg->smin_value = 0;
+		reg->smax_value = U32_MAX;
+	}
 }
 
 static void __reg_combine_32_into_64(struct bpf_reg_state *reg)
-- 
2.34.1

