Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F92353728
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 09:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhDDHLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 03:11:16 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:50030 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhDDHLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 03:11:13 -0400
Received: from localhost.localdomain ([90.126.11.170])
        by mwinf5d04 with ME
        id oXB62400m3g7mfN03XB7CC; Sun, 04 Apr 2021 09:11:08 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 04 Apr 2021 09:11:08 +0200
X-ME-IP: 90.126.11.170
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: openvswitch: Use 'skb_push_rcsum()' instead of hand coding it
Date:   Sun,  4 Apr 2021 09:11:03 +0200
Message-Id: <0c50411744412a25332ada56836c6181674843df.1617520174.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'skb_push()'/'skb_postpush_rcsum()' can be replaced by an equivalent
'skb_push_rcsum()' which is less verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/openvswitch/conntrack.c    | 6 ++----
 net/openvswitch/vport-netdev.c | 7 +++----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 71cec03e8612..c29b0ef1fc27 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -809,8 +809,7 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 
 	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
 push:
-	skb_push(skb, nh_off);
-	skb_postpush_rcsum(skb, skb->data, nh_off);
+	skb_push_rcsum(skb, nh_off);
 
 	return err;
 }
@@ -1322,8 +1321,7 @@ int ovs_ct_execute(struct net *net, struct sk_buff *skb,
 	else
 		err = ovs_ct_lookup(net, key, info, skb);
 
-	skb_push(skb, nh_ofs);
-	skb_postpush_rcsum(skb, skb->data, nh_ofs);
+	skb_push_rcsum(skb, nh_ofs);
 	if (err)
 		kfree_skb(skb);
 	return err;
diff --git a/net/openvswitch/vport-netdev.c b/net/openvswitch/vport-netdev.c
index 57d6436e6f6a..8e1a88f13622 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -44,10 +44,9 @@ static void netdev_port_receive(struct sk_buff *skb)
 	if (unlikely(!skb))
 		return;
 
-	if (skb->dev->type == ARPHRD_ETHER) {
-		skb_push(skb, ETH_HLEN);
-		skb_postpush_rcsum(skb, skb->data, ETH_HLEN);
-	}
+	if (skb->dev->type == ARPHRD_ETHER)
+		skb_push_rcsum(skb, ETH_HLEN);
+
 	ovs_vport_receive(vport, skb, skb_tunnel_info(skb));
 	return;
 error:
-- 
2.27.0

