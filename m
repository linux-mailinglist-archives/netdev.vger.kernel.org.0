Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722BF1EE9FF
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 20:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbgFDR7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 13:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730400AbgFDR7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 13:59:24 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5CBC08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 10:59:24 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n23so3791225pgb.12
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 10:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2qJ1KmR7n31K99rmmaGKTiex9LAFKCkmBxAmhTYhJxo=;
        b=O25wYAeOqYLKutlDyi60xIlbTuDdCOT5e2XYNOsNGhC4B+NaMg3VxpH/LIFlYcKegJ
         T2d7Nsibm7xBSN7jaERDrF77NKlRLBhUJZhYCNyaOF8giEp3RryXOHyVxA+KlQtlUkqU
         MR3J/581kbOBBRQlO36Kq+wpxgAQjeV+sg00s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2qJ1KmR7n31K99rmmaGKTiex9LAFKCkmBxAmhTYhJxo=;
        b=bg08psLifMtNZvh0zaFUXIaQtjrjDEcY+2Kg03bap6PLBMCbKdYOTr0WlWDSh1x8fZ
         UadNrhEdSWUPd2Pzc7FZDP2vfCWw5yZYdmBhguaaVuAkqpmzXOff3jgYp0ORhUn2zE17
         LMEMNEgtQNNBR2RBmTaYfJH/JkfhFWACYNBPliCCFTxL83hFEFA7N2eA1Uh+97dz7OjQ
         BunoS2QEx6yPOJEcXukuoHLUsPLzG+wZFMLmLqspV9vHvXFRNTU+lzClkgeUhfB78dZb
         Hf5Yj3YaCiY4s3IwUfZpsXdCHGqlohSkqu9nEbFMnUBWBLEEjLwhOG2/Cyzqv0m8iI5J
         HLdA==
X-Gm-Message-State: AOAM532T5gLB8D+N5nxfP6G17jgFvvakMinP5xNxaRijh02NLW6gt+S+
        GVL1x+QxKXVZPQdEFr3rqKY40A==
X-Google-Smtp-Source: ABdhPJy8aqjpj6isz3vL3kGOUE53Wgd2Jl+2f1JtJGfWBzh0MNQ1ovSw5R16ThJEKXvXpFgxlTMkiA==
X-Received: by 2002:a63:454c:: with SMTP id u12mr5625732pgk.153.1591293563926;
        Thu, 04 Jun 2020 10:59:23 -0700 (PDT)
Received: from evgreen-glaptop.cheshire.ch ([2601:646:c780:1404:1c5a:73fa:6d5a:5a3c])
        by smtp.gmail.com with ESMTPSA id q13sm2568927pfk.8.2020.06.04.10.59.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 04 Jun 2020 10:59:23 -0700 (PDT)
From:   Evan Green <evgreen@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     kuabhs@google.com.org, sujitka@chromium.org,
        Evan Green <evgreen@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Govind Singh <govinds@qti.qualcomm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kazior <michal.kazior@tieto.com>,
        ath10k@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] ath10k: Acquire tx_lock in tx error paths
Date:   Thu,  4 Jun 2020 10:59:11 -0700
Message-Id: <20200604105901.1.I5b8b0c7ee0d3e51a73248975a9da61401b8f3900@changeid>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ath10k_htt_tx_free_msdu_id() has a lockdep assertion that htt->tx_lock
is held. Acquire the lock in a couple of error paths when calling that
function to ensure this condition is met.

Fixes: 6421969f248fd ("ath10k: refactor tx pending management")
Fixes: e62ee5c381c59 ("ath10k: Add support for htt_data_tx_desc_64
descriptor")
Signed-off-by: Evan Green <evgreen@chromium.org>
---

 drivers/net/wireless/ath/ath10k/htt_tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index e9d12ea708b62..e8c00af2cce1d 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -1545,7 +1545,9 @@ static int ath10k_htt_tx_32(struct ath10k_htt *htt,
 err_unmap_msdu:
 	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 err_free_msdu_id:
+	spin_lock_bh(&htt->tx_lock);
 	ath10k_htt_tx_free_msdu_id(htt, msdu_id);
+	spin_unlock_bh(&htt->tx_lock);
 err:
 	return res;
 }
@@ -1752,7 +1754,9 @@ static int ath10k_htt_tx_64(struct ath10k_htt *htt,
 err_unmap_msdu:
 	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 err_free_msdu_id:
+	spin_lock_bh(&htt->tx_lock);
 	ath10k_htt_tx_free_msdu_id(htt, msdu_id);
+	spin_unlock_bh(&htt->tx_lock);
 err:
 	return res;
 }
-- 
2.24.1

