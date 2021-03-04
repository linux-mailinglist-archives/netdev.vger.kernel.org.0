Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133C232D149
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 11:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239118AbhCDK6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 05:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239104AbhCDK5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 05:57:50 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A2FC061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 02:57:10 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id jt13so48572487ejb.0
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 02:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b9bUYoeieSP5RN1Ykfbla4tN7LP2oMjm52vIwmbyLQo=;
        b=kR4gcWsrFCxneaQNEaklEm9tR3K8X5fJsSFByoA85Z6DuHgMXP1F9XFV1H1pbRadRz
         LdXNzfu6iL4lO+LAIZDAsLYdRIx+m9hh2OFJm2y8PRWFQEEgc5UNFMsJY3SEzKHIMDLM
         /RK9iRpm+JuhB33iu3BOq6zxFoRdiSz88aHA8YDxrluRrMKp5HtZiBahUKaiWfONoD3Z
         0ANxyMeT5TgJmSv7GBqqkkhF7cecBgyLZboj+cyCx4R8FVVuvv/TmP4pK8OgAvFNPj0A
         NLmzoPsHQCIwHZ/goN1K8aWcJ61Uma/q1k+wlkfR5TvYP3G+HPlVT0iFJCnjMt6AcipX
         mB5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b9bUYoeieSP5RN1Ykfbla4tN7LP2oMjm52vIwmbyLQo=;
        b=UDXl18tdZm2qtCkjssEX/S+nEWwQA725lWfEVDHaq8UIixuPmnHTmtIIc1NuS+3uKc
         XG2lGXHJ06mUFhffraJ1367XX92aBtmkxr8L0JqdbTVBVC16ei6voqMuJDY7VCiOp8Hb
         H12jQb/kxzYR1TSjxy911uYIKK8kVdOCQn/cdEoOmrUruJDqUlCMdscIwLQP0NPQtfJx
         ClX+RaICqooVFkV/XOXoO2bDvrY8HtfVlqsCfeMMax3e90DFR4qZlQnKK8PU+ABNjccT
         hl+sn4aqRrawbiJ6tU5YP5yjRyYKYakh9vbEM/qSBO2x35Qoj8Dita1vWnTQ9WLA6iVD
         1nug==
X-Gm-Message-State: AOAM5339cZZpQPF1isUdi2fGTfxDtFYQTMWlvWPP6S9sFTFZa0Eu1rst
        uV4RgrDlRrsXWSdnuTAnL1I=
X-Google-Smtp-Source: ABdhPJwt/CjprRQv2C1jO5FI5OPiqA0FGmANHg/xtrZVzHU3TISAocWzmQFhoaYfhbgWeUimSust9Q==
X-Received: by 2002:a17:906:558:: with SMTP id k24mr3567288eja.387.1614855428921;
        Thu, 04 Mar 2021 02:57:08 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id mc2sm19857824ejb.115.2021.03.04.02.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 02:57:08 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 1/2] net: dsa: sja1105: fix SGMII PCS being forced to SPEED_UNKNOWN instead of SPEED_10
Date:   Thu,  4 Mar 2021 12:56:53 +0200
Message-Id: <20210304105654.873554-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When using MLO_AN_PHY or MLO_AN_FIXED, the MII_BMCR of the SGMII PCS is
read before resetting the switch so it can be reprogrammed afterwards.
This works for the speeds of 1Gbps and 100Mbps, but not for 10Mbps,
because SPEED_10 is actually 0, so AND-ing anything with 0 is false,
therefore that last branch is dead code.

Do what others do (genphy_read_status_fixed, phy_mii_ioctl) and just
remove the check for SPEED_10, let it fall into the default case.

Fixes: ffe10e679cec ("net: dsa: sja1105: Add support for the SGMII port")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 7692338730df..c1982615c631 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1922,7 +1922,7 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 				speed = SPEED_1000;
 			else if (bmcr & BMCR_SPEED100)
 				speed = SPEED_100;
-			else if (bmcr & BMCR_SPEED10)
+			else
 				speed = SPEED_10;
 
 			sja1105_sgmii_pcs_force_speed(priv, speed);
-- 
2.25.1

