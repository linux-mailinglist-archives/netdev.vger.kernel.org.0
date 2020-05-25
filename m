Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDB81E1772
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 23:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388974AbgEYVy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 17:54:29 -0400
Received: from correo.us.es ([193.147.175.20]:47308 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389349AbgEYVy1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 17:54:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F406FF8D70
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 23:54:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4C4EDA714
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 23:54:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D9932DA710; Mon, 25 May 2020 23:54:26 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0051DA70E;
        Mon, 25 May 2020 23:54:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 May 2020 23:54:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9BBB942EE38E;
        Mon, 25 May 2020 23:54:24 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 1/5] netfilter: nft_reject_bridge: enable reject with bridge vlan
Date:   Mon, 25 May 2020 23:54:16 +0200
Message-Id: <20200525215420.2290-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200525215420.2290-1-pablo@netfilter.org>
References: <20200525215420.2290-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Braun <michael-dev@fami-braun.de>

Currently, using the bridge reject target with tagged packets
results in untagged packets being sent back.

Fix this by mirroring the vlan id as well.

Fixes: 85f5b3086a04 ("netfilter: bridge: add reject support")
Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nft_reject_bridge.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index b325b569e761..f48cf4cfb80f 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -31,6 +31,12 @@ static void nft_reject_br_push_etherhdr(struct sk_buff *oldskb,
 	ether_addr_copy(eth->h_dest, eth_hdr(oldskb)->h_source);
 	eth->h_proto = eth_hdr(oldskb)->h_proto;
 	skb_pull(nskb, ETH_HLEN);
+
+	if (skb_vlan_tag_present(oldskb)) {
+		u16 vid = skb_vlan_tag_get(oldskb);
+
+		__vlan_hwaccel_put_tag(nskb, oldskb->vlan_proto, vid);
+	}
 }
 
 static int nft_bridge_iphdr_validate(struct sk_buff *skb)
-- 
2.20.1

