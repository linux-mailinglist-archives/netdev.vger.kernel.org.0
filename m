Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED04A228789
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730664AbgGURlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730407AbgGURlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:02 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18D63C0619DD
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:02 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 11FD093AC9;
        Tue, 21 Jul 2020 18:33:02 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352782; bh=31X/TduiWYx1oeJfSaTJJzIWA0gAnDq+S3IJ4q9W+8U=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2020/29]=20l2tp:=20cleanup=20netlink=20send=20of=20tunnel=20ad
         dress=20information|Date:=20Tue,=2021=20Jul=202020=2018:32:12=20+0
         100|Message-Id:=20<20200721173221.4681-21-tparkin@katalix.com>|In-
         Reply-To:=20<20200721173221.4681-1-tparkin@katalix.com>|References
         :=20<20200721173221.4681-1-tparkin@katalix.com>;
        b=vwuKf21Yo9jNDlA/SDtGci7Juu1QVCqQ3HD4WGcXbqsGDgtdZziBlzjwlvrhU5J1g
         A7/fG5BXBKgvsteR+HSn5VvlurSywT9xUkw6s9v0thoc8Mg7ULaMIM66ntUr8GTv0Q
         rY+5M6+xnTDK35L2b3cQlFPc04GLKtTNK7rNgSOTtVVXGtnCLb0Mo5OSkpqradVkyD
         /79weOPD3NkteGDQ1MEeEnyQ5nabg4HdjkeE5nNKbHzGfkLiGsemWczFDk1DRBgnr8
         yb62akREVlVs54mkADf8oGZGtXEG+p8sCYRyuak3jPVdMTSVLx0a0dB0TmFRooTmWL
         qYHHsMyGNuiLw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 20/29] l2tp: cleanup netlink send of tunnel address information
Date:   Tue, 21 Jul 2020 18:32:12 +0100
Message-Id: <20200721173221.4681-21-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp_nl_tunnel_send has conditionally compiled code to support AF_INET6,
which makes the code difficult to follow and triggers checkpatch
warnings.

Split the code out into functions to handle the AF_INET v.s. AF_INET6
cases, which both improves readability and resolves the checkpatch
warnings.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_netlink.c | 126 ++++++++++++++++++++++------------------
 1 file changed, 70 insertions(+), 56 deletions(-)

diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index ac5769ef8e20..8e03f2e367a0 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -310,16 +310,79 @@ static int l2tp_nl_cmd_tunnel_modify(struct sk_buff *skb, struct genl_info *info
 	return ret;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static int l2tp_nl_tunnel_send_addr6(struct sk_buff *skb, struct sock *sk,
+				     enum l2tp_encap_type encap)
+{
+	struct inet_sock *inet = inet_sk(sk);
+	struct ipv6_pinfo *np = inet6_sk(sk);
+
+	switch (encap) {
+	case L2TP_ENCAPTYPE_UDP:
+		if (udp_get_no_check6_tx(sk) &&
+		    nla_put_flag(skb, L2TP_ATTR_UDP_ZERO_CSUM6_TX))
+			return -1;
+		if (udp_get_no_check6_rx(sk) &&
+		    nla_put_flag(skb, L2TP_ATTR_UDP_ZERO_CSUM6_RX))
+			return -1;
+		if (nla_put_u16(skb, L2TP_ATTR_UDP_SPORT, ntohs(inet->inet_sport)) ||
+		    nla_put_u16(skb, L2TP_ATTR_UDP_DPORT, ntohs(inet->inet_dport)))
+			return -1;
+		fallthrough;
+	case L2TP_ENCAPTYPE_IP:
+		if (nla_put_in6_addr(skb, L2TP_ATTR_IP6_SADDR, &np->saddr) ||
+		    nla_put_in6_addr(skb, L2TP_ATTR_IP6_DADDR, &sk->sk_v6_daddr))
+			return -1;
+		break;
+	}
+	return 0;
+}
+#endif
+
+static int l2tp_nl_tunnel_send_addr4(struct sk_buff *skb, struct sock *sk,
+				     enum l2tp_encap_type encap)
+{
+	struct inet_sock *inet = inet_sk(sk);
+
+	switch (encap) {
+	case L2TP_ENCAPTYPE_UDP:
+		if (nla_put_u8(skb, L2TP_ATTR_UDP_CSUM, !sk->sk_no_check_tx) ||
+		    nla_put_u16(skb, L2TP_ATTR_UDP_SPORT, ntohs(inet->inet_sport)) ||
+		    nla_put_u16(skb, L2TP_ATTR_UDP_DPORT, ntohs(inet->inet_dport)))
+			return -1;
+		fallthrough;
+	case L2TP_ENCAPTYPE_IP:
+		if (nla_put_in_addr(skb, L2TP_ATTR_IP_SADDR, inet->inet_saddr) ||
+		    nla_put_in_addr(skb, L2TP_ATTR_IP_DADDR, inet->inet_daddr))
+			return -1;
+		break;
+	}
+
+	return 0;
+}
+
+/* Append attributes for the tunnel address, handling the different attribute types
+ * used for different tunnel encapsulation and AF_INET v.s. AF_INET6.
+ */
+static int l2tp_nl_tunnel_send_addr(struct sk_buff *skb, struct l2tp_tunnel *tunnel)
+{
+	struct sock *sk = tunnel->sock;
+
+	if (!sk)
+		return 0;
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family == AF_INET6)
+		return l2tp_nl_tunnel_send_addr6(skb, sk, tunnel->encap);
+#endif
+	return l2tp_nl_tunnel_send_addr4(skb, sk, tunnel->encap);
+}
+
 static int l2tp_nl_tunnel_send(struct sk_buff *skb, u32 portid, u32 seq, int flags,
 			       struct l2tp_tunnel *tunnel, u8 cmd)
 {
 	void *hdr;
 	struct nlattr *nest;
-	struct sock *sk = NULL;
-	struct inet_sock *inet;
-#if IS_ENABLED(CONFIG_IPV6)
-	struct ipv6_pinfo *np = NULL;
-#endif
 
 	hdr = genlmsg_put(skb, portid, seq, &l2tp_nl_family, flags, cmd);
 	if (!hdr)
@@ -363,58 +426,9 @@ static int l2tp_nl_tunnel_send(struct sk_buff *skb, u32 portid, u32 seq, int fla
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);
 
-	sk = tunnel->sock;
-	if (!sk)
-		goto out;
-
-#if IS_ENABLED(CONFIG_IPV6)
-	if (sk->sk_family == AF_INET6)
-		np = inet6_sk(sk);
-#endif
-
-	inet = inet_sk(sk);
-
-	switch (tunnel->encap) {
-	case L2TP_ENCAPTYPE_UDP:
-		switch (sk->sk_family) {
-		case AF_INET:
-			if (nla_put_u8(skb, L2TP_ATTR_UDP_CSUM, !sk->sk_no_check_tx))
-				goto nla_put_failure;
-			break;
-#if IS_ENABLED(CONFIG_IPV6)
-		case AF_INET6:
-			if (udp_get_no_check6_tx(sk) &&
-			    nla_put_flag(skb, L2TP_ATTR_UDP_ZERO_CSUM6_TX))
-				goto nla_put_failure;
-			if (udp_get_no_check6_rx(sk) &&
-			    nla_put_flag(skb, L2TP_ATTR_UDP_ZERO_CSUM6_RX))
-				goto nla_put_failure;
-			break;
-#endif
-		}
-		if (nla_put_u16(skb, L2TP_ATTR_UDP_SPORT, ntohs(inet->inet_sport)) ||
-		    nla_put_u16(skb, L2TP_ATTR_UDP_DPORT, ntohs(inet->inet_dport)))
-			goto nla_put_failure;
-		/* fall through  */
-	case L2TP_ENCAPTYPE_IP:
-#if IS_ENABLED(CONFIG_IPV6)
-		if (np) {
-			if (nla_put_in6_addr(skb, L2TP_ATTR_IP6_SADDR,
-					     &np->saddr) ||
-			    nla_put_in6_addr(skb, L2TP_ATTR_IP6_DADDR,
-					     &sk->sk_v6_daddr))
-				goto nla_put_failure;
-		} else
-#endif
-		if (nla_put_in_addr(skb, L2TP_ATTR_IP_SADDR,
-				    inet->inet_saddr) ||
-		    nla_put_in_addr(skb, L2TP_ATTR_IP_DADDR,
-				    inet->inet_daddr))
-			goto nla_put_failure;
-		break;
-	}
+	if (l2tp_nl_tunnel_send_addr(skb, tunnel))
+		goto nla_put_failure;
 
-out:
 	genlmsg_end(skb, hdr);
 	return 0;
 
-- 
2.17.1

