Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2DE5BFF41
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiIUNwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbiIUNvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:51:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCBA80F4B
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AD206306F
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5537BC433C1;
        Wed, 21 Sep 2022 13:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663768302;
        bh=9q6XwCEeFuKP9VNaKzdSsGsPxtkW0iuNe05U5nJfic8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QuRQv0U7DDbjgj/FybZGMccVTcIf7XuK7KnKmgBhM+baC7yz5iTauXhIAVNAoxl+O
         r3vaYW4eVamoVthoTqSpmvDJCEDumeywGUL6KEqZO64D0urIcXLqfNPa5RL9eutwYL
         cNc7p22g0eQ6zQ68RKBpfOdjeUElYrxvHAwHyxOwTDOS4pJkMKZisBu5E6Dxbs4SDU
         5eBrmM3P3Q3sWdCqRMIGYJrLe9ZYxJtOKiUdOQaPJZAou6WpPA4rn4aXriNKU35QrH
         IveF5dlQC4KWYNP8wsluu2RzTAFY9KjM7Q89WrynYx4lOYHY/dpMGy1jYAW2r2gKL5
         N1+ud1nherblw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Antoine Tenart <atenart@kernel.org>, sundeep.lkml@gmail.com,
        saeedm@nvidia.com, liorna@nvidia.com, dbogdanov@marvell.com,
        mstarovoitov@marvell.com, irusskikh@marvell.com,
        sd@queasysnail.net, netdev@vger.kernel.org
Subject: [PATCH net-next 7/7] net: macsec: remove the prepare flag from the MACsec offloading context
Date:   Wed, 21 Sep 2022 15:51:18 +0200
Message-Id: <20220921135118.968595-8-atenart@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921135118.968595-1-atenart@kernel.org>
References: <20220921135118.968595-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the MACsec offloading preparation phase was removed from the
MACsec core implementation as well as from drivers implementing it, we
can safely remove the flag representing it.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/macsec.c | 1 -
 include/net/macsec.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 0e7cf6a68a50..498e4ddef49d 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1663,7 +1663,6 @@ static int macsec_offload(int (* const func)(struct macsec_context *),
 	if (ctx->offload == MACSEC_OFFLOAD_PHY)
 		mutex_lock(&ctx->phydev->lock);
 
-	ctx->prepare = false;
 	ret = (*func)(ctx);
 
 	if (ctx->offload == MACSEC_OFFLOAD_PHY)
diff --git a/include/net/macsec.h b/include/net/macsec.h
index 871599b11707..5b9c61c4d3a6 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -271,8 +271,6 @@ struct macsec_context {
 		struct macsec_rx_sa_stats *rx_sa_stats;
 		struct macsec_dev_stats  *dev_stats;
 	} stats;
-
-	u8 prepare:1;
 };
 
 /**
-- 
2.37.3

