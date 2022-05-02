Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91BA0517A07
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 00:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352170AbiEBWgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 18:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345562AbiEBWgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 18:36:54 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78271101C5;
        Mon,  2 May 2022 15:33:21 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id k2so21194062wrd.5;
        Mon, 02 May 2022 15:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NCEj5GMAzzn+PrpVx+OQFAucjbV/+hpyT4Q10dBlXEU=;
        b=LWsRTqbs1XNCflqZ21mUl3rc0f8DxhKJqSu+tqf6Vz72OyAwDqIwup6swLoyMW1tw6
         PRUP5y82v9AKO7H+ZY7qYabv0VWd9XTIrlqf1CFKZv5rUvPTPFPaOBPd6oAvTTmleyQ1
         mpO0pXHfgkv7W7oKa1fRe7waTVbVAHxv6RMluypQyHEzV463uIuqn6KXZhiiE4Pc+mIG
         kzFZ0TCz4waoQQAKwvBuJ8kW0QkFwLYs4vGtCgy2cwxfhlPqXnOPTaAULc7DHOeEL4Vz
         fOIxgupb1io7kfcJzkTQVC7BWUabG3kduYhwLTkbmSuYvJ0LmriTF50NKwo9na1aXg/m
         bCIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NCEj5GMAzzn+PrpVx+OQFAucjbV/+hpyT4Q10dBlXEU=;
        b=7n0CHecF6ngTBCaVt/ibVPV6HTA0F+YhaQjo8BXfuKAY/oEs623K8txtGe/zK/uJsM
         d5FXFi8ci5++NFXk/zKEx4pKImbC5MbkiiWYWxZJT94GLt/LXuGQO1oVjUrUEL6dp9Oz
         56CocnxN87t4hILLpQvM4w0MoKa+gueBdU7Jpp1j8e5LIOYGNCzycYl/LPQdjM1qVGrD
         4TL3mZ9cFiBZ4/TU2X8ogroOSqicwDy84GS+S7ZF/VBBOtKEkt2VFSOmnk1b1Zz6VEBC
         NFePfoh+FN+v8BPZybbjPfk5MnqDzBes8BlnoXvNHC86gtloBJN8Px4kjqgf2NyibgGr
         7XYA==
X-Gm-Message-State: AOAM530XU/QQ5SUTuHo1OJeGvtrpIUxY4/PuM41sWxhDXiMwYUlca1bK
        2qqCfYd6coBCqNnLRTbIYB0=
X-Google-Smtp-Source: ABdhPJy7HO/WgOLZBexxRyUdlQ7CvaTY0gtiJk/WABDxjWcGGOi7Qrf25z9a19KkEFFZ2jqk4OJhOw==
X-Received: by 2002:adf:d1ec:0:b0:20c:61ef:93b6 with SMTP id g12-20020adfd1ec000000b0020c61ef93b6mr5704971wrd.694.1651530799883;
        Mon, 02 May 2022 15:33:19 -0700 (PDT)
Received: from localhost.localdomain ([2603:c020:c001:7eff:ffff:ffff:ffff:ff00])
        by smtp.googlemail.com with ESMTPSA id bh19-20020a05600c3d1300b003942a244f45sm346682wmb.30.2022.05.02.15.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 15:33:19 -0700 (PDT)
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
Subject: [PATCH v2] net: sfp: Add tx-fault workaround for Huawei MA5671A SFP ONT
Date:   Mon,  2 May 2022 23:33:15 +0100
Message-Id: <20220502223315.1973376-1-mnhagan88@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As noted elsewhere, various GPON SFP modules exhibit non-standard
TX-fault behaviour. In the tested case, the Huawei MA5671A, when used
in combination with a Marvell mv88e6085 switch, was found to
persistently assert TX-fault, resulting in the module being disabled.

This patch adds a quirk to ignore the SFP_F_TX_FAULT state, allowing the
module to function.

Change from v1: removal of erroneous return statment (Andrew Lunn)

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
---
 drivers/net/phy/sfp.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 4dfb79807823..9a5d5a10560f 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -250,6 +250,7 @@ struct sfp {
 	struct sfp_eeprom_id id;
 	unsigned int module_power_mW;
 	unsigned int module_t_start_up;
+	bool tx_fault_ignore;
 
 #if IS_ENABLED(CONFIG_HWMON)
 	struct sfp_diag diag;
@@ -1956,6 +1957,12 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	else
 		sfp->module_t_start_up = T_START_UP;
 
+	if (!memcmp(id.base.vendor_name, "HUAWEI          ", 16) &&
+	    !memcmp(id.base.vendor_pn, "MA5671A         ", 16))
+		sfp->tx_fault_ignore = true;
+	else
+		sfp->tx_fault_ignore = false;
+
 	return 0;
 }
 
@@ -2409,7 +2416,10 @@ static void sfp_check_state(struct sfp *sfp)
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

