Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73811FFDAB
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730379AbgFRWFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729796AbgFRWFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:05:19 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21F3C06174E;
        Thu, 18 Jun 2020 15:05:17 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k2so3193768pjs.2;
        Thu, 18 Jun 2020 15:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DFuspUBCAWSfBUM7wRuDqizerOunF3nyVfYMWAoB1Xs=;
        b=GjGtbt9QqhdRWSt3FcrN78a+L3SHC7LX0DBNavohIshzAV2OHy3+0MM/pYHX/38FNA
         e2vPso9zBRbVRuyAlJZWeR0PsFXKtRrFTbyy4W4NxYU8AjOH1l5de+yZg2uA/v7L0Zlm
         AOd8sjwNbVJAKiaPDMub3MtZ2i8rUAyT27qt4oXkGEjOdZQArug5CykTOpYWiD7oqOXU
         H+arEG5mMRyBtMIj7NBfoj9yXIlbv8To1pb8kxBNxkH6v8DZzJmhL0AkTP2gJCFvuQQq
         u05bvhp3V8luYWKfKEQ+A0P4WxSjlfl7hkNVsUedQ4dVl1NyiWtKUT2aMOXRBQS8KKAN
         F1ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DFuspUBCAWSfBUM7wRuDqizerOunF3nyVfYMWAoB1Xs=;
        b=nmwMOWAlHHdhpefMZU1RDRf8KBJW1gm9GJ6LJoxkwKJjTBmwrGgwKlNq5eYYFEzm2r
         pg/Jhz5YKXogS2v/RVWxFhST7YniHn5oFmAOvXNCZoswZ1UyqMiSSkgKZ/YiAGHQE7HK
         fmtVJHCgnEeRL/v/e6V3iS7N9YIlh+1gQ3mdEXoGD7vMDQahg98sDzLy8C89mqSlRZ4N
         3DWrmDD7jN1qJUu+lUx49Ki0Fb8lFHlRKvPoqeEA6yXOVdqlIipQrteIlzzSUfcFSYOX
         aMTmlT1ziAXoNJZBmoSUWagqnD6h4cwnxsGC2JOcMavpXdYDEXE8DKP+jx1F3K1qMEeR
         0ldg==
X-Gm-Message-State: AOAM530Gammn2Ho3N6+6cmWCKeS6fuGPuUl5An5YkU6FpAjyJGOzB8io
        EpYtqvqJxnYpKZF0vGLsFSc=
X-Google-Smtp-Source: ABdhPJz0a7CgPcnqPMHYsXarirAvcaspBT3OSoe0R1KuP1eYrpJDTy8RtpiAEign488GX9+rwiHsAA==
X-Received: by 2002:a17:902:6a89:: with SMTP id n9mr5289437plk.337.1592517917384;
        Thu, 18 Jun 2020 15:05:17 -0700 (PDT)
Received: from taoren-ubuntu-R90MNF91.thefacebook.com (c-73-252-146-110.hsd1.ca.comcast.net. [73.252.146.110])
        by smtp.gmail.com with ESMTPSA id k18sm3765999pfp.208.2020.06.18.15.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 15:05:16 -0700 (PDT)
From:   rentao.bupt@gmail.com
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org, taoren@fb.com
Cc:     Tao Ren <rentao.bupt@gmail.com>
Subject: [PATCH net-next] of: mdio: preserve phy dev_flags in of_phy_connect()
Date:   Thu, 18 Jun 2020 15:04:44 -0700
Message-Id: <20200618220444.5064-1-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Ren <rentao.bupt@gmail.com>

Replace assignment "=" with OR "|=" for "phy->dev_flags" so "dev_flags"
configured in phy probe() function can be preserved.

The idea is similar to commit e7312efbd5de ("net: phy: modify assignment
to OR for dev_flags in phy_attach_direct").

Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
---
 drivers/of/of_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index a04afe79529c..f5c46c72f4d3 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -380,7 +380,7 @@ struct phy_device *of_phy_connect(struct net_device *dev,
 	if (!phy)
 		return NULL;
 
-	phy->dev_flags = flags;
+	phy->dev_flags |= flags;
 
 	ret = phy_connect_direct(dev, phy, hndlr, iface);
 
-- 
2.17.1

