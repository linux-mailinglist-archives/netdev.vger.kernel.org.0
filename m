Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D14D95BB87
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 14:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbfGAMbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 08:31:13 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42575 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728728AbfGAMbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 08:31:12 -0400
Received: by mail-ed1-f65.google.com with SMTP id z25so23235683edq.9
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 05:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H7z6+IjvClg5ACQqYyTZ2VYHmF3t7Zn6E9lmHRdM6O0=;
        b=uJH4J0a75AsKuJdOATfi9ktWUJtnYzV0CNaY0LCNXbv536NOGh2WXhrFnYLSjY7ut9
         PBAuuFSKLgCHGdz9BBbbg++VWdDpdVCfR0paw3XJ4EMtN18IeFung2McUllaNX8yZp3X
         ItfcJEy4ZNtvoZV+dFjYgZQzIrYz+vcqZ07lR5wIBAK+snanLmK+qFZpVMU9KVnT/F2G
         lDdyERBAVMMMuEqkr4zSUoUJy22xCuw1qg6WdMvcYRbWBwl7vOtLWLEqkbSQhfgS/ine
         RxONQBWb0PP13Cf0dT/q+KX/7V1w1jjQ5E4mJT6ADOm8hj+wnE9P/qRRDiDA3x2hyuvD
         SLfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H7z6+IjvClg5ACQqYyTZ2VYHmF3t7Zn6E9lmHRdM6O0=;
        b=gajqwMePTEPmzKmalLfjIrKDJisg2LO4z0ErGeQ4Z1jx+0dqpla7FlGcNe07azmXF0
         i7xUjjudWmcjEcR209ghK6MfM5Mc65A3gJf4sy++SPYPbFHDm6pORmrwyvdu3xswieoM
         h0p1Q4AvNB/ZbVFmY/48kkNZOMrTyxv9Nv9UMBCKUF2W62LGqYyvRdGvXBn78Jw1LwtX
         eSjFhHtDB7QbhmYvpLZ6x4+lWwek7TibD6XhGuIDm8dSQqUQjhtVZHPAL5QrQ2PSt3h3
         Xu5wYjESz0YI85317sFNXc2o8c6Zb5p7RGsuxP45sgC4ft4D4nGRK041cPmNMZikwfPL
         cKTQ==
X-Gm-Message-State: APjAAAVilR7bO2H24QOv1mMxh4DoZNf+iMg65UE8Z8wzEJpcvT8pYOz+
        KpmOZL+xia0S0RAOpRLBpt+NLzeLyfg=
X-Google-Smtp-Source: APXvYqxCiZPObCqlIAFvM3PeVm/Cw4ar3pZvaL/c8KLf0Guxrk8ybdk/jCHmVmRz+BDjPZbfo+r1gg==
X-Received: by 2002:a50:ae8f:: with SMTP id e15mr28530322edd.74.1561984270369;
        Mon, 01 Jul 2019 05:31:10 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id a3sm2099204ejn.64.2019.07.01.05.31.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 01 Jul 2019 05:31:09 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v4 1/5] net: core: move push MPLS functionality from OvS to core helper
Date:   Mon,  1 Jul 2019 13:30:53 +0100
Message-Id: <1561984257-9798-2-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561984257-9798-1-git-send-email-john.hurley@netronome.com>
References: <1561984257-9798-1-git-send-email-john.hurley@netronome.com>
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

