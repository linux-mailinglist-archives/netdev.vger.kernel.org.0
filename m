Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218136E65F6
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 15:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjDRNbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 09:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbjDRNbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 09:31:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2C514F57
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 06:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681824662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z+Wj+wuar2esG3Vf+0jIPaMSY2J1burZPGTUx2EHY1I=;
        b=ZGT+C/DNHx1tehbaFC648z6bJrkyqR9FrrGGRq+Pi7QuGqwUqSq3ly0oFK4kbyO+q33a7A
        Xj1hF5ceXPZcLzbwScJgg6Ve8zWT3VQOp8Mmu5VxaU1mZps1dJrcDRrblUCNI44Xuu5exD
        HliEmQCqsE3j8BFpir8lDimSUqs4JPA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-5TqzC1WfMP-cICaGFtp0Xg-1; Tue, 18 Apr 2023 09:30:56 -0400
X-MC-Unique: 5TqzC1WfMP-cICaGFtp0Xg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24F3E1C0170B;
        Tue, 18 Apr 2023 13:30:54 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0DB740C845F;
        Tue, 18 Apr 2023 13:30:53 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id DC7A7307372E8;
        Tue, 18 Apr 2023 15:30:52 +0200 (CEST)
Subject: [PATCH bpf-next V2 3/5] igc: add XDP hints kfuncs for RX hash
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
Date:   Tue, 18 Apr 2023 15:30:52 +0200
Message-ID: <168182465285.616355.2701740913376314790.stgit@firesoul>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements XDP hints kfunc for RX-hash (xmo_rx_hash).
The HW rss hash type is handled via mapping table.

This igc driver (default config) does L3 hashing for UDP packets
(excludes UDP src/dest ports in hash calc).  Meaning RSS hash type is
L3 based.  Tested that the igc_rss_type_num for UDP is either
IGC_RSS_TYPE_HASH_IPV4 or IGC_RSS_TYPE_HASH_IPV6.

This patch also updates AF_XDP zero-copy function igc_clean_rx_irq_zc()
to use the xdp_buff wrapper struct igc_xdp_buff.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/igc/igc.h      |    1 +
 drivers/net/ethernet/intel/igc/igc_main.c |   53 +++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 76a5115aefc8..c609a2e648f8 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -502,6 +502,7 @@ struct igc_rx_buffer {
 /* context wrapper around xdp_buff to provide access to descriptor metadata */
 struct igc_xdp_buff {
 	struct xdp_buff xdp;
+	union igc_adv_rx_desc *rx_desc;
 };
 
 struct igc_q_vector {
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 6a4c7cd706bd..9cb43c0eab73 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2562,6 +2562,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 					 igc_rx_offset(rx_ring) + pkt_offset,
 					 size, true);
 			xdp_buff_clear_frags_flag(&ctx.xdp);
+			ctx.rx_desc = rx_desc;
 
 			skb = igc_xdp_run_prog(adapter, &ctx.xdp);
 		}
@@ -2688,6 +2689,15 @@ static void igc_dispatch_skb_zc(struct igc_q_vector *q_vector,
 	napi_gro_receive(&q_vector->napi, skb);
 }
 
