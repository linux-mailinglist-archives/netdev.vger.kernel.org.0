Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3DBD139541
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 16:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgAMPxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 10:53:09 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38732 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728734AbgAMPxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 10:53:07 -0500
Received: by mail-lj1-f193.google.com with SMTP id w1so10652139ljh.5
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 07:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OEK3+d3CKz1mIylcZTyAVylsHfHcJSc3xiPKTSlMW5U=;
        b=JJyBw1Bdfdn/DXRctvYndAg0AuUSmUbCaylTOhEiNjsqQ4f8/QE2UFY4NwHHcEoUer
         PxkGvdOOeAZjIRYdL5wT/4tn7JNvJXR+mR85wrex6ZvWA0Q+luITCfvZer6p8kb4tklp
         Ol0ihmY5HpDqO4oyPFKgU4aK/H0vKrHxvdeXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OEK3+d3CKz1mIylcZTyAVylsHfHcJSc3xiPKTSlMW5U=;
        b=nc9Tkww9mfzdcvZFjpKJjTk6RgLVzULii1K6n7PVndJufdCUAyNrNC+p6Z/fMN8uo4
         maFT6YPjYLx1a4gTaKQv+jMSdab+l8jpZgxk3UvO3TNTssnVhpFgcTKXKvpi1I9/IQqX
         hhTIPBHBNWmzjzVFn+JBdLL7itM96dYfDy5Et+qQU0664tJd0xZE64aMDBQNFFPs1kU0
         7UQU1WZ/c1o0VmaVMWgX3fwr5E14RPoSQM9bXblpc/TcxAmeCCLTRV811DQs05wkCsBQ
         cFm59eRVZ7i5VYGfOU5Bh+2aVWAMdMGoRzsJum6N16iPB4qbFBf+0SnF5aDEso2jx8GD
         1N/g==
X-Gm-Message-State: APjAAAU33nGaq8wPoBok35tCaJ510W8a3L+BDVX0B/lBfLzJBu5DjSMY
        WKInPno8yy51LelZKLI27+D7iH8gi9A=
X-Google-Smtp-Source: APXvYqxceAKLZyUuArHDU7dwD9jiViqFCLrqjxbUGKI+t/EoK6oZ93obLx70UWxUHq4SQzZdAUvS7A==
X-Received: by 2002:a2e:8512:: with SMTP id j18mr9188451lji.269.1578930784874;
        Mon, 13 Jan 2020 07:53:04 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id e20sm6175658ljl.59.2020.01.13.07.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 07:53:03 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 2/8] net: bridge: netlink: add extack error messages when processing vlans
Date:   Mon, 13 Jan 2020 17:52:27 +0200
Message-Id: <20200113155233.20771-3-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
References: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add extack messages on vlan processing errors. We need to move the flags
missing check after the "last" check since we may have "last" set but
lack a range end flag in the next entry.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_netlink.c |  6 +++---
 net/bridge/br_private.h | 38 +++++++++++++++++++++++++++-----------
 2 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 14100e8653e6..40942cece51a 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -568,11 +568,11 @@ static int br_process_vlan_info(struct net_bridge *br,
 				bool *changed,
 				struct netlink_ext_ack *extack)
 {
-	if (!br_vlan_valid_id(vinfo_curr->vid))
+	if (!br_vlan_valid_id(vinfo_curr->vid, extack))
 		return -EINVAL;
 
 	if (vinfo_curr->flags & BRIDGE_VLAN_INFO_RANGE_BEGIN) {
-		if (!br_vlan_valid_range(vinfo_curr, *vinfo_last))
+		if (!br_vlan_valid_range(vinfo_curr, *vinfo_last, extack))
 			return -EINVAL;
 		*vinfo_last = vinfo_curr;
 		return 0;
@@ -582,7 +582,7 @@ static int br_process_vlan_info(struct net_bridge *br,
 		struct bridge_vlan_info tmp_vinfo;
 		int v, err;
 
-		if (!br_vlan_valid_range(vinfo_curr, *vinfo_last))
+		if (!br_vlan_valid_range(vinfo_curr, *vinfo_last, extack))
 			return -EINVAL;
 
 		memcpy(&tmp_vinfo, *vinfo_last,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index dbc0089e2c1a..a7dddc5d7790 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -507,32 +507,48 @@ static inline bool nbp_state_should_learn(const struct net_bridge_port *p)
 	return p->state == BR_STATE_LEARNING || p->state == BR_STATE_FORWARDING;
 }
 
-static inline bool br_vlan_valid_id(u16 vid)
+static inline bool br_vlan_valid_id(u16 vid, struct netlink_ext_ack *extack)
 {
-	return vid > 0 && vid < VLAN_VID_MASK;
+	bool ret = vid > 0 && vid < VLAN_VID_MASK;
+
+	if (!ret)
+		NL_SET_ERR_MSG_MOD(extack, "Vlan id is invalid");
+
+	return ret;
 }
 
 static inline bool br_vlan_valid_range(const struct bridge_vlan_info *cur,
-				       const struct bridge_vlan_info *last)
+				       const struct bridge_vlan_info *last,
+				       struct netlink_ext_ack *extack)
 {
 	/* pvid flag is not allowed in ranges */
-	if (cur->flags & BRIDGE_VLAN_INFO_PVID)
-		return false;
-
-	/* check for required range flags */
-	if (!(cur->flags & (BRIDGE_VLAN_INFO_RANGE_BEGIN |
-			    BRIDGE_VLAN_INFO_RANGE_END)))
+	if (cur->flags & BRIDGE_VLAN_INFO_PVID) {
+		NL_SET_ERR_MSG_MOD(extack, "Pvid isn't allowed in a range");
 		return false;
+	}
 
 	/* when cur is the range end, check if:
 	 *  - it has range start flag
 	 *  - range ids are invalid (end is equal to or before start)
 	 */
 	if (last) {
-		if (cur->flags & BRIDGE_VLAN_INFO_RANGE_BEGIN)
+		if (cur->flags & BRIDGE_VLAN_INFO_RANGE_BEGIN) {
+			NL_SET_ERR_MSG_MOD(extack, "Found a new vlan range start while processing one");
 			return false;
-		else if (cur->vid <= last->vid)
+		} else if (!(cur->flags & BRIDGE_VLAN_INFO_RANGE_END)) {
+			NL_SET_ERR_MSG_MOD(extack, "Vlan range end flag is missing");
 			return false;
+		} else if (cur->vid <= last->vid) {
+			NL_SET_ERR_MSG_MOD(extack, "End vlan id is less than or equal to start vlan id");
+			return false;
+		}
+	}
+
+	/* check for required range flags */
+	if (!(cur->flags & (BRIDGE_VLAN_INFO_RANGE_BEGIN |
+			    BRIDGE_VLAN_INFO_RANGE_END))) {
+		NL_SET_ERR_MSG_MOD(extack, "Both vlan range flags are missing");
+		return false;
 	}
 
 	return true;
-- 
2.21.0

