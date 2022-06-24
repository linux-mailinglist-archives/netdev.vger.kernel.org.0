Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A6655909F
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 07:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbiFXExV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 00:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbiFXExE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 00:53:04 -0400
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6B3474E65;
        Thu, 23 Jun 2022 21:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Tb64P
        u0w0mNUC4InDOg/CyJ1ovpbrmbwN790T5bKgDo=; b=Zqz3OQyXpldZtEwasKiQU
        a8HLtGK5Jc5m+ggrT9rZZcdm0rzfIZDlie6eXqAAmc/dHtwcJoVdv3HMp5zaRhBa
        TwK+qAw46MSMLQ2pGBF6F75h4DoNe50/+f2DsAXIotClOzoCpc4bBnDWrphW6CMy
        M2nVCj9ddyaMDrsZQu3hzs=
Received: from localhost.localdomain (unknown [123.112.69.106])
        by smtp1 (Coremail) with SMTP id GdxpCgAnludnQrVi8XdDKw--.42139S4;
        Fri, 24 Jun 2022 12:49:51 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH v2] net: sfp: fix memory leak in sfp_probe()
Date:   Fri, 24 Jun 2022 12:49:41 +0800
Message-Id: <20220624044941.1807118-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgAnludnQrVi8XdDKw--.42139S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrKr1fJr1UXFyftw4fJrW7XFb_yoW3urb_CF
        47XF4fGryUCr4qqw15K34SvrWS9Fy8ZFs5CF1fK3yagFy3Gws8u3yvvF47Jr1UWrW2vr4U
        uF9rZFsa9r1fKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREF4i5UUUUU==
X-Originating-IP: [123.112.69.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/xtbBOQ8qjF-POHMHlgAAsa
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sfp_probe() allocates a memory chunk from sfp with sfp_alloc(). When
devm_add_action() fails, sfp is not freed, which leads to a memory leak.

We should use devm_add_action_or_reset() instead of devm_add_action().

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
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
2.25.1

