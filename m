Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFB44158BB3
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 10:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgBKJTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 04:19:45 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35626 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727815AbgBKJTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 04:19:44 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Feb 2020 11:19:37 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01B9Jbgw031153;
        Tue, 11 Feb 2020 11:19:37 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        pablo@netfilter.org, marcelo.leitner@gmail.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 3/4] net: sched: refactor ct action helpers to require tcf_lock
Date:   Tue, 11 Feb 2020 11:19:17 +0200
Message-Id: <20200211091918.20974-4-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200211091918.20974-1-vladbu@mellanox.com>
References: <20200211091918.20974-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to remove rtnl lock dependency from flow_action representation
translator, change rtnl_dereference() to rcu_dereference_protected() in ct
action helpers that provide external access to zone and action values. This
is safe to do because the functions are not called from anywhere else
outside flow_action infrastructure which was modified to obtain tcf_lock
when accessing action data in one of previous patches in the series.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/tc_act/tc_ct.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
index bdc20ab3b88d..a8b156402873 100644
--- a/include/net/tc_act/tc_ct.h
+++ b/include/net/tc_act/tc_ct.h
@@ -33,8 +33,10 @@ struct tcf_ct {
 };
 
 #define to_ct(a) ((struct tcf_ct *)a)
-#define to_ct_params(a) ((struct tcf_ct_params *) \
-			 rtnl_dereference((to_ct(a)->params)))
+#define to_ct_params(a)							\
+	((struct tcf_ct_params *)					\
+	 rcu_dereference_protected(to_ct(a)->params,			\
+				   lockdep_is_held(&a->tcfa_lock)))
 
 static inline uint16_t tcf_ct_zone(const struct tc_action *a)
 {
-- 
2.21.0

