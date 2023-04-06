Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEBD16D97A3
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 15:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237861AbjDFNJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 09:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237027AbjDFNJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 09:09:24 -0400
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0B949D1;
        Thu,  6 Apr 2023 06:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding:
         in-reply-to:references;
        bh=P5ACJ2S+rz/slua9T/dUeE+wX3wCOdG0OX28eLza1E0=;
        b=KT8hnRtrvRGnzG8wqYeiM8eiR9ReCj7oNBjNwd6W5jwHiYHa0ULrAjpTJ/s7t6AQCK+LnUbzC0YGN
         QuBLy4ZsxziUYs36m+DGCT1gs9tG6U+zv6X7GoUE2nCUCOUXnC/A76ZLzBVYDvN6bF0X2e72U3T2WP
         w3DogZ9ZcdIPLfg+ehBT08qOUQvnA9PJGDLhGLYql2aOHIkE5/9w6kvTFEn3KCfPJxnImx5xfj3yXJ
         l9aAIY47V8knQyx3xtdHgx89EycX15GkXMFuGoSmxEm7DLzkNbYK9EPCQNX1dPAzTbd61dCEELuflM
         L90fMNnb6yCcvn3xYPM5ZHQjuHG32pQ==
X-Kerio-Anti-Spam:  Build: [Engines: 2.17.2.1477, Stamp: 3], Multi: [Enabled, t: (0.000012,0.007277)], BW: [Enabled, t: (0.000028,0.000001)], RTDA: [Enabled, t: (0.123683), Hit: No, Details: v2.49.0; Id: 15.csws6.1gtbauqpq.6o3; mclb], total: 0(700)
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([78.37.166.219])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Thu, 6 Apr 2023 16:09:06 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     netdev@vger.kernel.org
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, system@metrotek.ru
Subject: [PATCH net v2 2/2] net: sfp: avoid EEPROM read of absent SFP module
Date:   Thu,  6 Apr 2023 16:08:33 +0300
Message-Id: <20230406130833.32160-3-i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406130833.32160-1-i.bornyakov@metrotek.ru>
References: <20230406130833.32160-1-i.bornyakov@metrotek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If SFP module is not present, it is sensible to fail sfp_module_eeprom()
and sfp_module_eeprom_by_page() early to avoid excessive I2C transfers
which are garanteed to fail.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
---
 drivers/net/phy/sfp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 5663a184644d..6f32c2ab415d 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2481,6 +2481,9 @@ static int sfp_module_eeprom(struct sfp *sfp, struct ethtool_eeprom *ee,
 	unsigned int first, last, len;
 	int ret;
 
+	if (!(sfp->state & SFP_F_PRESENT))
+		return -ENODEV;
+
 	if (ee->len == 0)
 		return -EINVAL;
 
@@ -2513,6 +2516,9 @@ static int sfp_module_eeprom_by_page(struct sfp *sfp,
 				     const struct ethtool_module_eeprom *page,
 				     struct netlink_ext_ack *extack)
 {
+	if (!(sfp->state & SFP_F_PRESENT))
+		return -ENODEV;
+
 	if (page->bank) {
 		NL_SET_ERR_MSG(extack, "Banks not supported");
 		return -EOPNOTSUPP;
-- 
2.39.2


