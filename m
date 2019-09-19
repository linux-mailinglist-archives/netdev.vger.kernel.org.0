Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23CEFB824B
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 22:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404602AbfISUOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 16:14:51 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58143 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404551AbfISUOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 16:14:51 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 19 Sep 2019 23:14:47 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x8JKEkHt031361;
        Thu, 19 Sep 2019 23:14:46 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net v2 0/3] Fix Qdisc destroy issues caused by adding fine-grained locking to filter API
Date:   Thu, 19 Sep 2019 23:14:35 +0300
Message-Id: <20190919201438.2383-1-vladbu@mellanox.com>
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

 include/net/sch_generic.h |  1 +
 net/sched/sch_generic.c   | 37 +++++++++++++++++++++++++------------
 net/sched/sch_htb.c       |  4 +++-
 net/sched/sch_multiq.c    | 23 ++++++++++++++++-------
 net/sched/sch_sfb.c       |  7 ++++---
 5 files changed, 49 insertions(+), 23 deletions(-)

-- 
2.21.0

