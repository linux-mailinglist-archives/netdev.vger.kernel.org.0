Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 401A461526
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 16:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfGGOCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 10:02:18 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46945 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfGGOCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 10:02:18 -0400
Received: by mail-ed1-f65.google.com with SMTP id d4so12154351edr.13
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 07:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=97ZgDpzhXV80TbGcuwr+b/Ee4Z34OyRTRKyY8995ldU=;
        b=rhTz0ybx02jI018rI2vTul04MDz19ZQpCxwRLkYlBv8uVLcjoUvK1lRwVI8KJ5pmvQ
         ZrrtNUqzQ+VUpgJBT9EFtGt53BQWizcrsU1j2XiOKAEveufMdoKu/JenI6JnUDJ1eEL8
         CWT32oyKs2Mr6bsk48WsaXl8J+HhV33qbLXv1n8oRGF7NFltn17dJv61AYB7y+C2iJAC
         MxtB9bpBquTK7OywKL2Xv1ZMqDVEs2rADlVNKi0Ni5I/KEBrlK+PloiB266frASEgJ6y
         L9a6NTx5HzvyjHBeYs2TY9BG9LqScllyuut+Kne1myYz5W8m8yU/6pXys6kFqXXoEyqG
         RAyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=97ZgDpzhXV80TbGcuwr+b/Ee4Z34OyRTRKyY8995ldU=;
        b=EBAvhynkQBvRISbDGKvXn+Krlbiizyjz61g39tBfUjOIzWqMKlC1djQgciqHLCs6U2
         dtbqq4Lb1qlBQqH2LkNdDfB4kyJAKiQ2M3lxwvj0V0SdWxOYhs8AiuCnGW3Yq//GW89m
         1JNTqq/IVYY0Om6zf4sAetyjmC0N+PQAz0RluBS9ZSx7zNA9At3URQMcHeotvVtmUGTd
         0M2O9j+NRxkBg6DdqImV+4fkTsjrdm3KU77uiE8J4myxcvw+CtmqxfDTn5X+bjDnF9xI
         knnWtZHYbbzY8RkAC39fSRaUwq45/G/Et0e+fS+rXhGk79yH0td6YCv0/PAcu/Ew54V4
         aIaA==
X-Gm-Message-State: APjAAAWqkuC99Y1GTej6GfLCEKbCLIWWp7OJgnVEFxtpxaAR4RwAWuv7
        tRq+GL9y7XR9RFQwdnUAM3pLyjc4whc=
X-Google-Smtp-Source: APXvYqzCYekllYxQPz3sALZwLR9E8cknDyiXEajREq+SSEocZ3oNour1fLB2giZi0Zwu2RfISOYYJg==
X-Received: by 2002:a50:eb8b:: with SMTP id y11mr14904862edr.154.1562508135453;
        Sun, 07 Jul 2019 07:02:15 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id t2sm4673327eda.95.2019.07.07.07.02.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 07 Jul 2019 07:02:14 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        dcaratti@redhat.com, mrv@mojatatu.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v7 1/5] net: core: move push MPLS functionality from OvS to core helper
Date:   Sun,  7 Jul 2019 15:01:54 +0100
Message-Id: <1562508118-28841-2-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562508118-28841-1-git-send-email-john.hurley@netronome.com>
References: <1562508118-28841-1-git-send-email-john.hurley@netronome.com>
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
index 7ece49d..10387d0 100644
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

