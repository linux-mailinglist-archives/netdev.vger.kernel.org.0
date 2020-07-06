Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB5F21565C
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 13:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbgGFL2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 07:28:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7377 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728945AbgGFL16 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 07:27:58 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6CC693185162430C08E1;
        Mon,  6 Jul 2020 19:27:55 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Mon, 6 Jul 2020 19:27:47 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 4/4] net: hns3: fix use-after-free when doing self test
Date:   Mon, 6 Jul 2020 19:26:02 +0800
Message-ID: <1594034762-6445-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594034762-6445-1-git-send-email-tanhuazhong@huawei.com>
References: <1594034762-6445-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

Enable promisc mode of PF, set VF link state to enable, and
run iperf of the VF, then do self test of the PF. The self test
will fail with a low frequency, and may cause a use-after-free
problem.

[   87.142126] selftest:000004a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   87.159722] ==================================================================
[   87.174187] BUG: KASAN: use-after-free in hex_dump_to_buffer+0x140/0x608
[   87.187600] Read of size 1 at addr ffff003b22828000 by task ethtool/1186
[   87.201012]
[   87.203978] CPU: 7 PID: 1186 Comm: ethtool Not tainted 5.5.0-rc4-gfd51c473-dirty #4
[   87.219306] Hardware name: Huawei TaiShan 2280 V2/BC82AMDA, BIOS TA BIOS 2280-A CS V2.B160.01 01/15/2020
[   87.238292] Call trace:
[   87.243173]  dump_backtrace+0x0/0x280
[   87.250491]  show_stack+0x24/0x30
[   87.257114]  dump_stack+0xe8/0x140
[   87.263911]  print_address_description.isra.8+0x70/0x380
[   87.274538]  __kasan_report+0x12c/0x230
[   87.282203]  kasan_report+0xc/0x18
[   87.288999]  __asan_load1+0x60/0x68
[   87.295969]  hex_dump_to_buffer+0x140/0x608
[   87.304332]  print_hex_dump+0x140/0x1e0
[   87.312000]  hns3_lb_check_skb_data+0x168/0x170
[   87.321060]  hns3_clean_rx_ring+0xa94/0xfe0
[   87.329422]  hns3_self_test+0x708/0x8c0

The length of packet sent by the selftest process is only
128 + 14 bytes, and the min buffer size of a BD is 256 bytes,
and the receive process will make sure the packet sent by
the selftest process is in the linear part, so only check
the linear part in hns3_lb_check_skb_data().

So fix this use-after-free by using skb_headlen() to dump
skb->data instead of skb->len.

Fixes: c39c4d98dc65 ("net: hns3: Add mac loopback selftest support in hns3 driver")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 6b1545f..2622e04 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -180,18 +180,21 @@ static void hns3_lb_check_skb_data(struct hns3_enet_ring *ring,
 {
 	struct hns3_enet_tqp_vector *tqp_vector = ring->tqp_vector;
 	unsigned char *packet = skb->data;
+	u32 len = skb_headlen(skb);
 	u32 i;
 
-	for (i = 0; i < skb->len; i++)
+	len = min_t(u32, len, HNS3_NIC_LB_TEST_PACKET_SIZE);
+
+	for (i = 0; i < len; i++)
 		if (packet[i] != (unsigned char)(i & 0xff))
 			break;
 
 	/* The packet is correctly received */
-	if (i == skb->len)
+	if (i == HNS3_NIC_LB_TEST_PACKET_SIZE)
 		tqp_vector->rx_group.total_packets++;
 	else
 		print_hex_dump(KERN_ERR, "selftest:", DUMP_PREFIX_OFFSET, 16, 1,
-			       skb->data, skb->len, true);
+			       skb->data, len, true);
 
 	dev_kfree_skb_any(skb);
 }
-- 
2.7.4

