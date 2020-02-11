Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D188C158BB5
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 10:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgBKJTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 04:19:44 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:50232 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727684AbgBKJTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 04:19:44 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Feb 2020 11:19:37 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01B9Jbgv031153;
        Tue, 11 Feb 2020 11:19:37 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        pablo@netfilter.org, marcelo.leitner@gmail.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 2/4] net: sched: refactor police action helpers to require tcf_lock
Date:   Tue, 11 Feb 2020 11:19:16 +0200
Message-Id: <20200211091918.20974-3-vladbu@mellanox.com>
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
translator, change rcu_dereference_bh_rtnl() to rcu_dereference_protected()
in police action helpers that provide external access to rate and burst
values. This is safe to do because the functions are not called from
anywhere else outside flow_action infrastructure which was modified to
obtain tcf_lock when accessing action data in one of previous patches in
the series.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/tc_act/tc_police.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
index cfdc7cb82cad..f098ad4424be 100644
--- a/include/net/tc_act/tc_police.h
+++ b/include/net/tc_act/tc_police.h
@@ -54,7 +54,8 @@ static inline u64 tcf_police_rate_bytes_ps(const struct tc_action *act)
 	struct tcf_police *police = to_police(act);
 	struct tcf_police_params *params;
 
-	params = rcu_dereference_bh_rtnl(police->params);
+	params = rcu_dereference_protected(police->params,
+					   lockdep_is_held(&police->tcf_lock));
 	return params->rate.rate_bytes_ps;
 }
 
@@ -63,7 +64,8 @@ static inline s64 tcf_police_tcfp_burst(const struct tc_action *act)
 	struct tcf_police *police = to_police(act);
 	struct tcf_police_params *params;
 
-	params = rcu_dereference_bh_rtnl(police->params);
+	params = rcu_dereference_protected(police->params,
+					   lockdep_is_held(&police->tcf_lock));
 	return params->tcfp_burst;
 }
 
-- 
2.21.0

