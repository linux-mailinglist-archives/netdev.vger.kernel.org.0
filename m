Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89DFB54F347
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 10:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380652AbiFQInr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 04:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381069AbiFQInZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 04:43:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4355C2B26D;
        Fri, 17 Jun 2022 01:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655455404; x=1686991404;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Vw1zRoLepBKUeO0HYeEdzkJaAQbGQ2petXz77myYyLs=;
  b=HKbUOGrScA10OMOeN6BUfg52Henk0k4kclY6lxbW/Hg7Ug4vyF4zRKlk
   XsblBnXofhtq9DZAH92DNFT8UOJ7gCkVknnTUbuCcDp98F5RcIQy8OqbI
   3YuVTTeFEBVCjjZE7t2RQ9hlFiQHO0EikMJ4lYyxgmhLPEVN054DKu2Hy
   9lthOkAS5Rxgmpz/h6dQQahpi9oLzqc6C+vgYErI6fuM9XTfMIvi+j2eH
   1UNfbiJlX/4BzdVdP34VuAF5lBraMr+viJUZdzYtCGwtOY3WieKIQGvTg
   +GGADT6Fwwb5mcDAnCoQSdkwIaHAlTQrmSSvQiAX1rlrHu2uxvLlIHb58
   A==;
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="168515102"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jun 2022 01:43:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Jun 2022 01:43:22 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 17 Jun 2022 01:43:18 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [Patch net-next 00/11] net: dsa: microchip: common spi probe for the ksz series switches - part 1
Date:   Fri, 17 Jun 2022 14:12:44 +0530
Message-ID: <20220617084255.19376-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series aims to refactor the ksz_switch_register routine to have the
common flow for the ksz series switch. At present ksz8795.c & ksz9477.c have
its own dsa_switch_ops and switch detect functionality.
In ksz_switch_register, ksz_dev_ops is assigned based on the function parameter
passed by the individual ksz8/ksz9477 switch register function. And then switch
detect is performed based on the ksz_dev_ops.detect hook.  This patch modifies
the ksz_switch_register such a way that switch detect is performed first, based
on the chip ksz_dev_ops is assigned to ksz_device structure. It ensures the
common flow for the existing as well as LAN937x switches.
In the next series of patch, it will move ksz_dsa_ops and dsa_switch_ops
from ksz8795.c and ksz9477.c to ksz_common.c and have the common spi
probe all the ksz based switches.

Changes in v1
- Splitted the patch series into two.
- Replaced all occurrence of REG_PORT_STATUS_0 and PORT_FIBER_MODE to
  KSZ8_PORT_STATUS_0 and KSZ8_PORT_FIBER_MODE.
- Separated the tag protocol and phy read/write patch into two.
- Assigned the DSA_TAG_PROTO_NONE as the default value for get_tag_protocol hook.
- Reduced the indentation level by using the if(!dev->dev_ops->mirror_add).
- Added the stp_ctrl_reg as a member in ksz_chip_data and removed the member
  in ksz_dev_ops.
- Removed the r_dyn_mac_table, r_sta_mac_table and w_sta_mac_table from the
  ksz_dev_ops since it is used only in the ksz8795.c.

Changes in RFC v2
- Fixed the compilation issue.
- Reduced the patch set to 15.

Arun Ramadoss (11):
  net: dsa: microchip: ksz9477: cleanup the ksz9477_switch_detect
  net: dsa: microchip: move switch chip_id detection to ksz_common
  net: dsa: microchip: move tag_protocol to ksz_common
  net: dsa: microchip: ksz9477: use ksz_read_phy16 & ksz_write_phy16
  net: dsa: microchip: move vlan functionality to ksz_common
  net: dsa: microchip: move the port mirror to ksz_common
  net: dsa: microchip: get P_STP_CTRL in ksz_port_stp_state by
    ksz_dev_ops
  net: dsa: microchip: update the ksz_phylink_get_caps
  net: dsa: microchip: update the ksz_port_mdb_add/del
  net: dsa: microchip: update fdb add/del/dump in ksz_common
  net: dsa: microchip: move get_phy_flags & mtu to ksz_common

 drivers/net/dsa/microchip/ksz8795.c     | 233 ++++++++--------
 drivers/net/dsa/microchip/ksz8795_reg.h |  16 --
 drivers/net/dsa/microchip/ksz9477.c     | 181 +++++--------
 drivers/net/dsa/microchip/ksz9477_reg.h |   1 -
 drivers/net/dsa/microchip/ksz_common.c  | 342 ++++++++++++++++++------
 drivers/net/dsa/microchip/ksz_common.h  |  80 +++++-
 6 files changed, 517 insertions(+), 336 deletions(-)


base-commit: e8b03391b6a7353368d0d2d6ed2b5f03e0c6112f
-- 
2.36.1

