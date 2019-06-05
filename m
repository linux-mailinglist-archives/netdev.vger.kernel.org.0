Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D5C3667F
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfFEVME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:12:04 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46964 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfFEVMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:12:03 -0400
Received: by mail-qt1-f193.google.com with SMTP id z19so183121qtz.13
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 14:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ald4YexKoj7e7jbz1K2HPsjJos1TJnoj/ojq23acBKs=;
        b=MdrBbTqclAb0VMYD5GYMmDVmbfsjHcglmuzSB/kQ8e+rFRk2OTYJjuP3GkDaPVOPKj
         HIzoNMqJTMIZXnzCob4IPyHQQwjbo0OhSqZo7xpoUABzohBdGWmoIjrX0cpPnoMKVb25
         kNXxdIhNI0G5zzqB++Epw64ZfyXjDl8xDz4/R3VPpQeHq15llA55X3kAFMEKplzpeKYf
         DXlqBSJ0CyvvAycOiXHBsQmF9UaUd240B7slNw2wWBO2iotUmNF8YCvF0FZVn09w1mzh
         7i3dZ2qDHnYVWF+HPWBwkybNLsJHA3dcVTlA507PguDsLCYgjKRwP//mfRIg65jAldno
         6mKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ald4YexKoj7e7jbz1K2HPsjJos1TJnoj/ojq23acBKs=;
        b=msQi4AxHVczSWw1CXeEu/nOj1Nw9yQb4mSqnTnj8X1gPuwDLhB7SZTcMYN0IixEYEt
         LMs9cfc3kXS7+Cg8KjBaOEp51lpipLl2JJfOOHQxskwNjKwyYsdANx162Jnb0QelZp6F
         +IbJzIgABlntvj8WO/FK95LVxckPcEx9XNR6DXuHVDWRResg+43WB3qjyWqphFusamUg
         ST3OqhepdVfvWbXresRT+rRfX9p+2qthaW/m6RiLxA1mFodusVIUDNK4ANgn96hKTL4a
         mP/ne1KsPT0ljCliLiX67gDnYw1GN80pRbNF4Rgck7M5BLHLT7N2RxAnIMSjvoZRul4q
         A3Hw==
X-Gm-Message-State: APjAAAV/c1GK+iUKc7rOC6xM3+9+M/l8b/i6mrmjaB/fVeSBxAozrp0X
        eCzKtKeC714fXvgloNFkG3ao9A==
X-Google-Smtp-Source: APXvYqxZ4PPsnK2Nkn95ncoOsbgsFstRGHE0Up9cOkXhboFYQ4s25HCcKkTwUQUlbNPxvlbFiFzsEw==
X-Received: by 2002:ac8:38d5:: with SMTP id g21mr36095572qtc.52.1559769122657;
        Wed, 05 Jun 2019 14:12:02 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t20sm2933807qtr.7.2019.06.05.14.12.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 14:12:02 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 01/13] nfp: count all failed TX attempts as errors
Date:   Wed,  5 Jun 2019 14:11:31 -0700
Message-Id: <20190605211143.29689-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605211143.29689-1-jakub.kicinski@netronome.com>
References: <20190605211143.29689-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently if we need to modify the head of the skb and allocation
fails we would free the skb and not increment the error counter.
Make sure all errors are counted.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index b82b684f52ce..0c163b086de5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -873,17 +873,14 @@ static int nfp_net_tx(struct sk_buff *skb, struct net_device *netdev)
 	}
 
 	md_bytes = nfp_net_prep_port_id(skb);
-	if (unlikely(md_bytes < 0)) {
-		nfp_net_tx_xmit_more_flush(tx_ring);
-		dev_kfree_skb_any(skb);
-		return NETDEV_TX_OK;
-	}
+	if (unlikely(md_bytes < 0))
+		goto err_flush;
 
 	/* Start with the head skbuf */
 	dma_addr = dma_map_single(dp->dev, skb->data, skb_headlen(skb),
 				  DMA_TO_DEVICE);
 	if (dma_mapping_error(dp->dev, dma_addr))
-		goto err_free;
+		goto err_dma_err;
 
 	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
 
@@ -979,8 +976,9 @@ static int nfp_net_tx(struct sk_buff *skb, struct net_device *netdev)
 	tx_ring->txbufs[wr_idx].skb = NULL;
 	tx_ring->txbufs[wr_idx].dma_addr = 0;
 	tx_ring->txbufs[wr_idx].fidx = -2;
-err_free:
+err_dma_err:
 	nn_dp_warn(dp, "Failed to map DMA TX buffer\n");
+err_flush:
 	nfp_net_tx_xmit_more_flush(tx_ring);
 	u64_stats_update_begin(&r_vec->tx_sync);
 	r_vec->tx_errors++;
-- 
2.21.0

