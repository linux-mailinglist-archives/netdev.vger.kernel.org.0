Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C119131E16
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 04:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgAGDoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 22:44:04 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34451 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbgAGDoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 22:44:03 -0500
Received: by mail-pj1-f66.google.com with SMTP id s94so4851889pjc.1
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 19:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VRpcX5dljS7G2GoRPSUCuR98m4dO7SFJ1AshJLSpdeY=;
        b=jhCIu6sF3Zcn0x86+OYqlF/BqxGmrth/xoQcw1+bEUZvSz9EfudLCkBw+LEl8Dci3/
         W/1PZ1gD/d6mxQhbgrw+xa3+XvzWOdEXZ9kmYPu4UEqLq5uhQuMRiKcOf4Rn2TWo9ocJ
         5dDoZBMnNqs6878plw5gt0VR413o3kA4/D6XoFdrzLJPRt07/1KFsuXkDwMnOxLF+xDM
         ITLA0OeIg4du9vdafjnJf615C3bHiinLwxcNhCd0lZbNVvuI6HyAxabwgGsRwn/prRet
         sO8J4sILtTJNCbO6yKAaCOw/wPKStY54cDQKWnpYPkCnuovJPuk5LUM8SLDzYeQzPdxH
         cObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VRpcX5dljS7G2GoRPSUCuR98m4dO7SFJ1AshJLSpdeY=;
        b=GFN4uRZjmbFiiRUsZFBtb+pTGGl4RUAmEO5989/0sWwV67YKe4DxBcFXrIS4nfgkm3
         cpcI3FobRx52GU2RZE9E4PqJAQ2g2wsBNfSGfdJH8nbmKUVgol2J8IFYeYJDma8oVzyr
         +ay8n4fJOrT3lar1lcXw9mqid5G9MO/F+D3cx9CQAMeuYQAIPPvHtyQtkzDYKfQNqueK
         z13HEZxDOKVP19XAf7vowNaKzNS48SSUerUZTaoix6VN7sNrPfzzLb5Ax1Oc1wvH5X5b
         Jbs4iPXnlNJOYem41/lQV8D9kOMg0inDvIsRTilwFGrQ54lfTd8vQp5cdRSXtxO1/jAQ
         m3Xw==
X-Gm-Message-State: APjAAAWYaknKWj6Nn4t4mnOIDV1DxVwtYfDHJWFVGL3zPVxayhmJw6qe
        XpRwGvavkEblZUa9KljwYVMdLJCQIf4=
X-Google-Smtp-Source: APXvYqwOElJxhaRnFmOTbQFAGJBOzcTToCML3NH/gUtYSaDxamd2dGxQdtmUd/K3BUKB0HBU1BrKtg==
X-Received: by 2002:a17:90a:b009:: with SMTP id x9mr46774346pjq.124.1578368642373;
        Mon, 06 Jan 2020 19:44:02 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a22sm85262959pfk.108.2020.01.06.19.44.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 19:44:01 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 2/4] ionic: add Rx dropped packet counter
Date:   Mon,  6 Jan 2020 19:43:47 -0800
Message-Id: <20200107034349.59268-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200107034349.59268-1-snelson@pensando.io>
References: <20200107034349.59268-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a counter for packets dropped by the driver, typically
for bad size or a receive error seen by the device.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.h   |  1 +
 drivers/net/ethernet/pensando/ionic/ionic_stats.c |  1 +
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c  | 12 +++++++++---
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index a55fd1f8c31b..9c5a7dd45f9d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -37,6 +37,7 @@ struct ionic_rx_stats {
 	u64 csum_complete;
 	u64 csum_error;
 	u64 buffers_posted;
+	u64 dropped;
 };
 
 #define IONIC_QCQ_F_INITED		BIT(0)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
index 03916b6d47f2..a1e9796a660a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -39,6 +39,7 @@ static const struct ionic_stat_desc ionic_rx_stats_desc[] = {
 	IONIC_RX_STAT_DESC(csum_none),
 	IONIC_RX_STAT_DESC(csum_complete),
 	IONIC_RX_STAT_DESC(csum_error),
+	IONIC_RX_STAT_DESC(dropped),
 };
 
 static const struct ionic_stat_desc ionic_txq_stats_desc[] = {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 97e79949b359..a009bbe9f9be 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -152,12 +152,16 @@ static void ionic_rx_clean(struct ionic_queue *q, struct ionic_desc_info *desc_i
 	stats = q_to_rx_stats(q);
 	netdev = q->lif->netdev;
 
-	if (comp->status)
+	if (comp->status) {
+		stats->dropped++;
 		return;
+	}
 
 	/* no packet processing while resetting */
-	if (unlikely(test_bit(IONIC_LIF_QUEUE_RESET, q->lif->state)))
+	if (unlikely(test_bit(IONIC_LIF_QUEUE_RESET, q->lif->state))) {
+		stats->dropped++;
 		return;
+	}
 
 	stats->pkts++;
 	stats->bytes += le16_to_cpu(comp->len);
@@ -167,8 +171,10 @@ static void ionic_rx_clean(struct ionic_queue *q, struct ionic_desc_info *desc_i
 	else
 		skb = ionic_rx_frags(q, desc_info, cq_info);
 
-	if (unlikely(!skb))
+	if (unlikely(!skb)) {
+		stats->dropped++;
 		return;
+	}
 
 	skb_record_rx_queue(skb, q->index);
 
-- 
2.17.1

