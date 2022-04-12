Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185BD4FCC2A
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 04:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbiDLCJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 22:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239653AbiDLCJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 22:09:20 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3451A338BC;
        Mon, 11 Apr 2022 19:07:04 -0700 (PDT)
Received: from kwepemi500010.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kcpvr4WfzzgYcs;
        Tue, 12 Apr 2022 10:05:12 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500010.china.huawei.com (7.221.188.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Apr 2022 10:07:01 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Apr 2022 10:07:00 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>, <wangjie125@huawei.com>
Subject: [PATCH net-next v2 0/3] net: ethool: add support to get/set tx push by ethtool -G/g
Date:   Tue, 12 Apr 2022 10:01:18 +0800
Message-ID: <20220412020121.14140-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

These three patches add tx push in ring params and adapt the set and get APIs
of ring params.

ChangeLog:

V1->V2
1.Add a mention in tx push description
2.Delete the redundant value check in ethnl_set_rings
3.Fix the Kdoc warning
link: https://lore.kernel.org/netdev/20220408071245.40554-1-huangguangbin2@huawei.com/

RFC V4->V1
1.Add detailed description about the tx push mode
2.Modify the patch subject title
link: https://lore.kernel.org/netdev/20220331084342.27043-1-wangjie125@huawei.com/

RFC V3->RFC V4
1.Put three request checks before rtnl_lock() in ethnl_set_rings
2.Add tx push feature description in Documentation/networking/ethtool-netlink.rst
3.Use netdev_dbg to track changes in hns3_set_tx_push
link: https://lore.kernel.org/netdev/20220329091913.17869-1-wangjie125@huawei.com/

RFC V2->RFC V3
1.Add tx push documentation in Documentation/networking/ethtool-netlink.rst
2.Use u8 to store tx push in struct kernel_ethtool_ringparam
3.Add ETHTOOL_RING_USE_TX_PUSH to reject setting for unsupported driver
4.Use NLA_POLICY_MAX(NLA_U8, 1) to limit the tx push value
link: https://lore.kernel.org/netdev/20220326085102.14111-1-wangjie125@huawei.com/

RFC V1->RFC V2
1.Extend tx push param in ringparam, suggested by Jakub Kicinski.
link: https://lore.kernel.org/netdev/20220315032108.57228-1-wangjie125@huawei.com/

Jie Wang (3):
  net: ethtool: extend ringparam set/get APIs for tx_push
  net: ethtool: move checks before rtnl_lock() in ethnl_set_rings
  net: hns3: add tx push support in hns3 ring param process

 Documentation/networking/ethtool-netlink.rst  |  9 ++++
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 33 +++++++++++-
 include/linux/ethtool.h                       |  4 ++
 include/uapi/linux/ethtool_netlink.h          |  1 +
 net/ethtool/netlink.h                         |  2 +-
 net/ethtool/rings.c                           | 54 ++++++++++++-------
 6 files changed, 81 insertions(+), 22 deletions(-)

-- 
2.33.0

