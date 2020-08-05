Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D964823D1B2
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 22:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgHEUFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 16:05:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:58482 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbgHEQge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 12:36:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CBE4DAFC0;
        Wed,  5 Aug 2020 12:28:41 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 1/3] hso: fix bailout in error case of probe
Date:   Wed,  5 Aug 2020 14:07:07 +0200
Message-Id: <20200805120709.4676-2-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200805120709.4676-1-oneukum@suse.com>
References: <20200805120709.4676-1-oneukum@suse.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver tries to reuse code for disconnect in case
of a failed probe.
If resources need to be freed after an error in probe, the
netdev must not be freed because it has never been registered.
Fix it by telling the helper which path we are in.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/hso.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index d2fdb5430d27..031a5ad25500 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2357,7 +2357,7 @@ static int remove_net_device(struct hso_device *hso_dev)
 }
 
 /* Frees our network device */
-static void hso_free_net_device(struct hso_device *hso_dev)
+static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
 {
 	int i;
 	struct hso_net *hso_net = dev2net(hso_dev);
@@ -2380,7 +2380,7 @@ static void hso_free_net_device(struct hso_device *hso_dev)
 	kfree(hso_net->mux_bulk_tx_buf);
 	hso_net->mux_bulk_tx_buf = NULL;
 
-	if (hso_net->net)
+	if (hso_net->net && !bailout)
 		free_netdev(hso_net->net);
 
 	kfree(hso_dev);
@@ -2556,7 +2556,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 
 	return hso_dev;
 exit:
-	hso_free_net_device(hso_dev);
+	hso_free_net_device(hso_dev, true);
 	return NULL;
 }
 
@@ -3133,7 +3133,7 @@ static void hso_free_interface(struct usb_interface *interface)
 				rfkill_unregister(rfk);
 				rfkill_destroy(rfk);
 			}
-			hso_free_net_device(network_table[i]);
+			hso_free_net_device(network_table[i], false);
 		}
 	}
 }
-- 
2.16.4

