Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4400D1EA580
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 16:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgFAODl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 10:03:41 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:63952 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgFAODl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 10:03:41 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 051E3Xdf031664;
        Mon, 1 Jun 2020 07:03:34 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net] crypto/chcr: IPV6 code needs to be in CONFIG_IPV6
Date:   Mon,  1 Jun 2020 19:33:32 +0530
Message-Id: <20200601140332.24516-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Error messages seen while building kernel with CONFIG_IPV6
disabled.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/crypto/chelsio/chcr_ktls.c | 48 ++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index f55b87152166..91dee616d15e 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -221,6 +221,7 @@ static int chcr_ktls_act_open_req(struct sock *sk,
 	return cxgb4_l2t_send(tx_info->netdev, skb, tx_info->l2te);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 /*
  * chcr_ktls_act_open_req6: creates TCB entry for ipv6 connection.
  * @sk - tcp socket.
@@ -270,6 +271,7 @@ static int chcr_ktls_act_open_req6(struct sock *sk,
 
 	return cxgb4_l2t_send(tx_info->netdev, skb, tx_info->l2te);
 }
+#endif /* #if IS_ENABLED(CONFIG_IPV6) */
 
 /*
  * chcr_setup_connection:  create a TCB entry so that TP will form tcp packets.
@@ -290,20 +292,26 @@ static int chcr_setup_connection(struct sock *sk,
 	tx_info->atid = atid;
 	tx_info->ip_family = sk->sk_family;
 
-	if (sk->sk_family == AF_INET ||
-	    (sk->sk_family == AF_INET6 && !sk->sk_ipv6only &&
-	     ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
+	if (sk->sk_family == AF_INET) {
 		tx_info->ip_family = AF_INET;
 		ret = chcr_ktls_act_open_req(sk, tx_info, atid);
+#if IS_ENABLED(CONFIG_IPV6)
 	} else {
-		tx_info->ip_family = AF_INET6;
-		ret =
-		cxgb4_clip_get(tx_info->netdev,
-			       (const u32 *)&sk->sk_v6_rcv_saddr.in6_u.u6_addr8,
-			       1);
-		if (ret)
-			goto out;
-		ret = chcr_ktls_act_open_req6(sk, tx_info, atid);
+		if (!sk->sk_ipv6only &&
+		    ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED) {
+			tx_info->ip_family = AF_INET;
+			ret = chcr_ktls_act_open_req(sk, tx_info, atid);
+		} else {
+			tx_info->ip_family = AF_INET6;
+			ret = cxgb4_clip_get(tx_info->netdev,
+					     (const u32 *)
+					     &sk->sk_v6_rcv_saddr.s6_addr,
+					     1);
+			if (ret)
+				goto out;
+			ret = chcr_ktls_act_open_req6(sk, tx_info, atid);
+		}
+#endif
 	}
 
 	/* if return type is NET_XMIT_CN, msg will be sent but delayed, mark ret
@@ -394,11 +402,13 @@ void chcr_ktls_dev_del(struct net_device *netdev,
 	if (tx_info->l2te)
 		cxgb4_l2t_release(tx_info->l2te);
 
+#if IS_ENABLED(CONFIG_IPV6)
 	/* clear clip entry */
 	if (tx_info->ip_family == AF_INET6)
 		cxgb4_clip_release(netdev,
 				   (const u32 *)&sk->sk_v6_daddr.in6_u.u6_addr8,
 				   1);
+#endif
 
 	/* clear tid */
 	if (tx_info->tid != -1) {
@@ -491,12 +501,16 @@ int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 		goto out2;
 
 	/* get peer ip */
-	if (sk->sk_family == AF_INET ||
-	    (sk->sk_family == AF_INET6 && !sk->sk_ipv6only &&
-	     ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
+	if (sk->sk_family == AF_INET) {
 		memcpy(daaddr, &sk->sk_daddr, 4);
+#if IS_ENABLED(CONFIG_IPV6)
 	} else {
-		memcpy(daaddr, sk->sk_v6_daddr.in6_u.u6_addr8, 16);
+		if (!sk->sk_ipv6only &&
+		    ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)
+			memcpy(daaddr, &sk->sk_daddr, 4);
+		else
+			memcpy(daaddr, sk->sk_v6_daddr.in6_u.u6_addr8, 16);
+#endif
 	}
 
 	/* get the l2t index */
@@ -903,7 +917,9 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 	struct fw_eth_tx_pkt_wr *wr;
 	struct cpl_tx_pkt_core *cpl;
 	u32 ctrl, iplen, maclen;
+#if IS_ENABLED(CONFIG_IPV6)
 	struct ipv6hdr *ip6;
+#endif
 	unsigned int ndesc;
 	struct tcphdr *tcp;
 	int len16, pktlen;
@@ -958,9 +974,11 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 		/* we need to correct ip header len */
 		ip = (struct iphdr *)(buf + maclen);
 		ip->tot_len = htons(pktlen - maclen);
+#if IS_ENABLED(CONFIG_IPV6)
 	} else {
 		ip6 = (struct ipv6hdr *)(buf + maclen);
 		ip6->payload_len = htons(pktlen - maclen - iplen);
+#endif
 	}
 	/* now take care of the tcp header, if fin is not set then clear push
 	 * bit as well, and if fin is set, it will be sent at the last so we
-- 
2.18.1

