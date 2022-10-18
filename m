Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67E66029DA
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 13:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJRLHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 07:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJRLHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 07:07:12 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6255B5FE1;
        Tue, 18 Oct 2022 04:07:10 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666091228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6slPvh5nOW6GsvuvgTCwVYEyF+ng4Q8ONP9U1HohB8c=;
        b=OPZdMR6nWQO0VN0S1yTX9Y8wQJQWqV6VDVtC8AKu0q43UMtoL+OgoHL0uJsqLtnvkjWa41
        XCZ5CmZhJ391mi4RZARA5RwlIqngx3qvO1HvK77oEsa67zXMYOBgADH9TXwuYoO3K+FR96
        wfqf2gJHQiChm6TzCbIH+1bHWCaUsqQ=
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     kuba@kernel.org
Cc:     Cai Huoqing <cai.huoqing@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Qiao Ma <mqaio@linux.alibaba.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] net: hinic: Set max_mtu/min_mtu directly to simplify the code.
Date:   Tue, 18 Oct 2022 19:06:52 +0800
Message-Id: <20221018110701.3958-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set max_mtu/min_mtu directly to avoid making the validity judgment
when set mtu, because the judgment is made in net/core: dev_validate_mtu,
so to simplify the code.

Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
---
v1->v2:
	1.Update changelog.
	2.Reverse MAX_MTU to max jumbo frame size.

v2->v3:
	1.Update signature

	v1 link: https://lore.kernel.org/lkml/20221012082945.10353-1-cai.huoqing@linux.dev/
        v2 link: https://lore.kernel.org/lkml/20220429033733.GA15753@chq-T47/


 drivers/net/ethernet/huawei/hinic/hinic_dev.h  |  4 ++++
 drivers/net/ethernet/huawei/hinic/hinic_main.c |  3 ++-
 drivers/net/ethernet/huawei/hinic/hinic_port.c | 17 +----------------
 3 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index a4fbf44f944c..2bbc94c0a9c1 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -22,6 +22,10 @@
 
 #define LP_PKT_CNT		64
 
+#define HINIC_MAX_JUMBO_FRAME_SIZE 	15872
+#define HINIC_MAX_MTU_SIZE 	(HINIC_MAX_JUMBO_FRAME_SIZE - ETH_HLEN - ETH_FCS_LEN)
+#define HINIC_MIN_MTU_SIZE 	256
+
 enum hinic_flags {
 	HINIC_LINK_UP = BIT(0),
 	HINIC_INTF_UP = BIT(1),
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index c23ee2ddbce3..41e52f775aae 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1189,7 +1189,8 @@ static int nic_dev_init(struct pci_dev *pdev)
 	else
 		netdev->netdev_ops = &hinicvf_netdev_ops;
 
-	netdev->max_mtu = ETH_MAX_MTU;
+	netdev->max_mtu = HINIC_MAX_MTU_SIZE;
+	netdev->min_mtu = HINIC_MIN_MTU_SIZE;
 
 	nic_dev = netdev_priv(netdev);
 	nic_dev->netdev = netdev;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 28ae6f1201a8..0a39c3dffa9a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -17,9 +17,6 @@
 #include "hinic_port.h"
 #include "hinic_dev.h"
 
-#define HINIC_MIN_MTU_SIZE              256
-#define HINIC_MAX_JUMBO_FRAME_SIZE      15872
-
 enum mac_op {
 	MAC_DEL,
 	MAC_SET,
@@ -147,24 +144,12 @@ int hinic_port_get_mac(struct hinic_dev *nic_dev, u8 *addr)
  **/
 int hinic_port_set_mtu(struct hinic_dev *nic_dev, int new_mtu)
 {
-	struct net_device *netdev = nic_dev->netdev;
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_port_mtu_cmd port_mtu_cmd;
 	struct hinic_hwif *hwif = hwdev->hwif;
 	u16 out_size = sizeof(port_mtu_cmd);
 	struct pci_dev *pdev = hwif->pdev;
-	int err, max_frame;
-
-	if (new_mtu < HINIC_MIN_MTU_SIZE) {
-		netif_err(nic_dev, drv, netdev, "mtu < MIN MTU size");
-		return -EINVAL;
-	}
-
-	max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN;
-	if (max_frame > HINIC_MAX_JUMBO_FRAME_SIZE) {
-		netif_err(nic_dev, drv, netdev, "mtu > MAX MTU size");
-		return -EINVAL;
-	}
+	int err;
 
 	port_mtu_cmd.func_idx = HINIC_HWIF_FUNC_IDX(hwif);
 	port_mtu_cmd.mtu = new_mtu;
-- 
2.25.1

