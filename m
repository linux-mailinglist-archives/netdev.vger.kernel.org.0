Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E192C612A
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 09:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgK0Irt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 03:47:49 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7746 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728731AbgK0Irr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 03:47:47 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cj7Xw3qSwzkhCS;
        Fri, 27 Nov 2020 16:47:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Fri, 27 Nov 2020 16:47:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 6/7] net: hns3: add a check for devcie's verion in hns3_tunnel_csum_bug()
Date:   Fri, 27 Nov 2020 16:47:21 +0800
Message-ID: <1606466842-57749-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606466842-57749-1-git-send-email-tanhuazhong@huawei.com>
References: <1606466842-57749-1-git-send-email-tanhuazhong@huawei.com>
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
index 07bdb3d5..b51bf61 100644
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

