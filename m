Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929A2620B0F
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbiKHIYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbiKHIXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:23:55 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1024D27B21
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 00:23:53 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 0ECC785002;
        Tue,  8 Nov 2022 09:23:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1667895831;
        bh=C6B+a2DadBo1YhlPDtYATKhq1EjEieIoxolsfqGeLgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ve2WcK/TsSX+91gcYxhxq7S9tkfZxe9T+dtU7rDKkumOdmgCyqYxM7Fu21krcOw71
         ORyBVUyvHCpLX9gg5uWCuNS1cwzbTa0PdihkzDhZ8NkUaDGO7cRwBpYII3t2y3Ovqd
         smGZxy4Xj7fgH6GK2HTdTZ5+tLKsN7joaXw1GO+Ui1qk7R2WIhoj3cd31gC6B885rr
         g10MwKIb6F2Jhm5MDQ/olt5BRMpgvapZWws+p+AhN870x0js+hjAZwX55XHKVi0PVh
         wrXsyUKAtoi7hshnWjcRZJzbC49hyBFG3mX1MrwebJ9MS3KwhMnFdvlvv851LjDkHN
         HED9LhEZ2F3Mg==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH 9/9] net: dsa: mv88e6071: Set .set_max_frame_size callback
Date:   Tue,  8 Nov 2022 09:23:30 +0100
Message-Id: <20221108082330.2086671-10-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221108082330.2086671-1-lukma@denx.de>
References: <20221108082330.2086671-1-lukma@denx.de>
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

The .set_max_frame_size is now set to the
mv88e6185_g1_set_max_frame_size() function.

The global switch control register (0x4 offset) used
as well as the bit (10) are the same.

The only difference is the misleading suffix (1632)
as the mv88e6071/mv88e6020 supports 2048 bytes
as a maximal size of the frame.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1aba9d15a5e0..ce7723d1ffbe 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4998,6 +4998,7 @@ static const struct mv88e6xxx_ops mv88e6071_ops = {
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6250_ptp_ops,
+	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
 static const struct mv88e6xxx_ops mv88e6290_ops = {
-- 
2.37.2

