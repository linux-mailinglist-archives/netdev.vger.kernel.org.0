Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFA32C702E
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 18:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731981AbgK1EPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 23:15:34 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8456 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731751AbgK1ENi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 23:13:38 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CjcxS3jzdzhhdR;
        Sat, 28 Nov 2020 11:51:40 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Sat, 28 Nov 2020 11:51:49 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 6/7] net: hns3: add a check for devcie's verion in hns3_tunnel_csum_bug()
Date:   Sat, 28 Nov 2020 11:51:49 +0800
Message-ID: <1606535510-44346-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606535510-44346-1-git-send-email-tanhuazhong@huawei.com>
References: <1606535510-44346-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the device whose version is above V3(include V3), the hardware
can do checksum offload for the non-tunnel udp packet, who has
a dest port as the IANA assigned. So add a check for devcie's verion
in hns3_tunnel_csum_bug().

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 3ad7f98..1798c0a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -828,8 +828,16 @@ static int hns3_get_l4_protocol(struct sk_buff *skb, u8 *ol4_proto,
  */
 static bool hns3_tunnel_csum_bug(struct sk_buff *skb)
 {
+	struct hns3_nic_priv *priv = netdev_priv(skb->dev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(priv->ae_handle->pdev);
 	union l4_hdr_info l4;
 
+	/* device version above V3(include V3), the hardware can
+	 * do this checksum offload.
+	 */
+	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
+		return false;
+
 	l4.hdr = skb_transport_header(skb);
 
 	if (!(!skb->encapsulation &&
-- 
2.7.4

