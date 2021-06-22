Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297253B0DE7
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhFVT70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbhFVT7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 15:59:25 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9571BC061574;
        Tue, 22 Jun 2021 12:57:08 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m2so17965314pgk.7;
        Tue, 22 Jun 2021 12:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7EK4KCzWQjnwZZfmTqzpOsXvyTUA9SISmaf19z0hRsA=;
        b=UOz6Wrsz4pUBdKXM3vBYeg/faqwU8ekW41vkrks+bhqlJFYNa7HutVkxXX8sFl1q6b
         bVF1rsDzlZO0ZJ8xqISXAdiMicBJq00pykpJOTSjG9StqhI56eazOyROdGUuc1avUUqf
         1HfmWZfDGS/svvOqPEVB+nPNPalgxSU2TwkacGXZItIeCgoAuY2FKq3uRgttMPKj2Bsg
         Ro2L2vF39Ol9fsQwOF9fg1VUtJYIEqn0tkqw/jq4+1MhnyIHhy9gicLkvicgujfm9C8D
         WMDbSsI3OXIrxO6VyzcjdfqITorp5uJPGRtKguclLEzpPsG2X8iVO4FGkO/L0UETlCTx
         Y3/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7EK4KCzWQjnwZZfmTqzpOsXvyTUA9SISmaf19z0hRsA=;
        b=rhd09X80xxkLDfkxNr8LOdJL1Ba3t+AVS6KbIl9rE5d1wY0LwGZXQ+LcVboxC33V2H
         RPwf84JYYH2QUkvqSP0+3iTOjAaCAUvMIfUakkEmL72stal/XcthEISrMDZQLsM8L3xC
         GjlFDAfVl/n/SjUMheVDkDJCyO3zfl7O96AHdC0LJq3q8JkYYzm/wUa4CuD6N4457WVU
         b5xtUemCFhRi9MjvUi2STEAZeXkJSqu2DXvmOGsoWkIFsjIPQ8kUiK1Uz6VSz9J5slhi
         QYkxAGY0fdVEdNT9WGWDWo8NUcsAOc440jtO2mJa1saA8/xL1oxgytrEF+md+uxhVreW
         uv1w==
X-Gm-Message-State: AOAM530umw1ErZAV1Em8qysAuqUgZ57P5nrY/8CAoGqV7AhSAzkSxF6+
        OGmxDace6KT5lK5vvKvjPPD8ngbynck=
X-Google-Smtp-Source: ABdhPJy9kbfjaKFpBwCsOzNP7vSMUM7W9Eh0jhG7o8s80ZmM4dIAcaOXLrd3UdZzfIxs0ijjq+QjrA==
X-Received: by 2002:a62:dd8b:0:b029:2e9:731a:e22e with SMTP id w133-20020a62dd8b0000b02902e9731ae22emr5238665pff.69.1624391827975;
        Tue, 22 Jun 2021 12:57:07 -0700 (PDT)
Received: from localhost ([2402:3a80:11bb:33b3:7f0c:3646:8bde:417e])
        by smtp.gmail.com with ESMTPSA id a197sm137891pfa.220.2021.06.22.12.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 12:57:07 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v2 1/5] net: core: split out code to run generic XDP prog
Date:   Wed, 23 Jun 2021 01:25:23 +0530
Message-Id: <20210622195527.1110497-2-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622195527.1110497-1-memxor@gmail.com>
References: <20210622195527.1110497-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helper can later be utilized in code that runs cpumap and devmap
programs in generic redirect mode and adjust skb based on changes made
to xdp_buff.

When returning XDP_REDIRECT/XDP_TX, it invokes __skb_push, so whenever a
generic redirect path invokes devmap/cpumap prog if set, it must
__skb_pull again as we expect mac header to be pulled.

It also drops the skb_reset_mac_len call after do_xdp_generic, as the
mac_header and network_header are advanced by the same offset, so the
difference (mac_len) remains constant.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
NB: I am not too sure why the skb_reset_mac_len was there, so I removed it since
the offset addition/subtraction should be same for network_header and
mac_header, but I could be missing something important...
---
 include/linux/netdevice.h |  2 +
 net/core/dev.c            | 84 ++++++++++++++++++++++++---------------
 2 files changed, 55 insertions(+), 31 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index be1dcceda5e4..90472ea70db2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3984,6 +3984,8 @@ static inline void dev_consume_skb_any(struct sk_buff *skb)
 	__dev_kfree_skb_any(skb, SKB_REASON_CONSUMED);
 }

