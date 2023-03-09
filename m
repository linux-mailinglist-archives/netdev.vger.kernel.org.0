Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41AD86B249D
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjCIMzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbjCIMzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:55:11 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1433D87DB2;
        Thu,  9 Mar 2023 04:55:10 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 1B73885EA8;
        Thu,  9 Mar 2023 13:55:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678366506;
        bh=dVEgBnkSNnuvOZZ/mAHRR8gLntu/ElXZ1r9lih2XJe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bg9mVsKNm4tgsSSTEAdQSzKdlrRTlZiAduKpOP0gHP21Jqa8/Lf2P+8BvQDa16cXw
         ISyqQstr4tpj7edzzN6FBhEvNn0SflMo9RU9AOgFfFAMx0ORkfUovWDeQRPb9m6bLN
         qzI0OAGD7mDHcBDyH2B2L08KEMRCOu0UNDE4bZ85Z87KY+gI777TtHSSH9oJyUgYWR
         o+6k6mSN02oge4gDRSh/YYBX2v/10yExefpVG5tMj3Vv0GAL8uw0Rlr78hY8S1e6d6
         XM/Nk+QVIT1HAPQqviVQUva1k8JT6tRO74AiGdqImEhH8MwpaZLPbkYyzClwTXWd2k
         ZaZaZhMyAcATQ==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH 5/7] dsa: marvell: Add helper function to validate the max_frame_size variable
Date:   Thu,  9 Mar 2023 13:54:19 +0100
Message-Id: <20230309125421.3900962-6-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230309125421.3900962-1-lukma@denx.de>
References: <20230309125421.3900962-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit shall be regarded as a transition one, as this function helps
to validate the correctness of max_frame_size variable added to
mv88e6xxx_info structure.

It is necessary to avoid regressions as manual assessment of this value
turned out to be error prone.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
---
Changes for v5:
- New patch
---
 drivers/net/dsa/mv88e6xxx/chip.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 9695a1af45a9..af14eb8a1bfd 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -7169,6 +7169,27 @@ static int __maybe_unused mv88e6xxx_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(mv88e6xxx_pm_ops, mv88e6xxx_suspend, mv88e6xxx_resume);
 
+static void mv88e6xxx_validate_frame_size(void)
+{
+	int max;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mv88e6xxx_table); i++) {
+		/* same logic as in mv88e6xxx_get_max_mtu() */
+		if (mv88e6xxx_table[i].ops->port_set_jumbo_size)
+			max = 10240;
+		else if (mv88e6xxx_table[i].ops->set_max_frame_size)
+			max = 1632;
+		else
+			max = 1522;
+
+		if (mv88e6xxx_table[i].max_frame_size != max)
+			pr_err("BUG: %s has differing max_frame_size: %d != %d\n",
+			       mv88e6xxx_table[i].name, max,
+			       mv88e6xxx_table[i].max_frame_size);
+	}
+}
+
 static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 {
 	struct dsa_mv88e6xxx_pdata *pdata = mdiodev->dev.platform_data;
@@ -7302,6 +7323,7 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	if (err)
 		goto out_mdio;
 
+	mv88e6xxx_validate_frame_size();
 	return 0;
 
 out_mdio:
-- 
2.20.1

