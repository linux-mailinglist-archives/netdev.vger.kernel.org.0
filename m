Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5CC557396
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiFWHKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiFWHKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:10:31 -0400
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7AADF45534;
        Thu, 23 Jun 2022 00:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=+Yi5W
        E6QmU8Q2WHGxfAqHLKBZQtcrArdRuT7E7T90aQ=; b=go/u1KEngFhEzPyU6THYD
        STPBJhaaqAdtJDEhE2z+nJyYlaesrI889/09ixersTKuSJe2/6o0dDwY0BndtTOo
        LxLsrdeyFj2JWCz4vH+nzfko302fbIUr5aDW7TSnLl3UxShREJYQXweQTl1FfWul
        9c9HvAng2bw7x8dSmmjTps=
Received: from localhost.localdomain (unknown [123.112.69.106])
        by smtp1 (Coremail) with SMTP id GdxpCgAHRb2dEbRi2eS2Kg--.6843S4;
        Thu, 23 Jun 2022 15:09:26 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] net: sfp: fix memory leak in sfp_probe()
Date:   Thu, 23 Jun 2022 15:09:14 +0800
Message-Id: <20220623070914.1781700-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgAHRb2dEbRi2eS2Kg--.6843S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrKr1kZrWfAF17WFy7CF13CFg_yoW3urc_WF
        W2vF43JrWjkrs0qw15Kw1SvrWF9Fy8XFs5ZF4fK3yftry3GanxW3ykXF47Jr9rWrW2vr4D
        u3sruFsI9w4fGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREsqXtUUUUU==
X-Originating-IP: [123.112.69.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiQwYpjFc7aNoYJgAAsA
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sfp_probe() allocates a memory chunk from sfp with sfp_alloc(), when
devm_add_action() fails, sfp is not freed, which leads to a memory leak.

We should free the sfp with sfp_cleanup() when devm_add_action() fails.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/phy/sfp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 9a5d5a10560f..366a89adabf5 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2517,8 +2517,10 @@ static int sfp_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, sfp);
 
 	err = devm_add_action(sfp->dev, sfp_cleanup, sfp);
-	if (err < 0)
+	if (err < 0) {
+		sfp_cleanup(sfp);
 		return err;
+	}
 
 	sff = sfp->type = &sfp_data;
 
-- 
2.25.1

