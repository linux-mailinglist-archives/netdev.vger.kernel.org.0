Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DD63FD6B4
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 11:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243465AbhIAJXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 05:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242789AbhIAJXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 05:23:41 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BDDC061575;
        Wed,  1 Sep 2021 02:22:44 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id j12so3682687ljg.10;
        Wed, 01 Sep 2021 02:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AKMjpN2/BtbCv16EaWTjstGR2UORcQiJiYOiz1FEe10=;
        b=YiURxLIA7wFpM4b0F5gg4DacGxdsm3XThsNOHwtV3vJoaeoYh93YR30mmo1BAktYa+
         8MtX7pZHbGFMkh3zv9jc4xxDOQoLqoli0tOE1Y4PYSAfUB0T4qfi+fAfuSR1hwBFMSWg
         R4sxCRIr2u/DWQn2eOQd0uknd+lQVFCUieb1HPHKxznLjb7AodCf6M7rEcxT43kP0+hg
         JEJ01fTTpwd9J+5bRerUN07s5mCUXaBoCQDGAR46XXGMqJfron1hOHIj7BrPoW29YFt6
         iDLANhXP4FcORz3gUDJi/OkzBbardzehf+FNoOzfqo1xGiQJZn8thi4TeRjhamTu94pm
         fgYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AKMjpN2/BtbCv16EaWTjstGR2UORcQiJiYOiz1FEe10=;
        b=T8oA4/VleLqCFgqxzJazatfdm/uNq0OqfuR8/+9qCVDreA4uq0qPAiLaZaARIjbSYe
         1Bn1H7KAN+9yDaJy60FZtxi53ktPxfQv3euMMlUCVjRY3/2JPLKpDgIQem4TH3JOJyfM
         dnJDRzgooPQYHvQuwv9AddHJndd27bYHpbfJXsmMdCgKPVbdbTKV6jJNLYHR1MCd8MoV
         Ak8kEm6BEI6rDYEyoVgQfGPn334ar8Si1qWX7566oTuY67zBNqwRUZhOHRChBDuydHlg
         QO7qi8O4sLBSUN4M/YjEG80KGEjV7jvE885YpSA4LHjqffOTJEq/XEpXuEUefv02rSQe
         kQmA==
X-Gm-Message-State: AOAM532cJpZt0i50NTpmPY8fwQkmFUZzm8Fup/LwG2WS6tIcMZvI5Emn
        kB8cniipz5Sp4/AagC1lMFtqSUY+hwE=
X-Google-Smtp-Source: ABdhPJw0RYUDTe09wEx5vmivqCT1/uTx9mZ2U0ce0ciKVKGNSbuxAty0CIL3dCtO2RIGlCT8CoT+7g==
X-Received: by 2002:a2e:8810:: with SMTP id x16mr29470515ljh.410.1630488162989;
        Wed, 01 Sep 2021 02:22:42 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id d24sm2492372ljj.8.2021.09.01.02.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 02:22:42 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        stable@vger.kernel.org
Subject: [PATCH net 1/2] net: dsa: b53: Fix calculating number of switch ports
Date:   Wed,  1 Sep 2021 11:21:40 +0200
Message-Id: <20210901092141.6451-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

It isn't true that CPU port is always the last one. Switches BCM5301x
have 9 ports (port 6 being inactive) and they use port 5 as CPU by
default (depending on design some other may be CPU ports too).

A more reliable way of determining number of ports is to check for the
last set bit in the "enabled_ports" bitfield.

This fixes b53 internal state, it will allow providing accurate info to
the DSA and is required to fix BCM5301x support.

Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
Cc: stable@vger.kernel.org
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/dsa/b53/b53_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index bd1417a66cbf..dcf9d7e5ae14 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2612,9 +2612,8 @@ static int b53_switch_init(struct b53_device *dev)
 			dev->cpu_port = 5;
 	}
 
-	/* cpu port is always last */
-	dev->num_ports = dev->cpu_port + 1;
 	dev->enabled_ports |= BIT(dev->cpu_port);
+	dev->num_ports = fls(dev->enabled_ports);
 
 	/* Include non standard CPU port built-in PHYs to be probed */
 	if (is539x(dev) || is531x5(dev)) {
-- 
2.26.2

