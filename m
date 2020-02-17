Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F001613BC
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 14:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgBQNnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 08:43:19 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:47022 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727953AbgBQNnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 08:43:19 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6C8F76C0075;
        Mon, 17 Feb 2020 13:43:17 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 17 Feb
 2020 13:43:13 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 1/2] sfc: only schedule asynchronous filter work if
 needed
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3d83a647-beb0-6de7-39f7-c960e3299dc7@solarflare.com>
Message-ID: <6ed9e69a-4405-a904-21d8-5f9baf2e3ed2@solarflare.com>
Date:   Mon, 17 Feb 2020 13:43:10 +0000
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
X-TM-AS-Result: No-5.282600-8.000000-10
X-TMASE-MatchedRID: Qbco1hwQouYnK76E4RHdvxi3rdbpQXD7rJPj1l6ESRljLp8Cm8vwFwoe
        RRhCZWIBNAOocBQj98a6M1wBej8T3SHhSBQfglfsA9lly13c/gHYuVu0X/rOkIvFa5XXUMbGhGz
        G3wY/cLfzP4JHeobH6CRCxdq76nqm/0NC8kkf7EkJuplsyNNdx/EJfOSvCp8zy5JfHvVu9Iu5Qb
        /vPOg/coI1HVe7njr3fzzZvLDv3OaT4QuBHRkf9qubsOtSWY2QkZOl7WKIImrvXOvQVlExsAtuK
        BGekqUpOlxBO2IcOBYMfqCwAH7Mad8Sx/7jyFZ0/E1WwmhtPer1KCytG1H0/vgparVLtz2fQwym
        txuJ6y0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.282600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25236.003
X-MDID: 1581946998-CTKx0U029BJj
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prevent excessive CPU time spent running a workitem with nothing to do.

We avoid any races by keeping the same check in efx_filter_rfs_expire().

Suggested-by: Martin Habets <mhabets@solarflare.com>
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.h          | 2 +-
 drivers/net/ethernet/sfc/efx_channels.c | 8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index f1bdb04efbe4..78babbe6d2d8 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -159,7 +159,7 @@ static inline void efx_filter_rfs_expire(struct work_struct *data)
 	channel = container_of(dwork, struct efx_channel, filter_work);
 	time = jiffies - channel->rfs_last_expiry;
 	quota = channel->rfs_filter_count * time / (30 * HZ);
-	if (quota > 20 && __efx_filter_rfs_expire(channel, min(channel->rfs_filter_count, quota)))
+	if (quota >= 20 && __efx_filter_rfs_expire(channel, min(channel->rfs_filter_count, quota)))
 		channel->rfs_last_expiry += time;
 	/* Ensure we do more work eventually even if NAPI poll is not happening */
 	schedule_delayed_work(dwork, 30 * HZ);
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index aeb5e8aa2f2a..1b1265d94fc9 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -1166,6 +1166,9 @@ static int efx_poll(struct napi_struct *napi, int budget)
 	struct efx_channel *channel =
 		container_of(napi, struct efx_channel, napi_str);
 	struct efx_nic *efx = channel->efx;
+#ifdef CONFIG_RFS_ACCEL
+	unsigned int time;
+#endif
 	int spent;
 
 	netif_vdbg(efx, intr, efx->net_dev,
@@ -1185,7 +1188,10 @@ static int efx_poll(struct napi_struct *napi, int budget)
 
 #ifdef CONFIG_RFS_ACCEL
 		/* Perhaps expire some ARFS filters */
-		mod_delayed_work(system_wq, &channel->filter_work, 0);
+		time = jiffies - channel->rfs_last_expiry;
+		/* Would our quota be >= 20? */
+		if (channel->rfs_filter_count * time >= 600 * HZ)
+			mod_delayed_work(system_wq, &channel->filter_work, 0);
 #endif
 
 		/* There is no race here; although napi_disable() will

