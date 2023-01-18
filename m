Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFA767199B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjARKth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjARKsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:48:32 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECDB30B06;
        Wed, 18 Jan 2023 01:55:03 -0800 (PST)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30I9siVc007299;
        Wed, 18 Jan 2023 03:54:44 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1674035684;
        bh=jD3wjH/fKK2EjFCvy9AQqLjvXfkPS+sIQoGZYKdZK18=;
        h=From:To:CC:Subject:Date;
        b=MYzqYayCRSaPCoct9pv1gBcdZJScwfiJGiYUN3D864OBmyCBEnV5CEyIMpMHDnUG1
         Z2E5YsRisIRwGYVJSnNDO1yL1JSytIPdafR+t3vqMjjbd9HyNXGrjcTQmW+knih64W
         QPBeZwSnW1ucION926ZQhouer038F7EF2B7jYrCs=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30I9si9X036444
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 18 Jan 2023 03:54:44 -0600
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 18
 Jan 2023 03:54:44 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 18 Jan 2023 03:54:44 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30I9se8f107670;
        Wed, 18 Jan 2023 03:54:40 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>,
        <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <vigneshr@ti.com>,
        <srk@ti.com>, <s-vadapalli@ti.com>
Subject: [PATCH net-next v3 0/2] Fix CPTS release action in am65-cpts driver
Date:   Wed, 18 Jan 2023 15:24:37 +0530
Message-ID: <20230118095439.114222-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete unreachable code in am65_cpsw_init_cpts() function, which was
Reported-by: Leon Romanovsky <leon@kernel.org>
at:
https://lore.kernel.org/r/Y8aHwSnVK9+sAb24@unreal

Remove the devm action associated with am65_cpts_release() and invoke the
function directly on the cleanup and exit paths.

Changes from v2:
1. Drop Reviewed-by tag from Roger Quadros.
2. Add cleanup patch for deleting unreachable error handling code in
   am65_cpsw_init_cpts().
3. Drop am65_cpsw_cpts_cleanup() function and directly invoke
   am65_cpts_release().

Changes from v1:
1. Fix the build issue when "CONFIG_TI_K3_AM65_CPTS" is not set. This
   error was reported by kernel test robot <lkp@intel.com> at:
   https://lore.kernel.org/r/202301142105.lt733Lt3-lkp@intel.com/
2. Collect Reviewed-by tag from Roger Quadros.

v2:
https://lore.kernel.org/r/20230116044517.310461-1-s-vadapalli@ti.com/
v1:
https://lore.kernel.org/r/20230113104816.132815-1-s-vadapalli@ti.com/

Siddharth Vadapalli (2):
  net: ethernet: ti: am65-cpsw: Delete unreachable error handling code
  net: ethernet: ti: am65-cpsw/cpts: Fix CPTS release action

 drivers/net/ethernet/ti/am65-cpsw-nuss.c |  7 ++-----
 drivers/net/ethernet/ti/am65-cpts.c      | 15 +++++----------
 drivers/net/ethernet/ti/am65-cpts.h      |  5 +++++
 3 files changed, 12 insertions(+), 15 deletions(-)

-- 
2.25.1

