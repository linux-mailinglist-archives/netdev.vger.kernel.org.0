Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E84146324F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239190AbhK3L2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236663AbhK3L2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:28:19 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3961DC061574;
        Tue, 30 Nov 2021 03:25:00 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id z9so19786148qtj.9;
        Tue, 30 Nov 2021 03:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ym825Oem8EC5G2GRDZ+HddgbbKOYg4yd7gybO1UTWJY=;
        b=hqNe3KR/ZaHYLDTzD8T1KYUFb5Avq6sL4TdGldnako+WU07tR52Pci04KsKPBmORgQ
         AGpoFfXyzUSEH4OlsNDT+WFJAwQ3XyXBoFFU5A/ebIrzWfIPthWh6zQ97LWyE4zKfXmh
         T7VHKj1jxPFWnGzu6lpc1q9xcDODS9qenZ5l79lr6d6IQE7RJw9q2UnpixS0wHjidksc
         IGgmzGlXLehGPU4Y/L4OSafxoTi11s9E+mR+LqMu0ydAREaavVFPRsiC1eMptAusk3U9
         Kn04FYnoPPT8Hhn9Imth5pTIMx4OJZ7Be7m/XqIQxxLii+WNtCejW7on7lPSCAVu+QsB
         4qYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ym825Oem8EC5G2GRDZ+HddgbbKOYg4yd7gybO1UTWJY=;
        b=pzKLNW6m9tGmNq4Fuj9r3NgFwVOMgUPcKJFkm6X2n2iZPyGWtPOWZ5J/RjJMmGjKiy
         f/doYyG2r1h57G7mi59OChIgpi/n5iQ6K89ToA7Oqo8wuu4h3gqA6MTJcyt0x5ALBAdL
         p3CE0Q0Vp5OFiD9OPNOId9D4DT8pBh0QfksBxQnb2Iqj2prhyzN1UM2R0AmJ7c9O5r7R
         dp+8EVU8HxgvjjZfeTLYHw6e4/Sff4VBmykx0ZENF8/FJy3OzI0VFSnL7Kv9FpVTXg2y
         PZENL5IFCXO5KONsAsYjJ7cvugyfSqNfIq0q2n8HKUwzAHVtcBFjSZGYySUeTqfj8dM2
         0f7g==
X-Gm-Message-State: AOAM531yYzEZoP/e+8031SWKcPD2NjyHvu93M189JtXXmtBuHVMiWEm5
        dLsHBqDx0oNOrAIU8yIxG/8=
X-Google-Smtp-Source: ABdhPJwGB7NH9co0Rc85irLAspmG/3OKbdKPZWkFqFIXiP95zAEPyFZLAMGDS4WSXo9v0ElYQYNMbQ==
X-Received: by 2002:a05:622a:164b:: with SMTP id y11mr49370660qtj.87.1638271499392;
        Tue, 30 Nov 2021 03:24:59 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id v2sm10501672qkp.72.2021.11.30.03.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 03:24:58 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     vladimir.oltean@nxp.com
Cc:     claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: mscc: ocelot: fix mutex_lock not released
Date:   Tue, 30 Nov 2021 11:24:43 +0000
Message-Id: <20211130112443.309708-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

If err is true, the function will be returned, but mutex_lock isn't
released.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 drivers/net/ethernet/mscc/ocelot.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index fe8abb30f185..b1856d8c944b 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1651,8 +1651,10 @@ int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
 	}
 
 	err = ocelot_setup_ptp_traps(ocelot, port, l2, l4);
-	if (err)
+	if (err) {
+		mutex_unlock(&ocelot->ptp_lock);
 		return err;
+	}
 
 	if (l2 && l4)
 		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
-- 
2.25.1

