Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692FF1B33A4
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 01:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgDUXs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 19:48:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgDUXs3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 19:48:29 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCB5C2068F;
        Tue, 21 Apr 2020 23:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587512909;
        bh=drjTTPR6qP+yRPTJ11BBmGTaQoQ6JtjmWXJMNdhAOnk=;
        h=From:To:Cc:Subject:Date:From;
        b=pxFfscTOpj+70Uk242QdcqxUo2popTF5iHPrizj+ZJJQDsE8Ve3EwJIH9liwIa91T
         HQGcfNyKOEWHQD+d+uPVuO3aaQO8iepD842qpkkrzHZv6MsK0kyLE5/wwuXVMSHeFx
         vy+BBSVlGkLreHd8VC63u2giheAaruwYBlNMnsbc=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] vrf: Fix IPv6 with qdisc and xfrm
Date:   Tue, 21 Apr 2020 17:48:27 -0600
Message-Id: <20200421234827.63465-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

When a qdisc is attached to the VRF device, the packet goes down the ndo
xmit function which is setup to send the packet back to the VRF driver
which does a lookup to send the packet out. The lookup in the VRF driver
is not considering xfrm policies. Change it to use ip6_dst_lookup_flow
rather than ip6_route_output.

Fixes: 35402e313663 ("net: Add IPv6 support to VRF device")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 drivers/net/vrf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 6f5d03b7d9c0..56f8aab46f89 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -188,8 +188,8 @@ static netdev_tx_t vrf_process_v6_outbound(struct sk_buff *skb,
 	fl6.flowi6_proto = iph->nexthdr;
 	fl6.flowi6_flags = FLOWI_FLAG_SKIP_NH_OIF;
 
-	dst = ip6_route_output(net, NULL, &fl6);
-	if (dst == dst_null)
+	dst = ip6_dst_lookup_flow(net, NULL, &fl6, NULL);
+	if (IS_ERR(dst) || dst == dst_null)
 		goto err;
 
 	skb_dst_drop(skb);
-- 
2.20.1

