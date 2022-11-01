Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40EE6146EC
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 10:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiKAJkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 05:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiKAJkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 05:40:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3CE18E23;
        Tue,  1 Nov 2022 02:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667295575; x=1698831575;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GAoo/BJgk2MhRjdr2Zx1abuI3Wf02Ay0QWvIGLbIG5Y=;
  b=lbpw1H9SwWTg77B1nKDRU8y0vpbBe5yaOQVhpcp8OJzG64nKnQX3EA+x
   GiY0ekQ5/IZ56G/E0a9GTvEvrlXTYpJKFDXX4EvMSsoJS78yIlUcg2O+8
   n3WpCfN3+mEQAGg5NFOb+5V6v1KguLpEAkv9dybyb8mpxzBTw5vfx2D07
   Wa0853HA1V3hBbkQGDwCSKD7/LCEd97UmV2qQNG5Z3WgRRvvHB1T8IYM/
   aWbnUXDiA5t5hYTKe1PN1qIwgWIkIwPs3HDsCn8EMIWkMZ9YjVy9p6Sj+
   6CstDNBmCsnj1Y4i9Zg/MBwuWHkwU8w9wPjiPGZsB8IObA60tEoKGJrJ0
   A==;
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="184796645"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Nov 2022 02:39:34 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 1 Nov 2022 02:39:33 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 1 Nov 2022 02:39:29 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <joe@perches.com>, <linux@armlinux.org.uk>,
        <horatiu.vultur@microchip.com>, <Julia.Lawall@inria.fr>,
        <vladimir.oltean@nxp.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next v6 0/6] Add new PCP and APPTRUST attributes to dcbnl
Date:   Tue, 1 Nov 2022 10:48:28 +0100
Message-ID: <20221101094834.2726202-1-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds new extension attributes to dcbnl, to support PCP
prioritization (and thereby hw offloadable pcp-based queue
classification) and per-selector trust and trust order. Additionally,
the microchip sparx5 driver has been dcb-enabled to make use of the new
attributes to offload PCP, DSCP and Default prio to the switch, and
implement trust order of selectors.

For pre-RFC discussion see:
https://lore.kernel.org/netdev/Yv9VO1DYAxNduw6A@DEN-LT-70577/

For RFC series see:
https://lore.kernel.org/netdev/20220915095757.2861822-1-daniel.machon@microchip.com/

In summary: there currently exist no convenient way to offload per-port
PCP-based queue classification to hardware. The DCB subsystem offers
different ways to prioritize through its APP table, but lacks an option
for PCP. Similarly, there is no way to indicate the notion of trust for
APP table selectors. This patch series addresses both topics.

PCP based queue classification:
  - 8021Q standardizes the Priority Code Point table (see 6.9.3 of IEEE
    Std 802.1Q-2018).  This patch series makes it possible, to offload
    the PCP classification to said table.  The new PCP selector is not a
    standard part of the APP managed object, therefore it is
    encapsulated in a new non-std extension attribute.

Selector trust:
  - ASIC's often has the notion of trust DSCP and trust PCP. The new
    attribute makes it possible to specify a trust order of app
    selectors, which drivers can then react on.

DCB-enable sparx5 driver:
 - Now supports offloading of DSCP, PCP and default priority. Only one
   mapping of protocol:priority is allowed. Consecutive mappings of the
   same protocol to some new priority, will overwrite the previous. This
   is to keep a consistent view of the app table and the hardware.
 - Now supports dscp and pcp trust, by use of the introduced
   dcbnl_set/getapptrust ops. Sparx5 supports trust orders: [], [dscp],
   [pcp] and [dscp, pcp]. For now, only DSCP and PCP selectors are
   supported by the driver, everything else is bounced.

Patch #1 introduces a new PCP selector to the APP object, which makes it
possible to encode PCP and DEI in the app triplet and offload it to the
PCP table of the ASIC.

Patch #2 Introduces the new extension attributes
DCB_ATTR_DCB_APP_TRUST_TABLE and DCB_ATTR_DCB_APP_TRUST. Trusted
selectors are passed in the nested DCB_ATTR_DCB_APP_TRUST_TABLE
attribute, and assembled into an array of selectors:

  u8 selectors[256];

