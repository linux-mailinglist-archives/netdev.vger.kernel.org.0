Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB87312B47
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 08:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhBHHyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 02:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbhBHHx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 02:53:27 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13D7C061793
        for <netdev@vger.kernel.org>; Sun,  7 Feb 2021 23:52:40 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id r7so6302717wrq.9
        for <netdev@vger.kernel.org>; Sun, 07 Feb 2021 23:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d/vcUFElLAuaSN3VBWBjg1pNshUOyxf0nCgvwWAXx70=;
        b=i28V+t5dcGUq3yVBn0zgWZnSZVTY8tIrnqlddVj+s0kHnhremwt5MSJIuJaSm1oDnj
         xsIuUzpgNPpAu0Wx8/83VPK5XVqaPKDnWuQ1lbiY56eSrUuDuNPcqI82Dboykm1ZxcHF
         z1FH6je88Ro7xTNhprRNM+s1LPZ4hmRw+YPkivLz4yLFJXzFeP3/47Jrz3wRVUjr2LM2
         HFLPvok1iSDYWSTlLkIkI0IHvc4TCI0RvGos4pD1l8GrK0y3/xUuhDMK3LQMfh9CtoJk
         bi6uRW7ZKKyL8dvYboAC8Ug7SpBhbggYMV0hBPr1l7hf/8e0qkcdUiscbbHLhhXbzEau
         7QNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d/vcUFElLAuaSN3VBWBjg1pNshUOyxf0nCgvwWAXx70=;
        b=p5c48eUNiMIYyz9EbmIz22JkqCX2NBpCOHR5t1Kun/qAz53hvS0n7bdzwnuNgl6zz0
         RdeKQEy2CuTr06VXJutayZz0MFcg16a2LLK3m3A2tTT0uGHX6YjAtZoKJ0zP8cYkXFid
         MPba38EKrE+DEbLe+EWHHvYoS4FmWsxzQJfQej1mRjf6QXe2D06tK6Uw4HHoZkDQp2Q1
         BFIHjGZlbVr3dqMEdQvAJn1AuepxknFmolQraI3T2tuPqCV4qHzatR/lFWTpqvIwJFjL
         D2jVDOTtouRRZZgez/Fh2r3KrYNALySqu2CJhKZLyUvzrtWOXTtsp8qK7oBgGFfxiLek
         I6JA==
X-Gm-Message-State: AOAM532OVnUfDbxMY5c44evVW8lct4PZJhB3f7s778LB/uMw3muP9Dy+
        O2pa4ec56LvZG9tgs3RZukWisVTHPUzlbg==
X-Google-Smtp-Source: ABdhPJz2RHfwXmAdKpsEIgOmDCyB9eD3vWQMYAHLVvXS8JxxkhrlsJf3qfEYc6uLJiTEIRbdK7jAhw==
X-Received: by 2002:adf:d20c:: with SMTP id j12mr18384135wrh.407.1612770759271;
        Sun, 07 Feb 2021 23:52:39 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:490:8730:2c22:849b:ef6a:c4b9])
        by smtp.gmail.com with ESMTPSA id g16sm18784952wmi.30.2021.02.07.23.52.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Feb 2021 23:52:38 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, bjorn@mork.no, dcbw@redhat.com,
        carl.yin@quectel.com, mpearson@lenovo.com, cchen50@lenovo.com,
        jwjiang@lenovo.com, ivan.zhang@quectel.com,
        naveen.kumar@quectel.com, ivan.mikhanchuk@quectel.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v4 4/5] net: mhi: Add rx_length_errors stat
Date:   Mon,  8 Feb 2021 09:00:36 +0100
Message-Id: <1612771237-3782-5-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612771237-3782-1-git-send-email-loic.poulain@linaro.org>
References: <1612771237-3782-1-git-send-email-loic.poulain@linaro.org>
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This can be used by proto when packet len is incorrect.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi/mhi.h | 1 +
 drivers/net/mhi/net.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/mhi/mhi.h b/drivers/net/mhi/mhi.h
index 5050e4a..82210e0 100644
--- a/drivers/net/mhi/mhi.h
+++ b/drivers/net/mhi/mhi.h
@@ -9,6 +9,7 @@ struct mhi_net_stats {
 	u64_stats_t rx_bytes;
 	u64_stats_t rx_errors;
 	u64_stats_t rx_dropped;
+	u64_stats_t rx_length_errors;
 	u64_stats_t tx_packets;
 	u64_stats_t tx_bytes;
 	u64_stats_t tx_errors;
diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index 58b4b7c..44cbfb3 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -95,6 +95,7 @@ static void mhi_ndo_get_stats64(struct net_device *ndev,
 		stats->rx_bytes = u64_stats_read(&mhi_netdev->stats.rx_bytes);
 		stats->rx_errors = u64_stats_read(&mhi_netdev->stats.rx_errors);
 		stats->rx_dropped = u64_stats_read(&mhi_netdev->stats.rx_dropped);
+		stats->rx_length_errors = u64_stats_read(&mhi_netdev->stats.rx_length_errors);
 	} while (u64_stats_fetch_retry_irq(&mhi_netdev->stats.rx_syncp, start));
 
 	do {
-- 
2.7.4

