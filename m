Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38C47184856
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 14:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgCMNkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 09:40:12 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:59826 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726695AbgCMNkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 09:40:11 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 194E1C0FB0;
        Fri, 13 Mar 2020 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584106810; bh=rcAqQ1O33U21fdLUgojPBeEA9JnctLvnhRjalBTBl+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=ezSTBR352SeEGsPvGI0WubGZdMMH5XD853Ubuzb7afYnuzVU6VrXVLmLMqJrXV5/u
         tOCaQe84PFjz3yoyqzuMYcOKU3wkiVggZ+QONvQbm6ZdI34cWF7gxcsEvOy5QEd01V
         o7BcPS51EzO9fxsfUUE4WXh0dLFmOWm4w3kqp/WggMEi/jV2O1cjDXUy10VlaflYDH
         sTmQ85f+dXXbFo7ZGZYeTG7DuF4qBCXJohhjPKIER5zyreZGYCmo7WQDXKVE3DJIE5
         8pdeXdP/1Y+7hWqvHaK5IMW0FFzRKy1p3dk1Ch6r33bPFC7SNTShZI8Y0Z7QGePkIM
         6F8wqropPUiag==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 8D0ACA0064;
        Fri, 13 Mar 2020 13:40:08 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/4] net: phy: xpcs: Return error when 10GKR link errors are found
Date:   Fri, 13 Mar 2020 14:39:42 +0100
Message-Id: <314512a6938e6472237b55753b04ec83177111b2.1584106347.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1584106347.git.Jose.Abreu@synopsys.com>
References: <cover.1584106347.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1584106347.git.Jose.Abreu@synopsys.com>
References: <cover.1584106347.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For 10GKR rate, when link errors are found we need to return fault
status so that XPCS is correctly resumed.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/phy/mdio-xpcs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio-xpcs.c b/drivers/net/phy/mdio-xpcs.c
index 23516397b982..83ced7180a44 100644
--- a/drivers/net/phy/mdio-xpcs.c
+++ b/drivers/net/phy/mdio-xpcs.c
@@ -219,8 +219,10 @@ static int xpcs_read_fault(struct mdio_xpcs_args *xpcs,
 	if (ret < 0)
 		return ret;
 
-	if (ret & MDIO_PCS_10GBRT_STAT2_ERR)
+	if (ret & MDIO_PCS_10GBRT_STAT2_ERR) {
 		xpcs_warn(xpcs, state, "Link has errors!\n");
+		return -EFAULT;
+	}
 
 	return 0;
 }
-- 
2.7.4

