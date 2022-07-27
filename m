Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEB958216E
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 09:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiG0HpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 03:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiG0HpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 03:45:12 -0400
Received: from mail-m965.mail.126.com (mail-m965.mail.126.com [123.126.96.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4272E399
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 00:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=igBup
        S0welsQgLlRUF4lev/by1tQN8ez4Mmtv12KutU=; b=lD3pVxtlK0ONnigDr87TE
        l785xO/5OClYMNKM5+CPjvj8CjcTpIyTkoBKgtCi1B/jOXu0B/qq2AS+G4py5YVt
        WfGRZA2T0HgV2SIDNp2eKC2d9+xfnztJIaDht9gFwWmVM6GdWmbKfEfCrBrSXUk7
        SV83+ALA8qYkilvRt1unuw=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp10 (Coremail) with SMTP id NuRpCgD3Fa7K7OBiFYySHA--.1124S2;
        Wed, 27 Jul 2022 15:44:11 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, windhl@126.com,
        linmq006@gmail.com
Subject: [PATCH] of: mdio: Add of_node_put() when breaking out of for_each_xx
Date:   Wed, 27 Jul 2022 15:44:09 +0800
Message-Id: <20220727074409.1323592-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: NuRpCgD3Fa7K7OBiFYySHA--.1124S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZr4xXr17WFW3CF1DAF48tFb_yoW3Wwb_Ka
        s5XFZrWF4kGF43KrsxCrWfZ3sYya1kWr4rZFySgrZ3Kw40qr12gr1UZF13XrykGFWxAF9r
        Gr1qyr4Iy34SkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRtAwIJUUUUU==
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbizgtLF18RPkEIFAAAs0
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In of_mdiobus_register(), we should call of_node_put() for 'child'
escaped out of for_each_available_child_of_node().

Fixes: 66bdede495c7 ("of_mdio: Fix broken PHY IRQ in case of probe deferral")
Co-authored-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Liang He <windhl@126.com>
---
 drivers/net/mdio/of_mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 9e3c815a070f..796e9c7857d0 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -231,6 +231,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	return 0;
 
 unregister:
+	of_node_put(child);
 	mdiobus_unregister(mdio);
 	return rc;
 }
-- 
2.25.1

