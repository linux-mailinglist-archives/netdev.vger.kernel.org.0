Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A334231B10E
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 16:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhBNP6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 10:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhBNP57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 10:57:59 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE30C061756
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 07:57:18 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id w1so7250312ejf.11
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 07:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KBldjOvO17ApSk77FiyWF1LuIv96yzQ18hN9HI7B+qQ=;
        b=RdPKJINx0gIkOo+YMBn+Xb32tzNKB3hI06oUuGg/MGJuvsQifyw3le2fJb/AwPVnFt
         uVJKlM44cEdgH4u+1u+ICy1lKq9nVb03PFEoezs4nj2I/OYqH013AUfTO+uIii+ZZSOI
         AQSKebohztClVU7jwOBMd79812yYCnm+Lo1JiERdqri7mJuNS7S41svK4enHsLoPRgph
         LdmGMlLgjrhQi80zoosI16qL6iLv5bXp5lyJN/ybVW/M9v0T8o0IaMBizXaOcWMFhhr3
         VZZAPq7H6jNj13HttUoJFzk0/HU5EGBRLXAFbGscNiiyNNbB/ABLi7lu6TYg96RuQLEr
         Qf6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KBldjOvO17ApSk77FiyWF1LuIv96yzQ18hN9HI7B+qQ=;
        b=YFHIa0lGmo+l4qGY+lyL1ghSIB+9tizVOvNEPpfwiVCLx+3/tqFIrBnXUya5pIaCjf
         s7D8f6Ctc2qKlkTSOtmPPam/InKh131MfVBthoBuR37FSSVDba6NYciutXMD8qFwgoN5
         znH403zqeQpbl0h+kpcGnIr1uqn4jDpi48JuwtJkcz8LTjhW53DEOtl4u+hAFDyWCngv
         3Ykky6LOZWK7e7XaEVXv5eVkfle+loL2ifQpZGKU68NJQJavEeqqB+nP/wo1dzLFCMWf
         2Dndco4TJzZjXlRInJSC8sJVbg/y2Vgurthi7IFToJ78DZs53K3qNHohR4X3l+mgSp8N
         QzlA==
X-Gm-Message-State: AOAM530JzgTDlkYhwB0eGOUR/uIurnsyDBOn7MSOh8vKCPgc1BdQqCDT
        yDq53L53B40+UFkO0xBZT6k=
X-Google-Smtp-Source: ABdhPJx8VsFPIpo2XWOqLie2ELwOIjfziEtC9oIKXVZ9X70EPFPzgE7xU3QONKn1VGw7gOWG026dJQ==
X-Received: by 2002:a17:906:555:: with SMTP id k21mr11854737eja.148.1613318237228;
        Sun, 14 Feb 2021 07:57:17 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id d16sm8671829edq.77.2021.02.14.07.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 07:57:16 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: sja1105: fix configuration of source address learning
Date:   Sun, 14 Feb 2021 17:57:03 +0200
Message-Id: <20210214155704.1784220-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210214155704.1784220-1-olteanv@gmail.com>
References: <20210214155704.1784220-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Due to a mistake, the driver always sets the address learning flag to
the previously stored value, and not to the currently configured one.
The bug is visible only in standalone ports mode, because when the port
is bridged, the issue is masked by .port_stp_state_set which overwrites
the address learning state to the proper value.

Fixes: 4d9423549501 ("net: dsa: sja1105: offload bridge port flags to device")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1dad94540cc9..3d3e2794655d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3282,7 +3282,7 @@ static int sja1105_port_set_learning(struct sja1105_private *priv, int port,
 
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
-	mac[port].dyn_learn = !!(priv->learn_ena & BIT(port));
+	mac[port].dyn_learn = enabled;
 
 	rc = sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG, port,
 					  &mac[port], true);
-- 
2.25.1

