Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863A5625679
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 10:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbiKKJUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 04:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbiKKJUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 04:20:09 -0500
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BF965E53
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 01:20:07 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4N7tTF6Xnhz4f4FHm
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 17:20:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.102.38])
        by APP4 (Coremail) with SMTP id gCh0CgCXu9jDE25jBOVeAQ--.38918S4;
        Fri, 11 Nov 2022 17:20:04 +0800 (CST)
From:   Wei Yongjun <weiyongjun@huaweicloud.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org
Subject: [PATCH net v2] net: mhi: Fix memory leak in mhi_net_dellink()
Date:   Fri, 11 Nov 2022 09:20:44 +0000
Message-Id: <20221111092044.3170908-1-weiyongjun@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCXu9jDE25jBOVeAQ--.38918S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw4fXrWUZFyfArWkXr4kXrb_yoWftrcEkr
        y7Zr17Jr45KF48K34UuF1rZr10kr1FgryrXF1Iqr93JryxZrn7Ww1xZr17tr9rWw4xAF9x
        AryaqF12y3sxWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbokYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
        z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
        AF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4l
        IxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s
        0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsG
        vfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: 5zhl50pqjm3046kxt4xhlfz01xgou0bp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

MHI driver registers network device without setting the
needs_free_netdev flag, and does NOT call free_netdev() when
unregisters network device, which causes a memory leak.

This patch calls free_netdev() to fix it since netdev_priv
is used after unregister.

Fixes: 13adac032982 ("net: mhi_net: Register wwan_ops for link creation")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
v1 -> v2: fix 'Fixes' tag

 drivers/net/mhi_net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index ff302144029d..3d322ac4f6a5 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -343,6 +343,8 @@ static void mhi_net_dellink(struct mhi_device *mhi_dev, struct net_device *ndev)
 
 	kfree_skb(mhi_netdev->skbagg_head);
 
+	free_netdev(ndev);
+
 	dev_set_drvdata(&mhi_dev->dev, NULL);
 }
 
-- 
2.34.1

