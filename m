Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983A94D8039
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 11:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238688AbiCNKzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 06:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiCNKzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 06:55:02 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0B4DEF0;
        Mon, 14 Mar 2022 03:53:52 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KHCyt70lBzBs03;
        Mon, 14 Mar 2022 18:51:50 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Mar 2022 18:53:50 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <edumazet@google.com>, <sakiwit@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 0/3] net: ipvlan: fix potential UAF problem for phy_dev
Date:   Mon, 14 Mar 2022 19:11:34 +0800
Message-ID: <cover.1647255926.git.william.xuanziyang@huawei.com>
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

Add the reference operation to phy_dev of ipvlan to avoid
the potential UAF problem under the following known scenario:

Someone module puts the NETDEV_UNREGISTER event handler to a
work, and phy_dev is accessed in the work handler. But when
the work is excuted, phy_dev has been destroyed because upper
ipvlan did not get reference to phy_dev correctly.

In addition, add net device refcount tracker to ipvlan and
fix some error comments for ipvtap module.

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

