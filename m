Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B4E295A8
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390492AbfEXK0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:26:01 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39733 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390462AbfEXKZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 06:25:57 -0400
Received: by mail-lj1-f196.google.com with SMTP id a10so8195003ljf.6
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 03:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RorlBuqGStvR+lJesgnM0QQ4TctYfMpfdIOVtqYvpAc=;
        b=BLzo3fdDXaSPzhXAGsuW6oJ2Sqmz6afXa9F4IvElElmTIUt6gbO+cpCvn833+ViIGj
         DM7pmQbPpKydUyULOE3JX8N/PO7LrRFi8Mt/M+kvs15QF8F4IwuvYGMJ8mL3GxqkVIay
         XtsLIp/ItfjMg9GVWsVOZNr/DaL0jpUAlJdJDXQkxhYale4zC9RxnAD6Zem+5FhQy1fl
         HoJ8X/StCWWLuMkFjbMN4RMNxaNdJBWYmkzdP65jED3uq85xEE5pzOjRypy6jej6UW9+
         37A9Yl/RCfzL2G43Fa9D/sOwUhBDyJ5AsVq1Q7S5cn+lUUzcK9iILpNC94Uzee51NLMh
         0vSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RorlBuqGStvR+lJesgnM0QQ4TctYfMpfdIOVtqYvpAc=;
        b=T4LSx3vh6eErz9lBqnUBAg2Pzgb/IS3MFghH9C99F6W0aIKsasA3V2gIfqGrnAPKdH
         3cCacbbPJhmxUcixkSNfLy0NAPIfnfz3HnzX2jvGQN2zTMVZ8ZY/iI0RjplpTRYXy65C
         UNZ2E2Lrs8BHnfyOHg0iYQ65yiXlGMSeG8VGC4jkYA+ALXXGsaE4bYg+W3KE0ZT7kRhF
         xJxLkKkmhpnf69KSRWAqL/fWIWCOo4Y2yulv9jyQNAeVIgbHI2TYvQW3LKnFpITnE/sP
         gLm0/EK8yxZJYGDgsEoj5fBKUHJ09qSIITPSo+jkCYiSATbLxKq2CrSYhvwgvjfMuneH
         ITaQ==
X-Gm-Message-State: APjAAAVw+JbgFJtZ2uzmAA0WkjcGu4UrCXKkr1gdnGJk2FCvE9Jwxzk/
        2t0XX27IS8VxhwyvLnK7s7Ijo184HBYZMg==
X-Google-Smtp-Source: APXvYqznwyGnUjbaX8mZk3WhGXDYafMXBjuNa9J0eSVkxQ3clqMmD+s3nOLoPK2lEHYPZjWkmFTJfA==
X-Received: by 2002:a2e:6a01:: with SMTP id f1mr51390798ljc.21.1558693555288;
        Fri, 24 May 2019 03:25:55 -0700 (PDT)
Received: from maxim-H61M-D2-B3.d-systems.local ([185.75.190.112])
        by smtp.gmail.com with ESMTPSA id n7sm421567ljc.69.2019.05.24.03.25.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 03:25:54 -0700 (PDT)
From:   Max Uvarov <muvarov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, Max Uvarov <muvarov@gmail.com>
Subject: [PATCH 2/3] net:phy:dp83867: increase SGMII autoneg timer duration
Date:   Fri, 24 May 2019 13:25:40 +0300
Message-Id: <20190524102541.4478-3-muvarov@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190524102541.4478-1-muvarov@gmail.com>
References: <20190524102541.4478-1-muvarov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After reset SGMII Autoneg timer is set to 2us (bits 6 and 5 are 01).
That us not enough to finalize autonegatiation on some devices.
Increase this timer duration to maximum supported 16ms.

Signed-off-by: Max Uvarov <muvarov@gmail.com>
---
 drivers/net/phy/dp83867.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index afd31c516cc7..66b0a09ad094 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -297,6 +297,19 @@ static int dp83867_config_init(struct phy_device *phydev)
 			WARN_ONCE(1, "dp83867: err DP83867_10M_SGMII_CFG\n");
 			return ret;
 		}
+
+		/* After reset SGMII Autoneg timer is set to 2us (bits 6 and 5
+		 * are 01). That us not enough to finalize autoneg on some
+		 * devices. Increase this timer duration to maximum 16ms.
+		 */
+		val = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4);
+		val &= ~(BIT(5) | BIT(6));
+		ret = phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4, val);
+		if (ret) {
+			WARN_ONCE(1, "dp83867: error config sgmii auto-neg timer\n");
+			return ret;
+		}
+
 	}
 
 	/* Enable Interrupt output INT_OE in CFG3 register */
-- 
2.17.1

