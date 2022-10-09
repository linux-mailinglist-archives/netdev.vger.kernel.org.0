Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3354C5F93A1
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 01:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbiJIXle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 19:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiJIXlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 19:41:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375DC9C2D0;
        Sun,  9 Oct 2022 16:13:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59E02B80D33;
        Sun,  9 Oct 2022 22:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BA2C43144;
        Sun,  9 Oct 2022 22:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354242;
        bh=cBNw3HRI8ZxmonBa0pb7XC5xRZOkCci7V2ECYh4VxEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOyWM+koEoO4iR4SCfEH7Zt9GGImIVphvOx6v51UKPhGjXWG6BVGTvkFQ5suD/M+L
         QIlwRqx9N2Q6bmGYQmuoSaUnIwKIkUDwhs/16nccJGtl8oW0i2pmlxCJdrrcFimUtN
         VehFuVjHPji75JNDktWxj3Hn/jkom29YluaAbKa1E6jI1LkvBcc+D95ld2Eby9dV/Y
         pABTm1rtviJwcyeR9Wuxi70POCTScnAYkI4HPvIfgWg+PhWfxCoCFwNROILTqaHQXj
         +jPjJpDD9SeoRLva89RQ1r8nRpPIVlFJRYQ/Tjtw8pwKHvYt0clQ1vlyI6BKdvHHDg
         X1zf4P5B4Ji1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Gong <quic_wgong@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/29] wifi: ath10k: reset pointer after memory free to avoid potential use-after-free
Date:   Sun,  9 Oct 2022 18:22:54 -0400
Message-Id: <20221009222304.1218873-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222304.1218873-1-sashal@kernel.org>
References: <20221009222304.1218873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Gong <quic_wgong@quicinc.com>

[ Upstream commit 1e1cb8e0b73e6f39a9d4a7a15d940b1265387eb5 ]

When running suspend test, kernel crash happened in ath10k, and it is
fixed by commit b72a4aff947b ("ath10k: skip ath10k_halt during suspend
for driver state RESTARTING").

Currently the crash is fixed, but as a common code style, it is better
to set the pointer to NULL after memory is free.

This is to address the code style and it will avoid potential bug of
use-after-free.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00110-QCARMSWP-1
Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220505092248.787-1-quic_wgong@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 760d24a28f39..f6fdb18f0950 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -297,12 +297,16 @@ void ath10k_htt_rx_free(struct ath10k_htt *htt)
 			  ath10k_htt_get_vaddr_ring(htt),
 			  htt->rx_ring.base_paddr);
 
+	ath10k_htt_config_paddrs_ring(htt, NULL);
+
 	dma_free_coherent(htt->ar->dev,
 			  sizeof(*htt->rx_ring.alloc_idx.vaddr),
 			  htt->rx_ring.alloc_idx.vaddr,
 			  htt->rx_ring.alloc_idx.paddr);
+	htt->rx_ring.alloc_idx.vaddr = NULL;
 
 	kfree(htt->rx_ring.netbufs_ring);
+	htt->rx_ring.netbufs_ring = NULL;
 }
 
 static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
@@ -823,8 +827,10 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 			  ath10k_htt_get_rx_ring_size(htt),
 			  vaddr_ring,
 			  htt->rx_ring.base_paddr);
+	ath10k_htt_config_paddrs_ring(htt, NULL);
 err_dma_ring:
 	kfree(htt->rx_ring.netbufs_ring);
+	htt->rx_ring.netbufs_ring = NULL;
 err_netbuf:
 	return -ENOMEM;
 }
-- 
2.35.1

