Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A1E6454AD
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 08:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiLGHgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 02:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiLGHfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 02:35:46 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622562FC3C
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 23:35:43 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NRprp4t8ZzJp3K;
        Wed,  7 Dec 2022 15:32:10 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 7 Dec
 2022 15:35:07 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH net 0/4] net: don't call dev_kfree_skb() under spin_lock_irqsave()
Date:   Wed, 7 Dec 2022 15:32:11 +0800
Message-ID: <20221207073215.3545460-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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
with dev_consume_skb_irq() under spin_lock_irqsave() in some drivers.

Yang Yingliang (4):
  net: emaclite: don't call dev_kfree_skb() under spin_lock_irqsave()
  net: ethernet: dnet: don't call dev_kfree_skb() under
    spin_lock_irqsave()
  hamradio: don't call dev_kfree_skb() under spin_lock_irqsave()
  net: amd: lance: don't call dev_kfree_skb() under spin_lock_irqsave()

 drivers/net/ethernet/amd/atarilance.c         | 2 +-
 drivers/net/ethernet/amd/lance.c              | 2 +-
 drivers/net/ethernet/dnet.c                   | 2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 2 +-
 drivers/net/hamradio/scc.c                    | 6 +++---
 5 files changed, 7 insertions(+), 7 deletions(-)

-- 
2.25.1

