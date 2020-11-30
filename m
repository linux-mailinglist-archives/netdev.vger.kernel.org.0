Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5D22C8E21
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 20:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgK3TeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 14:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgK3TeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 14:34:04 -0500
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407D3C0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 11:33:19 -0800 (PST)
Received: from vlad-x1g6.localdomain (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 829611FC5B;
        Mon, 30 Nov 2020 21:33:16 +0200 (EET)
From:   Vlad Buslov <vlad@buslov.dev>
To:     jhs@mojatatu.com, dsahern@gmail.com, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Vlad Buslov <vlad@buslov.dev>
Subject: [PATCH iproute2-next 1/2] tc: use TCA_ACT_ prefix for action flags
Date:   Mon, 30 Nov 2020 21:32:49 +0200
Message-Id: <20201130193250.81308-2-vlad@buslov.dev>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130193250.81308-1-vlad@buslov.dev>
References: <20201130193250.81308-1-vlad@buslov.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use TCA_ACT_FLAG_LARGE_DUMP_ON alias according to new preferred naming for
action flags.

Signed-off-by: Vlad Buslov <vlad@buslov.dev>
---
 include/uapi/linux/rtnetlink.h | 12 +++++++-----
 tc/m_action.c                  |  4 ++--
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 749878a5a6f2..c66fd247d90a 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -766,16 +766,18 @@ enum {
 #define TA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct tcamsg))
 /* tcamsg flags stored in attribute TCA_ROOT_FLAGS
  *
- * TCA_FLAG_LARGE_DUMP_ON user->kernel to request for larger than TCA_ACT_MAX_PRIO
- * actions in a dump. All dump responses will contain the number of actions
- * being dumped stored in for user app's consumption in TCA_ROOT_COUNT
+ * TCA_ACT_FLAG_LARGE_DUMP_ON user->kernel to request for larger than
+ * TCA_ACT_MAX_PRIO actions in a dump. All dump responses will contain the
+ * number of actions being dumped stored in for user app's consumption in
+ * TCA_ROOT_COUNT
  *
- * TCA_FLAG_TERSE_DUMP user->kernel to request terse (brief) dump that only
+ * TCA_ACT_FLAG_TERSE_DUMP user->kernel to request terse (brief) dump that only
  * includes essential action info (kind, index, etc.)
  *
  */
 #define TCA_FLAG_LARGE_DUMP_ON		(1 << 0)
-#define TCA_FLAG_TERSE_DUMP		(1 << 1)
+#define TCA_ACT_FLAG_LARGE_DUMP_ON	TCA_FLAG_LARGE_DUMP_ON
+#define TCA_ACT_FLAG_TERSE_DUMP		(1 << 1)
 
 /* New extended info filters for IFLA_EXT_MASK */
 #define RTEXT_FILTER_VF		(1 << 0)
diff --git a/tc/m_action.c b/tc/m_action.c
index 66e672453c25..77ff4a8d4126 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -735,8 +735,8 @@ static int tc_act_list_or_flush(int *argc_p, char ***argv_p, int event)
 	addattr_nest_end(&req.n, tail);
 
 	tail3 = NLMSG_TAIL(&req.n);
-	flag_select.value |= TCA_FLAG_LARGE_DUMP_ON;
-	flag_select.selector |= TCA_FLAG_LARGE_DUMP_ON;
+	flag_select.value |= TCA_ACT_FLAG_LARGE_DUMP_ON;
+	flag_select.selector |= TCA_ACT_FLAG_LARGE_DUMP_ON;
 	addattr_l(&req.n, MAX_MSG, TCA_ROOT_FLAGS, &flag_select,
 		  sizeof(struct nla_bitfield32));
 	tail3->rta_len = (void *) NLMSG_TAIL(&req.n) - (void *) tail3;
-- 
2.29.2

