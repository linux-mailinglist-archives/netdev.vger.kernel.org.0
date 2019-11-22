Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4CB71076D9
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfKVR5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:57:49 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:36280 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbfKVR5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:57:49 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 039CB300069;
        Fri, 22 Nov 2019 17:57:48 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 22 Nov
 2019 17:57:43 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 4/4] sfc: do ARFS expiry work occasionally even
 without NAPI poll
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <dahern@digitalocean.com>
References: <a41f9c29-db34-a2e4-1abd-bfe1a33b442e@solarflare.com>
Message-ID: <65f2d84e-4e1f-9f58-da8e-a66d73265710@solarflare.com>
Date:   Fri, 22 Nov 2019 17:57:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <a41f9c29-db34-a2e4-1abd-bfe1a33b442e@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25058.003
X-TM-AS-Result: No-7.038600-8.000000-10
X-TMASE-MatchedRID: 0ApEILD83VB8m+cg4DIARFD5LQ3Tl9H79OmDAzguGMlRD5heJnxuK2Gf
        tP5z/8TG8XVI39JCRnSjfNAVYAJRAr+Q0YdVmuyWnFVnNmvv47tLXPA26IG0hN9RlPzeVuQQj78
        +1uscT5Jt0JJWgZAGgg5Q7W8dBYFUyhs+gnQcjAIkOFAoKA9tAnVkVJ5M7LrRNiymK3UPD2cyp6
        /v309JXVt1JyrphUxuJnuVIraYm5DplnRmy5tzbBIRh9wkXSlFZ/JREBjQWsbUlVJM/QT13uvt+
        NYpsLRFgIDkAAVDEfWbqstpiCER9hTBVEIvqWphngIgpj8eDcC063Wh9WVqgtZE3xJMmmXc+gtH
        j7OwNO31Kzk40dEY9S3oYaXmV8vsfvwWnIFk3UTPYrAHxeTKo9t8ujQKLssz
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.038600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25058.003
X-MDID: 1574445468-mylzsxjV47ZG
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there's no traffic on a channel, its ARFS expiry work will never get
 scheduled by efx_poll() as that isn't being run.
So make efx_filter_rfs_expire() reschedule itself to run after 30 seconds.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c        |  8 ++++----
 drivers/net/ethernet/sfc/efx.h        | 10 +++++++---
 drivers/net/ethernet/sfc/net_driver.h |  2 +-
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 38d186b949be..992c773620ec 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -355,7 +355,7 @@ static int efx_poll(struct napi_struct *napi, int budget)
 
 #ifdef CONFIG_RFS_ACCEL
 		/* Perhaps expire some ARFS filters */
-		schedule_work(&channel->filter_work);
+		mod_delayed_work(system_wq, &channel->filter_work, 0);
 #endif
 
 		/* There is no race here; although napi_disable() will
@@ -487,7 +487,7 @@ efx_alloc_channel(struct efx_nic *efx, int i, struct efx_channel *old_channel)
 	}
 
 #ifdef CONFIG_RFS_ACCEL
-	INIT_WORK(&channel->filter_work, efx_filter_rfs_expire);
+	INIT_DELAYED_WORK(&channel->filter_work, efx_filter_rfs_expire);
 #endif
 
 	rx_queue = &channel->rx_queue;
@@ -533,7 +533,7 @@ efx_copy_channel(const struct efx_channel *old_channel)
 	memset(&rx_queue->rxd, 0, sizeof(rx_queue->rxd));
 	timer_setup(&rx_queue->slow_fill, efx_rx_slow_fill, 0);
 #ifdef CONFIG_RFS_ACCEL
-	INIT_WORK(&channel->filter_work, efx_filter_rfs_expire);
+	INIT_DELAYED_WORK(&channel->filter_work, efx_filter_rfs_expire);
 #endif
 
 	return channel;
@@ -1994,7 +1994,7 @@ static void efx_remove_filters(struct efx_nic *efx)
 	struct efx_channel *channel;
 
 	efx_for_each_channel(channel, efx) {
-		flush_work(&channel->filter_work);
+		cancel_delayed_work_sync(&channel->filter_work);
 		kfree(channel->rps_flow_id);
 	}
 #endif
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index e58c2b6d64d9..2dd8d5002315 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -169,13 +169,17 @@ int efx_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
 bool __efx_filter_rfs_expire(struct efx_channel *channel, unsigned int quota);
 static inline void efx_filter_rfs_expire(struct work_struct *data)
 {
-	struct efx_channel *channel = container_of(data, struct efx_channel,
-						   filter_work);
-	unsigned int time = jiffies - channel->rfs_last_expiry, quota;
+	struct delayed_work *dwork = to_delayed_work(data);
+	struct efx_channel *channel;
+	unsigned int time, quota;
 
+	channel = container_of(dwork, struct efx_channel, filter_work);
+	time = jiffies - channel->rfs_last_expiry;
 	quota = channel->rfs_filter_count * time / (30 * HZ);
 	if (quota > 20 && __efx_filter_rfs_expire(channel, min(channel->rfs_filter_count, quota)))
 		channel->rfs_last_expiry += time;
+	/* Ensure we do more work eventually even if NAPI poll is not happening */
+	schedule_delayed_work(dwork, 30 * HZ);
 }
 #define efx_filter_rfs_enabled() 1
 #else
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index ccd480e699d3..1f88212be085 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -501,7 +501,7 @@ struct efx_channel {
 	unsigned int rfs_expire_index;
 	unsigned int n_rfs_succeeded;
 	unsigned int n_rfs_failed;
-	struct work_struct filter_work;
+	struct delayed_work filter_work;
 #define RPS_FLOW_ID_INVALID 0xFFFFFFFF
 	u32 *rps_flow_id;
 #endif
