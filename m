Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD833A48A3
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 20:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhFKS2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 14:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbhFKS2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 14:28:11 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6328C061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 11:26:04 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id i13so6026577ilk.3
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 11:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EAHxaZihko63eZs3RZm6MKwaWhCSxnqgrXTUH40MDkY=;
        b=lBsThK6OOlsVeGRgCqKb+xfBmmGlOw/gtmNnUoyN7cCpnHE/bHM0gpGwWwpEfPcZGY
         X0FpzevEEQkN6O2xme/3Qi8c62L02y1XrksP4rsSJ1+FpaiB6eVvmV5FPa0OmgbYuDQF
         cD7gPyBHtF2Fjt/kAopznxifYew4xu24SAMDFYMKaUuKMNvBawxuCAn5EG3pHBKkOFxp
         gLyce56bfjH5CxagJvlcVWm/VXVvtd3IDlzDcThdpsSTXnIZ+w822NVG9lmNvuacnYgD
         EqC7e2M0pENgUzYF2TC3a7Sg1xSomclpadoIk2UqEPLdatyW0j3izxxY4Hg8AIYH2JAA
         2pZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EAHxaZihko63eZs3RZm6MKwaWhCSxnqgrXTUH40MDkY=;
        b=D0KT/yUk7S43AV1VJCO4OJki7JdUW1GmuaKGgWwQx5se7l7rZ4MDKHvezVfJurlR7/
         L+jn0K+khGu/33kDSxOVzuE1WqHAOGwm3bxrltXSlHlCT0/0HS7bcanx5sile2nIBiUl
         OaQX1J8t+FLAk4/ylJbz88HkKKi1MRWFGTpr3Bda/u/xwAOhDQ9RT9mUfx1LRTQQJvtG
         2eXelYgTZOohY/935zdEoHer9ET86QeozKlRI93WwOZCWduBMQvKoWi2vVoMaws8KhJC
         5MooErL6spirY7CtzDxHCgsDjMNq3nctsLGxVURYMfdeFdgSZTAmZ2fLJ4ZHv8aWgskL
         s4tA==
X-Gm-Message-State: AOAM53006p0nLyWt9ewiES3D8rD20ZyLvA96dupVQsljGgRwwNN/R68d
        bG3Z4gq9CgvkUBFn1jqrLWH6zg==
X-Google-Smtp-Source: ABdhPJyhLODZiTGzLpEDITOVhWQyt842Yw4j61Nt2TQwRmjzT923Kj6QFFFrafAfa0kIkkx8DbUBXA==
X-Received: by 2002:a92:4a02:: with SMTP id m2mr4056855ilf.171.1623435964276;
        Fri, 11 Jun 2021 11:26:04 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o18sm3803158ioh.35.2021.06.11.11.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 11:26:03 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: qualcomm: rmnet: don't over-count statistics
Date:   Fri, 11 Jun 2021 13:26:00 -0500
Message-Id: <20210611182600.2972987-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of the loop using u64_stats_fetch_*_irq() is to ensure
statistics on a given CPU are collected atomically. If one of the
statistics values gets updated within the begin/retry window, the
loop will run again.

Currently the statistics totals are updated inside that window.
This means that if the loop ever retries, the statistics for the
CPU will be counted more than once.

Fix this by taking a snapshot of a CPU's statistics inside the
protected window, and then updating the counters with the snapshot
values after exiting the loop.

(Also add a newline at the end of this file...)

Fixes: 192c4b5d48f2a ("net: qualcomm: rmnet: Add support for 64 bit stats")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c    | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index fe13017e9a41e..06a74fa0d575d 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -126,24 +126,24 @@ static void rmnet_get_stats64(struct net_device *dev,
 			      struct rtnl_link_stats64 *s)
 {
 	struct rmnet_priv *priv = netdev_priv(dev);
-	struct rmnet_vnd_stats total_stats;
+	struct rmnet_vnd_stats total_stats = { };
 	struct rmnet_pcpu_stats *pcpu_ptr;
+	struct rmnet_vnd_stats snapshot;
 	unsigned int cpu, start;
 
-	memset(&total_stats, 0, sizeof(struct rmnet_vnd_stats));
-
 	for_each_possible_cpu(cpu) {
 		pcpu_ptr = per_cpu_ptr(priv->pcpu_stats, cpu);
 
 		do {
 			start = u64_stats_fetch_begin_irq(&pcpu_ptr->syncp);
-			total_stats.rx_pkts += pcpu_ptr->stats.rx_pkts;
-			total_stats.rx_bytes += pcpu_ptr->stats.rx_bytes;
-			total_stats.tx_pkts += pcpu_ptr->stats.tx_pkts;
-			total_stats.tx_bytes += pcpu_ptr->stats.tx_bytes;
+			snapshot = pcpu_ptr->stats;	/* struct assignment */
 		} while (u64_stats_fetch_retry_irq(&pcpu_ptr->syncp, start));
 
-		total_stats.tx_drops += pcpu_ptr->stats.tx_drops;
+		total_stats.rx_pkts += snapshot.rx_pkts;
+		total_stats.rx_bytes += snapshot.rx_bytes;
+		total_stats.tx_pkts += snapshot.tx_pkts;
+		total_stats.tx_bytes += snapshot.tx_bytes;
+		total_stats.tx_drops += snapshot.tx_drops;
 	}
 
 	s->rx_packets = total_stats.rx_pkts;
@@ -355,4 +355,4 @@ int rmnet_vnd_update_dev_mtu(struct rmnet_port *port,
 	}
 
 	return 0;
-}
\ No newline at end of file
+}
-- 
2.27.0

