Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C20E32D0B1
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 11:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238496AbhCDKa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 05:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238477AbhCDKaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 05:30:35 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF4AC061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 02:29:55 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id w9so488856edc.11
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 02:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+1F8iOv0nfSeXuYHm8Yzgo/v5HFID2Xq5yv5D/mRLKw=;
        b=SmJlrrpGqZeRQg8axPl4oGDAGghvBL6WRxW/Dd5Jx7Cvpb2Eys5oNpTnp5AT18Qcyc
         MXDkUei4+FJBvfkV5iecjBVxTkHM2zFLg76eQO6160DUSu/18TIuePfuIuGpBz9+qcfT
         luIQukKNYiTMJmkrkCvVO9PT3NOxQCiUCTHstf2U3BAGTQ1HmC/Om0/gzm/+PfpF//Bv
         8magJ1/a0CD6XKGa/z/LSUS6mzqxpx/4kESdkYXPrd0uBLirDGq3IU5dJ3oWm0KmcN4c
         MM1+lc119cKGJITqscyuJNAWVFP6kbrSeybGBqwkCBqL3ldSnZhsEFiakThDdAewGeY3
         ODkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+1F8iOv0nfSeXuYHm8Yzgo/v5HFID2Xq5yv5D/mRLKw=;
        b=oO2wB1s3rYaj7X+2Cc6zq34Jywl+HJc3fD6PCtpLAycy3u58k9+RkX4elsK+bK8zZa
         fEDREMPp64DO5op0QgxGDprBmxsKfQdjuht6eTkR4noasxLllwJ102EcFh8kwzJRw8Pz
         +a/wpGp+nr1n2etH+sUX2VH0nxB3K3CTq6dfA/BqiBFm3+1niZ8XKPiW6MONPD+MOCHz
         86uazPBpQfZFGm2BwJSEoRMnFplNcu89N3RYQ79iCs73L8GBWBtHeb7yB+j19JjN/Ux3
         mfrEFoL8EcWsHIwm5GW3/8SVOPUH716CgtNpizCH6ml9OEKLbLjCXTaBuAuO6arZTJ4S
         IULg==
X-Gm-Message-State: AOAM530PkmAwfTUBalnPGwKn4cE6MBhI71HpZrNJ0IhfXks6ZbAFG+IA
        5s/TJpLsMNVVsihYzJ/7o6E=
X-Google-Smtp-Source: ABdhPJxONPwmF4DPeW8P8uO3ppRBfLE9h7j99j8FZN7MoRepsgYXvXhCAW1tINi5fFqWyJrBdhiMoQ==
X-Received: by 2002:a05:6402:3075:: with SMTP id bs21mr3566556edb.274.1614853794152;
        Thu, 04 Mar 2021 02:29:54 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id bx24sm10260145ejc.88.2021.03.04.02.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 02:29:53 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH net] net: mscc: ocelot: properly reject destination IP keys in VCAP IS1
Date:   Thu,  4 Mar 2021 12:29:43 +0200
Message-Id: <20210304102943.865874-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

An attempt is made to warn the user about the fact that VCAP IS1 cannot
offload keys matching on destination IP (at least given the current half
key format), but sadly that warning fails miserably in practice, due to
the fact that it operates on an uninitialized "match" variable. We must
first decode the keys from the flow rule.

Fixes: 75944fda1dfe ("net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP IS1")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index c3ac026f6aea..a41b458b1b3e 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -540,13 +540,14 @@ ocelot_flower_parse_key(struct ocelot *ocelot, int port, bool ingress,
 			return -EOPNOTSUPP;
 		}
 
+		flow_rule_match_ipv4_addrs(rule, &match);
+
 		if (filter->block_id == VCAP_IS1 && *(u32 *)&match.mask->dst) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Key type S1_NORMAL cannot match on destination IP");
 			return -EOPNOTSUPP;
 		}
 
-		flow_rule_match_ipv4_addrs(rule, &match);
 		tmp = &filter->key.ipv4.sip.value.addr[0];
 		memcpy(tmp, &match.key->src, 4);
 
-- 
2.25.1

