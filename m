Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D226E65F3
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 15:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbjDRNbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 09:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbjDRNbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 09:31:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D3914476
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 06:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681824650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DQLp/bDiJrLIn15C39/j/M4j9TLKrN3SMwzO4FOSIKY=;
        b=bLmbZiACG4vMiinByf9ehEkPM8PYYRwV6jOqmOfoI3qzFFpza8j1qH88RDerFqSGyC0VHh
        sEGFAQCsgrpL724j8MYwPRs0eBpeUdxNLg6rP0Ey1TaM+QwUvedihyZ5nWuB0FumzU27CD
        Em1osHJKgl1EJ4+WdTyVBWjKDKgQYhI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-C2UzXstBMjCcODvroXG6rw-1; Tue, 18 Apr 2023 09:30:46 -0400
X-MC-Unique: C2UzXstBMjCcODvroXG6rw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C653F3850541;
        Tue, 18 Apr 2023 13:30:43 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67DC840C83A9;
        Tue, 18 Apr 2023 13:30:43 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id BD404307372E8;
        Tue, 18 Apr 2023 15:30:42 +0200 (CEST)
Subject: [PATCH bpf-next V2 1/5] igc: enable and fix RX hash usage by netstack
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, yoong.siang.song@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net
Date:   Tue, 18 Apr 2023 15:30:42 +0200
Message-ID: <168182464270.616355.11391652654430626584.stgit@firesoul>
In-Reply-To: <168182460362.616355.14591423386485175723.stgit@firesoul>
References: <168182460362.616355.14591423386485175723.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When function igc_rx_hash() was introduced in v4.20 via commit 0507ef8a0372
("igc: Add transmit and receive fastpath and interrupt handlers"), the
hardware wasn't configured to provide RSS hash, thus it made sense to not
enable net_device NETIF_F_RXHASH feature bit.

The NIC hardware was configured to enable RSS hash info in v5.2 via commit
2121c2712f82 ("igc: Add multiple receive queues control supporting"), but
forgot to set the NETIF_F_RXHASH feature bit.

The original implementation of igc_rx_hash() didn't extract the associated
pkt_hash_type, but statically set PKT_HASH_TYPE_L3. The largest portions of
this patch are about extracting the RSS Type from the hardware and mapping
this to enum pkt_hash_types. This was based on Foxville i225 software user
manual rev-1.3.1 and tested on Intel Ethernet Controller I225-LM (rev 03).

For UDP it's worth noting that RSS (type) hashing have been disabled both for
IPv4 and IPv6 (see IGC_MRQC_RSS_FIELD_IPV4_UDP + IGC_MRQC_RSS_FIELD_IPV6_UDP)
because hardware RSS doesn't handle fragmented pkts well when enabled (can
cause out-of-order). This results in PKT_HASH_TYPE_L3 for UDP packets, and
hash value doesn't include UDP port numbers. Not being PKT_HASH_TYPE_L4, have
the effect that netstack will do a software based hash calc calling into
flow_dissect, but only when code calls skb_get_hash(), which doesn't
necessary happen for local delivery.

For QA verification testing I wrote a small bpftrace prog:
 [0] https://github.com/xdp-project/xdp-project/blob/master/areas/hints/monitor_skb_hash_on_dev.bt

Fixes: 2121c2712f82 ("igc: Add multiple receive queues control supporting")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/igc/igc.h      |   28 ++++++++++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_main.c |   31 +++++++++++++++++++++++++----
 2 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 34aebf00a512..f7f9e217e7b4 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -13,6 +13,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
 #include <linux/net_tstamp.h>
+#include <linux/bitfield.h>
 
 #include "igc_hw.h"
 
@@ -311,6 +312,33 @@ extern char igc_driver_name[];
 #define IGC_MRQC_RSS_FIELD_IPV4_UDP	0x00400000
 #define IGC_MRQC_RSS_FIELD_IPV6_UDP	0x00800000
 
