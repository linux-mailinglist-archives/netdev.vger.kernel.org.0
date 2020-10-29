Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D0929F3BF
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 19:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgJ2SD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 14:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgJ2SD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 14:03:27 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816FEC0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 11:03:27 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id k21so1745906wmi.1
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 11:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=9oWpFJnwqcTeEioDFrwXjjEVw20YdDZ/VKCKGD8uA8Q=;
        b=rEDdYjZH0qu19FKTm44wVWM///dbswGsz1f79O5Dp7AMbLHn+NKqFDK5Rt0Rrrb5jz
         6aMFAEg21zJpFsoKSqVdsfGT4u+N3Rj7VP4X8h3PHk+rmL1phs+geTqt3qVwoxqBqq1Y
         9nFKcnrsRzlESsehZCXbZofW35ljPefOugZebE+lquQRN9DT9IIo0C+PnZn7WZjiH7H6
         a0B7JqSox9RW4/fBH+uC9zH3n1OH6jjmdOFJzOEnaxe+9lozrmYt+Somv4KGku8jkRG5
         BK9lqla0VDQiHNMJBPbf27LJ3hYeZboNfDk8Bq6SUB0/Ece+fgY6KS6CyAbGAanH1fdR
         ocGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=9oWpFJnwqcTeEioDFrwXjjEVw20YdDZ/VKCKGD8uA8Q=;
        b=Bne7dzbntL/0gHErT4a8XBjtIovsgHTcKXfRY74paHafUjUIqqSvn75BJ0JIaC05Oa
         xFLaN6/tCb6CCDw5yUhx2ydNnJnz4biOEaTw7V3fwgD816x2iRn9uUq2Wl752G7swa8Q
         ewTuuBAi5MetAWtjd7BD3fpAlHgm4aSDqe/yLxSsgFXkhAScZdojKEXfcObPecnI3L8t
         AkBM3npkwXiTD+q2JPXTCyUxw/K04i1b7D57Pkaf/EMLH7bh7Z2XDOgWfWZfIiA/ok5T
         4qffC6oBylhiTMGIXuTIUczW1jQ+gmM1JfVFlaXHH3WcoQgfmyQfXrsjh3iSivUnsrqF
         BvGg==
X-Gm-Message-State: AOAM5335vlVUanajrPbUs/s8LATFv0imeqeIVtWFNGatDBblVWunExhT
        aYv+OfuhqkBAkbqriRZ+02+qTliD8u0=
X-Google-Smtp-Source: ABdhPJwBFZiq+qrzTSJ/2UuyXzj2TsDD9u5HmFkJRizpuj6JvOYsvjYx7iNqiL3jr/fnrfm7PBGjWw==
X-Received: by 2002:a1c:f203:: with SMTP id s3mr356610wmc.71.1603994605863;
        Thu, 29 Oct 2020 11:03:25 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:a990:f24b:87e1:a560? (p200300ea8f232800a990f24b87e1a560.dip0.t-ipconnect.de. [2003:ea:8f23:2800:a990:f24b:87e1:a560])
        by smtp.googlemail.com with ESMTPSA id v189sm1040739wmg.14.2020.10.29.11.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 11:03:25 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: use pm_runtime_put_sync in rtl_open error
 path
Message-ID: <aa093b1e-f295-5700-1cb7-954b54dd8f17@gmail.com>
Date:   Thu, 29 Oct 2020 19:02:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can safely runtime-suspend the chip if rtl_open() fails. Therefore
switch the error path to use pm_runtime_put_sync() as well.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 75df476c6..319399a03 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4701,7 +4701,7 @@ static int rtl_open(struct net_device *dev)
 	tp->TxDescArray = dma_alloc_coherent(&pdev->dev, R8169_TX_RING_BYTES,
 					     &tp->TxPhyAddr, GFP_KERNEL);
 	if (!tp->TxDescArray)
-		goto err_pm_runtime_put;
+		goto out;
 
 	tp->RxDescArray = dma_alloc_coherent(&pdev->dev, R8169_RX_RING_BYTES,
 					     &tp->RxPhyAddr, GFP_KERNEL);
@@ -4726,9 +4726,9 @@ static int rtl_open(struct net_device *dev)
 	rtl8169_up(tp);
 	rtl8169_init_counter_offsets(tp);
 	netif_start_queue(dev);
-
-	pm_runtime_put_sync(&pdev->dev);
 out:
+	pm_runtime_put_sync(&pdev->dev);
+
 	return retval;
 
 err_free_irq:
@@ -4744,8 +4744,6 @@ static int rtl_open(struct net_device *dev)
 	dma_free_coherent(&pdev->dev, R8169_TX_RING_BYTES, tp->TxDescArray,
 			  tp->TxPhyAddr);
 	tp->TxDescArray = NULL;
-err_pm_runtime_put:
-	pm_runtime_put_noidle(&pdev->dev);
 	goto out;
 }
 
-- 
2.29.1

