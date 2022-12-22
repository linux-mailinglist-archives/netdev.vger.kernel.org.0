Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2577B65433B
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 15:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbiLVOgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 09:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiLVOgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 09:36:09 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03F4298
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 06:36:06 -0800 (PST)
Received: (Authenticated sender: mta@jsl.io)
        by mail.gandi.net (Postfix) with ESMTPSA id BE03E100005;
        Thu, 22 Dec 2022 14:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jsl.io; s=gm1;
        t=1671719765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CapLo+SfkwAl5jwFcDxpsuQ2IzvnSkF/btENzMotOHY=;
        b=OlIj0ZaAbmcFVNUQFYUJqW3QwjJTa+gi6gUbY6FW2gtkUtzO+IqRLqYh3uPoEfAB0Gxk9m
        Yu0KIYoX3XReQqjzYi0Gkv+aVCJbQk+P3b6oViVdK0QbdDc7jnlIvyD7E8DtlTQ3pHG3sE
        5nmHui+RfhBm0icIKggSp8JDUDTvnEFGnn55+b9/N7Cek+FEnj+melLNcykaHMzuMcgOkj
        n7Zya0Tg7NlBZJQnAv0Pa9Fcj3lL28PYb00DP/luT5akLGAcrV5YwEne5UY27VY35RyBfk
        Agg8uKGFCOX9LjfCQCMUy22NcUg/gx//smkTAb9givaNrg1TyivV2fw+fNavEA==
From:   "Johnny S. Lee" <foss@jsl.io>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Shannon Nelson <shannon.nelson@amd.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Johnny S. Lee" <foss@jsl.io>
Subject: [PATCH net] net: dsa: mv88e6xxx: depend on PTP conditionally
Date:   Thu, 22 Dec 2022 22:34:05 +0800
Message-Id: <20221222143405.1304900-1-foss@jsl.io>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP hardware timestamping related objects are not linked when PTP
support for MV88E6xxx (NET_DSA_MV88E6XXX_PTP) is disabled, therefore
NET_DSA_MV88E6XXX should not depend on PTP_1588_CLOCK_OPTIONAL
regardless of NET_DSA_MV88E6XXX_PTP.

Instead, condition more strictly on how NET_DSA_MV88E6XXX_PTP's
dependencies are met, making sure that it cannot be enabled when
NET_DSA_MV88E6XXX=y and PTP_1588_CLOCK=m.

In other words, this commit allows NET_DSA_MV88E6XXX to be built-in
while PTP_1588_CLOCK is a module, as long as NET_DSA_MV88E6XXX_PTP is
prevented from being enabled.

Fixes: e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies")
Signed-off-by: Johnny S. Lee <foss@jsl.io>
---
 drivers/net/dsa/mv88e6xxx/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/Kconfig b/drivers/net/dsa/mv88e6xxx/Kconfig
index 7a2445a34eb7..e3181d5471df 100644
--- a/drivers/net/dsa/mv88e6xxx/Kconfig
+++ b/drivers/net/dsa/mv88e6xxx/Kconfig
@@ -2,7 +2,6 @@
 config NET_DSA_MV88E6XXX
 	tristate "Marvell 88E6xxx Ethernet switch fabric support"
 	depends on NET_DSA
-	depends on PTP_1588_CLOCK_OPTIONAL
 	select IRQ_DOMAIN
 	select NET_DSA_TAG_EDSA
 	select NET_DSA_TAG_DSA
@@ -13,7 +12,8 @@ config NET_DSA_MV88E6XXX
 config NET_DSA_MV88E6XXX_PTP
 	bool "PTP support for Marvell 88E6xxx"
 	default n
-	depends on NET_DSA_MV88E6XXX && PTP_1588_CLOCK
+	depends on (NET_DSA_MV88E6XXX = y && PTP_1588_CLOCK = y) || \
+	           (NET_DSA_MV88E6XXX = m && PTP_1588_CLOCK)
 	help
 	  Say Y to enable PTP hardware timestamping on Marvell 88E6xxx switch
 	  chips that support it.
-- 
2.39.0

