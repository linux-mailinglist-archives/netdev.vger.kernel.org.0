Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E37C4F7659
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 08:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241466AbiDGGkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 02:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241361AbiDGGkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 02:40:08 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 73BA55A0B5;
        Wed,  6 Apr 2022 23:38:06 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app4 (Coremail) with SMTP id cS_KCgA3rqW8hk5ipp_iAA--.33196S2;
        Thu, 07 Apr 2022 14:37:52 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org
Cc:     chris@zankel.net, jcmvbkbc@gmail.com, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, jgg@ziepe.ca, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jes@trained-monkey.org,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alexander.deucher@amd.com, linux-xtensa@linux-xtensa.org,
        linux-rdma@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-hippi@sunsite.dk,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 11/11] arch: xtensa: platforms: Fix deadlock in rs_close()
Date:   Thu,  7 Apr 2022 14:37:48 +0800
Message-Id: <9ca3ab0b40c875b6019f32f031c68a1ae80dd73a.1649310812.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1649310812.git.duoming@zju.edu.cn>
References: <cover.1649310812.git.duoming@zju.edu.cn>
X-CM-TRANSID: cS_KCgA3rqW8hk5ipp_iAA--.33196S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AF1kWFy8CFW7KrWfAr4DXFb_yoW8Jw4xpF
        WUKrnxGF4DWrWjg3WDta1DWryUZa1kKF1UJr98K3yUZ3Z5XryagF1xtw4rXFW7tFs7Wanx
        ZF1vqry5AFsrZr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvG1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
        twAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCF04k20xvY
        0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r4fKr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
        x4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa
        73UjIFyTuYvjfU5JPEDUUUU
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAggNAVZdtZEcMgANsK
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a deadlock in rs_close(), which is shown
below:

   (Thread 1)              |      (Thread 2)
                           | rs_open()
rs_close()                 |  mod_timer()
 spin_lock_bh() //(1)      |  (wait a time)
 ...                       | rs_poll()
 del_timer_sync()          |  spin_lock() //(2)
 (wait timer to stop)      |  ...

We hold timer_lock in position (1) of thread 1 and
use del_timer_sync() to wait timer to stop, but timer handler
also need timer_lock in position (2) of thread 2.
As a result, rs_close() will block forever.

This patch extracts del_timer_sync() from the protection of
spin_lock_bh(), which could let timer handler to obtain
the needed lock.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 arch/xtensa/platforms/iss/console.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index 81d7c7e8f7e..d431b61ae3c 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -51,8 +51,10 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 static void rs_close(struct tty_struct *tty, struct file * filp)
 {
 	spin_lock_bh(&timer_lock);
-	if (tty->count == 1)
+	if (tty->count == 1) {
+		spin_unlock_bh(&timer_lock);
 		del_timer_sync(&serial_timer);
+	}
 	spin_unlock_bh(&timer_lock);
 }
 
-- 
2.17.1

