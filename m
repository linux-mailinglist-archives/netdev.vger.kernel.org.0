Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05BB5BFF3C
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbiIUNvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiIUNvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:51:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6408E857E7
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:51:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 801B6623C8
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CDDC433C1;
        Wed, 21 Sep 2022 13:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663768290;
        bh=yZaCi2uCeKlo3Wr/pz723Ji4IQd7GRSH96mm4e0BdAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZ+eFQvm5XZ9rrlBWPeOmH9hrF+8Eg+dMlk2JtVhwxMWzfjAizDyC9A4wKBXKnzt1
         MsxhpXqyxRnnCu1hm2t1561aopQF0VFsm56aUmsgaoyoLxGLY6RMls2EdzY+lI/SFu
         kr/0tAv9Vf3mTPfLJyWxuamYEct22j49XnRpPDvEyzXzJlcAYzBkPwRX6vE6iWjayn
         On2v6dDYQwPc6Dy1W4DdqfVaCDo5mzE2DY3VjIThKPb9qYDyKN6/Let62WAVdBKW7X
         OBGGGsR7RvLz0Ndh6WhIbdRgc1dZDsJTTWfMrwsRazluXIbEAT/KfGHHtEIR9cEw0S
         zsLkupzj6yHIA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Antoine Tenart <atenart@kernel.org>, sundeep.lkml@gmail.com,
        saeedm@nvidia.com, liorna@nvidia.com, dbogdanov@marvell.com,
        mstarovoitov@marvell.com, irusskikh@marvell.com,
        sd@queasysnail.net, netdev@vger.kernel.org
Subject: [PATCH net-next 3/7] net: macsec: remove the prepare phase when offloading
Date:   Wed, 21 Sep 2022 15:51:14 +0200
Message-Id: <20220921135118.968595-4-atenart@kernel.org>
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

The hardware offloading in MACsec was initially supported using 2 phases.
This was proposed in the RFC as this could have allowed easier fallback
to the software implementation if the hardware did not support a feature
or had enough entries already. But this fallback wasn't implemented and
might not be a good idea after all. In addition it turned out this logic
didn't mapped well the hardware logic and device drivers were mostly
ignoring the preparation phase.

Let's remove this as it does not offer any advantage and is ignored by
drivers.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/macsec.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 830fed3914b6..0e7cf6a68a50 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1663,22 +1663,9 @@ static int macsec_offload(int (* const func)(struct macsec_context *),
 	if (ctx->offload == MACSEC_OFFLOAD_PHY)
 		mutex_lock(&ctx->phydev->lock);
 
-	/* Phase I: prepare. The drive should fail here if there are going to be
-	 * issues in the commit phase.
-	 */
-	ctx->prepare = true;
-	ret = (*func)(ctx);
-	if (ret)
-		goto phy_unlock;
-
-	/* Phase II: commit. This step cannot fail. */
 	ctx->prepare = false;
 	ret = (*func)(ctx);
-	/* This should never happen: commit is not allowed to fail */
-	if (unlikely(ret))
-		WARN(1, "MACsec offloading commit failed (%d)\n", ret);
 
-phy_unlock:
 	if (ctx->offload == MACSEC_OFFLOAD_PHY)
 		mutex_unlock(&ctx->phydev->lock);
 
-- 
2.37.3

