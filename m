Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87D6699A03
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjBPQ3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjBPQ3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:29:18 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993354B521
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:16 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-52ed582a847so25791417b3.1
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lp1V6Xqu44WWdH2sIdyairYsXMgAdg6Ez6OAouI1moE=;
        b=DJrf8FZMT3xQE3amPRCcykdqyQchcKQOnwSv1n2t+EcelzP1prrsU/uYS3suwHkVGL
         aO/Y3fRRIqVGJ6RCBDfHNWKDV5yY4/XmNCsIoOptt7vmjFvD/yusS48wburmvf0L2ZYq
         x3ZRGsgfRJUJCtxisMa7hHVS2lpUlOOolpkotvuoQ+UaFfjRJEsfJVvNuI56HdpFZO1M
         ERWmLaMgvDdRX7ELPZONR+uTYlQSPi9Yv4uBa8MoBxlz0fIOZNipSmeIbWDy+J8E1U0b
         QJ0iOWxLZ1+qYiQlhnNbTXWZ8Gj7mRB/h+xE3BjxkVA4e+oeuPAZ1Dz9w0qYlRpPVb4s
         ALsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lp1V6Xqu44WWdH2sIdyairYsXMgAdg6Ez6OAouI1moE=;
        b=Hut8Q7okdvNbdH+JXZ95lCERea/45B0P7cn7LXyQgSWLTOjsyam7Z6hEKh5ZWSOyyx
         lLiUrBsTzrmMkCqEfXS0mXxd64pZpyxu4I/UzMthswDxBBI7Hv9qeR5Va9awoMEhWOqm
         /OOESjiKJMYMtJNs+kt3gWebCzu+qDr20UkLHvCQI6+teU7Ghs65uPWcqAf9wHubSE3N
         ddY4FZrKEuInw/LbwMUYae04q7xXx8qWLDVYY814gFWebzTNEj5Q020XxOEHYIY8yLLl
         GpYhRyu1LwBlNs5vUSnnIhpImYtjHnKRVES0A/FpwfRA7fPDrxkE+PVsTJYckosmglQr
         xXAA==
X-Gm-Message-State: AO0yUKVgAk8gS36bbbzswCnFdepFF2lL0A/VwakEzm9q6dLYL1wA6OUb
        mTQ244lP4SLUykILXfEetK5YYOvCT7rIvA==
X-Google-Smtp-Source: AK7set9MQKOl14OvmiOP6pk04mdiURb45YTEojPJwEXFfGRlvsRXjqHR1zw4bh2Td0miv5I1oq8Q4Zp/nz59sA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1614:b0:8f3:904a:2305 with SMTP
 id bw20-20020a056902161400b008f3904a2305mr17ybb.2.1676564955263; Thu, 16 Feb
 2023 08:29:15 -0800 (PST)
Date:   Thu, 16 Feb 2023 16:28:36 +0000
In-Reply-To: <20230216162842.1633734-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230216162842.1633734-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230216162842.1633734-3-edumazet@google.com>
Subject: [PATCH net-next 2/8] ipv6: icmp6: add drop reason support to ndisc_recv_na()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change ndisc_recv_na() to return a drop reason.

For the moment, return PKT_TOO_SMALL, NOT_SPECIFIED
or SKB_CONSUMED. More reasons are added later.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ndisc.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 039722f83c668ad59eb63ffde98e18ad8947bdcc..9354cb3669c814166fb3d07b32097f0b00ef42f8 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -987,7 +987,7 @@ static int accept_untracked_na(struct net_device *dev, struct in6_addr *saddr)
 	}
 }
 
-static void ndisc_recv_na(struct sk_buff *skb)
+static enum skb_drop_reason ndisc_recv_na(struct sk_buff *skb)
 {
 	struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
 	struct in6_addr *saddr = &ipv6_hdr(skb)->saddr;
@@ -1000,22 +1000,21 @@ static void ndisc_recv_na(struct sk_buff *skb)
 	struct inet6_dev *idev = __in6_dev_get(dev);
 	struct inet6_ifaddr *ifp;
 	struct neighbour *neigh;
+	SKB_DR(reason);
 	u8 new_state;
 
-	if (skb->len < sizeof(struct nd_msg)) {
-		ND_PRINTK(2, warn, "NA: packet too short\n");
-		return;
-	}
+	if (skb->len < sizeof(struct nd_msg))
+		return SKB_DROP_REASON_PKT_TOO_SMALL;
 
 	if (ipv6_addr_is_multicast(&msg->target)) {
 		ND_PRINTK(2, warn, "NA: target address is multicast\n");
-		return;
+		return reason;
 	}
 
 	if (ipv6_addr_is_multicast(daddr) &&
 	    msg->icmph.icmp6_solicited) {
 		ND_PRINTK(2, warn, "NA: solicited NA is multicasted\n");
-		return;
+		return reason;
 	}
 
 	/* For some 802.11 wireless deployments (and possibly other networks),
@@ -1025,18 +1024,18 @@ static void ndisc_recv_na(struct sk_buff *skb)
 	 */
 	if (!msg->icmph.icmp6_solicited && idev &&
 	    idev->cnf.drop_unsolicited_na)
-		return;
+		return reason;
 
 	if (!ndisc_parse_options(dev, msg->opt, ndoptlen, &ndopts)) {
 		ND_PRINTK(2, warn, "NS: invalid ND option\n");
-		return;
+		return reason;
 	}
 	if (ndopts.nd_opts_tgt_lladdr) {
 		lladdr = ndisc_opt_addr_data(ndopts.nd_opts_tgt_lladdr, dev);
 		if (!lladdr) {
 			ND_PRINTK(2, warn,
 				  "NA: invalid link-layer address length\n");
-			return;
+			return reason;
 		}
 	}
 	ifp = ipv6_get_ifaddr(dev_net(dev), &msg->target, dev, 1);
@@ -1044,7 +1043,7 @@ static void ndisc_recv_na(struct sk_buff *skb)
 		if (skb->pkt_type != PACKET_LOOPBACK
 		    && (ifp->flags & IFA_F_TENTATIVE)) {
 				addrconf_dad_failure(skb, ifp);
-				return;
+				return reason;
 		}
 		/* What should we make now? The advertisement
 		   is invalid, but ndisc specs say nothing
@@ -1060,7 +1059,7 @@ static void ndisc_recv_na(struct sk_buff *skb)
 				  "NA: %pM advertised our address %pI6c on %s!\n",
 				  eth_hdr(skb)->h_source, &ifp->addr, ifp->idev->dev->name);
 		in6_ifa_put(ifp);
-		return;
+		return reason;
 	}
 
 	neigh = neigh_lookup(&nd_tbl, &msg->target, dev);
@@ -1121,10 +1120,11 @@ static void ndisc_recv_na(struct sk_buff *skb)
 			 */
 			rt6_clean_tohost(dev_net(dev),  saddr);
 		}
-
+		reason = SKB_CONSUMED;
 out:
 		neigh_release(neigh);
 	}
+	return reason;
 }
 
 static void ndisc_recv_rs(struct sk_buff *skb)
@@ -1840,7 +1840,7 @@ enum skb_drop_reason ndisc_rcv(struct sk_buff *skb)
 		break;
 
 	case NDISC_NEIGHBOUR_ADVERTISEMENT:
-		ndisc_recv_na(skb);
+		reason = ndisc_recv_na(skb);
 		break;
 
 	case NDISC_ROUTER_SOLICITATION:
-- 
2.39.1.581.gbfd45094c4-goog

