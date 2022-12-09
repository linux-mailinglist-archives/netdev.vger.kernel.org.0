Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070ED647AAA
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiLIAUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiLIAUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:20:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B594E424
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:20:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B34E2B826A7
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D582FC433EF;
        Fri,  9 Dec 2022 00:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670545202;
        bh=mihSmkJ+r3egOZKiL60k01bNG/r6ukddHKqX2WTn3xQ=;
        h=From:To:Cc:Subject:Date:From;
        b=byAHFGo7e4Cj6AvucXqOi0WnBuei75ya0dsz8HV3PYkPwCm9LjktlzcLsxjv2XPj0
         NYfDOpZQyvneKSUyuafmS1l5JOUbgtaGM1+FpzmKQUi0Y/f9Yjb+4f3v1vPVUZz+lc
         Co3fVQfE5jE8AfhYMHfd9RiB7lKP98QYC7mknioPHx3Z5yC6NUD+Pyu1mpAicOMFt4
         iBgThj67L41mrM4uqr7FIc4xsD0maqzIaP8+UZafUN51B04wrjJyaQgT+0xbymNw8+
         uxZw2fcH23dM49RlWx0HkCH7PCNl1QB6Bdcq5Oc7VrtYgk5J487vSqBjQbcI4Jch+H
         jPFeQqaGo6MOQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, vladimir.oltean@nxp.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next] net: ethernet: enetc: unlock XDP_REDIRECT for XDP non-linear buffers
Date:   Fri,  9 Dec 2022 01:19:44 +0100
Message-Id: <1dc514b266e19b1e5973d038a0189ab6e4acb93a.1670544817.git.lorenzo@kernel.org>
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

Even if full XDP_REDIRECT is not supported yet for non-linear XDP buffers
since we allow redirecting just into CPUMAPs, unlock XDP_REDIRECT for
S/G XDP buffer and rely on XDP stack to properly take care of the
frames.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- drop Fixes tag
- unlock XDP_REDIRECT
- populate missing XDP metadata

Please note this patch is just compile tested
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 27 +++++++++-----------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 8671591cb750..9fd15e1e692d 100644
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
@@ -1628,6 +1623,8 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 				enetc_xdp_free(rx_ring, tmp_orig_i, i);
 			} else {
 				xdp_redirect_frm_cnt++;
+				if (xdp_buff_has_frags(&xdp_buff))
+					rx_ring->stats.xdp_redirect_sg++;
 				rx_ring->stats.xdp_redirect++;
 			}
 		}
-- 
2.38.1

