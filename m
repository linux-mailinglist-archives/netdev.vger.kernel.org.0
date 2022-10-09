Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE205F9259
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbiJIWsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbiJIWqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:46:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5E24456A;
        Sun,  9 Oct 2022 15:23:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02F46B80DE3;
        Sun,  9 Oct 2022 22:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7211CC433D6;
        Sun,  9 Oct 2022 22:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354160;
        bh=XiV1yhcURTqPLmoZcX5KUzmWfOZN2WAvBvCSNKE+L3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHf943wezLyN82i58mnD1AKGlQqLw1utTAAmadX72fj0EOMri0uPFXgahEIMkJQGX
         toeaBpPntcv9OLwUu5ZP2xZ2XKNfdcpDzJZEyPx5WYWlCsItKKz5mO3qiJklDQa7F/
         j02Bqw7In/e2cFAxa7AmTfGujzEIFreVcwKzDRIYy6/0CQ6QoIEtuqXUpBtpysdoor
         m+Yr1OfEqL9ERIAfTPOcljw1gCeLNh7W6XThhut6ulKxmjKZgPZ1XKEwz3k0t3ohaU
         H227bK228MR2gkK+pydacXgk8Pz0dVG457ovgLuJBgrrmE1u6rTpUDICce/7i8MDJF
         UslB5KUTHsahQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Gong <quic_wgong@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 24/34] wifi: ath10k: reset pointer after memory free to avoid potential use-after-free
Date:   Sun,  9 Oct 2022 18:21:18 -0400
Message-Id: <20221009222129.1218277-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222129.1218277-1-sashal@kernel.org>
References: <20221009222129.1218277-1-sashal@kernel.org>
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
index 28ec3c5b4d1f..1b34f12b7eca 100644
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

