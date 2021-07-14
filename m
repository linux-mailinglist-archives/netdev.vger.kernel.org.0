Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4D33C893B
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 19:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhGNRDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 13:03:21 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:38436 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236733AbhGNRDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 13:03:20 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 14865228D4;
        Wed, 14 Jul 2021 17:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626282028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dwnyqLC3FgZ8/gCSQBCS5HJ1KdwXrjhEabLrECiHHlY=;
        b=SPGbkmNpw7DswD4QQRQmT93qiAMc2+5JE6o/lwKZTD+7A4qIgQMpnstPLGaK1ogHUwcGoM
        h1UxCAKav3jrEg32Zn6J7XjTJzsSjAVsZNrlBETh8wUEjPKE/DQZCn1cZedainLcTqZIfx
        85PK5PV2nKPJV9ijAvsmwxKi9b3toPE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626282028;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dwnyqLC3FgZ8/gCSQBCS5HJ1KdwXrjhEabLrECiHHlY=;
        b=5L54TDreSJ14PIvkSqhTLKSLmR772eI3fm0d20D9LC76yGexIHTMFEDsuKZBcT7Afcd8x4
        ndKuILL0NlgzJbDQ==
Received: from alsa1.nue.suse.com (alsa1.suse.de [10.160.4.42])
        by relay2.suse.de (Postfix) with ESMTP id 0432CA3B90;
        Wed, 14 Jul 2021 17:00:28 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH 1/2] r8152: Fix potential PM refcount imbalance
Date:   Wed, 14 Jul 2021 19:00:21 +0200
Message-Id: <20210714170022.8162-2-tiwai@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210714170022.8162-1-tiwai@suse.de>
References: <20210714170022.8162-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtl8152_close() takes the refcount via usb_autopm_get_interface() but
it doesn't release when RTL8152_UNPLUG test hits.  This may lead to
the imbalance of PM refcount.  This patch addresses it.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1186194
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/net/usb/r8152.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 1692d3b1b6e1..4096e20e9725 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6763,9 +6763,10 @@ static int rtl8152_close(struct net_device *netdev)
 		tp->rtl_ops.down(tp);
 
 		mutex_unlock(&tp->control);
+	}
 
+	if (!res)
 		usb_autopm_put_interface(tp->intf);
-	}
 
 	free_all_mem(tp);
 
-- 
2.26.2

