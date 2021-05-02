Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22D9370F9D
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhEBXIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbhEBXIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:19 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA010C06138D;
        Sun,  2 May 2021 16:07:26 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id m12so5224398eja.2;
        Sun, 02 May 2021 16:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3Fz5YjFSkPaMwcaNx5BDYLv2IvhzfHI26C3Hc8T8qMU=;
        b=WGJL5XoYFaiBCvlBqD66pKZqsMH+KBi8h3pgWpzqmlgZ1H+3PUycFHO5kFI50nWc3X
         CMIAJhLpQhbT0TtRsRmzXI7c+TIQfjT+hA1ox5wXsVkyBQBeUF+eKmbXTXCs5DpSrJC2
         mB6NP8DQZbn0t6axIpo/hz2JHAzMiY2MW4RdrCw09wKP3H1syqc6CqjeQf5Ybamc/igh
         +yEiH8rgCoUnwJZwIg68JRK75IPgUeH5wSxJdQmkBws9U3EJqzkGcVU/U7oA2Yuyf2mh
         fpzm+RgpRBhfLQ/4fUjOHO8fqnlu2iZi1lrB/CiC8i1Wpp1CNsC2o9sN8fDv9kNEgFJc
         ogPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3Fz5YjFSkPaMwcaNx5BDYLv2IvhzfHI26C3Hc8T8qMU=;
        b=hE9JASIxr3k0Mvi4VZ3BPUDpQFSkkk6G7ztZGkUyo97UzDrHveeyKm46+0FbbJZPMr
         NmplS+20qe8SY9+C1Xuw4srfxCPzkFw81V+g7TpRuMO9xOYE91gZnI3w9YHesyOj7EPA
         PSsrgcKhrXQFBtTQWR14ZgUhIWhw6rXll5PmLqEa0zUHfP8Rb+ktvdoPGrsxdXxGe+Nm
         IWppCXSCuM5q+lqiF8hTelXff+bWKc2MMd3zJujfMy5HCG6pac7MK1+OOX8O73trjiIi
         INoz0rudrdGmp/jCY/ZrCQtUHTgH4MurdOuiHEBXjCa/yGRwJkcw4ZdeX1HtArf03Sby
         4z2g==
X-Gm-Message-State: AOAM531g2v/Lj3wSSQG49/j9dOWx7EvLPt8a7YO4CyvAvobCbk3dPTTf
        9NElnGtPHdmkYcfwbQ0DOls=
X-Google-Smtp-Source: ABdhPJx5W+mnwQDb5nVvmTHfoSK7hOnlzI7xGnksC7UgfFxtsVHTTZuvuw7BrVB6pETCJX2Zs+Z65g==
X-Received: by 2002:a17:906:17ca:: with SMTP id u10mr13717344eje.124.1619996845517;
        Sun, 02 May 2021 16:07:25 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:25 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v2 11/17] net: dsa: qca8k: clear MASTER_EN after phy read/write
Date:   Mon,  3 May 2021 01:07:03 +0200
Message-Id: <20210502230710.30676-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502230710.30676-1-ansuelsmth@gmail.com>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clear MDIO_MASTER_EN bit from MDIO_MASTER_CTRL after read/write
operation. The MDIO_MASTER_EN bit is not reset after read/write
operation and the next operation can be wrongly interpreted by the
switch as a mdio operation. This cause a production of wrong/garbage
data from the switch and underfined bheavior. (random port drop,
unplugged port flagged with link up, wrong port speed)
Also on driver remove the MASTER_CTRL can be left set and cause the
malfunction of any next driver using the mdio device.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d522398d504e..f64e3215a515 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -639,8 +639,14 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 	if (ret)
 		return ret;
 
-	return qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-		QCA8K_MDIO_MASTER_BUSY);
+	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+			      QCA8K_MDIO_MASTER_BUSY);
+
+	/* even if the busy_wait timeouts try to clear the MASTER_EN */
+	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
+			QCA8K_MDIO_MASTER_EN);
+
+	return ret;
 }
 
 static int
@@ -674,6 +680,10 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 
 	val &= QCA8K_MDIO_MASTER_DATA_MASK;
 
+	/* even if the busy_wait timeouts try to clear the MASTER_EN */
+	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
+			QCA8K_MDIO_MASTER_EN);
+
 	return val;
 }
 
-- 
2.30.2

