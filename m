Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87BC9543DB5
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 22:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbiFHUq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 16:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiFHUqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 16:46:43 -0400
Received: from smtp5.emailarray.com (smtp5.emailarray.com [65.39.216.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0462BEBE88
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 13:46:42 -0700 (PDT)
Received: (qmail 79755 invoked by uid 89); 8 Jun 2022 20:44:52 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjg0LjIwNQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 8 Jun 2022 20:44:52 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@fb.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Lasse Johnsen <l@ssejohnsen.me>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: [PATCH net-next v6 0/3] Broadcom PTP PHY support
Date:   Wed,  8 Jun 2022 13:44:48 -0700
Message-Id: <20220608204451.3124320-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds PTP support for the Broadcom PHY BCM54210E (and the
specific variant BCM54213PE that the rpi-5.15 branch uses).

This has only been tested on the RPI CM4, which has one port.

There are other Broadcom chips which may benefit from using the
same framework here, although with different register sets.

v5->v6:
 Fix calculations in bcm_ptp_adjtime_locked (Richard)
 Add bcm_ptp_stop (Florian)
 Update framesync handling for better masking and restore
 Cleanup 1PPS perout function, remove unsync'd version
 Add 1PPS extts detection
 Break out extts/perout into its own patch

v4->v5:
 Reorder so bcm-phy-lib.h shows up first, fixing dependency issues.
 Use set_normalized_timespec for adjusting ns in adjtime
 Return upscaled config setting from hwtstamp

v3->v4:
 Squash bcm-phy-lib.h and broadcom.c changes into one patch
 Reorder so the main patch shows up first.

v2->v3:
 Rearrange patches so they apply in order
 Use ERR_CAST

v1->v2:
 Squash Kconfig into main patch
 Move config checks into bcm-phy-lib.h
 Fix delta_ns calculations in adjtime
 Uppercase mode selector macros
 Only use NSE_INIT when necessary
 Remove the inserted Broadcom RX timestamp from the PTP packet
 Add perout (chip generated) and fsync out (timer generated)
 Remove PHY_ID_BCM54213PE special casing (needed for rpi tree)
--- 
CC: Andrew Lunn <andrew@lunn.ch>
CC: Florian Fainelli <f.fainelli@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
CC: Lasse Johnsen <l@ssejohnsen.me>
CC: Heiner Kallweit <hkallweit1@gmail.com>
CC: Russell King <linux@armlinux.org.uk>
CC: "David S. Miller" <davem@davemloft.net>
CC: Eric Dumazet <edumazet@google.com>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Paolo Abeni <pabeni@redhat.com>
CC: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
--- 

Jonathan Lemon (3):
  net: phy: broadcom: Add Broadcom PTP hooks to bcm-phy-lib
  net: phy: broadcom: Add PTP support for some Broadcom PHYs.
  net: phy: Add support for 1PPS out and external timestamps

 drivers/net/phy/Kconfig       |  10 +
 drivers/net/phy/Makefile      |   1 +
 drivers/net/phy/bcm-phy-lib.h |  19 +
 drivers/net/phy/bcm-phy-ptp.c | 945 ++++++++++++++++++++++++++++++++++
 drivers/net/phy/broadcom.c    |  33 +-
 5 files changed, 1004 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/phy/bcm-phy-ptp.c

-- 
2.34.3

