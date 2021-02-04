Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D818A30FAF1
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 19:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238903AbhBDSLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237870AbhBDSKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 13:10:49 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7DCC06178C
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 10:10:07 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id m1so3819687wml.2
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 10:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d/vcUFElLAuaSN3VBWBjg1pNshUOyxf0nCgvwWAXx70=;
        b=jLzThKild8SiSmDTt7B6hMXltpLE82ZUBpsXNL8Qx8a03uuOb0of67FQmkMxHvCy2N
         sX1F1uD+q0b79+hO4b6q9KdSclrWge+E0U0gewA2xbRgjs+iBR6rjeuCam/ZXAQrKfcC
         GHUSafEyirZ4cNjkPs0OvQrg4XLYIQH0aRlHVgJt1zTZ7CK1xU+FbdHX/URJIYkeOBc/
         N3hEOc6gpcgqpiTFdM8YWUQMXdjBHQY2//N/cR+bjXBQWSUIOC6jKrUmeYOGcWfuER+W
         o4LTb2PuZBBDS5XB9Rt36bzcPC5osuqxu5KJBiyNZXqlIm2ZUzkW8iG+GydteqAVGdIq
         n+jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d/vcUFElLAuaSN3VBWBjg1pNshUOyxf0nCgvwWAXx70=;
        b=T93FYzyFAl8JPlHiKBV9comsuo09Ia+26gLGzQuFs2cEah1hYshg0hZQmRsS4a141y
         JD+QrHqa+CUu/HvU8FnHu4UcGZcixEefA5ELbYN8vw3UGCWwMT/wf5O868GW5vGU+yEn
         qBn/xyIaKe0RXsQ4DhwiEB8Uz9MJylSHIJhnAxArAoHOs6OQMpQK4coZHmW4yZZB+U6t
         tRKmUaBxoVaId07CqjXiFlqeBpX5W07xJtb6oFIC3nwH3w9yBgRFfHoUy0XeSp34SM+V
         YpqdGuvgdDkBeZn0Ci+rFLXEJiAIJ0VoZo9eyM34NgDmGj2buhOKtCOMWljZuwyV36eX
         ql0Q==
X-Gm-Message-State: AOAM533lVU0AmiXM7VlNmDlmHca3zqKxGD5N1xlTC4wwrtDHw6uzEMiB
        MB78zCKSVS4AHYXIvwuEJpc0vQ==
X-Google-Smtp-Source: ABdhPJyhHAF366BhIpow4wvQNyB9h9L6/JAfXZzsi0zxfVx5C2Bt4ZFqnBRpv0nZLuKQAAInpoBCiw==
X-Received: by 2002:a1c:65d5:: with SMTP id z204mr372600wmb.184.1612462206510;
        Thu, 04 Feb 2021 10:10:06 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id m6sm6313746wmq.13.2021.02.04.10.10.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Feb 2021 10:10:06 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bjorn@mork.no, dcbw@redhat.com,
        carl.yin@quectel.com, mpearson@lenovo.com, cchen50@lenovo.com,
        jwjiang@lenovo.com, ivan.zhang@quectel.com,
        naveen.kumar@quectel.com, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v3 4/5] net: mhi: Add rx_length_errors stat
Date:   Thu,  4 Feb 2021 19:17:40 +0100
Message-Id: <1612462661-23045-5-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612462661-23045-1-git-send-email-loic.poulain@linaro.org>
References: <1612462661-23045-1-git-send-email-loic.poulain@linaro.org>
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

