Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FF0391943
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 15:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbhEZN53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 09:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbhEZN51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 09:57:27 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9344C061756
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:55:54 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g7so1629876edm.4
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l6pTB7oPQFNwM4xkFgzQblCRLDf360qrnS/iDnNwL3Q=;
        b=R3uMM+rNdOIQ2i4/1FUWxPXqf2d3HuY//Q0oYLG/nDR1+409lAbvs9gDAtxcnGinkP
         myHCBXrBlTNzmRpPlvYVpAbzw0E8/2CDafmafN+HhrBbW8AfBTCcaCuuPWbLNI9jai2j
         a3fL/HOystyx+WSAvU9Bb1dvx2gyMR6TIanIlXgB1wkm33+8OjuBasQ3ZCIuEFJbe470
         IBapqapcXanaSrFBKiLNNO0oqm+F6vvbMN66ZBqBbFYZKwro2Hkl1Z0IYVtBE70GOsh4
         +xGPFxg3iAdoZRUIj95nGnMmpwjJIGlJ/DePRQYUd4VWdg/wbAnx28zD7w9Ieqp2+mVB
         7yzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l6pTB7oPQFNwM4xkFgzQblCRLDf360qrnS/iDnNwL3Q=;
        b=K5coUya3FfS2gLwB7O1Pz3urKY4utCwHLENqYFLTxINHWpLOi1FSf6BhHxyX2sNDm4
         9CpaTVke5rYAnBrDm8w44NWqp8jcr/akt+mANp2yerxwh0aZxTYPU7q/Cu2UHXtcjmvV
         g9i/1r0qkxicwTlQ90STeJH9U1jmRZ4q+cQEFZfOPYSiE5/IW6UFklPK8XnJ9jAI/zIq
         s2wq6u3a/KFAd7fNnznGVr8Iju46DNajv3kQrzspvP4sqrpOeaVVn83pNeIcMYI391/c
         mMint+n1Cs8tkvm2Z37IOYv/gLFJm3c7tRdWOFtqm3GCTmWqsZiQfVxAwSUfFWW20wZ8
         OvMA==
X-Gm-Message-State: AOAM531h4ODB0XTXk3iDz5QUxt+vcr/ByKoiszMVuhH51Rept/kePXA+
        U19zp8J7gyz65IlSamVEDqm+1XOoWDA=
X-Google-Smtp-Source: ABdhPJz0PkbEk4itcvbcUGzTsy4Rlmxgq4kWtsiTK8GVZL/HvBGO8lS0YkrUn2kt5D62Krln8uiTeQ==
X-Received: by 2002:aa7:c782:: with SMTP id n2mr38008336eds.77.1622037353346;
        Wed, 26 May 2021 06:55:53 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id k11sm10508476ejc.94.2021.05.26.06.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 06:55:52 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH v2 linux-next 01/14] net: dsa: sja1105: be compatible with "ethernet-ports" OF node name
Date:   Wed, 26 May 2021 16:55:22 +0300
Message-Id: <20210526135535.2515123-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
References: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit f2f3e09396be ("net: dsa: sja1105: be compatible with
"ethernet-ports" OF node name"), DSA supports the "ethernet-ports" name
for the container node of the ports, but the sja1105 driver doesn't,
because it handles some device tree parsing of its own.

Add the second node name as a fallback.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

 drivers/net/dsa/sja1105/sja1105_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 11fffd332c74..b6a8ac3a0430 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -885,6 +885,8 @@ static int sja1105_parse_dt(struct sja1105_private *priv,
 	int rc;
 
 	ports_node = of_get_child_by_name(switch_node, "ports");
+	if (!ports_node)
+		ports_node = of_get_child_by_name(switch_node, "ethernet-ports");
 	if (!ports_node) {
 		dev_err(dev, "Incorrect bindings: absent \"ports\" node\n");
 		return -ENODEV;
-- 
2.25.1

