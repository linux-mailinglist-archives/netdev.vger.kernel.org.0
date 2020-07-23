Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D32822ADC7
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgGWLaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728536AbgGWLaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:30:05 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DB82C0619E2
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 04:30:05 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 8A8D28AD78;
        Thu, 23 Jul 2020 12:30:04 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595503804; bh=YW3I8SnzAhZlI7sWArroBiyLFJrQvSqW5Ja3udfmjBc=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=204/6]=20l2tp:=20cleanup=20netli
         nk=20send=20of=20tunnel=20address=20information|Date:=20Thu,=2023=
         20Jul=202020=2012:29:53=20+0100|Message-Id:=20<20200723112955.1980
         8-5-tparkin@katalix.com>|In-Reply-To:=20<20200723112955.19808-1-tp
         arkin@katalix.com>|References:=20<20200723112955.19808-1-tparkin@k
         atalix.com>;
        b=MVtklMjWC1klW9HI+vnqVodI/zHUNIv9elxKWOvxYgQxSRErOnqiDfgNGGoMVTF85
         AKBuAt/ldIp8+vYwo1kcCX2Azb97SdSfXUtLEJffRw/EEfDfiXEu9tK0Lku30qRr7P
         Vae2WEgVYAQLBx2JOj396AjsmmqUSRlreadiPA6QsFIysj6Q9EzWQxEAFRAeV/8C7E
         NA5cFxRLNppn05WcIOZKCoeDAldBWevu4wCQpydgcjE4bIBZiB5gEWBEuier8asiOn
         IKSSt77WVZnucexXYoyHPznFtNhLLY7yHmYrA/Klm+6Qrgm/m5t1dZWqa0/jixXTEz
         9Dt/tXEf1E3FQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 4/6] l2tp: cleanup netlink send of tunnel address information
Date:   Thu, 23 Jul 2020 12:29:53 +0100
Message-Id: <20200723112955.19808-5-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200723112955.19808-1-tparkin@katalix.com>
References: <20200723112955.19808-1-tparkin@katalix.com>
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
index fc26ebad2f4f..0021cc03417e 100644
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

