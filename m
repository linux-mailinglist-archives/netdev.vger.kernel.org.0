Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3306C64EB93
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 13:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiLPMrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 07:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLPMri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 07:47:38 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E75CF5
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 04:47:37 -0800 (PST)
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id C997F8524E;
        Fri, 16 Dec 2022 13:47:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1671194855;
        bh=fEIEJmdqmkeSkg+RQHUIRuf+WGzlxZ/wuMipOCxnQ54=;
        h=From:To:Cc:Subject:Date:From;
        b=v4PmfzUxOPbcOS9d7HuzcZnayDMZHlVVjFVW8qrwTYmtpfloVeUpj8hbj5XV+1Rwp
         vnf0cGEgPf8MREfltX+hAb5i/vfsxsqveBHgymnwdAYdeiHTsfANEVGkkaUtP16eUk
         oh2xkz9fydZ987cBXeZrMQg08QoxfoVXnZJVI0YNvJixxGzWmH8b5hzFPJ9ExuIYyc
         Q6AsI5fATuY3deY6ti5CXX2ovczIssI2NYGumLFHTHmXpkCDGXdcuOAfjlAKwsNrXd
         J+yBjoPqgDGTPB7qiW2FJDoh9mBY5QsEtv0TS1rB1vNSltWmbsnYRsVKGk371PJEKI
         6ajes8/a2wP4w==
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Geoff Levand <geoff@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@nvidia.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH] net: ks8851: Drop IRQ threading
Date:   Fri, 16 Dec 2022 13:47:31 +0100
Message-Id: <20221216124731.122459-1-marex@denx.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Request non-threaded IRQ in the KSZ8851 driver, this fixes the following warning:
"
NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!
"

Signed-off-by: Marek Vasut <marex@denx.de>
---
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Petr Machata <petrm@nvidia.com>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: netdev@vger.kernel.org
---
 drivers/net/ethernet/micrel/ks8851_common.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index cfbc900d4aeb9..1eba4ba0b95cf 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -443,9 +443,7 @@ static int ks8851_net_open(struct net_device *dev)
 	unsigned long flags;
 	int ret;
 
-	ret = request_threaded_irq(dev->irq, NULL, ks8851_irq,
-				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				   dev->name, ks);
+	ret = request_irq(dev->irq, ks8851_irq, IRQF_TRIGGER_LOW, dev->name, ks);
 	if (ret < 0) {
 		netdev_err(dev, "failed to get irq\n");
 		return ret;
-- 
2.35.1

