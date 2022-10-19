Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFD96046DB
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbiJSNVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbiJSNVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:21:16 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E231F114DCD;
        Wed, 19 Oct 2022 06:06:35 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,195,1661785200"; 
   d="scan'208";a="137159771"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 19 Oct 2022 17:51:10 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 5FEB3400BC0E;
        Wed, 19 Oct 2022 17:51:10 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     linux@armlinux.org.uk, kabel@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH RFC 0/3] net: phy: marvell10g: Add host speed setting by an ethernet driver
Date:   Wed, 19 Oct 2022 17:50:49 +0900
Message-Id: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        KHOP_HELO_FCRDNS,SPF_HELO_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car S4-8 environment board requires to change the host interface
as SGMII and the host speed as 1000 Mbps because the strap pin was
other mode, but the SoC/board cannot work on that mode. Also, after
the SoC initialized the SERDES once, we cannot re-initialized it
because the initialized procedure seems all black magic...

To communicate between R-Car S4-8 (host MAC) and marvell PHY,
this patch series adds a new function of_phy_connect_with_host_param()
to set host parameters (host_interfaces and host_speed), and
rswitch driver sets the paramter. After that, the marvell10g can
check the paramters and set specific registers for it.

This patch series is based on next-20221017 and the following patches
which are not upstreamed yet:
https://lore.kernel.org/all/20221019083518.933070-1-yoshihiro.shimoda.uh@renesas.com/T/#m1c3de735de018b5cb90cb3720056ac1497112b36

I'm not sure whether this is a correct way or not. So, I marked
this patch series as RFC.

Yoshihiro Shimoda (3):
  net: mdio: Add of_phy_connect_with_host_param()
  net: phy: marvell10g: Add host interface speed configuration
  net: renesas: rswitch: Pass host parameters to phydev

 drivers/net/ethernet/renesas/rswitch.c | 13 ++++++--
 drivers/net/mdio/of_mdio.c             | 42 ++++++++++++++++++++++++++
 drivers/net/phy/marvell10g.c           | 23 ++++++++++++++
 include/linux/of_mdio.h                |  7 +++++
 include/linux/phy.h                    |  8 +++++
 5 files changed, 91 insertions(+), 2 deletions(-)

-- 
2.25.1

