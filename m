Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F401113953F
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 16:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgAMPxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 10:53:06 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40717 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgAMPxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 10:53:05 -0500
Received: by mail-lj1-f194.google.com with SMTP id u1so10643563ljk.7
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 07:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M7dGQIqTzWEMkio4akH4cg6mHCfmnNJAqzweWg3IPew=;
        b=EU4bgx6u3way6NIjZxOKnjaxf5SMcZiKh9iSgZ5u9/HIZCReVaZuyG69vKvYSBobDb
         Nsx/vpkTqKnICdEWR9BlIpGxlST3LRbGo1z1E+ytuGEFM4n/Wf2sz0OJjsEb5MQUJwbS
         ynrIClQV+ZYNfFgSemAMwnqXgIPTukyJbrVJI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M7dGQIqTzWEMkio4akH4cg6mHCfmnNJAqzweWg3IPew=;
        b=GIEqtJkbuoD1DjrO25JN8hwChi7y+zdsBRs8yDYT0mIgm4J75qnFWuJKkc+Rdqvl0p
         jQqir6jtReSt9A+iP3zMJm9CrWk1S4XzXeCnT51LzdW1DaiWRZRPZAeCwweGCgezoaNO
         RWUjotRqjWhK0gLiggYF4BcKob7ZCg2NYaAwTQcyP6Zh2q/LWRr8ZDJmaBL8swJ+FyBj
         U/7qCLgORX86ZGqOMZaXN5Y93j9MjqxxdBkCYEmU4VKgHG70aDpqhl1JECU8Zk7pMmlH
         qMDA+0j/VBN7ghGZtRRLQ2ITUuzUZbe1sIMsIurXgWYQ8YNIe8YAiABAJXkkX5aX5lQw
         H26A==
X-Gm-Message-State: APjAAAVrvcCpirJGtSKFkn4Dp80qfYT4MpSJTtMQoU9Unph5Cyq40Hpj
        OBXmidSi9uxApmszDeFCT3byASJCZIU=
X-Google-Smtp-Source: APXvYqwkJWoH9wyx/Px9XxfQjuyYN60dv/K4oOZrE8L7SAezrGIqb8W8QhGyYt389PhEKdCNn5mQoQ==
X-Received: by 2002:a2e:721a:: with SMTP id n26mr11317377ljc.128.1578930782863;
        Mon, 13 Jan 2020 07:53:02 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id e20sm6175658ljl.59.2020.01.13.07.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 07:53:02 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 1/8] net: bridge: vlan: add helpers to check for vlan id/range validity
Date:   Mon, 13 Jan 2020 17:52:26 +0200
Message-Id: <20200113155233.20771-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
References: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helpers to check if a vlan id or range are valid. The range helper
must be called when range start or end are detected.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_netlink.c | 13 +++----------
 net/bridge/br_private.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 60136575aea4..14100e8653e6 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -568,17 +568,13 @@ static int br_process_vlan_info(struct net_bridge *br,
 				bool *changed,
 				struct netlink_ext_ack *extack)
 {
-	if (!vinfo_curr->vid || vinfo_curr->vid >= VLAN_VID_MASK)
+	if (!br_vlan_valid_id(vinfo_curr->vid))
 		return -EINVAL;
 
 	if (vinfo_curr->flags & BRIDGE_VLAN_INFO_RANGE_BEGIN) {
-		/* check if we are already processing a range */
-		if (*vinfo_last)
+		if (!br_vlan_valid_range(vinfo_curr, *vinfo_last))
 			return -EINVAL;
 		*vinfo_last = vinfo_curr;
-		/* don't allow range of pvids */
-		if ((*vinfo_last)->flags & BRIDGE_VLAN_INFO_PVID)
-			return -EINVAL;
 		return 0;
 	}
 
@@ -586,10 +582,7 @@ static int br_process_vlan_info(struct net_bridge *br,
 		struct bridge_vlan_info tmp_vinfo;
 		int v, err;
 
-		if (!(vinfo_curr->flags & BRIDGE_VLAN_INFO_RANGE_END))
-			return -EINVAL;
-
-		if (vinfo_curr->vid <= (*vinfo_last)->vid)
+		if (!br_vlan_valid_range(vinfo_curr, *vinfo_last))
 			return -EINVAL;
 
 		memcpy(&tmp_vinfo, *vinfo_last,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index f540f3bdf294..dbc0089e2c1a 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -507,6 +507,37 @@ static inline bool nbp_state_should_learn(const struct net_bridge_port *p)
 	return p->state == BR_STATE_LEARNING || p->state == BR_STATE_FORWARDING;
 }
 
+static inline bool br_vlan_valid_id(u16 vid)
+{
+	return vid > 0 && vid < VLAN_VID_MASK;
+}
+
+static inline bool br_vlan_valid_range(const struct bridge_vlan_info *cur,
+				       const struct bridge_vlan_info *last)
+{
+	/* pvid flag is not allowed in ranges */
+	if (cur->flags & BRIDGE_VLAN_INFO_PVID)
+		return false;
+
+	/* check for required range flags */
+	if (!(cur->flags & (BRIDGE_VLAN_INFO_RANGE_BEGIN |
+			    BRIDGE_VLAN_INFO_RANGE_END)))
+		return false;
+
+	/* when cur is the range end, check if:
+	 *  - it has range start flag
+	 *  - range ids are invalid (end is equal to or before start)
+	 */
+	if (last) {
+		if (cur->flags & BRIDGE_VLAN_INFO_RANGE_BEGIN)
+			return false;
+		else if (cur->vid <= last->vid)
+			return false;
+	}
+
+	return true;
+}
+
 static inline int br_opt_get(const struct net_bridge *br,
 			     enum net_bridge_opts opt)
 {
-- 
2.21.0

