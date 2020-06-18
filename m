Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2291FE9AC
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 05:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgFRDxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 23:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727914AbgFRDxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 23:53:46 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E60FC061755
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:53:46 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b135so5072655yba.11
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MtgJnooZi1N2NHQfNjrP1tRVI5EJU+jkftfAJ6oddAg=;
        b=gKV3+Lb1baWgfnwT8NlbLRpc/OjJdrckbRYIdoeZJuJz8sXWkKCpqbRPeAzMCxO48L
         hhSPlgrjW6Fx2S3e5J5kQ6UATxne4OYi120cRCaI6hAinkThetGl8ji6+W0MARbE9fDO
         /rh+3fBZ2B6leTBaakDaMFR9k2NK6DTvG9PRBswV8VKFbZnSSqaCmzIEIpOoNh9dtg3T
         qtDrdnidZRR+zUvkrcp+XkdBUqHOCeTgJ36QzL27TsK4GeUe02pwLnDYqMwKOThNPgGZ
         iwLhazvnwpBcn4MBpmvwnrYAaOr6j/7u6ezrdovF28PunRut1DO/A2drONEyImq8GAa1
         XDpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MtgJnooZi1N2NHQfNjrP1tRVI5EJU+jkftfAJ6oddAg=;
        b=AVKPJRnL9nmyAFg9twVnwj+eMe7jMgE/3dtbtdHxQMfS78pZi5xLlgvseAlwjT/VSu
         W+HuSArwIUHAbh1IQqQOTh1FjHXLQML4zXiHqzl1+pmp7rkusvZBdrcAJKrMvka1Uutn
         93SLtmQ0iohIg1RksN4Ac/L6a9JzTFDaK6S+wFsCok4R5c7oDWtnsBHkoIp2LjMnZYIA
         0cOZDQDTnjVokT/bTHJyNa9gjN5U8lcG4Y9WLRCDIzib8ra65Ud5cWp9b8yUiwA2Y3V6
         ggsRL2wV8Dqi65XpvR+VH1T07FS/2J2EUvF4TVkKKvmZZ009DDuESHqfkNrFiW45Pyoo
         Ibew==
X-Gm-Message-State: AOAM533vSTfYCGCONV7h4PdGLOraFkNEGboid6itJcOwFifTZTjlzqiJ
        MUfG/J62mjNNAwaCcNKB1ADA8OEqoymQPQ==
X-Google-Smtp-Source: ABdhPJyHZgB7wyXk1IiFWSpclRCha5f9WlrOBUSsz7zIWkWeJzuL0t+loC+dSbOOPISBOrHbUomdrVcaN5Gp1A==
X-Received: by 2002:a05:6902:725:: with SMTP id l5mr3916940ybt.150.1592452425288;
 Wed, 17 Jun 2020 20:53:45 -0700 (PDT)
Date:   Wed, 17 Jun 2020 20:53:26 -0700
In-Reply-To: <20200618035326.39686-1-edumazet@google.com>
Message-Id: <20200618035326.39686-7-edumazet@google.com>
Mime-Version: 1.0
References: <20200618035326.39686-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH v2 net-next 6/6] net: tso: add UDP segmentation support
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Sunil Goutham <sgoutham@marvell.com>,
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

