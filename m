Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566FB38DBB1
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 17:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhEWPzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 11:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbhEWPzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 11:55:46 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EDCC06138D;
        Sun, 23 May 2021 08:54:18 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x188so18790390pfd.7;
        Sun, 23 May 2021 08:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pjK887Xz+X6T4Y2ff7RSvF+2TexghUl3NiM9BTxoguo=;
        b=l0FSlSawwB7/tYE5V52wWz5qvPUgro517N2wtmlblVZC2MFXtTrbkc2XatdXrLXf0Q
         Ho1NYYzRxRleiVHXprCGX2gExXm6PoGHUYZ7xUvFqT4ftlhRjOlZpAyPb7mls7BCNegJ
         yBfSvVhStZzSxNB4TULh28g7dkYQrWTTuHZb3fwXO0QChEshxA6UFuSLxpOUEzbIJEQN
         bMlGAdknhblnFv7r3wg+M44R6Vuxsbu3pYNuFkr/5EHqxCy/Zuu5puMeIzPkyMh9sag3
         S9U7F+mdRjLKAgQJzRQiVk6jLfx56N2hs/VfEJBRzxhxlHB2lJ87je7FB0CB9JfjokNT
         +vNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pjK887Xz+X6T4Y2ff7RSvF+2TexghUl3NiM9BTxoguo=;
        b=a2RF1nn+KnNNhJ4Se3cowWE5Q0RFTgxSmSX+/0w8+FnUPzgEM3flpzwEtBfiz/h4EZ
         rJBc7mE2NOGj6dR7fN6CbHoysr0vB19AM8oS7Xg86wooP/ZMIyCrzXnC4zaJO1Z8TqbG
         5jBP9Yp6TlM0XH7mqmaFpvOXOOa78YZB4KXkTqE3SgTD/cPqw+m588GYlqMOVCE0MzZc
         VSfblcHFqfbvqUQ5sMkI0vn0Wq59/+2rBv4BWAs1suhfRy8eskZVK0xX4b+atU2hPLyi
         jJd3WvEjY0PqYpT+5pihrUmOxl7E4ZoiRibbt/TlBiL7RrNMnuH5PI6837R97rYmKiyK
         A6OQ==
X-Gm-Message-State: AOAM530k4R0HhM5FVOE05ln+LqVW7HjgiX37Nxk5IKlGJLWnmDc3+mwB
        lkNvg67ZlsES3Xyofzq3FBfcZItKQfivQw==
X-Google-Smtp-Source: ABdhPJz/DCWT8ejE2r2GpiDFwAoIe6DMNVejMgqfWn85sjaOAIqvDq+a+/0eyJnV8dCvqdrJ/SOeNg==
X-Received: by 2002:a62:4e03:0:b029:2e7:46b3:3a82 with SMTP id c3-20020a624e030000b02902e746b33a82mr6419738pfb.53.1621785257364;
        Sun, 23 May 2021 08:54:17 -0700 (PDT)
Received: from localhost.localdomain (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id t133sm10022765pgb.0.2021.05.23.08.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 08:54:16 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 1/2] net: r6040: Use logical or for MDIO operations
Date:   Sun, 23 May 2021 08:54:10 -0700
Message-Id: <20210523155411.11185-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523155411.11185-1-f.fainelli@gmail.com>
References: <20210523155411.11185-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is not a functional change, but we should be using a logical or to
assign the bits we will be writing to the MDIO read and write registers.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/rdc/r6040.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index 7c74318620b1..aff68e2cb700 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -200,7 +200,7 @@ static int r6040_phy_read(void __iomem *ioaddr, int phy_addr, int reg)
 	int limit = MAC_DEF_TIMEOUT;
 	u16 cmd;
 
-	iowrite16(MDIO_READ + reg + (phy_addr << 8), ioaddr + MMDIO);
+	iowrite16(MDIO_READ | reg | (phy_addr << 8), ioaddr + MMDIO);
 	/* Wait for the read bit to be cleared */
 	while (limit--) {
 		cmd = ioread16(ioaddr + MMDIO);
@@ -224,7 +224,7 @@ static int r6040_phy_write(void __iomem *ioaddr,
 
 	iowrite16(val, ioaddr + MMWD);
 	/* Write the command to the MDIO bus */
-	iowrite16(MDIO_WRITE + reg + (phy_addr << 8), ioaddr + MMDIO);
+	iowrite16(MDIO_WRITE | reg | (phy_addr << 8), ioaddr + MMDIO);
 	/* Wait for the write bit to be cleared */
 	while (limit--) {
 		cmd = ioread16(ioaddr + MMDIO);
-- 
2.25.1

