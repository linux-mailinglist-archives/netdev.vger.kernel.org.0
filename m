Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC16649A42
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 09:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiLLIoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 03:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiLLIoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 03:44:15 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF04E003
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 00:44:13 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NVw7R74tMzJpKD;
        Mon, 12 Dec 2022 16:40:35 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 12 Dec
 2022 16:44:11 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <isdn@linux-pingi.de>, <davem@davemloft.net>, <kuba@kernel.org>,
        <jiri@resnulli.us>, Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH net v2 0/3] mISDN: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
Date:   Mon, 12 Dec 2022 16:41:36 +0800
Message-ID: <20221212084139.3277913-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled. This
pachset try to avoid calling dev_kfree_skb/kfree_skb()() under
spin_lock_irqsave().

v1 -> v2:
  Use skb_queue_splice_init() to move the 'squeue' to a free queue, then purge it.

Yang Yingliang (3):
  mISDN: hfcsusb: don't call dev_kfree_skb/kfree_skb() under
    spin_lock_irqsave()
  mISDN: hfcpci: don't call dev_kfree_skb/kfree_skb() under
    spin_lock_irqsave()
  mISDN: hfcmulti: don't call dev_kfree_skb/kfree_skb() under
    spin_lock_irqsave()

 drivers/isdn/hardware/mISDN/hfcmulti.c | 19 +++++++++++++------
 drivers/isdn/hardware/mISDN/hfcpci.c   | 13 +++++++++----
 drivers/isdn/hardware/mISDN/hfcsusb.c  | 12 ++++++++----
 3 files changed, 30 insertions(+), 14 deletions(-)

-- 
2.25.1

