Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC08193B6D
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 10:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbgCZJCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 05:02:50 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41382 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgCZJCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 05:02:50 -0400
Received: by mail-pl1-f195.google.com with SMTP id t16so1883704plr.8
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 02:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=G6Gn9p3Ec01xE6utZqG5eed8oBFLxDsG8Rbe5vC1mWU=;
        b=GDtb20Ke2iMzLrgvoHp01kAO9Hvkv+hbdeHnzgttQDbt2BqP5XbQ5jCHf8Avq8T9RN
         Zi8yrGLbjUIm9sHtf8TayvawB8JxEnNlq8SP33xHy91U5Wte9uh/2jQbrzU34H0s770+
         e8KPrJJjfpz9fZyjkSaoxLo9dJrm7SALOEOWT4Kj2QpVnWW/UlUkwusCAxXjCgZDhxB/
         /qDINdvKa0qH0ou6nlFsK5uYvYDJmpF4qaFUua68GHzvcuV/sQ0rd/vbNY6xsOKJArjN
         4poTUm3A1xLMkTMV46cgGjBgctNpNptLUWtF+1lJrSTkLkEKN0sfLcbK2g6MQdazjy0E
         UP+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=G6Gn9p3Ec01xE6utZqG5eed8oBFLxDsG8Rbe5vC1mWU=;
        b=ILxlOAoNysO4z8X1mBAPpVGlXojyXAm2ohzvt9xXbDjreEWJ20Ew73uT9RXRURYR4t
         JqT6P2AB6r5IaycuHpdE7IAUTMXVNR60ra2ThlNVIiP9TQx5pJkm7K+OUc4l+LuEj5sR
         /XvxZI6wsD8dRGgyhHQm9lBWdiK/GRwVhCN1GnaN9ZmhhQnAPBJza6EZkkgvU4nUe3Fg
         A72Da75X4DrmUx8VGW83bhnbyqZQlRIk4Yp1c/4n721VTetEG1jTWerIv20bgLKKKnFH
         WvX884L6dFGfjNgLnJlbxWG60NOSOC/FRMige/AzZpLvu7zASCPU3qx3A7tJgX3T1Lat
         vPMQ==
X-Gm-Message-State: ANhLgQ0C//AQyfzRVLB4INd6X84SAVoFDn+Kbx8vW0yLJhax7FhQyTwR
        5Wzj46RN2qtGcobQu+IrFD1GNgbs
X-Google-Smtp-Source: ADFU+vvU7jK58JYB9AoI6c18k32PwFYKhUDUaeMMOqJTrCJnCoocZ03M/SdrJpJeWRhws/VGlafQ+Q==
X-Received: by 2002:a17:90a:315:: with SMTP id 21mr1878126pje.96.1585213368349;
        Thu, 26 Mar 2020 02:02:48 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d3sm1194413pfq.126.2020.03.26.02.02.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2020 02:02:47 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 1/3] esp4: add gso_segment for esp4 beet mode
Date:   Thu, 26 Mar 2020 17:02:29 +0800
Message-Id: <0baafba3ed70c5e04d437faf83f2c40f57f52540.1585213292.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1585213292.git.lucien.xin@gmail.com>
References: <cover.1585213292.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1585213292.git.lucien.xin@gmail.com>
References: <cover.1585213292.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to xfrm4_tunnel/transport_gso_segment(), _gso_segment()
is added to do gso_segment for esp4 beet mode. Before calling
inet_offloads[proto]->callbacks.gso_segment, it needs to do:

  - Get the upper proto from ph header to get its gso_segment
    when xo->proto is IPPROTO_BEETPH.

  - Add SKB_GSO_TCPV4 to gso_type if x->sel.family == AF_INET6
    and the proto == IPPROTO_TCP, so that the current tcp ipv4
    packet can be segmented.

  - Calculate a right value for skb->transport_header and move
    skb->data to the transport header position.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/esp4_offload.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index e2e219c..731022c 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -132,6 +132,36 @@ static struct sk_buff *xfrm4_transport_gso_segment(struct xfrm_state *x,
 	return segs;
 }
 
+static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
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
+	} else if (x->sel.family != AF_INET6) {
+		skb->transport_header -= IPV4_BEET_PHMAXLEN;
+	} else if (proto == IPPROTO_TCP) {
+		skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4;
+	}
+
+	__skb_pull(skb, skb_transport_offset(skb));
+	ops = rcu_dereference(inet_offloads[proto]);
+	if (likely(ops && ops->callbacks.gso_segment))
+		segs = ops->callbacks.gso_segment(skb, features);
+
+	return segs;
+}
+
 static struct sk_buff *xfrm4_outer_mode_gso_segment(struct xfrm_state *x,
 						    struct sk_buff *skb,
 						    netdev_features_t features)
@@ -141,6 +171,8 @@ static struct sk_buff *xfrm4_outer_mode_gso_segment(struct xfrm_state *x,
 		return xfrm4_tunnel_gso_segment(x, skb, features);
 	case XFRM_MODE_TRANSPORT:
 		return xfrm4_transport_gso_segment(x, skb, features);
+	case XFRM_MODE_BEET:
+		return xfrm4_beet_gso_segment(x, skb, features);
 	}
 
 	return ERR_PTR(-EOPNOTSUPP);
-- 
2.1.0

