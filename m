Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 871AB5F9E2
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 16:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfGDOQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 10:16:54 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37950 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfGDOQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 10:16:53 -0400
Received: by mail-ed1-f68.google.com with SMTP id r12so5573920edo.5
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 07:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SKcl/zq9ujcR8+15B2vvj1zaoq3kRkSzdx1owMPWGtk=;
        b=Xx2UfyZrPOFwcSYA/fUgQTAaX/UCHiyneLQpYcaxeby3JgRJqAYhjWQyj5GfCZX/KI
         /FmxtUq7BCKALSSzO2kXDIvybNF45DNbXGMsU05hG+ayy/Ib9toaaLIGWITTpa+MNCY8
         k70qG+SblA1lcUskmwoTl9MhQj6806XxoeyeamFCj9TQzeQvoorJ93a365PHGgwgVyV0
         x0ILRWikwUdE7DhgefcfrAvUiK0BsGMsBHm9U4MPRa3PcU9N3Nn/lYJvem6VETyBiZyj
         T/acbFEr3/aPPSdF0B07l5cH/IB1yxRk9RihqR+A8fi4Omx4wkGLVkEB2xW/tz6rl5f2
         fFVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SKcl/zq9ujcR8+15B2vvj1zaoq3kRkSzdx1owMPWGtk=;
        b=kDzYvDRKh/BEtpRWKixmwWd0hMNlem7+mrO/+IBMp+Ja87Yoqoefb1Oy5qT1hJfWKu
         Q+R2yFD9d2MUHNeGaaVYUQh0XcgK5u/ZUufA/C+8ig2KYioSI6Y7W3oeKS/wV8l8sR30
         hZKZjqX/TeWqC0dm3Ar8kU7jNC+LsY1nLfbGxvUUfDkdsnJUZPe4bHnnXZUFuh3E86ev
         QHxRPrYSKjISsYBuoCIA9SNKv8jx1iHMJQmz/E0klokLLxU5qS4b3QRYB3y5wSPMCEZ8
         ELCrdi2TXpHtvBHqX9hg7W12eTNO+LW0fDPmWetHQJRnxW8wehL/ozOTdF2H2ll/9ZHl
         9wIw==
X-Gm-Message-State: APjAAAXZ5a5qPN2NHWAzsZtroBu1lvK7E5hJHeHwWL1kPX/V0wBTFk7K
        OdSZBDxDoKQCYBFtZW6L5v2ICI6goKc=
X-Google-Smtp-Source: APXvYqz0LKVeaK5nCdIpv4rxrw/mjqEpl0Hl9MXzMFKzB1bqAkRAyfbUivNUvSuEAPgEdiX8YtFlyg==
X-Received: by 2002:aa7:d0c5:: with SMTP id u5mr21773384edo.299.1562249810781;
        Thu, 04 Jul 2019 07:16:50 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id s27sm1702705eda.36.2019.07.04.07.16.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 04 Jul 2019 07:16:50 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        dcaratti@redhat.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v6 1/5] net: core: move push MPLS functionality from OvS to core helper
Date:   Thu,  4 Jul 2019 15:16:38 +0100
Message-Id: <1562249802-24937-2-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562249802-24937-1-git-send-email-john.hurley@netronome.com>
References: <1562249802-24937-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Open vSwitch provides code to push an MPLS header to a packet. In
preparation for supporting this in TC, move the push code to an skb helper
that can be reused.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/linux/skbuff.h    |  1 +
 net/core/skbuff.c         | 64 +++++++++++++++++++++++++++++++++++++++++++++++
 net/openvswitch/actions.c | 31 +++--------------------
 3 files changed, 69 insertions(+), 27 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b5d427b..0112256 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3446,6 +3446,7 @@ int skb_ensure_writable(struct sk_buff *skb, int write_len);
 int __skb_vlan_pop(struct sk_buff *skb, u16 *vlan_tci);
 int skb_vlan_pop(struct sk_buff *skb);
 int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci);
+int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto);
 struct sk_buff *pskb_extract(struct sk_buff *skb, int off, int to_copy,
 			     gfp_t gfp);
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5323441..f1d1e47 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -66,6 +66,7 @@
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
 #include <net/xfrm.h>
