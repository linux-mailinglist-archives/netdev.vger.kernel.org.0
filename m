Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB66459F671
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 11:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbiHXJhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 05:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbiHXJhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 05:37:12 -0400
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C2195AE5;
        Wed, 24 Aug 2022 02:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1661333832;
  x=1692869832;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YJCzYLp8Y2/CRNKGcIXUTUMWNoKrWZYcZFG32dKFNeM=;
  b=Q2Q+QCcUfcchcyMhjEa6cYy+q29S9bGzZrBTqaZiE2TWpFL41JoqmQu4
   +KL6oQFj7q5ODzOqrgIJoyYlsigBDte0H7/PGUFNWgMb7OgFVJEu0kM4Y
   aH872UfP3jJeEjwcGTQOQ2fYP4qe321nOFrhbtkphnwyl0a/UED0X8i6Q
   A6SXvIZMtFtynToxANU8UcKEpb08ue+OLnOwtMyUae9UzwX/c9f5Omhu4
   +uuqNFnmSEQe9kBfWtHHYaF8F5xKdsp4o+V9XoRgT1dkts9lYNEynrNxW
   Svngfd8GIFNM5/xfjm3Bg5tGMb1fCYOpPRf4K7S8z3exiMcTv+HB+YX+d
   Q==;
From:   Marcus Carlberg <marcus.carlberg@axis.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <kernel@axis.com>, Marcus Carlberg <marcus.carlberg@axis.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: dsa: mv88e6xxx: Allow external SMI if serial
Date:   Wed, 24 Aug 2022 11:37:06 +0200
Message-ID: <20220824093706.19049-1-marcus.carlberg@axis.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

p0_mode set to one of the supported serial mode should not prevent
configuring the external SMI interface in
mv88e6xxx_g2_scratch_gpio_set_smi. The current masking of the p0_mode
only checks the first 2 bits. This results in switches supporting
serial mode cannot setup external SMI on certain serial modes
(Ex: 1000BASE-X and SGMII).

Extend the mask of the p0_mode to include the reduced modes and
serial modes as allowed modes for the external SMI interface.

Signed-off-by: Marcus Carlberg <marcus.carlberg@axis.com>
---
 drivers/net/dsa/mv88e6xxx/global2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index 807aeaad9830..7536b8b0ad01 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -298,7 +298,7 @@
 #define MV88E6352_G2_SCRATCH_CONFIG_DATA1	0x71
 #define MV88E6352_G2_SCRATCH_CONFIG_DATA1_NO_CPU	BIT(2)
 #define MV88E6352_G2_SCRATCH_CONFIG_DATA2	0x72
-#define MV88E6352_G2_SCRATCH_CONFIG_DATA2_P0_MODE_MASK	0x3
+#define MV88E6352_G2_SCRATCH_CONFIG_DATA2_P0_MODE_MASK	0xf
 #define MV88E6352_G2_SCRATCH_CONFIG_DATA3	0x73
 #define MV88E6352_G2_SCRATCH_CONFIG_DATA3_S_SEL		BIT(1)
 
-- 
2.20.1

