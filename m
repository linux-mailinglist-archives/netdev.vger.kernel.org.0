Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40231550925
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 09:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbiFSHd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 03:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbiFSHd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 03:33:57 -0400
X-Greylist: delayed 1819 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 19 Jun 2022 00:33:50 PDT
Received: from mail-m965.mail.126.com (mail-m965.mail.126.com [123.126.96.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BF316590;
        Sun, 19 Jun 2022 00:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=dTAU6
        mTEjt6l5zqq/41qP0DP8KBBlAM0uLigIY0i9p8=; b=WS25MfutzsoGDDh6btDjK
        4xy49amCnVYNJn9dn/MXLglf3XrexwyTkWClVAuNADw8jV6E2ks9i7A83xw/pFge
        B7GuzUs7jwndJcquv7GZUd6z3VyTLFhIjs8DLWSNSI9oaVY1QQc+NRJklY9Gd+B3
        y7jMOzL6sDeIVGNGV2RCqI=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp10 (Coremail) with SMTP id NuRpCgB3ym4iyq5i43vMEw--.47634S2;
        Sun, 19 Jun 2022 15:02:58 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     windhl@126.com, linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] can: Remove extra of_node_get in grcan
Date:   Sun, 19 Jun 2022 15:02:57 +0800
Message-Id: <20220619070257.4067022-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: NuRpCgB3ym4iyq5i43vMEw--.47634S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKFW7tw47CrWfGw1rGry7Awb_yoWfXFX_G3
        s7ZF4xXr15Wr4Dt3WI93yavrW2yrW5Zrykurs0yFW3Aa13Zr1UJrs2vF93twn5W3ykZF9I
        krnIya48C3yYqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRiUGYtUUUUU==
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/xtbBGgolF1-HZVIHkQAAsb
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In grcan_probe(), of_find_node_by_path() has increased the refcount.
There is no need to call of_node_get() again.

Fixes: 1e93ed26acf0 (can: grcan: grcan_probe(): fix broken system id check for errata workaround needs)

Signed-off-by: Liang He <windhl@126.com>
---
 drivers/net/can/grcan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 76df4807d366..4c47c1055eff 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1646,7 +1646,6 @@ static int grcan_probe(struct platform_device *ofdev)
 	 */
 	sysid_parent = of_find_node_by_path("/ambapp0");
 	if (sysid_parent) {
-		of_node_get(sysid_parent);
 		err = of_property_read_u32(sysid_parent, "systemid", &sysid);
 		if (!err && ((sysid & GRLIB_VERSION_MASK) >=
 			     GRCAN_TXBUG_SAFE_GRLIB_VERSION))
-- 
2.25.1

