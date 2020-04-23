Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCEA1B684A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 01:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgDWXOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 19:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728628AbgDWXNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 19:13:47 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE16C09B042;
        Thu, 23 Apr 2020 16:13:46 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id k13so8597460wrw.7;
        Thu, 23 Apr 2020 16:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9+tLQbU6rNyziVvImQingDwaJR2gEdQLKWLdpp3M4uw=;
        b=h6s1g6FsVkOnYNVUK0jCFCIai1dpCxoOwuZQEmdWFiI79i7obLds2NSsRmtUcIBafm
         pU1UOVCouOoTHwgKmzNtXyeedkXSPOQnaLct+2R4Rmszu8De5EhaR+cebxqI9Ge6A4nv
         eiSunmNNEGytSXCwMuYLdLdih2Qi6JFk+FKfK2GAx3jvoeyDiXgxHHO+UJNp9tQYNJIo
         EFIt6ibvaQgTHHBD1lRmkve2LyG3RcxPOLMY/RJeYraZFdKnYPmr0GfVuBp8dtOiKSRn
         TIpaS+2hkONaA4CEolsj//ldTJsjx2r6ZCgxUTB9keWDbAaxJdP1woVYLsmqFA9DZ1d+
         aLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9+tLQbU6rNyziVvImQingDwaJR2gEdQLKWLdpp3M4uw=;
        b=Kb1hUsqXcTlm+A/2fBap2r5jKU4uYgZKeWKSdTqZaSJXRd8ci0hFrOwdCcfZbvL+A5
         HmWuqz+DW5IYI8VmIo9k2JEIG9ErENa9uFTfr0TsudWtctDtZ7qHUUMGDzi/hweMuorS
         gDZAULOcOIhBzUzeqJo4U6HOwEpbEtYG2/rJN099SBieDip4Tx2fDLevNuC/819/Lh9b
         8MxC+XX641WLoC+Xb3L5Wix4V9FY5NB1ZKMxryEAMzwr4FStmIbwqP9kZHwNYNatfMtJ
         9iKgvQ6kEX42KSDDP7eTG9MTpzi5C1cm9FTKKDHZVyqGUHDQv0sKbjdNlyg9vwewYo5q
         5j3A==
X-Gm-Message-State: AGi0PuYiA1UDMlcAv21bn8PkQSmAd8yewtxEJ/oGnkOscbfpoEIIBu/q
        zTYXVhESTVQjHgDYaYPz7qHnrkcS
X-Google-Smtp-Source: APiQypLhovJKyzkshBe8hf/w0eNYa9nDr2KJcanPob1u6b3ohu2lVf1ziRQrKnbDOa79MLZijp7Exw==
X-Received: by 2002:adf:92c2:: with SMTP id 60mr7191793wrn.379.1587683625642;
        Thu, 23 Apr 2020 16:13:45 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s12sm382393wmc.7.2020.04.23.16.13.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 16:13:45 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next] net: systemport: suppress warnings on failed Rx SKB allocations
Date:   Thu, 23 Apr 2020 16:13:30 -0700
Message-Id: <1587683610-4342-1-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver is designed to drop Rx packets and reclaim the buffers
when an allocation fails, and the network interface needs to safely
handle this packet loss. Therefore, an allocation failure of Rx
SKBs is relatively benign.

However, the output of the warning message occurs with a high
scheduling priority that can cause excessive jitter/latency for
other high priority processing.

This commit suppresses the warning messages to prevent scheduling
problems while retaining the failure count in the statistics of
the network interface.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index af7ce5c5488c..ed12a0f894bf 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -664,7 +664,8 @@ static struct sk_buff *bcm_sysport_rx_refill(struct bcm_sysport_priv *priv,
 	dma_addr_t mapping;
 
 	/* Allocate a new SKB for a new packet */
-	skb = netdev_alloc_skb(priv->netdev, RX_BUF_LENGTH);
+	skb = __netdev_alloc_skb(priv->netdev, RX_BUF_LENGTH,
+				 GFP_ATOMIC | __GFP_NOWARN);
 	if (!skb) {
 		priv->mib.alloc_rx_buff_failed++;
 		netif_err(priv, rx_err, ndev, "SKB alloc failed\n");
-- 
2.7.4

