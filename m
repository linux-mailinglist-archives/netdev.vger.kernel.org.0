Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CDF54F415
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 11:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbiFQJSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 05:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235678AbiFQJS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 05:18:28 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4755677A;
        Fri, 17 Jun 2022 02:18:26 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4LPYLv5d4Qz1K9xM;
        Fri, 17 Jun 2022 17:16:23 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 17 Jun 2022 17:18:16 +0800
Received: from localhost.localdomain (10.175.112.70) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 17 Jun 2022 17:18:15 +0800
From:   Xu Jia <xujia39@huawei.com>
To:     <linux-hams@vger.kernel.org>, <pabeni@redhat.com>,
        <ajk@comnets.uni-bremen.de>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xujia39@huawei.com>
Subject: [PATCH v2] hamradio: 6pack: fix array-index-out-of-bounds in decode_std_command()
Date:   Fri, 17 Jun 2022 17:31:06 +0800
Message-ID: <1655458266-27879-1-git-send-email-xujia39@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hulk Robot reports incorrect sp->rx_count_cooked value in decode_std_command().
This should be caused by the subtracting from sp->rx_count_cooked before.
It seems that sp->rx_count_cooked value is changed to 0, which bypassed the
previous judgment.

The situation is shown below:

         (Thread 1)			|  (Thread 2)
decode_std_command()		| resync_tnc()
...					|
if (rest == 2)			|
	sp->rx_count_cooked -= 2;	|
else if (rest == 3)			| ...
					| sp->rx_count_cooked = 0;
	sp->rx_count_cooked -= 1;	|
for (i = 0; i < sp->rx_count_cooked; i++) // report error
	checksum += sp->cooked_buf[i];

sp->rx_count_cooked is a shared variable but is not protected by a lock.
The same applies to sp->rx_count. This patch adds a lock to fix the bug.

The fail log is shown below:
=======================================================================
UBSAN: array-index-out-of-bounds in drivers/net/hamradio/6pack.c:925:31
index 400 is out of range for type 'unsigned char [400]'
CPU: 3 PID: 7433 Comm: kworker/u10:1 Not tainted 5.18.0-rc5-00163-g4b97bac0756a #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
Workqueue: events_unbound flush_to_ldisc
Call Trace:
 <TASK>
 dump_stack_lvl+0xcd/0x134
 ubsan_epilogue+0xb/0x50
 __ubsan_handle_out_of_bounds.cold+0x62/0x6c
 sixpack_receive_buf+0xfda/0x1330
 tty_ldisc_receive_buf+0x13e/0x180
 tty_port_default_receive_buf+0x6d/0xa0
 flush_to_ldisc+0x213/0x3f0
 process_one_work+0x98f/0x1620
 worker_thread+0x665/0x1080
 kthread+0x2e9/0x3a0
 ret_from_fork+0x1f/0x30
 ...

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Xu Jia <xujia39@huawei.com>
---
 drivers/net/hamradio/6pack.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index ff2bb3d..833dcc7 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -99,6 +99,7 @@ struct sixpack {
 
 	unsigned int		rx_count;
 	unsigned int		rx_count_cooked;
+	spinlock_t		rxlock;
 
 	int			mtu;		/* Our mtu (to spot changes!) */
 	int			buffsize;       /* Max buffers sizes */
@@ -565,6 +566,7 @@ static int sixpack_open(struct tty_struct *tty)
 	sp->dev = dev;
 
 	spin_lock_init(&sp->lock);
+	spin_lock_init(&sp->rxlock);
 	refcount_set(&sp->refcnt, 1);
 	init_completion(&sp->dead);
 
@@ -913,6 +915,7 @@ static void decode_std_command(struct sixpack *sp, unsigned char cmd)
 			sp->led_state = 0x60;
 			/* fill trailing bytes with zeroes */
 			sp->tty->ops->write(sp->tty, &sp->led_state, 1);
+			spin_lock_bh(&sp->rxlock);
 			rest = sp->rx_count;
 			if (rest != 0)
 				 for (i = rest; i <= 3; i++)
@@ -930,6 +933,7 @@ static void decode_std_command(struct sixpack *sp, unsigned char cmd)
 				sp_bump(sp, 0);
 			}
 			sp->rx_count_cooked = 0;
+			spin_unlock_bh(&sp->rxlock);
 		}
 		break;
 	case SIXP_TX_URUN: printk(KERN_DEBUG "6pack: TX underrun\n");
@@ -959,8 +963,11 @@ static void decode_std_command(struct sixpack *sp, unsigned char cmd)
 			decode_prio_command(sp, inbyte);
 		else if ((inbyte & SIXP_STD_CMD_MASK) != 0)
 			decode_std_command(sp, inbyte);
-		else if ((sp->status & SIXP_RX_DCD_MASK) == SIXP_RX_DCD_MASK)
+		else if ((sp->status & SIXP_RX_DCD_MASK) == SIXP_RX_DCD_MASK) {
+			spin_lock_bh(&sp->rxlock);
 			decode_data(sp, inbyte);
+			spin_unlock_bh(&sp->rxlock);
+		}
 	}
 }
 
-- 
1.8.3.1

