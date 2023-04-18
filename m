Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7786E65F9
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 15:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbjDRNcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 09:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjDRNcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 09:32:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFC715470
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 06:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681824675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AK4HrA02Q1v0w9WsJgOrguYhNpSNgBPs/ggkgsLYvjA=;
        b=es8IrlZRIAemOAEgDKsqi4VbacChaKz324gA97fZ6Beid0g88WU1gOGUDkWDzo5Nju8BU4
        gQNJtP7MGIKKGXiX38Y90iydyWNf5ofBqqtu85m5OliHyA16UvmIZb+UeVI4O9SyKEaogG
        uHqwuT478HDlkOIDr9i3qvZC3fU89eQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-PMQLmTNYOwewXYm-BgBc4g-1; Tue, 18 Apr 2023 09:31:06 -0400
X-MC-Unique: PMQLmTNYOwewXYm-BgBc4g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E28DC3850542;
        Tue, 18 Apr 2023 13:31:03 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B2B51410F21;
        Tue, 18 Apr 2023 13:30:58 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id EC4FC307372E8;
        Tue, 18 Apr 2023 15:30:57 +0200 (CEST)
Subject: [PATCH bpf-next V2 4/5] igc: add XDP hints kfuncs for RX timestamp
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
Date:   Tue, 18 Apr 2023 15:30:57 +0200
Message-ID: <168182465791.616355.2583922957423587914.stgit@firesoul>
In-Reply-To: <168182460362.616355.14591423386485175723.stgit@firesoul>
References: <168182460362.616355.14591423386485175723.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/intel/igc/igc_main.c |   16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index c609a2e648f8..18d4af934d8c 100644
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
index 9cb43c0eab73..38d113b48111 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2552,6 +2552,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 		if (igc_test_staterr(rx_desc, IGC_RXDADV_STAT_TSIP)) {
 			timestamp = igc_ptp_rx_pktstamp(q_vector->adapter,
 							pktbuf);
+			ctx.rx_ts = timestamp;
 			pkt_offset = IGC_TS_HDR_LEN;
 			size -= IGC_TS_HDR_LEN;
 		}
@@ -2740,6 +2741,7 @@ static int igc_clean_rx_irq_zc(struct igc_q_vector *q_vector, const int budget)
 		if (igc_test_staterr(desc, IGC_RXDADV_STAT_TSIP)) {
 			timestamp = igc_ptp_rx_pktstamp(q_vector->adapter,
 							bi->xdp->data);
+			ctx->rx_ts = timestamp;
 
 			bi->xdp->data += IGC_TS_HDR_LEN;
 
@@ -6526,8 +6528,22 @@ static int igc_xdp_rx_hash(const struct xdp_md *_ctx, u32 *hash,
 	return 0;
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
 static const struct xdp_metadata_ops igc_xdp_metadata_ops = {
 	.xmo_rx_hash			= igc_xdp_rx_hash,
+	.xmo_rx_timestamp		= igc_xdp_rx_timestamp,
 };
 
 /**


