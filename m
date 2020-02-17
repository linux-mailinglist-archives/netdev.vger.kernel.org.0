Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075B1160FAC
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 11:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgBQKMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 05:12:45 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33252 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729098AbgBQKMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 05:12:45 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 17 Feb 2020 12:12:38 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01HACcAP017557;
        Mon, 17 Feb 2020 12:12:38 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        pablo@netfilter.org, marcelo.leitner@gmail.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [RESEND PATCH net-next 2/4] net: sched: refactor police action helpers to require tcf_lock
Date:   Mon, 17 Feb 2020 12:12:10 +0200
Message-Id: <20200217101212.5979-3-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200217101212.5979-1-vladbu@mellanox.com>
References: <20200217101212.5979-1-vladbu@mellanox.com>
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

