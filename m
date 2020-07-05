Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B72F214E76
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 20:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgGESWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 14:22:46 -0400
Received: from mail.aperture-lab.de ([138.201.29.205]:43710 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727892AbgGESWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 14:22:45 -0400
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c0d3.blue; s=2018;
        t=1593973363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BWLNZff+/2GVoco07cWEeMqx/qFYTKj66Lb7zdTUnbM=;
        b=KHY10xfprOr13lO/b9r4ocoUTapsaRf42ZvcqVJnC/K7ZurJWGaaxQb+V6GS61hcLlpAUz
        4CSdTNvRBZAwHl6fVA6ee3y89+1aLdeZInm7FdcO+OAN0GFet0+E1h9dRFObkd3KBdqRre
        VCiMGfA0cpf1c9qlY+jMNE7vbOd+01/nIYnDPEQ+1eXJfSdSvPQzsI7livM9y8FDdu2Es6
        TD+T3ZmXDm8Nugyaa5Sg6vMOucfRG17MqpLQPTIjOnZ1uKZ9hjE+PiPCDNBGETDL+AeIQs
        CaAL3HJZrdJVyxSC1TtAzHDdE7YH/lLGIFAG00GNUNJy5rIvs7Eb63xzwDH7xw==
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Martin Weinelt <martin@linuxlounge.net>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: [PATCH net] bridge: mcast: Fix MLD2 Report IPv6 payload length check
Date:   Sun,  5 Jul 2020 20:22:34 +0200
Message-Id: <20200705182234.10257-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=linus.luessing@c0d3.blue smtp.mailfrom=linus.luessing@c0d3.blue
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e57f61858b7c ("net: bridge: mcast: fix stale nsrcs pointer in
igmp3/mld2 report handling") introduced a small bug which would potentially
lead to accepting an MLD2 Report with a broken IPv6 header payload length
field.

The check needs to take into account the 2 bytes for the "Number of
Sources" field in the "Multicast Address Record" before reading it.
And not the size of a pointer to this field.

Fixes: e57f61858b7c ("net: bridge: mcast: fix stale nsrcs pointer in igmp3/mld2 report handling")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
---
 net/bridge/br_multicast.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 83490bf73a13..4c4a93abde68 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1000,21 +1000,21 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 	num = ntohs(icmp6h->icmp6_dataun.un_data16[1]);
 	len = skb_transport_offset(skb) + sizeof(*icmp6h);
 
 	for (i = 0; i < num; i++) {
 		__be16 *_nsrcs, __nsrcs;
 		u16 nsrcs;
 
 		nsrcs_offset = len + offsetof(struct mld2_grec, grec_nsrcs);
 
 		if (skb_transport_offset(skb) + ipv6_transport_len(skb) <
-		    nsrcs_offset + sizeof(_nsrcs))
+		    nsrcs_offset + sizeof(__nsrcs))
 			return -EINVAL;
 
 		_nsrcs = skb_header_pointer(skb, nsrcs_offset,
 					    sizeof(__nsrcs), &__nsrcs);
 		if (!_nsrcs)
 			return -EINVAL;
 
 		nsrcs = ntohs(*_nsrcs);
 		grec_len = struct_size(grec, grec_src, nsrcs);
 
-- 
2.27.0

