Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C93B1B75F7
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 11:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388260AbfISJPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 05:15:37 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:58702 "EHLO
        andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730506AbfISJPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 05:15:36 -0400
Received: from ramsan ([84.194.98.4])
        by andre.telenet-ops.be with bizsmtp
        id 3MFa2100505gfCL01MFaUC; Thu, 19 Sep 2019 11:15:35 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iAsXG-0003n1-0Q; Thu, 19 Sep 2019 11:15:34 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iAsXF-0006VB-Un; Thu, 19 Sep 2019 11:15:33 +0200
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -net] zd1211rw: zd_usb: Use "%zu" to format size_t
Date:   Thu, 19 Sep 2019 11:15:32 +0200
Message-Id: <20190919091532.24951-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 32-bit:

    drivers/net/wireless/zydas/zd1211rw/zd_usb.c: In function ‘check_read_regs’:
    drivers/net/wireless/zydas/zd1211rw/zd_def.h:18:25: warning: format ‘%ld’ expects argument of type ‘long int’, but argument 6 has type ‘size_t’ {aka ‘unsigned int’} [-Wformat=]
      dev_printk(level, dev, "%s() " fmt, __func__, ##args)
			     ^~~~~~~
    drivers/net/wireless/zydas/zd1211rw/zd_def.h:22:4: note: in expansion of macro ‘dev_printk_f’
	dev_printk_f(KERN_DEBUG, dev, fmt, ## args)
	^~~~~~~~~~~~
    drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1635:3: note: in expansion of macro ‘dev_dbg_f’
       dev_dbg_f(zd_usb_dev(usb),
       ^~~~~~~~~
    drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1636:51: note: format string is defined here
	 "error: actual length %d less than expected %ld\n",
						     ~~^
						     %d

Fixes: 84b0b66352470e64 ("zd1211rw: zd_usb: Use struct_size() helper")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
index 4e44ea8c652d65aa..7b5c2fe5bd4d9cde 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -1633,7 +1633,7 @@ static bool check_read_regs(struct zd_usb *usb, struct usb_req_read_regs *req,
 	 */
 	if (rr->length < struct_size(regs, regs, count)) {
 		dev_dbg_f(zd_usb_dev(usb),
-			 "error: actual length %d less than expected %ld\n",
+			 "error: actual length %d less than expected %zu\n",
 			 rr->length, struct_size(regs, regs, count));
 		return false;
 	}
-- 
2.17.1

