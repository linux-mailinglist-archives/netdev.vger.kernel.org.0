Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D491FD4D5
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgFQSsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgFQSsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:48:42 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660CCC06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:48:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s90so3626647ybi.6
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MtgJnooZi1N2NHQfNjrP1tRVI5EJU+jkftfAJ6oddAg=;
        b=cVts4akpBC0l1PMbwnCb4y9mhQWPFAKfDzPmLVUxdGXNYbeVkTSZ+U+1Ej1ljHlplE
         AxqM5fnp846Rdr/x1vAbrQaf+9IUQy9wXcHrVud2d/f8rFxQJIHkD7/IW9J3qnck1Axj
         LR3RN0+R/0PMtZz4f2JxILKqxFQsEE5Rp/0Q6b8X2w3omRxX/wP9CBx3lBZG0j/xvMpr
         OSwy7f9/m+zlAXQAP9DaozIMayUdscvwnXPfD9j7DBlzHs4UgkkLXp5bVtJMkVZ9+P2T
         4LNWg1bb4gGLfYwb1s2qwlkiDd7HJo8MwoxaTbDAdSNsYLDhREE/XnFrHPrDrSGWcsGz
         MGeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MtgJnooZi1N2NHQfNjrP1tRVI5EJU+jkftfAJ6oddAg=;
        b=pFEW3SlGo7ly+VXoO3CwjRZaxT1Cv8/D88uj3b77F2pxUizYKk31mhyDNqgYFIBcaS
         dco2RVHzExxj1bvs83brmhHURFbpKEdHp1GZx3LSrN5t+uC2+ry3yqS8aGpgT8Kq5Ern
         Q4YeD1pTI8I7SRsoFADen8S8CehU1CofGOKRawxl2WMuk+YNudTj7+UA4WqWGJkMmdjb
         Iv/0CPTA/dTamRUw/yFvw+o+Hx/SE3+3KYTpoq6t2mKvXFudOmUyKBKEzD/zltUiBlmd
         Cq91s9z6iweW4q6RcVn4KL2MAY9IhRHV7YJ/t8cCT+JvEHcfcXH+QL5v/Q/FpjE0dbgN
         y7QQ==
X-Gm-Message-State: AOAM532n4nYwJKKAq6YY9FYXiGwWle5ityn9ezcU2+mqEQ9cyuIhmXNR
        7wC/zyI7aSfYs6+kEkZ8zmEUXZd2ETo9WQ==
X-Google-Smtp-Source: ABdhPJxnE7t0YBuYtfBs0lxyf8qQeGCO6hD3ieLmWFmvkOLDDXmzQRVdObN1gVWELipJD0otd9UJ3e1MhDvgiA==
X-Received: by 2002:a25:ba03:: with SMTP id t3mr403950ybg.111.1592419721659;
 Wed, 17 Jun 2020 11:48:41 -0700 (PDT)
Date:   Wed, 17 Jun 2020 11:48:19 -0700
In-Reply-To: <20200617184819.49986-1-edumazet@google.com>
Message-Id: <20200617184819.49986-6-edumazet@google.com>
Mime-Version: 1.0
References: <20200617184819.49986-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH net-next 5/5] net: tso: add UDP segmentation support
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Note that like TCP, we do not support additional encapsulations,
and that checksums must be offloaded to the NIC.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/tso.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/net/core/tso.c b/net/core/tso.c
index 9f35518815bda275106d27bc5cc34b019429d254..4148f6d48953e1e1ebd878c3953f3e41d47832d9 100644
--- a/net/core/tso.c
+++ b/net/core/tso.c
@@ -16,7 +16,6 @@ EXPORT_SYMBOL(tso_count_descs);
 void tso_build_hdr(const struct sk_buff *skb, char *hdr, struct tso_t *tso,
 		   int size, bool is_last)
 {
-	struct tcphdr *tcph;
 	int hdr_len = skb_transport_offset(skb) + tso->tlen;
 	int mac_hdr_len = skb_network_offset(skb);
 
@@ -32,21 +31,29 @@ void tso_build_hdr(const struct sk_buff *skb, char *hdr, struct tso_t *tso,
 
 		iph->payload_len = htons(size + tso->tlen);
 	}
-	tcph = (struct tcphdr *)(hdr + skb_transport_offset(skb));
-	put_unaligned_be32(tso->tcp_seq, &tcph->seq);
+	hdr += skb_transport_offset(skb);
+	if (tso->tlen != sizeof(struct udphdr)) {
+		struct tcphdr *tcph = (struct tcphdr *)hdr;
 
-	if (!is_last) {
-		/* Clear all special flags for not last packet */
-		tcph->psh = 0;
-		tcph->fin = 0;
-		tcph->rst = 0;
+		put_unaligned_be32(tso->tcp_seq, &tcph->seq);
+
+		if (!is_last) {
+			/* Clear all special flags for not last packet */
+			tcph->psh = 0;
+			tcph->fin = 0;
+			tcph->rst = 0;
+		}
+	} else {
+		struct udphdr *uh = (struct udphdr *)hdr;
+
+		uh->len = htons(sizeof(*uh) + size);
 	}
 }
 EXPORT_SYMBOL(tso_build_hdr);
 
 void tso_build_data(const struct sk_buff *skb, struct tso_t *tso, int size)
 {
-	tso->tcp_seq += size;
+	tso->tcp_seq += size; /* not worth avoiding this operation for UDP */
 	tso->size -= size;
 	tso->data += size;
 
@@ -64,12 +71,12 @@ EXPORT_SYMBOL(tso_build_data);
 
 int tso_start(struct sk_buff *skb, struct tso_t *tso)
 {
-	int tlen = tcp_hdrlen(skb);
+	int tlen = skb_is_gso_tcp(skb) ? tcp_hdrlen(skb) : sizeof(struct udphdr);
 	int hdr_len = skb_transport_offset(skb) + tlen;
 
 	tso->tlen = tlen;
 	tso->ip_id = ntohs(ip_hdr(skb)->id);
-	tso->tcp_seq = ntohl(tcp_hdr(skb)->seq);
+	tso->tcp_seq = (tlen != sizeof(struct udphdr)) ? ntohl(tcp_hdr(skb)->seq) : 0;
 	tso->next_frag_idx = 0;
 	tso->ipv6 = vlan_get_protocol(skb) == htons(ETH_P_IPV6);
 
-- 
2.27.0.290.gba653c62da-goog

