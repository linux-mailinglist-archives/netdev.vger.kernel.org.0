Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83CFF5D90B
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfGCAdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:33:23 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36003 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727325AbfGCAdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:33:22 -0400
Received: by mail-ed1-f65.google.com with SMTP id k21so319875edq.3
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 17:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H7z6+IjvClg5ACQqYyTZ2VYHmF3t7Zn6E9lmHRdM6O0=;
        b=C2eAP/QhE/9R2p+bfPYHIJby+OUn8kenbL5vmM5ctsqsMsG9IvI69SKBHwdOUXqpg5
         konjK/6K0UhEuKMdPOeifYPnucfhycXIfMqp65dwh5zLi60g/f9Gm/YFXUj6HU4+IJBS
         SNVvZhZL4KZKRLFJ5QLC2xcMeMxKocLH9LBqSBPnfOC1I1rN8cqrv4uBmfD+Yhuphlzo
         pnvbSsSundPAEmA16b6GDZWjNf6x+uRbjB8o3IcIvMJLOxg0Qt9bOLEqK+6qfGtHLlTQ
         jJa6Z7otSoxNy2r8fXa14hH52llsFCUWH9ktSHySbxxG25YYv14H41Wr1PUfRYDwpjpB
         ii7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H7z6+IjvClg5ACQqYyTZ2VYHmF3t7Zn6E9lmHRdM6O0=;
        b=Gtahmz+VJpYlAKgGNjYZL8mbGueKdsF5squGcUWUQ+IzU75+Jm4QrZNIPefb077TtW
         uUPvUWDgK5Vx+Xq2udl8ovLzeIQzxejPpY2yxD1a2UrhXX22O+doBbwhXyFAoVXCJCDk
         0D6iO8X8WsnzXiaizGaSNeDtPJj9Q11QEwPhkSlfdrR1nVCgt7cla7zMydTX2dovHcTE
         WTDHSPrjMYmvhIG0M1pgMwbDgbR/2pG6DcfkDWwSLRv0E00nL/fka5vkoGKJCS3xeooK
         n4MxZ3uwGKq7cAfvtkFqZdLq+UrqWsxJwZ0iYki9a8igG8+7+UdJ0etPxozfs50SiW2s
         I5nw==
X-Gm-Message-State: APjAAAV+SZjsvitPbLttNFADKtzymBt8yJQYszWh1ugvLfUqI3FhIkgC
        Hq3pNNmkX19J1jiSzxFbaadHrx4jx+Y=
X-Google-Smtp-Source: APXvYqybnysQmjRpI+wVn6+CabcaGFvAPc6kNx8jSvnmu52XhhWg3A8Leath6A3MwlseBYtg4vxq6Q==
X-Received: by 2002:a17:906:fac5:: with SMTP id lu5mr412714ejb.295.1562113555239;
        Tue, 02 Jul 2019 17:25:55 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id h10sm168768eda.85.2019.07.02.17.25.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 02 Jul 2019 17:25:54 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v5 1/5] net: core: move push MPLS functionality from OvS to core helper
Date:   Wed,  3 Jul 2019 01:25:27 +0100
Message-Id: <1562113531-29296-2-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562113531-29296-1-git-send-email-john.hurley@netronome.com>
References: <1562113531-29296-1-git-send-email-john.hurley@netronome.com>
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

