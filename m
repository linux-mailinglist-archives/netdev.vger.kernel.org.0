Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1273FB590
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237134AbhH3MGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236625AbhH3MAq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 08:00:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7F0B61159;
        Mon, 30 Aug 2021 11:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324792;
        bh=cxXbVoZbpko4j+V6gp+3wR8SDxOgMa1XZ4POoerdObM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OaBIz3yu9Y0Rqq4QNpH4/GZxQe2ZIUayqmKQZB5ztFi6JVTW42QSPCB/MsQyrg7eL
         luiOjKOUa4NOHdlCMuOW0bh3a9hgA3L0nrKpad9xA/otYKJvdN3UPbeU3ILcCWanxi
         4/9BPqVjH0fkHgeScSy2Zj/zQRipJn7/XfNZfPF2dStjWCgbxq94Lu5mFzOO0Z2Um5
         DsM/loW4v5dD5yX2LE8OgRc82H1IxGwEtf4bPMi4J4YCeunow05yn/CECJii8AwbZy
         REGu1owWXRI4WSX21Dk+JcOrLp6l1ckM3g7Mkzb7yLZpGeIXhOUohNC1iDcsH8Ne/Q
         lnmaRaaAk4tHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 07/14] net: macb: Add a NULL check on desc_ptp
Date:   Mon, 30 Aug 2021 07:59:35 -0400
Message-Id: <20210830115942.1017300-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830115942.1017300-1-sashal@kernel.org>
References: <20210830115942.1017300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

[ Upstream commit 85520079afce885b80647fbd0d13d8f03d057167 ]

macb_ptp_desc will not return NULL under most circumstances with correct
Kconfig and IP design config register. But for the sake of the extreme
corner case, check for NULL when using the helper. In case of rx_tstamp,
no action is necessary except to return (similar to timestamp disabled)
and warn. In case of TX, return -EINVAL to let the skb be free. Perform
this check before marking skb in progress.
Fixes coverity warning:
(4) Event dereference:
Dereferencing a null pointer "desc_ptp"

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_ptp.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index 283918aeb741..09d64a29f56e 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -275,6 +275,12 @@ void gem_ptp_rxstamp(struct macb *bp, struct sk_buff *skb,
 
 	if (GEM_BFEXT(DMA_RXVALID, desc->addr)) {
 		desc_ptp = macb_ptp_desc(bp, desc);
+		/* Unlikely but check */
+		if (!desc_ptp) {
+			dev_warn_ratelimited(&bp->pdev->dev,
+					     "Timestamp not supported in BD\n");
+			return;
+		}
 		gem_hw_timestamp(bp, desc_ptp->ts_1, desc_ptp->ts_2, &ts);
 		memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
 		shhwtstamps->hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
@@ -307,8 +313,11 @@ int gem_ptp_txstamp(struct macb_queue *queue, struct sk_buff *skb,
 	if (CIRC_SPACE(head, tail, PTP_TS_BUFFER_SIZE) == 0)
 		return -ENOMEM;
 
-	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 	desc_ptp = macb_ptp_desc(queue->bp, desc);
+	/* Unlikely but check */
+	if (!desc_ptp)
+		return -EINVAL;
+	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 	tx_timestamp = &queue->tx_timestamps[head];
 	tx_timestamp->skb = skb;
 	/* ensure ts_1/ts_2 is loaded after ctrl (TX_USED check) */
-- 
2.30.2

