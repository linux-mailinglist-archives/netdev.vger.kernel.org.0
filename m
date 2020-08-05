Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A2D23CC47
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 18:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgHEQfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 12:35:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:57670 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726923AbgHEQeG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 12:34:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 755D8ABD2;
        Wed,  5 Aug 2020 12:28:42 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 3/3] usb: hso: remove bogus check for EINPROGRESS
Date:   Wed,  5 Aug 2020 14:07:09 +0200
Message-Id: <20200805120709.4676-4-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200805120709.4676-1-oneukum@suse.com>
References: <20200805120709.4676-1-oneukum@suse.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This check an inherent race. It opens a race where
an error code has already been set or cleared yet
the URB has not been given back. We cannot do
such an optimization and must unlink unconditionally.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/hso.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 5762876e3105..2bb28db89432 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -831,8 +831,7 @@ static void hso_net_tx_timeout(struct net_device *net, unsigned int txqueue)
 	dev_warn(&net->dev, "Tx timed out.\n");
 
 	/* Tear the waiting frame off the list */
-	if (odev->mux_bulk_tx_urb &&
-	    (odev->mux_bulk_tx_urb->status == -EINPROGRESS))
+	if (odev->mux_bulk_tx_urb)
 		usb_unlink_urb(odev->mux_bulk_tx_urb);
 
 	/* Update statistics */
-- 
2.16.4

