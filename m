Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCAF66EB777
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 06:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjDVE7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 00:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjDVE7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 00:59:34 -0400
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA7A1BEC;
        Fri, 21 Apr 2023 21:59:31 -0700 (PDT)
X-QQ-mid: bizesmtp66t1682139524tohjp0zk
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 22 Apr 2023 12:58:29 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: znfcQSa1hKZBDzquBTLLcvy2B4kBgi0XQWJHFjDxgGE2NxVJB3eYYbtyIh8/I
        z43f4DYEaVGdS8AhwYH4bMA2UdWfBgk8boA0pXHS4p2wIopTEqZbk/jRK7j4rX3qTJqYxmq
        rvk60aNoMNPTbj0uSVOp+YlFA7cAe8t4I93jwQpoWr9exAn/RlJ2/dQj4IaSOS4z7dAZzRm
        223jfT6fjB5MrH49GPGa60MXFVyNHSCwD+0dP3+Rn5tv4bv+DWdhKp1OXTgUfzbGb5FKAbw
        8dFPe+WP5cKXfgemTdXLbjERO2QKs404Jxf2HSxxuPV8vuF+clXbrVBQqlPqm7xVTK/guDm
        Rqh3oOildHysybgdiYg07a37GwgNRWO6bNk2zPm8xrgMqOQ4sg=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 10421498859572223231
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, andrew@lunn.ch, linux@armlinux.org.uk,
        jarkko.nikula@linux.intel.com, olteanv@gmail.com,
        andriy.shevchenko@linux.intel.com, hkallweit1@gmail.com
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v4 0/8] TXGBE PHYLINK support
Date:   Sat, 22 Apr 2023 12:56:13 +0800
Message-Id: <20230422045621.360918-1-jiawenwu@trustnetic.com>
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

Implement I2C, SFP, GPIO and PHYLINK to setup TXGBE link.

Because our I2C and PCS are based on Synopsys Designware IP-core, extend
the i2c-designware and pcs-xpcs driver to realize our functions.

v3 -> v4:
- modify I2C transfer to be generic implementation
- avoid to read DW_IC_COMP_PARAM_1
- remove redundant "if" statement
- add specific labels to handle error in txgbe_init_phy(), and remove
  "if" conditions in txgbe_remove_phy()

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

 drivers/i2c/busses/i2c-designware-common.c    |   8 +
 drivers/i2c/busses/i2c-designware-core.h      |   1 +
 drivers/i2c/busses/i2c-designware-master.c    |  84 ++-
 drivers/i2c/busses/i2c-designware-platdrv.c   |  36 +-
 drivers/net/ethernet/wangxun/Kconfig          |   6 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   |   3 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |   3 +
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   1 +
 .../ethernet/wangxun/txgbe/txgbe_ethtool.c    |  28 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  63 +-
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 570 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_phy.h    |  10 +
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  92 +++
 drivers/net/pcs/pcs-xpcs.c                    |  56 ++
 include/linux/pcs/pcs-xpcs.h                  |   1 +
 include/linux/platform_data/i2c-dw.h          |  15 +
 16 files changed, 940 insertions(+), 37 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
 create mode 100644 include/linux/platform_data/i2c-dw.h

-- 
2.27.0

