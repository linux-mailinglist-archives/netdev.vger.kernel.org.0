Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A070C1A4438
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 11:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgDJJHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 05:07:41 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33954 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgDJJHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 05:07:41 -0400
Received: by mail-pj1-f67.google.com with SMTP id q16so1634011pje.1
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 02:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rQ9OJO3VWYMdUO2+N2SLwQFPhIJRyGfLggvJS3pe86M=;
        b=kRP1SyafTRiNQbhR0ETIZB5dvSNYPyUyL4RYuXWV7bjr29weDHVRG6OnjgxvqqX9AB
         GZ/uyZcRaxMo3Ch6Po1rgmZHF9vqWhBRprfSTtxC11pPm2VImReBPU3htgvG4Cmd+UKQ
         j76YVFrlxD1664rYyT1606/qHushXbJg81r21pb2ohJcOVZQvsuB0gc1Gw0T0bx5JOfz
         XKJEnGtMX4mZpnUUTQGd0M0+UyPZVzI67fHCpTtv10ukNLtUL9pxPtStgdBzOxojiuNd
         tJlx7EH5niehI/FOx/0eU2Ih24fjLAiPzQMVWLdp1TRvcLfD1DvbGBMvYGGra3cBms2N
         7GDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rQ9OJO3VWYMdUO2+N2SLwQFPhIJRyGfLggvJS3pe86M=;
        b=e66zWGA3Gyaf65LIK6YklwDKbbqdY4df1Mh3JDkg/GxQltbt633nUvpJ3S6gh9mXXO
         OqG9uE+eJd5jyeEeuYQbAJUvcxgiX3pPzmL6YMeLZs/noHKXfe04BOKyu2/QhNoB3l7M
         VJ0mL114AL2hIQXYqpTA3K5q1puxQIq/RYU5EKBVMWzojzfXhpYC0xqU32wM/mT8orzP
         rwX7xsRRthdIO2/iEwYJrkeuqi8760mUCUWoDzUhY1vCaIs2wH/qwRPMAOXI61B/QzUx
         x/Lbi7MDYeraklZR8PVUvRJdYdl7UrrULyALZVplEac8fZ+B7ukd4haV+ORK4UG7jDRt
         bqnQ==
X-Gm-Message-State: AGi0PuZyYqsarzLvJraw7HFnk/bs9fzymXlCWhszoiS4hMBKIpDFM+qn
        ARSK8bTdi67jRhqXe99M70jsHfCo
X-Google-Smtp-Source: APiQypIJQde/Rr4inA02XZi8H3qhSiHKjUFXUcW4pPaQd5r3C86I1H8O0YZ/4PtbZy9w4UDxMO81cw==
X-Received: by 2002:a17:902:968a:: with SMTP id n10mr3667383plp.74.1586509659781;
        Fri, 10 Apr 2020 02:07:39 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q8sm1266412pfg.19.2020.04.10.02.07.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Apr 2020 02:07:39 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec] esp6: support ipv6 nexthdrs process for beet gso segment
Date:   Fri, 10 Apr 2020 17:07:31 +0800
Message-Id: <7607f06c9a9f39d8a4581dd76e6e6e5314ad2968.1586509651.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For beet mode, when it's ipv6 inner address with nexthdrs set,
the packet format might be:

    ----------------------------------------------------
    | outer  |     | dest |     |      |  ESP    | ESP |
    | IP6 hdr| ESP | opts.| TCP | Data | Trailer | ICV |
    ----------------------------------------------------

Before doing gso segment in xfrm6_beet_gso_segment(), it should
skip all nexthdrs and get the real transport proto, and set
transport_header properly.

This patch is to fix it by simply calling ipv6_skip_exthdr()
in xfrm6_beet_gso_segment().

Fixes: 7f9e40eb18a9 ("esp6: add gso_segment for esp6 beet mode")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/esp6_offload.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index b828508..021f58c 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -173,7 +173,7 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	const struct net_offload *ops;
-	int proto = xo->proto;
+	u8 proto = xo->proto;
 
 	skb->transport_header += x->props.header_len;
 
@@ -184,7 +184,13 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
 		proto = ph->nexthdr;
 	}
 
-	if (x->sel.family != AF_INET6) {
+	if (x->sel.family == AF_INET6) {
+		int offset = skb_transport_offset(skb);
+		__be16 frag;
+
+		offset = ipv6_skip_exthdr(skb, offset, &proto, &frag);
+		skb->transport_header += offset;
+	} else {
 		skb->transport_header -=
 			(sizeof(struct ipv6hdr) - sizeof(struct iphdr));
 
-- 
2.1.0

