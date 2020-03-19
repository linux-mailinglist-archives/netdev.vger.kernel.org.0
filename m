Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB6818B855
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgCSNsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:48:13 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45595 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727034AbgCSNsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:48:12 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id EEFED5C0326;
        Thu, 19 Mar 2020 09:48:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 19 Mar 2020 09:48:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=3+nTNbGx9lnmUSn3jb4kAZP+YgM6wYBO0r6qr1hmtNM=; b=tr5DqOPR
        pSdL6Nhik1wqpmtee1O6ihIXpuzlkmJwasb8Aqy58ZLN7Lo9lY+Wxk18KQZWHE/n
        EL0G+9b/mbWXupEvvnM43C69UScfXsqz5cRmk2LklWO4N966fl0nzi25EaEfro3P
        Hpsd0cBPSKC+R9LxOtSCjh0dswvL2FIlzVOpY88+QNabHY8forqrvG8x1DrAAigX
        PX0xCTpAEjywaQ7cwBXTtb6LLFpgA2Fawb4uw9rdwzdDCBVMZFKfH0PUa3pRZqSI
        CF8dT8kJiLhNM0sM4M93YxhDfilaNn5ms+kq1fd9mCYwqkzL1+779eOTdk26T9hd
        g8KqxwPvdYmUeQ==
X-ME-Sender: <xms:G3hzXupbkm963Q5Pp3-iSb5HL6RrImfy-0EtJI33y5nUnSRJoinInw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefledgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedrudeftddrheenucevlhhushhtvghruf
    hiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:G3hzXnNshxWpqLDw6H7GZbQtyczU3jd3shtfsEDeNibevPhxLEPC2w>
    <xmx:G3hzXvyMPGO31nYXEicbLQ0FCnxIrAwK7-P2UUoE4JHZ93qXQ1JPZw>
    <xmx:G3hzXgulA9VHd-0oOlQhQ5nK39VbMy5aV2vp5gHNwsEHRqT4oW_lTw>
    <xmx:G3hzXuE6eQcK_aiSiCpaHHy0ltib9292pFG6-7RbUG4supXAJcb9yg>
Received: from splinter.mtl.com (bzq-109-66-130-5.red.bezeqint.net [109.66.130.5])
        by mail.messagingengine.com (Postfix) with ESMTPA id B4F6A3061DC5;
        Thu, 19 Mar 2020 09:48:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/5] net: tc_skbedit: Make the skbedit priority offloadable
Date:   Thu, 19 Mar 2020 15:47:21 +0200
Message-Id: <20200319134724.1036942-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319134724.1036942-1-idosch@idosch.org>
References: <20200319134724.1036942-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The skbedit action "priority" is used for adjusting SKB priority. Allow
drivers to offload the action by introducing two new skbedit getters and a
new flow action, and initializing appropriately in tc_setup_flow_action().

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/net/flow_offload.h      |  2 ++
 include/net/tc_act/tc_skbedit.h | 17 +++++++++++++++++
 net/sched/cls_api.c             |  3 +++
 3 files changed, 22 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 1e30b0d44b61..51b9893d4ccb 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -137,6 +137,7 @@ enum flow_action_id {
 	FLOW_ACTION_CSUM,
 	FLOW_ACTION_MARK,
 	FLOW_ACTION_PTYPE,
+	FLOW_ACTION_PRIORITY,
 	FLOW_ACTION_WAKE,
 	FLOW_ACTION_QUEUE,
 	FLOW_ACTION_SAMPLE,
@@ -211,6 +212,7 @@ struct flow_action_entry {
 		u32			csum_flags;	/* FLOW_ACTION_CSUM */
 		u32			mark;		/* FLOW_ACTION_MARK */
 		u16                     ptype;          /* FLOW_ACTION_PTYPE */
+		u32			priority;	/* FLOW_ACTION_PRIORITY */
 		struct {				/* FLOW_ACTION_QUEUE */
 			u32		ctx;
 			u32		index;
diff --git a/include/net/tc_act/tc_skbedit.h b/include/net/tc_act/tc_skbedit.h
index ac8ff60143fe..00bfee70609e 100644
--- a/include/net/tc_act/tc_skbedit.h
+++ b/include/net/tc_act/tc_skbedit.h
@@ -77,4 +77,21 @@ static inline u32 tcf_skbedit_ptype(const struct tc_action *a)
 	return ptype;
 }
 
+/* Return true iff action is priority */
+static inline bool is_tcf_skbedit_priority(const struct tc_action *a)
+{
+	return is_tcf_skbedit_with_flag(a, SKBEDIT_F_PRIORITY);
+}
+
+static inline u32 tcf_skbedit_priority(const struct tc_action *a)
+{
+	u32 priority;
+
+	rcu_read_lock();
+	priority = rcu_dereference(to_skbedit(a)->params)->priority;
+	rcu_read_unlock();
+
+	return priority;
+}
+
 #endif /* __NET_TC_SKBEDIT_H */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index eefacb3176e3..fb6c3660fb9a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3665,6 +3665,9 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		} else if (is_tcf_skbedit_ptype(act)) {
 			entry->id = FLOW_ACTION_PTYPE;
 			entry->ptype = tcf_skbedit_ptype(act);
+		} else if (is_tcf_skbedit_priority(act)) {
+			entry->id = FLOW_ACTION_PRIORITY;
+			entry->priority = tcf_skbedit_priority(act);
 		} else {
 			err = -EOPNOTSUPP;
 			goto err_out_locked;
-- 
2.24.1

