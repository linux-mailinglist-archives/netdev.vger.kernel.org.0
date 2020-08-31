Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FCE257BD8
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgHaPL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgHaPKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:10:12 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC420C0619C4
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:10:05 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f7so6334492wrw.1
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yot6KwfYfw5rhPTVz46mBjLztxcuLpYs684NnYPwT1Q=;
        b=MkLoPcPvifPSOSyCHQhw2IRiKnQLQWjXYp5rBsgBXcZNFjsffeVX2njSRaz28Y60BR
         qX5d/mTzaSbWlPcj+84xYKqC1qUjoezWm+9R7/43z+y+fiatTq3nxfnEh1YJSMW2/b5f
         mhMlDXKet306eumKKlUVAJwYrfiybvriGp8Hw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yot6KwfYfw5rhPTVz46mBjLztxcuLpYs684NnYPwT1Q=;
        b=qUchQXJnqe3sObs8fkqVxF4mkuIJEj2HblPBqx82miGONwk8zc7TefZOeNKM8zP2Kr
         /JLNdl7lcH4PysbiBR0dis56QWTYgQ9pMSgu4wJgOmcpgZQNcMLBSOSoiLTqzMH9hckW
         F00SP0zdr54Dhmdhz4MvIgrqP0mPj72EF7nmNH67+bzSvM8nNXYZgHmJy6ruQ6qOA2Yv
         PPWZEqDf6btfKta1MDUKynNCOTb0l+SfNSINXgfRT4JUXKKRRmv+Gy5qpWcW8DGX190F
         PslSb49Jm11jW//z1KIt29M3ayC9Onc68OVBPu6wnwm/gYLRk+9qUZWzkDTQkDWXacxK
         +I3w==
X-Gm-Message-State: AOAM531Aq8CnbcfwUL/e9C6s58EAoSF4Qa7vsoxWo0TEPdXgTgAlBDA8
        buM5Ssy/DRzuj6pfqivYQZBNPp8PDhifAwo6
X-Google-Smtp-Source: ABdhPJzvZ1spZ03Pt59fKKNQ5fnVP7a+aXbzRS3TzyftN569erw2414bOblQN4M2uxJJbSas8KAMjA==
X-Received: by 2002:adf:ea4f:: with SMTP id j15mr2026650wrn.295.1598886603930;
        Mon, 31 Aug 2020 08:10:03 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f6sm14181636wme.32.2020.08.31.08.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 08:10:03 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 09/15] net: bridge: mcast: delete expired port groups without srcs
Date:   Mon, 31 Aug 2020 18:08:39 +0300
Message-Id: <20200831150845.1062447-10-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
References: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
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
index cdd732c91d1f..1dc0964ea3b5 100644
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

