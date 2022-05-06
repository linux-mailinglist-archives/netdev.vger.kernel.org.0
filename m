Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5522651E1FD
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376562AbiEFWp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355448AbiEFWp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:45:57 -0400
Received: from smtp2.emailarray.com (smtp.emailarray.com [69.28.212.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE2961600
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:42:12 -0700 (PDT)
Received: (qmail 38834 invoked by uid 89); 6 May 2022 22:42:11 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 6 May 2022 22:42:11 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        lasse@timebeat.app, clk@fb.com
Subject: [PATCH net-next v4 0/2] Broadcom PTP PHY support
Date:   Fri,  6 May 2022 15:42:08 -0700
Message-Id: <20220506224210.1425817-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
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

Thanks to Lasse Johnsen <lasse@timebeat.app> for pointing out
that the chip's periodic output generation isn't sync'd to any
time base.

Jonathan Lemon (2):
  net: phy: broadcom: Add PTP support for some Broadcom PHYs.
  net: phy: broadcom: Add Broadcom PTP hooks to bcm-phy-lib

 drivers/net/phy/Kconfig       |  10 +
 drivers/net/phy/Makefile      |   1 +
 drivers/net/phy/bcm-phy-lib.h |  14 +
 drivers/net/phy/bcm-phy-ptp.c | 869 ++++++++++++++++++++++++++++++++++
 drivers/net/phy/broadcom.c    |  23 +-
 5 files changed, 913 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/phy/bcm-phy-ptp.c

-- 
2.34.3


Jonathan Lemon (3):
  net: phy: broadcom: Add Broadcom PTP hooks to bcm-phy-lib
  net: phy: broadcom: Hook up the PTP PHY functions
  net: phy: broadcom: Add PTP support for some Broadcom PHYs.

 drivers/net/phy/Kconfig       |  10 +
 drivers/net/phy/Makefile      |   1 +
 drivers/net/phy/bcm-phy-lib.h |  14 +
 drivers/net/phy/bcm-phy-ptp.c | 869 ++++++++++++++++++++++++++++++++++
 drivers/net/phy/broadcom.c    |  23 +-
 5 files changed, 913 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/phy/bcm-phy-ptp.c

-- 
2.31.1
