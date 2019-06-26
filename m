Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A16C5726C
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 22:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfFZUSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 16:18:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60361 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfFZUSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 16:18:43 -0400
Received: from mail-qk1-f200.google.com ([209.85.222.200])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <gpiccoli@canonical.com>)
        id 1hgENM-0008PP-FE
        for netdev@vger.kernel.org; Wed, 26 Jun 2019 20:18:40 +0000
Received: by mail-qk1-f200.google.com with SMTP id i196so3939598qke.20
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 13:18:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jOAQ4OmjS1kk6QX2uM9jDZzovLwI1Wi/o+yl5VwistI=;
        b=laqyMlXg2pPIWQMV4ujWaGyBKm91UJsaf8Mwwns6lZ0z0Hgnp4MciNzeMSQrga5Qi4
         +cRtrxzAh7lQ56Upz9Vvrw+WpRhcwV0R+EOSHTFyWo32aIeSybiGw4mcFSCNRuBauHFs
         w2B0Jt/YDC3lyu0VQZMr8JGAgtKh/tc7Mv7V0EtEYjemTNBaHWqZ7xKC0HRT5DrOymoC
         xiipjzWXOSvqJQ4g/63101meBRPSnwcUEG6ma4sFZaNPrvNg9pVqysnB0yTekIngsq/C
         miWHlTxJ66rUEkdtERoBNypoBGZgINCagBRgcr9x5FcSSU/yIFixNdmHU9Y9JTDaNBGK
         6EMw==
X-Gm-Message-State: APjAAAUUV3XoK5a6BcVZvCR4z1SI1re05a9fo1XZxVHY+NDjec4SLP0p
        cUqgIIu7efmApUxY6q0NyX6u9lzHYTYdiPi9KHg5zRDfecLcldIp3cdfm0liQzgekivOkpjjT6+
        yel+BZhD6RTtpJIbnjGLqoUyAlMHBwEP5ig==
X-Received: by 2002:ac8:30d2:: with SMTP id w18mr5530386qta.296.1561580319285;
        Wed, 26 Jun 2019 13:18:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy0C5mBh+zLam2dIayTDh33yeW/EPC2orbWGFmWqBZzpNlQoXyuU8LAqHKb+zckRO8vmumAXg==
X-Received: by 2002:ac8:30d2:: with SMTP id w18mr5530364qta.296.1561580319015;
        Wed, 26 Jun 2019 13:18:39 -0700 (PDT)
Received: from localhost ([179.98.77.238])
        by smtp.gmail.com with ESMTPSA id r39sm12344124qtc.87.2019.06.26.13.18.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 13:18:38 -0700 (PDT)
From:   "Guilherme G. Piccoli" <gpiccoli@canonical.com>
To:     GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        skalluru@marvell.com
Cc:     aelior@marvell.com, gpiccoli@canonical.com,
        jay.vosburgh@canonical.com
Subject: [PATCH V3] bnx2x: Prevent ptp_task to be rescheduled indefinitely
Date:   Wed, 26 Jun 2019 17:18:35 -0300
Message-Id: <20190626201835.31660-1-gpiccoli@canonical.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently bnx2x ptp worker tries to read a register with timestamp
information in case of TX packet timestamping and in case it fails,
the routine reschedules itself indefinitely. This was reported as a
kworker always at 100% of CPU usage, which was narrowed down to be
bnx2x ptp_task.

By following the ioctl handler, we could narrow down the problem to
an NTP tool (chrony) requesting HW timestamping from bnx2x NIC with
RX filter zeroed; this isn't reproducible for example with ptp4l
(from linuxptp) since this tool requests a supported RX filter.
It seems NIC FW timestamp mechanism cannot work well with
RX_FILTER_NONE - driver's PTP filter init routine skips a register
write to the adapter if there's not a supported filter request.

This patch addresses the problem of bnx2x ptp thread's everlasting
reschedule by retrying the register read 10 times; between the read
attempts the thread sleeps for an increasing amount of time starting
in 1ms to give FW some time to perform the timestamping. If it still
fails after all retries, we bail out in order to prevent an unbound
resource consumption from bnx2x.

The patch also adds an ethtool statistic for accounting the skipped
TX timestamp packets and it reduces the priority of timestamping
error messages to prevent log flooding. The code was tested using
both linuxptp and chrony.

Reported-and-tested-by: Przemyslaw Hausman <przemyslaw.hausman@canonical.com>
Suggested-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
---

