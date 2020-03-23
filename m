Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E6C18EE46
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 03:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgCWC54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 22:57:56 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39674 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgCWC54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 22:57:56 -0400
Received: by mail-pg1-f193.google.com with SMTP id b22so6444488pgb.6;
        Sun, 22 Mar 2020 19:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LCNpzOTbUE/HzR4l3Qcur0n2Jb8EBfncTh7DRzPIDl8=;
        b=EgCuRl9Pz9lTYHbOjBhWf1PDvq3QaqoDlyNkJbE2XjpwonjwuS5uXsoMD3X0UtsYET
         v3mHQxzbIvQQmUn4jkkavpShyYpp49a76b9hh5BGZvhlNaWpzDOA6aoBHBkrN8gFHjIG
         rjXo9oPVTDfQ/VJT3oM/3w+xmbzHciKJ+2g6lB1joU8qdzTcW4/WQsK/FgV+Z13LNuEu
         5bFCxRob4RlcHGNYBldBd3X05pKm5GVw7LWQnzGPQEEOOYv2aWeWI+n1Z/F6vN5yu5Ya
         BBIm4u+9ogA9RV8xmNCvBrgj/K4VnXu+E4CsmpHvdRp/ymM+sDFazxRXWlRg7tOfMOB3
         swPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LCNpzOTbUE/HzR4l3Qcur0n2Jb8EBfncTh7DRzPIDl8=;
        b=GhGSUFQJiZ06CffYc7grnTVm7W03oI95US+fXmJIQjtt64MnZkA5mZa4CdrmPHDZ4O
         7S/8CG5EriUi8bFOp9ki6CzNN63gzzYyHNMDX+h9QmTSmF3C3J+0tq5KYkt3urcuoyMz
         UGNRxBc9jip1u00kPlBBIw5r7dHqbP9UJrzB/jCXdcosDMHoG2pk2Tvv+Ea1o+vn1rqD
         Y44egZAJuHi/xWTqNIjoRc+92/SlVYlqHW3wpCQD+2eM5VG1UyHUq9taGTDOpmRwV8TD
         /IlJHo0bGmq3sNUHwu5407s4VZkqEG3iCijtKJRmq78r9Yj0WwCQg8wlVnDEvKCbYi6w
         EA3g==
X-Gm-Message-State: ANhLgQ14fuSdO+57dG614jXZFlbWMrnhEk6LiVbqQx+WzXjgKzOrK1kg
        XwE7yHbaYRPtqRRKXQdizQk=
X-Google-Smtp-Source: ADFU+vsKVn9fYwahIqa36/dtMadogMhOYktoHnEoNnZ/iBtmTv/Lyly09Mn24qErmVRoZ6LWrgAs2A==
X-Received: by 2002:aa7:962d:: with SMTP id r13mr23109263pfg.244.1584932275229;
        Sun, 22 Mar 2020 19:57:55 -0700 (PDT)
Received: from localhost (104.128.80.227.16clouds.com. [104.128.80.227])
        by smtp.gmail.com with ESMTPSA id v38sm10838374pjb.1.2020.03.22.19.57.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 19:57:54 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, gregkh@linuxfoundation.org,
        broonie@kernel.org, tglx@linutronix.de, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v6 10/10] net: phy: tja11xx: use phy_read_poll_timeout() to simplify the code
Date:   Mon, 23 Mar 2020 10:56:33 +0800
Message-Id: <20200323025633.6069-11-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200323025633.6069-1-zhengdejin5@gmail.com>
References: <20200323025633.6069-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_poll_timeout() to replace the poll codes for
simplify tja11xx_check() function.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v5 -> v6:
	- no changed.
v4 -> v5:
	- no changed.
v3 -> v4:
	- add this patch by Andrew's suggestion. Thanks Andrew!

 drivers/net/phy/nxp-tja11xx.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index b705d0bd798b..32ef32a4af3c 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -72,20 +72,10 @@ static struct tja11xx_phy_stats tja11xx_hw_stats[] = {
 
 static int tja11xx_check(struct phy_device *phydev, u8 reg, u16 mask, u16 set)
 {
-	int i, ret;
-
-	for (i = 0; i < 200; i++) {
-		ret = phy_read(phydev, reg);
-		if (ret < 0)
-			return ret;
-
-		if ((ret & mask) == set)
-			return 0;
-
-		usleep_range(100, 150);
-	}
+	int val;
 
-	return -ETIMEDOUT;
+	return phy_read_poll_timeout(phydev, reg, val, (val & mask) == set,
+				     150, 30000);
 }
 
 static int phy_modify_check(struct phy_device *phydev, u8 reg,
-- 
2.25.0

