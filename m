Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8926D9EBD
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 19:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240019AbjDFRaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 13:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239814AbjDFRaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 13:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE35A9
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 10:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE458649BC
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 17:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763E8C433EF;
        Thu,  6 Apr 2023 17:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680802221;
        bh=uTezeCfzpYKuhuhU2D8QgaY4IY+HPF1/VqkokcAEH/s=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=asWJygQgC55dAkjx6udpdZntn9zuHt+kcQ0wgfPkXijrhvumhv4d/EdkWjZEHE7N+
         yQ9SaMwOJrnlBbTp5gMzf0WuZR6An4wuvhlKq2VTDDN7QWKJ+PFershPATGcWAZqHO
         5W9BmCuXhTOb73ykf4CFUIIX0dMjlDlXoa9Y7finaHR447+dLH1oGzE4KthCFZNQB4
         OWacI/iuswF2dqqdr+nS1SlS0t6eDREd4RYsfrZ9UgjrnpVaGChDZqcNkroTRPYeUe
         P7+WiNdpj3HseW4keCiCN2oq67bx0VL2IAwOaid3tZFAg5Q0KAeMJRz0UhxcaRM9M1
         A6OsHLO0kcUkA==
From:   Simon Horman <horms@kernel.org>
Date:   Thu, 06 Apr 2023 19:30:10 +0200
Subject: [PATCH net-next 2/2] net: stmmac: dwmac-anarion: Always return
 struct anarion_gmac * from anarion_config_dt()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230406-dwmac-anarion-sparse-v1-2-b0c866c8be9d@kernel.org>
References: <20230406-dwmac-anarion-sparse-v1-0-b0c866c8be9d@kernel.org>
In-Reply-To: <20230406-dwmac-anarion-sparse-v1-0-b0c866c8be9d@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Always return struct anarion_gmac * from anarion_config_dt().
In the case where ctl_block was an error pointer it was being
returned directly. Which sparse flags as follows:

 .../dwmac-anarion.c:73:24: warning: incorrect type in return expression (different address spaces)
 .../dwmac-anarion.c:73:24:    expected struct anarion_gmac *
 .../dwmac-anarion.c:73:24:    got void [noderef] __iomem *[assigned] ctl_block

Avoid this by converting the error pointer to an error.
And then reversing the conversion.

As a side effect, the error can be used for logging purposes,
subjectively, leading to a minor cleanup.

No functional change intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
index 2357e77434fb..9354bf419112 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
@@ -68,9 +68,9 @@ static struct anarion_gmac *anarion_config_dt(struct platform_device *pdev)
 
 	ctl_block = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(ctl_block)) {
-		dev_err(&pdev->dev, "Cannot get reset region (%ld)!\n",
-			PTR_ERR(ctl_block));
-		return ctl_block;
+		err = PTR_ERR(ctl_block);
+		dev_err(&pdev->dev, "Cannot get reset region (%d)!\n", err);
+		return ERR_PTR(err);
 	}
 
 	gmac = devm_kzalloc(&pdev->dev, sizeof(*gmac), GFP_KERNEL);

-- 
2.30.2

