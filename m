Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE413495BB
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 16:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhCYPgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 11:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230450AbhCYPfk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 11:35:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0406619A3;
        Thu, 25 Mar 2021 15:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616686540;
        bh=KtE8vYC86VK7BFuTBN+ShiHWJhokC3D9HUVLd/Iv4gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j0yiDwvUXBshYYFP2mtGiA2tJV8pjP69zjur0wnnFsVXQCqVhuJeYn0Onoly9rZn/
         Qnvoi2RmX/o0n9voiSmA/ZEiKDB7tA0zyzltbsBic8ehz5j4SAh20N7XI0lGkhzcuZ
         DP+eYiSd4hmantR+1XZBsWlYKTcIsueJRDDApOhZvwneftEvSjiF0OEJpL7ngyfNKq
         qRccOyIL/G2IWF9c2IoxJ3h3xmqoyHWtvNxb4hDWqRdP1Hwdaix6FTQrypeodwpcRb
         0ICpHx4e8qgOoK8eXhOeJY85cjeRN3NUv+nD1z956uzj9JbAeXOk/ZAAY4vy2iydrx
         noWEPAWPp3jcA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, echaudro@redhat.com,
        sbrivio@redhat.com, netdev@vger.kernel.org
Subject: [PATCH net 2/2] geneve: do not modify the shared tunnel info when PMTU triggers an ICMP reply
Date:   Thu, 25 Mar 2021 16:35:33 +0100
Message-Id: <20210325153533.770125-3-atenart@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325153533.770125-1-atenart@kernel.org>
References: <20210325153533.770125-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the interface is part of a bridge or an Open vSwitch port and a
packet exceed a PMTU estimate, an ICMP reply is sent to the sender. When
using the external mode (collect metadata) the source and destination
addresses are reversed, so that Open vSwitch can match the packet
against an existing (reverse) flow.

But inverting the source and destination addresses in the shared
ip_tunnel_info will make following packets of the flow to use a wrong
destination address (packets will be tunnelled to itself), if the flow
isn't updated. Which happens with Open vSwitch, until the flow times
out.

Fixes this by uncloning the skb's ip_tunnel_info before inverting its
source and destination addresses, so that the modification will only be
made for the PTMU packet, not the following ones.

Fixes: c1a800e88dbf ("geneve: Support for PMTU discovery on directly bridged links")
Tested-by: Eelco Chaudron <echaudro@redhat.com>
Reviewed-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/geneve.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 4ac0373326ef..d5b1e48e0c09 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -908,8 +908,16 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 
 		info = skb_tunnel_info(skb);
 		if (info) {
-			info->key.u.ipv4.dst = fl4.saddr;
-			info->key.u.ipv4.src = fl4.daddr;
+			struct ip_tunnel_info *unclone;
+
+			unclone = skb_tunnel_info_unclone(skb);
+			if (unlikely(!unclone)) {
+				dst_release(&rt->dst);
+				return -ENOMEM;
+			}
+
+			unclone->key.u.ipv4.dst = fl4.saddr;
+			unclone->key.u.ipv4.src = fl4.daddr;
 		}
 
 		if (!pskb_may_pull(skb, ETH_HLEN)) {
@@ -993,8 +1001,16 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		struct ip_tunnel_info *info = skb_tunnel_info(skb);
 
 		if (info) {
-			info->key.u.ipv6.dst = fl6.saddr;
-			info->key.u.ipv6.src = fl6.daddr;
+			struct ip_tunnel_info *unclone;
+
+			unclone = skb_tunnel_info_unclone(skb);
+			if (unlikely(!unclone)) {
+				dst_release(dst);
+				return -ENOMEM;
+			}
+
+			unclone->key.u.ipv6.dst = fl6.saddr;
+			unclone->key.u.ipv6.src = fl6.daddr;
 		}
 
 		if (!pskb_may_pull(skb, ETH_HLEN)) {
-- 
2.30.2

