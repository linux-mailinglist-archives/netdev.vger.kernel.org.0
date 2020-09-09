Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC32262CCE
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 12:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgIIKEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 06:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgIIKEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 06:04:35 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F02BC061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 03:04:35 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y15so1753200wmi.0
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 03:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GwN0+i/cI/n/+0mqzm/sKQPMpFX4gdPhYIC5uk3bMbQ=;
        b=boqs782B2W+C5l6qBV381hB/DTlNglszD1gTKGL5qNNp2eEM8I2dRcEOBQq90bZJRM
         GAvUYHNAibM2oWAPWSzZYJC1Or5MRZqhOezyQXteQvSoD2quJTkK/EgQBVAz0j3lWMpy
         zdMLJYUuyLGEg8pjez6mKMMFtQH7zvNFrWUf4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GwN0+i/cI/n/+0mqzm/sKQPMpFX4gdPhYIC5uk3bMbQ=;
        b=d+7cFuQiOWzb9M/HH9jpC55vF7l2H3bN3Shh5DvUx9x2iv2AekmQOlK8qFm0ZXscfr
         Gm/YJPRl+Q3Vp7OsrfniDtDh0Yb6bQepgB+wfFWq4YX5XW/i2ZBf5MMXcxWwx9Vc93c3
         x5Z5cuszFbE1ig7BtF5slDXiMhE6m2dLu/4YmukV146NGAcmIH06bAx6rxEskOKXtVR6
         m6kUIB2PlhInCHPqSI4MLoHDglw6qT7MfuL5bptNxaItAPPTxC0hNUBqy7KMlN0ZfxOd
         w+MKPN7qGkieMY56wmXLvcXG9Dw0KtvZhKdpGopYdgUblrxHbUhUGCOEFKhPvWp6nk3/
         swlg==
X-Gm-Message-State: AOAM533zRiYJbgAXqn7Cw98+E56rgw76jM1HPt0KJcMK6hpRqP/O9xMy
        scKtVsocLXdq8F7E/4hA/mEM3w==
X-Google-Smtp-Source: ABdhPJxRg3eSGd/mkl5lmr8frJ6I4Rdr+h739do/YtaV3JyH4Mz2h4mMjHbszBUgUoPv0gQMACrafg==
X-Received: by 2002:a7b:c404:: with SMTP id k4mr2247339wmi.168.1599645874087;
        Wed, 09 Sep 2020 03:04:34 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id l16sm3828237wrb.70.2020.09.09.03.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 03:04:33 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH v3 1/4] net: dsa: microchip: Make switch detection more informative
Date:   Wed,  9 Sep 2020 11:04:14 +0100
Message-Id: <20200909100417.380011-2-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200909100417.380011-1-pbarker@konsulko.com>
References: <20200909100417.380011-1-pbarker@konsulko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make switch detection more informative print the result of the
ksz9477/ksz9893 compatibility check. With debug output enabled also
print the contents of the Chip ID registers as a 40-bit hex string.

As this detection is the first communication with the switch performed
by the driver, making it easy to see any errors here will help identify
issues with SPI data corruption or reset sequencing.

Signed-off-by: Paul Barker <pbarker@konsulko.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 3cb22d149813..df5ecd0261fa 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1426,10 +1426,12 @@ static int ksz9477_switch_detect(struct ksz_device *dev)
 	/* Default capability is gigabit capable. */
 	dev->features = GBIT_SUPPORT;
 
+	dev_dbg(dev->dev, "Switch detect: ID=%08x%02x\n", id32, data8);
 	id_hi = (u8)(id32 >> 16);
 	id_lo = (u8)(id32 >> 8);
 	if ((id_lo & 0xf) == 3) {
 		/* Chip is from KSZ9893 design. */
+		dev_info(dev->dev, "Found KSZ9893\n");
 		dev->features |= IS_9893;
 
 		/* Chip does not support gigabit. */
@@ -1438,6 +1440,7 @@ static int ksz9477_switch_detect(struct ksz_device *dev)
 		dev->mib_port_cnt = 3;
 		dev->phy_port_cnt = 2;
 	} else {
+		dev_info(dev->dev, "Found KSZ9477 or compatible\n");
 		/* Chip uses new XMII register definitions. */
 		dev->features |= NEW_XMII;
 
-- 
2.28.0

