Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60645554D1C
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357492AbiFVOc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353254AbiFVOc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:32:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 399713A5C1
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 07:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655908344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Sn7nOljWo/8vz7K+im5VHkWmr9wjfaGO9PFCzMSrrYg=;
        b=GpMMt7KxRySQdyjZjZlzumZaSU6IcHpGDU3hU3VN60ekACcThb3IJE0lofogg6aORQLjLo
        k4A7VVRj6wpjnbgOMAUs90js8SXHpnmOWcBDhJ6fYPO8X85ATY+cKmVneZwEsEzSxzpaEP
        OAzXOB+y2mCDj5Oa8IzRc5NrBp96DeM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-U11Ry9bjN56pph6LTBUh1A-1; Wed, 22 Jun 2022 10:32:18 -0400
X-MC-Unique: U11Ry9bjN56pph6LTBUh1A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D56B8811E84;
        Wed, 22 Jun 2022 14:32:17 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D27F1410F3B;
        Wed, 22 Jun 2022 14:32:16 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v2] net: pcs: xpcs: select PHYLINK in Kconfig
Date:   Wed, 22 Jun 2022 16:31:56 +0200
Message-Id: <54288e0ef07ac8a40cf28d782aa3f1e8acaa4b59.1655906864.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is another attempt at fixing:

>> ERROR: modpost: "phylink_mii_c22_pcs_encode_advertisement" [drivers/net/pcs/pcs_xpcs.ko] undefined!
>> ERROR: modpost: "phylink_mii_c22_pcs_decode_state" [drivers/net/pcs/pcs_xpcs.ko] undefined!

We can't mix select and depends, or that will trigger a circular dependency.
We can't use 'depends on' for PHYLINK, as the latter config is not
user-visible.
Pull-in all the dependencies via 'select'.
Note that PHYLINK already selects PHYLIB, which in turn selects MDIO_DEVICE.

v1 -> v2:
 - use 'select' instead of 'depends on' (Jakub)

Link: https://lore.kernel.org/netdev/20220621125045.7e0a78c2@kernel.org/
Reported-by: kernel test robot <lkp@intel.com>
Fixes: b47aec885bcd ("net: pcs: xpcs: add CL37 1000BASE-X AN support")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/pcs/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 22ba7b0b476d..59148d9654d5 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -7,7 +7,8 @@ menu "PCS device drivers"
 
 config PCS_XPCS
 	tristate "Synopsys DesignWare XPCS controller"
-	depends on MDIO_DEVICE && MDIO_BUS
+	select MDIO_BUS
+	select PHYLINK
 	help
 	  This module provides helper functions for Synopsys DesignWare XPCS
 	  controllers.
-- 
2.35.3

