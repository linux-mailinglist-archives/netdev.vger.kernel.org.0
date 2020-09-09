Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45747262CCF
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 12:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgIIKEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 06:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgIIKEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 06:04:38 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7F9C061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 03:04:38 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id c18so2252701wrm.9
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 03:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pRUN7p1qzh/z0sF2kkFkWXZEvmC67k/rtM33VZEr1RY=;
        b=EsiWTg2DgucOy7ksi0tfoaZP/MIDdLVdJK6TrCTZfdujWCAm0vtNaoQsxNyys0HHjk
         UN/wZNC1fFhLtMWN+LqYZLyzaHHa7QBPfVqxj0zSMTOqwF4DSYX5WDXnEPP2otEm4VgA
         +IKEqwFdqSbPfJrSTn/N4fMX11qScykaIqZig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pRUN7p1qzh/z0sF2kkFkWXZEvmC67k/rtM33VZEr1RY=;
        b=dPZlpcaOn5fxpofMjKluvkenic6RPMb4hZKYUk6o63Na1MwFDC/J9iWQSTO6Supy6g
         doSYyjZKtQnNtpOKyMp5lF/7jBakenwXFlz/zzHynkMF9gjlk8qCezgOr6ap7LNueWcK
         NojvAcfA4JgCigfsF14KlyHYGjgp7i8QKoWMH5ZQGvOrmjc0+UiINk/G8ubyUlBtKFBS
         GaHoYnl6uXMnYMr5mn6gtKooiGaza4YtCyLU2cV6xihMroS33oGutIkE1FEJX/71QWCP
         VB8Ctmg6nwczg4YbNDk9rUmsUOyVLG/306rrD1HJa4lLkMy41pohcqCEbPGzt19KL9Qs
         H7cw==
X-Gm-Message-State: AOAM533m3ITvj9ZMAoqdM+oonvvtqOqyI0V1UNFhJM/ykn1AsJUwbpqi
        RnsbKZAUTnTzQBw199b3etpOqA==
X-Google-Smtp-Source: ABdhPJzswvZt4mmoAPxtvxnzDKiIP+BRMmg7AkmT1c0NdWDTfK22qJv1fOUxhe0V0WqcmqSOfNvRqg==
X-Received: by 2002:a5d:60cc:: with SMTP id x12mr3132553wrt.84.1599645876890;
        Wed, 09 Sep 2020 03:04:36 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id l16sm3828237wrb.70.2020.09.09.03.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 03:04:36 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH v3 4/4] net: dsa: microchip: Implement recommended reset timing
Date:   Wed,  9 Sep 2020 11:04:17 +0100
Message-Id: <20200909100417.380011-5-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200909100417.380011-1-pbarker@konsulko.com>
References: <20200909100417.380011-1-pbarker@konsulko.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

