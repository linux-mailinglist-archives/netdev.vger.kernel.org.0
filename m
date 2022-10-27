Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A411460F964
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbiJ0Nk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236149AbiJ0Nk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:40:57 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C0BFB2DAF;
        Thu, 27 Oct 2022 06:40:56 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,217,1661785200"; 
   d="scan'208";a="140602858"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 27 Oct 2022 22:40:55 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 85CC04048F0C;
        Thu, 27 Oct 2022 22:40:55 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v5 0/3] net: ethernet: renesas: Add support for "Ethernet Switch"
Date:   Thu, 27 Oct 2022 22:40:31 +0900
Message-Id: <20221027134034.2343230-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is based on next-20221027.

Add initial support for Renesas "Ethernet Switch" device of R-Car S4-8.
The hardware has features about forwarding for an ethernet switch
device. But, for now, it acts as ethernet controllers so that any
forwarding offload features are not supported. So, any switchdev
header files and DSA framework are not used.

Notes that this driver requires some special settings on marvell10g,
Especially host mactype and host speed. And, I need further investigation
to modify the marvell10g driver for upstream. But, the special settings
are applied, this rswitch driver can work correcfly without any changes
of this rswitch driver. So, I believe the rswitch driver can go for
upstream.

Changes from v4:
https://lore.kernel.org/all/20221019083518.933070-1-yoshihiro.shimoda.uh@renesas.com/
 - Rebased on next-20221027.
 - Drop some unneeded properties on the dt-bindings doc.
 - Change the subject and commit descriptions on the patch [2/3].
 - Use phylink instead of phylib.
 - Modify struct rswitch_*_desc to remove similar functions ([gs]et_dptr).

Changes from v3:
 https://lore.kernel.org/all/20220922052803.3442561-1-yoshihiro.shimoda.uh@renesas.com/
 - Rebased on next-20221017.
 - Rename dt-binding file.
 - Fix a lot of things about dt-binding.
 - Remove unneeded clocks/resets property.
 - Fix a lot of things about the rswitch driver.
 -- Fix a lot of sparse warnings.
 -- Naming of definitations/variables for readability.
 -- Add supports for all ports, especially using direct descriptor mode
    for sending frames from CPU to the specific user port.
 --- Refactor the initialization sequence to support all ports.
     (Especially, this is for SERDES which needs all black magic...)
 - Add protection for multiple registers access in the ptp driver.

Changes from v2:
 https://lore.kernel.org/all/20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com/
 - Separate patcheas into each subsystem.
 - Add spin lock protection for multiple registers access in patch [3/3].

Yoshihiro Shimoda (3):
  dt-bindings: net: renesas: Document Renesas Ethernet Switch
  net: ethernet: renesas: Add support for "Ethernet Switch"
  net: ethernet: renesas: rswitch: Add R-Car Gen4 gPTP support

 .../net/renesas,r8a779f0-ether-switch.yaml    |  261 +++
 drivers/net/ethernet/renesas/Kconfig          |   11 +
 drivers/net/ethernet/renesas/Makefile         |    4 +
 drivers/net/ethernet/renesas/rcar_gen4_ptp.c  |  181 ++
 drivers/net/ethernet/renesas/rcar_gen4_ptp.h  |   72 +
 drivers/net/ethernet/renesas/rswitch.c        | 1832 +++++++++++++++++
 drivers/net/ethernet/renesas/rswitch.h        |  973 +++++++++
 7 files changed, 3334 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml
 create mode 100644 drivers/net/ethernet/renesas/rcar_gen4_ptp.c
 create mode 100644 drivers/net/ethernet/renesas/rcar_gen4_ptp.h
 create mode 100644 drivers/net/ethernet/renesas/rswitch.c
 create mode 100644 drivers/net/ethernet/renesas/rswitch.h

-- 
2.25.1

