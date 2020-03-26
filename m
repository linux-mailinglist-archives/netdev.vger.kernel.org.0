Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C14193B6F
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 10:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbgCZJC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 05:02:59 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37835 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgCZJC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 05:02:58 -0400
Received: by mail-pl1-f193.google.com with SMTP id x1so1891072plm.4
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 02:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=qKM544i7sMxs7sN6CF+56+EfYgSDyC7c3U6yG2tQvdU=;
        b=Ud33KFWWAaGjrFsILnPjoIBSpeFTCdwroQwP1f4+51BQaopzInefIjpqiArU4EJsak
         UCnOWocFiw/CmPzetmQx7DCEq8/DT7VLIq1/2YBRynwl4R8KcSKIUHxhdXue7aufi12T
         jKng38wnQWeijVM1vAaLlpaDiLUJFwryWJdeuTJKSRTYi3zvB2QvVYTtxnuHAVj1MjUN
         6myB1j1TDJ+7JgvcERi27IEPDvVJavvIOmBwNQpTm5OtzzGZ4llqxhxOUNDjewxjd8kS
         ixkbtNgWAYDwJYTNa8VVaj1lLyEGgZXkzo1rroUEh1VI+1AHB7qCcUvDt4slu3uyww98
         dxaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=qKM544i7sMxs7sN6CF+56+EfYgSDyC7c3U6yG2tQvdU=;
        b=IyiJ4Y3HVPecwKAHrDniv58fijaf37Tg8tS9JDusePqHT117iH/UXG9VMuyfa7mI3W
         L9GBbKPwWibPCfikA6MCKx3TeqXd6oAD4IBI6mgLyiRw0168SbcDVTPChx+1Lo3G4NLq
         4PcZeSfTMQEyud+onCSwTwB2kjHQiYM7OfJMn2s5oe1+WzxgyK1EHGJDvtndM7T2713g
         ncluq8DTl/uQg2hrgOKUV04D2FX5FUKELlps8VfE9VfnCkWcD40CFYF8DaY3skST981R
         uPjCJxHUmvm+9eoweLslTD5GRIe97HLbWPdBOxuiiwyh1OtFp7PkOwKjYRKYiUEBp2Nw
         P/4Q==
X-Gm-Message-State: ANhLgQ3a0U8JIx4oUn+SKHcjgbn1yysH7jK8zYzF6IPW+rWBNKmRRroq
        AyJ1XfIbl+3dCrKXVm5Z66ZxQvAO
X-Google-Smtp-Source: ADFU+vvZ9Q1d2fYNImYGpQedR8Kt/8juTiMrqS4Uif5+kold/2OgL3rkbTydVQqADKUa//fQSWOYxw==
X-Received: by 2002:a17:90a:5888:: with SMTP id j8mr2034701pji.61.1585213377534;
        Thu, 26 Mar 2020 02:02:57 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y18sm1152753pfe.19.2020.03.26.02.02.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2020 02:02:56 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 2/3] esp6: add gso_segment for esp6 beet mode
Date:   Thu, 26 Mar 2020 17:02:30 +0800
Message-Id: <dc705b5bbeee366e76829d3c98c1b438a7dce232.1585213292.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <0baafba3ed70c5e04d437faf83f2c40f57f52540.1585213292.git.lucien.xin@gmail.com>
References: <cover.1585213292.git.lucien.xin@gmail.com>
 <0baafba3ed70c5e04d437faf83f2c40f57f52540.1585213292.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1585213292.git.lucien.xin@gmail.com>
References: <cover.1585213292.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to xfrm6_tunnel/transport_gso_segment(), _gso_segment()
is added to do gso_segment for esp6 beet mode. Before calling
inet6_offloads[proto]->callbacks.gso_segment, it needs to do:

  - Get the upper proto from ph header to get its gso_segment
    when xo->proto is IPPROTO_BEETPH.

  - Add SKB_GSO_TCPV6 to gso_type if x->sel.family != AF_INET6
    and the proto == IPPROTO_TCP, so that the current tcp ipv6
    packet can be segmented.

  - Calculate a right value for skb->transport_header and move
    skb->data to the transport header position.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/esp6_offload.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index fd53505..8eab2c8 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -159,6 +159,40 @@ static struct sk_buff *xfrm6_transport_gso_segment(struct xfrm_state *x,
 	return segs;
 }
 
+static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
+					      struct sk_buff *skb,
+					      netdev_features_t features)
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	struct sk_buff *segs = ERR_PTR(-EINVAL);
+	const struct net_offload *ops;
+	int proto = xo->proto;
+
+	skb->transport_header += x->props.header_len;
+
+	if (proto == IPPROTO_BEETPH) {
+		struct ip_beet_phdr *ph = (struct ip_beet_phdr *)skb->data;
+
+		skb->transport_header += ph->hdrlen * 8;
+		proto = ph->nexthdr;
+	}
+
+	if (x->sel.family != AF_INET6) {
+		skb->transport_header -=
+			(sizeof(struct ipv6hdr) - sizeof(struct iphdr));
+
+		if (proto == IPPROTO_TCP)
+			skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV6;
+	}
+
+	__skb_pull(skb, skb_transport_offset(skb));
+	ops = rcu_dereference(inet6_offloads[proto]);
+	if (likely(ops && ops->callbacks.gso_segment))
+		segs = ops->callbacks.gso_segment(skb, features);
+
+	return segs;
+}
+
 static struct sk_buff *xfrm6_outer_mode_gso_segment(struct xfrm_state *x,
 						    struct sk_buff *skb,
 						    netdev_features_t features)
@@ -168,6 +202,8 @@ static struct sk_buff *xfrm6_outer_mode_gso_segment(struct xfrm_state *x,
 		return xfrm6_tunnel_gso_segment(x, skb, features);
 	case XFRM_MODE_TRANSPORT:
 		return xfrm6_transport_gso_segment(x, skb, features);
+	case XFRM_MODE_BEET:
+		return xfrm6_beet_gso_segment(x, skb, features);
 	}
 
 	return ERR_PTR(-EOPNOTSUPP);
-- 
2.1.0

