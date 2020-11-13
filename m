Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9527F2B2790
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgKMVyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgKMVyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 16:54:10 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B6BC0613D1;
        Fri, 13 Nov 2020 13:54:08 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id d12so11706171wrr.13;
        Fri, 13 Nov 2020 13:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xOBvY2vFCS6zdH1EtrWMdIMtOxjbVKvd1EKUczrVfJM=;
        b=tJGV0d/CLi8gHAiyR/LKkcXKmx5U78J0Z0o0kmK0qHHg6e8y/G/4/sCi4+BIuurdzj
         rnXJCJBuahmOVsmmaGrIO0Y6/FmFVKNhDa2qgEpX4oljOM9eyXua9Q6DD4rcVF1z0Dip
         RjVxhdIBbY1bSGKv+UCQJZCDmwPax26oKlMdlGdZZs9g/XRJial1gt9vEChtnXvZI2q0
         vmegBUX9s/xGZWWibgwNeZi3HkT5ENXuzTe3knArIo9C5x41eib8kgpxMoivfv4ZxlpW
         ULWStRJ8wqCkNXUCnBWiYAC+wIWV2eyewfKxmuLTGmnnsIYBf0tsptkS8ma6BZheZ/zY
         SAew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xOBvY2vFCS6zdH1EtrWMdIMtOxjbVKvd1EKUczrVfJM=;
        b=uAGSrfbnwZyGCol77kx4PThGxavy59rPg3iKiTNiy415eFjLEF8/Vo+RI+Xa09Kwav
         h3MDkctxx+obnlelj1qtYtUB+3geRO97UmJZp5ws74GusN4yakH2vcr4PNaZHmba+ZxG
         q3kLYfKo2BoohL6zJ0sH4FZ6V1jEDzRxdoOn8p58ztjUQCA+CdsQ5/6sNZGSvLXg9td+
         AnJO3F2TRDp+ELopxTL72Ap1TrWFEqwgXUdiz6vt+aioeFkrLK3cg3I3ebp7ihjgqyum
         n71Y68EbotDKuq/fx+GYStOjJBNP0EqBMclSuRCf6Oa5DAI4B1tEMdM1Ubykp7jUX3Oe
         6qYg==
X-Gm-Message-State: AOAM532TuWqfQ17RGry3SonBxh1lc6k0nE8OgTNoSqXBIZfoTlToJPNg
        ty79NvpPhOfpV55GNMenEI8=
X-Google-Smtp-Source: ABdhPJzXUtc+8UALpzbx9/laOEwGc8nAaT9sn3qegwxvC1ucflcKRKx1YkuzbjsxbohaKGSOLG1gtA==
X-Received: by 2002:a5d:5048:: with SMTP id h8mr5976770wrt.135.1605304447657;
        Fri, 13 Nov 2020 13:54:07 -0800 (PST)
Received: from ubux1.bb.dnainternet.fi (81-175-130-136.bb.dnainternet.fi. [81.175.130.136])
        by smtp.gmail.com with ESMTPSA id l3sm13037500wmf.0.2020.11.13.13.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 13:54:07 -0800 (PST)
From:   Lev Stipakov <lstipakov@gmail.com>
X-Google-Original-From: Lev Stipakov <lev@openvpn.net>
To:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Lev Stipakov <lev@openvpn.net>
Subject: [PATCH v3] net: openvswitch: use core API to update/provide stats
Date:   Fri, 13 Nov 2020 23:53:36 +0200
Message-Id: <20201113215336.145998-1-lev@openvpn.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <c4409cfe-4d58-27da-0c0d-3c59ce508aea@gmail.com>
References: <c4409cfe-4d58-27da-0c0d-3c59ce508aea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add") has added
function "dev_sw_netstats_tx_add()" to update net device per-cpu TX
stats.

Use this function instead of own code.

While on it, remove internal_get_stats() and replace it
with dev_get_tstats64().

Signed-off-by: Lev Stipakov <lev@openvpn.net>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
---

 v3: no code changes, just send separate patch instead of series as
requested

 v2:
  - do not delete len variable and add comment why
  - replace internal_get_stats() vs dev_get_tstats64()

 net/openvswitch/vport-internal_dev.c | 29 +++++++---------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 1e30d8df3ba5..5b2ee9c1c00b 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -35,21 +35,18 @@ internal_dev_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	int len, err;
 
+	/* store len value because skb can be freed inside ovs_vport_receive() */
 	len = skb->len;
+
 	rcu_read_lock();
 	err = ovs_vport_receive(internal_dev_priv(netdev)->vport, skb, NULL);
 	rcu_read_unlock();
 
-	if (likely(!err)) {
-		struct pcpu_sw_netstats *tstats = this_cpu_ptr(netdev->tstats);
-
-		u64_stats_update_begin(&tstats->syncp);
-		tstats->tx_bytes += len;
-		tstats->tx_packets++;
-		u64_stats_update_end(&tstats->syncp);
-	} else {
+	if (likely(!err))
+		dev_sw_netstats_tx_add(netdev, 1, len);
+	else
 		netdev->stats.tx_errors++;
-	}
+
 	return NETDEV_TX_OK;
 }
 
@@ -83,24 +80,12 @@ static void internal_dev_destructor(struct net_device *dev)
 	ovs_vport_free(vport);
 }
 
-static void
-internal_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
-{
-	memset(stats, 0, sizeof(*stats));
-	stats->rx_errors  = dev->stats.rx_errors;
-	stats->tx_errors  = dev->stats.tx_errors;
-	stats->tx_dropped = dev->stats.tx_dropped;
-	stats->rx_dropped = dev->stats.rx_dropped;
-
-	dev_fetch_sw_netstats(stats, dev->tstats);
-}
-
 static const struct net_device_ops internal_dev_netdev_ops = {
 	.ndo_open = internal_dev_open,
 	.ndo_stop = internal_dev_stop,
 	.ndo_start_xmit = internal_dev_xmit,
 	.ndo_set_mac_address = eth_mac_addr,
-	.ndo_get_stats64 = internal_get_stats,
+	.ndo_get_stats64 = dev_get_tstats64,
 };
 
 static struct rtnl_link_ops internal_dev_link_ops __read_mostly = {
-- 
2.25.1

