Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49181515D0B
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 14:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237251AbiD3MwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 08:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbiD3MwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 08:52:19 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41ECB2A71A;
        Sat, 30 Apr 2022 05:48:58 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id w4so13971978wrg.12;
        Sat, 30 Apr 2022 05:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O/FsveIK5tQmhrYWr1untBSs0r3sGQT4hudw1u1onus=;
        b=Ykrp+gWbIAq9sg9ItQWonAtSkkoJHjwOhZ4C5E5259X59O769Kdld6QrRelzl5zITG
         HjredN5f5Tp7IyAvWJvVJIFG1ToQK5u2x+cnCcgwP9ebepXkCOCmzq5Y7YXopHDyE4gH
         GpBy8GzKWzPxogUpF4l/UhEXbHfSt0jnC3SuoBqWuD+eUIu5dSaD2fPtxRdFyjTa9Gd1
         a6eFa+MGC12uDd/kmQF1272foUb0K6xyWt4E8lmMUpqpkhWyR7a+eLooa6Oz8+qvsSIk
         XdJG2ea/RfvhqRcIWs2LBg/Xkfa9R3xdjXfiBqfMndF3UQomB4QyYPNwBTegWG/Zl+j1
         Irng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O/FsveIK5tQmhrYWr1untBSs0r3sGQT4hudw1u1onus=;
        b=Bj5BbTZOU0wR1cLcW45rJG+bPlrQSpSmeR7B05NZ5JmEJ+Z+I9qe8YvrgqP4uhIvFG
         QDJZzbZSKVCd/VpNxPhcBEvEem4sEK9kBfvFNhU6/5yxrCu82CaacKUyG3FtibiseBWt
         RNHWfBBDUKeB+BjdfpOHSLTEn7SxuiYC358x4srX8NCePnksOCX85yRt6Ww6I4TWuCsl
         Cf+vLkl85y6feFcL0fr00DTBCb2XxgcuUU4kRRGdwAKpig0eBCnzRFDXrAizWUshey3p
         75/NtBQKweDneS6huW9s/KvjUU0cAbUUhsDEfZET1CmTqHHh8y/M0GlRS4B1XNOL57pW
         IQ3g==
X-Gm-Message-State: AOAM533Es991OaMKSrjZ5gdJvUFKucnITsfC4v0YjfUoJdJ3zMVeP4XS
        NZrT7cKpjPZc6C0b+veev3k=
X-Google-Smtp-Source: ABdhPJzQl6K4s0HPG395D8G2wx59Rjqyd6RKFNrzwkVH2Thj3ceGCo2cXKgVyBVws2KzTS0BC8JBqg==
X-Received: by 2002:a05:6000:1e05:b0:20a:ecc7:41cf with SMTP id bj5-20020a0560001e0500b0020aecc741cfmr2999825wrb.102.1651322936716;
        Sat, 30 Apr 2022 05:48:56 -0700 (PDT)
Received: from localhost.localdomain ([2603:c020:c001:7eff:ffff:ffff:ffff:ff00])
        by smtp.googlemail.com with ESMTPSA id f25-20020a7bc8d9000000b003942a244f49sm1717403wml.34.2022.04.30.05.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 05:48:56 -0700 (PDT)
From:   Matthew Hagan <mnhagan88@gmail.com>
Cc:     Matthew Hagan <mnhagan88@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: sfp: Add tx-fault quirk for Huawei MA5671A SFP ONT
Date:   Sat, 30 Apr 2022 13:48:02 +0100
Message-Id: <20220430124803.1165005-1-mnhagan88@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As noted elsewhere [1], various GPON SFP modules exhibit non-standard
TX-fault behaviour. In the tested case, the Huawei MA5671A, when used in
combination with a Marvell 88E6393X switch, was found to persistently
assert TX-fault, resulting in the module being disabled.

This patch adds a quirk to ignore changes to the the SFP_F_TX_FAULT
state, thus allowing the module to function.

[1] https://lore.kernel.org/all/20200110114433.GZ25745@shell.armlinux.org.uk/

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
---
 drivers/net/phy/sfp.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 4dfb79807823..11a20687b273 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -250,6 +250,7 @@ struct sfp {
 	struct sfp_eeprom_id id;
 	unsigned int module_power_mW;
 	unsigned int module_t_start_up;
+	bool tx_fault_ignore;
 
 #if IS_ENABLED(CONFIG_HWMON)
 	struct sfp_diag diag;
@@ -1956,6 +1957,14 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	else
 		sfp->module_t_start_up = T_START_UP;
 
+	if (!memcmp(id.base.vendor_name, "HUAWEI          ", 16) &&
+	    !memcmp(id.base.vendor_pn, "MA5671A         ", 16))
+		sfp->tx_fault_ignore = true;
+	else
+		sfp->tx_fault_ignore = false;
+
+	return 0;
+
 	return 0;
 }
 
@@ -2409,7 +2418,10 @@ static void sfp_check_state(struct sfp *sfp)
 	mutex_lock(&sfp->st_mutex);
 	state = sfp_get_state(sfp);
 	changed = state ^ sfp->state;
-	changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
+	if (sfp->tx_fault_ignore)
+		changed &= SFP_F_PRESENT | SFP_F_LOS;
+	else
+		changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
 
 	for (i = 0; i < GPIO_MAX; i++)
 		if (changed & BIT(i))
-- 
2.27.0

