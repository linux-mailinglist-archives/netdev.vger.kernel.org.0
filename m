Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1992B17BF
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 10:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgKMJDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 04:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgKMJDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 04:03:19 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC53C0613D1;
        Fri, 13 Nov 2020 01:03:19 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id 11so9795972ljf.2;
        Fri, 13 Nov 2020 01:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jOx9/hL9gcypJbYKVQmbDZbvLP/OxmK+3X0k+2YLwtI=;
        b=QB2KkR+ZBDshhCgbXCg99iRunoBLOQQuuJHx03u+I9M4KWg3oSRSC93pCOAeYozgON
         FJG5lxKfLfkf3vOkJv+BbszR0Tec0IET8GqxXdcdWKA+ctGe1J1Oq12fkrS2L4R5TU3m
         evSW2v9MT2PsoFqEQDomHux7UzKKstuI3at1e8KwUM+kjhXSfqc+Hn1gYWeYboM4rUM6
         mOAwf9MhHy0zJ5qqhn2FYlFjURh8lAV0h0ncHyAqphl7A3c2xA0kfZHoqCAE8aOYzXez
         kvAvknzfYwPYpuphZZ8gVggrIJtS6u3uHfKqcvOZPp5eOjO9QhxWrNmI7mYcBv/f4YYj
         +Fyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jOx9/hL9gcypJbYKVQmbDZbvLP/OxmK+3X0k+2YLwtI=;
        b=AgFbaIkxPEJF55As37lVonKIKXy3DM2JwVnRTWxQZ6h4X3KxbEYgv6xaeiyCFPv2fI
         FKxktBm66sA3ImuHv/1KCIMfBylX9jRCm7pryaeeFZUyU93EdON7JFEAv0Q1RBceXJQN
         GHe9/ZH6A/lWdmPovxwV7vsPcotS7wFhbW43zddW872ETNub6KrAuVn/MODcMfcJPAmQ
         csLDv3PYlGtSSndsJoMsiWpIXW+/U+OFRKqhVg+OpM6WgPMHUuwI+q2vXOTJA/9Dsxgt
         6fTeu2VLzLeRfAJkURLBy0eht5gBvV1IC6bF1pK3Ln2U5ZbIN7FmRFChP4/wqqRRUb0j
         VlPQ==
X-Gm-Message-State: AOAM531VxKDzBokXoMNNwIbkYB8jiwJiE+vnqwAKgUqg6y6bYJ2hruP8
        6rIdMQ0G0lVOE6u0ZM2Gy/Q=
X-Google-Smtp-Source: ABdhPJzPHX5eBspcz8RbOMHzgzd0DdUJ49lB/KCdR5s9frlvXJ+9CexOkkF1/3bu38c9j3ASNYigig==
X-Received: by 2002:a2e:91cd:: with SMTP id u13mr584825ljg.239.1605258197991;
        Fri, 13 Nov 2020 01:03:17 -0800 (PST)
Received: from localhost.localdomain (dmjt96jhvbz3j2f08hy-4.rev.dnainternet.fi. [2001:14bb:51:e1dd:1cd1:d2e:7b13:dc30])
        by smtp.gmail.com with ESMTPSA id c6sm1477876lfm.226.2020.11.13.01.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 01:03:17 -0800 (PST)
From:   Lev Stipakov <lstipakov@gmail.com>
X-Google-Original-From: Lev Stipakov <lev@openvpn.net>
To:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Lev Stipakov <lev@openvpn.net>
Subject: [PATCH v2 2/3] net: openvswitch: use core API to update/provide stats
Date:   Fri, 13 Nov 2020 11:02:40 +0200
Message-Id: <20201113090240.116518-1-lev@openvpn.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <598c779c-fb0b-a9a6-43be-3a7cd5b38946@gmail.com>
References: <598c779c-fb0b-a9a6-43be-3a7cd5b38946@gmail.com>
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
---

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

