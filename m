Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F37D6921A7
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbjBJPIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjBJPIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:08:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B081D92F
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676041683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=e8ZYGa32ajx7UKkBkfci0p0scmPbzf+B01H5rAfbodk=;
        b=Nh7RA45Tfw9t3cFzJe6B583TR1MKKg4XmLuWV7vc9KvDPHwETqgQ8RkHMZ4X4IvmHBRzZO
        mjupZm9zIfdv7SQE41xqRF6QI/ciDGbj5rGVfm1wU/KtMVhAWd67fQ16glq4e5dtZT/OBX
        jkWgLY39U9a2rcsN5nCw9DUXePc3gUU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-jTx170zwPRaTukeNdCqIdw-1; Fri, 10 Feb 2023 10:08:02 -0500
X-MC-Unique: jTx170zwPRaTukeNdCqIdw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14D01971087;
        Fri, 10 Feb 2023 15:08:01 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-19.brq.redhat.com [10.40.208.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F7E12166B29;
        Fri, 10 Feb 2023 15:08:00 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id A3BCF300003CA;
        Fri, 10 Feb 2023 16:07:59 +0100 (CET)
Subject: [PATCH bpf-next V1] igc: enable and fix RX hash usage by netstack
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        yoong.siang.song@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org, xdp-hints@xdp-project.net
Date:   Fri, 10 Feb 2023 16:07:59 +0100
Message-ID: <167604167956.1726972.7266620647404438534.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
this to enum pkt_hash_types. This were based on Foxville i225 software user
manual rev-1.3.1 and tested on Intel Ethernet Controller I225-LM (rev 03).

For UDP it's worth noting that RSS (type) hashing have been disabled both for
IPv4 and IPv6 (see IGC_MRQC_RSS_FIELD_IPV4_UDP + IGC_MRQC_RSS_FIELD_IPV6_UDP)
because hardware RSS doesn't handle fragmented pkts well when enabled (can
cause out-of-order). This result in PKT_HASH_TYPE_L3 for UDP packets, and
hash value doesn't include UDP port numbers. Not being PKT_HASH_TYPE_L4, have
the effect that netstack will do a software based hash calc calling into
flow_dissect, but only when code calls skb_get_hash(), which doesn't
necessary happen for local delivery.

Fixes: 2121c2712f82 ("igc: Add multiple receive queues control supporting")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/igc/igc.h      |   52 +++++++++++++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_main.c |   35 +++++++++++++++++---
 2 files changed, 83 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index df3e26c0cf01..a112eeb59525 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -311,6 +311,58 @@ extern char igc_driver_name[];
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
+#define IGC_RSS_TYPE_MASK		0xF
+
+/* igc_rss_type - Rx descriptor RSS type field */
+static inline u8 igc_rss_type(union igc_adv_rx_desc *rx_desc)
+{
+	/* RSS Type 4-bit number: 0-9 (above 9 is reserved) */
+	return rx_desc->wb.lower.lo_dword.hs_rss.pkt_info & IGC_RSS_TYPE_MASK;
+}
+
+/* Packet header type identified by hardware (when BIT(11) is zero).
+ * Even when UDP ports are not part of RSS hash HW still parse and mark UDP bits
+ */
+enum igc_pkt_type_bits {
+	IGC_PKT_TYPE_HDR_IPV4	=	BIT(0),
+	IGC_PKT_TYPE_HDR_IPV4_WITH_OPT=	BIT(1), /* IPv4 Hdr includes IP options */
+	IGC_PKT_TYPE_HDR_IPV6	=	BIT(2),
+	IGC_PKT_TYPE_HDR_IPV6_WITH_EXT=	BIT(3), /* IPv6 Hdr includes extensions */
+	IGC_PKT_TYPE_HDR_L4_TCP	=	BIT(4),
+	IGC_PKT_TYPE_HDR_L4_UDP	=	BIT(5),
+	IGC_PKT_TYPE_HDR_L4_SCTP=	BIT(6),
+	IGC_PKT_TYPE_HDR_NFS	=	BIT(7),
+	/* Above only valid when BIT(11) is zero */
+	IGC_PKT_TYPE_L2		=	BIT(11),
+	IGC_PKT_TYPE_VLAN	=	BIT(12),
+	IGC_PKT_TYPE_MASK	=	0x1FFF, /* 13-bits */
+};
+
+/* igc_pkt_type - Rx descriptor Packet type field */
+static inline u16 igc_pkt_type(union igc_adv_rx_desc *rx_desc)
+{
+	u32 data = le32_to_cpu(rx_desc->wb.lower.lo_dword.data);
+	/* Packet type is 13-bits - as bits (16:4) in lower.lo_dword*/
+	u16 pkt_type = (data >> 4) & IGC_PKT_TYPE_MASK;
+
+	return pkt_type;
+}
+
 /* Interrupt defines */
 #define IGC_START_ITR			648 /* ~6000 ints/sec */
 #define IGC_4K_ITR			980
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 8b572cd2c350..42a072509d2a 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1677,14 +1677,40 @@ static void igc_rx_checksum(struct igc_ring *ring,
 		   le32_to_cpu(rx_desc->wb.upper.status_error));
 }
 
