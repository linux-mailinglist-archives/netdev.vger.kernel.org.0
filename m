Return-Path: <netdev+bounces-6959-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F387190FB
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:09:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C87431C20FC4
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 03:09:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA7E1FA9;
	Thu,  1 Jun 2023 03:09:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6A41C33
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 03:09:30 +0000 (UTC)
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2C810C9
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 20:08:51 -0700 (PDT)
X-QQ-mid: bizesmtp86t1685588629th185j4x
Received: from wxdbg.localdomain.com ( [183.159.96.128])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 01 Jun 2023 11:03:29 +0800 (CST)
X-QQ-SSF: 01400000000000J0Z000000A0000000
X-QQ-FEAT: KvvwR/hcPA28oVGIpiInLMiYRnef01bpBESmW5NetR65y/eNZnlU7wyFU9VS+
	kiK1h/8VQhkJB2eBYHxmgJia7SiU2+wiAlDtv0P2Htqy0RC37deOx0Dbos1xuqqRKHQeFtN
	+S6RU1txc56oGd/Egq6DZ+dk6FxCmtan/iEQuGu9IB5D/dJNCsxlw9Y2bfOD6W3IbnG8r7v
	VpoYVufxYMuhYlqI6dP6ZrQTMKTY70UvRuRtgucZDrZQ13w2kWU1R/8aw9o7LQ1rvbtKlh7
	9nuRlJuOQ39HM1LuBBDrdT2/LDOy+lJ/3K/E/EQYivy9Yw2K1D2Gxfe1OscsEURZlbnTnqK
	G0wxr/rKoGinGtz0R+6LHA+4K837ZwfmkpPjEe3rePiriFD4Sw=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 6414154519478394770
From: Jiawen Wu <jiawenwu@trustnetic.com>
To: netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com,
	jsd@semihalf.com,
	Jose.Abreu@synopsys.com,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk
Cc: linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com,
	Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v10 0/9] TXGBE PHYLINK support
Date: Thu,  1 Jun 2023 11:01:31 +0800
Message-Id: <20230601030140.687493-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement I2C, SFP, GPIO and PHYLINK to setup TXGBE link.

Because our I2C and PCS are based on Synopsys Designware IP-core, extend
the i2c-designware and pcs-xpcs driver to realize our functions.

v9 -> v10:
- clear I2C device model flags
- change the order of header files
- use xpcs_create_mdiodev()
- fix Kconfig warning

v8 -> v9:
- rename swnode property for specific I2C platform device
- add ".fast_io = true" for I2C regmap
- use raw_spinlock_t for GPIO reg lock and adjust its position
- remove redundant txgbe->mdiodev
- keep reverse x-mass tree order
- other minor style changes

v7 -> v8:
- use macro defined I2C FIFO depth instead of magic number
- fix return code of clock create failure
- add spinlock for writing GPIO registers
- implement triggering GPIO interrupts for both-edge type
- remove the condition that enables interrupts
- add mii bus check for PCS device
- other minor style changes

v6 -> v7:
- change swnode property of I2C platform to be boolean
- use device_property_present() to match I2C device data

v5 -> v6:
- fix to set error code if pointer of txgbe is NULL
- change "if" to "switch" for *_i2c_dw_xfer_quirk()
- rename property for I2C device flag
- use regmap to access I2C mem region
- use DEFINE_RES_IRQ()
- use phylink_mii_c45_pcs_get_state() for DW_XPCS_10GBASER

v4 -> v5:
- add clock register
- delete i2c-dw.h with platform data
- introduce property "i2c-dw-flags" to match device flags
- get resource from platform info to do ioremap
- rename quirk functions in i2c-designware-*.c
- fix calling txgbe_phylink_init()

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

Jiawen Wu (9):
  net: txgbe: Add software nodes to support phylink
  i2c: designware: Add driver support for Wangxun 10Gb NIC
  net: txgbe: Register fixed rate clock
  net: txgbe: Register I2C platform device
  net: txgbe: Add SFP module identify
  net: txgbe: Support GPIO to SFP socket
  net: pcs: Add 10GBASE-R mode for Synopsys Designware XPCS
  net: txgbe: Implement phylink pcs
  net: txgbe: Support phylink MAC layer

 drivers/i2c/busses/i2c-designware-common.c    |   8 +
 drivers/i2c/busses/i2c-designware-core.h      |   4 +
 drivers/i2c/busses/i2c-designware-master.c    |  89 ++-
 drivers/i2c/busses/i2c-designware-platdrv.c   |  15 +
 drivers/net/ethernet/wangxun/Kconfig          |  10 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   |   3 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |   4 +
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   1 +
 .../ethernet/wangxun/txgbe/txgbe_ethtool.c    |  28 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  65 +-
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 670 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_phy.h    |  10 +
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  89 +++
 drivers/net/pcs/pcs-xpcs.c                    |  30 +
 include/linux/pcs/pcs-xpcs.h                  |   1 +
 15 files changed, 989 insertions(+), 38 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h

-- 
2.27.0


