Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83874EF4D3
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348531AbiDAOyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350161AbiDAOrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:47:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C662A03E6;
        Fri,  1 Apr 2022 07:37:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24F6AB8250B;
        Fri,  1 Apr 2022 14:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED45C36AF8;
        Fri,  1 Apr 2022 14:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823834;
        bh=yKDECHd+3Hf1wFsavIVXaGAn88ZEKbCwTF4OHq50O2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZK6GuRG+viGcZfijINiSQEXjzvyQv5IZYAZlT6qPKrUwT60jXHih6fLBaSKTTei4/
         jKctDS85uGy7tmIkFs3LtnJvhVgVmrr2JTAvSlss1H4MWwWt2i+m6FR2Pley3nGKiu
         84IujdJJj7MhvpNlxvyKqnIvQRgR08ZhfxGTc68VdlmqlfLyxhyY+psAKGiyczGiGv
         O51eHbwWxiuFXAu6+tJlhRinbJSq53ccfhaKrO9fBJcjRfguhcADPt5Ip2iqv12FHe
         uoGHNSGSJd+Xy5hXrO8SdMIzNZV8WTB8LfKHj0WQor+JUoaU1cVP2Avu+SO7x56agJ
         YEGXN25pui6Qw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 097/109] net: sfp: add 2500base-X quirk for Lantech SFP module
Date:   Fri,  1 Apr 2022 10:32:44 -0400
Message-Id: <20220401143256.1950537-97-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 00eec9fe4f3b9588b4bfa8ef9dd0aae96407d5d7 ]

The Lantech 8330-262D-E module is 2500base-X capable, but it reports the
nominal bitrate as 2500MBd instead of 3125MBd. Add a quirk for the
module.

The following in an EEPROM dump of such a SFP with the serial number
redacted:

00: 03 04 07 00 00 00 01 20 40 0c 05 01 19 00 00 00    ???...? @????...
10: 1e 0f 00 00 4c 61 6e 74 65 63 68 20 20 20 20 20    ??..Lantech
20: 20 20 20 20 00 00 00 00 38 33 33 30 2d 32 36 32        ....8330-262
30: 44 2d 45 20 20 20 20 20 56 31 2e 30 03 52 00 cb    D-E     V1.0?R.?
40: 00 1a 00 00 46 43 XX XX XX XX XX XX XX XX XX XX    .?..FCXXXXXXXXXX
50: 20 20 20 20 32 32 30 32 31 34 20 20 68 b0 01 98        220214  h???
60: 45 58 54 52 45 4d 45 4c 59 20 43 4f 4d 50 41 54    EXTREMELY COMPAT
70: 49 42 4c 45 20 20 20 20 20 20 20 20 20 20 20 20    IBLE

Signed-off-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20220312205014.4154907-1-michael@walle.cc
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp-bus.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index c1512c9925a6..15aa5ac1ff49 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -74,6 +74,12 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.vendor = "HUAWEI",
 		.part = "MA5671A",
 		.modes = sfp_quirk_2500basex,
+	}, {
+		// Lantech 8330-262D-E can operate at 2500base-X, but
+		// incorrectly report 2500MBd NRZ in their EEPROM
+		.vendor = "Lantech",
+		.part = "8330-262D-E",
+		.modes = sfp_quirk_2500basex,
 	}, {
 		.vendor = "UBNT",
 		.part = "UF-INSTANT",
-- 
2.34.1

