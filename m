Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6589716ABFC
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 17:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgBXQqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 11:46:34 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41814 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgBXQqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 11:46:34 -0500
Received: by mail-lj1-f196.google.com with SMTP id h23so10869004ljc.8
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 08:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KlzZTw/zsM+mHRD9C+w/KLZyZ8oyoiKmmQWyQ1wQFKo=;
        b=cb7xwylQmtYWxawQ959uekX5jF4nO8RFP5CCSKs24JW2oM2ZOS1KCQO4AHRiiG/Kth
         60wZgQXQIjDRF198UipR/GSeQnI76tCZ/2jBF+jf3hCokwAIUFnkKCJlvWXqKdFrrG18
         mDZ7fcSZTzvqczeSPB8QZyioVKIxjotTCoGAg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KlzZTw/zsM+mHRD9C+w/KLZyZ8oyoiKmmQWyQ1wQFKo=;
        b=nl7x9Td8H32FT8SbX0yGrpYajkW+d2r4lSkenyJwN4U40AbmVtRmGxz4OkW8/xvN09
         qGR5A2PAZt35hudfYHa+GRlJsvEinQ1e+irQ9apyDbl4Yy6bYOAO+0vYXSC+/70jHwEV
         KiqNSkoJP1oHKbHYoUFWL2o2WxAl7+m7SPLb9nVM0zWebmBGgzOruVE+hYwzbbIsLEpd
         Hs1gjYo22ipKLROHGoxJjt0P5xhVZdrwViDJUNAAK/gLzRbu+f3aetxFgYa1nswfjPlB
         L7jVW8bbmdvwsEzS/NbXLD7h7PvlwX8roYZ0lf0hHZFk+t3GujaO5ldRDIkQ+0y1bFf2
         JBnw==
X-Gm-Message-State: APjAAAUGxYl/pN1pZz58kUs+cZV8nzIAqXRJje0xtNj0JB+VDb3OCOeE
        6aSeFInURYpYalmGMs1ADg5kNrWAhb0=
X-Google-Smtp-Source: APXvYqxlSlQyErPFoueeAe4DEhVEzzr5u63/LYIqMtSyhTRf6tQ4/pdE7jVgVPtTM3NqOBKJRakyqw==
X-Received: by 2002:a05:651c:1a2:: with SMTP id c2mr32127323ljn.79.1582562791188;
        Mon, 24 Feb 2020 08:46:31 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i67sm3804654lfi.11.2020.02.24.08.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 08:46:30 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net v2] net: bridge: fix stale eth hdr pointer in br_dev_xmit
Date:   Mon, 24 Feb 2020 18:46:22 +0200
Message-Id: <20200224164622.1472051-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <83cadec7-d659-cf2a-c0c0-a85d2f6503bc@cumulusnetworks.com>
References: <83cadec7-d659-cf2a-c0c0-a85d2f6503bc@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In br_dev_xmit() we perform vlan filtering in br_allowed_ingress() but
if the packet has the vlan header inside (e.g. bridge with disabled
tx-vlan-offload) then the vlan filtering code will use skb_vlan_untag()
to extract the vid before filtering which in turn calls pskb_may_pull()
and we may end up with a stale eth pointer. Moreover the cached eth header
pointer will generally be wrong after that operation. Remove the eth header
caching and just use eth_hdr() directly, the compiler does the right thing
and calculates it only once so we don't lose anything.

Fixes: 057658cb33fb ("bridge: suppress arp pkts on BR_NEIGH_SUPPRESS ports")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
v2: remove syzbot's reported-by tag, this seems to be a different bug

 net/bridge/br_device.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index dc3d2c1dd9d5..0e3dbc5f3c34 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -34,7 +34,6 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	const struct nf_br_ops *nf_ops;
 	u8 state = BR_STATE_FORWARDING;
 	const unsigned char *dest;
-	struct ethhdr *eth;
 	u16 vid = 0;
 
 	rcu_read_lock();
@@ -54,15 +53,14 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	BR_INPUT_SKB_CB(skb)->frag_max_size = 0;
 
 	skb_reset_mac_header(skb);
-	eth = eth_hdr(skb);
 	skb_pull(skb, ETH_HLEN);
 
 	if (!br_allowed_ingress(br, br_vlan_group_rcu(br), skb, &vid, &state))
 		goto out;
 
 	if (IS_ENABLED(CONFIG_INET) &&
-	    (eth->h_proto == htons(ETH_P_ARP) ||
-	     eth->h_proto == htons(ETH_P_RARP)) &&
+	    (eth_hdr(skb)->h_proto == htons(ETH_P_ARP) ||
+	     eth_hdr(skb)->h_proto == htons(ETH_P_RARP)) &&
 	    br_opt_get(br, BROPT_NEIGH_SUPPRESS_ENABLED)) {
 		br_do_proxy_suppress_arp(skb, br, vid, NULL);
 	} else if (IS_ENABLED(CONFIG_IPV6) &&
-- 
2.24.1

