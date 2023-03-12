Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 275336B6B08
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 21:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjCLUYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 16:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjCLUYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 16:24:35 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4661730E8A;
        Sun, 12 Mar 2023 13:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678652671; x=1710188671;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=joNMncj/BiWcmzZcHvpg70xi30fS22mGS98IQ7jvZd0=;
  b=0uviPUIR14VZSZtOHwssU/LtCY0V7GL/quDOPOXPdH4MSK2vBiJgAg/S
   xKx3G04qW/YnPhkLcTakn4z6i9jJ8Ruk+/42B74AmuEaXhjbkyReCiep7
   fBtPEsJvM/HZU+2tlaDORMYWQhQV7kNYdcO2JStvH3MK2YL0DjQWlOgWy
   f/+4DfvuJXLeMvVjY80In2skT8WcGC3zPbTjHpoSto9CM7iX/cVco7LPg
   3zYRmpGp3+ab3TyAMG4sOg2/AUrP7ylmFwjMWorfQJoWec5gPHJ171dfI
   4xy6r/LcyBMLoXAllYRCBTkpPxprl3vfKv5fmjpYX4fvazMhCjE8Cd1kk
   w==;
X-IronPort-AV: E=Sophos;i="5.98,254,1673938800"; 
   d="scan'208";a="201240583"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Mar 2023 13:24:30 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 13:24:29 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Sun, 12 Mar 2023 13:24:27 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/2] net: lan966x: Improve TX/RX of frames from/to CPU
Date:   Sun, 12 Mar 2023 21:24:22 +0100
Message-ID: <20230312202424.1495439-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
this gives an improvement of ~100mbit on TX side.
All the measurements were done using iperf3.

Horatiu Vultur (2):
  net: lan966x: Don't read RX timestamp if not needed
  net: lan966x: Stop using packing library

 .../net/ethernet/microchip/lan966x/Kconfig    |  1 -
 .../ethernet/microchip/lan966x/lan966x_fdma.c |  2 +-
 .../ethernet/microchip/lan966x/lan966x_main.c | 77 +++++++++++++------
 .../ethernet/microchip/lan966x/lan966x_main.h |  5 +-
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 20 ++---
 5 files changed, 66 insertions(+), 39 deletions(-)

-- 
2.38.0

