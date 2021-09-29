Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BF341C450
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343592AbhI2MK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:10:28 -0400
Received: from www381.your-server.de ([78.46.137.84]:41716 "EHLO
        www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343603AbhI2MKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 08:10:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=metafoo.de;
         s=default2002; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References;
        bh=BRk1cIZ+WlfuEt5CS+iEtvNUgYm7DbziRcTnkcuyQSg=; b=fzM4X6Jj2Wm1VtlB7HCbwYTvng
        jfsfcu9bNtWxf1KJm88dZTIxpeSfNu21+Ba8fGyK27a3R3h5dt/qmbP95DRitJMCd/K6/PaE+MKXS
        kbETOw6Msgx65bycFEB0hU1579BCBexiLXKUHtV9d0AeQ2iKfTHq22z1gnBtCGIdb4Pgr2qIoAK6h
        sRPvk17wMpg14bjiCgT57GkzCT6kt2krBtvxuQYnUruxI/66geFBStxPrXBH70PZp7D4Qq987rOIP
        EITxYySMh0emm3pCCNvxIks4pzpgm/J1UBX6YJtjSuQ3naXgZUv701bq1Lxo9SsT4i1CbQMT+hFCG
        +o4+ccIA==;
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www381.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <lars@metafoo.de>)
        id 1mVYO4-0009ZA-3A; Wed, 29 Sep 2021 14:08:36 +0200
Received: from [82.135.83.152] (helo=lars-desktop.fritz.box)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <lars@metafoo.de>)
        id 1mVYO3-000US1-TS; Wed, 29 Sep 2021 14:08:35 +0200
From:   Lars-Peter Clausen <lars@metafoo.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        netdev@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] net: macb: ptp: Switch to gettimex64() interface
Date:   Wed, 29 Sep 2021 14:07:39 +0200
Message-Id: <20210929120739.22168-1-lars@metafoo.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: lars@metafoo.de
X-Virus-Scanned: Clear (ClamAV 0.103.3/26307/Wed Sep 29 11:09:54 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macb PTP support currently implements the `gettime64` callback to allow
to retrieve the hardware clock time. Update the implementation to provide
the `gettimex64` callback instead.

The difference between the two is that with `gettime64` a snapshot of the
system clock is taken before and after invoking the callback. Whereas
`gettimex64` expects the callback itself to take the snapshots.

To get the time from the macb Ethernet core multiple register accesses have
to be done. Only one of which will happen at the time reported by the
function. This leads to a non-symmetric delay and adds a slight offset
between the hardware and system clock time when using the `gettime64`
method. This offset can be a few 100 nanoseconds. Switching to the
`gettimex64` method allows for a more precise correlation of the hardware
and system clocks and results in a lower offset between the two.

On a Xilinx ZynqMP system `phc2sys` reports a delay of 1120 ns before and
300 ns after the patch. With the latter being mostly symmetric.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/net/ethernet/cadence/macb_ptp.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index c2e1f163bb14..095c5a2144a7 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -38,7 +38,8 @@ static struct macb_dma_desc_ptp *macb_ptp_desc(struct macb *bp,
 	return NULL;
 }
 
-static int gem_tsu_get_time(struct ptp_clock_info *ptp, struct timespec64 *ts)
+static int gem_tsu_get_time(struct ptp_clock_info *ptp, struct timespec64 *ts,
+			    struct ptp_system_timestamp *sts)
 {
 	struct macb *bp = container_of(ptp, struct macb, ptp_clock_info);
 	unsigned long flags;
@@ -46,7 +47,9 @@ static int gem_tsu_get_time(struct ptp_clock_info *ptp, struct timespec64 *ts)
 	u32 secl, sech;
 
 	spin_lock_irqsave(&bp->tsu_clk_lock, flags);
+	ptp_read_system_prets(sts);
 	first = gem_readl(bp, TN);
+	ptp_read_system_postts(sts);
 	secl = gem_readl(bp, TSL);
 	sech = gem_readl(bp, TSH);
 	second = gem_readl(bp, TN);
@@ -56,7 +59,9 @@ static int gem_tsu_get_time(struct ptp_clock_info *ptp, struct timespec64 *ts)
 		/* if so, use later read & re-read seconds
 		 * (assume all done within 1s)
 		 */
+		ptp_read_system_prets(sts);
 		ts->tv_nsec = gem_readl(bp, TN);
+		ptp_read_system_postts(sts);
 		secl = gem_readl(bp, TSL);
 		sech = gem_readl(bp, TSH);
 	} else {
@@ -161,7 +166,7 @@ static int gem_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	}
 
 	if (delta > TSU_NSEC_MAX_VAL) {
-		gem_tsu_get_time(&bp->ptp_clock_info, &now);
+		gem_tsu_get_time(&bp->ptp_clock_info, &now, NULL);
 		now = timespec64_add(now, then);
 
 		gem_tsu_set_time(&bp->ptp_clock_info,
@@ -192,7 +197,7 @@ static const struct ptp_clock_info gem_ptp_caps_template = {
 	.pps		= 1,
 	.adjfine	= gem_ptp_adjfine,
 	.adjtime	= gem_ptp_adjtime,
-	.gettime64	= gem_tsu_get_time,
+	.gettimex64	= gem_tsu_get_time,
 	.settime64	= gem_tsu_set_time,
 	.enable		= gem_ptp_enable,
 };
@@ -251,7 +256,7 @@ static int gem_hw_timestamp(struct macb *bp, u32 dma_desc_ts_1,
 	 * The timestamp only contains lower few bits of seconds,
 	 * so add value from 1588 timer
 	 */
-	gem_tsu_get_time(&bp->ptp_clock_info, &tsu);
+	gem_tsu_get_time(&bp->ptp_clock_info, &tsu, NULL);
 
 	/* If the top bit is set in the timestamp,
 	 * but not in 1588 timer, it has rolled over,
-- 
2.20.1

