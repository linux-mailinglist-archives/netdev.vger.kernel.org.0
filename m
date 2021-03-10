Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A803340C1
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 15:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhCJOvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 09:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbhCJOu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 09:50:57 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFC0C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 06:50:57 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id l12so28507198edt.3
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 06:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MrbkQsyDQbRWH3cY6hRKJgB0osGycZ7aLgmVqGraerU=;
        b=YrA+WPKgF30D6mZB2n2SrLtcZnnd+1/pA+vF7D53khTPMt5Bg/8aTANYQxGmf7xu9v
         iPFXQSxAlLfkiJuzSSnsNc+s9QpR+CyyDg7d3UB4bjpFW7KoA5PudT0UFj+eyXrSuaGo
         8jBXfJZs9U011cIzjPrmJHXGfOWdfF+u+KZLsska5/OjqgQxoRlva/PSwhdtEdD16/Fi
         fHQqxHISVwnZwP4o+dzcRn8/5ongzC9NaOvE4Uu7ioT+3OSerbyHaxeJIcwqN0tZUi++
         JbXfIr5vriMosVa2nHh0Fk0vQiDMtyCNie8t+CoQ7yX8JcQ1gDIEOLuVqun7nOnq22Us
         yNjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MrbkQsyDQbRWH3cY6hRKJgB0osGycZ7aLgmVqGraerU=;
        b=Z3vN70H2L9i64q8SrJnl+O56CU3MRXuBaUqUrBorRON7Uelxpz0DThGpCwmhTT0IpV
         y2fcdUITN+mfueb5TAEesFAiK4MxGFX/TGqXbR7VB0oZbm33jvoPt8hKW/fxwJ7D/HvQ
         0vkYE241u4QHEHxmCStflOz8782QSWT/6cmZJPJjMDbCz47bhSuBAoZCQEFdFXH6ROvP
         JoweNy2aUq8Z/wMueaZMx/iPK/f48g9Vae0gxhkIqoCIZv+2OjVUVZCuY26Wc+T64hKX
         XRI3eCO0A5PEeprl/hWexP+gDsbvq/bDzKw3Ilysh7xMlZ0CyDbv2YGVsxwFu8fh+sMm
         1GWQ==
X-Gm-Message-State: AOAM530yNkiJLe0rD3aVTu298zJNZJFfghmg2qJk0+rSykcfHj/1ecps
        rD4vAVsTOjC3hFCOMkectks=
X-Google-Smtp-Source: ABdhPJzh755uR1RzdzZrnMZH7H1a2PceCSk+EWh34U4Ba55PzSSO19yWTaJ/n6xNebSjyOscskNBrQ==
X-Received: by 2002:a05:6402:375:: with SMTP id s21mr3673556edw.287.1615387855714;
        Wed, 10 Mar 2021 06:50:55 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id g1sm11087149edh.31.2021.03.10.06.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 06:50:55 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next] net: add a helper to avoid issues with HW TX timestamping and SO_TXTIME
Date:   Wed, 10 Mar 2021 16:50:44 +0200
Message-Id: <20210310145044.614429-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As explained in commit 29d98f54a4fe ("net: enetc: allow hardware
timestamping on TX queues with tc-etf enabled"), hardware TX
timestamping requires an skb with skb->tstamp = 0. When a packet is sent
with SO_TXTIME, the skb->skb_mstamp_ns corrupts the value of skb->tstamp,
so the drivers need to explicitly reset skb->tstamp to zero after
consuming the TX time.

Create a helper named skb_txtime_consumed() which does just that. All
drivers which offload TC_SETUP_QDISC_ETF should implement it, and it
would make it easier to assess during review whether they do the right
thing in order to be compatible with hardware timestamping or not.

Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 8 ++------
 drivers/net/ethernet/intel/igb/igb_main.c    | 2 +-
 drivers/net/ethernet/intel/igc/igc_main.c    | 2 +-
 include/net/pkt_sched.h                      | 9 +++++++++
 4 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e85dfccb9ed1..5a54976e6a28 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -5,6 +5,7 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/vmalloc.h>
+#include <net/pkt_sched.h>
 
 /* ENETC overhead: optional extension BD + 1 BD gap */
 #define ENETC_TXBDS_NEEDED(val)	((val) + 2)
@@ -293,12 +294,7 @@ static void enetc_tstamp_tx(struct sk_buff *skb, u64 tstamp)
 	if (skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) {
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 		shhwtstamps.hwtstamp = ns_to_ktime(tstamp);
-		/* Ensure skb_mstamp_ns, which might have been populated with
-		 * the txtime, is not mistaken for a software timestamp,
-		 * because this will prevent the dispatch of our hardware
-		 * timestamp to the socket.
-		 */
-		skb->tstamp = ktime_set(0, 0);
+		skb_txtime_consumed(skb);
 		skb_tstamp_tx(skb, &shhwtstamps);
 	}
 }
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 878b31d534ec..369533feb4f2 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -5856,7 +5856,7 @@ static void igb_tx_ctxtdesc(struct igb_ring *tx_ring,
 	 */
 	if (tx_ring->launchtime_enable) {
 		ts = ktime_to_timespec64(first->skb->tstamp);
-		first->skb->tstamp = ktime_set(0, 0);
+		skb_txtime_consumed(first->skb);
 		context_desc->seqnum_seed = cpu_to_le32(ts.tv_nsec / 32);
 	} else {
 		context_desc->seqnum_seed = 0;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 7ac9597ddb84..059ffcfb0bda 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -941,7 +941,7 @@ static void igc_tx_ctxtdesc(struct igc_ring *tx_ring,
 		struct igc_adapter *adapter = netdev_priv(tx_ring->netdev);
 		ktime_t txtime = first->skb->tstamp;
 
-		first->skb->tstamp = ktime_set(0, 0);
+		skb_txtime_consumed(first->skb);
 		context_desc->launch_time = igc_tx_launchtime(adapter,
 							      txtime);
 	} else {
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 15b1b30f454e..f5c1bee0cd6a 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -188,4 +188,13 @@ struct tc_taprio_qopt_offload *taprio_offload_get(struct tc_taprio_qopt_offload
 						  *offload);
 void taprio_offload_free(struct tc_taprio_qopt_offload *offload);
 
+/* Ensure skb_mstamp_ns, which might have been populated with the txtime, is
+ * not mistaken for a software timestamp, because this will otherwise prevent
+ * the dispatch of hardware timestamps to the socket.
+ */
+static inline void skb_txtime_consumed(struct sk_buff *skb)
+{
+	skb->tstamp = ktime_set(0, 0);
+}
+
 #endif
-- 
2.25.1

