Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E481564B29F
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 10:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbiLMJrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 04:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiLMJrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 04:47:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B7BF59E
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 01:47:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1E95B80B73
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 09:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22291C433EF;
        Tue, 13 Dec 2022 09:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670924824;
        bh=EeikwQ4k0/Dv6jOR/fcg08tVBJFVhJPGDQ2Bpk6KG3I=;
        h=From:To:Cc:Subject:Date:From;
        b=oWpsYLjqB37do4anrA9JmoxpmDoRs2k9XG9C58HjaunTTQf/r531X28iiBX0itgfY
         RGPklkS9+pdMsuNti8AMl/d5++yQfOq+HkD/aKbKE3jxq1mwoJ0CRV0hlC06uYWSDH
         1/AZMDy16MkYt5x70z3KNOWi0UDN3lU0OpR40pkw2OI2pJXUyd4lRrJ4jbfo39Uet5
         /KyoJVDMxJKi2xLCa6OG0S8ScTsgifZZDSnVfbA+F5VbqFQVBIvsmpDwNU6HPdFld0
         ALsqyLpVc4+ASbBEc6t0gLPw31tdFn57AvSYL900V4NTJPTZKxpYnWtMQrHPCk+PI/
         W/GSF+0ctkFnw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, vladimir.oltean@nxp.com,
        lorenzo.bianconi@redhat.com
Subject: [RFT] net: ethernet: enetc: do not always access skb_shared_info in the XDP path
Date:   Tue, 13 Dec 2022 10:46:43 +0100
Message-Id: <8acb59077ff51eb58ca164e432be63194a92b0bf.1670924659.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
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

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
This patch is based on the following series not applied yet to next-next:
https://patchwork.kernel.org/project/netdevbpf/cover/cover.1670680119.git.lorenzo@kernel.org/
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index cd8f5f0c6b54..2ed6b163f3c8 100644
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
2.38.1

