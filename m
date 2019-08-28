Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE6FA0746
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 18:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfH1Q04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 12:26:56 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43686 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfH1Q0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 12:26:55 -0400
Received: by mail-qt1-f194.google.com with SMTP id b11so159474qtp.10
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 09:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CtFI//2AqAcPUJUnRaJGcvLDo21k6AiEytxHdOupuHI=;
        b=uhS5HwL7rs/1EqWeJnwyWPBVmgk7xTZAvK1pFDkSYAJ4woJHbct27t1/8xpbupzDl/
         XNw/Cyqy+rXu61K1GAKVudMhdJ576eWantG27yFpIscSpVzY4HsTsr8/uhc/dYgzt1Mp
         Nvp5Psb/bxoBmxdwKJomWXHAlL3vQ0BqMpJzWXFJHJZ8RN95Lcw/6ugI02PrDre/qEi4
         ZTKZOlmfbDn5UnI7qqbXMp6+P/GvsgudrevpoAFrowtaOoyExyQaWL+ebshMlaqqOvl1
         y0zKVLeWKYcm2CkSrD1MvFgnA7EAIxABUZmbrFF4ymiPtvazKoVnVig6ctizzXiSs7mn
         JKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CtFI//2AqAcPUJUnRaJGcvLDo21k6AiEytxHdOupuHI=;
        b=IuRIELr+IWkMPlKgKRjxRGAi/m/9YfMfRybJvBm6uUefKT4uHTPIlZAQ5raWqBa2V5
         tb023eEKR5YfbfMNhQdt39b+yFfPPQDhblyZi/RhrfnttQma/Z4+/T8zT809ic8St3kP
         RPzzIVeExkVMgwjA4RdnRQjuNwhxp46TzKde7lTdcWbBgo6WD+q1pUiWhFQwjVspUJ+I
         vnGU0uNIi/PHeBd/JKtnqHDdCjOWD7rYeHcz56PmIj0Lxs1/3C9+VfSeP7Y/0aVCvNqS
         J8vxyRMpElAD6WBKCekKkL6tNyoo0NzQdrznh9aedBh6YEtVqPmt8V+G0q4xZhr5EV8n
         GV9A==
X-Gm-Message-State: APjAAAXjPUikk83lHXW+1Hi5FTZApoTaNshwxrm6I8eNItO1Ph+5RfqW
        51xIcOxl4CrvfcNhFEZbYWodql+x
X-Google-Smtp-Source: APXvYqwLYwl08sh4LwZNGUcG+R0fBAx+/72aBEOtaFTwwbSqJL5T3Xky7KDYrLGJwoc/GDWQLUg58Q==
X-Received: by 2002:ac8:6887:: with SMTP id m7mr4891002qtq.325.1567009614448;
        Wed, 28 Aug 2019 09:26:54 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q9sm1417974qtj.48.2019.08.28.09.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 09:26:53 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: get serdes lane after lock
Date:   Wed, 28 Aug 2019 12:26:11 -0400
Message-Id: <20190828162611.10064-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow-up patch for commit 17deaf5cb37a ("net: dsa:
mv88e6xxx: create serdes_get_lane chip operation").

The .serdes_get_lane implementations access the CMODE of a port,
even though it is cached at the moment, it is safer to call them
after the mutex is locked, not before.

At the same time, check for an eventual error and return IRQ_DONE,
instead of blindly ignoring it.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 9424e401dbc7..38c0da2492c0 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -646,10 +646,12 @@ static irqreturn_t mv88e6390_serdes_thread_fn(int irq, void *dev_id)
 	int err;
 	u8 lane;
 
-	mv88e6xxx_serdes_get_lane(chip, port->port, &lane);
-
 	mv88e6xxx_reg_lock(chip);
 
+	err = mv88e6xxx_serdes_get_lane(chip, port->port, &lane);
+	if (err)
+		goto out;
+
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
 	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
-- 
2.23.0

