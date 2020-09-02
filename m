Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8DB25AA52
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 13:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgIBLbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 07:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgIBL3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 07:29:23 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA19DC061258
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 04:29:22 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id k15so4832279wrn.10
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 04:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1xzox0HjSFnJFTMxOWtROlHBfTBMie+4N7AnHWjIyZM=;
        b=L6onOfTbzpay30OwwGg3IPcHaxE6d6LIyT3W+yvrZkoAFdhvAS6+k/NLY7IMoA17v7
         dtE+Gvy69CJwftPTFsZUS/VMMgi7rV9/jdHrOqs8fni2FFwbb9U4AIW/jYFftY7aDRd6
         El/asmGfPS8cdjhnuVzmPsI4Uq2mIIl9nXass=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1xzox0HjSFnJFTMxOWtROlHBfTBMie+4N7AnHWjIyZM=;
        b=Bq0tPEiBn4uI/X4mi1aF82iNdujGLChTmyYIXxkeyebhaL2t0L/qUaL1c35kIWYJQ0
         ocBz7FJxWoF0JfK+YPIqqJsR7St0XQxvpp2rUnTJR7cQJGvL8I71WlqTISMuhD2IEA42
         HyjsK/OkNl0JxrgKkv86rETYkCz/uKGU0lMKbO40LB/AcQJKDRo20S6PlZXL0xf1LQ/c
         cckAk15ZtIVdjGYIWil20ZTuIAmcOcQP0l2iYqtepSQD1Re8i2ThzWGmKgPVwA6oTyH5
         Fa8rhUTgnKotFP7/uq5B39o67y0ACMvAcdMFzjwLCYC5EKbSHECBpuxL6fWJfg3gQRld
         N+vw==
X-Gm-Message-State: AOAM531Y6WcXc2Kdm0nuE2bPwANFew9ceEWksPdBhHeGulZffTwGJTaD
        z7OWe7PhHLOndtJngWaW/hbbdPDmEotJLoz4
X-Google-Smtp-Source: ABdhPJxNR+Dh/hCzJXb2xVVsTj6lnlI25agF3VeDIbDMoJyG+2SG6lIPvj2+KQ5vMWWV6KBpzXQ42A==
X-Received: by 2002:adf:ea01:: with SMTP id q1mr5257060wrm.97.1599046161074;
        Wed, 02 Sep 2020 04:29:21 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 5sm5985172wmz.22.2020.09.02.04.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 04:29:20 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 09/15] net: bridge: mcast: delete expired port groups without srcs
Date:   Wed,  2 Sep 2020 14:25:23 +0300
Message-Id: <20200902112529.1570040-10-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
References: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an expired port group is in EXCLUDE mode, then we have to turn it
into INCLUDE mode, remove all srcs with zero timer and finally remove
the group itself if there are no more srcs with an active timer.
For IGMPv2 use there would be no sources, so this will reduce to just
removing the group as before.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 0ec43d549137..aabb1fcc7fa1 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -222,15 +222,34 @@ static void br_multicast_find_del_pg(struct net_bridge *br,
 static void br_multicast_port_group_expired(struct timer_list *t)
 {
 	struct net_bridge_port_group *pg = from_timer(pg, t, timer);
+	struct net_bridge_group_src *src_ent;
 	struct net_bridge *br = pg->port->br;
+	struct hlist_node *tmp;
+	bool changed;
 
 	spin_lock(&br->multicast_lock);
 	if (!netif_running(br->dev) || timer_pending(&pg->timer) ||
 	    hlist_unhashed(&pg->mglist) || pg->flags & MDB_PG_FLAGS_PERMANENT)
 		goto out;
 
-	br_multicast_find_del_pg(br, pg);
+	changed = !!(pg->filter_mode == MCAST_EXCLUDE);
+	pg->filter_mode = MCAST_INCLUDE;
+	hlist_for_each_entry_safe(src_ent, tmp, &pg->src_list, node) {
+		if (!timer_pending(&src_ent->timer)) {
+			br_multicast_del_group_src(src_ent);
+			changed = true;
+		}
+	}
 
+	if (hlist_empty(&pg->src_list)) {
+		br_multicast_find_del_pg(br, pg);
+	} else if (changed) {
+		struct net_bridge_mdb_entry *mp = br_mdb_ip_get(br, &pg->addr);
+
+		if (WARN_ON(!mp))
+			goto out;
+		br_mdb_notify(br->dev, mp, pg, RTM_NEWMDB);
+	}
 out:
 	spin_unlock(&br->multicast_lock);
 }
-- 
2.25.4

