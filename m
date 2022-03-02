Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2A74CB27F
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 23:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiCBWq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 17:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiCBWq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 17:46:57 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B6B128DCE
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 14:46:02 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so3208999pjb.0
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 14:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:subject:date:message-id;
        bh=NIbIcWPLu1WQs0h/YDh1gBro4dlIy8KQS9MhRK1W+tw=;
        b=tnOQ2CNVO/QxA2c/FWZaKm9lMhs73bhTHdJACWDJubL+WUZwZe1hqKC7hXHI32hhD3
         wiW05vkb6eVXT3pj3aaRsdf5q9I1VD9cZ/imwEWgDUWS6iPwWc1Y8SZCg5Hp1KdUTUkY
         GH4ewyW5pxm2H++3/YNsTaBV4YRXQ1O9rSeU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=NIbIcWPLu1WQs0h/YDh1gBro4dlIy8KQS9MhRK1W+tw=;
        b=S3DDaDpnUgmFmmV9sH3PxvLTR7FLKbrh+thILIuuyadaSNyk1ZPR3Uyn00njYEMlQF
         iLuMCQWPEepoOxQauB17iGvPY3QqYZuoYIGsHoePUYNVOqnlUci+TXaxmzQpZSxfQ5fQ
         POsGweOO0AC3jaDVGv9gC8kX9nc8vMJyr5ADiPiGeNw5bcZqRCvmKroLwHTEvZLGoPPc
         SEqxBjusA7E3z3KEeGGNsTNKg3YDxhK6b4mNDIcZigAKm1GBc/mJpBmDENDd4TWLMrBg
         XkF33e5GO5y36pFabIDEoJB/lWtJIJH6YZSOOb8wASPOrq1PjzG7CkwmTi9qrBAKux2j
         4YrA==
X-Gm-Message-State: AOAM533pNgLA/ugKjia/n3ZMf8ycud5+sbLY9hQLXqHEkKuMVveqoXa6
        HvuKQvrY7BERcsfaXaYJjO7BEg==
X-Google-Smtp-Source: ABdhPJxLVLXp2+CZ1j7jvKjwWxqgFGPLQB49cN077amWcihdc0fpbQyxa2dJzNlEVrOun3NTG/zl4Q==
X-Received: by 2002:a17:90b:3b50:b0:1bf:b9b:df59 with SMTP id ot16-20020a17090b3b5000b001bf0b9bdf59mr637094pjb.11.1646261161477;
        Wed, 02 Mar 2022 14:46:01 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090ad59600b001b7deb42251sm5934640pju.15.2022.03.02.14.45.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Mar 2022 14:46:00 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     jdamato@fastly.com, mgallo@fastly.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com, netdev@vger.kernel.org,
        arkadiusz.kubalewski@intel.com
Subject: [next-queue] i40e: Add support for MPLS + TSO
Date:   Wed,  2 Mar 2022 14:45:02 -0800
Message-Id: <1646261102-84208-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support for TSO of MPLS packets.

In my tests with tcpdump it seems to work. Note this test setup has
a 9000 byte MTU:

MPLS (label 100, exp 0, [S], ttl 64) IP srcip.50086 > dstip.1234:
  Flags [P.], seq 593345:644401, ack 0, win 420,
  options [nop,nop,TS val 45022534 ecr 1722291395], length 51056

IP dstip.1234 > srcip.50086: Flags [.], ack 593345, win 122,
  options [nop,nop,TS val 1722291395 ecr 45022534], length 0

IP dstip.1234 > srcip.50086: Flags [.], ack 602289, win 105,
  options [nop,nop,TS val 1722291395 ecr 45022534], length 0

IP dstip.1234 > srcip.50086: Flags [.], ack 620177, win 71,
  options [nop,nop,TS val 1722291395 ecr 45022534], length 0

MPLS (label 100, exp 0, [S], ttl 64) IP srcip.50086 > dstip.1234:
  Flags [P.], seq 644401:655953, ack 0, win 420,
  options [nop,nop,TS val 45022534 ecr 1722291395], length 11552

