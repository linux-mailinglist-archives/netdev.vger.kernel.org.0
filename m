Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B471044D7BD
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 15:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhKKODK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 09:03:10 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:33790 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233586AbhKKODI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 09:03:08 -0500
Received: from localhost.localdomain (unknown [222.205.2.245])
        by mail-app3 (Coremail) with SMTP id cC_KCgBnbxvoIY1ht1H5Bw--.22116S4;
        Thu, 11 Nov 2021 22:00:08 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jirislaby@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v0] hamradio: delete unnecessary free_netdev()
Date:   Thu, 11 Nov 2021 22:00:07 +0800
Message-Id: <20211111140007.7244-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cC_KCgBnbxvoIY1ht1H5Bw--.22116S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtrW8uw15XF48AF15Xw48Xrb_yoWfZrg_ur
        1xZFZ7Jr1DJrW7tanFvr4rA34IkFs8Xr1fuas2qas3Ga43twn7J3yI9rs3Jr15WayxtF9x
        Ar12qF17J3y2gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbxkFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
        GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_Xryl42xK82IYc2Ij64vIr41l
        42xK82IY6x8ErcxFaVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
        8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWU
        twCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
        0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
        Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUb
        kR65UUUUU==
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The former patch "defer 6pack kfree after unregister_netdev" adds
free_netdev() function in sixpack_close(), which is a bad copy from the
similar code in mkiss_close(). However, this free is unnecessary as the
flag needs_free_netdev is set to true in sp_setup(), hence the
unregister_netdev() will free the netdev automatically.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 drivers/net/hamradio/6pack.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index bfdf89e54752..180c8f08169b 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -677,8 +677,6 @@ static void sixpack_close(struct tty_struct *tty)
 	/* Free all 6pack frame buffers after unreg. */
 	kfree(sp->rbuff);
 	kfree(sp->xbuff);
-
-	free_netdev(sp->dev);
 }
 
 /* Perform I/O control on an active 6pack channel. */
-- 
2.33.1

