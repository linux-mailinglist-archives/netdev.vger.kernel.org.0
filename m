Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E5C37493
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 14:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbfFFM4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 08:56:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:55632 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727130AbfFFM4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 08:56:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 08C64ADEC;
        Thu,  6 Jun 2019 12:56:08 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 2/6] usb: hso: no complaint about kmalloc failure
Date:   Thu,  6 Jun 2019 14:55:44 +0200
Message-Id: <20190606125548.18315-2-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190606125548.18315-1-oneukum@suse.com>
References: <20190606125548.18315-1-oneukum@suse.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If this fails, kmalloc() will print a report including
a stack trace. There is no need for a separate complaint.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/hso.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 6a0ecddff310..fe1d7bdc8afe 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2474,10 +2474,9 @@ static void hso_create_rfkill(struct hso_device *hso_dev,
 				       &interface_to_usbdev(interface)->dev,
 				       RFKILL_TYPE_WWAN,
 				       &hso_rfkill_ops, hso_dev);
-	if (!hso_net->rfkill) {
-		dev_err(dev, "%s - Out of memory\n", __func__);
+	if (!hso_net->rfkill)
 		return;
-	}
+
 	if (rfkill_register(hso_net->rfkill) < 0) {
 		rfkill_destroy(hso_net->rfkill);
 		hso_net->rfkill = NULL;
-- 
2.16.4

