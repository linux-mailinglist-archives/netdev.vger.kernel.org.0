Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938BB26C85A
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 20:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgIPSqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 14:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbgIPSqF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 14:46:05 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7611F20809;
        Wed, 16 Sep 2020 18:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600281965;
        bh=nZOBAZJ8i1B5WAzn9kzW9pRaFqxTgYJjGm/mivE6qmw=;
        h=From:To:Cc:Subject:Date:From;
        b=Jie/Eo0tJ3qXhcAezeLBEEvASq6q5gjMQ35bdggOj357YUbOIkFQe3/fE7YbRPHWQ
         AALflh1PUDV+9vnLDYvfFOf7H/nxqT+v/hagP8U0JYeUd19yRfKS0nx39LGyfiCqba
         J3g4XpbWrqpoPyMp++XyYWs1iRbIM5dVtrEV5giI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, paulmck@kernel.org, joel@joelfernandes.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, josh@joshtriplett.org, peterz@infradead.org,
        christian.brauner@ubuntu.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/7] rcu: prevent RCU_LOCKDEP_WARN() from swallowing  the condition
Date:   Wed, 16 Sep 2020 11:45:21 -0700
Message-Id: <20200916184528.498184-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

So I unfolded the RFC patch into smaller chunks and fixed an issue
in SRCU pointed out by build bot. Build bot has been quiet for
a day but I'm not 100% sure it's scanning my tree, so let's
give these patches some ML exposure.

The motivation here is that we run into a unused variable
warning in networking code because RCU_LOCKDEP_WARN() makes
its argument disappear with !LOCKDEP / !PROVE_RCU. We marked
the variable as __maybe_unused, but that's ugly IMHO.

This set makes the relevant function declarations visible to
the compiler and uses (0 && (condition)) to make the compiler
remove those calls before linker realizes they are never defined.

I'm tentatively marking these for net-next, but if anyone (Paul?)
wants to take them into their tree - even better.

Jakub Kicinski (7):
  sched: un-hide lockdep_tasklist_lock_is_held() for !LOCKDEP
  rcu: un-hide lockdep maps for !LOCKDEP
  net: un-hide lockdep_sock_is_held() for !LOCKDEP
  net: sched: remove broken definitions and un-hide for !LOCKDEP
  srcu: use a more appropriate lockdep helper
  lockdep: provide dummy forward declaration of *_is_held() helpers
  rcu: prevent RCU_LOCKDEP_WARN() from swallowing the condition

 include/linux/lockdep.h        |  6 ++++++
 include/linux/rcupdate.h       | 11 ++++++-----
 include/linux/rcupdate_trace.h |  4 ++--
 include/linux/sched/task.h     |  2 --
 include/net/sch_generic.h      | 12 ------------
 include/net/sock.h             |  2 --
 kernel/rcu/srcutree.c          |  2 +-
 7 files changed, 15 insertions(+), 24 deletions(-)

-- 
2.26.2

