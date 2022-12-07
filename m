Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A890645B7F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiLGNzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiLGNzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:55:33 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E065B874
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 05:55:31 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NRzL55ftWzRpqT;
        Wed,  7 Dec 2022 21:54:37 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 7 Dec
 2022 21:55:28 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH net v2 0/4] net: don't call dev_kfree_skb() under spin_lock_irqsave()
Date:   Wed, 7 Dec 2022 21:52:54 +0800
Message-ID: <20221207135258.34193-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
with dev_consume_skb_irq() under spin_lock_irqsave() in some drivers, or
move dev_kfree_skb() after spin_unlock_irqrestore().

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

