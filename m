Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E474D4CB49B
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 02:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbiCCBqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 20:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiCCBqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 20:46:53 -0500
X-Greylist: delayed 914 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 02 Mar 2022 17:46:07 PST
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 67AC21B6E18;
        Wed,  2 Mar 2022 17:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=XAi7D
        k9Yg7EF/mSMo8raLyxYjVznmUNk90i0YbDYo5A=; b=ZEmq/qzrJtrY9zC207PgZ
        REzIQycl5G5Qj/X4NlmoD0WDcQJJIo/2XwUaDq+pebvUyOZ0q/RK6IWhS58FaZaj
        NLHKooZXW2WFd1/q87NjPrpNq51uyfD7UAx3EZeW/lM1eAo2Q/pFkztOqoXHwAnJ
        FqL/lfJ8JYmk+SV6qQxKps=
Received: from localhost.localdomain (unknown [218.106.182.227])
        by smtp4 (Coremail) with SMTP id HNxpCgBnPKQzGiBi+_cuEw--.7369S4;
        Thu, 03 Mar 2022 09:30:37 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     davem@davemloft.net, kuba@kernel.org, caihuoqing@baidu.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] net: arc_emac: Fix use after free in arc_mdio_probe()
Date:   Thu,  3 Mar 2022 09:30:22 +0800
Message-Id: <20220303013022.459154-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgBnPKQzGiBi+_cuEw--.7369S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gw45KFyDGF47urW7GrW3Wrg_yoWDZFgE9w
        18Za43Jw43tr90gw4j9F4ayryvk3yUXrs3uF4fKr9xAr9rCr47X3WkuF93Jr1kuws2qF9I
        qayayrW7u348KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREzuWtUUUUU==
X-Originating-IP: [218.106.182.227]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiQx24jFc7XpwVewAAsq
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If bus->state is equal to MDIOBUS_ALLOCATED, mdiobus_free(bus) will free
the "bus". But bus->name is still used in the next line, which will lead
to a use after free.

We can fix it by assigning dev_err_probe() to dev_err before the bus is
freed to avoid the uaf.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/ethernet/arc/emac_mdio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/arc/emac_mdio.c b/drivers/net/ethernet/arc/emac_mdio.c
index 9acf589b1178..795a25c5848a 100644
--- a/drivers/net/ethernet/arc/emac_mdio.c
+++ b/drivers/net/ethernet/arc/emac_mdio.c
@@ -165,9 +165,10 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
 
 	error = of_mdiobus_register(bus, priv->dev->of_node);
 	if (error) {
-		mdiobus_free(bus);
-		return dev_err_probe(priv->dev, error,
+		int dev_err = dev_err_probe(priv->dev, error,
 				     "cannot register MDIO bus %s\n", bus->name);
+		mdiobus_free(bus);
+		return dev_err;
 	}
 
 	return 0;
-- 
2.25.1

