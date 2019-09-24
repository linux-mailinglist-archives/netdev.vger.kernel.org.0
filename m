Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E503BCBD6
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390648AbfIXPvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:51:25 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:46810 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389921AbfIXPvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:51:25 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 24 Sep 2019 18:51:22 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x8OFpMls010930;
        Tue, 24 Sep 2019 18:51:22 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net v3 0/3] Fix Qdisc destroy issues caused by adding fine-grained locking to filter API
Date:   Tue, 24 Sep 2019 18:51:15 +0300
Message-Id: <20190924155118.2488-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TC filter API unlocking introduced several new fine-grained locks. The
change caused sleeping-while-atomic BUGs in several Qdiscs that call cls
APIs which need to obtain new mutex while holding sch tree spinlock. This
series fixes affected Qdiscs by ensuring that cls API that became sleeping
is only called outside of sch tree lock critical section.

Vlad Buslov (3):
  net: sched: sch_htb: don't call qdisc_put() while holding tree lock
  net: sched: multiq: don't call qdisc_put() while holding tree lock
  net: sched: sch_sfb: don't call qdisc_put() while holding tree lock

 net/sched/sch_htb.c    |  4 +++-
 net/sched/sch_multiq.c | 23 ++++++++++++++++-------
 net/sched/sch_sfb.c    |  7 ++++---
 3 files changed, 23 insertions(+), 11 deletions(-)

-- 
2.21.0

