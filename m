Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0D344120
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388707AbfFMQMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:12:10 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34259 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728857AbfFMQMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 12:12:10 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 13 Jun 2019 19:12:07 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.213.18.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5DGC7e3024853;
        Thu, 13 Jun 2019 19:12:07 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, daniel@iogearbox.net,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next] net: sched: ingress: set 'unlocked' flag for clsact Qdisc ops
Date:   Thu, 13 Jun 2019 19:12:05 +0300
Message-Id: <20190613161205.2689-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To remove rtnl lock dependency in tc filter update API when using clsact
Qdisc, set QDISC_CLASS_OPS_DOIT_UNLOCKED flag in clsact Qdisc_class_ops.

Clsact Qdisc ops don't require any modifications to be used without rtnl
lock on tc filter update path. Implementation never changes its q->block
and only releases it when Qdisc is being destroyed. This means it is enough
for RTM_{NEWTFILTER|DELTFILTER|GETTFILTER} message handlers to hold clsact
Qdisc reference while using it without relying on rtnl lock protection.
Unlocked Qdisc ops support is already implemented in filter update path by
unlocked cls API patch set.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 net/sched/sch_ingress.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index d5382554e281..599730f804d7 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -247,6 +247,7 @@ static void clsact_destroy(struct Qdisc *sch)
 }
 
 static const struct Qdisc_class_ops clsact_class_ops = {
+	.flags		=	QDISC_CLASS_OPS_DOIT_UNLOCKED,
 	.leaf		=	ingress_leaf,
 	.find		=	clsact_find,
 	.walk		=	ingress_walk,
-- 
2.21.0

