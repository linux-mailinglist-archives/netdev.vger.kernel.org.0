Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FBE25E677
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 10:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgIEIZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 04:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbgIEIY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 04:24:56 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F4CC061245
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 01:24:55 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l9so8826288wme.3
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 01:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lDPD0SBTXMHitArGqEGbSSR6qohaslJSZJZXxjRVv1U=;
        b=YhhLlt0uqbMasWSbMwK/dPayNdtOXNFqS3OPtwC1ODv9AlY1KvuDNDgIY5zvZxb2W5
         HWI+UwI3i4TT6DpjxSGr91vrYK542xNVV6tvdZ7P9F/vksLJy8H3fR+2DN38LYbch7Ry
         i3IdqngnHJvYqZIRtrH9nCbHKA+yRUj9uFZoQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lDPD0SBTXMHitArGqEGbSSR6qohaslJSZJZXxjRVv1U=;
        b=akcWzFo3xRb9FSCY2yGq2/Brn3mRBN3AFoVb4hslbtocteMGdvov5KgFGRp8R85gwu
         xTRPwIm3h6iM6Ujy3vRhi9ECqvKZiPq1ZsVmf4urDGSt2ddzqlHn33fXW5AQrBBF9UCG
         y446pVQzkDMeg+FAx2rSMKcg/TovoVWSerpRWnOv4qpJanA63VOOZ8P4HqTCdjk+LnPG
         o1vgrC4zVIMkZ+QciRG0XOY6AKoVb+Z8+85EfkZhykuz1RfSDMq1UVYntxgbp7jelrb+
         1/VBB7RvPYojvjBKvouzgbMBNpKY42dq0n+cnXlIqEsmfR90X1YyQLBhGPXfUA8MXf3h
         XyXg==
X-Gm-Message-State: AOAM5336Cye1y++SUJNMGj3+A1PvAOWoQ1PY0cRmHtXjnBqQl2kQ4bpo
        DiAWnYaba7kDFsQSzBta1SuMkbislLdczWsr
X-Google-Smtp-Source: ABdhPJwNnJKAcEne+sZwO+Lcw91MMwQ3J6WfYhkxwp/zjL2QkItA2OiHQRqGVbUZdTo9kFTw4jnebg==
X-Received: by 2002:a05:600c:24d3:: with SMTP id 19mr10851011wmu.98.1599294293980;
        Sat, 05 Sep 2020 01:24:53 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m185sm17169296wmf.5.2020.09.05.01.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 01:24:53 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 09/15] net: bridge: mcast: delete expired port groups without srcs
Date:   Sat,  5 Sep 2020 11:24:04 +0300
Message-Id: <20200905082410.2230253-10-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
References: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
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
index a54d5fb810d1..e8d2f653344f 100644
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

