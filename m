Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A523C282298
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 10:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgJCIoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 04:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgJCIoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 04:44:55 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7534C061787
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 01:44:54 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOd9w-00FmcE-Od; Sat, 03 Oct 2020 10:44:52 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v3 3/5] genetlink: factor skb preparation out of ctrl_dumppolicy()
Date:   Sat,  3 Oct 2020 10:44:44 +0200
Message-Id: <20201003104138.f5f85141e735.I0e59ae414404a92143c6ed8b0b0caf7e0e0d11a0@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201003084446.59042-1-johannes@sipsolutions.net>
References: <20201003084446.59042-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We'll need this later for the per-op policy index dump.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/netlink/genetlink.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 89646b97300c..5e33c7938470 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1154,6 +1154,24 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 					      rt->maxattr);
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
@@ -1162,15 +1180,10 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 		void *hdr;
 		struct nlattr *nest;
 
-		hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
-				  cb->nlh->nlmsg_seq, &genl_ctrl,
-				  NLM_F_MULTI, CTRL_CMD_GETPOLICY);
+		hdr = ctrl_dumppolicy_prep(skb, cb);
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

