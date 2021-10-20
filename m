Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AC84345A9
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 09:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhJTHHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 03:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhJTHG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 03:06:59 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FAFC06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 00:04:45 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634713484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SegCl+BCqhHxK6dSfWI75zjWX2xeRTibY0tvPU0f2X4=;
        b=CAlPzPnZHNWJIX5Qb5ZtRH5TCjny28qEwjn8IxTVhb6lqPGdjCy+Vo4MCfwefdr00HGIKm
        GrnBxeqlYZPOdrnBmBBg5QSu0mLvu00BIjPsXOv3lmGSLNJP/vCdwlL96U2lmlTn2OwvcW
        GEBWCF1/RgOL7UhnrUxo0LROJ49Sxhq8IWRAFENmiJiI9sqBAmkNXx+2xlG1+gsMj5LMMJ
        AKlkF83csKvtg9D2ak2eMAB1ZDx27BbEUjI9WnQ74uEcOwgAWUq5JuZyY1fupRSzZ1Lp20
        11XBj/QtynG0UGs7ncfERWELPVrxsSbzWuJHDRmKdE8DhQ7Iw9CJ0wRqhrFzbQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634713484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SegCl+BCqhHxK6dSfWI75zjWX2xeRTibY0tvPU0f2X4=;
        b=/N9DXcjCBi0g4YT0tkvIO5zLX3VxIHuUTt9UgCPZJHl+b3taAYDCzObu1e+8Vls41xbyWH
        deHkGj41g6tIK7Ag==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net] net: stmmac: Fix E2E delay mechanism
Date:   Wed, 20 Oct 2021 09:04:33 +0200
Message-Id: <20211020070433.71398-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When utilizing End to End delay mechanism, the following error messages show up:

|root@ehl1:~# ptp4l --tx_timestamp_timeout=50 -H -i eno2 -E -m
|ptp4l[950.573]: selected /dev/ptp3 as PTP clock
|ptp4l[950.586]: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
|ptp4l[950.586]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
|ptp4l[952.879]: port 1: new foreign master 001395.fffe.4897b4-1
|ptp4l[956.879]: selected best master clock 001395.fffe.4897b4
|ptp4l[956.879]: port 1: assuming the grand master role
|ptp4l[956.879]: port 1: LISTENING to GRAND_MASTER on RS_GRAND_MASTER
|ptp4l[962.017]: port 1: received DELAY_REQ without timestamp
|ptp4l[962.273]: port 1: received DELAY_REQ without timestamp
|ptp4l[963.090]: port 1: received DELAY_REQ without timestamp

Commit f2fb6b6275eb ("net: stmmac: enable timestamp snapshot for required PTP
packets in dwmac v5.10a") already addresses this problem for the dwmac
v5.10. However, same holds true for all dwmacs above version v4.10. Correct the
check accordingly. Afterwards everything works as expected.

Tested on Intel Atom(R) x6414RE Processor.

Fixes: 14f347334bf2 ("net: stmmac: Correctly take timestamp for PTPv2")
Fixes: f2fb6b6275eb ("net: stmmac: enable timestamp snapshot for required PTP packets in dwmac v5.10a")
Suggested-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index eb3b7bf771d7..3d67d1fa3690 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -736,7 +736,7 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 			config.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
 			ptp_v2 = PTP_TCR_TSVER2ENA;
 			snap_type_sel = PTP_TCR_SNAPTYPSEL_1;
-			if (priv->synopsys_id != DWMAC_CORE_5_10)
+			if (priv->synopsys_id < DWMAC_CORE_4_10)
 				ts_event_en = PTP_TCR_TSEVNTENA;
 			ptp_over_ipv4_udp = PTP_TCR_TSIPV4ENA;
 			ptp_over_ipv6_udp = PTP_TCR_TSIPV6ENA;
-- 
2.30.2

