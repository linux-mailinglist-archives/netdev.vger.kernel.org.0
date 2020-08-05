Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BBD23CC4F
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 18:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgHEQhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 12:37:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:58324 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbgHEQfh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 12:35:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1BFA6AFE6;
        Wed,  5 Aug 2020 12:28:42 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 2/3] usb: hso: no complaint about kmalloc failure
Date:   Wed,  5 Aug 2020 14:07:08 +0200
Message-Id: <20200805120709.4676-3-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200805120709.4676-1-oneukum@suse.com>
References: <20200805120709.4676-1-oneukum@suse.com>
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
index 031a5ad25500..5762876e3105 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2465,10 +2465,9 @@ static void hso_create_rfkill(struct hso_device *hso_dev,
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