+/* RX-desc Write-Back format RSS Type's */
+enum igc_rss_type_num {
+	IGC_RSS_TYPE_NO_HASH		= 0,
+	IGC_RSS_TYPE_HASH_TCP_IPV4	= 1,
+	IGC_RSS_TYPE_HASH_IPV4		= 2,
+	IGC_RSS_TYPE_HASH_TCP_IPV6	= 3,
+	IGC_RSS_TYPE_HASH_IPV6_EX	= 4,
+	IGC_RSS_TYPE_HASH_IPV6		= 5,
+	IGC_RSS_TYPE_HASH_TCP_IPV6_EX	= 6,
+	IGC_RSS_TYPE_HASH_UDP_IPV4	= 7,
+	IGC_RSS_TYPE_HASH_UDP_IPV6	= 8,
+	IGC_RSS_TYPE_HASH_UDP_IPV6_EX	= 9,
+	IGC_RSS_TYPE_MAX		= 10,
+};
+#define IGC_RSS_TYPE_MAX_TABLE		16
+#define IGC_RSS_TYPE_MASK		GENMASK(3,0) /* 4-bits (3:0) = mask 0x0F */
+
+/* igc_rss_type - Rx descriptor RSS type field */
+static inline u32 igc_rss_type(const union igc_adv_rx_desc *rx_desc)
+{
+	/* RSS Type 4-bits (3:0) number: 0-9 (above 9 is reserved)
+	 * Accessing the same bits via u16 (wb.lower.lo_dword.hs_rss.pkt_info)
+	 * is slightly slower than via u32 (wb.lower.lo_dword.data)
+	 */
+	return le32_get_bits(rx_desc->wb.lower.lo_dword.data, IGC_RSS_TYPE_MASK);
+}
+
 /* Interrupt defines */
 #define IGC_START_ITR			648 /* ~6000 ints/sec */
 #define IGC_4K_ITR			980
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1c4676882082..bfa9768d447f 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1690,14 +1690,36 @@ static void igc_rx_checksum(struct igc_ring *ring,
 		   le32_to_cpu(rx_desc->wb.upper.status_error));
 }
 
+/* Mapping HW RSS Type to enum pkt_hash_types */
+static const enum pkt_hash_types igc_rss_type_table[IGC_RSS_TYPE_MAX_TABLE] = {
+	[IGC_RSS_TYPE_NO_HASH]		= PKT_HASH_TYPE_L2,
+	[IGC_RSS_TYPE_HASH_TCP_IPV4]	= PKT_HASH_TYPE_L4,
+	[IGC_RSS_TYPE_HASH_IPV4]	= PKT_HASH_TYPE_L3,
+	[IGC_RSS_TYPE_HASH_TCP_IPV6]	= PKT_HASH_TYPE_L4,
+	[IGC_RSS_TYPE_HASH_IPV6_EX]	= PKT_HASH_TYPE_L3,
+	[IGC_RSS_TYPE_HASH_IPV6]	= PKT_HASH_TYPE_L3,
+	[IGC_RSS_TYPE_HASH_TCP_IPV6_EX] = PKT_HASH_TYPE_L4,
+	[IGC_RSS_TYPE_HASH_UDP_IPV4]	= PKT_HASH_TYPE_L4,
+	[IGC_RSS_TYPE_HASH_UDP_IPV6]	= PKT_HASH_TYPE_L4,
+	[IGC_RSS_TYPE_HASH_UDP_IPV6_EX] = PKT_HASH_TYPE_L4,
+	[10] = PKT_HASH_TYPE_NONE, /* RSS Type above 9 "Reserved" by HW  */
+	[11] = PKT_HASH_TYPE_NONE, /* keep array sized for SW bit-mask   */
+	[12] = PKT_HASH_TYPE_NONE, /* to handle future HW revisons       */
+	[13] = PKT_HASH_TYPE_NONE,
+	[14] = PKT_HASH_TYPE_NONE,
+	[15] = PKT_HASH_TYPE_NONE,
+};
+
 static inline void igc_rx_hash(struct igc_ring *ring,
 			       union igc_adv_rx_desc *rx_desc,
 			       struct sk_buff *skb)
 {
-	if (ring->netdev->features & NETIF_F_RXHASH)
-		skb_set_hash(skb,
-			     le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
-			     PKT_HASH_TYPE_L3);
+	if (ring->netdev->features & NETIF_F_RXHASH) {
+		u32 rss_hash = le32_to_cpu(rx_desc->wb.lower.hi_dword.rss);
+		u32 rss_type = igc_rss_type(rx_desc);
+
+		skb_set_hash(skb, rss_hash, igc_rss_type_table[rss_type]);
+	}
 }
 
 static void igc_rx_vlan(struct igc_ring *rx_ring,
@@ -6554,6 +6576,7 @@ static int igc_probe(struct pci_dev *pdev,
 	netdev->features |= NETIF_F_TSO;
 	netdev->features |= NETIF_F_TSO6;
 	netdev->features |= NETIF_F_TSO_ECN;
+	netdev->features |= NETIF_F_RXHASH;
 	netdev->features |= NETIF_F_RXCSUM;
 	netdev->features |= NETIF_F_HW_CSUM;
 	netdev->features |= NETIF_F_SCTP_CRC;


