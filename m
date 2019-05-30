Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCF4301CB
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfE3SVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:21:31 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37147 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfE3SU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:20:56 -0400
Received: by mail-lj1-f193.google.com with SMTP id h19so7014658ljj.4
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 11:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7Z+hJ2xpe6chUPepscBLPDGl6ohx6IXf3hvf84qy8k8=;
        b=uhOmPRjvEPSqocDDlrLrJvOMrG4BmMTmoKHMBhVYAOxkMPgQwKo8MLA+oUcoZpnE73
         dmiFzXl+QuZrAp0Lgucvbbs/79sKAtpwEPKLe+oVyi9gpnJmlqdmQWFthozqsJ7vAlib
         O5ziXaNoSYxVerDq2kopFdPMRnnstnvVV+oXSSGa8KaD2zcWoIZqMQTCOKKkN2oZxBYH
         QXagZkmO/GrHY+9MvwRB2j/wtFTdc9VllDwFrNei7AQgikvYzJ4CyR3Aqnd1qkd/6ahV
         PUicArdA8GgZMhQv7A5UXBQJCzMMl0d5wd3whOjnjuW8jmjn5lApMHzCIAyDszBD+YcR
         T0hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7Z+hJ2xpe6chUPepscBLPDGl6ohx6IXf3hvf84qy8k8=;
        b=il7DmXZDOmFp8bqy47SWGZIoBgcaN8GK7RylNMMUCfGtXBkBz1qQ0/bWM1TAnxy1fz
         KpvSJgZ1ZuPys5s3s44tmKTbbXQzyUY9aSoMzxudIqyVfgGXSHT63spMTqZ0tpZCH7cY
         s5GbuIpoyNZhFqVCOqMnFRwPs2E56n4EhRPHi2zDjY20snKIKnixvkeHuIzxbugRu0y/
         VOTOMAGZZxLDZ4UBmPK+/8SG/750PKNvWOkU2VNFvK4qBmXXhtTvV620xq//MDBp3+iK
         BX/jNpEhPqct77Eb93LeJAIkewAFDXB0LVhbUGlRJhNboGREhF1np6h+wo+UniIrwmk2
         Iw2g==
X-Gm-Message-State: APjAAAXKKv8aLgbUBNcrCwTm9G1TwvKL+TE8CLiXLCNAx4bWEGb4bp/K
        R0xuNG4CaHF8bS7ZML93y6Y8RQ==
X-Google-Smtp-Source: APXvYqwqZIOoXCsEeTno321JHOUaxvSb9pUFwirU22e1UX6ErOyOq9neJwpkmyIFY2XvP7TweKdhLw==
X-Received: by 2002:a05:651c:93:: with SMTP id 19mr2944496ljq.213.1559240455046;
        Thu, 30 May 2019 11:20:55 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id v7sm388946lfe.11.2019.05.30.11.20.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 11:20:54 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v2 net-next 4/7] net: ethernet: ti: cpsw_ethtool: simplify slave loops
Date:   Thu, 30 May 2019 21:20:36 +0300
Message-Id: <20190530182039.4945-5-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
References: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only for consistency reasons, do it like in main cpsw.c module
and use ndev reference but not by means of slave.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/net/ethernet/ti/cpsw_ethtool.c | 40 ++++++++++++++------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index a4a7ec0d2531..c260bb32aacf 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -458,7 +458,6 @@ int cpsw_nway_reset(struct net_device *ndev)
 static void cpsw_suspend_data_pass(struct net_device *ndev)
 {
 	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
-	struct cpsw_slave *slave;
 	int i;
 
 	/* Disable NAPI scheduling */
@@ -467,12 +466,13 @@ static void cpsw_suspend_data_pass(struct net_device *ndev)
 	/* Stop all transmit queues for every network device.
 	 * Disable re-using rx descriptors with dormant_on.
 	 */
-	for (i = cpsw->data.slaves, slave = cpsw->slaves; i; i--, slave++) {
-		if (!(slave->ndev && netif_running(slave->ndev)))
+	for (i = 0; i < cpsw->data.slaves; i++) {
+		ndev = cpsw->slaves[i].ndev;
+		if (!(ndev && netif_running(ndev)))
 			continue;
 
-		netif_tx_stop_all_queues(slave->ndev);
-		netif_dormant_on(slave->ndev);
+		netif_tx_stop_all_queues(ndev);
+		netif_dormant_on(ndev);
 	}
 
 	/* Handle rest of tx packets and stop cpdma channels */
@@ -483,13 +483,14 @@ static int cpsw_resume_data_pass(struct net_device *ndev)
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	struct cpsw_common *cpsw = priv->cpsw;
-	struct cpsw_slave *slave;
 	int i, ret;
 
 	/* Allow rx packets handling */
-	for (i = cpsw->data.slaves, slave = cpsw->slaves; i; i--, slave++)
-		if (slave->ndev && netif_running(slave->ndev))
-			netif_dormant_off(slave->ndev);
+	for (i = 0; i < cpsw->data.slaves; i++) {
+		ndev = cpsw->slaves[i].ndev;
+		if (ndev && netif_running(ndev))
+			netif_dormant_off(ndev);
+	}
 
 	/* After this receive is started */
 	if (cpsw->usage_count) {
@@ -502,9 +503,11 @@ static int cpsw_resume_data_pass(struct net_device *ndev)
 	}
 
 	/* Resume transmit for every affected interface */
-	for (i = cpsw->data.slaves, slave = cpsw->slaves; i; i--, slave++)
-		if (slave->ndev && netif_running(slave->ndev))
-			netif_tx_start_all_queues(slave->ndev);
+	for (i = 0; i < cpsw->data.slaves; i++) {
+		ndev = cpsw->slaves[i].ndev;
+		if (ndev && netif_running(ndev))
+			netif_tx_start_all_queues(ndev);
+	}
 
 	return 0;
 }
@@ -587,7 +590,6 @@ int cpsw_set_channels_common(struct net_device *ndev,
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	struct cpsw_common *cpsw = priv->cpsw;
-	struct cpsw_slave *slave;
 	int i, ret;
 
 	ret = cpsw_check_ch_settings(cpsw, chs);
@@ -604,20 +606,20 @@ int cpsw_set_channels_common(struct net_device *ndev,
 	if (ret)
 		goto err;
 
-	for (i = cpsw->data.slaves, slave = cpsw->slaves; i; i--, slave++) {
-		if (!(slave->ndev && netif_running(slave->ndev)))
+	for (i = 0; i < cpsw->data.slaves; i++) {
+		struct net_device *ndev = cpsw->slaves[i].ndev;
+
+		if (!(ndev && netif_running(ndev)))
 			continue;
 
 		/* Inform stack about new count of queues */
-		ret = netif_set_real_num_tx_queues(slave->ndev,
-						   cpsw->tx_ch_num);
+		ret = netif_set_real_num_tx_queues(ndev, cpsw->tx_ch_num);
 		if (ret) {
 			dev_err(priv->dev, "cannot set real number of tx queues\n");
 			goto err;
 		}
 
-		ret = netif_set_real_num_rx_queues(slave->ndev,
-						   cpsw->rx_ch_num);
+		ret = netif_set_real_num_rx_queues(ndev, cpsw->rx_ch_num);
 		if (ret) {
 			dev_err(priv->dev, "cannot set real number of rx queues\n");
 			goto err;
-- 
2.17.1

