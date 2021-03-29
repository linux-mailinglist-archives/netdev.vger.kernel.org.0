Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B881834CC16
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 11:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhC2Iza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:55:30 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:19808 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236382AbhC2Ix3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 04:53:29 -0400
Received: from localhost.localdomain (unknown [10.192.140.4])
        by mail-app3 (Coremail) with SMTP id cC_KCgA3P5dmlWFgxK5pAA--.51681S4;
        Mon, 29 Mar 2021 16:53:00 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Jouni Malinen <j@w1.fi>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hostap: Fix memleak in prism2_config
Date:   Mon, 29 Mar 2021 16:52:43 +0800
Message-Id: <20210329085246.24586-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgA3P5dmlWFgxK5pAA--.51681S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw1kCw4rZrW5AF15Cr18Grg_yoWfAFX_Cr
        W2vFn5XrykA3409r1UCFsxZFyIyF1DZa48ZF1ktF95JryUXrZ7t34fZr1ay3s3Cw4q9ry3
        Cr4qqF1Ikas0gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbskFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl6s0DM28EF7xvwVC2z280
        aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07
        x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18
        McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr4
        1lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28IcxkI
        7VAKI48JMxAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
        C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
        wI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
        v20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73Uj
        IFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAg4HBlZdtSzMkgBNsM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When prism2_hw_config() fails, we just return an error code
without any resource release, which may lead to memleak.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/net/wireless/intersil/hostap/hostap_cs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_cs.c b/drivers/net/wireless/intersil/hostap/hostap_cs.c
index ec7db2badc40..7dc16ab50ad6 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_cs.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_cs.c
@@ -536,10 +536,10 @@ static int prism2_config(struct pcmcia_device *link)
 	sandisk_enable_wireless(dev);
 
 	ret = prism2_hw_config(dev, 1);
-	if (!ret)
-		ret = hostap_hw_ready(dev);
+	if (ret)
+		goto failed;
 
-	return ret;
+	return hostap_hw_ready(dev);;
 
  failed:
 	kfree(hw_priv);
-- 
2.17.1

