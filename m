Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C696065D4CB
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 14:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbjADN5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 08:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239374AbjADN5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 08:57:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EEB27B
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 05:57:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E6A0B81673
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 13:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3FCC4339C;
        Wed,  4 Jan 2023 13:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672840648;
        bh=7g/u2VMMIO9/7S3DkIGknPlGgh/bA7HKunZYs2JNXU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OVT1jxfPFpoptEiAGLYzQnpeFxMf65FAM3ekllS0WoB/bEqxaB8zU2HDEvIZoH4r/
         3euGkgbDS+orN+y5HqlMa++9JAADZoudNxiTgqmaIiybieuH7Pl3wXhJ5jLSA6QPfN
         NqHI74d6m94sW/54+jYZNN7KVfT5fIpcEXnCSmuV5LVLGJKpr71cYXD+1OzJfkZvXS
         +8jl50d0CP1ZwkgAWRdJ1Z6TiTjWqggr98mZEmuvcfMTKnfGqA1HVW9gU12IpSa6oi
         A1M1f5ucNBZ+NaoFwDGo1udrvQvHlugshaJrXAmP63+OVypIa4GNiTqtUcGf3MlJ9U
         E9FXLZAiCT9vg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com
Subject: [PATCH v2 net-next 1/3] net: ethernet: enetc: unlock XDP_REDIRECT for XDP non-linear buffers
Date:   Wed,  4 Jan 2023 14:57:10 +0100
Message-Id: <4aa99c4ef0e9929fff82d694baa9d79b7ab85986.1672840490.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1672840490.git.lorenzo@kernel.org>
References: <cover.1672840490.git.lorenzo@kernel.org>
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