IP dstip.1234 > srcip.50086: Flags [.], ack 638065, win 37,
  options [nop,nop,TS val 1722291395 ecr 45022534], length 0

IP dstip.1234 > srcip.50086: Flags [.], ack 644401, win 25,
  options [nop,nop,TS val 1722291395 ecr 45022534], length 0

IP dstip.1234 > srcip.50086: Flags [.], ack 653345, win 8,
  options [nop,nop,TS val 1722291395 ecr 45022534], length 0

IP dstip.1234 > srcip.50086: Flags [.], ack 655953, win 3,
  options [nop,nop,TS val 1722291395 ecr 45022534], length 0

Signed-off-by: Joe Damato <jdamato@fastly.com>
Co-developed-by: Mike Gallo <mgallo@fastly.com>
Signed-off-by: Mike Gallo <mgallo@fastly.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 20 +++++++++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 51 +++++++++++++++++------------
 2 files changed, 48 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1145a6e..f4730cc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13473,8 +13473,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	np->vsi = vsi;
 
 	hw_enc_features = NETIF_F_SG			|
-			  NETIF_F_IP_CSUM		|
-			  NETIF_F_IPV6_CSUM		|
+			  NETIF_F_HW_CSUM		|
 			  NETIF_F_HIGHDMA		|
 			  NETIF_F_SOFT_FEATURES		|
 			  NETIF_F_TSO			|
@@ -13505,6 +13504,23 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	/* record features VLANs can make use of */
 	netdev->vlan_features |= hw_enc_features | NETIF_F_TSO_MANGLEID;
 
+#define I40E_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE |		\
+				   NETIF_F_GSO_GRE_CSUM |	\
+				   NETIF_F_GSO_IPXIP4 |		\
+				   NETIF_F_GSO_IPXIP6 |		\
+				   NETIF_F_GSO_UDP_TUNNEL |	\
+				   NETIF_F_GSO_UDP_TUNNEL_CSUM)
+
+	netdev->gso_partial_features = I40E_GSO_PARTIAL_FEATURES;
+	netdev->features |= NETIF_F_GSO_PARTIAL |
+			    I40E_GSO_PARTIAL_FEATURES;
+
+	netdev->mpls_features |= NETIF_F_SG;
+	netdev->mpls_features |= NETIF_F_HW_CSUM;
+	netdev->mpls_features |= NETIF_F_TSO;
+	netdev->mpls_features |= NETIF_F_TSO6;
+	netdev->mpls_features |= I40E_GSO_PARTIAL_FEATURES;
+
 	/* enable macvlan offloads */
 	netdev->hw_features |= NETIF_F_HW_L2FW_DOFFLOAD;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 0eae585..fadf84a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -9,6 +9,7 @@
 #include "i40e_prototype.h"
 #include "i40e_txrx_common.h"
 #include "i40e_xsk.h"
