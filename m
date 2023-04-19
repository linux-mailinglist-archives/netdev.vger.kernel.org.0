Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3346E7514
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbjDSI25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbjDSI2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:28:54 -0400
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BBD449D;
        Wed, 19 Apr 2023 01:28:51 -0700 (PDT)
X-QQ-mid: bizesmtp68t1681892925t2smjhin
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 19 Apr 2023 16:28:36 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: WMGta2JUicY6lp4BDFyIrDgjxzRSNsmDkIxLnhoZuLy/l8sMUYw3oKtrB+2NX
        yydpsCaOjRQjvpjWdShw3v3biRVHRLuF1TYZTFHLZRgp+rZ9V1YL+7gnwx0oR0x02leh5G4
        alkRi+q+Wr9CYvLARKEk1QSQKuuxIURZGHoi/G+6R5rpBUzodHrcvlNWm+PkCV8/+433px4
        NH9JEgpktjv2CXmyDxrXJD8j8w1P1oEx44a3YuH1ksX1R5uEdFwFnGU5NCEcFzQdrxvxK2D
        EeegTFWYR/K0UF8ffwD798N3EWlu53QN5OOxrDDMTWC2lxIyOBPBJbIwlAb25e/fasutqTB
        rtNqO+XTYd2cHHVfUq9EuGMd17xgkSWwZEWTh1wHFfzObQ3+A4qV8Et42ZZAA==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 4162631676512922062
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        olteanv@gmail.com, mengyuanlou@net-swift.com,
        Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v3 0/8] TXGBE PHYLINK support
Date:   Wed, 19 Apr 2023 16:27:31 +0800
Message-Id: <20230419082739.295180-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement I2C, SFP, GPIO and PHYLINK to setup TXGBE link and switch link
rate based on optical module information.

Because our I2C and PCS are based on Synopsys Designware IP-core, extend
the i2c-designware and pcs-xpcs driver to realize our functions.

v2 -> v3:
- delete own I2C bus master driver, support it in i2c-designware
- delete own PCS functions, remove pma configuration and 1000BASE-X mode
- add basic function for 10GBASE-R interface in pcs-xpcs
- add helper to get txgbe pointer from netdev

v1 -> v2:
- add comments to indicate GPIO lines
- add I2C write operation support
- modify GPIO direction functions
- rename functions related to PHY interface
- add condition on interface changing to re-config PCS
- add to set advertise and fix to get status for 1000BASE-X mode
- other redundant codes remove

Jiawen Wu (8):
  net: txgbe: Add software nodes to support phylink
  i2c: designware: Add driver support for Wangxun 10Gb NIC
  net: txgbe: Register I2C platform device
  net: txgbe: Add SFP module identify
  net: txgbe: Support GPIO to SFP socket
  net: pcs: Add 10GBASE-R mode for Synopsys Designware XPCS
  net: txgbe: Implement phylink pcs
  net: txgbe: Support phylink MAC layer

 drivers/i2c/busses/i2c-designware-common.c    |   4 +
 drivers/i2c/busses/i2c-designware-core.h      |   1 +
 drivers/i2c/busses/i2c-designware-master.c    |  91 ++-
 drivers/i2c/busses/i2c-designware-platdrv.c   |  36 +-
 drivers/net/ethernet/wangxun/Kconfig          |   6 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   |   3 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |   3 +
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   1 +
 .../ethernet/wangxun/txgbe/txgbe_ethtool.c    |  28 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  63 +-
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 585 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_phy.h    |  10 +
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  92 +++
 drivers/net/pcs/pcs-xpcs.c                    |  58 ++
 include/linux/pcs/pcs-xpcs.h                  |   1 +
 include/linux/platform_data/i2c-dw.h          |  15 +
 16 files changed, 960 insertions(+), 37 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
 create mode 100644 include/linux/platform_data/i2c-dw.h

-- 
2.27.0

