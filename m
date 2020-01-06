Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19996131A0E
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgAFVFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:05:24 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45738 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgAFVFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:05:22 -0500
Received: by mail-pg1-f195.google.com with SMTP id b9so27401879pgk.12
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 13:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VRpcX5dljS7G2GoRPSUCuR98m4dO7SFJ1AshJLSpdeY=;
        b=guivR/P+q9s70eQRcwYqKbN4IMhrvC5DL1eCZr0BFrQ74Zog0wuF0S8OCASq3XyLQA
         HhppT4v0Xejl7+vVdkur1gydxfoJv/4MUrBLNvPDCK13xfnuFnIGxyjQ6Q73Pzt85G8M
         9PVtmqxzXQ+2oXBJLdb/X7gXK+7d/uSdXuTdUqnrvLQtx61floX2Db+DeSUqaRb1M9/N
         1x6idfYgZUgoItCTN8xINlG24utvG7gJvxs8UWDM2eH2vXr4v8JmBvJ0J2nYQO6kxI5m
         35BQoyWAJIoNGHN+cIOjkB3SuRqgr9blfSBlFWmambCIOkqluo2AmSHsPSDqviNRNoCS
         9yVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VRpcX5dljS7G2GoRPSUCuR98m4dO7SFJ1AshJLSpdeY=;
        b=lkaORkkKD3UY7kTf/W17SNASpjaEzpNSBEh11c4NQgAXP/fh84qgSpDcxCjhTS2osM
         sCVXtp5DVyVNiY42/uWtA39ZD/odbWR4W7DtPgqNqg/4Xbd8vCjQQ9o6Zcuw+7IxEf65
         Ig5EQJQZxSXRAAKmJe1914CFDQ/NOKs22sOvnSv5ukJGEQmBA8A3BbGhYu4WSCmSe4p7
         3HBC7TPLPTpAa3ufSflAcodlAvjA6+1FJO7TI9hDRjdpeyPj6SE+QBcZXdSMisZovNqR
         CpGPoVRUd9kHGBGZq3zZBwxyQLxEwvd7HPXj+EywcsEokrn6hSF9VUaDbsx2JWSf9FaH
         JAmA==
X-Gm-Message-State: APjAAAVGWQSUUmJ6yvE4LvXKVhmIWibNvr+8+hPY8Lpojh753YIROd0/
        U+hPg75NjcvY6K1QJf67LHmRrNWUJC4=
X-Google-Smtp-Source: APXvYqwsVQY2ssMnU9IZXKNMSfGDr1XF/DADpCGqcUaZ6J3+e0Un3jTQCqbDRYaYSM+ZVBD3EoSDpA==
X-Received: by 2002:a62:148a:: with SMTP id 132mr48588984pfu.158.1578344721619;
        Mon, 06 Jan 2020 13:05:21 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p16sm63183003pfq.184.2020.01.06.13.05.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 13:05:21 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/4] ionic: add Rx dropped packet counter
Date:   Mon,  6 Jan 2020 13:05:11 -0800
Message-Id: <20200106210512.34244-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200106210512.34244-1-snelson@pensando.io>
References: <20200106210512.34244-1-snelson@pensando.io>
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

