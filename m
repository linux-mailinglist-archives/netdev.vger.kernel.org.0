Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2CAC2923
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732191AbfI3Vti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:49:38 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36368 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfI3Vte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:49:34 -0400
Received: by mail-pf1-f195.google.com with SMTP id y22so6357331pfr.3
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 14:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iyER8ybMeuqZeGqNiP6Lbd8qMka3eAGMmkCKVrI0azE=;
        b=QJWpcXjHpXwmyDqK3x+1HoeEulxgq7mwPmcacXkzZPv6rk7BR9FIilLAccjwAdHtBQ
         NE9BUYsjKbx1vn4NP0Ce4QUVyiykW2AjVjNjqsOhuKWzxS8OOA3sSMNmGLr+5dTNaRM1
         JzVLWz4J8YHUZnD8Aed6MhA+omx8gYqRPcpRMqYrl4Zr63dp8YbUfB8sLxVS8o7KDHyV
         GbaamVGONr5qzsbt13NtvtfEpV2a2gBrwniZM4YQziAwkM0IsrRuDjqTeyqtwUhra5g4
         fz6IuF9TYr1Hln0z+k1Jj5gNcXjluvDSV7ow/Hj29sdnFmZ/DR9TvW824G82aSDAhwbC
         iEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iyER8ybMeuqZeGqNiP6Lbd8qMka3eAGMmkCKVrI0azE=;
        b=lw5Q/6bJhsedYXHlMCFPdKFhxDFAi+u9PCkz7DK6e2BSqwqd8w13TERSreRPSZVI3l
         AtIw445Z7kjAMtiANcIIn0MY6/pEeu7FwhpKchINg+pcNZjgKXXAjuoCfBvWm9htn98j
         vlv+6rPfAP4fBznulJl+3m56cCIZEdYrR2Cb1bApSM0R35afz34lrdgK9whjern8bEoR
         NsjmMo501UqpXtX9/t46lANosM0Yg4mrFjRfmReiIxeJxa241BPJV0BiQpBuQaHxOTZB
         8viYy7Mqf9c0QKezf/LkjWRZGt+U2/QBjHQnvo+M/p1uMWT9Ittz57gzC0ZLhKau5o0K
         1zVg==
X-Gm-Message-State: APjAAAXvVNJkVgOCKsne3QYpw/Yxledok7LW4OcPFoBHi3YSe8xM4GVg
        bGbzb7+34uh0O/p2Eoqv6TwdOtjciHoqVw==
X-Google-Smtp-Source: APXvYqxRx3fHiXtV8LoOMmsDoUmKB7Q4Mo01Z97uSGr69D6dLAbcQ2NCzr5WazZXXuNxDdy53MuXag==
X-Received: by 2002:a17:90a:f990:: with SMTP id cq16mr1555893pjb.41.1569880173540;
        Mon, 30 Sep 2019 14:49:33 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 30sm505746pjk.25.2019.09.30.14.49.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 14:49:32 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 4/5] ionic: implement ethtool set-fec
