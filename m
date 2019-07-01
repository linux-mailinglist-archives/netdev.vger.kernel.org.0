Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 689005BB88
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 14:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbfGAMbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 08:31:14 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43044 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbfGAMbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 08:31:14 -0400
Received: by mail-ed1-f66.google.com with SMTP id e3so23199969edr.10
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 05:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jZFFaBntFOF6JRAZzNgyKqVJG53qU5arVep/YxRIE2c=;
        b=K4F9RfhsyAPtc9Q8Br9Zus6zRsICwymqr6TIgeI4cdbycOVqusT5Z1CjFPoqCuP8Ni
         S2j0LgpyhgucmBH61R67Folm4XV+77S/ZazlK3o1PbCe952x2+hl7sTFAJlqRCStGVnC
         vcWKEGZ9fuDRLqyFy2jb+4g2JET/AFp4FASHyrkOZ24U2yrzjO2pQIsnRimnmtElxY6n
         OSersWYToMpA7t+SJyKP1rjy2vw39xTg6/URtl6C9dHQiFq5E06HjH1OpFrL/mi+jrT2
         7RADvNILOepDi2ePSmmjESE2cVB2d+o/XDe2NGSTlJqdqwZPzQ+bvPRCr5NM3lSbwph0
         CPBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jZFFaBntFOF6JRAZzNgyKqVJG53qU5arVep/YxRIE2c=;
        b=PVknpfyrdlFsUPMUTUCiOOeksU9RyD5Rx9M4HEiYfXYQWf2c9fqGRrZqRRgzv2ObYB
         GilIo9VtlW4e6WReZ+miDlOhSYwywo6iCsep42QJ8tIs71D40GGIusFn5eOAPpQvLpk8
         Js6zfRDxx0olHmgrxec0npHHvpqU805wtr+S4f/SjswlfcQ6fKBDdq0zIzj81wKQ86ls
         BIBPexHlCgyHll/wg8XtO9uy+8nmg6xvxEgTSoO3OcQxVJz/Dze+cocAMEW0AcJw7+Q5
         gt0Nqb8Ky9m3o76r8V9qrW3kylZ63Ar7GFJGhXVQiCrNQWIzGeIGRwlBCU7LL/kLCoW1
         Nh2g==
X-Gm-Message-State: APjAAAV3c7Jx0EJ9NTM2R378dFvbApm8nOU/97FSi24hPc/6Zzuk98hT
        eONqw/je4ZqXNOY0HdjLbMTEWP4rn2A=
X-Google-Smtp-Source: APXvYqxw3cPvfub0kBgbeFnQ+BO5wimfCL5OUnIBbCX2wojQAtSIcjkPAN74TUL7jnGcUCEFrtIjaw==
X-Received: by 2002:a17:906:25c5:: with SMTP id n5mr22599223ejb.195.1561984271671;
        Mon, 01 Jul 2019 05:31:11 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id a3sm2099204ejn.64.2019.07.01.05.31.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 01 Jul 2019 05:31:11 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v4 2/5] net: core: move pop MPLS functionality from OvS to core helper
Date:   Mon,  1 Jul 2019 13:30:54 +0100
Message-Id: <1561984257-9798-3-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561984257-9798-1-git-send-email-john.hurley@netronome.com>
References: <1561984257-9798-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Open vSwitch provides code to pop an MPLS header to a packet. In
preparation for supporting this in TC, move the pop code to an skb helper
that can be reused.

Remove the, now unused, update_ethertype static function from OvS.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 include/linux/skbuff.h    |  1 +
 net/core/skbuff.c         | 42 ++++++++++++++++++++++++++++++++++++++++++
 net/openvswitch/actions.c | 37 ++-----------------------------------
 3 files changed, 45 insertions(+), 35 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0112256..89d5c43 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3447,6 +3447,7 @@ int __skb_vlan_pop(struct sk_buff *skb, u16 *vlan_tci);
 int skb_vlan_pop(struct sk_buff *skb);
 int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci);
 int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto);
