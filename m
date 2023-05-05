Return-Path: <netdev+bounces-549-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D3E86F818E
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:24:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12D46280F80
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 11:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C95476D1B;
	Fri,  5 May 2023 11:24:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0F0156C6
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 11:24:28 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094701A124;
	Fri,  5 May 2023 04:24:26 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QCSsH57DqzZfkS;
	Fri,  5 May 2023 19:20:19 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 5 May
 2023 19:24:23 +0800
From: Liu Jian <liujian56@huawei.com>
To: <corbet@lwn.net>, <paulmck@kernel.org>, <frederic@kernel.org>,
	<quic_neeraju@quicinc.com>, <joel@joelfernandes.org>,
	<josh@joshtriplett.org>, <boqun.feng@gmail.com>, <rostedt@goodmis.org>,
	<mathieu.desnoyers@efficios.com>, <jiangshanlai@gmail.com>,
	<qiang1.zhang@intel.com>, <jstultz@google.com>, <tglx@linutronix.de>,
	<sboyd@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <peterz@infradead.org>,
	<frankwoo@google.com>, <Rhinewuwu@google.com>
CC: <liujian56@huawei.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rcu@vger.kernel.org>,
	<netdev@vger.kernel.org>
Subject: [PATCH 0/9] fix softlockup in run_timer_softirq
Date: Fri, 5 May 2023 19:33:06 +0800
Message-ID: <20230505113315.3307723-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I encountered the run_timer_softirq lockup issue[1] many times during fuzz
tests. We analyze __run_timers() and find the following problem.

In the while loop of __run_timers(), because there are too many timers or
improper timer handler functions, if the processing time of the expired
timers is always greater than the time wheel's next_expiry, the function
will loop infinitely.

Here base on Peter's softirq_needs_break patchset[2], use the timeout/break
logic jump out of the loop.

[1] https://lore.kernel.org/lkml/fb8d80434b2148e78c0032c6c70a8b4d@huawei.com/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git/log/?h=core/softirq

Liu Jian (1):
  softirq, timer: Use softirq_needs_break()

Peter Zijlstra (8):
  softirq: Rewrite softirq processing loop
  softirq: Use sched_clock() based timeout
  softirq: Factor loop termination condition
  softirq: Allow early break
  softirq: Context aware timeout
  softirq: Provide a softirq_needs_break() API
  softirq,net: Use softirq_needs_break()
  softirq,rcu: Use softirq_needs_break()

 Documentation/admin-guide/sysctl/net.rst | 11 +--
 include/linux/interrupt.h                |  5 ++
 kernel/rcu/tree.c                        | 29 ++-----
 kernel/rcu/tree_nocb.h                   |  2 +-
 kernel/softirq.c                         | 97 +++++++++++++++---------
 kernel/time/timer.c                      | 12 ++-
 net/core/dev.c                           |  6 +-
 net/core/dev.h                           |  1 -
 net/core/sysctl_net_core.c               |  8 --
 9 files changed, 86 insertions(+), 85 deletions(-)

-- 
2.34.1


