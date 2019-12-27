Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35A7912B0AB
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 03:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfL0CiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 21:38:14 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46130 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfL0CiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 21:38:13 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so24919248wrl.13
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 18:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Nz9deGkEs9iAxQ/m/RijBJ8QCVO4KRvfev/hgLVhvLI=;
        b=J6kLs5i/LLgznN5/zI9fUZaEcgboPcfp+PFEVsBiHJzZrhB78kPKBhN5CIBejONX3C
         c/mcVMf6WpfUJcUwzMXPttDFAmxNefpO+oYG8jk6JNfGf6145bgAb7A6CMRWpOSajmYv
         6owBtv5Sg9UPPMBAUJqy8pWrc5Un6isdRBBt331Aao7ouiXJ5mLOj1elLNcclffuIgc7
         LAyDL4XaVV5I10jVV92qRYLyzQSdxahHr7Fx0cp2cuf1UgL/HmzDTglvilndEkN5iXOJ
         mXAFbyktHqdPGDrCBFzwlwUug+pZ4HrfC2oTy35RlnV2XwFut7Ht7Df4tO2n0gWxeB50
         neyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Nz9deGkEs9iAxQ/m/RijBJ8QCVO4KRvfev/hgLVhvLI=;
        b=NBGs9qyhgls4PbI7M8sDobGJeAWq3ANWSBN0hvm/kCZXo+UiLdTRGrRPupPUxkk9C8
         pAZorqK6DZPFJPl1vfxqH+SW1SJ587XgtqlZvYpB0OYGl0jte2qotNVuCZNkaEHRMMSY
         lUNNklrlAk4XcJVHfk8vmEESCPiy+xTTeXt0bRYrLnQFayTaU7rCo8/R9E17jzZ2Fj0u
         8rpXttGSuMFT4id0wV3sJDqYHufR5/OjC52EBPhFb7jBxo4c4fwHrs27sxYr2FTGT1Tm
         fL/JFc9qU3WG3EyHWWxmPd32c8N544q53q5pr/xtWdlNdu8OeSDcFoq46hxq3ePkoHUO
         2psg==
X-Gm-Message-State: APjAAAViw4ILvVsZCrYT7eeFQSJ50gs+LJeRcBa+3vVd+oYOPGVLSixL
        H3eADlGHAPu0bIWqtaX5pXI=
X-Google-Smtp-Source: APXvYqw+PPhiwJT04cBgt/AGy/IisB+e9FdIODre7pdORlakbPHRLxTRWoF8xNtzjRE8FfNeRA1AQA==
X-Received: by 2002:adf:9144:: with SMTP id j62mr45724812wrj.168.1577414290816;
        Thu, 26 Dec 2019 18:38:10 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id k7sm9718714wmi.19.2019.12.26.18.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 18:38:10 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/3] net: dsa: sja1105: Use PTP core's dedicated kernel thread for RX timestamping
Date:   Fri, 27 Dec 2019 04:37:49 +0200
Message-Id: <20191227023750.12559-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227023750.12559-1-olteanv@gmail.com>
References: <20191227023750.12559-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And move the queue of skb's waiting for RX timestamps into the ptp_data
structure, since it isn't needed if PTP is not compiled.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c | 34 +++++++++++++--------------
 drivers/net/dsa/sja1105/sja1105_ptp.h |  1 +
 include/linux/dsa/sja1105.h           |  2 --
 3 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 038c83fbd9e8..d843c6395e52 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -83,6 +83,7 @@ static int sja1105_init_avb_params(struct sja1105_private *priv,
 static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 				      bool on)
 {
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 	struct sja1105_general_params_entry *general_params;
 	struct sja1105_table *table;
 	int rc;
@@ -367,22 +368,16 @@ static int sja1105_ptpclkval_write(struct sja1105_private *priv, u64 ticks,
 				ptp_sts);
 }
 