+int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto);
 struct sk_buff *pskb_extract(struct sk_buff *skb, int off, int to_copy,
 			     gfp_t gfp);
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f1d1e47..ce30989 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5391,6 +5391,48 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto)
 EXPORT_SYMBOL_GPL(skb_mpls_push);
 
 /**
+ * skb_mpls_pop() - pop the outermost MPLS header
+ *
+ * @skb: buffer
+ * @next_proto: ethertype of header after popped MPLS header
+ *
+ * Expects skb->data at mac header.
+ *
+ * Returns 0 on success, -errno otherwise.
+ */
+int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto)
+{
+	int err;
+
+	if (unlikely(!eth_p_mpls(skb->protocol)))
+		return -EINVAL;
+
+	err = skb_ensure_writable(skb, skb->mac_len + MPLS_HLEN);
+	if (unlikely(err))
+		return err;
+
+	skb_postpull_rcsum(skb, mpls_hdr(skb), MPLS_HLEN);
+	memmove(skb_mac_header(skb) + MPLS_HLEN, skb_mac_header(skb),
+		skb->mac_len);
+
+	__skb_pull(skb, MPLS_HLEN);
+	skb_reset_mac_header(skb);
+	skb_set_network_header(skb, skb->mac_len);
+
+	if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
+		struct ethhdr *hdr;
+
+		/* use mpls_hdr() to get ethertype to account for VLANs. */
+		hdr = (struct ethhdr *)((void *)mpls_hdr(skb) - ETH_HLEN);
+		skb_mod_eth_type(skb, hdr, next_proto);
+	}
+	skb->protocol = next_proto;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(skb_mpls_pop);
+
+/**
  * alloc_skb_with_frags - allocate skb with page frags
  *
  * @header_len: size of linear part
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index a9a6c9c..62715bb 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -160,18 +160,6 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 			      struct sw_flow_key *key,
 			      const struct nlattr *attr, int len);
 
-static void update_ethertype(struct sk_buff *skb, struct ethhdr *hdr,
-			     __be16 ethertype)
-{
-	if (skb->ip_summed == CHECKSUM_COMPLETE) {
-		__be16 diff[] = { ~(hdr->h_proto), ethertype };
-
-		skb->csum = csum_partial((char *)diff, sizeof(diff), skb->csum);
-	}
-
-	hdr->h_proto = ethertype;
-}
-
 static int push_mpls(struct sk_buff *skb, struct sw_flow_key *key,
 		     const struct ovs_action_push_mpls *mpls)
 {
@@ -190,31 +178,10 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
 {
 	int err;
 
-	err = skb_ensure_writable(skb, skb->mac_len + MPLS_HLEN);
-	if (unlikely(err))
+	err = skb_mpls_pop(skb, ethertype);
+	if (err)
 		return err;
 
-	skb_postpull_rcsum(skb, mpls_hdr(skb), MPLS_HLEN);
-
-	memmove(skb_mac_header(skb) + MPLS_HLEN, skb_mac_header(skb),
-		skb->mac_len);
-
-	__skb_pull(skb, MPLS_HLEN);
-	skb_reset_mac_header(skb);
-	skb_set_network_header(skb, skb->mac_len);
-
-	if (ovs_key_mac_proto(key) == MAC_PROTO_ETHERNET) {
-		struct ethhdr *hdr;
-
-		/* mpls_hdr() is used to locate the ethertype field correctly in the
-		 * presence of VLAN tags.
-		 */
-		hdr = (struct ethhdr *)((void *)mpls_hdr(skb) - ETH_HLEN);
-		update_ethertype(skb, hdr, ethertype);
-	}
-	if (eth_p_mpls(skb->protocol))
-		skb->protocol = ethertype;
-
 	invalidate_flow_key(key);
 	return 0;
 }
-- 
2.7.4

