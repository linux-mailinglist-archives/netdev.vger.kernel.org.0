Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0033C552C6C
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 09:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347856AbiFUHzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 03:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347809AbiFUHzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 03:55:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D44F0248EA
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 00:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655798145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MFrttWgM9aYSN2X1qEZhEE65FhLfQ0o4jvZi2JEQrvo=;
        b=O67YvR/VirDb4wbHVXf7Afxsmldabo+Cz/ntysdgsDpu9WAgb60k/AuZKoJWjntbkHcEP8
        CMdN5OjhHqyGrYq/3r5MjW0ByIVH2nVBEAsFZ2iKlbMAsd+dphrZ+WVgJaj5GXsjrfqbKc
        BUTdl+d7WQAYPJu+C4by9L9gP5PJwX4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-HYR1ikSqM6mOuuRckYRYrg-1; Tue, 21 Jun 2022 03:55:41 -0400
X-MC-Unique: HYR1ikSqM6mOuuRckYRYrg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE36C80B90C;
        Tue, 21 Jun 2022 07:55:40 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BEAA2166B26;
        Tue, 21 Jun 2022 07:55:39 +0000 (UTC)
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
Subject: [PATCH net-next] net: pcs: xpcs: depends on PHYLINK in Kconfig
Date:   Tue, 21 Jun 2022 09:55:35 +0200
Message-Id: <6959a6a51582e8bc2343824d0cee56f1db246e23.1655797997.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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

We can't select PHYLINK, or that will trigger a circular dependency
PHYLINK already selects PHYLIB, which in turn selects MDIO_DEVICE:
replacing the MDIO_DEVICE dependency with PHYLINK will pull all the
required configs.

Link: https://lore.kernel.org/netdev/20220620201915.1195280-1-kuba@kernel.org/
Reported-by: kernel test robot <lkp@intel.com>
Fixes: b47aec885bcd ("net: pcs: xpcs: add CL37 1000BASE-X AN support")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/pcs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 22ba7b0b476d..70fd6a03e982 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -7,7 +7,7 @@ menu "PCS device drivers"
 
 config PCS_XPCS
 	tristate "Synopsys DesignWare XPCS controller"
-	depends on MDIO_DEVICE && MDIO_BUS
+	depends on PHYLINK && MDIO_BUS
 	help
 	  This module provides helper functions for Synopsys DesignWare XPCS
 	  controllers.
-- 
2.35.3