-#define rxtstamp_to_tagger(d) \
-	container_of((d), struct sja1105_tagger_data, rxtstamp_work)
-#define tagger_to_sja1105(d) \
-	container_of((d), struct sja1105_private, tagger_data)
-
-static void sja1105_rxtstamp_work(struct work_struct *work)
+static long sja1105_rxtstamp_work(struct ptp_clock_info *ptp)
 {
-	struct sja1105_tagger_data *tagger_data = rxtstamp_to_tagger(work);
-	struct sja1105_private *priv = tagger_to_sja1105(tagger_data);
-	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
+	struct sja1105_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct sja1105_private *priv = ptp_data_to_sja1105(ptp_data);
 	struct dsa_switch *ds = priv->ds;
 	struct sk_buff *skb;
 
 	mutex_lock(&ptp_data->lock);
 
-	while ((skb = skb_dequeue(&tagger_data->skb_rxtstamp_queue)) != NULL) {
+	while ((skb = skb_dequeue(&ptp_data->skb_rxtstamp_queue)) != NULL) {
 		struct skb_shared_hwtstamps *shwt = skb_hwtstamps(skb);
 		u64 ticks, ts;
 		int rc;
@@ -404,6 +399,9 @@ static void sja1105_rxtstamp_work(struct work_struct *work)
 	}
 
 	mutex_unlock(&ptp_data->lock);
+
+	/* Don't restart */
+	return -1;
 }
 
 /* Called from dsa_skb_defer_rx_timestamp */
@@ -411,16 +409,16 @@ bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
 			   struct sk_buff *skb, unsigned int type)
 {
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 
-	if (!test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
+	if (!test_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state))
 		return false;
 
 	/* We need to read the full PTP clock to reconstruct the Rx
 	 * timestamp. For that we need a sleepable context.
 	 */
-	skb_queue_tail(&tagger_data->skb_rxtstamp_queue, skb);
-	schedule_work(&tagger_data->rxtstamp_work);
+	skb_queue_tail(&ptp_data->skb_rxtstamp_queue, skb);
+	ptp_schedule_worker(ptp_data->clock, 0);
 	return true;
 }
 
@@ -628,11 +626,11 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 		.adjtime	= sja1105_ptp_adjtime,
 		.gettimex64	= sja1105_ptp_gettimex,
 		.settime64	= sja1105_ptp_settime,
+		.do_aux_work	= sja1105_rxtstamp_work,
 		.max_adj	= SJA1105_MAX_ADJ_PPB,
 	};
 
-	skb_queue_head_init(&tagger_data->skb_rxtstamp_queue);
-	INIT_WORK(&tagger_data->rxtstamp_work, sja1105_rxtstamp_work);
+	skb_queue_head_init(&ptp_data->skb_rxtstamp_queue);
 	spin_lock_init(&tagger_data->meta_lock);
 
 	ptp_data->clock = ptp_clock_register(&ptp_data->caps, ds->dev);
@@ -653,8 +651,8 @@ void sja1105_ptp_clock_unregister(struct dsa_switch *ds)
 	if (IS_ERR_OR_NULL(ptp_data->clock))
 		return;
 
-	cancel_work_sync(&priv->tagger_data.rxtstamp_work);
-	skb_queue_purge(&priv->tagger_data.skb_rxtstamp_queue);
+	ptp_cancel_worker_sync(ptp_data->clock);
+	skb_queue_purge(&ptp_data->skb_rxtstamp_queue);
 	ptp_clock_unregister(ptp_data->clock);
 	ptp_data->clock = NULL;
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 470f44b76318..6f4a19eec709 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -30,6 +30,7 @@ struct sja1105_ptp_cmd {
 };
 
 struct sja1105_ptp_data {
+	struct sk_buff_head skb_rxtstamp_queue;
 	struct ptp_clock_info caps;
 	struct ptp_clock *clock;
 	struct sja1105_ptp_cmd cmd;
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 897e799dbcb9..c0b6a603ea8c 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -37,8 +37,6 @@
  * the structure defined in struct sja1105_private.
  */
 struct sja1105_tagger_data {
-	struct sk_buff_head skb_rxtstamp_queue;
-	struct work_struct rxtstamp_work;
 	struct sk_buff *stampable_skb;
 	/* Protects concurrent access to the meta state machine
 	 * from taggers running on multiple ports on SMP systems
-- 
2.17.1

