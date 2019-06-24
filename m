Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B035518E5
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbfFXQpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:45:24 -0400
Received: from canardo.mork.no ([148.122.252.1]:52427 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbfFXQpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 12:45:24 -0400
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x5OGjEfI019192
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 24 Jun 2019 18:45:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1561394715; bh=IDXZJ///XxwnyiOJpz8yicO6tLhZ1eLIrJXMy8Pzy9o=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        b=QFWbzXDxWkjF2XMtNgEdoVUqLgV/UXaa0PRsXeItEYc/ICr8TDmi1b8jFXa8Auyg9
         ypb6K3Vw8Ayu5autyWr6/m6kj0fyzU4sFG/pMB35ZL/Q97jGckW+PqFWrn236W7DA9
         H/KoD2DPEGwf/Fjul8pzyadVoNnkw7HDcx3JHvos=
Received: from bjorn by miraculix.mork.no with local (Exim 4.89)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1hfS5i-0000E4-E7; Mon, 24 Jun 2019 18:45:14 +0200
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, Hillf Danton <hdanton@sina.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH net,stable] qmi_wwan: Fix out-of-bounds read
Date:   Mon, 24 Jun 2019 18:45:11 +0200
Message-Id: <20190624164511.831-1-bjorn@mork.no>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The syzbot reported

 Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xca/0x13e lib/dump_stack.c:113
  print_address_description+0x67/0x231 mm/kasan/report.c:188
  __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:317
  kasan_report+0xe/0x20 mm/kasan/common.c:614
  qmi_wwan_probe+0x342/0x360 drivers/net/usb/qmi_wwan.c:1417
  usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
  really_probe+0x281/0x660 drivers/base/dd.c:509
  driver_probe_device+0x104/0x210 drivers/base/dd.c:670
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:777
  bus_for_each_drv+0x15c/0x1e0 drivers/base/bus.c:454

Caused by too many confusing indirections and casts.
id->driver_info is a pointer stored in a long.  We want the
pointer here, not the address of it.

Thanks-to: Hillf Danton <hdanton@sina.com>
Reported-by: syzbot+b68605d7fadd21510de1@syzkaller.appspotmail.com
Cc: Kristian Evensen <kristian.evensen@gmail.com>
Fixes: e4bf63482c30 ("qmi_wwan: Add quirk for Quectel dynamic config")
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
The bug was introduced in v5.2-rc1 but has been backported to stable kernels.
So this fix also needs to go into stable.

 drivers/net/usb/qmi_wwan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index d080f8048e52..8b4ad10cf940 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1482,7 +1482,7 @@ static int qmi_wwan_probe(struct usb_interface *intf,
 	 * different. Ignore the current interface if the number of endpoints
 	 * equals the number for the diag interface (two).
 	 */
-	info = (void *)&id->driver_info;
+	info = (void *)id->driver_info;
 
 	if (info->data & QMI_WWAN_QUIRK_QUECTEL_DYNCFG) {
 		if (desc->bNumEndpoints == 2)
-- 
2.11.0

