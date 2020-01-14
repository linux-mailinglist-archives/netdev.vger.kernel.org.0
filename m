Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD5C213B17E
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 18:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgANR6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 12:58:34 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42582 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgANR6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 12:58:32 -0500
Received: by mail-lj1-f193.google.com with SMTP id y4so15387728ljj.9
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 09:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M7dGQIqTzWEMkio4akH4cg6mHCfmnNJAqzweWg3IPew=;
        b=KOyrYoPDKO/L6xfHagAIPLVBllOIvBf02OrQ4SsgBrEjWAf7oiimfkex4sixNWEiBV
         +6nt2FT4ON+JFNG6S/hfsbMQyP9M4qIzxecg0KgnJn0H4YELqwLf9ErKC7a8gETYz79I
         o2BJAH0YfjbeerHgdfsH8XybtDzGes0Rrkx/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M7dGQIqTzWEMkio4akH4cg6mHCfmnNJAqzweWg3IPew=;
        b=ofE2uqTjgAcQUmTSN2W8qPf73zep7rt11P1mN0zOmv5VKwGN49aDViNOTkn8pjPOEI
         OCDsjNrRo6ZIQ0iGZKA0gAt+EpCW372gv91KW+sYmWpVeVAIaOsVeGk2ywSdPUqYEoI0
         awGHP323n5SGgVXXmOv79ewBLxgKkTgP3HKPSBYH2RM/1Xl65YGavBk/i8/0qFjDbbjP
         3jz5vxtUNNj4A7xiksnMnMoYa/KPk5WOA+gJ/ITUlRdGVDczBsvbB1AtX8Yr813bdA0I
         r6R4kVwIvOyQKAMjc6v/KpGwBGWvZIB+TZ2okjv4CcdyxCuKTj+7BddOAJtadNxb+ftr
         Zqug==
X-Gm-Message-State: APjAAAWGDM3P4nJhgYbPeF/dMTWAEo0gKC2zbLibg+3/NT8AHOjUccUF
        9KeffQXKpaI2iAFzlz0fpTO4Kj2lz00=
X-Google-Smtp-Source: APXvYqxcLZRY3/TOPTNVim2eGLUxFCGINorQpID+jv3qnjDdBIE71omVW0RrCPu8IIaG8Ak9h0xU1g==
X-Received: by 2002:a05:651c:1b0:: with SMTP id c16mr15378691ljn.236.1579024710559;
        Tue, 14 Jan 2020 09:58:30 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a15sm7685655lfi.60.2020.01.14.09.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 09:58:29 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org,
        bridge@lists.linux-foundation.org, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 1/8] net: bridge: vlan: add helpers to check for vlan id/range validity
Date:   Tue, 14 Jan 2020 19:56:07 +0200
Message-Id: <20200114175614.17543-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200114175614.17543-1-nikolay@cumulusnetworks.com>
References: <20200114175614.17543-1-nikolay@cumulusnetworks.com>
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

