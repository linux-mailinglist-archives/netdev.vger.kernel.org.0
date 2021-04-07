Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8551357867
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhDGXUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhDGXUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 19:20:30 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBC9C061764
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 16:20:19 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id nh5so117896pjb.5
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 16:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=unzw89ppabMkM4ijestM47VGkWVLzvnDd9OPBtJIspI=;
        b=ilENmXVAgs8ufGuIz9n04WwxLul8tOvFy+SS9FsklvixluEsn3ziNRb6Uf85139uon
         3ZDpfaKpDYRorejTIkSza2LuC0wqUsHCptwWCeWWyRzj80nKuqAHCOhWncdGpW4xWu4K
         q7KYRtjwp5pPtPCk9uuiLIL0fIdpCl4g+3XCegfRd2rgU6IPqyNpAk2HTwwLMuw1Z/04
         Faw9UXFstqYYF1ZMookmWY4/QcqP4WPbaqZsK/B3Gx9sU9NGZY9Tqs0nOf7IhesbQP3y
         dr4sQq+wrd2WKHMj4tw7nnQOit//Zv0O0rfelUweLo1h2X/k0HCzdV/JF+GxI6ROn7Ge
         kxGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=unzw89ppabMkM4ijestM47VGkWVLzvnDd9OPBtJIspI=;
        b=EIkMnxLJj7PKo8mU4cFZNsQ8hkE+1r3nUiZ7D1ldJ2CLEQnV2hmmBSUZy8Ex6eA8f5
         53b5gBRZxGEzdJJlvaiAs+SDrBQzODkkvCp1UvxbTq4Tzmw/p4fS9Oe1+a7EfYKB0OD4
         yvGwVQ0K5DOOx4nHgZsTn1dzwEp23Yflj/ITk+tR2m4My6qqkv16J2VND6LvVbr57tu3
         LPaWrd016XA4q+g8ozpmN7vUqR0Nb1a48q8O/9S+pA2IJEAxzelVP1G0uu73XVWg1v8p
         1+vi5hdoyJWMC9hncwc/M2oen+np0J27JVwkZO+t0DUZVG135tFdCzqBpmI7xXI61zHA
         XBiQ==
X-Gm-Message-State: AOAM530kJFPGy3MnhZ0HR6wO0C784UEdJsipzD97fpKnCfT/rapXsPXB
        mwT+xCLCNqEspJQM5rb15jUsRns7LXjlwA==
X-Google-Smtp-Source: ABdhPJykZf4WqP58tqDbbJMdazbewlymAnxYO5GKrshiIIfIuvOkP1FHl8cmy1PHa4+PKRaDoJEP9g==
X-Received: by 2002:a17:902:e84e:b029:e6:cbe6:34b5 with SMTP id t14-20020a170902e84eb02900e6cbe634b5mr5242089plg.42.1617837618859;
        Wed, 07 Apr 2021 16:20:18 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id g3sm21422171pfk.186.2021.04.07.16.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 16:20:18 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 7/8] ionic: add ts_config replay
Date:   Wed,  7 Apr 2021 16:20:00 -0700
Message-Id: <20210407232001.16670-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210407232001.16670-1-snelson@pensando.io>
References: <20210407232001.16670-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split the call into ionic_lif_hwstamp_set() to have two
separate interfaces, one from the ioctl() for changing the
configuration and one for replaying the current configuration
after a FW RESET.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  2 +-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  6 ++
 .../net/ethernet/pensando/ionic/ionic_phc.c   | 84 ++++++++++++-------
 3 files changed, 60 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index eae774c0a2d9..af3a5368529c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2993,7 +2993,7 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 	dev_info(ionic->dev, "FW Up: LIFs restarted\n");
 
 	/* restore the hardware timestamping queues */
-	ionic_lif_hwstamp_set(lif, NULL);
+	ionic_lif_hwstamp_replay(lif);
 
 	return;
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index ea3b086af179..346506f01715 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -302,6 +302,7 @@ int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 int ionic_lif_size(struct ionic *ionic);
 
 #if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
+int ionic_lif_hwstamp_replay(struct ionic_lif *lif);
 int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr);
 int ionic_lif_hwstamp_get(struct ionic_lif *lif, struct ifreq *ifr);
 ktime_t ionic_lif_phc_ktime(struct ionic_lif *lif, u64 counter);
@@ -310,6 +311,11 @@ void ionic_lif_unregister_phc(struct ionic_lif *lif);
 void ionic_lif_alloc_phc(struct ionic_lif *lif);
 void ionic_lif_free_phc(struct ionic_lif *lif);
 #else
+static inline int ionic_lif_hwstamp_replay(struct ionic_lif *lif)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
 {
 	return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
index 5d5da61284e7..2bb749097d9e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
@@ -64,10 +64,12 @@ static u64 ionic_hwstamp_rx_filt(int config_rx_filter)
 	}
 }
 
