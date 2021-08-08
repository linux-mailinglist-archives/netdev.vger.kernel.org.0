Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD603E392C
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 08:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhHHGWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 02:22:12 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7809 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhHHGWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 02:22:11 -0400
Received: from dggeml759-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gj8Hl0RxHzYmHp;
        Sun,  8 Aug 2021 14:21:39 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 dggeml759-chm.china.huawei.com (10.1.199.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sun, 8 Aug 2021 14:21:49 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] wwan: mhi: Fix missing spin_lock_init() in mhi_mbim_probe()
Date:   Sun, 8 Aug 2021 06:33:44 +0000
Message-ID: <20210808063344.255867-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeml759-chm.china.huawei.com (10.1.199.138)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver allocates the spinlock but not initialize it.
Use spin_lock_init() on it to initialize it correctly.

Fixes: aa730a9905b7 ("net: wwan: Add MHI MBIM network driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/wwan/mhi_wwan_mbim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wwan/mhi_wwan_mbim.c b/drivers/net/wwan/mhi_wwan_mbim.c
index f37232fb29c0..377529bbf124 100644
--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -601,6 +601,7 @@ static int mhi_mbim_probe(struct mhi_device *mhi_dev, const struct mhi_device_id
 	if (!mbim)
 		return -ENOMEM;
 
+	spin_lock_init(&mbim->tx_lock);
 	dev_set_drvdata(&mhi_dev->dev, mbim);
 	mbim->mdev = mhi_dev;
 	mbim->mru = mhi_dev->mhi_cntrl->mru ? mhi_dev->mhi_cntrl->mru : MHI_DEFAULT_MRU;

