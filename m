Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6A323396A
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbgG3T6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbgG3T6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:58:24 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132C5C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:58:24 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a15so25980227wrh.10
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aIwWDhYuCoD/0vQOhh8J75E0YPkdiION+tv81FX4UHE=;
        b=YHij1Ji8sbAL7XuFcKw0LUPJVtLoZxJQCq/fAsA0FFpZoMg/9VPe444fv+jxbg3jMa
         kx2FEzwtRh3bjEa221LK5HZK3fIvGqOVFkdBzgz8SSsJx8vxdWDxlc6j33FJg93NSyRA
         G3HzCIkPAUy1plvcTDrFIXunOb3d4vqUDGjHGjaVNmvuLWJWEzM+I+eHISUxU9p6XiFX
         /2BCrDEQ9MycbnQfZozDHHrxCMWyfBsYgIuN53IPzO3rr7BlyaJRR/I4Zrdt8yjazH33
         jIqptRGbO3dVzFwmvWmo8sTV0nmWeE4tSm1KNnn1/bfatAsRhUoIKlW0CKx49UfsFCwC
         9NRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aIwWDhYuCoD/0vQOhh8J75E0YPkdiION+tv81FX4UHE=;
        b=az4M9VuXbp+zHwk5CcGwYXj9qaJStGWCoLgtBKhdooyy8ewG7wJJrtZoVE0JMe9/pE
         9xCUwxj5TI2iz935Xjz73KQVMg2sQ/4Kie/YUiA16yhNgxAkRLQ+bf5EfucJd2q4qpz/
         R8I9t0J/Xc30F59jDtyDhz1TAl/hADFDUzxTb5AO0f91yc5Qp4Aq7Vya1Zih5g7oRgeu
         mXe14oFxDFgudJJZr0EMt4bO2bWS0ukZATf6C2/aHwCC24XE6JxkdYN1Pv1bB7EJm8OM
         JXjUIDmaScfmk7v9jYMeG7yl2NlU3vrAF6MwBdJf25Q+imk5KL9x+8wWp1FEBVNI6Nd7
         lGrw==
X-Gm-Message-State: AOAM530Aa8v1s92d8Yf5h20V71TrXdFIAHrY89SWMuPnOlq+KCOEcD4+
        rTh/YrZwVemn8rOZ88iiiz0MwjTeY+QktA==
X-Google-Smtp-Source: ABdhPJw2TvK4JkncKO6UBzcLE4NgoRoMHOiBR+r5tGRK3NoCt0ESM7Jxj7kpHMmdheYYJ1D9c2Dx9g==
X-Received: by 2002:a5d:4743:: with SMTP id o3mr320001wrs.218.1596139102573;
        Thu, 30 Jul 2020 12:58:22 -0700 (PDT)
Received: from xps13.lan (3e6b1cc1.rev.stofanet.dk. [62.107.28.193])
        by smtp.googlemail.com with ESMTPSA id z6sm11326993wml.41.2020.07.30.12.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 12:58:22 -0700 (PDT)
From:   Bruno Thomsen <bruno.thomsen@gmail.com>
To:     netdev <netdev@vger.kernel.org>
Cc:     Bruno Thomsen <bruno.thomsen@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>
Subject: [PATCH v2 4/4 net-next] net: mdio device: use flexible sleeping in reset function
Date:   Thu, 30 Jul 2020 21:57:49 +0200
Message-Id: <20200730195749.4922-5-bruno.thomsen@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730195749.4922-1-bruno.thomsen@gmail.com>
References: <20200730195749.4922-1-bruno.thomsen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MDIO device reset assert and deassert length was created by
usleep_range() but that does not ensure optimal handling of
all the different values from device tree properties.
By switching to the new flexible sleeping helper function,
fsleep(), the correct delay function is called depending on
delay length, e.g. udelay(), usleep_range() or msleep().

Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>
---
 drivers/net/phy/mdio_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index 0f625a1b1644..0837319a52d7 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -132,7 +132,7 @@ void mdio_device_reset(struct mdio_device *mdiodev, int value)
 
 	d = value ? mdiodev->reset_assert_delay : mdiodev->reset_deassert_delay;
 	if (d)
-		usleep_range(d, d + max_t(unsigned int, d / 10, 100));
+		fsleep(d);
 }
 EXPORT_SYMBOL(mdio_device_reset);
 
-- 
2.26.2

