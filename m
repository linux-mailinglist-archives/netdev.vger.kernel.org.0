Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2B416A6D7
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgBXNHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:07:41 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:47029 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgBXNHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:07:41 -0500
Received: by mail-lj1-f193.google.com with SMTP id x14so9970185ljd.13
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 05:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mChaMVvWNoAtZi1nGZc55W0b1jW6bAc+WtjlbD6LhY0=;
        b=TR5eC0USeU6oHi0apikX1wcNfk3mz1J8HDHbv0m2R5/3V7m8B7lB6BstgHCOw80Lhb
         v/wWZiuDFlyTWepMzzkvYTroUVlKIkhBky8nmVDqmUWQ0s963F45OgFicE7/TmqCh5KE
         fg9r761XKu3hAa/jWqyJ7vHmnEnc4uNjexd+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mChaMVvWNoAtZi1nGZc55W0b1jW6bAc+WtjlbD6LhY0=;
        b=Lj5mN3Z4SOM8nBX9yjzX86OUe0H5Zk5X/wokL8LfgV29xz0U6+ySYhq0hxD1mlivZa
         fAt6XLpkaoLJQUyaaKpCHhV0whDHwVm2xSWfYtCzi5M5Lsxl/3b3yKoohLe+PLb4jfJ8
         kp9N6buazAYuyM7KOp35292cIBbm2+fmonnx/29Ht9QeuVFnxfBoupHFpOicTuLJkoUL
         3avRnfVGqC4GEZ/Mz8ZxonL2leC2/MRrhmfiBCE2X/A/0u9FyYel4rmlZBEZ03ggZCma
         Mto3QuBpR3nq9mbs31WimmaPrXTbIv4Cfg9RKfXF+Tng7dQ3n704qHaiVLTb2LRrnVtq
         eRdQ==
X-Gm-Message-State: APjAAAWg8Sd6AbjpNlI8flG7k4v+fSwDRlhjKAPzBxNC7DLuo17OF05a
        TRjgdOcHyEE7/S+ytoxgIML3VifitoM=
X-Google-Smtp-Source: APXvYqy7enhY1nUpwuiC4uB6pGMocRAbpJn5qLa/q1pLmunxc7PhA7lTtXUbrWHp0F7Uyk96A8kfyg==
X-Received: by 2002:a2e:556:: with SMTP id 83mr30277524ljf.127.1582549657707;
        Mon, 24 Feb 2020 05:07:37 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t21sm6187772ljh.14.2020.02.24.05.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 05:07:37 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        syzbot+18c8b623c66fc198c493@syzkaller.appspotmail.com
Subject: [PATCH net] net: bridge: fix stale eth hdr pointer in br_dev_xmit
Date:   Mon, 24 Feb 2020 15:07:15 +0200
Message-Id: <20200224130715.1446935-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <08a2e28b-fcf5-b26c-da75-97df67f51c7c@cumulusnetworks.com>
References: <08a2e28b-fcf5-b26c-da75-97df67f51c7c@cumulusnetworks.com>
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

Reported-by: syzbot+18c8b623c66fc198c493@syzkaller.appspotmail.com
Fixes: 057658cb33fb ("bridge: suppress arp pkts on BR_NEIGH_SUPPRESS ports")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
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

