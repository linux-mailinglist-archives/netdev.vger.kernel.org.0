Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05E04E8040
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 10:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiCZJ6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 05:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiCZJ6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 05:58:15 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED6D205F0;
        Sat, 26 Mar 2022 02:56:38 -0700 (PDT)
Received: from kwepemi500005.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KQZ7n1l27zfZsP;
        Sat, 26 Mar 2022 17:55:01 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500005.china.huawei.com (7.221.188.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 17:56:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 17:56:36 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 6/6] net: hns3: fix phy can not link up when autoneg off and reset
Date:   Sat, 26 Mar 2022 17:51:05 +0800
Message-ID: <20220326095105.54075-7-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220326095105.54075-1-huangguangbin2@huawei.com>
References: <20220326095105.54075-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, function hclge_mdio_read() will return 0 if during reset(the
cmd state will be set to disable).

If use general phy driver, the phy_state_machine() will update phy speed
every second in function genphy_read_status_fixed() when PHY is set to
autoneg off, no matter of link down or link up.

If phy driver happens to read BMCR register during reset, phy speed will
be updated to 10Mpbs as BMCR register value is 0. So it may call phy can
not link up if previous speed is not 10Mpbs.

To fix this problem, function hclge_mdio_read() should return -EBUSY if
the cmd state is disable. So does function hclge_mdio_write().

Fixes: 1c1249380992 ("net: hns3: bugfix for hclge_mdio_write and hclge_mdio_read")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index 63d2be4349e3..03d63b6a9b2b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -48,7 +48,7 @@ static int hclge_mdio_write(struct mii_bus *bus, int phyid, int regnum,
 	int ret;
 
 	if (test_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state))
-		return 0;
+		return -EBUSY;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_MDIO_CONFIG, false);
 
@@ -86,7 +86,7 @@ static int hclge_mdio_read(struct mii_bus *bus, int phyid, int regnum)
 	int ret;
 
 	if (test_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state))
-		return 0;
+		return -EBUSY;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_MDIO_CONFIG, true);
 
-- 
2.33.0

