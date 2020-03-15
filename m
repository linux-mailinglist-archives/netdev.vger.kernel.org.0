Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46252185EAB
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 18:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbgCORRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 13:17:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:56438 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728887AbgCORRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Mar 2020 13:17:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 79710ADFE;
        Sun, 15 Mar 2020 17:17:43 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 2AEF3E0C04; Sun, 15 Mar 2020 18:17:43 +0100 (CET)
Message-Id: <6bb18205e2876e4ab804dfc8ec141f895f2fd83a.1584292182.git.mkubecek@suse.cz>
In-Reply-To: <cover.1584292182.git.mkubecek@suse.cz>
References: <cover.1584292182.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net 1/3] netlink: allow extack cookie also for error messages
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Sun, 15 Mar 2020 18:17:43 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ba0dc5f6e0ba ("netlink: allow sending extended ACK with cookie on
success") introduced a cookie which can be sent to userspace as part of
extended ack message in the form of NLMSGERR_ATTR_COOKIE attribute.
Currently the cookie is ignored if error code is non-zero but there is
no technical reason for such limitation and it can be useful to provide
machine parseable information as part of an error message.

Include NLMSGERR_ATTR_COOKIE whenever the cookie has been set,
regardless of error code.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/netlink/af_netlink.c | 43 ++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 5313f1cec170..2f234791b879 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2392,19 +2392,14 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 	if (nlk_has_extack && extack && extack->_msg)
 		tlvlen += nla_total_size(strlen(extack->_msg) + 1);
 
-	if (err) {
-		if (!(nlk->flags & NETLINK_F_CAP_ACK))
-			payload += nlmsg_len(nlh);
-		else
-			flags |= NLM_F_CAPPED;
-		if (nlk_has_extack && extack && extack->bad_attr)
-			tlvlen += nla_total_size(sizeof(u32));
-	} else {
+	if (err && !(nlk->flags & NETLINK_F_CAP_ACK))
+		payload += nlmsg_len(nlh);
+	else
 		flags |= NLM_F_CAPPED;
-
-		if (nlk_has_extack && extack && extack->cookie_len)
-			tlvlen += nla_total_size(extack->cookie_len);
-	}
+	if (err && nlk_has_extack && extack && extack->bad_attr)
+		tlvlen += nla_total_size(sizeof(u32));
+	if (nlk_has_extack && extack && extack->cookie_len)
+		tlvlen += nla_total_size(extack->cookie_len);
 
 	if (tlvlen)
 		flags |= NLM_F_ACK_TLVS;
@@ -2427,20 +2422,16 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 			WARN_ON(nla_put_string(skb, NLMSGERR_ATTR_MSG,
 					       extack->_msg));
 		}
-		if (err) {
-			if (extack->bad_attr &&
-			    !WARN_ON((u8 *)extack->bad_attr < in_skb->data ||
-				     (u8 *)extack->bad_attr >= in_skb->data +
-							       in_skb->len))
-				WARN_ON(nla_put_u32(skb, NLMSGERR_ATTR_OFFS,
-						    (u8 *)extack->bad_attr -
-						    (u8 *)nlh));
-		} else {
-			if (extack->cookie_len)
-				WARN_ON(nla_put(skb, NLMSGERR_ATTR_COOKIE,
-						extack->cookie_len,
-						extack->cookie));
-		}
+		if (err && extack->bad_attr &&
+		    !WARN_ON((u8 *)extack->bad_attr < in_skb->data ||
+			     (u8 *)extack->bad_attr >= in_skb->data +
+						       in_skb->len))
+			WARN_ON(nla_put_u32(skb, NLMSGERR_ATTR_OFFS,
+					    (u8 *)extack->bad_attr -
+					    (u8 *)nlh));
+		if (extack->cookie_len)
+			WARN_ON(nla_put(skb, NLMSGERR_ATTR_COOKIE,
+					extack->cookie_len, extack->cookie));
 	}
 
 	nlmsg_end(skb, rep);
-- 
2.25.1

