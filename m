Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85891308E15
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbhA2UIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbhA2Txa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 14:53:30 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B92C061756;
        Fri, 29 Jan 2021 11:52:49 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id c12so7586211qtv.5;
        Fri, 29 Jan 2021 11:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ut9QqJ8Bb2FrztE7bn3aXbtZ5BLxMG2sx0NSSH/xwUI=;
        b=aBMO+pWmEC7z/EWnOcanV6rSfEWJC7TZQLc/1Nqaz73cldyCBvuHpJ3S/fCGuSyBAH
         jR2SiKDWY8jF2Etdz8O/Q1ePhaTxIxewlyVF/3y/1taDyC0O031wNSbfDet9IUJfDxaW
         3/BoyyJoLLxBhNkbmdrkDQeGwM4rRyzS7Jffg3AVV986EZpesGzmto9WEoxivkn2x4ZS
         w7DBEon6sXZlRWXI+Q12Ownrjjat15+ebKFKKH3avwvuOx6cOcFuagTAajMCssmpcXW8
         ww1rdtSnMJyTt6b/n+2YDMiZbknJ/X+1rQgbQQkTgrQQq8aP/WaXGiX4uhOiTMf9pJol
         FVsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ut9QqJ8Bb2FrztE7bn3aXbtZ5BLxMG2sx0NSSH/xwUI=;
        b=gp6xPOLI+/Mh41S+B7vBmF9MQRUTgeY7Wn7ZvE3xOsQ3UWjxi3t8wECoT311Lr1qHj
         VNXx5RK6tjP0o1kdhur6n+4VGqF6t3EXjtbUp5jz55V/jZYjlqT+nr4FvfYikzKGbOF7
         iQ34OiMrISRm5XX3uSJuZBW9vis54Xw/2htxP3TZHSFHpAJ1d1qjC90ddCw/hrIHL7e1
         LoGGwKwnSEOrsa/PnI7e1g/YYlolnImGElUKuCWVrYQ4lJj/g+LB33SZvWKfiC6KYyjJ
         42UKt4eA45MVo33jeD2Fj2upR87a0QSW8inr0UXPgtRk9otoSZBokBmJi/N7jMQC9fQI
         /yHQ==
X-Gm-Message-State: AOAM532BQiL2EYWjFquvbk75IUhg1VNhOKH+7XRjWf6LVsKhRMor97K5
        QpSxC5E+hF0W54WipIFMVdA=
X-Google-Smtp-Source: ABdhPJyCh48VoqMVC68j0pVhLy16N2ITDMDSP87kz509b1sCqaiQTT9AwAOCG9KU/bGMG/hMp7i9hg==
X-Received: by 2002:ac8:7119:: with SMTP id z25mr5628642qto.16.1611949969079;
        Fri, 29 Jan 2021 11:52:49 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id s136sm6558994qka.106.2021.01.29.11.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 11:52:48 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com, David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?q?Anders=20R=C3=B8nningen?= <anders@ronningen.priv.no>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 3/6] lan743x: allow mtu change while network interface is up
Date:   Fri, 29 Jan 2021 14:52:37 -0500
Message-Id: <20210129195240.31871-4-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210129195240.31871-1-TheSven73@gmail.com>
References: <20210129195240.31871-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

Now that we can use rx ring buffers smaller than the mtu,
we allow users to change the mtu on the fly.

Tested as follows:

Tests with debug logging enabled (add #define DEBUG).

1. Set the chip mtu to 1500, generate lots of network traffic.
   Stop all network traffic.
   Set the chip and remote mtus to 8000.
   Ping remote -> chip: $ ping <chip ip> -s 7000
   Verify that the first few received packets are multi-buffer.
   Verify no pings are dropped.

Tests with DEBUG_KMEMLEAK on:
 $ mount -t debugfs nodev /sys/kernel/debug/
 $ echo scan > /sys/kernel/debug/kmemleak

2. Start with chip mtu at 1500, host mtu at 8000.
Run concurrently:
 - iperf3 -s on chip
 - ping -> chip

Cycle the chip mtu between 1500 and 8000 every 10 seconds.

Scan kmemleak periodically to watch for memory leaks.
Verify that the mtu changeover happens smoothly, i.e.
the iperf3 test does not report periods where speed
drops and recovers suddenly.

Note: iperf3 occasionally reports dropped packets on
changeover. This behaviour also occurs on the original
driver, it's not a regression. Possibly related to the
chip's mac rx being disabled when the mtu is changed.

Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git # 46eb3c108fe1

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: UNGLinuxDriver@microchip.com
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Alexey Denisov <rtgbnm@gmail.com>
Cc: Sergej Bauer <sbauer@blackbox.su>
Cc: Tim Harvey <tharvey@gateworks.com>
Cc: Anders Rønningen <anders@ronningen.priv.no>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org (open list)

 drivers/net/ethernet/microchip/lan743x_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index b784e9feadac..618f0714a2cf 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2597,9 +2597,6 @@ static int lan743x_netdev_change_mtu(struct net_device *netdev, int new_mtu)
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
 	int ret = 0;
 
-	if (netif_running(netdev))
-		return -EBUSY;
-
 	ret = lan743x_mac_set_mtu(adapter, new_mtu);
 	if (!ret)
 		netdev->mtu = new_mtu;
-- 
2.17.1

