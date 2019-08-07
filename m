Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC358461E
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 09:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387396AbfHGHnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 03:43:11 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43217 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727190AbfHGHnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 03:43:11 -0400
Received: by mail-pl1-f195.google.com with SMTP id 4so32472187pld.10;
        Wed, 07 Aug 2019 00:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xyR+lCbovY7DSpuUffdnrpU/87Hr2gUcwjUISUwCLJw=;
        b=TW3Gk/9LpD+OFs4lahdlhV3I4MGtLWKreblCOq+Yo+EDbQ871srDL6vRjTPnvwgnrN
         PeKcjrsnqECNYvuYzY0+6PlVfSyU9xYfJe16uFdkPVJ0Uxb7iz/vvv8QkvWVoSC0Mort
         FVASEPQ6CdYeS6QWKvMQLaQIbsKGb0eJBom2KFxSf2IDl4gLeFVjnxZnczS5hXMXX5zI
         r221oZAfChl8ebIdqbDCyS5MczleMi+RS0AFUdLsAkvnvTmB34bk7JbplGWG7gld/PiE
         EK1MUM6m5G7hcvOHAKH8TZqc31OBACF9TZgoEDtBfMlO2eVuYjoXm68VbjvX6Hbj3Y6A
         JhQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xyR+lCbovY7DSpuUffdnrpU/87Hr2gUcwjUISUwCLJw=;
        b=dkhuhdz4yEZ6yYTIcK1pSp0zzqWFRjYqo/PF86J6atUqu0EqwKc/A9hNlUp5Z6LZjy
         3YFe1fGWs+UjqG3ERaJcGwFtKc5PekWEyiI63BsrlOCleUweiZcCQyheeFTL9/yLKIjd
         n9tZEwQzuMUekJqle5X6wB9L5f5TZ+DyYd/m9obZL9vRsWTJ6lCNivrJ9vVuh0ZXOJIh
         ZgbnFfZDQYrB+W2y/JRXMC2VfxX6lFCWBXZtik+x5DkqzR+xxhd5063dGv5Q5Cyn4RBG
         fjH3QCoJCw0S4vrLlbKiP/fwzoAP4+0m4txTPCC4qbEil4BCjpeCfSi92Lf8UD72vbSR
         t7eg==
X-Gm-Message-State: APjAAAWsHDBQV8SJpO/fQj5awfyUqsQchzIxtbOTgMnr/hXITYaoDVWh
        gC8UCF4k4z3thYTiaOBdo9Y=
X-Google-Smtp-Source: APXvYqyc2fzP2b8R5VpfzEakKkrCvXr78uRPkaICsLFEGjveOsccUEADRRTbxq7djuWvsa2i98p6+Q==
X-Received: by 2002:a62:874d:: with SMTP id i74mr7868817pfe.94.1565163790590;
        Wed, 07 Aug 2019 00:43:10 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id f3sm146879233pfg.165.2019.08.07.00.43.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 00:43:09 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH] net: tundra: tsi108: use spin_lock_irqsave instead of spin_lock_irq in IRQ context
Date:   Wed,  7 Aug 2019 15:43:00 +0800
Message-Id: <20190807074300.23135-1-huangfq.daxian@gmail.com>
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
 drivers/net/ethernet/tundra/tsi108_eth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index 78a7de3fb622..14215979d07e 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -372,8 +372,9 @@ static void tsi108_stat_carry(struct net_device *dev)
 {
 	struct tsi108_prv_data *data = netdev_priv(dev);
 	u32 carry1, carry2;
+	unsigned long flags;
 
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

