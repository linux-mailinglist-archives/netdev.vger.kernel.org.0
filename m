Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCC33CBAD0
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 14:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387764AbfJDMvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 08:51:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45515 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387440AbfJDMvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 08:51:22 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1iGN3C-00065G-RU; Fri, 04 Oct 2019 12:51:15 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     davem@davemloft.net
Cc:     hayeswang@realtek.com, mario.limonciello@dell.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH] r8152: Set macpassthru in reset_resume callback
Date:   Fri,  4 Oct 2019 20:51:04 +0800
Message-Id: <20191004125104.13202-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

r8152 may fail to establish network connection after resume from system
suspend.

If the USB port connects to r8152 lost its power during system suspend,
the MAC address was written before is lost. The reason is that The MAC
address doesn't get written again in its reset_resume callback.

So let's set MAC address again in reset_resume callback. Also remove
unnecessary lock as no other locking attempt will happen during
reset_resume.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/usb/r8152.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 08726090570e..cee9fef925cd 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -4799,10 +4799,9 @@ static int rtl8152_reset_resume(struct usb_interface *intf)
 	struct r8152 *tp = usb_get_intfdata(intf);
 
 	clear_bit(SELECTIVE_SUSPEND, &tp->flags);
-	mutex_lock(&tp->control);
 	tp->rtl_ops.init(tp);
 	queue_delayed_work(system_long_wq, &tp->hw_phy_work, 0);
-	mutex_unlock(&tp->control);
+	set_ethernet_addr(tp);
 	return rtl8152_resume(intf);
 }
 
-- 
2.17.1

