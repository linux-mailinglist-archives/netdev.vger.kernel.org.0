Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D76FF5FE8E
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 01:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfGDXOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 19:14:38 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35123 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727642AbfGDXOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 19:14:37 -0400
Received: by mail-lj1-f193.google.com with SMTP id x25so687626ljh.2
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 16:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3MKWFq9DHUtTXp9RzrqM9cpDCCIlrZafhvrB3JiYBHI=;
        b=luSEBYWCfK2cKUnoHWoL56vfCR/h4ws0+NF0Fw4aCQ2ade4bm/G8dXaH+o4+SCePYb
         gm2fHnq+qTzUFXA5tV0g/itprk73XMOtK04bSrLlydGVaS7Z+zb67PGX5WWQlOs9B1tg
         pQRPlztmicp184qQ1hwaFgophdIMAi8b/Q97HSlL1Dg9+gI+iH/FW4tMD3fEFLVedOUI
         Incefd9h4l1bFUEUDeht6ktklb6K3fQeEmr1jHIUPfXxx90UzvLHWEJJYKd8lLQPjqTL
         RLv8c4HZY6QKeMoatYtCQ8t8JqnhFH7sIFtgBbWGSa59mJHOzg/b+bPiYLEUCJ/iQnvd
         HmOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3MKWFq9DHUtTXp9RzrqM9cpDCCIlrZafhvrB3JiYBHI=;
        b=au1YSMgOuYsJeQjkHj572q2ZfuhFjAmJz9Lku5ntcEH8pfPDJ9w4u5UYOFNF08h6pj
         gTGgLCrwpAIGy+07GAQpse6dQSmLCFRJ/5YdGb2TWndKi3ahJ9jTKp4jKIPhGNljTvdn
         NWkSf3VwGDZcYdSEG2GqcJUndFBKs0mF4suB7ZgRbK5Zub4NGaH8fZTfLk9wkAWXRtaq
         jm8ARc0I9dpZdUObUTW/lOtbQKGjz8wNhzuVizILUqHUXlmJg3s+7zvuv2whsrHBRA95
         qoZ7MAlhNO2ik8gWdiQQXfO/ThEnImDO9a9rmvN2MY06lHogOhdH+H5MTl9wE9W/32x/
         P2rA==
X-Gm-Message-State: APjAAAW5RTwYUMlo8l7el1VNIWgpMJpASYYVzfKEK6HkSuCxgv2I1DfG
        B0mXpIx6q1rliHUEd/Y7H4hkVg==
X-Google-Smtp-Source: APXvYqw/8aDIdeQNolMclOnv9CQMT+YD4hqSX5OlnZ71Cg6Ne1c1FBhpYx9pj5M5U03chjP52G7cIA==
X-Received: by 2002:a2e:994:: with SMTP id 142mr300201ljj.130.1562282074688;
        Thu, 04 Jul 2019 16:14:34 -0700 (PDT)
Received: from localhost.localdomain ([46.211.39.135])
        by smtp.gmail.com with ESMTPSA id q6sm1407269lji.70.2019.07.04.16.14.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 16:14:34 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v7 net-next 3/5] net: ethernet: ti: davinci_cpdma: allow desc split while down
Date:   Fri,  5 Jul 2019 02:14:04 +0300
Message-Id: <20190704231406.27083-4-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190704231406.27083-1-ivan.khoronzhuk@linaro.org>
References: <20190704231406.27083-1-ivan.khoronzhuk@linaro.org>
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

