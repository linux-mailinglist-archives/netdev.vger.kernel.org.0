Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D0A6BEB6D
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjCQOfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjCQOen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:34:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC04B7E7B0
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 07:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679063624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mjoXfv22y8bGZIaFBiqJSnnyyPeBBhNiGzC+o+ftHU0=;
        b=B/tfQnEGkDS57A/y13FurjatdrwGuAZqlggGlx1efHx4PNerLeKDRHsyOTHloT18CpZo7m
        KreGt+5IIudaocmsJxLgzC+wuH+yi82BH8blCPWTJHyCNqB1erMl6N2sfe6CZ8lNC7S2Cp
        jHp+bbFpYOESz0jiZW8WCmTZqp7oX/M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-vEsSmLi-MDG77URLj2TIkw-1; Fri, 17 Mar 2023 10:33:42 -0400
X-MC-Unique: vEsSmLi-MDG77URLj2TIkw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25AB3385F36B;
        Fri, 17 Mar 2023 14:33:42 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E006D40D1C7;
        Fri, 17 Mar 2023 14:33:41 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 17C9530721A6C;
        Fri, 17 Mar 2023 15:33:41 +0100 (CET)
Subject: [PATCH bpf-next V1 6/7] igc: add XDP hints kfuncs for RX timestamp
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com
Date:   Fri, 17 Mar 2023 15:33:41 +0100
Message-ID: <167906362105.2706833.16377530444749058977.stgit@firesoul>
In-Reply-To: <167906343576.2706833.17489167761084071890.stgit@firesoul>
References: <167906343576.2706833.17489167761084071890.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NIC hardware RX timestamping mechanism adds an optional tailored
header before the MAC header containing packet reception time. Optional
depending on RX descriptor TSIP status bit (IGC_RXDADV_STAT_TSIP). In
case this bit is set driver does offset adjustments to packet data start
and extracts the timestamp.

The timestamp need to be extracted before invoking the XDP bpf_prog,
because this area just before the packet is also accessible by XDP via
data_meta context pointer (and helper bpf_xdp_adjust_meta). Thus, an XDP
bpf_prog can potentially overwrite this and corrupt data that we want to
extract with the new kfunc for reading the timestamp.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/igc/igc.h      |    1 +
 drivers/net/ethernet/intel/igc/igc_main.c |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index bc67a52e47e8..29941734f1a1 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -503,6 +503,7 @@ struct igc_rx_buffer {
 struct igc_xdp_buff {
 	struct xdp_buff xdp;
 	union igc_adv_rx_desc *rx_desc;
+	ktime_t rx_ts; /* data indication bit IGC_RXDADV_STAT_TSIP */
 };
 
 struct igc_q_vector {
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index a78d7e6bcfd6..f66285c85444 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2539,6 +2539,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 		if (igc_test_staterr(rx_desc, IGC_RXDADV_STAT_TSIP)) {
 			timestamp = igc_ptp_rx_pktstamp(q_vector->adapter,
 							pktbuf);
+			ctx.rx_ts = timestamp;
 			pkt_offset = IGC_TS_HDR_LEN;
 			size -= IGC_TS_HDR_LEN;
 		}
@@ -2727,6 +2728,7 @@ static int igc_clean_rx_irq_zc(struct igc_q_vector *q_vector, const int budget)
 		if (igc_test_staterr(desc, IGC_RXDADV_STAT_TSIP)) {
 			timestamp = igc_ptp_rx_pktstamp(q_vector->adapter,
 							bi->xdp->data);
+			ctx->rx_ts = timestamp;
 
 			bi->xdp->data += IGC_TS_HDR_LEN;
 
@@ -6481,6 +6483,23 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
 	return value;
 }
 
+static int igc_xdp_rx_timestamp(const struct xdp_md *_ctx, u64 *timestamp)
+{
+	const struct igc_xdp_buff *ctx = (void *)_ctx;
+
+	if (igc_test_staterr(ctx->rx_desc, IGC_RXDADV_STAT_TSIP)) {
+		*timestamp = ctx->rx_ts;
+
+		return 0;
+	}
+
+	return -ENODATA;
+}
+
+const struct xdp_metadata_ops igc_xdp_metadata_ops = {
+	.xmo_rx_timestamp		= igc_xdp_rx_timestamp,
+};
+
 /**
  * igc_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -6554,6 +6573,7 @@ static int igc_probe(struct pci_dev *pdev,
 	hw->hw_addr = adapter->io_addr;
 
 	netdev->netdev_ops = &igc_netdev_ops;
+	netdev->xdp_metadata_ops = &igc_xdp_metadata_ops;
 	igc_ethtool_set_ops(netdev);
 	netdev->watchdog_timeo = 5 * HZ;
 


