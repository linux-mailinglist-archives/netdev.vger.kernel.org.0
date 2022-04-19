Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18921506216
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 04:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236654AbiDSCah convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 18 Apr 2022 22:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233778AbiDSCag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 22:30:36 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF3D2C12C
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 19:27:55 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kj71v6WfkzFpgs;
        Tue, 19 Apr 2022 10:25:23 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 10:27:53 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv6 PATCH net-next 00/19] net: extend the type of netdev_features_t to bitmap
Date:   Tue, 19 Apr 2022 10:21:47 +0800
Message-ID: <20220419022206.36381-1-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the prototype of netdev_features_t is u64, and the number
of netdevice feature bits is 64 now. So there is no space to
introduce new feature bit.

This patchset try to solve it by change the prototype of
netdev_features_t from u64 to structure below:
	typedef struct {
		DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
	} netdev_features_t;

With this change, it's necessary to introduce a set of bitmap
operation helpers for netdev features. As the nic drivers are
not supposed to modify netdev_features directly, it also
introduces wrappers helpers to this. [patch 1]

To avoid mistake using NETIF_F_XXX as NETIF_F_XXX_BIT as
input macroes for above helpers, remove all the macroes
of NETIF_F_XXX. [patch 19]

The features group macroes in netdev_features.h are replaced
by a set of const features defined in netdev_features.c. [patch 2-3]
For example:
macro NETIF_F_ALL_TSO is replaced by netdev_all_tso_features

There are some drivers(e.g. sfc) use netdev_features in global
structure initialization. Changed the its netdev_features_t memeber
to netdev_features_t *, and make it prefer to a netdev_features_t
global variables. [patch 4]

As suggestion from Andrew Lunn, I wrote some semantic patches to do the
work(replacing the netdev features operator by helpers). [patch 7-18]
To make the semantic patches simple, I split the complex opreation of
netdev_features to simple logical operation. [patch 5, 6]

With the prototype is no longer u64, the implementation of print interface
for netdev features(%pNF) is changed to bitmap. [patch 19]

The whole work is not complete yet. I just use these changes
on several files(hns3 driver, sfc drivers, net/ethtool, net/core/dev.c),
in order to show how these helpers will be used. I will apply these helpers
to the whole tree later, sofar I want to get more suggestions for this
scheme, any comments would be appreciated.

The former discussion please see [1][2][3][4].

[1]:https://www.spinics.net/lists/netdev/msg769952.html
[2]:https://www.spinics.net/lists/netdev/msg777764.html
[3]:https://lore.kernel.org/netdev/20211107101519.29264-1-shenjian15@huawei.com/T/
[4]:https://www.spinics.net/lists/netdev/msg809293.html


ChangeLog:
V5-V6: suggestions from Jakub Kicinski:
drop the rename for netdev->features
simplify names of some helpers, and move them to a new header file
refine the implement for netdev_features_set_array
V4->V5:
adjust the patch structure, use semantic patch with coccinelle
V3->V4:
rename netdev->features to netdev->active_features
remove helpes for handle first 64 bits
remove __NETIF_F(name) macroes
replace features group macroes with const features
V2->V3:
use structure for bitmap, suggest by Edward Cree
V1->V2:
Extend the prototype from u64 to bitmap, suggest by Andrew Lunn

Jian Shen (19):
  net: introduce operation helpers for netdev features
  net: replace general features macroes with global netdev_features
    variables
  net: replace multiple feature bits with netdev features array
  net: sfc: replace const features initialization with netdev features
    array
  net: simplify the netdev features expression
  net: adjust variables definition for netdev_features_t
  net: use netdev_feature_add helpers
  net: use netdev_features_or helpers
  net: use netdev_features_xor helpers
  net: use netdev_feature_del helpers
  net: use netdev_features_andnot helpers
  net: use netdev_feature_test helpers
  net: use netdev_features_intersects helpers
  net: use netdev_features_and helpers
  net: use netdev_features_subset helpers
  net: use netdev_features_equal helpers
  net: use netdev_features_copy helpers
  net: use netdev_xxx_features helpers
  net: redefine the prototype of netdev_features_t

 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 108 ++-
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |   4 +-
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |   1 +
 drivers/net/ethernet/sfc/ef10.c               |  38 +-
 drivers/net/ethernet/sfc/ef100_nic.c          |  48 +-
 drivers/net/ethernet/sfc/ef100_rx.c           |   4 +-
 drivers/net/ethernet/sfc/ef100_tx.c           |   8 +-
 drivers/net/ethernet/sfc/ef10_sriov.c         |   6 +-
 drivers/net/ethernet/sfc/efx.c                |  82 ++-
 drivers/net/ethernet/sfc/efx_common.c         |  31 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |  67 +-
 drivers/net/ethernet/sfc/falcon/efx.h         |   3 +
 drivers/net/ethernet/sfc/falcon/falcon.c      |   4 +-
 drivers/net/ethernet/sfc/falcon/net_driver.h  |   5 +-
 drivers/net/ethernet/sfc/falcon/rx.c          |   4 +-
 drivers/net/ethernet/sfc/farch.c              |   2 +-
 drivers/net/ethernet/sfc/mcdi_filters.c       |  13 +-
 drivers/net/ethernet/sfc/mcdi_port_common.c   |   2 +-
 drivers/net/ethernet/sfc/net_driver.h         |   5 +-
 drivers/net/ethernet/sfc/rx.c                 |   2 +-
 drivers/net/ethernet/sfc/rx_common.c          |   4 +-
 drivers/net/ethernet/sfc/rx_common.h          |   4 +
 drivers/net/ethernet/sfc/siena.c              |   3 +-
 drivers/net/wireguard/device.c                |  10 +-
 include/linux/netdev_features.h               | 193 ++----
 include/linux/netdev_features_helper.h        | 653 ++++++++++++++++++
 include/linux/netdevice.h                     | 109 +--
 lib/vsprintf.c                                |  11 +-
 net/8021q/vlan_dev.c                          |   1 +
 net/core/Makefile                             |   2 +-
 net/core/dev.c                                | 389 +++++++----
 net/core/netdev_features.c                    | 241 +++++++
 net/ethtool/features.c                        |  90 +--
 net/ethtool/ioctl.c                           | 135 ++--
 34 files changed, 1723 insertions(+), 559 deletions(-)
 create mode 100644 include/linux/netdev_features_helper.h
 create mode 100644 net/core/netdev_features.c

-- 
2.33.0

