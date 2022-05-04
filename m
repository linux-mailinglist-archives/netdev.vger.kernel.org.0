Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BCA51B233
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 00:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237498AbiEDWrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 18:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbiEDWri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 18:47:38 -0400
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33114888F
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 15:43:59 -0700 (PDT)
Received: (qmail 14482 invoked by uid 89); 4 May 2022 22:43:58 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 4 May 2022 22:43:58 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, richardcochran@gmail.com,
        lasse@timebeat.app
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next v3 0/3] Broadcom PTP PHY support
Date:   Wed,  4 May 2022 15:43:53 -0700
Message-Id: <20220504224356.1128644-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
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
