Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E50628718D
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405509AbfHIFfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:35:51 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45484 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbfHIFfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 01:35:50 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so45260394pgp.12;
        Thu, 08 Aug 2019 22:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Y9/+wGbpbXCfuTma8kUk8xVzAbm0dcjXmGTrVrB3TKQ=;
        b=klqbFwmYXvkLwC4h8ftAVxXdmQ9OYmqmpf5ggfLyOLY1Xu/dFKEgJ4YWjzznPM5r/M
         oUyqM023Ofa1MhmGga1kr/xVmz8G70Xx0VNN676V9y+fF0Hnk05x8dARaVnrDiKb0Hjt
         A39aCKUpD/kf3Wv2LBh41oi7Rjx6uzvUn0zEWoo8P+Jrk8Y8USrDpetbLtD4g+kt+ipJ
         Z1+MaInT3UGXJv9lPwVV2JgOG30hOWH/iHLnGxk2k9jBl6BXLLZ3STjRvO8xMHgW1kJB
         l8jgYZtNZkHAZRoR5/BzDArAgjlvfJyFfotRego4LEoCe9SSqGkkspZh323zOjLIaqAn
         2t1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Y9/+wGbpbXCfuTma8kUk8xVzAbm0dcjXmGTrVrB3TKQ=;
        b=Gd443j4OX0qBUY6oKnsjCMUhleB6N2w8ZqNSQHyG6IvSCPZGPi5+B/NlkIkdoWRs/G
         Z0rm/BIQgZngSIhXhzh2TcmnnBuJInyx0KRNZVAzyKm/7MPD9IsbRGdqypZCG10d5Qgc
         SdK33WH6iCMu/i/vF0UxvaCTqPC2a14NRdjPajIbqu1DO65O7OiDRPCgjJYhdQ4VUivK
         kT1WWFjPQEi4M8bYXuxWL3NpRMrfCUrnCBkuar23RyqjkW7v0MOIxb7Y0ESzHrnGfolz
         wUUUfnLfYtlGkrTGbSGjkZtnxHmjn3mGlcYR72PjFMpLCz6aDa5si+n+FIuyJsWG+O3E
         0dtQ==
X-Gm-Message-State: APjAAAV9Kl9fvRVOh/B2paCE8gUi4ZVwxh7nLl0jRJRIJ/UmX68gPxB3
        F4Pz4wfnoCnohoJN61kPVdU=
X-Google-Smtp-Source: APXvYqxPMujEQFdBHnxMj8KaCeQx3GrElWgDMeZxYIz3P4iD2beWUVElDVjaHoVXoWcPDAJg3LGYKw==
X-Received: by 2002:a17:90a:2343:: with SMTP id f61mr7780272pje.130.1565328949960;
        Thu, 08 Aug 2019 22:35:49 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id l189sm116567684pfl.7.2019.08.08.22.35.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 22:35:49 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v2] net: tundra: tsi108: use spin_lock_irqsave instead of spin_lock_irq in IRQ context
Date:   Fri,  9 Aug 2019 13:35:39 +0800
Message-Id: <20190809053539.8341-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As spin_unlock_irq will enable interrupts.
Function tsi108_stat_carry is called from interrupt handler tsi108_irq.
Interrupts are enabled in interrupt handler.
Use spin_lock_irqsave/spin_unlock_irqrestore instead of spin_(un)lock_irq
in IRQ context to avoid this.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
Changes in v2:
  - Preserve reverse christmas tree ordering of local variables.

 drivers/net/ethernet/tundra/tsi108_eth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index 78a7de3fb622..c62f474b6d08 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -371,9 +371,10 @@ tsi108_stat_carry_one(int carry, int carry_bit, int carry_shift,
 static void tsi108_stat_carry(struct net_device *dev)
 {
 	struct tsi108_prv_data *data = netdev_priv(dev);
+	unsigned long flags;
 	u32 carry1, carry2;
 
-	spin_lock_irq(&data->misclock);
+	spin_lock_irqsave(&data->misclock, flags);
 
 	carry1 = TSI_READ(TSI108_STAT_CARRY1);
 	carry2 = TSI_READ(TSI108_STAT_CARRY2);
@@ -441,7 +442,7 @@ static void tsi108_stat_carry(struct net_device *dev)
 			      TSI108_STAT_TXPAUSEDROP_CARRY,
 			      &data->tx_pause_drop);
 
-	spin_unlock_irq(&data->misclock);
+	spin_unlock_irqrestore(&data->misclock, flags);
 }
 
 /* Read a stat counter atomically with respect to carries.
-- 
2.11.0

