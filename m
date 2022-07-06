Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7637C568D89
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbiGFPhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 11:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbiGFPgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:36:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7052A71B;
        Wed,  6 Jul 2022 08:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C2935CE2071;
        Wed,  6 Jul 2022 15:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5ACC3411C;
        Wed,  6 Jul 2022 15:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121615;
        bh=mYgorTCKW9dcyIfBO3uoP1zk+o/ZbssEvug0p5OqzbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/PJq5YAZpDgnCey5CraDZ+oc08HiOqjShHm7ZYaZswoM2nxQkPbmt4q44LFvCy5z
         dsBZ5tHgTQtqbXm+3DyPtrmyU0ywVUPcRHO6dqv3BmQPo+99wBu5wLhnAMNVu2YHEq
         lmZoFBN7WRLpZkVc3icMdQQIlKJOPduRYk14z1TvFtqNQueCXCkPRDjMYyACezPq0P
         s6FZN1QnBl+XCBhGhp/auRt9QU2cPhOG05cyXsrgekRLhrlfLB51kzDvY0eV+anLpB
         vkEnz9aKErJvO94bsPQLEPqCoXePvMY4BUxTXNn3QshE+5n2J5m3T1qOgeRwdY1ZrL
         SSHHzCptIxsBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 9/9] net: sfp: fix memory leak in sfp_probe()
Date:   Wed,  6 Jul 2022 11:33:15 -0400
Message-Id: <20220706153316.1598554-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153316.1598554-1-sashal@kernel.org>
References: <20220706153316.1598554-1-sashal@kernel.org>
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
index 5657c604602e..beaa00342a13 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1878,7 +1878,7 @@ static int sfp_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, sfp);
 
-	err = devm_add_action(sfp->dev, sfp_cleanup, sfp);
+	err = devm_add_action_or_reset(sfp->dev, sfp_cleanup, sfp);
 	if (err < 0)
 		return err;
 
-- 
2.35.1

