Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAFB25F770
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgIGKNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728580AbgIGKMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:12:22 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677B3C061756
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 03:12:22 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id s13so13794488wmh.4
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 03:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+CmuBvHSLrJBh6+25r6fCP8C8dEsiulNskkxE4j9PUw=;
        b=DxE2NOyxZGuGlM+N84MBbRHboXyrobgPdcrERsi9jcGoo5k+sl5VpL83kePZaK9J06
         WCcjG7CN1YbqmFrkOx6bZm+WOzKQcKGNY8qlR/cptXUW+GMa2hI9vKt32FsWL0tTpWRC
         SxjV6a+wljQkDUd0BRf8gBJs09ZQYaJh4wKhs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+CmuBvHSLrJBh6+25r6fCP8C8dEsiulNskkxE4j9PUw=;
        b=aYRmE9t1UQNAcg6AvBECBSz/mgd0KvBIe46tuiHD6ciMPwtjJi/FBj1g3P7sy3Yz/3
         t+GmprZHI9fmFO4/EhomlXGSsTLKwb5uKtb60TxY98Ti8V2p8ZxcC4CUj0cCHhCefB9k
         M+UmNZQ1fv23oJcqo6fzrsrS562ujOfUwz6qGtaezfN32aVVQJU8wKMvNUMgbmMc3tWb
         lMksXlwVk65NDJRjiFcvh9z+pNZBqH7PcaKQRqT+4vFf/gqxR3aPrzlI1Ioh1o++KtHB
         NWD/VTpklJEMbtVpMgU+BvaDNLAHEVcdHd/dxuy8zwTTsLVf66F20lnVCtveS+lXidp0
         vHKg==
X-Gm-Message-State: AOAM532x12zZSfeAdyCRwz1GZvVrTvwthjYJD8kGm80TYfKihCg4NBZS
        4v/JAljRSGk+djqehvcOXoB5rw==
X-Google-Smtp-Source: ABdhPJyVAZ4DvZdxVZOXIUHHju8Zzlypi4Q2XtKa3FXrc114yHIrpcIWbwQN5sroI1N75StkNXcPRw==
X-Received: by 2002:a7b:c1d3:: with SMTP id a19mr13876530wmj.19.1599473541137;
        Mon, 07 Sep 2020 03:12:21 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id i16sm24173748wrq.73.2020.09.07.03.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:12:20 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH v2 4/4] net: dsa: microchip: Implement recommended reset timing
Date:   Mon,  7 Sep 2020 11:12:08 +0100
Message-Id: <20200907101208.1223-5-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907101208.1223-1-pbarker@konsulko.com>
References: <20200907101208.1223-1-pbarker@konsulko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The datasheet for the ksz9893 and ksz9477 switches recommend waiting at
least 100us after the de-assertion of reset before trying to program the
device through any interface.

Also switch the existing msleep() call to usleep_range() as recommended
in Documentation/timers/timers-howto.rst. The 2ms range used here is
somewhat arbitrary, as long as the reset is asserted for at least 10ms
we should be ok.

Signed-off-by: Paul Barker <pbarker@konsulko.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 8d53b12d40a8..a31738662d95 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -400,8 +400,9 @@ int ksz_switch_register(struct ksz_device *dev,
 
 	if (dev->reset_gpio) {
 		gpiod_set_value_cansleep(dev->reset_gpio, 1);
-		mdelay(10);
+		usleep_range(10000, 12000);
 		gpiod_set_value_cansleep(dev->reset_gpio, 0);
+		usleep_range(100, 1000);
 	}
 
 	mutex_init(&dev->dev_mutex);
-- 
2.28.0

