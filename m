Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62A455D2D5
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243369AbiF1CT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 22:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243474AbiF1CTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 22:19:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0020F22BDD;
        Mon, 27 Jun 2022 19:19:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5520B615C3;
        Tue, 28 Jun 2022 02:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF84C341D1;
        Tue, 28 Jun 2022 02:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382782;
        bh=Y9LFZ5AYICHV61HYIR74tGPitldOGzjg7gwkPbn555U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tn0mMk8dRllacvf5XMKDeYkn8I2KU9qrFH1JdWJ51TfBlOnGkwVJ3TTWjns09HuJG
         x2VEDd1pLXkEx/GmmtfQWvv5oshFb2aBbTXTi7iFuuNP78sJ7GAZkfdUQnBxgaWXbL
         qN55MuPMGeH5T2Y/ieg/w7+4Ep7mUhD4GIUY/NA+dM+NbX9ydD/g2PhVWnouIQf64v
         ijJ3exkUaoCI+tlB57IXe72+fDTxdfFya+dT1Gheg49tOKoifw7n4UaaWeikJX77wc
         Qx479YaIoIvCXuWImkYcUd6ZRLYXSdKxPpHzsxqrRlk0iY8nbP9qgaY/o4PXcemfCb
         Pp/j5gORCb89Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xu Jia <xujia39@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, ajk@comnets.uni-bremen.de,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 20/53] hamradio: 6pack: fix array-index-out-of-bounds in decode_std_command()
Date:   Mon, 27 Jun 2022 22:18:06 -0400
Message-Id: <20220628021839.594423-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Jia <xujia39@huawei.com>

[ Upstream commit 2b04495e21cdb9b45c28c6aeb2da560184de20a3 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/6pack.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 45c3c4a1101b..9fb567524220 100644
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
@@ -959,8 +963,11 @@ sixpack_decode(struct sixpack *sp, const unsigned char *pre_rbuff, int count)
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
2.35.1

