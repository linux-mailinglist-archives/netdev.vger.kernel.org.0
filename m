Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC3C1899E5
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 11:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgCRKuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 06:50:39 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41894 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727168AbgCRKuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 06:50:39 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 18 Mar 2020 12:50:36 +0200
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02IAoaJ8001777;
        Wed, 18 Mar 2020 12:50:36 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net] net/sched: act_ct: Fix leak of ct zone template on replace
Date:   Wed, 18 Mar 2020 12:50:33 +0200
Message-Id: <1584528633-20177-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, on replace, the previous action instance params
is swapped with a newly allocated params. The old params is
only freed (via kfree_rcu), without releasing the allocated
ct zone template related to it.

Call tcf_ct_params_free (via call_rcu) for the old params,
so it will release it.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 net/sched/act_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index f685c0d..41114b4 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -739,7 +739,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 	if (params)
-		kfree_rcu(params, rcu);
+		call_rcu(&params->rcu, tcf_ct_params_free);
 	if (res == ACT_P_CREATED)
 		tcf_idr_insert(tn, *a);
 
-- 
1.8.3.1

