Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA43333DE88
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 21:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhCPUUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 16:20:15 -0400
Received: from smtp.sysclose.org ([69.164.214.230]:43504 "EHLO sysclose.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhCPUT4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 16:19:56 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Mar 2021 16:19:56 EDT
Received: from localhost (unknown [45.71.105.250])
        by sysclose.org (Postfix) with ESMTPSA id 195672604;
        Tue, 16 Mar 2021 20:14:53 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 sysclose.org 195672604
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sysclose.org;
        s=201903; t=1615925694;
        bh=Ea1FliF9RAeUN2t8OsM5ioLS+YASnT1KliVvDFy2sXs=;
        h=From:To:Cc:Subject:Date:From;
        b=BcqMGAkO4yl33qq2isRIZAKQlrcPrcZDjgQt0sKzOnVv+cgwInzUrIwy7OYZmDxXx
         o/Zr72cj1XGCI3rkzr1/8RBGgUhMfgldYcyJaIFq+AMyeh/JGKFqOW3i3BpjNPYKy+
         DR8dYqRytyoZSIBeDPf13kv276zBXFW1eEsKjZPTgVhlEUnwTwTGhtnWRrs8ZUwY/t
         dFxaVlzGLGsrnCnzNHauP+JlUY30Udf3vKhNauzNQ1qIayx5ZrzNoih45Sh25TvSqt
         dx2NXUZMVJlT9euKuzayqmchU7MPCIC3psxICyYTfQLBd7KjiAfk12hleqblIy6TsE
         PvnsxzdvJbnXw==
From:   Flavio Leitner <fbl@sysclose.org>
To:     netdev@vger.kernel.org
Cc:     Eelco Chaudron <echaudro@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>
Subject: [PATCH net-next] openvswitch: Warn over-mtu packets only if iface is UP.
Date:   Tue, 16 Mar 2021 17:14:27 -0300
Message-Id: <20210316201427.1690660-1-fbl@sysclose.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not unusual to have the bridge port down. Sometimes
it has the old MTU, which is fine since it's not being used.

However, the kernel spams the log with a warning message
when a packet is going to be sent over such port. Fix that
by warning only if the interface is UP.

Signed-off-by: Flavio Leitner <fbl@sysclose.org>
---
 net/openvswitch/vport.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 4ed7e52c7012..88deb5b41429 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -497,10 +497,12 @@ void ovs_vport_send(struct vport *vport, struct sk_buff *skb, u8 mac_proto)
 
 	if (unlikely(packet_length(skb, vport->dev) > mtu &&
 		     !skb_is_gso(skb))) {
-		net_warn_ratelimited("%s: dropped over-mtu packet: %d > %d\n",
-				     vport->dev->name,
-				     packet_length(skb, vport->dev), mtu);
 		vport->dev->stats.tx_errors++;
+		if (vport->dev->flags & IFF_UP)
+			net_warn_ratelimited("%s: dropped over-mtu packet: "
+					     "%d > %d\n", vport->dev->name,
+					     packet_length(skb, vport->dev),
+					     mtu);
 		goto drop;
 	}
 
-- 
2.29.2