+#include <net/mpls.h>
 
 #define I40E_TXD_CMD (I40E_TX_DESC_CMD_EOP | I40E_TX_DESC_CMD_RS)
 /**
@@ -3015,6 +3016,7 @@ static int i40e_tso(struct i40e_tx_buffer *first, u8 *hdr_len,
 {
 	struct sk_buff *skb = first->skb;
 	u64 cd_cmd, cd_tso_len, cd_mss;
+	__be16 protocol;
 	union {
 		struct iphdr *v4;
 		struct ipv6hdr *v6;
@@ -3026,7 +3028,7 @@ static int i40e_tso(struct i40e_tx_buffer *first, u8 *hdr_len,
 		unsigned char *hdr;
 	} l4;
 	u32 paylen, l4_offset;
-	u16 gso_segs, gso_size;
+	u16 gso_size;
 	int err;
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
@@ -3039,15 +3041,23 @@ static int i40e_tso(struct i40e_tx_buffer *first, u8 *hdr_len,
 	if (err < 0)
 		return err;
 
-	ip.hdr = skb_network_header(skb);
-	l4.hdr = skb_transport_header(skb);
+	protocol = vlan_get_protocol(skb);
+
+	if (eth_p_mpls(protocol))
+		ip.hdr = skb_inner_network_header(skb);
+	else
+		ip.hdr = skb_network_header(skb);
+	l4.hdr = skb_checksum_start(skb);
 
 	/* initialize outer IP header fields */
 	if (ip.v4->version == 4) {
 		ip.v4->tot_len = 0;
 		ip.v4->check = 0;
+
+		first->tx_flags |= I40E_TX_FLAGS_TSO;
 	} else {
 		ip.v6->payload_len = 0;
+		first->tx_flags |= I40E_TX_FLAGS_TSO;
 	}
 
 	if (skb_shinfo(skb)->gso_type & (SKB_GSO_GRE |
@@ -3069,10 +3079,6 @@ static int i40e_tso(struct i40e_tx_buffer *first, u8 *hdr_len,
 					     (__force __wsum)htonl(paylen));
 		}
 
-		/* reset pointers to inner headers */
-		ip.hdr = skb_inner_network_header(skb);
-		l4.hdr = skb_inner_transport_header(skb);
-
 		/* initialize inner IP header fields */
 		if (ip.v4->version == 4) {
 			ip.v4->tot_len = 0;
@@ -3100,10 +3106,9 @@ static int i40e_tso(struct i40e_tx_buffer *first, u8 *hdr_len,
 
 	/* pull values out of skb_shinfo */
 	gso_size = skb_shinfo(skb)->gso_size;
-	gso_segs = skb_shinfo(skb)->gso_segs;
 
 	/* update GSO size and bytecount with header size */
-	first->gso_segs = gso_segs;
+	first->gso_segs = skb_shinfo(skb)->gso_segs;
 	first->bytecount += (first->gso_segs - 1) * *hdr_len;
 
 	/* find the field values */
@@ -3187,13 +3192,27 @@ static int i40e_tx_enable_csum(struct sk_buff *skb, u32 *tx_flags,
 	unsigned char *exthdr;
 	u32 offset, cmd = 0;
 	__be16 frag_off;
+	__be16 protocol;
 	u8 l4_proto = 0;
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
 		return 0;
 
-	ip.hdr = skb_network_header(skb);
-	l4.hdr = skb_transport_header(skb);
+	protocol = vlan_get_protocol(skb);
+
+	if (eth_p_mpls(protocol))
+		ip.hdr = skb_inner_network_header(skb);
+	else
+		ip.hdr = skb_network_header(skb);
+	l4.hdr = skb_checksum_start(skb);
+
+	/* set the tx_flags to indicate the IP protocol type. this is
+	 * required so that checksum header computation below is accurate.
+	 */
+	if (ip.v4->version == 4)
+		*tx_flags |= I40E_TX_FLAGS_IPV4;
+	else
+		*tx_flags |= I40E_TX_FLAGS_IPV6;
 
 	/* compute outer L2 header size */
 	offset = ((ip.hdr - skb->data) / 2) << I40E_TX_DESC_LENGTH_MACLEN_SHIFT;
@@ -3749,7 +3768,6 @@ static netdev_tx_t i40e_xmit_frame_ring(struct sk_buff *skb,
 	struct i40e_tx_buffer *first;
 	u32 td_offset = 0;
 	u32 tx_flags = 0;
-	__be16 protocol;
 	u32 td_cmd = 0;
 	u8 hdr_len = 0;
 	int tso, count;
@@ -3791,15 +3809,6 @@ static netdev_tx_t i40e_xmit_frame_ring(struct sk_buff *skb,
 	if (i40e_tx_prepare_vlan_flags(skb, tx_ring, &tx_flags))
 		goto out_drop;
 
-	/* obtain protocol of skb */
-	protocol = vlan_get_protocol(skb);
-
-	/* setup IPv4/IPv6 offloads */
-	if (protocol == htons(ETH_P_IP))
-		tx_flags |= I40E_TX_FLAGS_IPV4;
-	else if (protocol == htons(ETH_P_IPV6))
-		tx_flags |= I40E_TX_FLAGS_IPV6;
-
 	tso = i40e_tso(first, &hdr_len, &cd_type_cmd_tso_mss);
 
 	if (tso < 0)
-- 
2.7.4

