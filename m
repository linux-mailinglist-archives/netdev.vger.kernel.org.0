Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE9A27A15B
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 16:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgI0OId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 10:08:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbgI0OIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 10:08:32 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601215711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kurdIdFBC0V1Do9F8C0GBNvv55Ib7ixpdhn7yg6xmqU=;
        b=Ee7iicCWtdcrI00zJ4phhwkSx5bpY7/cLuMPsbOS17yHPObLazErnZDiAMjZDGnjYY2meh
        wCnmo6qjdXUJtPuvSMxfwy7UN00naCe1aaxNcJJwQIBRKMXEyZR+XpISUraAbP2CZu/ebl
        +3MtR3J/4Da+yFv+gZmpLy1eL+1smic=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-xKUcP-cYPfyopCNIg1RVPA-1; Sun, 27 Sep 2020 10:08:29 -0400
X-MC-Unique: xKUcP-cYPfyopCNIg1RVPA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4503E1DDEC;
        Sun, 27 Sep 2020 14:08:28 +0000 (UTC)
Received: from new-host-6.redhat.com (unknown [10.40.192.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 005B655786;
        Sun, 27 Sep 2020 14:08:26 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jianlin Shi <jishi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] ip6gre: avoid tx_error when sending MLD/DAD on external tunnels
Date:   Sun, 27 Sep 2020 16:08:21 +0200
Message-Id: <e63a72579b88602442650ba38764c0beeed05ada.1601215294.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

similarly to what has been done with commit 9d149045b3c0 ("geneve: change
from tx_error to tx_dropped on missing metadata"), avoid reporting errors
to userspace in case the kernel doesn't find any tunnel information for a
skb that is going to be transmitted: an increase of tx_dropped is enough.

tested with the following script:

 # for t in ip6gre ip6gretap ip6erspan; do
 > ip link add dev gre6-test0 type $t external
 > ip address add dev gre6-test0 2001:db8::1/64
 > ip link set dev gre6-test0 up
 > sleep 30
 > ip -s -j link show dev gre6-test0 | jq \
 > '.[0].stats64.tx | {"errors": .errors, "dropped": .dropped}'
 > ip link del dev gre6-test0
 > done

Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/ipv6/ip6_gre.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 3a57fb9ce049..931b186d2e48 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -707,6 +707,17 @@ static int prepare_ip6gre_xmit_ipv6(struct sk_buff *skb,
 	return 0;
 }
 
+static struct ip_tunnel_info *skb_tunnel_info_txcheck(struct sk_buff *skb)
+{
+	struct ip_tunnel_info *tun_info;
+
+	tun_info = skb_tunnel_info(skb);
+	if (unlikely(!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX)))
+		return ERR_PTR(-EINVAL);
+
+	return tun_info;
+}
+
 static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 			       struct net_device *dev, __u8 dsfield,
 			       struct flowi6 *fl6, int encap_limit,
@@ -734,10 +745,9 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		const struct ip_tunnel_key *key;
 		__be16 flags;
 
-		tun_info = skb_tunnel_info(skb);
-		if (unlikely(!tun_info ||
-			     !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
-			     ip_tunnel_info_af(tun_info) != AF_INET6))
+		tun_info = skb_tunnel_info_txcheck(skb);
+		if (IS_ERR(tun_info) ||
+		    unlikely(ip_tunnel_info_af(tun_info) != AF_INET6))
 			return -EINVAL;
 
 		key = &tun_info->key;
@@ -908,7 +918,8 @@ static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
 tx_err:
-	stats->tx_errors++;
+	if (!t->parms.collect_md || !IS_ERR(skb_tunnel_info_txcheck(skb)))
+		stats->tx_errors++;
 	stats->tx_dropped++;
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
@@ -917,6 +928,7 @@ static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
 static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 					 struct net_device *dev)
 {
+	struct ip_tunnel_info *tun_info = NULL;
 	struct ip6_tnl *t = netdev_priv(dev);
 	struct dst_entry *dst = skb_dst(skb);
 	struct net_device_stats *stats;
@@ -964,15 +976,13 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	 * for native mode, call prepare_ip6gre_xmit_{ipv4,ipv6}.
 	 */
 	if (t->parms.collect_md) {
-		struct ip_tunnel_info *tun_info;
 		const struct ip_tunnel_key *key;
 		struct erspan_metadata *md;
 		__be32 tun_id;
 
-		tun_info = skb_tunnel_info(skb);
-		if (unlikely(!tun_info ||
-			     !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
-			     ip_tunnel_info_af(tun_info) != AF_INET6))
+		tun_info = skb_tunnel_info_txcheck(skb);
+		if (IS_ERR(tun_info) ||
+		    unlikely(ip_tunnel_info_af(tun_info) != AF_INET6))
 			goto tx_err;
 
 		key = &tun_info->key;
@@ -1065,7 +1075,8 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 
 tx_err:
 	stats = &t->dev->stats;
-	stats->tx_errors++;
+	if (!IS_ERR(tun_info))
+		stats->tx_errors++;
 	stats->tx_dropped++;
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
-- 
2.26.2

