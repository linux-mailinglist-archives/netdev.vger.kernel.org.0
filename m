Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE0454E6AB
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 18:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377903AbiFPQJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 12:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiFPQJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 12:09:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD0893BBD2
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 09:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655395745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4UlfqnsKfoPacVcltxpTNbmIYI6wNPfePNniZn5M9NQ=;
        b=SLQ5K+pKmM0qG9d1heEWTafxHN6Vq+kaQ03gJf0TkFsGbzhoz50ANzGDoxAyW9DJ2i3QE8
        X1ltvC51g5MFAsNva1hCsasRDUatL3Midd2SUNfS1ElNPawUamXrCf3hRHvM/NnxJQkyWX
        TAR3qgC5hGtTQ6IxQruSJGiQyqtYoDg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-JJ4HsWfnMXa8ypiro3AvUw-1; Thu, 16 Jun 2022 12:09:02 -0400
X-MC-Unique: JJ4HsWfnMXa8ypiro3AvUw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79022100BABC;
        Thu, 16 Jun 2022 16:09:00 +0000 (UTC)
Received: from p1.luc.cera.cz.com (unknown [10.40.193.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B76A61415106;
        Thu, 16 Jun 2022 16:08:58 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] ethtool: Fix get module eeprom fallback
Date:   Thu, 16 Jun 2022 18:08:55 +0200
Message-Id: <20220616160856.3623273-1-ivecera@redhat.com>
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

Function fallback_set_params() checks if the module type returned
by a driver is ETH_MODULE_SFF_8079 and in this case it assumes
that buffer returns a concatenated content of page  A0h and A2h.
The check is wrong because the correct type is ETH_MODULE_SFF_8472.

Fixes: 96d971e307cc ("ethtool: Add fallback to get_module_eeprom from netlink command")
Cc: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 net/ethtool/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 7e6b37a54add..1c94bb8ea03f 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -36,7 +36,7 @@ static int fallback_set_params(struct eeprom_req_info *request,
 	if (request->page)
 		offset = request->page * ETH_MODULE_EEPROM_PAGE_LEN + offset;
 
-	if (modinfo->type == ETH_MODULE_SFF_8079 &&
+	if (modinfo->type == ETH_MODULE_SFF_8472 &&
 	    request->i2c_address == 0x51)
 		offset += ETH_MODULE_EEPROM_PAGE_LEN * 2;
 
-- 
2.35.1

