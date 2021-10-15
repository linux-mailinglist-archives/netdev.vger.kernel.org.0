Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D554942E77A
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 06:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbhJOEGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 00:06:39 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:24319 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhJOEGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 00:06:38 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HVswx4tqrzbcyb;
        Fri, 15 Oct 2021 12:00:01 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Fri, 15 Oct 2021 12:04:30 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <amitkarwar@gmail.com>, <siva8118@gmail.com>
CC:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] rsi: stop thread firstly in rsi_91x_init() error handling
Date:   Fri, 15 Oct 2021 12:03:35 +0800
Message-ID: <20211015040335.1021546-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When fail to init coex module, free 'common' and 'adapter' directly, but
common->tx_thread which will access 'common' and 'adapter' is running at
the same time. That will trigger the UAF bug.

==================================================================
BUG: KASAN: use-after-free in rsi_tx_scheduler_thread+0x50f/0x520 [rsi_91x]
Read of size 8 at addr ffff8880076dc000 by task Tx-Thread/124777
CPU: 0 PID: 124777 Comm: Tx-Thread Not tainted 5.15.0-rc5+ #19
Call Trace:
 dump_stack_lvl+0xe2/0x152
 print_address_description.constprop.0+0x21/0x140
 ? rsi_tx_scheduler_thread+0x50f/0x520
 kasan_report.cold+0x7f/0x11b
 ? rsi_tx_scheduler_thread+0x50f/0x520
 rsi_tx_scheduler_thread+0x50f/0x520
...

Freed by task 111873:
 kasan_save_stack+0x1b/0x40
 kasan_set_track+0x1c/0x30
 kasan_set_free_info+0x20/0x30
 __kasan_slab_free+0x109/0x140
 kfree+0x117/0x4c0
 rsi_91x_init+0x741/0x8a0 [rsi_91x]
 rsi_probe+0x9f/0x1750 [rsi_usb]

Stop thread before free 'common' and 'adapter' to fix it.

Fixes: 2108df3c4b18 ("rsi: add coex support")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/wireless/rsi/rsi_91x_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index d98483298555..87f83def6c25 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -359,6 +359,7 @@ struct rsi_hw *rsi_91x_init(u16 oper_mode)
 	if (common->coex_mode > 1) {
 		if (rsi_coex_attach(common)) {
 			rsi_dbg(ERR_ZONE, "Failed to init coex module\n");
+			rsi_kill_thread(&common->tx_thread);
 			goto err;
 		}
 	}
-- 
2.25.1

