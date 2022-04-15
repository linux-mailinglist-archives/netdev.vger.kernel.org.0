Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06282503087
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354145AbiDOVIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 17:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353834AbiDOVIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 17:08:24 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE936583F;
        Fri, 15 Apr 2022 14:05:55 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id 12so9319644oix.12;
        Fri, 15 Apr 2022 14:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=c+jRzeRaOtb5M7J5uF0lBdN76Vm6jmRXpE23TnVclyI=;
        b=Kf51MzpPbFNnuYynK3VGAw2zwks2ichcsDV2fcpBa83qFzY0+tzTVsmChDWOh+ZdO+
         yP5TDCYcIOsXZftHJrE3y4qtTKJy4lZp5jxDu/piSKCC3669DzNGpchHtW1LK71xYBYu
         EUfsKlM5wrUDSigLT8i1ixKtABNIOkjTGXiXn6f9QtsLwYzQ7QTk+MDjO9N7urL1N9JX
         66tm7Zpw0QE4l8/EiyBnIjK+LMvtlFYFMQBwool0nhH7MGoQ4E9sfaj9yQ275tsPPV+d
         JS+BV78DV8BptUgyh48ehiOPHeUxbJ/tVSdiaF3JZpGKOsVatCkJqq2aWOlT+HcYh+E4
         ZbPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=c+jRzeRaOtb5M7J5uF0lBdN76Vm6jmRXpE23TnVclyI=;
        b=vCYWNjSxlvfuwrfDkfuJQXHOamfDyC0i21IMRGhCos43n5WDnwJD0kIYcp2lravo59
         Vx9enR+DFdabn48jiQGHjtWiXn6n+5XgimG6mevo2owFe9LivygMjdseA09st7/Jzta5
         cuQ/nunQji1U2lIuShc6tFxqF4nY4kdJg+0tdHNYJ3Wsza6DDiyold94UZjgdk1WzaB8
         vaq9we3mvRj6XKpB9EkUnx97ei5qFJpEwtEHSFEc7NBsvEGaws5q7tfWgGF6fySypW4L
         pT9HIH7yFR0dtArpG29o+q1MtWevh6MKj8DwX1M/Mfa013kBYOsQHIXpeAN9MLko+dAq
         o3hg==
X-Gm-Message-State: AOAM532L2Rf++cn7twMae8VRTyecVqlobR9E5b2C292CaJ/unqM1/2P9
        tJBAXhGScW6LE/tcc38PMAY=
X-Google-Smtp-Source: ABdhPJw4UQPzzMTfzaIdqFrRq5KfZCX15V+2ATQdVLWJtVZsRPxurqsi+SOddaG27IU/KaErUYP7vQ==
X-Received: by 2002:a05:6808:178d:b0:2fa:6573:d78 with SMTP id bg13-20020a056808178d00b002fa65730d78mr330810oib.241.1650056754737;
        Fri, 15 Apr 2022 14:05:54 -0700 (PDT)
Received: from toe.qscaudio.com ([65.113.122.35])
        by smtp.gmail.com with ESMTPSA id bh20-20020a056808181400b002fa6ea63b7asm1528222oib.20.2022.04.15.14.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:05:54 -0700 (PDT)
From:   Jeff Evanson <jeff.evanson@gmail.com>
X-Google-Original-From: Jeff Evanson <jeff.evanson@qsc.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     jeff.evanson@qsc.com, jeff.evanson@gmail.com
Subject: [PATCH 2/2] Trigger proper interrupts in igc_xsk_wakeup
Date:   Fri, 15 Apr 2022 15:05:46 -0600
Message-Id: <20220415210546.11294-1-jeff.evanson@qsc.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in igc_xsk_wakeup, trigger the proper interrupt based on whether flags
contains XDP_WAKEUP_RX and/or XDP_WAKEUP_TX

Signed-off-by: Jeff Evanson <jeff.evanson@qsc.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 36 +++++++++++++++++------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index a36a18c84aeb..d706de95dc06 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6073,7 +6073,7 @@ static void igc_trigger_rxtxq_interrupt(struct igc_adapter *adapter,
 int igc_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
 {
 	struct igc_adapter *adapter = netdev_priv(dev);
-	struct igc_q_vector *q_vector;
+	struct igc_q_vector *txq_vector = 0, *rxq_vector = 0;
 	struct igc_ring *ring;
 
 	if (test_bit(__IGC_DOWN, &adapter->state))
@@ -6082,17 +6082,35 @@ int igc_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
 	if (!igc_xdp_is_enabled(adapter))
 		return -ENXIO;
 
-	if (queue_id >= adapter->num_rx_queues)
-		return -EINVAL;
+	if (flags & XDP_WAKEUP_RX) {
+		if (queue_id >= adapter->num_rx_queues)
+			return -EINVAL;
 
-	ring = adapter->rx_ring[queue_id];
+		ring = adapter->rx_ring[queue_id];
+		if (!ring->xsk_pool)
+			return -ENXIO;
 
-	if (!ring->xsk_pool)
-		return -ENXIO;
+		rxq_vector = ring->q_vector;
+	}
+
+	if (flags & XDP_WAKEUP_TX) {
+		if (queue_id >= adapter->num_tx_queues)
+			return -EINVAL;
+
+		ring = adapter->tx_ring[queue_id];
+		if (!ring->xsk_pool)
+			return -ENXIO;
+
+		txq_vector = ring->q_vector;
+	}
+
+	if (rxq_vector &&
+	    !napi_if_scheduled_mark_missed(&rxq_vector->napi))
+		igc_trigger_rxtxq_interrupt(adapter, rxq_vector);
 
-	q_vector = adapter->q_vector[queue_id];
-	if (!napi_if_scheduled_mark_missed(&q_vector->napi))
-		igc_trigger_rxtxq_interrupt(adapter, q_vector);
+	if (txq_vector && txq_vector != rxq_vector &&
+	    !napi_if_scheduled_mark_missed(&txq_vector->napi))
+		igc_trigger_rxtxq_interrupt(adapter, txq_vector);
 
 	return 0;
 }
-- 
2.17.1

