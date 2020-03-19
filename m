Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B0018BFBB
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 19:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgCSS4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 14:56:30 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38754 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbgCSS4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 14:56:30 -0400
Received: by mail-wm1-f67.google.com with SMTP id l20so3616066wmi.3
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 11:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=87F1e/K9UnFLDCEIg+AS6R5nXrHXaWsW/Toxk015dAY=;
        b=bHTKRWg4nScPaTcTqfSWx24/7+IYbpTqSy8G78+22GOD8XV06aFhPFNPoKIlbBgv9D
         nGHPoS+6s7G2VU3hgdqYFH6KnLgg6LCK9MyU6L6WwIgoZiduVpHmZrHRoITvpto9sWdF
         96WzW48glEqi8er9avHX7qv8Ht/aKXB/3Iv/fFPr/9WZgAzZaSbNxKOf2qU2/F/lzVGH
         Er1lLLghCB/oHvcFf8eoZoOQ7ANMpi48fbdVjsWf7eyk5MUM9bpA9dUyEXnmrmeH80Yt
         eQy8HtsnAu36knaN0d/LsBSqOENGM3rhjOl2h8y35vCn06FVVwnnCmOAJ10hXobjzWp5
         wUag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=87F1e/K9UnFLDCEIg+AS6R5nXrHXaWsW/Toxk015dAY=;
        b=cPrVQpTTAoVnpJUH52Uh2Gf/+tdI8rclS0QR+D7X7mrDkOvd0Gjg2H03RSTLm0vP/6
         H5k3xr5iSQjVObhX+d01rHi1T97m4+sASN77YaLfu7AaopXajl7jNYa7yS4nWTKTo3wA
         dF7v//juhupiLZOC1oZnxjKqYTzkADQ8yBGFEos7bQMHQKwIIuE0XPMeM8vZrVy5sVzn
         9vYoe80JCI0h7CfOFYRuI/K5HRK5/pZ0H+0JiWsIGJrQiKtm3Xt8QpwrnQn6XPOD7W5j
         HVR2woih2Gt6AKBq9DCc0DaHposuCtpp68otn8kV7exDjeFqSBxWrD/OnqzZDGg3iveV
         t4Cw==
X-Gm-Message-State: ANhLgQ0W0ZAlzGqz9z6847O1AwWoDkC+9QC19IcqlXiLIh+ZoOQXUpGy
        /HrbBpKNc/cNH37AisnSOSA=
X-Google-Smtp-Source: ADFU+vspsDvFkIxEOahc5MAiGh2eHKMmkeSyARy1cTLfD/GaD7EtIsuRz1sx/vIdms6+f1zVsBKrkA==
X-Received: by 2002:a7b:c153:: with SMTP id z19mr5099073wmi.37.1584644189026;
        Thu, 19 Mar 2020 11:56:29 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id i9sm4314452wmd.37.2020.03.19.11.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 11:56:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: [PATCH net-next 2/2] net: dsa: sja1105: Avoid error message for unknown PHY mode on disabled ports
Date:   Thu, 19 Mar 2020 20:56:20 +0200
Message-Id: <20200319185620.1581-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319185620.1581-1-olteanv@gmail.com>
References: <20200319185620.1581-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When sja1105_init_mii_settings iterates over the port list, it prints
this message for disabled ports, because they don't have a valid
phy-mode:

[    4.778702] sja1105 spi2.0: Unsupported PHY mode unknown!

Use the newly introduced dsa_port_is_enabled helper to avoid this.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d8123288c572..8152b68389a7 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -162,6 +162,9 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv,
 	mii = table->entries;
 
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+		if (!dsa_port_is_enabled(priv->ds, i))
+			continue;
+
 		switch (ports[i].phy_mode) {
 		case PHY_INTERFACE_MODE_MII:
 			mii->xmii_mode[i] = XMII_MODE_MII;
-- 
2.17.1

