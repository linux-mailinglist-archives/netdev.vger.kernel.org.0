Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5494D8410
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 00:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390119AbfJOWuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 18:50:20 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37132 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfJOWuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 18:50:19 -0400
Received: by mail-pl1-f195.google.com with SMTP id u20so10295845plq.4;
        Tue, 15 Oct 2019 15:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vg7xYZ9+ZejKlKw8r28WKsh0/d0jAL+zKb5C9ek7Ft8=;
        b=fBTj3vjzaeAiJd6VIgAL/hHIPmoh5r3+eAxiG63s1heFlbYW7wJmotezCC/8ANDEev
         lilfKQuw56RDO8a38sNGdOKAaGqeeR7YEUnn4uq840W3cDaORaOvEBpLI+XO8ac8Wmgq
         gJsfunl+tE3xbyXxiQXbDByaxuCUz5+dVpoTnlOTPZ4lG61xvv1lwUceIBvo/PQTwYoU
         1VvZX6rUkDiMs9iSYUp9lBVXkA56q8dtp2SQP2R3BfH7pysWEkzqCeqmUQ3QAKY4S2Ej
         Nj8bjmVv7tHZ7yDu07XoJZcM9wt/3RYd5TTxbua4SNgozjPlxEqxTSb9CFjPA04jMNbu
         46cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vg7xYZ9+ZejKlKw8r28WKsh0/d0jAL+zKb5C9ek7Ft8=;
        b=dMlkNAS2JHg/T/TG6SLjuomgf5DbJ1F2bqbTSY60g4k43C7rL4hNSwD0GV3UlSkhRd
         IYRs9q6L1zaqpZCNS3ZrGLk9Ypm9LLg5Q0Xp/6e0KI+jsDkBCFGG0iV33k7dsn+wPrsv
         hj2asj0o0xp3r519qigSXz/WmVN9IyPwzomDirov5pESNRXvEAqx7WwlOXebeZwGfiRr
         vJHKCh8LWTP+smRnhmKxL+Gd19G/3bVpwKLmt4aXXTL2wQSfY0pv3utvM2bkrijS3WnN
         PTz23ecFvrvz3CQqMkE4PaQADNdjL7zuukA8R6uhSHZH25lRJYI9vKOUy200dMbEIse0
         J6kw==
X-Gm-Message-State: APjAAAUSijjtJL5PmhEaPW7Yw4e6EoUQwVDxbFkZ0NYaJxOVs3mh6jg4
        h4zvmM0ASNeiMbW3zMQqHdG8HAHh
X-Google-Smtp-Source: APXvYqzxQu0pEjv+doDIXfQrzPFQOpSbe14Cg27IluNj9kIzek1LVUjCP743x96MX6f83iGvnj3UZw==
X-Received: by 2002:a17:902:8b81:: with SMTP id ay1mr38309289plb.79.1571179817508;
        Tue, 15 Oct 2019 15:50:17 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x12sm20106171pfm.130.2019.10.15.15.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 15:50:17 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list), hkallweit1@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, olteanv@gmail.com,
        rmk+kernel@armlinux.org.uk, cphealy@gmail.com,
        Jose Abreu <joabreu@synopsys.com>
Subject: [PATCH net-next 1/2] net: phy: Use genphy_loopback() by default
Date:   Tue, 15 Oct 2019 15:49:52 -0700
Message-Id: <20191015224953.24199-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191015224953.24199-1-f.fainelli@gmail.com>
References: <20191015224953.24199-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The standard way of putting a PHY device into loopback is most often
suitable for testing. This is going to be necessary in a subsequent
patch that adds RGII debugging capability using the loopback feature.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 9d2bbb13293e..c2e66b9ec161 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1514,7 +1514,7 @@ int phy_loopback(struct phy_device *phydev, bool enable)
 	if (phydev->drv && phydrv->set_loopback)
 		ret = phydrv->set_loopback(phydev, enable);
 	else
-		ret = -EOPNOTSUPP;
+		ret = genphy_loopback(phydev, enable);
 
 	if (ret)
 		goto out;
-- 
2.17.1

