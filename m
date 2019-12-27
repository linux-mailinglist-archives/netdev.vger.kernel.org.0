Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E7212B4B8
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 14:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfL0NCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 08:02:42 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54683 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfL0NCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 08:02:40 -0500
Received: by mail-wm1-f67.google.com with SMTP id b19so7999962wmj.4
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 05:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=On7f7J2Rv/34/FOIRf5Nqjk7nvzsZXj/gSsurxXFGFo=;
        b=X6LezYRnx4xMZ9bz78/Tg0KXrze3778gmZBtThJT/rFBPiVVO83LjnqEANx0lzKkxy
         QeeB01CEgQEqczo51taW0VjydTquPom3hZz/+2P4u1xr7niXtJsy0NdlvXU+kZdOXTgC
         Y8yoigtaH0CA11rDUygyFpxSPjPDAREMwSvHV4wrqTqhpFSMFtR3J5Bl1etFjc28Ukr0
         lkgaF3yYn3D+n3cgPra+8q3DjwpLisG4NvTQ0fVtkLcYaTa3rO2bbzQ5NFJ/dFE0QZ58
         ZSpzZfvLB6c3JD54VLCc/pvfqGRHRDCBD/Vmb0XM8xaPZUf0CqElyaGMNCi26NEePyL3
         4VVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=On7f7J2Rv/34/FOIRf5Nqjk7nvzsZXj/gSsurxXFGFo=;
        b=Fr7kpK7aksxhZAZqR6GlT/Lu3pGxMPfot3pJXCrk0rn4Leui7PPigozWzUhvc0kp/F
         6YI4iwCFSzdAX0AAGMp6c6KwymQY6EE38yTEIHpEd/9QFWGlvG/PvArzX9LCsuA6qhdQ
         fLU5BarfeoMUVnbEIAWT7SkCfiIfYn4rWEXXXqySzL632C+a/AQ3ikOZcfgKiT9c0q7n
         IoBo73IKTcyAcoFDnyAU8E/MSJDXqM5YqvpAGBNv8cJ6B3xEoNq4CQnOKAFruAdzbX/C
         2YLpDEJEmDLEFSqLNBW5jCi8uYZ/BV5tkzpL1iL0lBZHuzxAnSRbJVOqLwWa/gimsTQC
         Rprg==
X-Gm-Message-State: APjAAAXx8xWk2MB+jbub+goXhyU+FP6dJcT1P7n2v1DYHiCdWqUDZFdD
        zU9EH60UKoM/x/MOZJIyHA8=
X-Google-Smtp-Source: APXvYqwi5LvAse406g8b/3LwoNSYeoiqO+gT9sRZFs1oN5El8JslWSjmwaFBDEldenIqdNQUBGRmlA==
X-Received: by 2002:a1c:e289:: with SMTP id z131mr18242753wmg.18.1577451758972;
        Fri, 27 Dec 2019 05:02:38 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id i5sm34307357wrv.34.2019.12.27.05.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 05:02:38 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 2/3] net: dsa: sja1105: Use PTP core's dedicated kernel thread for RX timestamping
Date:   Fri, 27 Dec 2019 15:02:29 +0200
Message-Id: <20191227130230.21541-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227130230.21541-1-olteanv@gmail.com>
References: <20191227130230.21541-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And move the queue of skb's waiting for RX timestamps into the ptp_data
structure, since it isn't needed if PTP is not compiled.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
- Moved "struct sja1105_ptp_data *ptp_data" declaration in
  sja1105_change_rxtstamping to patch 3/3.

 drivers/net/dsa/sja1105/sja1105_ptp.c | 33 ++++++++++++---------------
 drivers/net/dsa/sja1105/sja1105_ptp.h |  1 +
 include/linux/dsa/sja1105.h           |  2 --
 3 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 038c83fbd9e8..93683cbf2062 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -367,22 +367,16 @@ static int sja1105_ptpclkval_write(struct sja1105_private *priv, u64 ticks,
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
@@ -404,6 +398,9 @@ static void sja1105_rxtstamp_work(struct work_struct *work)
 	}
 
 	mutex_unlock(&ptp_data->lock);
+
+	/* Don't restart */
+	return -1;
 }
 
 /* Called from dsa_skb_defer_rx_timestamp */
@@ -411,16 +408,16 @@ bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
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
 
@@ -628,11 +625,11 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
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
@@ -653,8 +650,8 @@ void sja1105_ptp_clock_unregister(struct dsa_switch *ds)
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

