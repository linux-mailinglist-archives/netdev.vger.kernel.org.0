Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01395512095
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238989AbiD0PJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239180AbiD0PJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:09:01 -0400
Received: from mail.tkos.co.il (guitar.tkos.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA122326C2
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 08:05:49 -0700 (PDT)
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.tkos.co.il (Postfix) with ESMTPS id B697A44046E;
        Wed, 27 Apr 2022 18:05:00 +0300 (IDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1651071900;
        bh=tm7liJX8ov/WR2ZC4bn2cXltgUi43lPOmeatkQujUes=;
        h=From:To:Cc:Subject:Date:From;
        b=lSJtRsQ/tsGlyJuzSb59rTm8ukUwAg1yHh2g9ecUPyvCNNkWumVQ7eJgRFTJsvtKv
         sa1xtqCpZCDJF3Net5NzIgiS84p7CCIdag4HCXYZ1NPWpWj6ZScN3ayZuIC499UMVp
         xoTgGYnFeKOHJieBB8iEudtMxYkw+edYMn++X/pT59/bGPikzzW4T9PlJozYLEnzhI
         fRI7lVJU80BLIysWmlho2mUCSJM3Br9s1fzBMII+fHtRngp04xG92ZosV+Bc83Tpu/
         leUKEUQBrML4RtxmTZVt9UCXbJ+P9lzS+iGYM9Qf3D85LEUcqAcmYxm9Qi1xinJ1Mh
         U0vnPGF1VEsSA==
From:   Baruch Siach <baruch@tkos.co.il>
To:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Baruch Siach <baruch.siach@siklu.com>
Subject: [PATCH] net: mvpp2: add delay at the end of .mac_prepare
Date:   Wed, 27 Apr 2022 18:05:36 +0300
Message-Id: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch.siach@siklu.com>

Without this delay PHY mode switch from XLG to SGMII fails in a weird
way. Rx side works. However, Tx appears to work as far as the MAC is
concerned, but packets don't show up on the wire.

Tested with Marvell 10G 88X3310 PHY.

Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
---

Not sure this is the right fix. Let me know if you have any better
suggestion for me to test.

The same issue and fix reproduce with both v5.18-rc4 and v5.10.110.
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 1a835b48791b..8823efe396b1 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6432,6 +6432,8 @@ static int mvpp2_mac_prepare(struct phylink_config *config, unsigned int mode,
 		}
 	}
 
+	mdelay(10);
+
 	return 0;
 }
 
-- 
2.35.1

