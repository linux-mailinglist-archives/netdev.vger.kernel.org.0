Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254464AF227
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbiBIMyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiBIMyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:54:04 -0500
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37B53C0613CA;
        Wed,  9 Feb 2022 04:54:03 -0800 (PST)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app4 (Coremail) with SMTP id cS_KCgBn3oFauQNi37bZCA--.22091S2;
        Wed, 09 Feb 2022 20:53:50 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     dan.carpenter@oracle.com, jreuter@yaina.de, ralf@linux-mips.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH] ax25: fix UAF bugs of net_device caused by rebinding operation
Date:   Wed,  9 Feb 2022 20:53:45 +0800
Message-Id: <20220209125345.86638-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgBn3oFauQNi37bZCA--.22091S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAr1DurWxCrWrAw1DuF4fuFg_yoW5GFyUpF
        WkCayxAryDJFy5Ar4UWr97WF1UZFW5K3ykGr109FWSk343Jr95tryktryjqry5CFWrAF1U
        Xa47JFyrJF4UAaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v
        1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgwNAVZdtYEE3QANsp
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ax25_kill_by_device() will set s->ax25_dev = NULL and
call ax25_disconnect() to change states of ax25_cb and
sock, if we call ax25_bind() before ax25_kill_by_device().

However, if we call ax25_bind() again between the window of
ax25_kill_by_device() and ax25_dev_device_down(), the values
and states changed by ax25_kill_by_device() will be reassigned.

Finally, ax25_dev_device_down() will deallocate net_device.
If we dereference net_device in syscall functions such as
ax25_release(), ax25_sendmsg(), ax25_getsockopt(), ax25_getname()
and ax25_info_show(), a UAF bug will occur.

One of the possible race conditions is shown below:

      (USE)                   |      (FREE)
ax25_bind()                   |
                              |  ax25_kill_by_device()
ax25_bind()                   |
ax25_connect()                |    ...
                              |  ax25_dev_device_down()
                              |    ...
                              |    dev_put_track(dev, ...) //FREE
ax25_release()                |    ...
  ax25_send_control()         |
    alloc_skb()      //USE    |

the corresponding fail log is shown below:
===============================================================
BUG: KASAN: use-after-free in ax25_send_control+0x43/0x210
...
Call Trace:
  ...
  ax25_send_control+0x43/0x210
  ax25_release+0x2db/0x3b0
  __sock_release+0x6d/0x120
  sock_close+0xf/0x20
  __fput+0x11f/0x420
  ...
Allocated by task 1283:
  ...
  __kasan_kmalloc+0x81/0xa0
  alloc_netdev_mqs+0x5a/0x680
  mkiss_open+0x6c/0x380
  tty_ldisc_open+0x55/0x90
  ...
Freed by task 1969:
  ...
  kfree+0xa3/0x2c0
  device_release+0x54/0xe0
  kobject_put+0xa5/0x120
  tty_ldisc_kill+0x3e/0x80
  ...

In order to fix these UAF bugs caused by rebinding operation,
this patch adds dev_hold_track() into ax25_bind() and
corresponding dev_put_track() into ax25_kill_by_device().

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 net/ax25/af_ax25.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 3d87040d1bf..d53cbb4e250 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -91,6 +91,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			s->ax25_dev = NULL;
+			dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
 			ax25_dev_put(ax25_dev);
 			ax25_disconnect(s, ENETUNREACH);
 			release_sock(sk);
@@ -1116,8 +1117,10 @@ static int ax25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		}
 	}
 
-	if (ax25_dev != NULL)
+	if (ax25_dev) {
 		ax25_fillin_cb(ax25, ax25_dev);
+		dev_hold_track(ax25_dev->dev, &ax25_dev->dev_tracker, GFP_ATOMIC);
+	}
 
 done:
 	ax25_cb_add(ax25);
-- 
2.17.1