+u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, struct xdp_buff *xdp,
+			     struct bpf_prog *xdp_prog);
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
 int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb);
 int netif_rx(struct sk_buff *skb);
diff --git a/net/core/dev.c b/net/core/dev.c
index 50531a2d0b20..c34ff1dbf6e6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4717,45 +4717,18 @@ static struct netdev_rx_queue *netif_get_rxqueue(struct sk_buff *skb)
 	return rxqueue;
 }

-static u32 netif_receive_generic_xdp(struct sk_buff *skb,
-				     struct xdp_buff *xdp,
-				     struct bpf_prog *xdp_prog)
+u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, struct xdp_buff *xdp,
+			     struct bpf_prog *xdp_prog)
 {
 	void *orig_data, *orig_data_end, *hard_start;
 	struct netdev_rx_queue *rxqueue;
-	u32 metalen, act = XDP_DROP;
 	bool orig_bcast, orig_host;
 	u32 mac_len, frame_sz;
 	__be16 orig_eth_type;
 	struct ethhdr *eth;
+	u32 metalen, act;
 	int off;

-	/* Reinjected packets coming from act_mirred or similar should
-	 * not get XDP generic processing.
-	 */
-	if (skb_is_redirected(skb))
-		return XDP_PASS;
-
-	/* XDP packets must be linear and must have sufficient headroom
-	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
-	 * native XDP provides, thus we need to do it here as well.
-	 */
-	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
-	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
-		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
-		int troom = skb->tail + skb->data_len - skb->end;
-
-		/* In case we have to go down the path and also linearize,
-		 * then lets do the pskb_expand_head() work just once here.
-		 */
-		if (pskb_expand_head(skb,
-				     hroom > 0 ? ALIGN(hroom, NET_SKB_PAD) : 0,
-				     troom > 0 ? troom + 128 : 0, GFP_ATOMIC))
-			goto do_drop;
-		if (skb_linearize(skb))
-			goto do_drop;
-	}
-
 	/* The XDP program wants to see the packet starting at the MAC
 	 * header.
 	 */
@@ -4810,6 +4783,13 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 		skb->protocol = eth_type_trans(skb, skb->dev);
 	}

+	/* Redirect/Tx gives L2 packet, code that will reuse skb must __skb_pull
+	 * before calling us again on redirect path. We do not call do_redirect
+	 * as we leave that up to the caller.
+	 *
+	 * Caller is responsible for managing lifetime of skb (i.e. calling
+	 * kfree_skb in response to actions it cannot handle/XDP_DROP).
+	 */
 	switch (act) {
 	case XDP_REDIRECT:
 	case XDP_TX:
@@ -4820,6 +4800,49 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 		if (metalen)
 			skb_metadata_set(skb, metalen);
 		break;
+	}
+
+	return act;
+}
+
+static u32 netif_receive_generic_xdp(struct sk_buff *skb,
+				     struct xdp_buff *xdp,
+				     struct bpf_prog *xdp_prog)
+{
+	u32 act = XDP_DROP;
+
+	/* Reinjected packets coming from act_mirred or similar should
+	 * not get XDP generic processing.
+	 */
+	if (skb_is_redirected(skb))
+		return XDP_PASS;
+
+	/* XDP packets must be linear and must have sufficient headroom
+	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
+	 * native XDP provides, thus we need to do it here as well.
+	 */
+	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
+	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
+		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
+		int troom = skb->tail + skb->data_len - skb->end;
+
+		/* In case we have to go down the path and also linearize,
+		 * then lets do the pskb_expand_head() work just once here.
+		 */
+		if (pskb_expand_head(skb,
+				     hroom > 0 ? ALIGN(hroom, NET_SKB_PAD) : 0,
+				     troom > 0 ? troom + 128 : 0, GFP_ATOMIC))
+			goto do_drop;
+		if (skb_linearize(skb))
+			goto do_drop;
+	}
+
+	act = bpf_prog_run_generic_xdp(skb, xdp, xdp_prog);
+	switch (act) {
+	case XDP_REDIRECT:
+	case XDP_TX:
+	case XDP_PASS:
+		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
@@ -5285,7 +5308,6 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 			ret = NET_RX_DROP;
 			goto out;
 		}
-		skb_reset_mac_len(skb);
 	}

 	if (eth_type_vlan(skb->protocol)) {
--
2.31.1

