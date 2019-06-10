Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 934A33BCD9
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 21:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389040AbfFJTb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 15:31:58 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45616 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728276AbfFJTb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 15:31:57 -0400
Received: by mail-pf1-f193.google.com with SMTP id s11so5852221pfm.12;
        Mon, 10 Jun 2019 12:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eUPzmPUFDWkI7Q7rSFifM1MJ4oIJgugGIlrWCoNmq3Q=;
        b=HOr0KjsXy4RvLxgagrmOUQpJlnirP4L3ubMpzwf7mujRoVTQQ6oquZ/HmC0RcCTHdZ
         IXP6CcqOWCTJ2RFIUFNJ/YWPEm6/AYmxNqH745cv/A3GZZ6xV9qgps3PelinTlWlIWjd
         zcOKz1hTmtDSqWjjOO8cRJ/gyaGrIWugbpXwYn2ya6Eec6zPfwpk4dkZZd4WmRC1r0I/
         pRCWHd9kbC6MjH+6BSj865Mj9F0zUh2y20DDMhMcRoyjs5y2lkoiDvb21UNRhuq2XgM2
         SWpnv960bgYcdztPlcRqLHwCuObRsxo+tjGvhOLmTHL0+HbAlO9uftzuuMQOod5HG1N0
         37GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eUPzmPUFDWkI7Q7rSFifM1MJ4oIJgugGIlrWCoNmq3Q=;
        b=bVuVSSGsV6VGD0KBHjuakcnIyz7kFGnY/G8nWMjzYsFe3H0J33xruI9kNSE/2bUPrK
         f66jXAYti/xLvhPRNOGWdmsTbqUN8YaHNSVpBHwSCACAp2AodZrdBki8gR/PpKB1o0SD
         cpB9Vn+YT6XpUt3ZOcUTmVHt6La61vP3d83Z3xj/nqfFpVgtIbtDDM1AqMPgwSOg0Bw8
         fDBUkc8S1uQ6hX2amo2VYvHORytZ46MCCIGu3SUpjSuJyD6OlFw/3LlcQ54r9swHKMdZ
         429KnTKfV0wMWOzyJnO/iXj4aY5UYzf5dvzKM/rrXnYKl7mc2r+BvQ2bRSrKZQShwI7A
         64Jw==
X-Gm-Message-State: APjAAAXd4d9vXerj/I3goR7LCapAOaBtqUE5wot91Yy9Cerbou+ckA3B
        cdfT0eY/Koz3R+8Jjmas0qCnGTqk
X-Google-Smtp-Source: APXvYqzV4weJYVHbnM8dqMOBdnpidy/PsGfylPEqtErDsQGPSWkypEmACLluqUG/L6Aat2lpgniH7Q==
X-Received: by 2002:a63:d84a:: with SMTP id k10mr2546494pgj.74.1560195116295;
        Mon, 10 Jun 2019 12:31:56 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a64sm10786802pgc.53.2019.06.10.12.31.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 12:31:55 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     ioana.ciornei@nxp.com, olteanv@gmail.com,
        rmk+kernel@armlinux.org.uk,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: Deal with non-existing PHY/fixed-link
Date:   Mon, 10 Jun 2019 12:31:49 -0700
Message-Id: <20190610193150.22231-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to specifically deal with phylink_of_phy_connect() returning
-ENODEV, because this can happen when a CPU/DSA port does connect
neither to a PHY, nor has a fixed-link property. This is a valid use
case that is permitted by the binding and indicates to the switch:
auto-configure port with maximum capabilities.

Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index d74bc9df1359..dde3085ff065 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -622,7 +622,7 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 	}
 
 	err = phylink_of_phy_connect(dp->pl, port_dn, 0);
-	if (err) {
+	if (err && err != -ENODEV) {
 		pr_err("could not attach to PHY: %d\n", err);
 		goto err_phy_connect;
 	}
-- 
2.17.1

