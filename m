Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283464DE746
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 10:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242587AbiCSJfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 05:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbiCSJfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 05:35:41 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31ED270861;
        Sat, 19 Mar 2022 02:34:20 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KLFzN3GGqzfYmp;
        Sat, 19 Mar 2022 17:32:48 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 19 Mar 2022 17:34:18 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <edumazet@google.com>, <brianvv@google.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 0/3] net: ipvlan: fix potential UAF problem for phy_dev
Date:   Sat, 19 Mar 2022 17:52:00 +0800
Message-ID: <cover.1647664114.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a known scenario can trigger UAF problem for lower
netdevice as following:

Someone module puts the NETDEV_UNREGISTER event handler to a
work, and lower netdevice is accessed in the work handler. But
when the work is excuted, lower netdevice has been destroyed
because upper netdevice did not get reference to lower netdevice
correctly.

Although it can not happen for ipvlan now because there is no
way to access phy_dev outside ipvlan. But it is necessary to
add the reference operation to phy_dev to avoid the potential
UAF problem in the future.

In addition, add net device refcount tracker to ipvlan and
fix some error comments for ipvtap module.

---
v2->v3:
  - Make it clear that the problem can not happen now but for future.
  - Delete "Fixes: tag" to avoid backporting to stable.
v1->v2:
  - Add "Fixes: tag" for fix patches.

Ziyang Xuan (3):
  net: ipvlan: fix potential UAF problem for phy_dev
  net: ipvlan: add net device refcount tracker
  net: ipvtap: fix error comments

 drivers/net/ipvlan/ipvlan.h      |  1 +
 drivers/net/ipvlan/ipvlan_main.c | 13 +++++++++++++
 drivers/net/ipvlan/ipvtap.c      |  4 ++--
 3 files changed, 16 insertions(+), 2 deletions(-)

-- 
2.25.1

