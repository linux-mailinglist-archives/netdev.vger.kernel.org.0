Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2FE20614
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 13:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfEPLqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 07:46:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727787AbfEPLkh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 07:40:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F39221473;
        Thu, 16 May 2019 11:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006835;
        bh=Vv7OIPjGXH8iV14gTzRlXuyydsjwHX8Wip9Nj1L79eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKAk2/8niFS1d5ludKI/i1nXHRV8418DXpWNDdPgpCcg5hbc73n7kQldduuDDoxEH
         uzOLxGjwmR+Anb1KdtLoqSY6vwrvTXPXbM/2coYcOj8k6eEJsdCnqv6CQVCxMuNs0+
         RSBHhphULgUWyQw9bs4CvslOjJGOLoZ3FwsAfCMA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/25] esp4: add length check for UDP encapsulation
Date:   Thu, 16 May 2019 07:40:08 -0400
Message-Id: <20190516114029.8682-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516114029.8682-1-sashal@kernel.org>
References: <20190516114029.8682-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 8dfb4eba4100e7cdd161a8baef2d8d61b7a7e62e ]

esp_output_udp_encap can produce a length that doesn't fit in the 16
bits of a UDP header's length field. In that case, we'll send a
fragmented packet whose length is larger than IP_MAX_MTU (resulting in
"Oversized IP packet" warnings on receive) and with a bogus UDP
length.

To prevent this, add a length check to esp_output_udp_encap and return
 -EMSGSIZE on failure.

This seems to be older than git history.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 12a43a5369a54..114f9def1ec54 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -223,7 +223,7 @@ static void esp_output_fill_trailer(u8 *tail, int tfclen, int plen, __u8 proto)
 	tail[plen - 1] = proto;
 }
 
-static void esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
+static int esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
 {
 	int encap_type;
 	struct udphdr *uh;
@@ -231,6 +231,7 @@ static void esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, stru
 	__be16 sport, dport;
 	struct xfrm_encap_tmpl *encap = x->encap;
 	struct ip_esp_hdr *esph = esp->esph;
+	unsigned int len;
 
 	spin_lock_bh(&x->lock);
 	sport = encap->encap_sport;
@@ -238,11 +239,14 @@ static void esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, stru
 	encap_type = encap->encap_type;
 	spin_unlock_bh(&x->lock);
 
+	len = skb->len + esp->tailen - skb_transport_offset(skb);
+	if (len + sizeof(struct iphdr) >= IP_MAX_MTU)
+		return -EMSGSIZE;
+
 	uh = (struct udphdr *)esph;
 	uh->source = sport;
 	uh->dest = dport;
-	uh->len = htons(skb->len + esp->tailen
-		  - skb_transport_offset(skb));
+	uh->len = htons(len);
 	uh->check = 0;
 
 	switch (encap_type) {
@@ -259,6 +263,8 @@ static void esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, stru
 
 	*skb_mac_header(skb) = IPPROTO_UDP;
 	esp->esph = esph;
+
+	return 0;
 }
 
 int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
@@ -272,8 +278,12 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 	int tailen = esp->tailen;
 
 	/* this is non-NULL only with UDP Encapsulation */
-	if (x->encap)
-		esp_output_udp_encap(x, skb, esp);
+	if (x->encap) {
+		int err = esp_output_udp_encap(x, skb, esp);
+
+		if (err < 0)
+			return err;
+	}
 
 	if (!skb_cloned(skb)) {
 		if (tailen <= skb_tailroom(skb)) {
-- 
2.20.1

