Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C836381E07
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730707AbfHENvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:51:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4176 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729625AbfHENvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 09:51:17 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 46D274C0241425031124;
        Mon,  5 Aug 2019 21:51:14 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Mon, 5 Aug 2019
 21:51:07 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <davem@davemloft.net>, <jiri@resnulli.us>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] bonding: Add vlan tx offload to hw_enc_features
Date:   Mon, 5 Aug 2019 21:49:53 +0800
Message-ID: <20190805134953.63596-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As commit 30d8177e8ac7 ("bonding: Always enable vlan tx offload")
said, we should always enable bonding's vlan tx offload, pass the
vlan packets to the slave devices with vlan tci, let them to handle
vlan implementation.

Now if encapsulation protocols like VXLAN is used, skb->encapsulation
may be set, then the packet is passed to vlan devicec which based on
bonding device. However in netif_skb_features(), the check of
hw_enc_features:

	 if (skb->encapsulation)
                 features &= dev->hw_enc_features;

clears NETIF_F_HW_VLAN_CTAG_TX/NETIF_F_HW_VLAN_STAG_TX. This results
in same issue in commit 30d8177e8ac7 like this:

vlan_dev_hard_start_xmit
  -->dev_queue_xmit
    -->validate_xmit_skb
      -->netif_skb_features //NETIF_F_HW_VLAN_CTAG_TX is cleared
      -->validate_xmit_vlan
        -->__vlan_hwaccel_push_inside //skb->tci is cleared
...
 --> bond_start_xmit
   --> bond_xmit_hash //BOND_XMIT_POLICY_ENCAP34
     --> __skb_flow_dissect // nhoff point to IP header
        -->  case htons(ETH_P_8021Q)
             // skb_vlan_tag_present is false, so
             vlan = __skb_header_pointer(skb, nhoff, sizeof(_vlan),
             //vlan point to ip header wrongly

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/bonding/bond_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 02fd782..931d9d9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1126,6 +1126,8 @@ static void bond_compute_features(struct bonding *bond)
 done:
 	bond_dev->vlan_features = vlan_features;
 	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
+				    NETIF_F_HW_VLAN_CTAG_TX |
+				    NETIF_F_HW_VLAN_STAG_TX |
 				    NETIF_F_GSO_UDP_L4;
 	bond_dev->mpls_features = mpls_features;
 	bond_dev->gso_max_segs = gso_max_segs;
-- 
2.7.4


