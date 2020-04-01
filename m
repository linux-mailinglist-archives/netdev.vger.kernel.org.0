Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3C019A820
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 11:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732163AbgDAJAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 05:00:19 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33120 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732110AbgDAJAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 05:00:18 -0400
Received: by mail-pl1-f196.google.com with SMTP id g18so9375868plq.0
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 02:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=53H96W01sX/tuSMQwSCJYe3+Y9mtiJYnthRS8yEOVzw=;
        b=kG0PMMJepxwS8iVH/F92aRo4ajKoveUyFwUPl3FtSSorcd4Ksxd3WOpOAeHrOBsvZl
         O9RBSg5cqG4guTKyzdYpCTDzAM89keLw4hEIXiTcAuA8EVFbTSwvFyswb4rJdIIbPacO
         +OrKaDZPvgrbW7UvrMrkXeX1YzVRIWQsXYazsmONvoA1uMGgPupiSSxqgK0iCCqZ2wVU
         s8eOSj54i+ldiR35HCkOwN6bLWsI2VJlCucT+jAEVE5Vv5NALmaYEooNxyDmKSMTydkj
         cig16tx4TDSVaOuDWlLP59wLt/gbvbG6ghA24tF92VA64TW2PLErSR3ecut8W9RKxV1s
         6jew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=53H96W01sX/tuSMQwSCJYe3+Y9mtiJYnthRS8yEOVzw=;
        b=o/E9WoZ+MfT6WlYh0rCoPfJulBffp4hW+PqoZkQUabKGB4hOvXrPCsRXcAbIbHP8F/
         hgqffGqvy6a3Ce4Mu7F1vHH73RLTJHNtUZhNMr18ghzWOFe+8OsolbfgITgY521Nsvrm
         mVEK86Micz974O9dX0z1nsqONjkmPzJbljGIjM3Ca51Bk/ADMwcyeSDBqPjIa3Gm++L4
         Rk2NojiD76lL+pbRcH22xD0SNttwPQwhQ0eFYVFZdAOforSC/U5QqKjNv41pEEgbiXOT
         dpQwOxxVIhbzhW66bdmJzHBaM0zr2Wf4pn6MNC0nahUUJXr55nj3LmjAGL0CiJ7HzhC1
         FpMQ==
X-Gm-Message-State: AGi0PubYMmR0BoS6uur5qQz5rnozQRJHNVv62QhjpYq5pqd9TZjD74qV
        ASIJbgkmuow6XXzAZgAHSYjss9r+
X-Google-Smtp-Source: APiQypJ5JB6SmnkD7Pcz2e7sdpoihaOcLzr3x9bKwJGFCcGSZQC0ppJK2uiPuVk68JLxZEuw6dgTwg==
X-Received: by 2002:a17:90a:fe0f:: with SMTP id ck15mr3551852pjb.192.1585731615931;
        Wed, 01 Apr 2020 02:00:15 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y7sm1101000pfq.159.2020.04.01.02.00.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Apr 2020 02:00:15 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 5/5] esp4: support ipv6 nexthdrs process for beet gso segment
Date:   Wed,  1 Apr 2020 16:59:25 +0800
Message-Id: <df79a0889ccf7bcc9e9d2d242dcede2e185bafbd.1585731430.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <585191d693fc74273d314d4dea9a781ccc7712c2.1585731430.git.lucien.xin@gmail.com>
References: <cover.1585731430.git.lucien.xin@gmail.com>
 <c089597acfb559c70b1485ec84d01a78c8341bb3.1585731430.git.lucien.xin@gmail.com>
 <59aafccde155f156544d54db1145d54ecd018d74.1585731430.git.lucien.xin@gmail.com>
 <3f782f13de69081251addd3b7b37d155805feba2.1585731430.git.lucien.xin@gmail.com>
 <585191d693fc74273d314d4dea9a781ccc7712c2.1585731430.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1585731430.git.lucien.xin@gmail.com>
References: <cover.1585731430.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For beet mode, when it's ipv6 inner address with nexthdrs set,
the packet format might be:

    ----------------------------------------------------
    | outer  |     | dest |     |      |  ESP    | ESP |
    | IP hdr | ESP | opts.| TCP | Data | Trailer | ICV |
    ----------------------------------------------------

Before doing gso segment in xfrm4_beet_gso_segment(), the same
thing is needed as it does in xfrm6_beet_gso_segment() in last
patch 'esp6: support ipv6 nexthdrs process for beet gso segment'.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/esp4_offload.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 731022c..9dde4e3 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -139,7 +139,7 @@ static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	const struct net_offload *ops;
-	int proto = xo->proto;
+	u8 proto = xo->proto;
 
 	skb->transport_header += x->props.header_len;
 
@@ -148,10 +148,16 @@ static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
 
 		skb->transport_header += ph->hdrlen * 8;
 		proto = ph->nexthdr;
-	} else if (x->sel.family != AF_INET6) {
+	} else if (x->sel.family == AF_INET6) {
+		int offset = skb_transport_offset(skb);
+		__be16 frag;
+
+		offset = ipv6_skip_exthdr(skb, offset, &proto, &frag);
+		skb->transport_header += offset;
+		if (proto == IPPROTO_TCP)
+			skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4;
+	} else {
 		skb->transport_header -= IPV4_BEET_PHMAXLEN;
-	} else if (proto == IPPROTO_TCP) {
-		skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4;
 	}
 
 	__skb_pull(skb, skb_transport_offset(skb));
-- 
2.1.0

