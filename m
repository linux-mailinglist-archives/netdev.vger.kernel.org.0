Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3B7678C93
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 01:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbjAXAJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 19:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjAXAJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 19:09:21 -0500
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2412622A3D
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 16:09:20 -0800 (PST)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 2FD3F505270;
        Tue, 24 Jan 2023 03:03:54 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 2FD3F505270
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1674518640; bh=vVOUi3qU9K9jb7jjjJQImkSem0OpijgEiIhlUsJCQ4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMDgcXfvbvwchPovoRdu+0dEBkkWBzzBKqHsi0Su+ApAf+4P+NO5WMecu0aNbr07x
         2CY7cVBwmMq7bj+2seaBZ1Y6LkA2asZvV/9ZOPEP6wnmmpRcrsHtOCTDRQk2FjHv5W
         pHex1oCQdUjCqpYwStxTX2euaSwgU68zAqeJLa54=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Gal Pressman <gal@nvidia.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>, netdev@vger.kernel.org
Subject: [PATCH net v2 2/2] mlx5: fix skb leak while fifo resync
Date:   Tue, 24 Jan 2023 03:08:36 +0300
Message-Id: <20230124000836.20523-3-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230124000836.20523-1-vfedorenko@novek.ru>
References: <20230124000836.20523-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@meta.com>

During ptp resync operation SKBs were poped from the fifo but were never
freed neither by napi_consume nor by dev_kfree_skb_any. Add call to
napi_consume_skb to properly free SKBs.

Fixes: 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port timestamp")
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 32d6b387af61..2797028608a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -102,6 +102,7 @@ static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_
 		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
 		skb_tstamp_tx(skb, &hwts);
 		ptpsq->cq_stats->resync_cqe++;
+		napi_consume_skb(skb, 1);
 		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
 	}
 
-- 
2.27.0

