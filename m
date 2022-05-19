Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4C252D21A
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 14:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237699AbiESMKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 08:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbiESMKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 08:10:13 -0400
X-Greylist: delayed 4519 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 May 2022 05:10:09 PDT
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 628225997C;
        Thu, 19 May 2022 05:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pku.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=2+Vwb1brMiNx4lK7ZGRYMXQnW/BV3o/Pw9gsvxTqgWw=; b=W
        yKWYw3SBgLdi3XFJmocjftHOCM+Uo5vu6D8oF1qGryQIAxDECEvuVFRsTPzuIanb
        WniYLGcQl+y3duOqvz8k16fmotY0aTRiV7b7ybUKTR6bw1uHO94h3nhkmLx1o14h
        tadGh/z1j2PHQQGcWdvNVfnO0f5nYi8xNrVueq3Fwg=
Received: from localhost (unknown [10.129.21.144])
        by front01 (Coremail) with SMTP id 5oFpogBnjSWRM4Ziol1_Bw--.59015S2;
        Thu, 19 May 2022 20:09:53 +0800 (CST)
From:   Yongzhi Liu <lyz_cs@pku.edu.cn>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, sashal@kernel.org
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, fuyq@stu.pku.edu.cn,
        Yongzhi Liu <lyz_cs@pku.edu.cn>
Subject: [PATCH] hv_netvsc: Fix potential dereference of NULL pointer
Date:   Thu, 19 May 2022 05:09:48 -0700
Message-Id: <1652962188-129281-1-git-send-email-lyz_cs@pku.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: 5oFpogBnjSWRM4Ziol1_Bw--.59015S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZw4UGr4UCw1rtw47CF1Utrb_yoWfXrg_Cr
        48uF1rZr17AFy8KrsrCF4rZFy0yw1vqr1fZrW2y3y3tFy7ZrWDX395Zr97JF4fWa1Uur9x
        Cwn2qFW5AryIgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb3kFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
        GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY02Avz4vE
        -syl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VWkJr1UJwCFx2IqxVCFs4IE7x
        kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
        67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
        CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
        MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
        VFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: irzqijirqukmo6sn3hxhgxhubq/1tbiAwELBlPy7vJhCwAHsf
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of netvsc_devinfo_get()
needs to be checked to avoid use of NULL
pointer in case of an allocation failure.

Fixes: 0efeea5fb ("hv_netvsc: Add the support of hibernation")

Signed-off-by: Yongzhi Liu <lyz_cs@pku.edu.cn>
---
 drivers/net/hyperv/netvsc_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index fde1c49..b1dece6 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2671,7 +2671,10 @@ static int netvsc_suspend(struct hv_device *dev)
 
 	/* Save the current config info */
 	ndev_ctx->saved_netvsc_dev_info = netvsc_devinfo_get(nvdev);
-
+	if (!ndev_ctx->saved_netvsc_dev_info) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	ret = netvsc_detach(net, nvdev);
 out:
 	rtnl_unlock();
-- 
2.7.4

