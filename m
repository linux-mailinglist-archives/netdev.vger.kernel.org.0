Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5A546570D
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 21:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245665AbhLAU3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 15:29:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34402 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245633AbhLAU3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 15:29:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ypSed0sEyaMeNav/P/YI+niKhONo2775OHpJjKBVnfs=; b=vkXiMltcid9TySPLbcaK7ask35
        952tKGbSSgwp2/t7ZtUAcuqu66pU5YUUGcHllNhZVxUpH5V4Cg7qq7kCtp6cEX06Y4sq+tJJHlHdy
        FOFPuTscFb+qP/md3YOT3vVZUGw4ibqLhOTnDFT+VFgMwOPFysn0jZPLlY17Dk0gEs9k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1msWAS-00FGAA-9N; Wed, 01 Dec 2021 21:25:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [patch RFC net-next v2 1/3] seg6: export get_srh() for ICMP handling
Date:   Wed,  1 Dec 2021 21:25:17 +0100
Message-Id: <20211201202519.3637005-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211201202519.3637005-1-andrew@lunn.ch>
References: <20211201202519.3637005-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An ICMP error message can contain in its message body part of an IPv6
packet which invoked the error. Such a packet might contain a segment
router header. Export get_srh() so the ICMP code can make use of it.

Since his changes the scope of the function from local to global, add
the seg6_ prefix to keep the namespace clean. And move it into seg6.c
so it is always available, not just when IPV6_SEG6_LWTUNNEL is
enabled.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/net/seg6.h    |  1 +
 net/ipv6/seg6.c       | 29 +++++++++++++++++++++++++++++
 net/ipv6/seg6_local.c | 33 ++-------------------------------
 3 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/include/net/seg6.h b/include/net/seg6.h
index 9d19c15e8545..da85ebc5ae99 100644
--- a/include/net/seg6.h
+++ b/include/net/seg6.h
@@ -58,6 +58,7 @@ extern int seg6_local_init(void);
 extern void seg6_local_exit(void);
 
 extern bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len, bool reduced);
+struct ipv6_sr_hdr *seg6_get_srh(struct sk_buff *skb, int flags);
 extern int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh,
 			     int proto);
 extern int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh);
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index a8b5784afb1a..5bc9bf892199 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -75,6 +75,35 @@ bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len, bool reduced)
 	return true;
 }
 
+struct ipv6_sr_hdr *seg6_get_srh(struct sk_buff *skb, int flags)
+{
+	struct ipv6_sr_hdr *srh;
+	int len, srhoff = 0;
+
+	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, &flags) < 0)
+		return NULL;
+
+	if (!pskb_may_pull(skb, srhoff + sizeof(*srh)))
+		return NULL;
+
+	srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
+
+	len = (srh->hdrlen + 1) << 3;
+
+	if (!pskb_may_pull(skb, srhoff + len))
+		return NULL;
+
+	/* note that pskb_may_pull may change pointers in header;
+	 * for this reason it is necessary to reload them when needed.
+	 */
+	srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
+
+	if (!seg6_validate_srh(srh, len, true))
+		return NULL;
+
+	return srh;
+}
+
 static struct genl_family seg6_genl_family;
 
 static const struct nla_policy seg6_genl_policy[SEG6_ATTR_MAX + 1] = {
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 2dc40b3f373e..ef88489c71f5 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -150,40 +150,11 @@ static struct seg6_local_lwt *seg6_local_lwtunnel(struct lwtunnel_state *lwt)
 	return (struct seg6_local_lwt *)lwt->data;
 }
 
-static struct ipv6_sr_hdr *get_srh(struct sk_buff *skb, int flags)
-{
-	struct ipv6_sr_hdr *srh;
-	int len, srhoff = 0;
-
-	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, &flags) < 0)
-		return NULL;
-
-	if (!pskb_may_pull(skb, srhoff + sizeof(*srh)))
-		return NULL;
-
-	srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
-
-	len = (srh->hdrlen + 1) << 3;
-
-	if (!pskb_may_pull(skb, srhoff + len))
-		return NULL;
-
-	/* note that pskb_may_pull may change pointers in header;
-	 * for this reason it is necessary to reload them when needed.
-	 */
-	srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
-
-	if (!seg6_validate_srh(srh, len, true))
-		return NULL;
-
-	return srh;
-}
-
 static struct ipv6_sr_hdr *get_and_validate_srh(struct sk_buff *skb)
 {
 	struct ipv6_sr_hdr *srh;
 
-	srh = get_srh(skb, IP6_FH_F_SKIP_RH);
+	srh = seg6_get_srh(skb, IP6_FH_F_SKIP_RH);
 	if (!srh)
 		return NULL;
 
@@ -200,7 +171,7 @@ static bool decap_and_validate(struct sk_buff *skb, int proto)
 	struct ipv6_sr_hdr *srh;
 	unsigned int off = 0;
 
-	srh = get_srh(skb, 0);
+	srh = seg6_get_srh(skb, 0);
 	if (srh && srh->segments_left > 0)
 		return false;
 
-- 
2.33.1

