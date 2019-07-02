Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9698F5CF0F
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 14:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbfGBMFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 08:05:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46161 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbfGBMFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 08:05:07 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so17472486wrw.13
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 05:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GSx4QIELcR9xkyWBBehy9lJ5hvGJj8dGQFampul0IVo=;
        b=c07Tl1f1180GeriB7zwf34KMNMsCmC/35YWN2Xf7IiGiK2diGwyj2aLaRuQ5b1sDmD
         g/fu1pIACSjwIQd/ayCbGYfovi7AWeJm+ZOPyfiW1/RtwRVvY2pXOW0i+tY3uzayykT2
         EH6Tnx3B37L0IDhBlr2e1XLQgEH67keGETSCA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GSx4QIELcR9xkyWBBehy9lJ5hvGJj8dGQFampul0IVo=;
        b=SKK4CLbkGXRhtx/iaRiy7IxOorPWc7/6fPqwFt5BZDsxmuqf2cgSOBFvh5oYeb+zSV
         LEF+Dn0CjN93nITE9KdctlAkaGg5JFTcLbZIDuGtpiJZahzM1lZtroWeiSjUplnzp044
         odB9rtLz5QpZC/cOslNqx9pKMrG2JR88NdCc28PBn+Y8ClpaAOdiPy/rsv9W378vZkVY
         PCgLnpdJsIcUrlryXQgMQFCTpu9gDrNKl1hvbeynXPGjHiSecdKCZvmRn+DVyuOI2/rt
         +WIXr2ofDMeEGSbgEqbAGYgCnKqzUw4qA5HBb/P7F5NMyTM4J8jC4thu9ZLiGt1Iibuu
         bpjA==
X-Gm-Message-State: APjAAAUc08rOkTWuygsJB9zQ635AFrZtH6NS2rIhFhhAvlU8gM8nTO1r
        04t3D4I2qvGMxKPISrimAI4oIbjpsO4=
X-Google-Smtp-Source: APXvYqzxxVjoGTiFJtaahtI1xEpd1fIsUsn8/FDyH+w3WSKMF+W5Sor6PwOTl0I1q/PCDNIvh61wcw==
X-Received: by 2002:adf:b69a:: with SMTP id j26mr15838677wre.93.1562069105328;
        Tue, 02 Jul 2019 05:05:05 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x5sm2542655wmf.33.2019.07.02.05.05.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 05:05:04 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        martin@linuxlounge.net, bridge@lists.linux-foundation.org,
        yoshfuji@linux-ipv6.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net 3/4] net: bridge: don't cache ether dest pointer on input
Date:   Tue,  2 Jul 2019 15:00:20 +0300
Message-Id: <20190702120021.13096-4-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190702120021.13096-1-nikolay@cumulusnetworks.com>
References: <20190702120021.13096-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We would cache ether dst pointer on input in br_handle_frame_finish but
after the neigh suppress code that could lead to a stale pointer since
both ipv4 and ipv6 suppress code do pskb_may_pull. This means we have to
always reload it after the suppress code so there's no point in having
it cached just retrieve it directly.

Fixes: 057658cb33fbf ("bridge: suppress arp pkts on BR_NEIGH_SUPPRESS ports")
Fixes: ed842faeb2bd ("bridge: suppress nd pkts on BR_NEIGH_SUPPRESS ports")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_input.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 21b74e7a7b2f..52c712984cc7 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -74,7 +74,6 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	struct net_bridge_fdb_entry *dst = NULL;
 	struct net_bridge_mdb_entry *mdst;
 	bool local_rcv, mcast_hit = false;
-	const unsigned char *dest;
 	struct net_bridge *br;
 	u16 vid = 0;
 
@@ -92,10 +91,9 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 		br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, false);
 
 	local_rcv = !!(br->dev->flags & IFF_PROMISC);
-	dest = eth_hdr(skb)->h_dest;
-	if (is_multicast_ether_addr(dest)) {
+	if (is_multicast_ether_addr(eth_hdr(skb)->h_dest)) {
 		/* by definition the broadcast is also a multicast address */
-		if (is_broadcast_ether_addr(dest)) {
+		if (is_broadcast_ether_addr(eth_hdr(skb)->h_dest)) {
 			pkt_type = BR_PKT_BROADCAST;
 			local_rcv = true;
 		} else {
@@ -145,7 +143,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 		}
 		break;
 	case BR_PKT_UNICAST:
-		dst = br_fdb_find_rcu(br, dest, vid);
+		dst = br_fdb_find_rcu(br, eth_hdr(skb)->h_dest, vid);
 	default:
 		break;
 	}
-- 
2.21.0