-int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
+static int ionic_lif_hwstamp_set_ts_config(struct ionic_lif *lif,
+					   struct hwtstamp_config *new_ts)
 {
 	struct ionic *ionic = lif->ionic;
-	struct hwtstamp_config config;
+	struct hwtstamp_config *config;
+	struct hwtstamp_config ts;
 	int tx_mode = 0;
 	u64 rx_filt = 0;
 	int err, err2;
@@ -77,18 +79,23 @@ int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
 	if (!lif->phc || !lif->phc->ptp)
 		return -EOPNOTSUPP;
 
-	if (ifr) {
-		if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
-			return -EFAULT;
+	if (new_ts) {
+		config = new_ts;
 	} else {
-		/* if called with ifr == NULL, behave as if called with the
-		 * current ts_config from the initial cleared state.
+		/* If called with new_ts == NULL, replay the previous request
+		 * primarily for recovery after a FW_RESET.
+		 * We saved the previous configuration request info, so copy
+		 * the previous request for reference, clear the current state
+		 * to match the device's reset state, and run with it.
 		 */
-		memcpy(&config, &lif->phc->ts_config, sizeof(config));
-		memset(&lif->phc->ts_config, 0, sizeof(config));
+		config = &ts;
+		memcpy(config, &lif->phc->ts_config, sizeof(*config));
+		memset(&lif->phc->ts_config, 0, sizeof(lif->phc->ts_config));
+		lif->phc->ts_config_tx_mode = 0;
+		lif->phc->ts_config_rx_filt = 0;
 	}
 
-	tx_mode = ionic_hwstamp_tx_mode(config.tx_type);
+	tx_mode = ionic_hwstamp_tx_mode(config->tx_type);
 	if (tx_mode < 0)
 		return tx_mode;
 
@@ -96,18 +103,18 @@ int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
 	if ((ionic->ident.lif.eth.hwstamp_tx_modes & mask) != mask)
 		return -ERANGE;
 
-	rx_filt = ionic_hwstamp_rx_filt(config.rx_filter);
-	rx_all = config.rx_filter != HWTSTAMP_FILTER_NONE && !rx_filt;
+	rx_filt = ionic_hwstamp_rx_filt(config->rx_filter);
+	rx_all = config->rx_filter != HWTSTAMP_FILTER_NONE && !rx_filt;
 
 	mask = cpu_to_le64(rx_filt);
 	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) != mask) {
 		rx_filt = 0;
 		rx_all = true;
-		config.rx_filter = HWTSTAMP_FILTER_ALL;
+		config->rx_filter = HWTSTAMP_FILTER_ALL;
 	}
 
 	dev_dbg(ionic->dev, "config_rx_filter %d rx_filt %#llx rx_all %d\n",
-		config.rx_filter, rx_filt, rx_all);
+		config->rx_filter, rx_filt, rx_all);
 
 	mutex_lock(&lif->phc->config_lock);
 
@@ -141,15 +148,7 @@ int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
 			goto err_rxall;
 	}
 
-	if (ifr) {
-		err = copy_to_user(ifr->ifr_data, &config, sizeof(config));
-		if (err) {
-			err = -EFAULT;
-			goto err_final;
-		}
-	}
-
-	memcpy(&lif->phc->ts_config, &config, sizeof(config));
+	memcpy(&lif->phc->ts_config, config, sizeof(*config));
 	lif->phc->ts_config_rx_filt = rx_filt;
 	lif->phc->ts_config_tx_mode = tx_mode;
 
@@ -157,14 +156,6 @@ int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
 
 	return 0;
 
-err_final:
-	if (rx_all != (lif->phc->ts_config.rx_filter == HWTSTAMP_FILTER_ALL)) {
-		rx_all = lif->phc->ts_config.rx_filter == HWTSTAMP_FILTER_ALL;
-		err2 = ionic_lif_config_hwstamp_rxq_all(lif, rx_all);
-		if (err2)
-			dev_err(ionic->dev,
-				"Failed to revert all-rxq timestamp config: %d\n", err2);
-	}
 err_rxall:
 	if (rx_filt != lif->phc->ts_config_rx_filt) {
 		rx_filt = lif->phc->ts_config_rx_filt;
@@ -188,6 +179,37 @@ int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
 	return err;
 }
 
+int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
+{
+	struct hwtstamp_config config;
+	int err;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	err = ionic_lif_hwstamp_set_ts_config(lif, &config);
+	if (err) {
+		netdev_info(lif->netdev, "hwstamp set failed: %d\n", err);
+		return err;
+	}
+
+	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
+		return -EFAULT;
+
+	return 0;
+}
+
+int ionic_lif_hwstamp_replay(struct ionic_lif *lif)
+{
+	int err;
+
+	err = ionic_lif_hwstamp_set_ts_config(lif, NULL);
+	if (err)
+		netdev_info(lif->netdev, "hwstamp replay failed: %d\n", err);
+
+	return err;
+}
+
 int ionic_lif_hwstamp_get(struct ionic_lif *lif, struct ifreq *ifr)
 {
 	struct hwtstamp_config config;
-- 
2.17.1

