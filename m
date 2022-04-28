Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1AFB513D6F
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 23:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352236AbiD1V1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352182AbiD1V1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:27:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF7ABF533
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 14:23:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 946C0B8303E
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 21:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70C6C385AD;
        Thu, 28 Apr 2022 21:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651181021;
        bh=aWusfsVygd8PAIfwUe+vR4X18nkIBQqpy5W1lvkfkOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ufd7Qz5uwpPyIk5phjQZIDeWEU2PbT9ArBu9t/tG2nKIuM6T7ZOvVF8ShBPk4zrN1
         0YN4KkSx9pMAhdabcpLHI3XxJ0dOMEAotGb0vGpxlOuApxY6uI3nVnLORdfiXNRMdk
         k+kkkQqfNc8pgcxaKc5xC82ijRYFOP2roaGZVXyX5B2ko92Z6dmsYtrUbuhQFYAB93
         QO9lWwWNCuACaAoHYvma9FmQLPdsqq+9TrZwXlRM1cTEl3QJ+4tR8EaQ0dt5yFyLmH
         eGD86pryWkJt+tS4U77SV/sRoMk5itgmF1zvY3aOwCvTA5/9V3DD4QvLRZi0BiJlAG
         iSbgdAr1ChUjg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, LinoSanfilippo@gmx.de
Subject: [PATCH net-next v2 07/15] slic: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Thu, 28 Apr 2022 14:23:15 -0700
Message-Id: <20220428212323.104417-8-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220428212323.104417-1-kuba@kernel.org>
References: <20220428212323.104417-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Defining local versions of NAPI_POLL_WEIGHT with the same
values in the drivers just makes refactoring harder.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: LinoSanfilippo@gmx.de
---
 drivers/net/ethernet/alacritech/slic.h    | 2 --
 drivers/net/ethernet/alacritech/slicoss.c | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/alacritech/slic.h b/drivers/net/ethernet/alacritech/slic.h
index 3add305d34b4..4eecbdfff3ff 100644
--- a/drivers/net/ethernet/alacritech/slic.h
+++ b/drivers/net/ethernet/alacritech/slic.h
@@ -265,8 +265,6 @@
 #define SLIC_NUM_STAT_DESC_ARRAYS	4
 #define SLIC_INVALID_STAT_DESC_IDX	0xffffffff
 
-#define SLIC_NAPI_WEIGHT		64
-
 #define SLIC_UPR_LSTAT			0
 #define SLIC_UPR_CONFIG			1
 
diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethernet/alacritech/slicoss.c
index 1fc9a1cd3ef8..ce353b0c02a3 100644
--- a/drivers/net/ethernet/alacritech/slicoss.c
+++ b/drivers/net/ethernet/alacritech/slicoss.c
@@ -1803,7 +1803,7 @@ static int slic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto unmap;
 	}
 
-	netif_napi_add(dev, &sdev->napi, slic_poll, SLIC_NAPI_WEIGHT);
+	netif_napi_add(dev, &sdev->napi, slic_poll, NAPI_POLL_WEIGHT);
 	netif_carrier_off(dev);
 
 	err = register_netdev(dev);
-- 
2.34.1

