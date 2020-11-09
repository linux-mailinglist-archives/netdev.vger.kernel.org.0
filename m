Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFAA2AC60C
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 21:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgKIUid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 15:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbgKIUic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 15:38:32 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B48C0613CF;
        Mon,  9 Nov 2020 12:38:32 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id m65so6992100qte.11;
        Mon, 09 Nov 2020 12:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gMW3pk1wRUoLgj0dOxEf2J+Wx3p/8/WsmXDMapxJ2ec=;
        b=j6BwfuHNd7EIXx0fjylxPtKiYcgZGwwVsW0yk1t4qOj8R/ptKNRFNe9XaVtz83DDrb
         BQZzBn1Mx/l4uTdfHwHtDd10Eh3rMsmhp4Ef4frdnzFa7a/VvDpm/+ug7N3hGPHJNYzY
         7WlzqpIQg0rnUuMUs0ceFc5wptiJmONYtYWCNwQTWDZULESZHG3ic2MeIV0uW55FxJHC
         o2tWdqipayLTOywzSwc/o4pvC4ZARa7RC4ew2vWs/mA+WY1rO3nszziBILoSDOSSnU/j
         y/geSKgVBmNu8wiJwmJLLQHZf0XfGrSBWFmac5uWzt2obaXFp58LV0QlTGyIVEzbyyi4
         h0NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gMW3pk1wRUoLgj0dOxEf2J+Wx3p/8/WsmXDMapxJ2ec=;
        b=MlpMBev34ZIx+Bo5EHqaoklnF4LZJrnEx2ICP7XmQQ7oK4iiC0QxC4pvtSlmT9XpK/
         SgWBrtcoTlV2DIyvuofJlNlypijtBxVLq+CSXERMlx7XWZn0IBWRtXeCK6TZZeOATA5A
         cE2mfUH0V1iLSsy2ZOCtlNZzdhCTcgW6E4P4075XdBpf3mbsEUhXRzpqcq1UGOKXcxlE
         75yxH+5n0xQsOsXJ/MjzLSylqfMQDF1dTZDqsD3oo+aHRLSYSODMIkIFlE+L8xnLhmi0
         JrHqXPt3DBP47yXhxCo/xXGtatIzqZuFCrrvjTqbG46GWJawKeVNOthJjfzdO49L5EPd
         IqKg==
X-Gm-Message-State: AOAM5327109/35AvxTBuENCtcvFuHW8Kkmp+7S2DwZeYb3eG+5eNrhcH
        xj9wot972+WgObphoU+sCFk=
X-Google-Smtp-Source: ABdhPJzPmF4m7q3cvnahmyDVo4UMO5mkHR2ap6GMuqcisSxLG4PguplAq+Y0ex2MoKrZ27yul22c4Q==
X-Received: by 2002:aed:3a63:: with SMTP id n90mr15505367qte.133.1604954311887;
        Mon, 09 Nov 2020 12:38:31 -0800 (PST)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id h82sm6952821qke.109.2020.11.09.12.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 12:38:31 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v1] lan743x: fix "BUG: invalid wait context" when setting rx mode
Date:   Mon,  9 Nov 2020 15:38:28 -0500
Message-Id: <20201109203828.5115-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

In the net core, the struct net_device_ops -> ndo_set_rx_mode()
callback is called with the dev->addr_list_lock spinlock held.

However, this driver's ndo_set_rx_mode callback eventually calls
lan743x_dp_write(), which acquires a mutex. Mutex acquisition
may sleep, and this is not allowed when holding a spinlock.

Fix by removing the dp_lock mutex entirely. Its purpose is to
prevent concurrent accesses to the data port. No concurrent
accesses are possible, because the dev->addr_list_lock
spinlock in the core only lets through one thread at a time.

Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # 4e0396c59559

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org (open list)

 drivers/net/ethernet/microchip/lan743x_main.c | 12 +++---------
 drivers/net/ethernet/microchip/lan743x_main.h |  3 ---
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index d0817a974f8e..eb990e036611 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -674,14 +674,12 @@ static int lan743x_intr_open(struct lan743x_adapter *adapter)
 static int lan743x_dp_write(struct lan743x_adapter *adapter,
 			    u32 select, u32 addr, u32 length, u32 *buf)
 {
-	int ret = -EIO;
 	u32 dp_sel;
 	int i;
 
-	mutex_lock(&adapter->dp_lock);
 	if (lan743x_csr_wait_for_bit(adapter, DP_SEL, DP_SEL_DPRDY_,
 				     1, 40, 100, 100))
-		goto unlock;
+		return -EIO;
 	dp_sel = lan743x_csr_read(adapter, DP_SEL);
 	dp_sel &= ~DP_SEL_MASK_;
 	dp_sel |= select;
@@ -693,13 +691,10 @@ static int lan743x_dp_write(struct lan743x_adapter *adapter,
 		lan743x_csr_write(adapter, DP_CMD, DP_CMD_WRITE_);
 		if (lan743x_csr_wait_for_bit(adapter, DP_SEL, DP_SEL_DPRDY_,
 					     1, 40, 100, 100))
-			goto unlock;
+			return -EIO;
 	}
-	ret = 0;
 
-unlock:
-	mutex_unlock(&adapter->dp_lock);
-	return ret;
+	return 0;
 }
 
 static u32 lan743x_mac_mii_access(u16 id, u16 index, int read)
@@ -2720,7 +2715,6 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 
 	adapter->intr.irq = adapter->pdev->irq;
 	lan743x_csr_write(adapter, INT_EN_CLR, 0xFFFFFFFF);
-	mutex_init(&adapter->dp_lock);
 
 	ret = lan743x_gpio_init(adapter);
 	if (ret)
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 57fce752346e..3a0e70daa88f 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -711,9 +711,6 @@ struct lan743x_adapter {
 	struct lan743x_csr      csr;
 	struct lan743x_intr     intr;
 
-	/* lock, used to prevent concurrent access to data port */
-	struct mutex		dp_lock;
-
 	struct lan743x_gpio	gpio;
 	struct lan743x_ptp	ptp;
 
-- 
2.17.1

