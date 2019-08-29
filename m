Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D11E8A207E
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 18:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbfH2QP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 12:15:29 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:46489 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727344AbfH2QP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 12:15:28 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 29 Aug 2019 19:15:24 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7TGFNlt031066;
        Thu, 29 Aug 2019 19:15:23 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, saeedm@mellanox.com, idosch@mellanox.com,
        sergei.shtylyov@cogentembedded.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next v2 1/2] net: sched: cls_matchall: cleanup flow_action before deallocating
Date:   Thu, 29 Aug 2019 19:15:16 +0300
Message-Id: <20190829161517.20935-2-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190829161517.20935-1-vladbu@mellanox.com>
References: <20190829161517.20935-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent rtnl lock removal patch changed flow_action infra to require proper
cleanup besides simple memory deallocation. However, matchall classifier
was not updated to call tc_cleanup_flow_action(). Add proper cleanup to
mall_replace_hw_filter() and mall_reoffload().

Fixes: 5a6ff4b13d59 ("net: sched: take reference to action dev before calling offloads")
Reported-by: Ido Schimmel <idosch@mellanox.com>
Tested-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 net/sched/cls_matchall.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 3266f25011cc..7fc2eb62aa98 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -111,6 +111,7 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 
 	err = tc_setup_cb_add(block, tp, TC_SETUP_CLSMATCHALL, &cls_mall,
 			      skip_sw, &head->flags, &head->in_hw_count, true);
+	tc_cleanup_flow_action(&cls_mall.rule->action);
 	kfree(cls_mall.rule);
 
 	if (err) {
@@ -313,6 +314,7 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 	err = tc_setup_cb_reoffload(block, tp, add, cb, TC_SETUP_CLSMATCHALL,
 				    &cls_mall, cb_priv, &head->flags,
 				    &head->in_hw_count);
+	tc_cleanup_flow_action(&cls_mall.rule->action);
 	kfree(cls_mall.rule);
 
 	if (err)
-- 
2.21.0

