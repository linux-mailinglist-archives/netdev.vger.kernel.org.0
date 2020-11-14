Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DC02B30B9
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 21:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgKNUuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 15:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgKNUuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 15:50:08 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B91C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 12:50:06 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id 23so9513226wmg.1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 12:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=yZbqohHDXJo0peaT5UeaNuYrTH9axvZBMMAdSxtWAsM=;
        b=GzuwuDlmkcuAdAD7W2kMrbUyivoIYf9QaQfucB9g11xGzgL4pV86u+ejvu6l966g6a
         wn6oEsGAXjnUGa8EdFhwhCOyTFBgZuT0ZpRZiuOp1LyHe3u6el/kGl3xwwluzAWckFKr
         U554A90XuOoyXxiXrfdTpA7NQbNM4AeVRxaSldUi+3wb0CXBFftvojoDWO3c2O6TZZkY
         02nDnE1T8baNTjGzzIOtUkIN1WI/w8iR0XtXtX9PUTPENsPlvNQLFmY+jPr+9RwEi7Nc
         r7xOWdzd+rETwvcOA4UrROKsNCUz/Y4kgCEE6Crga5Q1zhNiXYm+XJe0QzzIR9IxRi8O
         +QEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=yZbqohHDXJo0peaT5UeaNuYrTH9axvZBMMAdSxtWAsM=;
        b=tgcjQF4USxdTQgBCnIvmu/R0c/3o2gIeLgLHEIkx7+Pw1F9UPxcvnrq7ohgwVSQS5G
         WseonrUWSCLsTBo8QCoYTwvS8w2psp4s5TzYzNYeIHDI5gPVz+24VMAdAJvdL4xBiq/I
         PXiV+gLyDN54fxpeedd1gp5swX6j/2Q7MtYnWzAnz/G5A6E64UCfVSGJ7v951sFGA4MS
         Rj6A+BLyai06HUVTHOjHkRLwJFrw6c933QI8KXoDzxdrxhUa0+cOfUUWsAfDVoV13WFe
         gUUMZy37cjvGG5hW71ocR2UKdcqJyM1mC7rMNFv7TtrsDlNXd6VBaOi66vU8JkVBhuO4
         Y7rQ==
X-Gm-Message-State: AOAM532m2ig+X8acUiBInl8TPUYU3ccbeHG4gYMxN9vhw3vlgAp1wYSN
        o5DK0a/NTLUUL0CqFvE/oM+TLW/dAZnZIg==
X-Google-Smtp-Source: ABdhPJxODtAF/I6wpoh2Gi2fxj7io48By2mV/JSRGMgV50tdla4/kOzTifdsbjcHgm3VmNOuTVnRpA==
X-Received: by 2002:a7b:c242:: with SMTP id b2mr8122370wmj.162.1605387004756;
        Sat, 14 Nov 2020 12:50:04 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:f440:c2bc:7fec:c7f5? (p200300ea8f232800f440c2bc7fecc7f5.dip0.t-ipconnect.de. [2003:ea:8f23:2800:f440:c2bc:7fec:c7f5])
        by smtp.googlemail.com with ESMTPSA id t23sm14077293wmn.4.2020.11.14.12.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2020 12:50:04 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: improve rtl8169_start_xmit
Message-ID: <80085451-3eaf-507a-c7c0-08d607c46fbc@gmail.com>
Date:   Sat, 14 Nov 2020 21:49:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve the following in rtl8169_start_xmit:
- tp->cur_tx can be accessed in parallel by rtl_tx(), therefore
  annotate the race by using WRITE_ONCE
- avoid checking stop_queue a second time by moving the doorbell check
- netif_stop_queue() uses atomic operation set_bit() that includes a
  full memory barrier on some platforms, therefore use
  smp_mb__after_atomic to avoid overhead

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8910e900e..940fc6590 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4226,7 +4226,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	/* rtl_tx needs to see descriptor changes before updated tp->cur_tx */
 	smp_wmb();
 
-	tp->cur_tx += frags + 1;
+	WRITE_ONCE(tp->cur_tx, tp->cur_tx + frags + 1);
 
 	stop_queue = !rtl_tx_slots_avail(tp, MAX_SKB_FRAGS);
 	if (unlikely(stop_queue)) {
@@ -4235,13 +4235,6 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 		 */
 		smp_wmb();
 		netif_stop_queue(dev);
-		door_bell = true;
-	}
-
-	if (door_bell)
-		rtl8169_doorbell(tp);
-
-	if (unlikely(stop_queue)) {
 		/* Sync with rtl_tx:
 		 * - publish queue status and cur_tx ring index (write barrier)
 		 * - refresh dirty_tx ring index (read barrier).
@@ -4249,11 +4242,15 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 		 * status and forget to wake up queue, a racing rtl_tx thread
 		 * can't.
 		 */
-		smp_mb();
+		smp_mb__after_atomic();
 		if (rtl_tx_slots_avail(tp, MAX_SKB_FRAGS))
 			netif_start_queue(dev);
+		door_bell = true;
 	}
 
+	if (door_bell)
+		rtl8169_doorbell(tp);
+
 	return NETDEV_TX_OK;
 
 err_dma_1:
-- 
2.29.2

