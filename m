Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D595858A879
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 11:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235790AbiHEJHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 05:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiHEJHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 05:07:08 -0400
X-Greylist: delayed 638 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 05 Aug 2022 02:07:06 PDT
Received: from forward105j.mail.yandex.net (forward105j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFFE1F2E1
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 02:07:06 -0700 (PDT)
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward105j.mail.yandex.net (Yandex) with ESMTP id 28F5F4ECB2CA;
        Fri,  5 Aug 2022 11:48:46 +0300 (MSK)
Received: from vla5-47b3f4751bc4.qloud-c.yandex.net (vla5-47b3f4751bc4.qloud-c.yandex.net [IPv6:2a02:6b8:c18:3508:0:640:47b3:f475])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id 244CB56A000F;
        Fri,  5 Aug 2022 11:48:46 +0300 (MSK)
Received: by vla5-47b3f4751bc4.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id xFBAKgq0sD-mhoWlJ8g;
        Fri, 05 Aug 2022 11:48:45 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maquefel.me; s=mail; t=1659689325;
        bh=WY/p0AKPurtQC7CbtbT4lh+mfKMDaL2pNRP+3Km3zMw=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=M6Wi8T/q+hoGx9dgUAqM+SWXRjHreA5+4/xctMXwI50sdDkbOhIa1lpKCFTHvfkHk
         wpzCdXZytpZhjjqwUaowRjAbribwdXKZzgWE4v+sJNZNDr1NPFdY7kLskpJJv4X+f1
         4VnnWZRwf618e2mUzK2R1P6LWUqOqSVYiG8GwZdE=
Authentication-Results: vla5-47b3f4751bc4.qloud-c.yandex.net; dkim=pass header.i=@maquefel.me
From:   Nikita Shubin <nikita.shubin@maquefel.me>
Cc:     linux@yadro.com, Nikita Shubin <n.shubin@yadro.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: dp83867: fix get nvmem cell fail
Date:   Fri,  5 Aug 2022 11:48:43 +0300
Message-Id: <20220805084843.24542-1-nikita.shubin@maquefel.me>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Shubin <n.shubin@yadro.com>

If CONFIG_NVMEM is not set of_nvmem_cell_get, of_nvmem_device_get
functions will return ERR_PTR(-EOPNOTSUPP) and "failed to get nvmem
cell io_impedance_ctrl" error would be reported despite "io_impedance_ctrl"
is completely missing in Device Tree and we should use default values.

Check -EOPNOTSUPP togather with -ENOENT to avoid this situation.

Fixes: 5c2d0a6a0701 ("net: phy: dp83867: implement support for io_impedance_ctrl nvmem cell")
Signed-off-by: Nikita Shubin <n.shubin@yadro.com>
---
 drivers/net/phy/dp83867.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 1e38039c5c56..6939563d3b7c 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -535,7 +535,7 @@ static int dp83867_of_init_io_impedance(struct phy_device *phydev)
 	cell = of_nvmem_cell_get(of_node, "io_impedance_ctrl");
 	if (IS_ERR(cell)) {
 		ret = PTR_ERR(cell);
-		if (ret != -ENOENT)
+		if (ret != -ENOENT && ret != -EOPNOTSUPP)
 			return phydev_err_probe(phydev, ret,
 						"failed to get nvmem cell io_impedance_ctrl\n");
 
-- 
2.35.1