Sudarsana, thanks again for your feedback. I've reduced the sleep times
to start in 1ms and goes up to 512ms - the sum of sleep times is 1023ms,
but due to the inherent overhead in sleeping/waking-up procedure, I've
measured the total delay in the register read loop (on bnx2x_ptp_task)
to be ~1.6 seconds.  It is almost the 2s value you first suggested as
PTP_TIMEOUT.

 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 12 +++++--
 .../ethernet/broadcom/bnx2x/bnx2x_ethtool.c   |  4 ++-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 36 ++++++++++++++-----
 .../net/ethernet/broadcom/bnx2x/bnx2x_stats.h |  3 ++
 4 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 008ad0ca89ba..6751cd04e8d8 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -3857,9 +3857,17 @@ netdev_tx_t bnx2x_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
 		if (!(bp->flags & TX_TIMESTAMPING_EN)) {
-			BNX2X_ERR("Tx timestamping was not enabled, this packet will not be timestamped\n");
+			bp->eth_stats.ptp_skip_tx_ts++;
+			netdev_err_once(bp->dev,
+					"Tx timestamping isn't enabled, this packet won't be timestamped\n");
+			DP(BNX2X_MSG_PTP,
+			   "Tx timestamping isn't enabled, this packet won't be timestamped\n");
 		} else if (bp->ptp_tx_skb) {
-			BNX2X_ERR("The device supports only a single outstanding packet to timestamp, this packet will not be timestamped\n");
+			bp->eth_stats.ptp_skip_tx_ts++;
+			netdev_err_once(bp->dev,
+					"Device supports only a single outstanding packet to timestamp, this packet won't be timestamped\n");
+			DP(BNX2X_MSG_PTP,
+			   "Device supports only a single outstanding packet to timestamp, this packet won't be timestamped\n");
 		} else {
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 			/* schedule check for Tx timestamp */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
index 51fc845de31a..4a0ba6801c9e 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
@@ -182,7 +182,9 @@ static const struct {
 	{ STATS_OFFSET32(driver_filtered_tx_pkt),
 				4, false, "driver_filtered_tx_pkt" },
 	{ STATS_OFFSET32(eee_tx_lpi),
-				4, true, "Tx LPI entry count"}
+				4, true, "Tx LPI entry count"},
+	{ STATS_OFFSET32(ptp_skip_tx_ts),
+				4, false, "ptp_skipped_tx_tstamp" },
 };
 
 #define BNX2X_NUM_STATS		ARRAY_SIZE(bnx2x_stats_arr)
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 03ac10b1cd1e..af6e7a950a28 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -15214,11 +15214,27 @@ static void bnx2x_ptp_task(struct work_struct *work)
 	u32 val_seq;
 	u64 timestamp, ns;
 	struct skb_shared_hwtstamps shhwtstamps;
+	bool bail = true;
+	int i;
 
-	/* Read Tx timestamp registers */
-	val_seq = REG_RD(bp, port ? NIG_REG_P1_TLLH_PTP_BUF_SEQID :
-			 NIG_REG_P0_TLLH_PTP_BUF_SEQID);
-	if (val_seq & 0x10000) {
+	/* FW may take a while to complete timestamping; try a bit and if it's
+	 * still not complete, may indicate an error state - bail out then.
+	 */
+	for (i = 0; i < 10; i++) {
+		/* Read Tx timestamp registers */
+		val_seq = REG_RD(bp, port ? NIG_REG_P1_TLLH_PTP_BUF_SEQID :
+				 NIG_REG_P0_TLLH_PTP_BUF_SEQID);
+		if (val_seq & 0x10000) {
+			bail = false;
+			break;
+		}
+
+		if (!(i % 4)) /* Avoid log flood */
+			DP(BNX2X_MSG_PTP, "There's no valid Tx timestamp yet\n");
+		msleep(1 << i);
+	}
+
+	if (!bail) {
 		/* There is a valid timestamp value */
 		timestamp = REG_RD(bp, port ? NIG_REG_P1_TLLH_PTP_BUF_TS_MSB :
 				   NIG_REG_P0_TLLH_PTP_BUF_TS_MSB);
@@ -15233,16 +15249,18 @@ static void bnx2x_ptp_task(struct work_struct *work)
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 		shhwtstamps.hwtstamp = ns_to_ktime(ns);
 		skb_tstamp_tx(bp->ptp_tx_skb, &shhwtstamps);
-		dev_kfree_skb_any(bp->ptp_tx_skb);
-		bp->ptp_tx_skb = NULL;
 
 		DP(BNX2X_MSG_PTP, "Tx timestamp, timestamp cycles = %llu, ns = %llu\n",
 		   timestamp, ns);
 	} else {
-		DP(BNX2X_MSG_PTP, "There is no valid Tx timestamp yet\n");
-		/* Reschedule to keep checking for a valid timestamp value */
-		schedule_work(&bp->ptp_task);
+		DP(BNX2X_MSG_PTP,
+		   "Tx timestamp is not recorded (register read=%u)\n",
+		   val_seq);
+		bp->eth_stats.ptp_skip_tx_ts++;
 	}
+
+	dev_kfree_skb_any(bp->ptp_tx_skb);
+	bp->ptp_tx_skb = NULL;
 }
 
 void bnx2x_set_rx_ts(struct bnx2x *bp, struct sk_buff *skb)
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
index b2644ed13d06..d55e63692cf3 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
@@ -207,6 +207,9 @@ struct bnx2x_eth_stats {
 	u32 driver_filtered_tx_pkt;
 	/* src: Clear-on-Read register; Will not survive PMF Migration */
 	u32 eee_tx_lpi;
+
+	/* PTP */
+	u32 ptp_skip_tx_ts;
 };
 
 struct bnx2x_eth_q_stats {
-- 
2.22.0

