Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD0F441D46
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 09:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407995AbfFLHOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 03:14:42 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59547 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2405266AbfFLHOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 03:14:41 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Jun 2019 10:14:39 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.213.18.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5C7Ecxj020922;
        Wed, 12 Jun 2019 10:14:38 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next] net: sched: ingress: set 'unlocked' flag for Qdisc ops
Date:   Wed, 12 Jun 2019 10:14:35 +0300
Message-Id: <20190612071435.7367-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To remove rtnl lock dependency in tc filter update API when using ingress
Qdisc, set QDISC_CLASS_OPS_DOIT_UNLOCKED flag in ingress Qdisc_class_ops.

Ingress Qdisc ops don't require any modifications to be used without rtnl
lock on tc filter update path. Ingress implementation never changes its
q->block and only releases it when Qdisc is being destroyed. This means it
is enough for RTM_{NEWTFILTER|DELTFILTER|GETTFILTER} message handlers to
hold ingress Qdisc reference while using it without relying on rtnl lock
protection. Unlocked Qdisc ops support is already implemented in filter
update path by unlocked cls API patch set.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 net/sched/sch_ingress.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index 0f65f617756b..d5382554e281 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -114,6 +114,7 @@ static int ingress_dump(struct Qdisc *sch, struct sk_buff *skb)
 }
 
 static const struct Qdisc_class_ops ingress_class_ops = {
+	.flags		=	QDISC_CLASS_OPS_DOIT_UNLOCKED,
 	.leaf		=	ingress_leaf,
 	.find		=	ingress_find,
 	.walk		=	ingress_walk,
-- 
2.21.0

