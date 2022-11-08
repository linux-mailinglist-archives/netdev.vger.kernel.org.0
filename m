Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C24662186B
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbiKHPfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbiKHPfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:35:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F152D5C740
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 07:35:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 806F061647
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 15:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D11C433C1;
        Tue,  8 Nov 2022 15:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667921705;
        bh=/6Nj1GfsnWm4Xo+zTncRhbLnC+3kDtzLx+mzlFmO4QM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MlM5iCWpgoY5OGM4hCzC2SVk9ndDR/4Y4mVvPwa31t9WK3dfXV3ZvcUR/8ev+nVFb
         D5DKMXU9oYCFzB1o+lu1LJRfCNU1QqpEyDIImEjSOpWj4Di3OxJUSjDO4P6ApgxjZJ
         XGhjfWwIo7HjOXqRFREDJfFBKWxT965gesSl42eZCSqMbgVEihC6RJcNom1fEFZoT1
         tHS+HWay8vVoRaTAa8ZtaJWGsQ3Cqj+4J+ud6631yLordXnzGTI9JlnjGaEGlc//5A
         C9AO4+vhdYRVH/CTrbI99oWjEb423Oslgrff9UbMFl34XTjlt/0co0SrFHbUGJ19vD
         u2ptyG8UsrnPA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Antoine Tenart <atenart@kernel.org>, sd@queasysnail.net,
        irusskikh@marvell.com, netdev@vger.kernel.org
Subject: [PATCH net 1/2] net: phy: mscc: macsec: clear encryption keys when freeing a flow
Date:   Tue,  8 Nov 2022 16:34:58 +0100
Message-Id: <20221108153459.811293-2-atenart@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108153459.811293-1-atenart@kernel.org>
References: <20221108153459.811293-1-atenart@kernel.org>
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

Commit aaab73f8fba4 ("macsec: clear encryption keys from the stack after
setting up offload") made sure to clean encryption keys from the stack
after setting up offloading, but the MSCC PHY driver made a copy, kept
it in the flow data and did not clear it when freeing a flow. Fix this.

Fixes: 28c5107aa904 ("net: phy: mscc: macsec support")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/phy/mscc/mscc_macsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index ee5b17edca39..f81b077618f4 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -632,6 +632,7 @@ static void vsc8584_macsec_free_flow(struct vsc8531_private *priv,
 
 	list_del(&flow->list);
 	clear_bit(flow->index, bitmap);
+	memzero_explicit(flow->key, sizeof(flow->key));
 	kfree(flow);
 }
 
-- 
2.38.1

