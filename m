Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3742D25E843
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 16:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgIEOEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 10:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728372AbgIEODr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 10:03:47 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC01DC061245
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 07:03:46 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c15so10154733wrs.11
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 07:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/X4cwvvUFsabA0ucoN9VOvC/13JiGESTrG6cG37QFDo=;
        b=Fq/kpFRNovuK6ZKzdr5oSPrbu19aCAhCq8Zw3mgFW0hZMFeDupI169cb5AtWjk3W0b
         CbNG0sA8CejmTOxfid6UYjowOWFfmu9Y0UEYrZ6MwEmrCZLcycNejdHzp6nKT5XkVXU5
         KG5QFemNlm1p8GN0txFWZYFnuIsTrJDQUtAlI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/X4cwvvUFsabA0ucoN9VOvC/13JiGESTrG6cG37QFDo=;
        b=H1tSlOZJb325P2gfok+eHY1SUNs+XzXInjujh/PNe6P8gyUH3CUTnL3s95WLp98tBj
         F6XCgIw/ZBe+Hi2DBY1+PhZueJMARRJih9nXfZBlZ61DM1My1ifuuAQZ7mxBG71d5FfD
         F4eViVJ1CJjiYnpsWcvuwXN6YQvBDPshEIXXIt+ywg/zNoBxBcbMZtBU2/hWDTpToKyQ
         2OLPinDCJM/I17q6Itb6kdo2PKqcEeFXHFLEaRP4JDmwlpDD+D00z1PZmDOKHctqoeUD
         pE9Cav/VVlGJOSo6SFz7S0Hyb5NUJJ3KQIQiu3eC1/omjibRs3NRp4y+8vYvM1HYDNgV
         a+vg==
X-Gm-Message-State: AOAM533ZQyh6kip1Cx2oogMbbOcj4zna+tE5U7ExaN12g2tn3L8+uOd2
        tpOYLx9VpF/lXiBiwaM+pJCtIQ==
X-Google-Smtp-Source: ABdhPJwIhiS5j0/DT/mV257lPhKlfOk8A1FlQH+vJ9NUaz38qHxvPgECgFRJLnBK6/sSWooqmdkJlA==
X-Received: by 2002:adf:83c3:: with SMTP id 61mr12168867wre.287.1599314620745;
        Sat, 05 Sep 2020 07:03:40 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id b2sm17390369wmh.47.2020.09.05.07.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 07:03:40 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH 4/4] net: dsa: microchip: Implement recommended reset timing
Date:   Sat,  5 Sep 2020 15:03:25 +0100
Message-Id: <20200905140325.108846-5-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200905140325.108846-1-pbarker@konsulko.com>
References: <20200905140325.108846-1-pbarker@konsulko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The datasheet for the ksz9893 and ksz9477 switches recommend waiting at
least 100us after the de-assertion of reset before trying to program the
device through any interface.

Also switch the existing mdelay() call to usleep_range() as recommended
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

