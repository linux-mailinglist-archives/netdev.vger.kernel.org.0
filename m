Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CE23A49DE
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhFKUIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhFKUIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:08:20 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E576C061280
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:06:05 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id r11so38399770edt.13
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xRBvZz0lIfl1yQ7DunT3dpjQHDR3uZQtR8Zy7dtHBEI=;
        b=eutQrOM2z0zWi66eSb6VewhWJzCQMoabVUTQDr0cbi7Lg+ZLj0b9rpQf8TQ7U2eSlM
         y344OyYmjm9YX4FOs5C25fpYaZDawAvh7T/SuuyxMvQRyrT4shKSJx0z7rxImSks1YVb
         KCEOckI5UWqoVskjGOWWoxnAZMDglUJ1vQRNPlFiBL9de2sPTorxhNWIYJBHlPxI/Tol
         CUlMHkkNgzz8Op5G8o/zur6gYpGvtivmVYTfyiN39X2LSf24Z0x34XODwmYOvDSsPKOM
         rQCcKKw3bQ4m1B+GQe7ALKqUN3kDqj4FxD1ecGXMfTHUz7zLvJosKdhEUKCdtglPeJyY
         54Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xRBvZz0lIfl1yQ7DunT3dpjQHDR3uZQtR8Zy7dtHBEI=;
        b=YvxufdEAIn30Wjc3pVqAlBYSMRyP13Y5FFAPpdQHH+czXdBtInPREdG7+FXcE3ydvZ
         9jou9Ja16idW4Y2TDULbNshIAacqGgz5gdFg4/1eNG6OD7011Sobir0VtPkGL2DFKE6+
         yxYZGnqiz1t1wb0koeEOiMaQhhLbZD/XNQfRIdUpRTkq1EOA/MqtYMM2USrOeAP1z2SJ
         xcj0G4ux4hqvtkdgT7ALp5dqQWKy3XgF9Xu9TsCJ1daFuhNnPwJ+DhGHcfV3YOg7z4CE
         VUNb0/ACBA1o/9taIE+e8fb1gMUfHgwVkP+LRa7CuMMh0et9jfGpi1zYcJ6uVFU8NQ/o
         npyQ==
X-Gm-Message-State: AOAM533Zh+zFUIfCvhp/hq2O65kfP3CVMz1UHHlXfJs1Bu8Q9CgT7KRf
        JqWQ8Vf5NOGDm/KrXtDfZ1s=
X-Google-Smtp-Source: ABdhPJyuT9MfxU8KMdbPgDFY+Fo6IcLiSiWe7mongMX3p0Ssy9uL34ykPCRqQZXcSxq8RJrImQHQuA==
X-Received: by 2002:aa7:c758:: with SMTP id c24mr5635417eds.188.1623441964199;
        Fri, 11 Jun 2021 13:06:04 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id w2sm2392084ejn.118.2021.06.11.13.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:06:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 12/13] net: dsa: sja1105: SGMII and 2500base-x on the SJA1110 are 'special'
Date:   Fri, 11 Jun 2021 23:05:30 +0300
Message-Id: <20210611200531.2384819-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611200531.2384819-1-olteanv@gmail.com>
References: <20210611200531.2384819-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

For the xMII Mode Parameters Table to be properly configured for SGMII
mode on SJA1110, we need to set the "special" bit, since SGMII is
officially bitwise coded as 0b0011 in SJA1105 (decimal 3, equal to
XMII_MODE_SGMII), and as 0b1011 in SJA1110 (decimal 11).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: none

 drivers/net/dsa/sja1105/sja1105_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index bd1f2686e37d..3e32b8676fa7 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -209,12 +209,14 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv)
 				goto unsupported;
 
 			mii->xmii_mode[i] = XMII_MODE_SGMII;
+			mii->special[i] = true;
 			break;
 		case PHY_INTERFACE_MODE_2500BASEX:
 			if (!priv->info->supports_2500basex[i])
 				goto unsupported;
 
 			mii->xmii_mode[i] = XMII_MODE_SGMII;
+			mii->special[i] = true;
 			break;
 unsupported:
 		default:
-- 
2.25.1

