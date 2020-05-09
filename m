Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0FB1CBD62
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgEIEgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:36:05 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:32789 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgEIEgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:36:05 -0400
Received: by mail-pl1-f193.google.com with SMTP id t7so1642694plr.0;
        Fri, 08 May 2020 21:36:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VkP6GWOio7qtVGJiV0OeaEyHuFiaIWKPQxya3i5GDSA=;
        b=l82iai2dqocs6iEfllINJe0nVEKcCUXwdS5lX4Pjfx0k+/tUN1vHDaBoNrCYxWa2un
         94Ph1y67DrIxZDdfUDpHbIqhkWC0yuJ4gpRFGUQl7bFjmHviAh0MB3BPxPTWn+jLUXmg
         v9W/gZd9Bcy4v7jQUjhQgQRw/KAyx9qYUthUMMmsSB8Vh/ghiACFRPKopHRtbiP8ByHQ
         PQML9RjuEViYNSrHEv1zl7QXZNwpTQ5z7no6baNrndLk2vEz/3nv/xSqE282n9+UmWcG
         rcXwxK5TfpKL9ayLxMG25cKRIJmdssADrz3N94OMmrQ9vmic9Hyw7US7d2J/AVG2OwEG
         Kdfw==
X-Gm-Message-State: AGi0Pub8O12eCz0m5xeyuajFUw33pAntvzncej+WQzEJF6toWCq1DVR+
        iXFUgOOGU1Q4gcDqxk0oh6s=
X-Google-Smtp-Source: APiQypIXyBqaBXyxzVqzZQbND5CCRopwmyiq2AWa34I4lmbuikMQ9/1Jk5F5GGDOQHUv7bOBuauRqA==
X-Received: by 2002:a17:90a:3b42:: with SMTP id t2mr9742401pjf.11.1588998964576;
        Fri, 08 May 2020 21:36:04 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id 138sm3331874pfz.31.2020.05.08.21.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 21:36:01 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id C70A841405; Sat,  9 May 2020 04:36:00 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     jeyu@kernel.org
Cc:     akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 02/15] ethernet/839: use new module_firmware_crashed()
Date:   Sat,  9 May 2020 04:35:39 +0000
Message-Id: <20200509043552.8745-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200509043552.8745-1-mcgrof@kernel.org>
References: <20200509043552.8745-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes use of the new module_firmware_crashed() to help
annotate when firmware for device drivers crash. When firmware
crashes devices can sometimes become unresponsive, and recovery
sometimes requires a driver unload / reload and in the worst cases
a reboot.

Using a taint flag allows us to annotate when this happens clearly.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Shannon Nelson <snelson@pensando.io>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/ethernet/8390/axnet_cs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/8390/axnet_cs.c b/drivers/net/ethernet/8390/axnet_cs.c
index aeae7966a082..8ad0200db8e9 100644
--- a/drivers/net/ethernet/8390/axnet_cs.c
+++ b/drivers/net/ethernet/8390/axnet_cs.c
@@ -1358,9 +1358,11 @@ static void ei_receive(struct net_device *dev)
 		 */
 		if ((netif_msg_rx_err(ei_local)) &&
 		    this_frame != ei_local->current_page &&
-		    (this_frame != 0x0 || rxing_page != 0xFF))
+		    (this_frame != 0x0 || rxing_page != 0xFF)) {
+			module_firmware_crashed();
 			netdev_err(dev, "mismatched read page pointers %2x vs %2x\n",
 				   this_frame, ei_local->current_page);
+		}
 		
 		if (this_frame == rxing_page)	/* Read all the frames? */
 			break;				/* Done for now */
-- 
2.25.1

