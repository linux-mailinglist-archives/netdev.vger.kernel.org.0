Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC8B4C226C
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 04:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiBXDgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 22:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiBXDgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 22:36:06 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0166254564
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 19:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=pADByy9hHSCm6K1PtULkC4wcb5MipbuML4dpuyav+nM=; b=TKPlMNU3PLvsBPnIQZ69Bkt419
        neAuLTNybqugK8Q7ym1gCtfQEf8XVAF5V2Pa28Rj4p2iEctE5woJJ42cmOXSdIxGJcIVKUov4QALO
        XhsX5wCbw7Uv2QuFSd45Df/XstAQdYz1kH6kT2RUl41Yx8sQN6zaSO9bgITrlgFnLXqR9waa1AQ7e
        xpLNnF1ecdveBGecP6UNIF5BheSatOAAK9exKhrk0r7HsnbYp6EyV5ev2iDHFpWKFHUKOePX9mNEx
        yXfuyXCoub6q0k1oKRWKr90zX91FOKt2YpTCqRLtCYO1lniyvxj2AdKIDwLfZR76WY+s3aDcXp0e2
        sNgcXUlQ==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nN4um-00GeG7-Tf; Thu, 24 Feb 2022 03:35:37 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: stmmac: fix return value of __setup handler
Date:   Wed, 23 Feb 2022 19:35:36 -0800
Message-Id: <20220224033536.25056-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__setup() handlers should return 1 on success, i.e., the parameter
has been handled. A return of 0 causes the "option=value" string to be
added to init's environment strings, polluting it.

Fixes: 47dd7a540b8a ("net: add support for STMicroelectronics Ethernet controllers.")
Fixes: f3240e2811f0 ("stmmac: remove warning when compile as built-in (V2)")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20220223.orig/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ linux-next-20220223/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7414,7 +7414,7 @@ static int __init stmmac_cmdline_opt(cha
 	char *opt;
 
 	if (!str || !*str)
-		return -EINVAL;
+		return 1;
 	while ((opt = strsep(&str, ",")) != NULL) {
 		if (!strncmp(opt, "debug:", 6)) {
 			if (kstrtoint(opt + 6, 0, &debug))
@@ -7445,11 +7445,11 @@ static int __init stmmac_cmdline_opt(cha
 				goto err;
 		}
 	}
-	return 0;
+	return 1;
 
 err:
 	pr_err("%s: ERROR broken module parameter conversion", __func__);
-	return -EINVAL;
+	return 1;
 }
 
 __setup("stmmaceth=", stmmac_cmdline_opt);
