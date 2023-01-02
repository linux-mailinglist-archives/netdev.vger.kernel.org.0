Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82C365B407
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 16:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbjABPTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 10:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236339AbjABPTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 10:19:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C32D10F9
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 07:19:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACC3C60C2A
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 15:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD661C433D2;
        Mon,  2 Jan 2023 15:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672672763;
        bh=FWUohQqVxutaX+oxbGwEgZu0QqVwW0r5RqdR/kUxhlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KM6ZYCVbbKKWbZrWFhMOk8Ub5E+F0S+sZRepEhlHnob1IT3Dsry6Kd/HHC5xRKrba
         WGZXuhWl6aIQ+kgrrcm5zArOBNvdvrt9d94+uZgm2RYmtaqpqv1W9CTEU25QKAc/7M
         RlNqTR9TOP6yQK7PwuyHmao2ywtiYfClMUt8KwSTXgPHVULN+tBKBdQUx8rvajEHTc
         sIXA0CmCh5Qc38/ozDP4ravD6o0Iq3X74eA166dvK7409YsB9s1zKAVH+7vgSV70lT
         NRVOwcG155KoBko8tKzF6YIaY0PTHHEiDDld3lnwfgB1Q1O72fThGXAq++ypg0kvsC
         vCxVVIBy2gaHg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com
Subject: [PATCH net-next 3/3] net: ethernet: enetc: do not always access skb_shared_info in the XDP path
Date:   Mon,  2 Jan 2023 16:18:53 +0100
Message-Id: <d754946d47643a74a009593765907649a552ea35.1672672314.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1672672314.git.lorenzo@kernel.org>
References: <cover.1672672314.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move XDP skb_shared_info structure initialization in from
enetc_map_rx_buff_to_xdp() to enetc_add_rx_buff_to_xdp() and do not always
access skb_shared_info in the xdp_buff/xdp_frame since it is located in a
different cacheline with respect to hard_start and data xdp pointers.
Rely on XDP_FLAGS_HAS_FRAGS flag to check if it really necessary to access
non-linear part of the xdp_buff/xdp_frame.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 18a01f6282b6..5ad0b259e623 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1305,6 +1305,10 @@ static int enetc_xdp_frame_to_xdp_tx_swbd(struct enetc_bdr *tx_ring,
 	xdp_tx_swbd->xdp_frame = NULL;
 
 	n++;
+
+	if (!xdp_frame_has_frags(xdp_frame))
+		goto out;
+
 	xdp_tx_swbd = &xdp_tx_arr[n];
 
 	shinfo = xdp_get_shared_info_from_frame(xdp_frame);
@@ -1334,7 +1338,7 @@ static int enetc_xdp_frame_to_xdp_tx_swbd(struct enetc_bdr *tx_ring,
 		n++;
 		xdp_tx_swbd = &xdp_tx_arr[n];
 	}
-
+out:
 	xdp_tx_arr[n - 1].is_eof = true;
 	xdp_tx_arr[n - 1].xdp_frame = xdp_frame;
 
@@ -1390,16 +1394,12 @@ static void enetc_map_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
 {
 	struct enetc_rx_swbd *rx_swbd = enetc_get_rx_buff(rx_ring, i, size);
 	void *hard_start = page_address(rx_swbd->page) + rx_swbd->page_offset;
-	struct skb_shared_info *shinfo;
 
 	/* To be used for XDP_TX */
 	rx_swbd->len = size;
 
 	xdp_prepare_buff(xdp_buff, hard_start - rx_ring->buffer_offset,
 			 rx_ring->buffer_offset, size, false);
-
-	shinfo = xdp_get_shared_info_from_buff(xdp_buff);
-	shinfo->nr_frags = 0;
 }
 
 static void enetc_add_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
@@ -1407,7 +1407,7 @@ static void enetc_add_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
 {
 	struct skb_shared_info *shinfo = xdp_get_shared_info_from_buff(xdp_buff);
 	struct enetc_rx_swbd *rx_swbd = enetc_get_rx_buff(rx_ring, i, size);
-	skb_frag_t *frag = &shinfo->frags[shinfo->nr_frags];
+	skb_frag_t *frag;
 
 	/* To be used for XDP_TX */
 	rx_swbd->len = size;
@@ -1415,6 +1415,7 @@ static void enetc_add_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
 	if (!xdp_buff_has_frags(xdp_buff)) {
 		xdp_buff_set_frags_flag(xdp_buff);
 		shinfo->xdp_frags_size = size;
+		shinfo->nr_frags = 0;
 	} else {
 		shinfo->xdp_frags_size += size;
 	}
@@ -1422,6 +1423,7 @@ static void enetc_add_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
 	if (page_is_pfmemalloc(rx_swbd->page))
 		xdp_buff_set_frag_pfmemalloc(xdp_buff);
 
+	frag = &shinfo->frags[shinfo->nr_frags];
 	skb_frag_off_set(frag, rx_swbd->page_offset);
 	skb_frag_size_set(frag, size);
 	__skb_frag_set_page(frag, rx_swbd->page);
-- 
2.39.0

