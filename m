Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4203B1D5B77
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgEOV24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:28:56 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:50980 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgEOV2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 17:28:55 -0400
Received: by mail-pj1-f65.google.com with SMTP id t9so1486896pjw.0;
        Fri, 15 May 2020 14:28:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mQHcezCNWzGuPmczrAfsld1MqXEk0Ppb3Y+korjrHEA=;
        b=H+2oKvnmYCrBr2Dfs1Pi6drOXJbvRQQt+hNxPiGB08gBWLo4B6oz9KQfGx0iADraeb
         vnHi6UQV0Df0WWM6dUKmqvQM1QPXX+pYS9l34fs/uUQTcO7bBg2CktOOutBmSl4mNquM
         KG5lKxbRxFOjvl634ZryJUHKWTAeyC8V394sA96MxQuZrvGO4hoZ2QwR1MW/Spx63/hR
         36F3xQIaghvCqctVOCQIdn6UmPvWh14pOacWOkMZYTB3OvogYP80heUiqC53gdUsBmeu
         R5pIjqLuhum1Ejz3kHouKQ1JP0fBQHmFQp77sdVduxQyEo5WzUflp+DWk88B+SYby8Vi
         MPkA==
X-Gm-Message-State: AOAM531apOtzAfQAAvMk67g1R4jK5OCKFAmmivnDcqo+2ZHRW7XlTADW
        Si9bRDwwbbv6rKK5eBJ1aMI=
X-Google-Smtp-Source: ABdhPJyl+c2F2sSpT3BFpmj7bcqKO62RcphXge2jJKPYJfka1FrmqSH1lDeI22yxIOVw1tH5xuJoOg==
X-Received: by 2002:a17:90a:4d4a:: with SMTP id l10mr5686766pjh.0.1589578133718;
        Fri, 15 May 2020 14:28:53 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id z13sm2235488pjz.42.2020.05.15.14.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 14:28:50 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 98C5341D00; Fri, 15 May 2020 21:28:49 +0000 (UTC)
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
Subject: [PATCH v2 02/15] ethernet/839: use new module_firmware_crashed()
Date:   Fri, 15 May 2020 21:28:33 +0000
Message-Id: <20200515212846.1347-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200515212846.1347-1-mcgrof@kernel.org>
References: <20200515212846.1347-1-mcgrof@kernel.org>
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
2.26.2

