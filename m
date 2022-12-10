Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B27648EF7
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 14:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiLJNxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 08:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiLJNxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 08:53:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5CA13EA3
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 05:53:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE4F560C01
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 13:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB82EC433D2;
        Sat, 10 Dec 2022 13:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670680422;
        bh=mpdGakfRPcbqDUyFyzefmi7AzdYG54Xi4qvjir3KvgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5uPlrVIAoDGSBjwmrVcKPph2cqx/Pbj4+Umz37WpD3os9gp6LOzMfVY1d+R5vz27
         TFTY59bOEfAobkLI6UyagGW7QPUze7JK8cjIqyGC2MRnht/dr31j46MN+c0iFdUHtT
         Kwcyq1FJrBLdLicqG51krYNlc6oO6I8PEfXhrfwWf091wjvOoYQFYj6BfxNeO52AHL
         fj9/aAYW+uqJ4EwDp7XflrD9Earq09ngkdZMBixRUrkAzTCj3/X9Vqf9yzEfpS/uM4
         4XMYWp/CUadL4qCWPT1GCcZPDwzf8WQ6hqHySHCLgxpTDmZekk/Wu3/9q6wqFtNOY1
         qMZ9ppXiudYJQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, vladimir.oltean@nxp.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v3 net-next 1/2] net: ethernet: enetc: unlock XDP_REDIRECT for XDP non-linear buffers
Date:   Sat, 10 Dec 2022 14:53:10 +0100
Message-Id: <18fe33e35b49d4b265d75489331f5c817489a26e.1670680119.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670680119.git.lorenzo@kernel.org>
References: <cover.1670680119.git.lorenzo@kernel.org>
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

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 25 ++++++++------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 8671591cb750..cd8f5f0c6b54 100644
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
@@ -1601,22 +1611,7 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
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
 			tmp_orig_i = orig_i;
-
 			while (orig_i != i) {
 				enetc_flip_rx_buff(rx_ring,
 						   &rx_ring->rx_swbd[orig_i]);
-- 
2.38.1