where lower indexes has higher precedence.  In the array, selectors are
stored consecutively, starting from index zero. With a maximum number of
256 unique selectors, the list has the same maximum size.

Patch #3 Sets up the dcbnl ops hook, and adds support for offloading pcp
app entries, to the PCP table of the switch.

Patch #4 Makes use of the dcbnl_set/getapptrust ops, to set a per-port
trust order.

Patch #5 Adds support for offloading dscp app entries to the DSCP table
of the switch.

Patch #6 Adds support for offloading default prio app entries to the
switch.

================================================================================

RFC v1:
https://lore.kernel.org/netdev/20220908120442.3069771-1-daniel.machon@microchip.com/

RFC v1 -> RFC v2:
  - Added new nested attribute type DCB_ATTR_DCB_APP_TRUST_TABLE.
  - Renamed attributes from DCB_ATTR_IEEE_* to DCB_ATTR_DCB_*.
  - Renamed ieee_set/getapptrust to dcbnl_set/getapptrust.
  - Added -EOPNOTSUPP if dcbnl_setapptrust is not set.
  - Added sanitization of selector array, before passing to driver.

RFC v2 -> (non-RFC) v1:
  - Added additional check for selector validity.
  - Fixed a few style errors.
  - using nla_start_nest() instead of nla_start_nest_no_flag().
  - Moved DCB_ATTR_DCB_APP_TRUST into new enum.
  - Added new DCB_ATTR_DCB_APP extension attribute, for non-std selector
    values.
  - Added support for offloading dscp, pcp and default prio in the sparx5
    driver.
  - Added support for per-selector trust and trust order in the sparx5
    driver.

v1 -> v2:
  - Fixed compiler and kdoc warning

v2 -> v3:
  - Moved back to 255 as PCP selector value.
  - Fixed return value in dcbnl_app_attr_type_get() to enum.
  - Modified in dcbnl_app_attr_type_get() dcbnl_app_attr_type_validate() to
    return directly.
  - Added nselector check in sparx5_dcb_apptrust_validate().
  - Added const qualifier to "names" variable in struct sparx5_dcb_apptrust.
  - Added new SPARX5_DCB config. Fixes issues reported by kernel test robot.

v3 -> v4:
  - Added new dcbnl_app_attr_selector_validate() function to validate that
    app selectors are sent in correct attribute e.g IEEE selectors in
    DCB_ATTR_IEEE and non-std selectors in DCB_ATTR_DCB.
  - Modified handling of dcbnl_getapptrust() return value, so that an error is
    ignored. Instead, added error check on nla_put_u8() and cancelling nest in
    case of an error.

v4 -> v5:
  - Rebased on net-next and fixed sparx5 conflicts

v5 -> v6:
  - Fix check of return value from app to apptrust.
  - Refactor dcbnl_app_attr_selector_validate().
  - Add attr type check and selector check to apptrust.
  - Rename a few variables to contain "sparx5" and define symbols for constants
    in sparx5_dcb.c.

Daniel Machon (6):
  net: dcb: add new pcp selector to app object
  net: dcb: add new apptrust attribute
  net: microchip: sparx5: add support for offloading pcp table
  net: microchip: sparx5: add support for apptrust
  net: microchip: sparx5: add support for offloading dscp table
  net: microchip: sparx5: add support for offloading default prio

 drivers/net/ethernet/microchip/sparx5/Kconfig |  10 +
 .../net/ethernet/microchip/sparx5/Makefile    |   2 +
 .../ethernet/microchip/sparx5/sparx5_dcb.c    | 293 ++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_main.h   |  11 +
 .../microchip/sparx5/sparx5_main_regs.h       | 127 +++++++-
 .../ethernet/microchip/sparx5/sparx5_port.c   |  99 ++++++
 .../ethernet/microchip/sparx5/sparx5_port.h   |  37 +++
 .../ethernet/microchip/sparx5/sparx5_qos.c    |   4 +
 include/net/dcbnl.h                           |   4 +
 include/uapi/linux/dcbnl.h                    |  16 +
 net/dcb/dcbnl.c                               | 151 ++++++++-
 11 files changed, 746 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c

--
2.34.1

