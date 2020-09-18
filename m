Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DDC26F33B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727214AbgIRCEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727200AbgIRCEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 148882388B;
        Fri, 18 Sep 2020 02:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394640;
        bh=z7GkIRBfIpqHZ8dIEWx/p44xdirXNH0oyPkAC+8qQJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hELPF3eHOwgMbPLMhDkjlvNB01TTvHoFcXlzEWx5U25a0b17aNa/U0r7AnT5q5pml
         aYJwxEgcmAcgG3PDjPXWjXjkJ0VI/a0s+hMJqMcFQYEZf+BkjfidIWxBsFMRQ2kZjG
         wEyyRsQ2all9I8xonizcPlpls6beeLis42wndbfM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 139/330] bpf: Remove recursion prevention from rcu free callback
Date:   Thu, 17 Sep 2020 21:57:59 -0400
Message-Id: <20200918020110.2063155-139-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 8a37963c7ac9ecb7f86f8ebda020e3f8d6d7b8a0 ]

If an element is freed via RCU then recursion into BPF instrumentation
functions is not a concern. The element is already detached from the map
and the RCU callback does not hold any locks on which a kprobe, perf event
or tracepoint attached BPF program could deadlock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200224145643.259118710@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 039d64b1bfb7d..728ffec52cf36 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -664,15 +664,7 @@ static void htab_elem_free_rcu(struct rcu_head *head)
 	struct htab_elem *l = container_of(head, struct htab_elem, rcu);
 	struct bpf_htab *htab = l->htab;
 
-	/* must increment bpf_prog_active to avoid kprobe+bpf triggering while
-	 * we're calling kfree, otherwise deadlock is possible if kprobes
-	 * are placed somewhere inside of slub
-	 */
-	preempt_disable();
-	__this_cpu_inc(bpf_prog_active);
 	htab_elem_free(htab, l);
-	__this_cpu_dec(bpf_prog_active);
-	preempt_enable();
 }
 
 static void htab_put_fd_value(struct bpf_htab *htab, struct htab_elem *l)
-- 
2.25.1

