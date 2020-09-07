Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2537F25F711
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgIGKAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728500AbgIGKA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:00:27 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BBBC061575
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 03:00:26 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e11so11982560wme.0
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 03:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xPrgpvu8R7IeEavKBbZFAFtOZyz+o22/fgY3P1q+vxU=;
        b=e0/Y7WvqcsSW6S/j3Wr3KIJZjCEM2UZIU2Eap7CrxpAFou9DxSVQzUH5YVGsgd+uCB
         etikOn02AOvdyE3+6Prfuqe+LKZ2EyMQZ9lAu34WBxcbjN8yRw3QhQoyjfiJCJNI8Aew
         topxP9uI9mUm3ahS3bxJN3QbEIuAIXbUInMPk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xPrgpvu8R7IeEavKBbZFAFtOZyz+o22/fgY3P1q+vxU=;
        b=eeyLylmwi92fGWNhMt89rSbk6ztLelC8qcPUHb9NUZ+rfWbKD2QXZni2IBKvVIiCX/
         PsvfFmvSeg+U1rP9SztAt7WdXc5S3BBAMWeb8XCS6t2OWRf3rTf1WJv6fSNEFApYNIRC
         egnTo9dHIOBTH0J6v7mz7yiaxrWgYseATVpFeYtMGq+6kJtYT6tiYZBko1wwUveZu8BT
         mzZdlirKpyPyWtMWX0tffO4A7s91OMr+PU5qsYytVsD63KPlWrJU7RiYkVYt3Zgy3GOk
         Lhum95fndTHBAPLIb845ve2Ja2ybNPMlpN7KS2nF8vSMpAqoJZizI0mGUb7O0RUEDoOa
         ahwQ==
X-Gm-Message-State: AOAM531dYjDXjisq6IcCD/q7O51IeO8qSTzGM98SxFbRJyGgZAF+EvHc
        i1LY5tvczR5DJxdV4JMImbEeN4CS/VbWy6T+
X-Google-Smtp-Source: ABdhPJwbxNJwmpD8e1VkLqnIVS8IOypN9C+A23SLMLNr1p6jzW/Gerw1vDfcW0M6e+q62yV5GnwK2g==
X-Received: by 2002:a7b:cc13:: with SMTP id f19mr19825730wmh.168.1599472824827;
        Mon, 07 Sep 2020 03:00:24 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 9sm6686289wmf.7.2020.09.07.03.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:00:24 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v4 09/15] net: bridge: mcast: delete expired port groups without srcs
Date:   Mon,  7 Sep 2020 12:56:13 +0300
Message-Id: <20200907095619.11216-10-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
References: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
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
index 541a22e130b0..ba2ce875a80e 100644
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

