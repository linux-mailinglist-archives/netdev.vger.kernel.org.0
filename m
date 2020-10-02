Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6988280F8F
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 11:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387700AbgJBJJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 05:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387644AbgJBJJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 05:09:56 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A92C0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 02:09:56 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOH4b-00F9QD-U6; Fri, 02 Oct 2020 11:09:54 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/5] genetlink: factor skb preparation out of ctrl_dumppolicy()
Date:   Fri,  2 Oct 2020 11:09:43 +0200
Message-Id: <20201002110205.ce65a163aebd.I0e59ae414404a92143c6ed8b0b0caf7e0e0d11a0@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002090944.195891-1-johannes@sipsolutions.net>
References: <20201002090944.195891-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We'll need this later for the per-op policy index dump.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/netlink/genetlink.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 42777749d4d8..0ab9549e30ee 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1168,23 +1168,35 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 					      op.maxattr);
 }
 
+static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
+				  struct netlink_callback *cb)
+{
+	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
+	void *hdr;
+
+	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
+			  cb->nlh->nlmsg_seq, &genl_ctrl,
+			  NLM_F_MULTI, CTRL_CMD_GETPOLICY);
+	if (!hdr)
+		return NULL;
+
+	if (nla_put_u16(skb, CTRL_ATTR_FAMILY_ID, ctx->fam_id))
+		return NULL;
+
+	return hdr;
+}
+
 static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
 
 	while (netlink_policy_dump_loop(ctx->state)) {
-		void *hdr;
+		void *hdr = ctrl_dumppolicy_prep(skb, cb);
 		struct nlattr *nest;
 
-		hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
-				  cb->nlh->nlmsg_seq, &genl_ctrl,
-				  NLM_F_MULTI, CTRL_CMD_GETPOLICY);
 		if (!hdr)
 			goto nla_put_failure;
 
-		if (nla_put_u16(skb, CTRL_ATTR_FAMILY_ID, ctx->fam_id))
-			goto nla_put_failure;
-
 		nest = nla_nest_start(skb, CTRL_ATTR_POLICY);
 		if (!nest)
 			goto nla_put_failure;
-- 
2.26.2

