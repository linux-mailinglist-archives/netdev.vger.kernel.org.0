Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E1E2AFAE4
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 22:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgKKV4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 16:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbgKKV4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 16:56:37 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128A4C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 13:56:37 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id za3so4837427ejb.5
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 13:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=hki7CdSbg6o8SL7rA6DCMTk5A9tadw44iwmvBCyoxqI=;
        b=E9vwIcxhty1dGrvoEqqZWcNkhKXERWZyDKaihnEmBnj90JL7zBqfHsuMNs4cxUz4jk
         t7jNVASwF7BObaJC65RoIA8Ox4/QlfxHimQufMuB6bfflNwG9mAm22oN9Q5BblF2ow7U
         H3PniQGy+KC5qRnBF//1ouNE7B1yLqr7QFPmDBSpzjfIcHeJ8xt6yt0fheqWDB/C7Acn
         ulT6HzHgZ3tjhcOqiM63qaCLWVsQytjP856sxPGxZSfdnhif7ppTXl7gFpwVuKrkZ9L8
         ou94F24VgSJIl2mCOwvuiOP76XRw5Qe3zAqxHrpRiWJicePsjsJM9dVHBRG8SRslndKU
         1qBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=hki7CdSbg6o8SL7rA6DCMTk5A9tadw44iwmvBCyoxqI=;
        b=s98EEQI9FyHgQBGpmFn7XvneLuDRfkVs4oUMTWOKYNUXzVFTj72aWHYZxxO/4ucTGn
         npP3Bi7yc6A13SeP0DccCtyUXRNIwNpIj1gSoTZRtVM+ZM0hUNx81uyoCr7dN45vi9LJ
         DMmSs9XcGFr5OQo6yXvMiCGJ7bYPylBoPIzTNyItcUE1zj6hx2Qr9hCTYSlmVtxHV+L3
         mcAIiS7nOTyEbW3+56zTVtDBpXGOzV7SsWkbEd5NC0YaLX2y+kRykYZBp1w3mH46pKah
         nNsPYXoWs3V/oUCV6G9Fz/FpNPYgslVsUFEE9KA791J7Y+gLx1rq8nRHYt9o67Tx5NdF
         jYGg==
X-Gm-Message-State: AOAM533W+sDjBBo7FFILv6AHS7hFwq1bUYRpcnL6bIw0TOgxxFp5ruLx
        kbMDgLnAo6bN01XH9o0wRPvScKv4T2e8LA==
X-Google-Smtp-Source: ABdhPJyIj3Abj78dpch9N1pJxnMEYrxAHeNT8TaUXKDgf5bCvBCv0MWHNcAl9b+hqQ8taKWDeg50UA==
X-Received: by 2002:a17:906:831a:: with SMTP id j26mr27848714ejx.450.1605131795511;
        Wed, 11 Nov 2020 13:56:35 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:b8a2:2ad2:2cb8:3612? (p200300ea8f232800b8a22ad22cb83612.dip0.t-ipconnect.de. [2003:ea:8f23:2800:b8a2:2ad2:2cb8:3612])
        by smtp.googlemail.com with ESMTPSA id r20sm1483167edq.6.2020.11.11.13.56.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 13:56:35 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: improve rtl_tx
Message-ID: <c2e19e5e-3d3f-d663-af32-13c3374f5def@gmail.com>
Date:   Wed, 11 Nov 2020 22:56:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can simplify the for() condition and eliminate variable tx_left.
The change also considers that tp->cur_tx may be incremented by a
racing rtl8169_start_xmit().
In addition replace the write to tp->dirty_tx and the following
smp_mb() with an equivalent call to smp_store_mb(). This implicitly
adds a WRITE_ONCE() to the write.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 641c94a46..8910e900e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4362,11 +4362,11 @@ static void rtl8169_pcierr_interrupt(struct net_device *dev)
 static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 		   int budget)
 {
-	unsigned int dirty_tx, tx_left, bytes_compl = 0, pkts_compl = 0;
+	unsigned int dirty_tx, bytes_compl = 0, pkts_compl = 0;
 
 	dirty_tx = tp->dirty_tx;
 
-	for (tx_left = READ_ONCE(tp->cur_tx) - dirty_tx; tx_left; tx_left--) {
+	while (READ_ONCE(tp->cur_tx) != dirty_tx) {
 		unsigned int entry = dirty_tx % NUM_TX_DESC;
 		struct sk_buff *skb = tp->tx_skb[entry].skb;
 		u32 status;
@@ -4389,7 +4389,6 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 		netdev_completed_queue(dev, pkts_compl, bytes_compl);
 		dev_sw_netstats_tx_add(dev, pkts_compl, bytes_compl);
 
-		tp->dirty_tx = dirty_tx;
 		/* Sync with rtl8169_start_xmit:
 		 * - publish dirty_tx ring index (write barrier)
 		 * - refresh cur_tx ring index and queue status (read barrier)
@@ -4397,7 +4396,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 		 * a racing xmit thread can only have a right view of the
 		 * ring status.
 		 */
-		smp_mb();
+		smp_store_mb(tp->dirty_tx, dirty_tx);
 		if (netif_queue_stopped(dev) &&
 		    rtl_tx_slots_avail(tp, MAX_SKB_FRAGS)) {
 			netif_wake_queue(dev);
-- 
2.29.2

