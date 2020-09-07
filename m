Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E24525F76D
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgIGKMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbgIGKMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:12:21 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD63CC061574
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 03:12:19 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id a9so13644212wmm.2
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 03:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oyl52mrqZ8yf4xueQQADEoNtO/OjPzssN55EUTt66ws=;
        b=cQxpjlmL+i5T07fyvWP5PXMOf3K+m53U5FFdJkaZT9qQe4MLIAAzw+jH7v18qgP7Rx
         1FuCDmfaUGOv7Fm3d13CO/ptZXov9i3ziOLN8pswDRKpsAN2E8mzxxTKEpjWkeiQ44Sf
         XxnWxCIDiIJQaZ9NloPXervv5cD2jagfIBhMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oyl52mrqZ8yf4xueQQADEoNtO/OjPzssN55EUTt66ws=;
        b=VcupzDSc8CYL9L2E3fwof2PeTVJs8dM3rJGy7gMJIEuqqD/fzwqKT0avi3XZarvE7U
         5yh+RmH6tP/EHcfwl7wX7wXawZw+RGWRNe0nJCwnV8ZqBbqfAvXRhNQwf50J2TZHbMuY
         jpSz+vt7b4VCoclUXSgGJbPRfIOBQAyV7wZHGKxc/ZqaLmcSvNf3iIH02U1kbWQotEiw
         BuQ4GOFxRtWRdEg5z8yGOUenWWZIGand6O/V04rn6a227NvNUcEs+HvGbZg2npEE5U/J
         g+zwBpyHjxWBOjvmlQSzg4Ka9c5Ii1Xnpq0Lfy+gjuCDirlpWg2fDoxYYi8loydiBtoG
         2q6Q==
X-Gm-Message-State: AOAM532lNl/E8XSr59yTJSeTo0JqGsNrqmuP8t8rO7y9JfAJ9XNFW2l8
        xUUY97cbDpBx780EaPOXKm3WKA==
X-Google-Smtp-Source: ABdhPJw2q8TQyLxIROIxNM+FqTDcvOyqlObGNd8CG5ooPrprP9QXKbU44njHET9XfaVzu6pvDpmMHQ==
X-Received: by 2002:a7b:cd06:: with SMTP id f6mr20962590wmj.66.1599473537964;
        Mon, 07 Sep 2020 03:12:17 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id i16sm24173748wrq.73.2020.09.07.03.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:12:17 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH v2 1/4] net: dsa: microchip: Make switch detection more informative
Date:   Mon,  7 Sep 2020 11:12:05 +0100
Message-Id: <20200907101208.1223-2-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907101208.1223-1-pbarker@konsulko.com>
References: <20200907101208.1223-1-pbarker@konsulko.com>
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

