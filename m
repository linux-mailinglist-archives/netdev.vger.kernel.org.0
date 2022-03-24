Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2504E6665
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351429AbiCXP45 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Mar 2022 11:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351432AbiCXP4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:48 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7FFAC93E
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:11 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KPVBN61n7zfZgC;
        Thu, 24 Mar 2022 23:53:32 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 23:55:07 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv5 PATCH net-next 00/20] net: extend the type of netdev_features_t to bitmap
Date:   Thu, 24 Mar 2022 23:49:12 +0800
Message-ID: <20220324154932.17557-1-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
introduces wrappers helpers to this. [patch 20]

There are a set of helpes named as "netdev_features_xxx", and I
want to add similar helpers for netdev features members, named as
netdev_XXX_features_xxx.(xxx: and/or/xor.., XXX: hw/vlan/mpls...)
To make the helpers name differentiable, rename netdev->features
to netdev->active_features. [patch 2]
For example:
	#define netdev_active_features_set_bit(ndev, nr) \
			netdev_features_set_bit(nr, &ndev->active_features)

To avoid mistake using NETIF_F_XXX as NETIF_F_XXX_BIT as
input macroes for above helpers, remove all the macroes
of NETIF_F_XXX. [patch 20]

The features group macroes in netdev_features.h are replaced
by a set of const features defined in netdev_features.c. [patch 3-4]
For example:
macro NETIF_F_ALL_TSO is replaced by netdev_all_tso_features

There are some drivers(e.g. sfc) use netdev_features in global
structure initialization. Changed the its netdev_features_t memeber
to netdev_features_t *, and make it prefer to a netdev_features_t
global variables. [patch 5]

As suggestion from Andrew Lunn, I wrote some semantic patches to do the
work(replacing the netdev features operator by helpers). [patch 8-19]
To make the semantic patches simple, I split the complex opreation of
netdev_features to simple logical operation. [patch 6, 7]

With the prototype is no longer u64, the implementation of print interface
for netdev features(%pNF) is changed to bitmap. [patch 20]

The whole work is not complete yet. I just use these changes
on several files(hns3 driver, sfc drivers, net/ethtool, net/core/dev.c),
in order to show how these helpers will be used. I want to get more
suggestions for this scheme, any comments would be appreciated.

The former discussion please see [1][2][3].

[1]:https://www.spinics.net/lists/netdev/msg769952.html
[2]:https://www.spinics.net/lists/netdev/msg777764.html
[3]:https://lore.kernel.org/netdev/20211107101519.29264-1-shenjian15@huawei.com/T/

ChangeLog:
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

Jian Shen (20):
  net: rename net_device->features to net_device->active_features
  net: introduce operation helpers for netdev features
  net: replace general features macroes with global netdev_features
    variables
  net: replace multiple feature bits with netdev features array
  net: sfc: replace const features initialization with netdev features
    array
  net: simplify the netdev features expression
  net: adjust variables definition for netdev_features_t
  net: use netdev_features_set_bit helpers
  net: use netdev_features_or helpers
  net: use netdev_features_xor helpers
  net: use netdev_features_clear_bit helpers
  net: use netdev_features_andnot helpers
  net: use netdev_features_test_bit helpers
  net: use netdev_features_intersects helpers
  net: use netdev_features_and helpers
  net: use netdev_features_subset helpers
  net: use netdev_features_equal helpers
  net: use netdev_set_xxx_features helpers
  net: use netdev_xxx_features helpers
  net: redefine the prototype of netdev_features_t

 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 116 ++-
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |   4 +-
 drivers/net/ethernet/sfc/ef10.c               |  43 +-
 drivers/net/ethernet/sfc/ef100_nic.c          |  57 +-
 drivers/net/ethernet/sfc/ef100_rx.c           |   4 +-
 drivers/net/ethernet/sfc/ef100_tx.c           |   8 +-
 drivers/net/ethernet/sfc/ef10_sriov.c         |   6 +-
 drivers/net/ethernet/sfc/efx.c                |  96 ++-
 drivers/net/ethernet/sfc/efx_common.c         |  32 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |  75 +-
 drivers/net/ethernet/sfc/falcon/efx.h         |   3 +
 drivers/net/ethernet/sfc/falcon/falcon.c      |   4 +-
 drivers/net/ethernet/sfc/falcon/net_driver.h  |   4 +-
 drivers/net/ethernet/sfc/falcon/rx.c          |   4 +-
 drivers/net/ethernet/sfc/farch.c              |   2 +-
 drivers/net/ethernet/sfc/mcdi_filters.c       |  13 +-
 drivers/net/ethernet/sfc/mcdi_port_common.c   |   2 +-
 drivers/net/ethernet/sfc/net_driver.h         |   4 +-
 drivers/net/ethernet/sfc/rx.c                 |   2 +-
 drivers/net/ethernet/sfc/rx_common.c          |   5 +-
 drivers/net/ethernet/sfc/rx_common.h          |   4 +
 drivers/net/ethernet/sfc/siena.c              |   3 +-
 include/linux/netdev_features.h               | 189 ++---
 include/linux/netdevice.h                     | 722 +++++++++++++++++-
 lib/vsprintf.c                                |  11 +-
 net/core/dev.c                                | 419 ++++++----
 net/core/netdev_features.c                    | 276 +++++++
 net/ethtool/features.c                        |  77 +-
 net/ethtool/ioctl.c                           | 140 ++--
 29 files changed, 1797 insertions(+), 528 deletions(-)
 create mode 100644 net/core/netdev_features.c

-- 
2.33.0

