Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181574567CB
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhKSCHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbhKSCHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:07:10 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A398FC061574;
        Thu, 18 Nov 2021 18:04:08 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id w1so35781354edc.6;
        Thu, 18 Nov 2021 18:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RMQJgyBENKzkTTSFzaG+/raTWPhTk69l4y3R2ofHhNo=;
        b=CGNLhoLIaKdmFWNvmOWMcPMFQOP19GqKn0W52XJcJKZIaNQkvMZ5O1xhuCIVWAhQX2
         8qVyZy9tKJIhi+UZktFkzEqX40OwQSuJ9RUU7MxdoHR/YsLq5ZhXhYsAaO3kDO12AY63
         nHSSvSGJTHk6/SyPbGxHppYD8Sac9ohb3Ns4yOb5IY/dfv/sD2CCSxSOQ6QmtYzgmJhh
         f5Nn+rh1YbNGgJ69Qj8er6B+XQt16WxGNDiBqr981LDlBXfHMLlKBW3wYQnKDkzq5I05
         o0Nbgb5la4WWgn/vlU22nPayhP8wmYS95xIB2SlO/6KIQavvEw4zFANYmUsz4lKPeSbg
         yQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RMQJgyBENKzkTTSFzaG+/raTWPhTk69l4y3R2ofHhNo=;
        b=tkIN2ROmMcfQ6C41TRgVFoZCsYXDYlihbch2gutiNhncoLo/mM2EaRMipNvpsa5kkR
         OXMJBCdK3MbRifaaPlTNhGRlK5Bx7vhNc2xuv86Xh1CTkYIZAYPpyyqfpqTkk96Jy4VG
         /UgENd26tQ3BIz8iuH9AqjsOlyYwYYbYlHMA0+jRwE8/+a4OSRXUwpru23qn7PhHMI7C
         VDyxk0CYd9hELK14BqgkG+fhyL7iVq0iW0v+cdud7yNL2Yly40Qi+SHkFKclKCaiu29x
         xYqcUEdafoXso3QbpZpi9AH1W4Qj8r6R3eEgzldGP1U+sErGMtBWwpMLkF+bX1ComV/b
         O4fQ==
X-Gm-Message-State: AOAM533fIPoP1F4SBl9EFWdHDiAlh07Mk25PRGcVLPHf3OPA7ZepJEGM
        LB+CPv1grPdSJWGJEbc7wzQ=
X-Google-Smtp-Source: ABdhPJzr/kCvEu/DZ6rUJ02zUh24zsx3XxlOv1A9p0W9FZ9mJF0cyKJzdjHLpNa1voFYhWsOBG02Dg==
X-Received: by 2002:a17:907:6da4:: with SMTP id sb36mr2905393ejc.40.1637287447124;
        Thu, 18 Nov 2021 18:04:07 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id gz26sm539610ejc.100.2021.11.18.18.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 18:04:06 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net PATCH 1/2] net: dsa: qca8k: fix internal delay applied to the wrong PAD config
Date:   Fri, 19 Nov 2021 03:03:49 +0100
Message-Id: <20211119020350.32324-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With SGMII phy the internal delay is always applied to the PAD0 config.
This is caused by the falling edge configuration that hardcode the reg
to PAD0 (as the falling edge bits are present only in PAD0 reg)
Move the delay configuration before the reg overwrite to correctly apply
the delay.

Fixes: cef08115846e ("net: dsa: qca8k: set internal delay also for sgmii")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a429c9750add..d7bcecbc1c53 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1433,6 +1433,12 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 
 		qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
 
+		/* From original code is reported port instability as SGMII also
+		 * require delay set. Apply advised values here or take them from DT.
+		 */
+		if (state->interface == PHY_INTERFACE_MODE_SGMII)
+			qca8k_mac_config_setup_internal_delay(priv, cpu_port_index, reg);
+
 		/* For qca8327/qca8328/qca8334/qca8338 sgmii is unique and
 		 * falling edge is set writing in the PORT0 PAD reg
 		 */
@@ -1455,12 +1461,6 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 					QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
 					val);
 
-		/* From original code is reported port instability as SGMII also
-		 * require delay set. Apply advised values here or take them from DT.
-		 */
-		if (state->interface == PHY_INTERFACE_MODE_SGMII)
-			qca8k_mac_config_setup_internal_delay(priv, cpu_port_index, reg);
-
 		break;
 	default:
 		dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
-- 
2.32.0

