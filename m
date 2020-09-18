Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530AA26EE40
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbgIRC1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729292AbgIRCPt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:15:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32A302388B;
        Fri, 18 Sep 2020 02:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395346;
        bh=1RB9PptwezVIEq4RXFnWE/U6qsX71aoTnZ18odfUcek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzlQkwKUstQAot3zAJ8ctxPU2o6RHVJQZST0/to/sMmvHDZdBhXIpzcfDW0iD2y2X
         MhZlyvBGmYOk61vOS///2eNcH3OC5SBWNkdQAxbtwUPIAlfYQkpiOrGSY3/T4ajtm3
         Ux5XpfMs6HmRmVSwuJenRSnN9Sppu+L6GZiwbESI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 42/90] bpf: Remove recursion prevention from rcu free callback
Date:   Thu, 17 Sep 2020 22:14:07 -0400
Message-Id: <20200918021455.2067301-42-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
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
index 8648d7d297081..1253261fdb3ba 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -427,15 +427,7 @@ static void htab_elem_free_rcu(struct rcu_head *head)
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
 
 static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
-- 
2.25.1

