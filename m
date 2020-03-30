Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3510198593
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 22:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgC3Ukz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 16:40:55 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34059 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728967AbgC3Ukx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 16:40:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id 65so23366243wrl.1
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 13:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=giEMc61bicslVarNKIkFWDcPwaj0NQvQj2GlOUKRs20=;
        b=b4/AEemUMctrQx84/dWCGocrLI/UM38ReeworbUSmRSEoCw8JCK0w41MjTuCl6L6+3
         FhBCp4GRTdIsQl9CyGnlrWJ0tgo6EOzB5E+M772nGf74AxzB7IjkozrEWV+dakcWYRMi
         jCoheIUKEi51FX90tKWiMLoxpBWhHSxQHJyIPTdF43Hb2lBARnLFL3sqDWthOQRwMvvi
         YKzVSsy9j3rvi3T0qvLWMBjvyrTsCZj2+KOO4o3R77XrDQi02GwerRRcDMd4v48+I7JC
         XSmoNAnBCtIuUAP5i426z7bDYYGd4sHwKyMDvdHfwx7gnCQsM8qJE8ZBVgnEw1XPL+98
         QCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=giEMc61bicslVarNKIkFWDcPwaj0NQvQj2GlOUKRs20=;
        b=dspYoQD/h7JQ3c8EkMsVKlyClDWoYoB4jY4YqwNiO4S0b8V41vHvsSgZwytV1mgDaA
         Cijwa0+0izvI55T/gR6sbDmALCN6IF5P+xTgYG8wg1DIPjTo5O3QXjO8eyJVvandiWnV
         7+xMIsEp7QDhl/Lmsw1Vc6ZkiDNssucdniR2vV8iuh/jrHgCg27x/MmTZFCe3hpEsgne
         1/6oNTfp/HGZ6Oln/+ignJlFyeJO/e6SdvLrCgBk5ppDMxrWlaOdnntMr6K/BnkEJh4b
         axo4uZVPVy2YdAfi5ZFYPnUF8rYTU/5ywZMgSkMc7B/z+brrkPrsmWYqUrC4PPJhy8qR
         R6GA==
X-Gm-Message-State: ANhLgQ20vK+6YZVMCc8UHtii5Izu2jChIrk/Qjh5//iolnUafCSmW1ur
        0994iETHYn62O3ERX6FYLp96ZBqd
X-Google-Smtp-Source: ADFU+vvXdCV28azhMdoxOgOA9bLPL4Pvrr8wbaMebRhLrJmm1Pxj0MG8rCWLT9cPdGIjSAFW0drzIw==
X-Received: by 2002:a5d:53c8:: with SMTP id a8mr16218858wrw.242.1585600851746;
        Mon, 30 Mar 2020 13:40:51 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o16sm23371109wrs.44.2020.03.30.13.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 13:40:51 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next 5/9] net: dsa: bcm_sf2: Disable learning for ASP port
Date:   Mon, 30 Mar 2020 13:40:28 -0700
Message-Id: <20200330204032.26313-6-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330204032.26313-1-f.fainelli@gmail.com>
References: <20200330204032.26313-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't want to enable learning for the ASP port since it just received
directed traffic, this allows us to bypass ARL-driven forwarding rules
which could conflict with Broadcom tags and/or CFP forwarding.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 368ead87e07a..affa5c6e135c 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -178,9 +178,17 @@ static int bcm_sf2_port_setup(struct dsa_switch *ds, int port,
 	core_writel(priv, reg, CORE_DIS_LEARN);
 
 	/* Enable Broadcom tags for that port if requested */
-	if (priv->brcm_tag_mask & BIT(port))
+	if (priv->brcm_tag_mask & BIT(port)) {
 		b53_brcm_hdr_setup(ds, port);
 
+		/* Disable learning on ASP port */
+		if (port == 7) {
+			reg = core_readl(priv, CORE_DIS_LEARN);
+			reg |= BIT(port);
+			core_writel(priv, reg, CORE_DIS_LEARN);
+		}
+	}
+
 	/* Configure Traffic Class to QoS mapping, allow each priority to map
 	 * to a different queue number
 	 */
-- 
2.17.1