+/* Mapping HW RSS Type to enum pkt_hash_types */
+struct igc_rss_type {
+	u8 hash_type; /* can contain enum pkt_hash_types */
+} igc_rss_type_table[IGC_RSS_TYPE_MAX_TABLE] = {
+	[IGC_RSS_TYPE_NO_HASH].hash_type	  = PKT_HASH_TYPE_L2,
+	[IGC_RSS_TYPE_HASH_TCP_IPV4].hash_type	  = PKT_HASH_TYPE_L4,
+	[IGC_RSS_TYPE_HASH_IPV4].hash_type	  = PKT_HASH_TYPE_L3,
+	[IGC_RSS_TYPE_HASH_TCP_IPV6].hash_type	  = PKT_HASH_TYPE_L4,
+	[IGC_RSS_TYPE_HASH_IPV6_EX].hash_type	  = PKT_HASH_TYPE_L3,
+	[IGC_RSS_TYPE_HASH_IPV6].hash_type	  = PKT_HASH_TYPE_L3,
+	[IGC_RSS_TYPE_HASH_TCP_IPV6_EX].hash_type = PKT_HASH_TYPE_L4,
+	[IGC_RSS_TYPE_HASH_UDP_IPV4].hash_type	  = PKT_HASH_TYPE_L4,
+	[IGC_RSS_TYPE_HASH_UDP_IPV6].hash_type	  = PKT_HASH_TYPE_L4,
+	[IGC_RSS_TYPE_HASH_UDP_IPV6_EX].hash_type = PKT_HASH_TYPE_L4,
+	[10].hash_type = PKT_HASH_TYPE_L2, /* RSS Type above 9 "Reserved" by HW */
+	[11].hash_type = PKT_HASH_TYPE_L2,
+	[12].hash_type = PKT_HASH_TYPE_L2,
+	[13].hash_type = PKT_HASH_TYPE_L2,
+	[14].hash_type = PKT_HASH_TYPE_L2,
+	[15].hash_type = PKT_HASH_TYPE_L2,
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
+		u8  rss_type = igc_rss_type(rx_desc);
+		enum pkt_hash_types hash_type;
+
+		hash_type = igc_rss_type_table[rss_type].hash_type;
+		skb_set_hash(skb, rss_hash, hash_type);
+	}
 }
 
 static void igc_rx_vlan(struct igc_ring *rx_ring,
@@ -6501,6 +6527,7 @@ static int igc_probe(struct pci_dev *pdev,
 	netdev->features |= NETIF_F_TSO;
 	netdev->features |= NETIF_F_TSO6;
 	netdev->features |= NETIF_F_TSO_ECN;
+	netdev->features |= NETIF_F_RXHASH;
 	netdev->features |= NETIF_F_RXCSUM;
 	netdev->features |= NETIF_F_HW_CSUM;
 	netdev->features |= NETIF_F_SCTP_CRC;


