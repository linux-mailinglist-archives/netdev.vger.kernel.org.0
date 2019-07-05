Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC8BC608B1
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfGEPF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:05:29 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36008 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfGEPFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:05:11 -0400
Received: by mail-lj1-f196.google.com with SMTP id i21so9591486ljj.3
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 08:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3MKWFq9DHUtTXp9RzrqM9cpDCCIlrZafhvrB3JiYBHI=;
        b=xyvsBDpHC1EZ2dWvSDA7okDtJU8c+RYRWvLbfE6yTRUaRRPTeMx4naijBhc1gORYBB
         fqdWq7A4JFUU/wg6qPHgari2TlXnujB97hM6gGjY9uRNSnKE3DASyEnY+PcghuM4LxeS
         uxg3pFkhfafUBbPn9ybRasj+SKZpSafJKQtuprX2VQe5LNP2FoBNFBSB72e53SCevH54
         o1YOQlp++pyanvB+mbRD9wbCSAs8T59Q2MOM0g0b7uSPxVgzGTQPtbMSEAEwteBb84Ke
         TjQE87Vma0iBWrx672Jg9bHwyDPLi4EiuZX6A7snuUiaOOACOncLlzvSB3BYPwgz7CEn
         bfmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3MKWFq9DHUtTXp9RzrqM9cpDCCIlrZafhvrB3JiYBHI=;
        b=DgASaLjftMD1lVhQMrsy8OcwHT8892uHMdUHybUdy+q8Nc2INePIW5PXwG87iDf+pS
         MKEXJr/LgMHKCSBsfVvf/LPUYaXw+Zh1vG+bNIBNrnNoFIbipiS7GxNwsuWbo9YOOxcJ
         Y2wmkR59AjUHwJEA+WMJVIgWEe7JdkUFaRJSnRxLjJ0l6W+qq9jzAwYHzQ/U3DBp2Mqf
         StlkecUP62sbSEgFh7jYOqrNTuXpPVh72cvriFCvjWX8fs6Kw1sEFbHvYDoCSnvmhUFz
         YwnwDvnttvXOueA0AJ/kWo34fdl9wPCiA6k71Qk8NvM4W6fXRplPWpbCUINfCccJlhLy
         AijQ==
X-Gm-Message-State: APjAAAUlzi0en6QU37ldWk4eZlfNTeJOmgEJ09vZz+NLy4wR4KPt/29h
        moAALqnzEGeyJ0CAmBFcievq+w==
X-Google-Smtp-Source: APXvYqzuXhHx+bwkjyadsYI9HwpVyfw9wCKVazqQ4H58bNzZlrBLVZeaaI9HSQm3LGj+FhwVLRLCaQ==
X-Received: by 2002:a2e:5c09:: with SMTP id q9mr2499358ljb.120.1562339109281;
        Fri, 05 Jul 2019 08:05:09 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id y4sm1433660lfc.56.2019.07.05.08.05.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 08:05:08 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v8 net-next 3/5] net: ethernet: ti: davinci_cpdma: allow desc split while down
Date:   Fri,  5 Jul 2019 18:05:00 +0300
Message-Id: <20190705150502.6600-4-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190705150502.6600-1-ivan.khoronzhuk@linaro.org>
References: <20190705150502.6600-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That's possible to set ring params while interfaces are down. When
interface gets up it uses number of descs to fill rx queue and on
later on changes to create rx pools. Usually, this resplit can happen
after phy is up, but it can be needed before this, so allow it to
happen while setting number of rx descs, when interfaces are down.
Also, if no dependency on intf state, move it to cpdma layer, where
it should be.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/net/ethernet/ti/cpsw_ethtool.c  | 17 +++++++++++------
 drivers/net/ethernet/ti/davinci_cpdma.c | 17 ++++++++++++++++-
 drivers/net/ethernet/ti/davinci_cpdma.h |  3 +--
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index f60dc1dfc443..c477e6b620d6 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -650,7 +650,7 @@ int cpsw_set_ringparam(struct net_device *ndev,
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	struct cpsw_common *cpsw = priv->cpsw;
-	int ret;
+	int descs_num, ret;
 
 	/* ignore ering->tx_pending - only rx_pending adjustment is supported */
 
@@ -659,20 +659,25 @@ int cpsw_set_ringparam(struct net_device *ndev,
 	    ering->rx_pending > (cpsw->descs_pool_size - CPSW_MAX_QUEUES))
 		return -EINVAL;
 
-	if (ering->rx_pending == cpdma_get_num_rx_descs(cpsw->dma))
+	descs_num = cpdma_get_num_rx_descs(cpsw->dma);
+	if (ering->rx_pending == descs_num)
 		return 0;
 
 	cpsw_suspend_data_pass(ndev);
 
-	cpdma_set_num_rx_descs(cpsw->dma, ering->rx_pending);
+	ret = cpdma_set_num_rx_descs(cpsw->dma, ering->rx_pending);
+	if (ret) {
+		if (cpsw_resume_data_pass(ndev))
+			goto err;
 
-	if (cpsw->usage_count)
-		cpdma_chan_split_pool(cpsw->dma);
+		return ret;
+	}
 
 	ret = cpsw_resume_data_pass(ndev);
 	if (!ret)
 		return 0;
-
+err:
+	cpdma_set_num_rx_descs(cpsw->dma, descs_num);
 	dev_err(cpsw->dev, "cannot set ring params, closing device\n");
 	dev_close(ndev);
 	return ret;
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index 8da46394c0e7..a3b6aeb4e935 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -1423,8 +1423,23 @@ int cpdma_get_num_tx_descs(struct cpdma_ctlr *ctlr)
 	return ctlr->num_tx_desc;
 }
 
-void cpdma_set_num_rx_descs(struct cpdma_ctlr *ctlr, int num_rx_desc)
+int cpdma_set_num_rx_descs(struct cpdma_ctlr *ctlr, int num_rx_desc)
 {
+	unsigned long flags;
+	int temp, ret;
+
+	spin_lock_irqsave(&ctlr->lock, flags);
+
+	temp = ctlr->num_rx_desc;
 	ctlr->num_rx_desc = num_rx_desc;
 	ctlr->num_tx_desc = ctlr->pool->num_desc - ctlr->num_rx_desc;
+	ret = cpdma_chan_split_pool(ctlr);
+	if (ret) {
+		ctlr->num_rx_desc = temp;
+		ctlr->num_tx_desc = ctlr->pool->num_desc - ctlr->num_rx_desc;
+	}
+
+	spin_unlock_irqrestore(&ctlr->lock, flags);
+
+	return ret;
 }
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.h b/drivers/net/ethernet/ti/davinci_cpdma.h
index 0271a20c2e09..d3cfe234d16a 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.h
+++ b/drivers/net/ethernet/ti/davinci_cpdma.h
@@ -116,8 +116,7 @@ enum cpdma_control {
 int cpdma_control_get(struct cpdma_ctlr *ctlr, int control);
 int cpdma_control_set(struct cpdma_ctlr *ctlr, int control, int value);
 int cpdma_get_num_rx_descs(struct cpdma_ctlr *ctlr);
-void cpdma_set_num_rx_descs(struct cpdma_ctlr *ctlr, int num_rx_desc);
+int cpdma_set_num_rx_descs(struct cpdma_ctlr *ctlr, int num_rx_desc);
 int cpdma_get_num_tx_descs(struct cpdma_ctlr *ctlr);
-int cpdma_chan_split_pool(struct cpdma_ctlr *ctlr);
 
 #endif
-- 
2.17.1

