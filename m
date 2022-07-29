Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23789584EB3
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 12:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbiG2KZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 06:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235742AbiG2KZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 06:25:24 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA5B1ADAC;
        Fri, 29 Jul 2022 03:25:16 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LvNqz0VZ4zlWQ6;
        Fri, 29 Jul 2022 18:22:39 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Jul 2022 18:24:51 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Jul 2022 18:24:50 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <snelson@pensando.io>, <brett@pensando.io>,
        <drivers@pensando.io>, <anthony.l.nguyen@intel.com>,
        <jesse.brandeburg@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net 1/2] net: ice: fix error NETIF_F_HW_VLAN_CTAG_FILTER check in ice_vsi_sync_fltr()
Date:   Fri, 29 Jul 2022 18:17:54 +0800
Message-ID: <20220729101755.4798-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220729101755.4798-1-huangguangbin2@huawei.com>
References: <20220729101755.4798-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

vsi->current_netdev_flags is used store the current net device
flags, not the active netdevice features. So it should use
vsi->netdev->featurs, rather than vsi->current_netdev_flags
to check NETIF_F_HW_VLAN_CTAG_FILTER.

Fixes: 1babaf77f49d ("ice: Advertise 802.1ad VLAN filtering and offloads for PF netdev")

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9f02b60459f1..bc68dc5c6927 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -433,7 +433,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 						IFF_PROMISC;
 					goto out_promisc;
 				}
-				if (vsi->current_netdev_flags &
+				if (vsi->netdev->features &
 				    NETIF_F_HW_VLAN_CTAG_FILTER)
 					vlan_ops->ena_rx_filtering(vsi);
 			}
-- 
2.33.0

