Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13A31613BD
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 14:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgBQNnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 08:43:37 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:48298 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726314AbgBQNng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 08:43:36 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5C91BB40066;
        Mon, 17 Feb 2020 13:43:35 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 17 Feb
 2020 13:43:31 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 2/2] sfc: move some ARFS code out of headers
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3d83a647-beb0-6de7-39f7-c960e3299dc7@solarflare.com>
Message-ID: <83a9b2d7-7800-173d-2a5d-1604c1c6a80f@solarflare.com>
Date:   Mon, 17 Feb 2020 13:43:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3d83a647-beb0-6de7-39f7-c960e3299dc7@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25236.003
X-TM-AS-Result: No-3.466000-8.000000-10
X-TMASE-MatchedRID: fIPceilDx+VyOVk+FPzL1/zTlJK+gA83qnabhLgnhmgjRiu1AuxJTLCW
        JgRLh7wH3+cJ6tKTUNVTvVffeIwvQwUcfW/oedmqnFVnNmvv47tLXPA26IG0hN9RlPzeVuQQ1EP
        2Wxlu2pZC062FL4CYwFl+rJjPLsuBs1dXYh6zp8ckOFAoKA9tAms80vt+osfctLJ1NlvsxGCeAi
        CmPx4NwLTrdaH1ZWqC1kTfEkyaZdz6C0ePs7A07fhmFHnZFzVqAJlpjrPvMPE/ymNsCWgmLoXma
        m+o4C0KGP1j749zTTuZIZX117UGDOM7p+n2ZHJ0PT4hOck6e9+0WPHMW130vw/hYamggk2w7X0N
        Uj756kyalV1F4xrI89hfrwWZbOCvsmqnO4HNG+XDa0xNKDTHvg==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.466000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25236.003
X-MDID: 1581947016-ATLJIroPdDao
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

efx_filter_rfs_expire() is a work-function, so it being inline makes no
 sense.  It's only ever used in efx_channels.c, so move it there.
While we're at it, clean out some related unused cruft.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.h          | 18 ------------------
 drivers/net/ethernet/sfc/efx_channels.c | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 78babbe6d2d8..da54afaa3c44 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -150,24 +150,6 @@ static inline s32 efx_filter_get_rx_ids(struct efx_nic *efx,
 int efx_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
 		   u16 rxq_index, u32 flow_id);
 bool __efx_filter_rfs_expire(struct efx_channel *channel, unsigned int quota);
-static inline void efx_filter_rfs_expire(struct work_struct *data)
-{
-	struct delayed_work *dwork = to_delayed_work(data);
-	struct efx_channel *channel;
-	unsigned int time, quota;
-
-	channel = container_of(dwork, struct efx_channel, filter_work);
-	time = jiffies - channel->rfs_last_expiry;
-	quota = channel->rfs_filter_count * time / (30 * HZ);
-	if (quota >= 20 && __efx_filter_rfs_expire(channel, min(channel->rfs_filter_count, quota)))
-		channel->rfs_last_expiry += time;
-	/* Ensure we do more work eventually even if NAPI poll is not happening */
-	schedule_delayed_work(dwork, 30 * HZ);
-}
-#define efx_filter_rfs_enabled() 1
-#else
-static inline void efx_filter_rfs_expire(struct work_struct *data) {}
-#define efx_filter_rfs_enabled() 0
 #endif
 
 /* RSS contexts */
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 1b1265d94fc9..d2d738314c50 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -485,6 +485,23 @@ void efx_remove_eventq(struct efx_channel *channel)
  *
  *************************************************************************/
 
+#ifdef CONFIG_RFS_ACCEL
+static void efx_filter_rfs_expire(struct work_struct *data)
+{
+	struct delayed_work *dwork = to_delayed_work(data);
+	struct efx_channel *channel;
+	unsigned int time, quota;
+
+	channel = container_of(dwork, struct efx_channel, filter_work);
+	time = jiffies - channel->rfs_last_expiry;
+	quota = channel->rfs_filter_count * time / (30 * HZ);
+	if (quota >= 20 && __efx_filter_rfs_expire(channel, min(channel->rfs_filter_count, quota)))
+		channel->rfs_last_expiry += time;
+	/* Ensure we do more work eventually even if NAPI poll is not happening */
+	schedule_delayed_work(dwork, 30 * HZ);
+}
+#endif
+
 /* Allocate and initialise a channel structure. */
 struct efx_channel *
 efx_alloc_channel(struct efx_nic *efx, int i, struct efx_channel *old_channel)
