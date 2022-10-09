Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E56A5F90A1
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbiJIW0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbiJIWY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:24:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B16193E3;
        Sun,  9 Oct 2022 15:18:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 426F2B80DFC;
        Sun,  9 Oct 2022 22:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE21C43470;
        Sun,  9 Oct 2022 22:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353758;
        bh=QRlhcj5BMHJzNR3pQ4+/M72AS4Peto5sSQnQiwknc4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBOizXwvo91q7K2pO47ghlfoD7iGa7cTrwWNqKDWELIpfDucWTLyNxytx8gZnC4yh
         7UYp5+Qs83mlctEDGQ7JMfXGBzaRIIOtFKyvMgQJVxtuRzi8Fz6CJ/z63Et2KF3epG
         JQ5BOmMdvc+1O7k0gJjbI1MneiFeK9sxg2Kts6jM3s/GtqMh4YKg8Ik/iF7EIU4Olf
         BiPnJascMj8xIbH1OWD9INOnQMfRFNowZn6QC/EvblG7s/acaL7afedcQUhkGehO6M
         m6urSjUnjI+SbD6zD+grO4Q5MT4EwF404Qjb8OFoV5KRF0X/Z46+bJg27ZEoQmo9lL
         VzR4sCkyGWJ8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcus Carlberg <marcus.carlberg@axis.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 15/73] net: dsa: mv88e6xxx: Allow external SMI if serial
Date:   Sun,  9 Oct 2022 18:13:53 -0400
Message-Id: <20221009221453.1216158-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcus Carlberg <marcus.carlberg@axis.com>

[ Upstream commit 8532c60efcc5b7b382006129b77aee2c19c43f15 ]

p0_mode set to one of the supported serial mode should not prevent
configuring the external SMI interface in
mv88e6xxx_g2_scratch_gpio_set_smi. The current masking of the p0_mode
only checks the first 2 bits. This results in switches supporting
serial mode cannot setup external SMI on certain serial modes
(Ex: 1000BASE-X and SGMII).

Extend the mask of the p0_mode to include the reduced modes and
serial modes as allowed modes for the external SMI interface.

Signed-off-by: Marcus Carlberg <marcus.carlberg@axis.com>
Link: https://lore.kernel.org/r/20220824093706.19049-1-marcus.carlberg@axis.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.35.1

