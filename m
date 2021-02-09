Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03D6314B1E
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhBIJHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhBIJAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 04:00:36 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DD6C061793
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 00:58:01 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id q7so20593532wre.13
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 00:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d/vcUFElLAuaSN3VBWBjg1pNshUOyxf0nCgvwWAXx70=;
        b=R6rF8ziL4TxdR5RXMcmtNQq8ZQMT0sTTuBOzJ3Bh9mnHEvNX0YpjoHmaqojcWS26TB
         WZcRCIlA7HigJkSAOjybd35eM455fUycY7n58z2pQL7Q5cNXggQcGeY4bCmUvSpOeYxG
         CjKYFARbirAB4Ye3OlGmcZjYsyQIybj97QkPlDu/N7cwuZW/DZN4zspKDbMdm4ScmNqE
         lOOZi89JPwI6A2FKEuBqeKfiNndOmfnOCqvXFSlpK9Trbm7uv8HyAn9H9eEhENzdgBZM
         D2ZGA7AZyZOvMlgA+UwK/eYsTFMlAHw4XlxGc8nYmrDP+lVjnqqKU5ldn0i4drvIuCyG
         WY1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d/vcUFElLAuaSN3VBWBjg1pNshUOyxf0nCgvwWAXx70=;
        b=Z1REGWJR7Gyl7uq8TmMjTAfnBDa3JzAM0O526u28Xolaj5nmp0Yw2jhGPIE7IpA7R+
         9zgoR6ylqptzP6y8zmiq+bhtlaDOtRfTmLNTLjjXVCCN1e5ZLFfDEemC4pwgOI7HQVFo
         J8Pu1FMKtw5AOTouT1BALxjwWnpwR1cpWv7gsCXsZA/dryiJSR9ldI1p7wMtYmYqIxQM
         f5SsH3r1HwTNvBr2317zspEuh+AT2anIdFHz5P5odQMfFmOHt03FD0g5mElZvQUPTpo1
         gjVqa9GRbgDFntHr28/1PdAlLNWM7i4gfYqPKeznmdHXbK82uUhWO21Hs2dMf+uaCu0B
         ZFYw==
X-Gm-Message-State: AOAM532XaGW25oeEgTmKNMU/e4kGKNKuuTiYMks84XDuihb+CVYARAsP
        PBGzgAhq3XrysHP44aOw2DQ4MQ==
X-Google-Smtp-Source: ABdhPJx2XDoI+HnDtYH5TmjCJGXZ9e/L1dKwNM348mCd1VbXTMqQotTeLNIk2xOaiv1m4JiY+iEF0A==
X-Received: by 2002:a5d:5010:: with SMTP id e16mr1995305wrt.202.1612861080034;
        Tue, 09 Feb 2021 00:58:00 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id d3sm38348693wrp.79.2021.02.09.00.57.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 00:57:59 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bjorn@mork.no, dcbw@redhat.com,
        carl.yin@quectel.com, mpearson@lenovo.com, cchen50@lenovo.com,
        jwjiang@lenovo.com, ivan.zhang@quectel.com,
        naveen.kumar@quectel.com, ivan.mikhanchuk@quectel.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v5 4/5] net: mhi: Add rx_length_errors stat
Date:   Tue,  9 Feb 2021 10:05:57 +0100
Message-Id: <1612861558-14487-5-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612861558-14487-1-git-send-email-loic.poulain@linaro.org>
References: <1612861558-14487-1-git-send-email-loic.poulain@linaro.org>
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

