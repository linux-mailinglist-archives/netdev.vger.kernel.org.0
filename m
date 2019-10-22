Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A46C0E0C55
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733035AbfJVTMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 15:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732990AbfJVTMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 15:12:31 -0400
Received: from localhost.localdomain (rrcs-50-75-166-42.nys.biz.rr.com [50.75.166.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9992F222C2;
        Tue, 22 Oct 2019 19:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571771550;
        bh=xvqU+DkqSwLSkL389M85X3LHYTzrsH2JRYG7WtqfMbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+ekN0hJzMU6y7DMOH26WIIjasFP1wEm2W7tmFmXMVmVnWIFEjzWc+3aEMLt1aJLf
         uqCIUtizCEUE9vYjvYO4kaIuK3ZWvUaYAB/ltFiGNOqUe5QlCYsLhrkYcTPdQ/WfCa
         hcbWtgPXvvD4um8tPHqzLemVfgPOVJ1XTi4u6pqU=
From:   paulmck@kernel.org
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mingo@kernel.org,
        jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH tip/core/rcu 06/10] bpf/cgroup: Replace rcu_swap_protected() with rcu_replace()
Date:   Tue, 22 Oct 2019 12:12:11 -0700
Message-Id: <20191022191215.25781-6-paulmck@kernel.org>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20191022191136.GA25627@paulmck-ThinkPad-P72>
References: <20191022191136.GA25627@paulmck-ThinkPad-P72>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

This commit replaces the use of rcu_swap_protected() with the more
intuitively appealing rcu_replace() as a step towards removing
rcu_swap_protected().

Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
[ paulmck: From rcu_replace() to rcu_replace_pointer() per Ingo Molnar. ]
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: <netdev@vger.kernel.org>
Cc: <bpf@vger.kernel.org>
---
 kernel/bpf/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index ddd8add..c684cf4 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -180,8 +180,8 @@ static void activate_effective_progs(struct cgroup *cgrp,
 				     enum bpf_attach_type type,
 				     struct bpf_prog_array *old_array)
 {
-	rcu_swap_protected(cgrp->bpf.effective[type], old_array,
-			   lockdep_is_held(&cgroup_mutex));
+	old_array = rcu_replace_pointer(cgrp->bpf.effective[type], old_array,
+					lockdep_is_held(&cgroup_mutex));
 	/* free prog array after grace period, since __cgroup_bpf_run_*()
 	 * might be still walking the array
 	 */
-- 
2.9.5

