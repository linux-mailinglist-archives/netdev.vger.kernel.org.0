Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E8D4D5DA9
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 09:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbiCKIqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 03:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbiCKIqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 03:46:01 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78592184634;
        Fri, 11 Mar 2022 00:44:58 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KFKBF1zN9z1GCM9;
        Fri, 11 Mar 2022 16:40:05 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 11 Mar 2022 16:44:56 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 0/2] net: macvlan: fix potential UAF problem for lowerdev
Date:   Fri, 11 Mar 2022 17:02:41 +0800
Message-ID: <cover.1646989143.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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

Add the reference operation to lowerdev of macvlan to avoid
the potential UAF problem under the following known scenario:

Someone module puts the NETDEV_UNREGISTER event handler to a
work, and lowerdev is accessed in the work handler. But when
the work is excuted, lowerdev has been destroyed because upper
macvlan did not get reference to lowerdev correctly.

In addition, add net device refcount tracker to macvlan.

Ziyang Xuan (2):
  net: macvlan: fix potential UAF problem for lowerdev
  net: macvlan: add net device refcount tracker

 drivers/net/macvlan.c      | 14 +++++++++++++-
 include/linux/if_macvlan.h |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

-- 
2.25.1