+static struct igc_xdp_buff *xsk_buff_to_igc_ctx(struct xdp_buff *xdp)
+{
+	/* xdp_buff pointer used by ZC code path is alloc as xdp_buff_xsk. The
+	 * igc_xdp_buff shares its layout with xdp_buff_xsk and private
+	 * igc_xdp_buff fields fall into xdp_buff_xsk->cb
+	 */
+       return (struct igc_xdp_buff *)xdp;
+}
+
 static int igc_clean_rx_irq_zc(struct igc_q_vector *q_vector, const int budget)
 {
 	struct igc_adapter *adapter = q_vector->adapter;
@@ -2706,6 +2716,7 @@ static int igc_clean_rx_irq_zc(struct igc_q_vector *q_vector, const int budget)
 	while (likely(total_packets < budget)) {
 		union igc_adv_rx_desc *desc;
 		struct igc_rx_buffer *bi;
+		struct igc_xdp_buff *ctx;
 		ktime_t timestamp = 0;
 		unsigned int size;
 		int res;
@@ -2723,6 +2734,9 @@ static int igc_clean_rx_irq_zc(struct igc_q_vector *q_vector, const int budget)
 
 		bi = &ring->rx_buffer_info[ntc];
 
+		ctx = xsk_buff_to_igc_ctx(bi->xdp);
+		ctx->rx_desc = desc;
+
 		if (igc_test_staterr(desc, IGC_RXDADV_STAT_TSIP)) {
 			timestamp = igc_ptp_rx_pktstamp(q_vector->adapter,
 							bi->xdp->data);
@@ -6478,6 +6492,44 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
 	return value;
 }
 
+/* Mapping HW RSS Type to enum xdp_rss_hash_type */
+static enum xdp_rss_hash_type igc_xdp_rss_type[IGC_RSS_TYPE_MAX_TABLE] = {
+	[IGC_RSS_TYPE_NO_HASH]		= XDP_RSS_TYPE_L2,
+	[IGC_RSS_TYPE_HASH_TCP_IPV4]	= XDP_RSS_TYPE_L4_IPV4_TCP,
+	[IGC_RSS_TYPE_HASH_IPV4]	= XDP_RSS_TYPE_L3_IPV4,
+	[IGC_RSS_TYPE_HASH_TCP_IPV6]	= XDP_RSS_TYPE_L4_IPV6_TCP,
+	[IGC_RSS_TYPE_HASH_IPV6_EX]	= XDP_RSS_TYPE_L3_IPV6_EX,
+	[IGC_RSS_TYPE_HASH_IPV6]	= XDP_RSS_TYPE_L3_IPV6,
+	[IGC_RSS_TYPE_HASH_TCP_IPV6_EX] = XDP_RSS_TYPE_L4_IPV6_TCP_EX,
+	[IGC_RSS_TYPE_HASH_UDP_IPV4]	= XDP_RSS_TYPE_L4_IPV4_UDP,
+	[IGC_RSS_TYPE_HASH_UDP_IPV6]	= XDP_RSS_TYPE_L4_IPV6_UDP,
+	[IGC_RSS_TYPE_HASH_UDP_IPV6_EX] = XDP_RSS_TYPE_L4_IPV6_UDP_EX,
+	[10] = XDP_RSS_TYPE_NONE, /* RSS Type above 9 "Reserved" by HW  */
+	[11] = XDP_RSS_TYPE_NONE, /* keep array sized for SW bit-mask   */
+	[12] = XDP_RSS_TYPE_NONE, /* to handle future HW revisons       */
+	[13] = XDP_RSS_TYPE_NONE,
+	[14] = XDP_RSS_TYPE_NONE,
+	[15] = XDP_RSS_TYPE_NONE,
+};
+
+static int igc_xdp_rx_hash(const struct xdp_md *_ctx, u32 *hash,
+			   enum xdp_rss_hash_type *rss_type)
+{
+	const struct igc_xdp_buff *ctx = (void *)_ctx;
+
+	if (!(ctx->xdp.rxq->dev->features & NETIF_F_RXHASH))
+		return -ENODATA;
+
+	*hash = le32_to_cpu(ctx->rx_desc->wb.lower.hi_dword.rss);
+	*rss_type = igc_xdp_rss_type[igc_rss_type(ctx->rx_desc)];
+
+	return 0;
+}
+
+static const struct xdp_metadata_ops igc_xdp_metadata_ops = {
+	.xmo_rx_hash			= igc_xdp_rx_hash,
+};
+
 /**
  * igc_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -6551,6 +6603,7 @@ static int igc_probe(struct pci_dev *pdev,
 	hw->hw_addr = adapter->io_addr;
 
 	netdev->netdev_ops = &igc_netdev_ops;
+	netdev->xdp_metadata_ops = &igc_xdp_metadata_ops;
 	igc_ethtool_set_ops(netdev);
 	netdev->watchdog_timeo = 5 * HZ;
 


