Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E53F1226EB
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 09:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfLQIra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 03:47:30 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:60255 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbfLQIra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 03:47:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07486;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0TlB69Cc_1576572438;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0TlB69Cc_1576572438)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 17 Dec 2019 16:47:24 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] net: sched: unify __gnet_stats_copy_xxx() for percpu and non-percpu
Date:   Tue, 17 Dec 2019 16:47:16 +0800
Message-Id: <20191217084718.52098-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, __gnet_stats_copy_xxx() will overwrite the return value when
percpu stats are not enabled. But when percpu stats are enabled, it will
add the percpu stats to the result. This inconsistency brings confusion to
its callers.

This patch series unify the behaviour of __gnet_stats_copy_basic() and
__gnet_stats_copy_queue() for percpu and non-percpu stats and fix an
incorrect statistic for mqprio class.

- Patch 1 unified __gnet_stats_copy_xxx() for both percpu and non-percpu
- Patch 2 depending on Patch 1, fixes the problem that 'tc class show'
  for mqprio class is always 0.

Dust Li (2):
  net: sched: keep __gnet_stats_copy_xxx() same semantics for percpu
    stats
  net: sched: fix wrong class stats dumping in sch_mqprio

 net/core/gen_stats.c   |  2 ++
 net/sched/sch_mq.c     | 35 ++++++++++++-------------
 net/sched/sch_mqprio.c | 59 +++++++++++++++++++++++-------------------
 3 files changed, 51 insertions(+), 45 deletions(-)

-- 
2.19.1.3.ge56e4f7

