Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB42056D4B
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbfFZPHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:07:00 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:19081 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727562AbfFZPHA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 11:07:00 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E6D418317CE54D8D4702;
        Wed, 26 Jun 2019 23:06:52 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Wed, 26 Jun 2019
 23:06:45 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <sdf@google.com>, <jianbol@mellanox.com>,
        <jiri@mellanox.com>, <mirq-linux@rere.qmqm.pl>,
        <willemb@google.com>, <sdf@fomichev.me>, <jiri@resnulli.us>,
        <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] bonding: Always enable vlan tx offload
Date:   Wed, 26 Jun 2019 16:08:44 +0800
Message-ID: <20190626080844.20796-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20190624135007.GA17673@nanopsycho>
References: <20190624135007.GA17673@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We build vlan on top of bonding interface, which vlan offload
is off, bond mode is 802.3ad (LACP) and xmit_hash_policy is
BOND_XMIT_POLICY_ENCAP34.

Because vlan tx offload is off, vlan tci is cleared and skb push
the vlan header in validate_xmit_vlan() while sending from vlan
devices. Then in bond_xmit_hash, __skb_flow_dissect() fails to
get information from protocol headers encapsulated within vlan,
because 'nhoff' is points to IP header, so bond hashing is based
on layer 2 info, which fails to distribute packets across slaves.

This patch always enable bonding's vlan tx offload, pass the vlan
packets to the slave devices with vlan tci, let them to handle
vlan implementation.

Fixes: 278339a42a1b ("bonding: propogate vlan_features to bonding master")
Suggested-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 407f4095a37a..799fc38c5c34 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4320,12 +4320,12 @@ void bond_setup(struct net_device *bond_dev)
 	bond_dev->features |= NETIF_F_NETNS_LOCAL;
 
 	bond_dev->hw_features = BOND_VLAN_FEATURES |
-				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
 	bond_dev->features |= bond_dev->hw_features;
+	bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
 }
 
 /* Destroy a bonding device.
-- 
2.20.1