Date:   Mon, 30 Sep 2019 14:49:19 -0700
Message-Id: <20190930214920.18764-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190930214920.18764-1-snelson@pensando.io>
References: <20190930214920.18764-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wire up the --set-fec and --show-fec features in the ethtool
callbacks and pull the related code out of set_link_ksettings.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 94 +++++++++++++------
 1 file changed, 67 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 63cc14c060d6..f778fff034f5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -254,12 +254,9 @@ static int ionic_set_link_ksettings(struct net_device *netdev,
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic *ionic = lif->ionic;
 	struct ionic_dev *idev;
-	u32 req_rs, req_fc;
-	u8 fec_type;
 	int err = 0;
 
 	idev = &lif->ionic->idev;
-	fec_type = IONIC_PORT_FEC_TYPE_NONE;
 
 	/* set autoneg */
 	if (ks->base.autoneg != idev->port_info->config.an_enable) {
@@ -281,29 +278,6 @@ static int ionic_set_link_ksettings(struct net_device *netdev,
 			return err;
 	}
 
-	/* set FEC */
-	req_rs = ethtool_link_ksettings_test_link_mode(ks, advertising, FEC_RS);
-	req_fc = ethtool_link_ksettings_test_link_mode(ks, advertising, FEC_BASER);
-	if (req_rs && req_fc) {
-		netdev_info(netdev, "Only select one FEC mode at a time\n");
-		return -EINVAL;
-	} else if (req_fc) {
-		fec_type = IONIC_PORT_FEC_TYPE_FC;
-	} else if (req_rs) {
-		fec_type = IONIC_PORT_FEC_TYPE_RS;
-	} else if (!(req_rs | req_fc)) {
-		fec_type = IONIC_PORT_FEC_TYPE_NONE;
-	}
-
-	if (fec_type != idev->port_info->config.fec_type) {
-		mutex_lock(&ionic->dev_cmd_lock);
-		ionic_dev_cmd_port_fec(idev, fec_type);
-		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
-		mutex_unlock(&ionic->dev_cmd_lock);
-		if (err)
-			return err;
-	}
-
 	return 0;
 }
 
@@ -353,6 +327,70 @@ static int ionic_set_pauseparam(struct net_device *netdev,
 	return 0;
 }
 
+static int ionic_get_fecparam(struct net_device *netdev,
+			      struct ethtool_fecparam *fec)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+
+	switch (lif->ionic->idev.port_info->config.fec_type) {
+	case IONIC_PORT_FEC_TYPE_NONE:
+		fec->active_fec = ETHTOOL_FEC_OFF;
+		break;
+	case IONIC_PORT_FEC_TYPE_RS:
+		fec->active_fec = ETHTOOL_FEC_RS;
+		break;
+	case IONIC_PORT_FEC_TYPE_FC:
+		fec->active_fec = ETHTOOL_FEC_BASER;
+		break;
+	}
+
+	fec->fec = ETHTOOL_FEC_OFF | ETHTOOL_FEC_RS | ETHTOOL_FEC_BASER;
+
+	return 0;
+}
+
+static int ionic_set_fecparam(struct net_device *netdev,
+			      struct ethtool_fecparam *fec)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	u8 fec_type;
+	int ret = 0;
+
+	if (lif->ionic->idev.port_info->config.an_enable) {
+		netdev_err(netdev, "FEC request not allowed while autoneg is enabled\n");
+		return -EINVAL;
+	}
+
+	switch (fec->fec) {
+	case ETHTOOL_FEC_NONE:
+		fec_type = IONIC_PORT_FEC_TYPE_NONE;
+		break;
+	case ETHTOOL_FEC_OFF:
+		fec_type = IONIC_PORT_FEC_TYPE_NONE;
+		break;
+	case ETHTOOL_FEC_RS:
+		fec_type = IONIC_PORT_FEC_TYPE_RS;
+		break;
+	case ETHTOOL_FEC_BASER:
+		fec_type = IONIC_PORT_FEC_TYPE_FC;
+		break;
+	case ETHTOOL_FEC_AUTO:
+	default:
+		netdev_err(netdev, "FEC request 0x%04x not supported\n",
+			   fec->fec);
+		return -EINVAL;
+	}
+
+	if (fec_type != lif->ionic->idev.port_info->config.fec_type) {
+		mutex_lock(&lif->ionic->dev_cmd_lock);
+		ionic_dev_cmd_port_fec(&lif->ionic->idev, fec_type);
+		ret = ionic_dev_cmd_wait(lif->ionic, DEVCMD_TIMEOUT);
+		mutex_unlock(&lif->ionic->dev_cmd_lock);
+	}
+
+	return ret;
+}
+
 static int ionic_get_coalesce(struct net_device *netdev,
 			      struct ethtool_coalesce *coalesce)
 {
@@ -751,6 +789,7 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.get_regs		= ionic_get_regs,
 	.get_link		= ethtool_op_get_link,
 	.get_link_ksettings	= ionic_get_link_ksettings,
+	.set_link_ksettings	= ionic_set_link_ksettings,
 	.get_coalesce		= ionic_get_coalesce,
 	.set_coalesce		= ionic_set_coalesce,
 	.get_ringparam		= ionic_get_ringparam,
@@ -773,7 +812,8 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.get_module_eeprom	= ionic_get_module_eeprom,
 	.get_pauseparam		= ionic_get_pauseparam,
 	.set_pauseparam		= ionic_set_pauseparam,
-	.set_link_ksettings	= ionic_set_link_ksettings,
+	.get_fecparam		= ionic_get_fecparam,
+	.set_fecparam		= ionic_set_fecparam,
 	.nway_reset		= ionic_nway_reset,
 };
 
-- 
2.17.1

