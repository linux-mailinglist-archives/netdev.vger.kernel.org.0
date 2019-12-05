Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C81DD113EFF
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 11:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfLEKDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 05:03:48 -0500
Received: from fd.dlink.ru ([178.170.168.18]:38436 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbfLEKDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 05:03:47 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 0DCFD1B214D6; Thu,  5 Dec 2019 13:03:43 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 0DCFD1B214D6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1575540224; bh=yI7KF/bM4Qa4hyw06HNlRSt7/ikY+NEJAJCnnl7lFyY=;
        h=From:To:Cc:Subject:Date;
        b=HNhL63xCyq243WuhJA1bkWHqxknokV8KgpHTlCqpuj+wcYHSLqeU/yApJ6+XKsdAO
         Wycy6lRs3et8dSpMHkLzzruDRj6O6CsfGMyJzfniIROvtEgCllYi+CmUFks1JsqRvs
         TwpwZnQ4knnIjGAmVmZDBk8T5lpZlvWDle7S0jkw=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 403331B20144;
        Thu,  5 Dec 2019 13:03:26 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 403331B20144
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 005F01B219AA;
        Thu,  5 Dec 2019 13:03:24 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Thu,  5 Dec 2019 13:03:24 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Muciri Gatimu <muciri@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>,
        John Crispin <john@phrozen.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Alexander Lobakin <alobakin@dlink.ru>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: dsa: fix flow dissection on Tx path
Date:   Thu,  5 Dec 2019 13:02:35 +0300
Message-Id: <20191205100235.14195-1-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 43e665287f93 ("net-next: dsa: fix flow dissection") added an
ability to override protocol and network offset during flow dissection
for DSA-enabled devices (i.e. controllers shipped as switch CPU ports)
in order to fix skb hashing for RPS on Rx path.

However, skb_hash() and added part of code can be invoked not only on
Rx, but also on Tx path if we have a multi-queued device and:
 - kernel is running on UP system or
 - XPS is not configured.

The call stack in this two cases will be like: dev_queue_xmit() ->
__dev_queue_xmit() -> netdev_core_pick_tx() -> netdev_pick_tx() ->
skb_tx_hash() -> skb_get_hash().

The problem is that skbs queued for Tx have both network offset and
correct protocol already set up even after inserting a CPU tag by DSA
tagger, so calling tag_ops->flow_dissect() on this path actually only
breaks flow dissection and hashing.

This can be observed by adding debug prints just before and right after
tag_ops->flow_dissect() call to the related block of code:

Before the patch:

Rx path (RPS):

[   19.240001] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
[   19.244271] tag_ops->flow_dissect()
[   19.247811] Rx: proto: 0x0800, nhoff: 8	/* ETH_P_IP */

[   19.215435] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
[   19.219746] tag_ops->flow_dissect()
[   19.223241] Rx: proto: 0x0806, nhoff: 8	/* ETH_P_ARP */

[   18.654057] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
[   18.658332] tag_ops->flow_dissect()
[   18.661826] Rx: proto: 0x8100, nhoff: 8	/* ETH_P_8021Q */

Tx path (UP system):

[   18.759560] Tx: proto: 0x0800, nhoff: 26	/* ETH_P_IP */
[   18.763933] tag_ops->flow_dissect()
[   18.767485] Tx: proto: 0x920b, nhoff: 34	/* junk */

[   22.800020] Tx: proto: 0x0806, nhoff: 26	/* ETH_P_ARP */
[   22.804392] tag_ops->flow_dissect()
[   22.807921] Tx: proto: 0x920b, nhoff: 34	/* junk */

[   16.898342] Tx: proto: 0x86dd, nhoff: 26	/* ETH_P_IPV6 */
[   16.902705] tag_ops->flow_dissect()
[   16.906227] Tx: proto: 0x920b, nhoff: 34	/* junk */

After:

Rx path (RPS):

[   16.520993] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
[   16.525260] tag_ops->flow_dissect()
[   16.528808] Rx: proto: 0x0800, nhoff: 8	/* ETH_P_IP */

[   15.484807] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
[   15.490417] tag_ops->flow_dissect()
[   15.495223] Rx: proto: 0x0806, nhoff: 8	/* ETH_P_ARP */

[   17.134621] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
[   17.138895] tag_ops->flow_dissect()
[   17.142388] Rx: proto: 0x8100, nhoff: 8	/* ETH_P_8021Q */

Tx path (UP system):

[   15.499558] Tx: proto: 0x0800, nhoff: 26	/* ETH_P_IP */

[   20.664689] Tx: proto: 0x0806, nhoff: 26	/* ETH_P_ARP */

[   18.565782] Tx: proto: 0x86dd, nhoff: 26	/* ETH_P_IPV6 */

In order to fix that we can add the check 'proto == htons(ETH_P_XDSA)'
to prevent code from calling tag_ops->flow_dissect() on Tx.
I also decided to initialize 'offset' variable so tagger callbacks can
now safely leave it untouched without provoking a chaos.

Fixes: 43e665287f93 ("net-next: dsa: fix flow dissection")
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 net/core/flow_dissector.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 69395b804709..d524a693e00f 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -969,9 +969,10 @@ bool __skb_flow_dissect(const struct net *net,
 		nhoff = skb_network_offset(skb);
 		hlen = skb_headlen(skb);
 #if IS_ENABLED(CONFIG_NET_DSA)
-		if (unlikely(skb->dev && netdev_uses_dsa(skb->dev))) {
+		if (unlikely(skb->dev && netdev_uses_dsa(skb->dev) &&
+			     proto == htons(ETH_P_XDSA))) {
 			const struct dsa_device_ops *ops;
-			int offset;
+			int offset = 0;
 
 			ops = skb->dev->dsa_ptr->tag_ops;
 			if (ops->flow_dissect &&
-- 
2.24.0

