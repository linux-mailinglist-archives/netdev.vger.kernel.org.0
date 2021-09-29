Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4C141C1BF
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245151AbhI2Jl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:41:57 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13391 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245083AbhI2Jlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 05:41:51 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKB7P3Zkyz901J;
        Wed, 29 Sep 2021 17:35:29 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:07 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:07 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 1/8] net: hns3: do not allow call hns3_nic_net_open repeatedly
Date:   Wed, 29 Sep 2021 17:35:49 +0800
Message-ID: <20210929093556.9146-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929093556.9146-1-huangguangbin2@huawei.com>
References: <20210929093556.9146-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

hns3_nic_net_open() is not allowed to called repeatly, but there
is no checking for this. When doing device reset and setup tc
concurrently, there is a small oppotunity to call hns3_nic_net_open
repeatedly, and cause kernel bug by calling napi_enable twice.

The calltrace information is like below:
[ 3078.222780] ------------[ cut here ]------------
[ 3078.230255] kernel BUG at net/core/dev.c:6991!
[ 3078.236224] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[ 3078.243431] Modules linked in: hns3 hclgevf hclge hnae3 vfio_iommu_type1 vfio_pci vfio_virqfd vfio pv680_mii(O)
[ 3078.258880] CPU: 0 PID: 295 Comm: kworker/u8:5 Tainted: G           O      5.14.0-rc4+ #1
[ 3078.269102] Hardware name:  , BIOS KpxxxFPGA 1P B600 V181 08/12/2021
[ 3078.276801] Workqueue: hclge hclge_service_task [hclge]
[ 3078.288774] pstate: 60400009 (nZCv daif +PAN -UAO -TCO BTYPE=--)
[ 3078.296168] pc : napi_enable+0x80/0x84
tc qdisc sho[w  3d0e7v8 .e3t0h218 79] lr : hns3_nic_net_open+0x138/0x510 [hns3]

[ 3078.314771] sp : ffff8000108abb20
[ 3078.319099] x29: ffff8000108abb20 x28: 0000000000000000 x27: ffff0820a8490300
[ 3078.329121] x26: 0000000000000001 x25: ffff08209cfc6200 x24: 0000000000000000
[ 3078.339044] x23: ffff0820a8490300 x22: ffff08209cd76000 x21: ffff0820abfe3880
[ 3078.349018] x20: 0000000000000000 x19: ffff08209cd76900 x18: 0000000000000000
[ 3078.358620] x17: 0000000000000000 x16: ffffc816e1727a50 x15: 0000ffff8f4ff930
[ 3078.368895] x14: 0000000000000000 x13: 0000000000000000 x12: 0000259e9dbeb6b4
[ 3078.377987] x11: 0096a8f7e764eb40 x10: 634615ad28d3eab5 x9 : ffffc816ad8885b8
[ 3078.387091] x8 : ffff08209cfc6fb8 x7 : ffff0820ac0da058 x6 : ffff0820a8490344
[ 3078.396356] x5 : 0000000000000140 x4 : 0000000000000003 x3 : ffff08209cd76938
[ 3078.405365] x2 : 0000000000000000 x1 : 0000000000000010 x0 : ffff0820abfe38a0
[ 3078.414657] Call trace:
[ 3078.418517]  napi_enable+0x80/0x84
[ 3078.424626]  hns3_reset_notify_up_enet+0x78/0xd0 [hns3]
[ 3078.433469]  hns3_reset_notify+0x64/0x80 [hns3]
[ 3078.441430]  hclge_notify_client+0x68/0xb0 [hclge]
[ 3078.450511]  hclge_reset_rebuild+0x524/0x884 [hclge]
[ 3078.458879]  hclge_reset_service_task+0x3c4/0x680 [hclge]
[ 3078.467470]  hclge_service_task+0xb0/0xb54 [hclge]
[ 3078.475675]  process_one_work+0x1dc/0x48c
[ 3078.481888]  worker_thread+0x15c/0x464
[ 3078.487104]  kthread+0x160/0x170
[ 3078.492479]  ret_from_fork+0x10/0x18
[ 3078.498785] Code: c8027c81 35ffffa2 d50323bf d65f03c0 (d4210000)
[ 3078.506889] ---[ end trace 8ebe0340a1b0fb44 ]---

Once hns3_nic_net_open() is excute success, the flag
HNS3_NIC_STATE_DOWN will be cleared. So add checking for this
flag, directly return when HNS3_NIC_STATE_DOWN is no set.

Fixes: e888402789b9 ("net: hns3: call hns3_nic_net_open() while doing HNAE3_UP_CLIENT")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index adc54a726661..5637c075a894 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -779,6 +779,11 @@ static int hns3_nic_net_open(struct net_device *netdev)
 	if (hns3_nic_resetting(netdev))
 		return -EBUSY;
 
+	if (!test_bit(HNS3_NIC_STATE_DOWN, &priv->state)) {
+		netdev_warn(netdev, "net open repeatedly!\n");
+		return 0;
+	}
+
 	netif_carrier_off(netdev);
 
 	ret = hns3_nic_set_real_num_queue(netdev);
-- 
2.33.0

