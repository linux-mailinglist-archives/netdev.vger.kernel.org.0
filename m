Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4870F34119E
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 01:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhCSAt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 20:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbhCSAs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 20:48:56 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F29C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 17:48:56 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id l3so4690819pfc.7
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 17:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7Z1W874oYykgTPXqxR8IoTTpuoVTHxIFrkm+0NrM8RQ=;
        b=lxPdtYHCkV0ZOyPHCyracbbBvI2yXoubson7QbbKcJDnBxY42gUmaJ0W8r9Mm0B0Lo
         NXurac/GgZZ+Gy1MqY6HN3QKMAtVb/KxtoQy5mhyQDKUfw/OeoDOnMEsgRvfkG/j8ujO
         dZKojcxCFul+9G28iYoE4EHp/OaMtwg0OWcyf07aU1hi0l00xFczqw9KHMLF1d36DOw+
         0wHk1fzCUus+DTwMjq8AvFi5jo7EbfiNuRLxwxffG0HK+b/M64gVB4hNnJsUsSfjc+7+
         NxnQTaCT13KZ7+KvYy6ptwrO3tH7EENsbqO8FIHAG0WxxTDVGTKimaN8kA+mzbppifn6
         IdIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7Z1W874oYykgTPXqxR8IoTTpuoVTHxIFrkm+0NrM8RQ=;
        b=BMSMddo3RVBsrQ9tBzhZcwGTJFmfLeU3tzsMLn0GUKR4p0CSPrSF+v2Fi+1+VL669v
         ofdnbjOuL8X3ca0eu+xT/IxY/6Hq8g8vlLKaE3K2BFfKnZW0/ncOAbGv2oxCZef0f1F1
         MQKRrW4o0YXRh02Fz59QNtha4FqPn19pr1Dyqa4UB1nkWcL2aDuyNpNbz187Rm5BqsS8
         M2E6vyzUoTylK+qeuo8VwkIpT5fa2CCk8SXw+LNY6Ga4/c/gQEyQZmt6ErUCYJLlXksw
         nnMBS0yoolmnCVtFs+XghDBclxRjVpq5keVEsa3HNouHS0bDjDpuuErv3zmqoI5zlo98
         vXLw==
X-Gm-Message-State: AOAM531NHY2l73mHI5smhRh39v3k9/A3nWNVygOTDa9/8yluzqqvJAn7
        XfOUC4meiugEwGh1TNQRCy6UcOMTjEf/+Q==
X-Google-Smtp-Source: ABdhPJwEkoSnGRZTr4ErYgyGoYP3pfLuyfN5Qb4lRhtVIAZueiFD74nhbG7JxUm+TyEIIDzQP57ifA==
X-Received: by 2002:a62:8782:0:b029:1f7:74b0:d0eb with SMTP id i124-20020a6287820000b02901f774b0d0ebmr6481681pfe.18.1616114935249;
        Thu, 18 Mar 2021 17:48:55 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i7sm3592949pfq.184.2021.03.18.17.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 17:48:54 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 6/7] ionic: stop watchdog when in broken state
Date:   Thu, 18 Mar 2021 17:48:09 -0700
Message-Id: <20210319004810.4825-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210319004810.4825-1-snelson@pensando.io>
References: <20210319004810.4825-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Up to now we've been ignoring any error return from the
queue starting in the link status check, so we fix that here.
If the driver had to reset and couldn't get things running
properly again, for example after a Tx Timeout and the FW is
not responding to commands, don't let the link watchdog try
to restart the queues.  At this point the user can try to DOWN
and UP the device to clear the errors.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 25 +++++++++++++++++--
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  1 +
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4f4ca183830b..9b3afedbc083 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -120,17 +120,31 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 	if (!test_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state))
 		return;
 
+	/* Don't put carrier back up if we're in a broken state */
+	if (test_bit(IONIC_LIF_F_BROKEN, lif->state)) {
+		clear_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state);
+		return;
+	}
+
 	link_status = le16_to_cpu(lif->info->status.link_status);
 	link_up = link_status == IONIC_PORT_OPER_STATUS_UP;
 
 	if (link_up) {
+		int err = 0;
+
 		if (netdev->flags & IFF_UP && netif_running(netdev)) {
 			mutex_lock(&lif->queue_lock);
-			ionic_start_queues(lif);
+			err = ionic_start_queues(lif);
+			if (err) {
+				netdev_err(lif->netdev,
+					   "Failed to start queues: %d\n", err);
+				set_bit(IONIC_LIF_F_BROKEN, lif->state);
+				netif_carrier_off(lif->netdev);
+			}
 			mutex_unlock(&lif->queue_lock);
 		}
 
-		if (!netif_carrier_ok(netdev)) {
+		if (!err && !netif_carrier_ok(netdev)) {
 			ionic_port_identify(lif->ionic);
 			netdev_info(netdev, "Link up - %d Gbps\n",
 				    le32_to_cpu(lif->info->status.link_speed) / 1000);
@@ -1836,6 +1850,9 @@ static int ionic_start_queues(struct ionic_lif *lif)
 {
 	int err;
 
+	if (test_bit(IONIC_LIF_F_BROKEN, lif->state))
+		return -EIO;
+
 	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
 		return -EBUSY;
 
@@ -1857,6 +1874,10 @@ static int ionic_open(struct net_device *netdev)
 	struct ionic_lif *lif = netdev_priv(netdev);
 	int err;
 
+	/* If recovering from a broken state, clear the bit and we'll try again */
+	if (test_and_clear_bit(IONIC_LIF_F_BROKEN, lif->state))
+		netdev_info(netdev, "clearing broken state\n");
+
 	err = ionic_txrx_alloc(lif);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 8ffda32a0a7d..be5cc89b2bd9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -139,6 +139,7 @@ enum ionic_lif_state_flags {
 	IONIC_LIF_F_LINK_CHECK_REQUESTED,
 	IONIC_LIF_F_FW_RESET,
 	IONIC_LIF_F_SPLIT_INTR,
+	IONIC_LIF_F_BROKEN,
 	IONIC_LIF_F_TX_DIM_INTR,
 	IONIC_LIF_F_RX_DIM_INTR,
 
-- 
2.17.1

