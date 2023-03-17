Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634426BECE0
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjCQP2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjCQP2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:28:48 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C284F59D4;
        Fri, 17 Mar 2023 08:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679066926; x=1710602926;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xh8khnO5LMKQzWW2OXEJ2k8r3FN0sYjxZDroAWhyYSo=;
  b=2DQ16jHKewhBhZe0cHsJnSdumb9+05c7gR//CsWKYkZqlFY/8UrZeTnW
   OU+TtzzSD3f2vO671yAWYVNKo5Sibl6j59NSIHpDZK5hNen5sHWyCnx+H
   Rk0CmF7ROKHrDtSURr4imx+slCNkh20KcuiwH5NFLYPFMy6lp7MQydHFO
   fnUZWmy5Acv/Hikz+A0kiUXHPDunYB0dksWcd8APbEKk9oFWIvYYD+w4U
   apWf2WX1nlO0IiNjZJOdL8ct/9aue6BrO+wV4m32HjTZIJArDgcjgmP16
   Qz1XuGLS99vXdp0WE5l8v68dzx+MbPr2fc2QYWi/63XcbSSdItXa7NQSq
   w==;
X-IronPort-AV: E=Sophos;i="5.98,268,1673938800"; 
   d="scan'208";a="205234261"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2023 08:28:46 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 08:28:45 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 08:28:43 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <david.laight@aculab.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/2] net: lan966x: Improve TX/RX of frames from/to CPU
Date:   Fri, 17 Mar 2023 16:27:11 +0100
Message-ID: <20230317152713.4141614-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch of this series improves the RX side. As it seems to be
an expensive operation to read the RX timestamp for every frame, then
read it only if it is required. This will give an improvement of ~70mbit
on the RX side.
The second patch stops using the packing library. This improves mostly
the TX side as this library is used to set diffent bits in the IFH. If
this library is replaced with a more simple/shorter implementation,
this gives an improvement of more than 100mbit on TX side.
All the measurements were done using iperf3.

v1->v2:
- update lan966x_ifh_set to set the bytes and not each bit individually

Horatiu Vultur (2):
  net: lan966x: Don't read RX timestamp if not needed
  net: lan966x: Stop using packing library

 .../net/ethernet/microchip/lan966x/Kconfig    |  1 -
 .../ethernet/microchip/lan966x/lan966x_fdma.c |  2 +-
 .../ethernet/microchip/lan966x/lan966x_main.c | 76 +++++++++++++------
 .../ethernet/microchip/lan966x/lan966x_main.h |  5 +-
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 20 ++---
 5 files changed, 65 insertions(+), 39 deletions(-)

-- 
2.38.0

