Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648F1568D17
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiGFPcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 11:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233957AbiGFPcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:32:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32274286CE;
        Wed,  6 Jul 2022 08:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69C77B81D98;
        Wed,  6 Jul 2022 15:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFCCC341CA;
        Wed,  6 Jul 2022 15:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121512;
        bh=5TmI5gMFDp/IwdORJQ6PYCQAsR0ZEQfsy0HobI+u69Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/ck5e4bht71xF5qQmCWefdNeNvTTqk52EB4gP2k3XtLm+gWM97ZXU1l9nCxt2Dr6
         UjjnU/Z1gfJV+TRhvpC0IkOy8NG4zXVUA0jkvo2CMBA1sZptc9/Hr+GkNrMPU5KyIZ
         TxY7oelzTAdh9jYwPeNwncK/wRlNDcJe4rt7lIxVpWtUKXSN6WIaR2t/7uIhSXgovK
         o+vZaFy03HMp34vmsfgbZDtTZVS6/0ARRJR9j4EbKqguxT/MWjFIuVNZdkN8iFD65J
         Oh2+EI78f8IYPs59swqiRCzZcCBb14z019AWJ49h+vRUIt6p2j+0yxLy1ecG0JdI7S
         gcB2kee3XU9xg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 22/22] net: sfp: fix memory leak in sfp_probe()
Date:   Wed,  6 Jul 2022 11:30:40 -0400
Message-Id: <20220706153041.1597639-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153041.1597639-1-sashal@kernel.org>
References: <20220706153041.1597639-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit 0a18d802d65cf662644fd1d369c86d84a5630652 ]

sfp_probe() allocates a memory chunk from sfp with sfp_alloc(). When
devm_add_action() fails, sfp is not freed, which leads to a memory leak.

We should use devm_add_action_or_reset() instead of devm_add_action().

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20220629075550.2152003-1-niejianglei2021@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 9a5d5a10560f..e7b0e12cc75b 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2516,7 +2516,7 @@ static int sfp_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, sfp);
 
-	err = devm_add_action(sfp->dev, sfp_cleanup, sfp);
+	err = devm_add_action_or_reset(sfp->dev, sfp_cleanup, sfp);
 	if (err < 0)
 		return err;
 
-- 
2.35.1

