Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F416EF011
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 10:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239817AbjDZIQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 04:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239909AbjDZIQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 04:16:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B4B10F8
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 01:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682496944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6x+QO0/D6ZnW3l2SgcHzZDuU4TgY6sqC/uSdbpmgmJs=;
        b=DoU/pH2BI1W1Saemh2W7XER65FO2Xc8n33z56amnSnJ3BiVK9NO0xnr0zEe0/Zje7sRct2
        5RCfgFJXaCDIbAR2OBzKs+EodiKNvd2WB+Ok6aD2gU6lkDzUyX3LJ0ShEdENwWaicfjY0Z
        Kr46tRpWRp5bBzqjQPBcdzdgfZBgBzM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-ZCkzw4f8MdaXNRbb65Lbew-1; Wed, 26 Apr 2023 04:15:39 -0400
X-MC-Unique: ZCkzw4f8MdaXNRbb65Lbew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49FDB101A551;
        Wed, 26 Apr 2023 08:15:39 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFB2B2027043;
        Wed, 26 Apr 2023 08:15:37 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 net-next] net: phy: hide the PHYLIB_LEDS knob
Date:   Wed, 26 Apr 2023 10:15:31 +0200
Message-Id: <d82489be8ed911c383c3447e9abf469995ccf39a.1682496488.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 4bb7aac70b5d ("net: phy: fix circular LEDS_CLASS dependencies")
solved a build failure, but introduces a new config knob with a default
'y' value: PHYLIB_LEDS.

The latter is against the current new config policy. The exception
was raised to allow the user to catch bad configurations without led
support.

Anyway the current definition of PHYLIB_LEDS does not fit the above
goal: if LEDS_CLASS is disabled, the new config will be available
only with PHYLIB disabled, too.

Hide the mentioned config, to preserve the randconfig testing done so
far, while respecting the mentioned policy.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v1 -> v2:
  - hide the knob instead of drop + IS_REACHABLE()
---
 drivers/net/phy/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 2f3ddc446cbb..93b8efc79227 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -45,10 +45,8 @@ config LED_TRIGGER_PHY
 		for any speed known to the PHY.
 
 config PHYLIB_LEDS
-	bool "Support probing LEDs from device tree"
+	def_bool OF
 	depends on LEDS_CLASS=y || LEDS_CLASS=PHYLIB
-	depends on OF
-	default y
 	help
 	  When LED class support is enabled, phylib can automatically
 	  probe LED setting from device tree.
-- 
2.40.0

