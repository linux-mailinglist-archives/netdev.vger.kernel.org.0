Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D84836A606
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 11:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhDYJWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 05:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhDYJWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 05:22:48 -0400
Received: from daxilon.jbeekman.nl (jbeekman.nl [IPv6:2a01:7c8:aab4:5fb::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53027C061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 02:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=jbeekman.nl
        ; s=main; h=Subject:Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:To:From:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nC1EmQC2aDc1D3V92LRuQ9iWwJu2uRPFq4IPsbVeQ9w=; b=C3l80p5UG0fJAIhj3wPPvbAjt3
        EAFDh9RULZ56TdGy1+cEu0kTZj3heEeEL9IxjV7YZ3/6DnveYkV6z2BG7KSyt8o0D7f+ocYBui15Z
        G0A9iBhJdhtpEdQAZo7BEwyLquY5QKecBAxZ8sQfHggYuxQAeqmXPL+TtFFeDNtWq22oVxATND0BJ
        VWSY/kNtcXvdtbQFExOIz2/tJxwINVTV+hipzG0qkUJn0IadWZdK77YqP4UeFhXU7Qc9rZnabiBGm
        0zs4+T1A+L1NUDe+uYJ5TNnEEoavAzq16egmJoUEx9GFSboo7H9/m0nL9A2W9oeBPZ+akNAeikHmT
        bh9ewALQ==;
Received: from ip-213-127-124-30.ip.prioritytelecom.net ([213.127.124.30] helo=[192.168.3.100])
        by daxilon.jbeekman.nl with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <kernel@jbeekman.nl>)
        id 1laaxo-0001uQ-3S; Sun, 25 Apr 2021 11:22:04 +0200
From:   Jethro Beekman <kernel@jbeekman.nl>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Message-ID: <2afc4d46-aa9b-a7db-d872-d02163b1f29c@jbeekman.nl>
Date:   Sun, 25 Apr 2021 11:22:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 213.127.124.30
X-SA-Exim-Mail-From: kernel@jbeekman.nl
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on daxilon.jbeekman.nl
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Report: Content analysis details:   (-2.9 points, 5.0 required)
        pts rule name              description
        --- ---------------------- --------------------------------------------------
        -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
        0.0 URIBL_BLOCKED          ADMINISTRATOR NOTICE: The query to URIBL was
        blocked.  See
        http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        for more information.
        [URIs: jbeekman.nl]
        -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
        [score: 0.0000]
Subject: [PATCH v2 net-next] macvlan: Add nodst option to macvlan type source
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The default behavior for source MACVLAN is to duplicate packets to
appropriate type source devices, and then do the normal destination MACVLAN
flow. This patch adds an option to skip destination MACVLAN processing if
any matching source MACVLAN device has the option set.

This allows setting up a "catch all" device for source MACVLAN: create one
or more devices with type source nodst, and one device with e.g. type vepa,
and incoming traffic will be received on exactly one device.

v2: netdev wants non-standard line length

Signed-off-by: Jethro Beekman <kernel@jbeekman.nl>
---
 drivers/net/macvlan.c        | 19 ++++++++++++++-----
 include/uapi/linux/if_link.h |  1 +
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 9a9a5cf36a4b..7427b989607e 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -423,18 +423,24 @@ static void macvlan_forward_source_one(struct sk_buff *skb,
 	macvlan_count_rx(vlan, len, ret == NET_RX_SUCCESS, false);
 }
 
-static void macvlan_forward_source(struct sk_buff *skb,
+static bool macvlan_forward_source(struct sk_buff *skb,
 				   struct macvlan_port *port,
 				   const unsigned char *addr)
 {
 	struct macvlan_source_entry *entry;
 	u32 idx = macvlan_eth_hash(addr);
 	struct hlist_head *h = &port->vlan_source_hash[idx];
+	bool consume = false;
 
 	hlist_for_each_entry_rcu(entry, h, hlist) {
-		if (ether_addr_equal_64bits(entry->addr, addr))
+		if (ether_addr_equal_64bits(entry->addr, addr)) {
+			if (entry->vlan->flags & MACVLAN_FLAG_NODST)
+				consume = true;
 			macvlan_forward_source_one(skb, entry->vlan);
+		}
 	}
+
+	return consume;
 }
 
 /* called under rcu_read_lock() from netif_receive_skb */
@@ -463,7 +469,8 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
 			return RX_HANDLER_CONSUMED;
 		*pskb = skb;
 		eth = eth_hdr(skb);
-		macvlan_forward_source(skb, port, eth->h_source);
+		if (macvlan_forward_source(skb, port, eth->h_source))
+			return RX_HANDLER_CONSUMED;
 		src = macvlan_hash_lookup(port, eth->h_source);
 		if (src && src->mode != MACVLAN_MODE_VEPA &&
 		    src->mode != MACVLAN_MODE_BRIDGE) {
@@ -482,7 +489,8 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
 		return RX_HANDLER_PASS;
 	}
 
-	macvlan_forward_source(skb, port, eth->h_source);
+	if (macvlan_forward_source(skb, port, eth->h_source))
+		return RX_HANDLER_CONSUMED;
 	if (macvlan_passthru(port))
 		vlan = list_first_or_null_rcu(&port->vlans,
 					      struct macvlan_dev, list);
@@ -1286,7 +1294,8 @@ static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[],
 		return 0;
 
 	if (data[IFLA_MACVLAN_FLAGS] &&
-	    nla_get_u16(data[IFLA_MACVLAN_FLAGS]) & ~MACVLAN_FLAG_NOPROMISC)
+	    nla_get_u16(data[IFLA_MACVLAN_FLAGS]) & ~(MACVLAN_FLAG_NOPROMISC |
+						      MACVLAN_FLAG_NODST))
 		return -EINVAL;
 
 	if (data[IFLA_MACVLAN_MODE]) {
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 91c8dda6d95d..cd5b382a4138 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -614,6 +614,7 @@ enum macvlan_macaddr_mode {
 };
 
 #define MACVLAN_FLAG_NOPROMISC	1
+#define MACVLAN_FLAG_NODST	2 /* skip dst macvlan if matching src macvlan */
 
 /* VRF section */
 enum {
-- 
2.31.1

