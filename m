Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8861922FF07
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 03:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgG1BpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 21:45:00 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:52595 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgG1BpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 21:45:00 -0400
Received: from fsav303.sakura.ne.jp (fsav303.sakura.ne.jp [153.120.85.134])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 06S1iJxD088794;
        Tue, 28 Jul 2020 10:44:19 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav303.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav303.sakura.ne.jp);
 Tue, 28 Jul 2020 10:44:19 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav303.sakura.ne.jp)
Received: from localhost.localdomain (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 06S1iFhm088645
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 28 Jul 2020 10:44:19 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     gbhat@marvell.com
Cc:     amitkarwar@gmail.com, andreyknvl@google.com, davem@davemloft.net,
        dvyukov@google.com, huxinming820@gmail.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        nishants@marvell.com,
        syzbot+dc4127f950da51639216@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+373e6719b49912399d21@syzkaller.appspotmail.com>
Subject: [PATCH] mwifiex: don't call del_timer_sync() on uninitialized timer
Date:   Tue, 28 Jul 2020 10:44:12 +0900
Message-Id: <1595900652-3842-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <MN2PR18MB2637D7C742BC235FE38367F0A09C0@MN2PR18MB2637.namprd18.prod.outlook.com>
References: <MN2PR18MB2637D7C742BC235FE38367F0A09C0@MN2PR18MB2637.namprd18.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is reporting that del_timer_sync() is called from
mwifiex_usb_cleanup_tx_aggr() from mwifiex_unregister_dev() without
checking timer_setup() from mwifiex_usb_tx_init() was called [1].
Since mwifiex_usb_prepare_tx_aggr_skb() is calling del_timer() if
is_hold_timer_set == true, use the same condition for del_timer_sync().

[1] https://syzkaller.appspot.com/bug?id=fdeef9cf7348be8b8ab5b847f2ed993aba8ea7b6

Reported-by: syzbot <syzbot+373e6719b49912399d21@syzkaller.appspotmail.com>
Cc: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
A patch from Ganapathi Bhat ( https://patchwork.kernel.org/patch/10990275/ ) is stalling
at https://lore.kernel.org/linux-usb/MN2PR18MB2637D7C742BC235FE38367F0A09C0@MN2PR18MB2637.namprd18.prod.outlook.com/ .
syzbot by now got this report for 10000 times. Do we want to go with this simple patch?

 drivers/net/wireless/marvell/mwifiex/usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 6f3cfde..04a1461 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -1353,7 +1353,8 @@ static void mwifiex_usb_cleanup_tx_aggr(struct mwifiex_adapter *adapter)
 				skb_dequeue(&port->tx_aggr.aggr_list)))
 				mwifiex_write_data_complete(adapter, skb_tmp,
 							    0, -1);
-		del_timer_sync(&port->tx_aggr.timer_cnxt.hold_timer);
+		if (port->tx_aggr.timer_cnxt.is_hold_timer_set)
+			del_timer_sync(&port->tx_aggr.timer_cnxt.hold_timer);
 		port->tx_aggr.timer_cnxt.is_hold_timer_set = false;
 		port->tx_aggr.timer_cnxt.hold_tmo_msecs = 0;
 	}
-- 
1.8.3.1

