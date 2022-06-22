Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77364556E93
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 00:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358275AbiFVWhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 18:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241081AbiFVWhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 18:37:06 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964F940920
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 15:37:05 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id l4so17362048pgh.13
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 15:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aOOC6w7tcK8YAozx/l7DkxqRFo0vrrcy2NbyMYSNBZc=;
        b=WvXJJeRlXwtox/SCr/vmFW+PKSnADw7tIprG1wcNfqnHC/zLW3aVU4e/T0zxFS19jC
         BCaJqBr2bDb+6LjY3Rx4mpgglRoGYeBmDsF2Y4/36Oujillkx9tUP1mEgQthO1DhSefR
         tFfI1OPGpKT+sy8yYID8A3w+4Nh2nISwshCg0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aOOC6w7tcK8YAozx/l7DkxqRFo0vrrcy2NbyMYSNBZc=;
        b=jntnA1rayELko4UbKSEOIB7lnYPwzj54I7t1ypuYaIXfTOWvFDAMfFHu0ef5jg+P5s
         AEU6GGi7jYrCHwZ8Oeoqx9GBY9V43AEyYg1Ab+OXqM2kqL+wRRPRKeDQ7o6ISYXabmRy
         TGM07gt6N4pIClNbcKKrx7O9B/L7mnz4AJfaSbJ7eUe8HdPe7aNUTt9fHTEbJllfo8eb
         86pMlmPtBqAqHEG9olYq4NqiDiXXNMENf84lIfO73jiJnYqze7VEe3jIjkcUeIXyTSTg
         30I4JsYf4O/jgtZFxTa/1ekdpXjN3vMxYeFBFqHv4mPDYBed9SnZMCIjt1sjkVWq9hml
         BHZg==
X-Gm-Message-State: AJIora+Wtt7w214cXJZZDxQcYScticw4F9UIj4t2SIkEjIxeqnbS33jy
        q2tAIGtDJJvW6f1em6Y9OcxfqVxC4SZG3A==
X-Google-Smtp-Source: AGRyM1uZh0N5ow3h8UG1mkytB5RetAbqfgPN85qz74yLXKM1VU+rT5u08aB0xP/lZoZJqJbdo49Biw==
X-Received: by 2002:a05:6a00:10d4:b0:522:8c31:ec23 with SMTP id d20-20020a056a0010d400b005228c31ec23mr37983499pfu.67.1655937425121;
        Wed, 22 Jun 2022 15:37:05 -0700 (PDT)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id v21-20020a17090331d500b0016a1e2d148fsm7518827ple.64.2022.06.22.15.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 15:37:04 -0700 (PDT)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, d.michailidis@fungible.com
Subject: [PATCH net-next] net/funeth: Support UDP segmentation offload
Date:   Wed, 22 Jun 2022 15:37:03 -0700
Message-Id: <20220622223703.59886-1-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle skbs with SKB_GSO_UDP_L4, advertise the offload in features, and
add an ethtool counter for it. Small change to existing TSO code due to
UDP's different header length.

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 .../ethernet/fungible/funeth/funeth_ethtool.c |  2 ++
 .../ethernet/fungible/funeth/funeth_main.c    |  3 ++-
 .../net/ethernet/fungible/funeth/funeth_tx.c  | 23 ++++++++++++++++++-
 .../ethernet/fungible/funeth/funeth_txrx.h    |  1 +
 4 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_ethtool.c b/drivers/net/ethernet/fungible/funeth/funeth_ethtool.c
