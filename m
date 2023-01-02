Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62AA265B409
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 16:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236096AbjABPTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 10:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236323AbjABPTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 10:19:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5721F10A6
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 07:19:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC20760A24
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 15:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFFCC433EF;
        Mon,  2 Jan 2023 15:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672672755;
        bh=7g/u2VMMIO9/7S3DkIGknPlGgh/bA7HKunZYs2JNXU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VACg9w3c1JLaRv1H6caXWLvrKknPCwifpc88gDFPjPwLZEDKEVEYvzE3uI0vPgKvb
         al/Z6ZL26iu+/dKfO3m2nJ3XlmtBfgekPNvFHCb+x7PQjyiEOLkjPCLKlxnT84tqAP
         KAKetTzjNqNbWdJns8TIXh9YQkBJConvOibCqmvY/lEfQbE04prFVah+e8ZXGY/Vsm
         ErEUUm1ncGiNepncuqNoA7zLNfPYrQtAIggKh62dl39+c6Ls6UBysHOwSD41IJ1xE7
         lu0ih7FZWOXlNtl5Kg6axlwIX6xpAstDb/6X6TIEaiDSChPPvsw1cpAEwZSgiQy05U
         sJHtosCHr8DPA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com
Subject: [PATCH net-next 1/3] net: ethernet: enetc: unlock XDP_REDIRECT for XDP non-linear buffers
Date:   Mon,  2 Jan 2023 16:18:51 +0100
Message-Id: <783a763dc5c92e1b4bbe72117bda83c14be060cc.1672672314.git.lorenzo@kernel.org>
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

Even if full XDP_REDIRECT is not supported yet for non-linear XDP buffers
since we allow redirecting just into CPUMAPs, unlock XDP_REDIRECT for
S/G XDP buffer and rely on XDP stack to properly take care of the
frames.

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 24 ++++++++------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3a79ead5219a..18a01f6282b6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1412,6 +1412,16 @@ static void enetc_add_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
 	/* To be used for XDP_TX */
 	rx_swbd->len = size;
 
+	if (!xdp_buff_has_frags(xdp_buff)) {
+		xdp_buff_set_frags_flag(xdp_buff);
+		shinfo->xdp_frags_size = size;
+	} else {
+		shinfo->xdp_frags_size += size;
+	}
+
+	if (page_is_pfmemalloc(rx_swbd->page))
+		xdp_buff_set_frag_pfmemalloc(xdp_buff);
+
 	skb_frag_off_set(frag, rx_swbd->page_offset);
 	skb_frag_size_set(frag, size);
 	__skb_frag_set_page(frag, rx_swbd->page);
@@ -1584,20 +1594,6 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 			}
 			break;
 		case XDP_REDIRECT:
-			/* xdp_return_frame does not support S/G in the sense
-			 * that it leaks the fragments (__xdp_return should not
-			 * call page_frag_free only for the initial buffer).
-			 * Until XDP_REDIRECT gains support for S/G let's keep
-			 * the code structure in place, but dead. We drop the
-			 * S/G frames ourselves to avoid memory leaks which
-			 * would otherwise leave the kernel OOM.
-			 */
-			if (unlikely(cleaned_cnt - orig_cleaned_cnt != 1)) {
-				enetc_xdp_drop(rx_ring, orig_i, i);
-				rx_ring->stats.xdp_redirect_sg++;
-				break;
-			}
-
 			err = xdp_do_redirect(rx_ring->ndev, &xdp_buff, prog);
 			if (unlikely(err)) {
 				enetc_xdp_drop(rx_ring, orig_i, i);
-- 
2.39.0

