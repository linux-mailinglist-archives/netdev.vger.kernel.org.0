Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5A96471B5
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiLHO0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiLHOZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:25:28 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C844C862F7;
        Thu,  8 Dec 2022 06:24:40 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NSbxG6Qwbz15Ms5;
        Thu,  8 Dec 2022 22:23:46 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 8 Dec
 2022 22:24:36 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <leon@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Michal Simek <michal.simek@xilinx.com>,
        John Linn <john.linn@xilinx.com>,
        Sadanand M <sadanan@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Ilya Yanok <yanok@emcraft.com>,
        Joerg Reuter <jreuter@yaina.de>, <linux-hams@vger.kernel.org>
Subject: [PATCH net v3 0/4] net: don't call dev_kfree_skb() under spin_lock_irqsave()
Date:   Thu, 8 Dec 2022 22:21:43 +0800
Message-ID: <20221208142147.2376671-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not allowed to call consume_skb() from hardware interrupt context
or with interrupts being disabled. This patchset replace dev_kfree_skb()
with dev_kfree_skb_irq/dev_consume_skb_irq() under spin_lock_irqsave()
in some drivers, or move dev_kfree_skb() after spin_unlock_irqrestore().

v2 -> v3:
  Update commit message, and change to use dev_kfree_skb_irq() in patch #1, #3.

v1 -> v2:
  patch #2 Move dev_kfree_skb() after spin_unlock_irqrestore()

Yang Yingliang (4):
  net: emaclite: don't call dev_kfree_skb() under spin_lock_irqsave()
  net: ethernet: dnet: don't call dev_kfree_skb() under
    spin_lock_irqsave()
  hamradio: don't call dev_kfree_skb() under spin_lock_irqsave()
  net: amd: lance: don't call dev_kfree_skb() under spin_lock_irqsave()

 drivers/net/ethernet/amd/atarilance.c         | 2 +-
 drivers/net/ethernet/amd/lance.c              | 2 +-
 drivers/net/ethernet/dnet.c                   | 4 ++--
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 2 +-
 drivers/net/hamradio/scc.c                    | 6 +++---
 5 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.25.1

