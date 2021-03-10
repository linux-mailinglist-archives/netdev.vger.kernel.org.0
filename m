Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DCB33490C
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 21:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbhCJUlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 15:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhCJUlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 15:41:35 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8DEC061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 12:41:35 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 16so5754684pgo.13
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 12:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VyG04wrih8NReE1caAJfJObEM9wOJAjCsx7lqTeXEJk=;
        b=bKk+w4heHTPaHAO2kBaBGm+Z7iri/PQtO5oF9C0l6bH7pI/sHcpUT7jDd5OXIzLr6k
         0q449fxHcmLz0UiP95EaDPliuyGRSRTEys3Ctctu4yFF2o2dk99q288Yc12E3oyS9aCt
         9rmIqNW83rxH0cmZvVt+8kjaYdcxwYDV22OzTlUPBgNno0Sq46jTMVpOo+x+i2VdmaOR
         vpaBKnc7WnAp5/Jlo2sD5oQb9R/X55TnVN77d63l/8U1NY18g1jXxzZfNraV2N58Mhoy
         CPk1/clPnYIBUwqX//HBDKz5UBu4HavgI4d0bkxNjol2rhvasr42r4TZiGbhCrPsRyyc
         XJiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VyG04wrih8NReE1caAJfJObEM9wOJAjCsx7lqTeXEJk=;
        b=VJcWO/owypTkkBLPhJUcX5HdPyZbP5J63Cma3k3mnBCPfHg/Cs/cPZb2fEA6rWadOG
         LXN7piHwE2u/HFahVg0kjc2DOProRGxDnVloYHup0leLpGuF55emutDkQH4mfuApFOow
         tKXd+J2XvbK7ffNrcXf5jcrnEk2y0fUX5xAYXOA4zRh7CwhadmfQgk4S2Fiu0yCKASJb
         MZQm7JxvKM36u1k25c/IUiSpY5cxNLMaeUGYU0v41DbLBaEtKsTchRIzT+q5kqFBzfOC
         WxayJngKcmgOe/dxAWR1krfJHt3zgJ9+hDq0e0wqdS8rl6ny5tJnRRhAWmcCg61Tp652
         pWEw==
X-Gm-Message-State: AOAM533F6GEuBAq70zjWgRUWYBEnHxxqydQQSgsHiqtYU2jb33qafenM
        wv/9IYa5WS5YzyLiByRriFJin772cdk=
X-Google-Smtp-Source: ABdhPJwS8WZWwkxnYdsKDWn39zUckQJoqMF8H2U14VxatZ0MPP6Hxys3d3lQ0Mxp933XnhQTePnUVw==
X-Received: by 2002:a63:5a50:: with SMTP id k16mr4255298pgm.155.1615408894880;
        Wed, 10 Mar 2021 12:41:34 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 1sm370213pfh.90.2021.03.10.12.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 12:41:34 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH net 3/3] net: phy: broadcom: Use corrected suspend for BCM54811
Date:   Wed, 10 Mar 2021 12:41:06 -0800
Message-Id: <20210310204106.2767772-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310204106.2767772-1-f.fainelli@gmail.com>
References: <20210310204106.2767772-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the non read/modify/write version of the suspend procedure for the
BCM54811 PHY.

Fixes: b0ed0bbfb304 ("net: phy: broadcom: add support for BCM54811 PHY")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index b33ffd44f799..14980ef44b42 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -804,7 +804,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_aneg    = bcm5481_config_aneg,
 	.config_intr    = bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
-	.suspend	= genphy_suspend,
+	.suspend	= bcm54xx_suspend,
 	.resume		= bcm54xx_resume,
 }, {
 	.phy_id		= PHY_ID_BCM5482,
-- 
2.25.1