+#include <net/mpls.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -5326,6 +5327,69 @@ int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci)
 }
 EXPORT_SYMBOL(skb_vlan_push);
 
+/* Update the ethertype of hdr and the skb csum value if required. */
+static void skb_mod_eth_type(struct sk_buff *skb, struct ethhdr *hdr,
+			     __be16 ethertype)
+{
+	if (skb->ip_summed == CHECKSUM_COMPLETE) {
+		__be16 diff[] = { ~hdr->h_proto, ethertype };
+
+		skb->csum = csum_partial((char *)diff, sizeof(diff), skb->csum);
+	}
+
+	hdr->h_proto = ethertype;
+}
+
+/**
+ * skb_mpls_push() - push a new MPLS header after the mac header
+ *
+ * @skb: buffer
+ * @mpls_lse: MPLS label stack entry to push
+ * @mpls_proto: ethertype of the new MPLS header (expects 0x8847 or 0x8848)
+ *
+ * Expects skb->data at mac header.
+ *
+ * Returns 0 on success, -errno otherwise.
+ */
+int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto)
+{
+	struct mpls_shim_hdr *lse;
+	int err;
+
+	if (unlikely(!eth_p_mpls(mpls_proto)))
+		return -EINVAL;
+
+	/* Networking stack does not allow simultaneous Tunnel and MPLS GSO. */
+	if (skb->encapsulation)
+		return -EINVAL;
+
+	err = skb_cow_head(skb, MPLS_HLEN);
+	if (unlikely(err))
+		return err;
+
+	if (!skb->inner_protocol) {
+		skb_set_inner_network_header(skb, skb->mac_len);
+		skb_set_inner_protocol(skb, skb->protocol);
+	}
+
+	skb_push(skb, MPLS_HLEN);
+	memmove(skb_mac_header(skb) - MPLS_HLEN, skb_mac_header(skb),
+		skb->mac_len);
+	skb_reset_mac_header(skb);
+	skb_set_network_header(skb, skb->mac_len);
+
+	lse = mpls_hdr(skb);
+	lse->label_stack_entry = mpls_lse;
+	skb_postpush_rcsum(skb, lse, MPLS_HLEN);
+
+	if (skb->dev && skb->dev->type == ARPHRD_ETHER)
+		skb_mod_eth_type(skb, eth_hdr(skb), mpls_proto);
+	skb->protocol = mpls_proto;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(skb_mpls_push);
+
 /**
  * alloc_skb_with_frags - allocate skb with page frags
  *
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index bd13146..a9a6c9c 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -175,34 +175,11 @@ static void update_ethertype(struct sk_buff *skb, struct ethhdr *hdr,
 static int push_mpls(struct sk_buff *skb, struct sw_flow_key *key,
 		     const struct ovs_action_push_mpls *mpls)
 {
-	struct mpls_shim_hdr *new_mpls_lse;
-
-	/* Networking stack do not allow simultaneous Tunnel and MPLS GSO. */
-	if (skb->encapsulation)
-		return -ENOTSUPP;
-
-	if (skb_cow_head(skb, MPLS_HLEN) < 0)
-		return -ENOMEM;
-
-	if (!skb->inner_protocol) {
-		skb_set_inner_network_header(skb, skb->mac_len);
-		skb_set_inner_protocol(skb, skb->protocol);
-	}
-
-	skb_push(skb, MPLS_HLEN);
-	memmove(skb_mac_header(skb) - MPLS_HLEN, skb_mac_header(skb),
-		skb->mac_len);
-	skb_reset_mac_header(skb);
-	skb_set_network_header(skb, skb->mac_len);
-
-	new_mpls_lse = mpls_hdr(skb);
-	new_mpls_lse->label_stack_entry = mpls->mpls_lse;
-
-	skb_postpush_rcsum(skb, new_mpls_lse, MPLS_HLEN);
+	int err;
 
-	if (ovs_key_mac_proto(key) == MAC_PROTO_ETHERNET)
-		update_ethertype(skb, eth_hdr(skb), mpls->mpls_ethertype);
-	skb->protocol = mpls->mpls_ethertype;
+	err = skb_mpls_push(skb, mpls->mpls_lse, mpls->mpls_ethertype);
+	if (err)
+		return err;
 
 	invalidate_flow_key(key);
 	return 0;
-- 
2.7.4

