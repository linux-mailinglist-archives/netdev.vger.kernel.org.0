Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B2E56E4E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfFZQEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:04:32 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54374 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725958AbfFZQEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 12:04:31 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 64C8DDA4DBBAD2CF71A4;
        Thu, 27 Jun 2019 00:04:11 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Thu, 27 Jun 2019
 00:04:03 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <sdf@google.com>, <jianbol@mellanox.com>,
        <jiri@mellanox.com>, <mirq-linux@rere.qmqm.pl>,
        <willemb@google.com>, <sdf@fomichev.me>, <jiri@resnulli.us>,
        <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] team: Always enable vlan tx offload
Date:   Thu, 27 Jun 2019 00:03:39 +0800
Message-ID: <20190626160339.35152-1-yuehaibing@huawei.com>
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

We should rather have vlan_tci filled all the way down
to the transmitting netdevice and let it do the hw/sw
vlan implementation.

Suggested-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/team/team.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index b48006e7fa2f..a8bb25341bed 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2128,12 +2128,12 @@ static void team_setup(struct net_device *dev)
 	dev->features |= NETIF_F_NETNS_LOCAL;
 
 	dev->hw_features = TEAM_VLAN_FEATURES |
-			   NETIF_F_HW_VLAN_CTAG_TX |
 			   NETIF_F_HW_VLAN_CTAG_RX |
 			   NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
 	dev->features |= dev->hw_features;
+	dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
 }
 
 static int team_newlink(struct net *src_net, struct net_device *dev,
-- 
2.20.1


