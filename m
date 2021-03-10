Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFEF334908
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 21:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhCJUlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 15:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbhCJUld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 15:41:33 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48377C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 12:41:33 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id e26so4292250pfd.9
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 12:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yZAbveqKHb9nZIWQzQ5m9x5vCRGgZKRadCqC047fdS0=;
        b=SSf3mB2LkMoTx99zXJ6i447NkYfudCivMYVVdPkX7N+m1p/v8X0LiVMG4wNiUT83hR
         VMIUpm9W/k8qfVQBYwBxpaKctXEv8xz2bdyIVLsmAuMcwMOwJzbpl+KAXTUx/iRvAigS
         b4IWli6Tm0XoKZ+oueV4R8t/11mBSZUgVoBpVBKx5ZXJiZNt2MBo5z80ZBrmjm+AvxpH
         szC3a+XkoKcV4PYqhzQA/rdfeb8BTUjY4J/ySBCDuk9P3KA/2YRkkBZr3Ac7ziSO6aov
         2TRMcjj1Y3mybj6W50Ivx4w49fEtk7CUQPID4X9FT7lfnaMM12M1JX6nnhnjBi2E9BuB
         Bk5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yZAbveqKHb9nZIWQzQ5m9x5vCRGgZKRadCqC047fdS0=;
        b=YjCXi9bl3IhzPL9sUBqWzenZeglNhVon2ujJapTnsaBRjMQ+jl12uQYQ6fu31CLOND
         u/mGbRh15KTz7QeXHNUpnzfVoFTXniZpIsAJqQV+zGJpM3jQtClEs2PJ2pkCX+CJVjyC
         zZ8FMmZpPEns/S1MVWc0zHeAd8SB7X8hNJ4WB3Kjcpv4tollH9Q/VDXQ7Ih851n+JlMO
         9bPYOzK9aM0Xr5Cyuk8iE+ubHeWBSTGA/87pe+/OnXEWuQ4x0rWneV7QCwMVP9oYKZGK
         h6OKt0ixmSXjcUGg7faMU5e6m3OouMaZpRvzPN8kdeoDM2CxTFLquXv2eqw0gE7tulhh
         l7jA==
X-Gm-Message-State: AOAM5336kKc6N6NRV2UQCeIxyeNcWrnQjdGjFzPYRV7hEJx0rWFTN3vK
        88M47Lwsu/t7HqmlMNgoyriobX+puYY=
X-Google-Smtp-Source: ABdhPJy3m7rc7z32g00IWnfdhCmQdsTW4RF9gHavxA7v+GIxhkH10y3yDZz82D9PDeanatYhHmzrkQ==
X-Received: by 2002:a62:3c4:0:b029:1ee:9771:2621 with SMTP id 187-20020a6203c40000b02901ee97712621mr4520292pfd.47.1615408892502;
        Wed, 10 Mar 2021 12:41:32 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 1sm370213pfh.90.2021.03.10.12.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 12:41:32 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH net 1/3] net: phy: broadcom: Add power down exit reset state delay
Date:   Wed, 10 Mar 2021 12:41:04 -0800
Message-Id: <20210310204106.2767772-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310204106.2767772-1-f.fainelli@gmail.com>
References: <20210310204106.2767772-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per the datasheet, when we clear the power down bit, the PHY remains in
an internal reset state for 40us and then resume normal operation.
Account for that delay to avoid any issues in the future if
genphy_resume() changes.

Fixes: fe26821fa614 ("net: phy: broadcom: Wire suspend/resume for BCM54810")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index fa0be591ae79..b8eb736fb456 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -399,6 +399,11 @@ static int bcm54xx_resume(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
+	/* Upon exiting power down, the PHY remains in an internal reset state
+	 * for 40us
+	 */
+	usleep(40);
+
 	return bcm54xx_config_init(phydev);
 }
 
-- 
2.25.1