index d081168c95fa..da42dd53a87c 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_ethtool.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_ethtool.c
@@ -78,6 +78,7 @@ static const char * const txq_stat_names[] = {
 	"tx_cso",
 	"tx_tso",
 	"tx_encapsulated_tso",
+	"tx_uso",
 	"tx_more",
 	"tx_queue_stops",
 	"tx_queue_restarts",
@@ -778,6 +779,7 @@ static void fun_get_ethtool_stats(struct net_device *netdev,
 		ADD_STAT(txs.tx_cso);
 		ADD_STAT(txs.tx_tso);
 		ADD_STAT(txs.tx_encap_tso);
+		ADD_STAT(txs.tx_uso);
 		ADD_STAT(txs.tx_more);
 		ADD_STAT(txs.tx_nstops);
 		ADD_STAT(txs.tx_nrestarts);
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index 9485cf699c5d..f247b7ad3a88 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -1357,7 +1357,8 @@ static const struct net_device_ops fun_netdev_ops = {
 #define GSO_ENCAP_FLAGS (NETIF_F_GSO_GRE | NETIF_F_GSO_IPXIP4 | \
 			 NETIF_F_GSO_IPXIP6 | NETIF_F_GSO_UDP_TUNNEL | \
 			 NETIF_F_GSO_UDP_TUNNEL_CSUM)
-#define TSO_FLAGS (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN)
+#define TSO_FLAGS (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN | \
+		   NETIF_F_GSO_UDP_L4)
 #define VLAN_FEAT (NETIF_F_SG | NETIF_F_HW_CSUM | TSO_FLAGS | \
 		   GSO_ENCAP_FLAGS | NETIF_F_HIGHDMA)
 
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_tx.c b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
index ff6e29237253..0a4a590218ba 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_tx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
@@ -130,6 +130,7 @@ static unsigned int write_pkt_desc(struct sk_buff *skb, struct funeth_txq *q,
 	struct fun_dataop_gl *gle;
 	const struct tcphdr *th;
 	unsigned int ngle, i;
+	unsigned int l4_hlen;
 	u16 flags;
 
 	if (unlikely(map_skb(skb, q->dma_dev, addrs, lens))) {
@@ -178,6 +179,7 @@ static unsigned int write_pkt_desc(struct sk_buff *skb, struct funeth_txq *q,
 						 FUN_ETH_UPDATE_INNER_L3_LEN;
 			}
 			th = inner_tcp_hdr(skb);
+			l4_hlen = __tcp_hdrlen(th);
 			fun_eth_offload_init(&req->offload, flags,
 					     shinfo->gso_size,
 					     tcp_hdr_doff_flags(th), 0,
@@ -185,6 +187,24 @@ static unsigned int write_pkt_desc(struct sk_buff *skb, struct funeth_txq *q,
 					     skb_inner_transport_offset(skb),
 					     skb_network_offset(skb), ol4_ofst);
 			FUN_QSTAT_INC(q, tx_encap_tso);
+		} else if (shinfo->gso_type & SKB_GSO_UDP_L4) {
+			flags = FUN_ETH_INNER_LSO | FUN_ETH_INNER_UDP |
+				FUN_ETH_UPDATE_INNER_L4_CKSUM |
+				FUN_ETH_UPDATE_INNER_L4_LEN |
+				FUN_ETH_UPDATE_INNER_L3_LEN;
+
+			if (ip_hdr(skb)->version == 4)
+				flags |= FUN_ETH_UPDATE_INNER_L3_CKSUM;
+			else
+				flags |= FUN_ETH_INNER_IPV6;
+
+			l4_hlen = sizeof(struct udphdr);
+			fun_eth_offload_init(&req->offload, flags,
+					     shinfo->gso_size,
+					     cpu_to_be16(l4_hlen << 10), 0,
+					     skb_network_offset(skb),
+					     skb_transport_offset(skb), 0, 0);
+			FUN_QSTAT_INC(q, tx_uso);
 		} else {
 			/* HW considers one set of headers as inner */
 			flags = FUN_ETH_INNER_LSO |
@@ -195,6 +215,7 @@ static unsigned int write_pkt_desc(struct sk_buff *skb, struct funeth_txq *q,
 			else
 				flags |= FUN_ETH_UPDATE_INNER_L3_CKSUM;
 			th = tcp_hdr(skb);
+			l4_hlen = __tcp_hdrlen(th);
 			fun_eth_offload_init(&req->offload, flags,
 					     shinfo->gso_size,
 					     tcp_hdr_doff_flags(th), 0,
@@ -209,7 +230,7 @@ static unsigned int write_pkt_desc(struct sk_buff *skb, struct funeth_txq *q,
 
 		extra_pkts = shinfo->gso_segs - 1;
 		extra_bytes = (be16_to_cpu(req->offload.inner_l4_off) +
-			       __tcp_hdrlen(th)) * extra_pkts;
+			       l4_hlen) * extra_pkts;
 	} else if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
 		flags = FUN_ETH_UPDATE_INNER_L4_CKSUM;
 		if (skb->csum_offset == offsetof(struct udphdr, check))
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
index 04c9f91b7489..1711f82cad71 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
+++ b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
@@ -82,6 +82,7 @@ struct funeth_txq_stats {  /* per Tx queue SW counters */
 	u64 tx_cso;        /* # of packets with checksum offload */
 	u64 tx_tso;        /* # of non-encapsulated TSO super-packets */
 	u64 tx_encap_tso;  /* # of encapsulated TSO super-packets */
+	u64 tx_uso;        /* # of non-encapsulated UDP LSO super-packets */
 	u64 tx_more;       /* # of DBs elided due to xmit_more */
 	u64 tx_nstops;     /* # of times the queue has stopped */
 	u64 tx_nrestarts;  /* # of times the queue has restarted */
-- 
2.25.1

