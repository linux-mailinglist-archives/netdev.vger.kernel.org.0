Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BC6357868
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhDGXUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhDGXUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 19:20:32 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B65C061765
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 16:20:20 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id p12so10175812pgj.10
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 16:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z5hTopG5DmQqhFIVp/3vpNpYzkhvWRurh+BVp+YoELI=;
        b=nYSmfM7g3wI5dEUls3t/qQHMIz1trYtpPshT2vxXGSr7PVsOtFLhmZFiMCRgiXV6ct
         b9QttrW6uVS++Tzn42ytC3IDq7gA/cDJ17muzS3R+dkipJQFedv61wry8MOczejT+Xvp
         EMNHXyTr/duexNptznrd513y92z8JzZJzXzyDvu8GTSAJja6KbYuSxufesRrYPJHAHcc
         1o9GE5O2NVclh5aaVxBRtqKERrmzRWeNPLLQsHtB76uIc4ISib4Z/uIuYNtOjQL13nyk
         mdw8opgHgSS22C0NjzwXCyjihNxEEwn9Zo+l9BJP9+ZrrYCM1IAyQiyEoFmi1ykNWEeE
         JPWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Z5hTopG5DmQqhFIVp/3vpNpYzkhvWRurh+BVp+YoELI=;
        b=T/8R82XHDqCYCRXH4ULWjgEG5WltoR85mIuDz2cTu99Ogef6PrAgZ30E1qUZtEX3k2
         T9ZhPhVLNSz8ov/pALE3DHccPfrFref8rIq6x4+ssd0ti0AGV3o8XAbluqmYjUvv78XZ
         JtjpDH2pA31V9r2ykfecdpBMrwcdeICCMtLYHP9jY6UdYasjYQb0O5rwAF+uv09cMuiJ
         Rh5gdqj+oSklFxFnCbGwJSff73KitjehM4PbYnTO2tTKwdkCVVpxwFIuc06gtyNcCcox
         Qx+UJmaDfeK22krfmrcCYOOfpMcykQyCff2t32phRT16c6UkJc3PhxTHRE1zzCu2F4nQ
         HZlA==
X-Gm-Message-State: AOAM532g7v3pecKFrt1bPBGQBvVfbSdEZA2Fljjeak36WglY07XiIqVl
        mbY+ruBu7NQOsZGQzDP7ZfIWCyvijmJkOg==
X-Google-Smtp-Source: ABdhPJxXg1BTWT5A1b0ZWfc97T3fsTG0TVU9JSo9BJ1JDc4rRkJhfkEOcwDOIA1L+dKkH5UMHh3eFg==
X-Received: by 2002:a63:b91b:: with SMTP id z27mr5393267pge.231.1617837619789;
        Wed, 07 Apr 2021 16:20:19 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id g3sm21422171pfk.186.2021.04.07.16.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 16:20:19 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 8/8] ionic: extend ts_config set locking
Date:   Wed,  7 Apr 2021 16:20:01 -0700
Message-Id: <20210407232001.16670-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210407232001.16670-1-snelson@pensando.io>
References: <20210407232001.16670-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the configuration is locked before
operating on it for the replay.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_phc.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
index 2bb749097d9e..177dbf89affd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
@@ -79,6 +79,8 @@ static int ionic_lif_hwstamp_set_ts_config(struct ionic_lif *lif,
 	if (!lif->phc || !lif->phc->ptp)
 		return -EOPNOTSUPP;
 
+	mutex_lock(&lif->phc->config_lock);
+
 	if (new_ts) {
 		config = new_ts;
 	} else {
@@ -96,12 +98,16 @@ static int ionic_lif_hwstamp_set_ts_config(struct ionic_lif *lif,
 	}
 
 	tx_mode = ionic_hwstamp_tx_mode(config->tx_type);
-	if (tx_mode < 0)
-		return tx_mode;
+	if (tx_mode < 0) {
+		err = tx_mode;
+		goto err_queues;
+	}
 
 	mask = cpu_to_le64(BIT_ULL(tx_mode));
-	if ((ionic->ident.lif.eth.hwstamp_tx_modes & mask) != mask)
-		return -ERANGE;
+	if ((ionic->ident.lif.eth.hwstamp_tx_modes & mask) != mask) {
+		err = -ERANGE;
+		goto err_queues;
+	}
 
 	rx_filt = ionic_hwstamp_rx_filt(config->rx_filter);
 	rx_all = config->rx_filter != HWTSTAMP_FILTER_NONE && !rx_filt;
@@ -116,8 +122,6 @@ static int ionic_lif_hwstamp_set_ts_config(struct ionic_lif *lif,
 	dev_dbg(ionic->dev, "config_rx_filter %d rx_filt %#llx rx_all %d\n",
 		config->rx_filter, rx_filt, rx_all);
 
-	mutex_lock(&lif->phc->config_lock);
-
 	if (tx_mode) {
 		err = ionic_lif_create_hwstamp_txq(lif);
 		if (err)
-- 
2.17.1

