Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5366181B8B
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 15:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbgCKOlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 10:41:42 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33412 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729057AbgCKOlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 10:41:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id n7so1476449pfn.0
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 07:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=JtQQJXaF2Ei5pbyln57WsRWWcGxciQ6YxzEePcbiHcc=;
        b=WtS+Glmwe44hf51kgEogxRQpx4pDeCkbUpIRIwGt8pRX5X71Ip48DyjS/pmYwyXwtX
         mbXFX1p5bOXeuyb60C5Uf2SddvgLd/1hTPC31aabyZHDTPTQLohtSYBsixeomTbQBIts
         HiMwzS92KzfH3lTgfO7LmZfQOVZgKpZvU9vVT/hyc50k9nzCyUrqRFdJdEUM7jwjSvAK
         +rWLyISuaEi2hf3wWeSTbhdgx98pbQk3CKneDiNS4ptwcFyB1lMLdLXi8XgtOCC+wHX1
         RTeSS+xwHYJknTdCNrDeoDj2UUtyULG9b9nUjLpfTpSxce+c5MF2yCEDxs6ov/+Cfx3B
         9K/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=JtQQJXaF2Ei5pbyln57WsRWWcGxciQ6YxzEePcbiHcc=;
        b=rmYKQT+1m4nUtBZ8KxofKUbJhq78SqzCMAnEQOhtsvPxWm2FJzSCqeCLaq/fDR8VDo
         PRM47y7jPwepVeUyxNxC5ubWGy/y9ck+548BuCDcge9zvBkcHkJz75aLWoWaCdYDscEj
         aYkK0nhFkDqVZUmq96CXr5kfQK0e/rQcr7N71GWtZ0BpBeCPcPjXLU9Nw6moxAgEnFY2
         u2lmuBwBXUAZ2JZ2eahvfOYRCSHCYyGind3sGRu0FfXBPG57ktqQnye+174BfQxrXFGY
         bWWFjIUMkehsDzAAsQmmkiW3x2HsmFzSKYkKI//IKN5om6Kl8x/dnyOS+TkTkTOMpqa6
         NW3A==
X-Gm-Message-State: ANhLgQ1ChPVOTYJ9VWaIwtn7DigE9lO6v+D3yWKJW8WbeACCV+Fl4bZ8
        /0bBEpdZA6fTfQBtCkDVdbRGRtpFKy0=
X-Google-Smtp-Source: ADFU+vumxBGfFON8cgPufDSZkqvR5eLCjtem2LFZGXUS2jtHhPAUdlQni9eF/tU3EzetyBOg9QMkuw==
X-Received: by 2002:a63:1b22:: with SMTP id b34mr3046726pgb.415.1583937700840;
        Wed, 11 Mar 2020 07:41:40 -0700 (PDT)
Received: from DESKTOP-DJ7UMF3 (bb121-7-89-109.singnet.com.sg. [121.7.89.109])
        by smtp.gmail.com with ESMTPSA id 25sm912849pfn.190.2020.03.11.07.41.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Mar 2020 07:41:40 -0700 (PDT)
Date:   Wed, 11 Mar 2020 22:41:38 +0800
From:   Darell Tan <darell.tan@gmail.com>
To:     netdev@vger.kernel.org
Cc:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
Subject: [PATCH] net: phy: Fix marvell_set_downshift() from clobbering MSCR
 register
Message-Id: <20200311224138.1b98ca46f948789a0eec7ecf@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.30; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix marvell_set_downshift() from clobbering MSCR register.

A typo in marvell_set_downshift() clobbers the MSCR register. This
register also shares settings with the auto MDI-X detection, set by
marvell_set_polarity(). In the 1116R init, downshift is set after
polarity, causing the polarity settings to be clobbered.

This bug is present on the 5.4 series and was introduced in commit
6ef05eb73c8f ("net: phy: marvell: Refactor setting downshift into a
helper"). This patch need not be forward-ported to 5.5 because the
functions were rewritten.

Signed-off-by: Darell Tan <darell.tan@gmail.com>
---
 drivers/net/phy/marvell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index a7796134e..6ab8fe339 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -282,7 +282,7 @@ static int marvell_set_downshift(struct phy_device *phydev, bool enable,
 	if (reg < 0)
 		return reg;
 
-	reg &= MII_M1011_PHY_SRC_DOWNSHIFT_MASK;
+	reg &= ~MII_M1011_PHY_SRC_DOWNSHIFT_MASK;
 	reg |= ((retries - 1) << MII_M1011_PHY_SCR_DOWNSHIFT_SHIFT);
 	if (enable)
 		reg |= MII_M1011_PHY_SCR_DOWNSHIFT_EN;
-- 
2.17.1
