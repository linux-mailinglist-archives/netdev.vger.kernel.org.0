Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B13447E23
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 11:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238772AbhKHKlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 05:41:21 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:40434 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238640AbhKHKkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 05:40:49 -0500
Received: from localhost.localdomain (unknown [222.205.2.245])
        by mail-app4 (Coremail) with SMTP id cS_KCgBHT+MH_ohhZIbCBA--.52229S4;
        Mon, 08 Nov 2021 18:37:59 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jirislaby@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v1 2/2] hamradio: defer 6pack kfree after unregister_netdev
Date:   Mon,  8 Nov 2021 18:37:59 +0800
Message-Id: <20211108103759.30541-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211108103721.30522-1-linma@zju.edu.cn>
References: <20211108103721.30522-1-linma@zju.edu.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cS_KCgBHT+MH_ohhZIbCBA--.52229S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uF15Zr48ZFykCF1kGr15Jwb_yoW8Jw18pF
        W5GFW3Aw1ktr45Gw1ktF4YgF98WwsavFWUCFZ8G3sF9rsIvF109r1qkFyj9r4DZr1rA3yY
        yFn8AF43Crn5A3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_
        JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r4DMxAIw28IcxkI7VAKI48J
        MxAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_
        Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
        6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0J
        UZYFZUUUUU=
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a possible race condition (use-after-free) like below

 (USE)                       |  (FREE)
  dev_queue_xmit             |
   __dev_queue_xmit          |
    __dev_xmit_skb           |
     sch_direct_xmit         | ...
      xmit_one               |
       netdev_start_xmit     | tty_ldisc_kill
        __netdev_start_xmit  |  6pack_close
         sp_xmit             |   kfree
          sp_encaps          |
                             |

According to the patch "defer ax25 kfree after unregister_netdev", this
patch reorder the kfree after the unregister_netdev to avoid the possible
UAF as the unregister_netdev() is well synchronized and won't return if
there is a running routine.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 drivers/net/hamradio/6pack.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 49f10053a794..bfdf89e54752 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -672,11 +672,13 @@ static void sixpack_close(struct tty_struct *tty)
 	del_timer_sync(&sp->tx_t);
 	del_timer_sync(&sp->resync_t);
 
-	/* Free all 6pack frame buffers. */
+	unregister_netdev(sp->dev);
+
+	/* Free all 6pack frame buffers after unreg. */
 	kfree(sp->rbuff);
 	kfree(sp->xbuff);
 
-	unregister_netdev(sp->dev);
+	free_netdev(sp->dev);
 }
 
 /* Perform I/O control on an active 6pack channel. */
-- 
2.33.1

