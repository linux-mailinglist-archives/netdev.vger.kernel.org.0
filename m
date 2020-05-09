Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5D41CBD6E
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgEIEgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:36:09 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37745 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728697AbgEIEgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:36:08 -0400
Received: by mail-pl1-f193.google.com with SMTP id x10so1634669plr.4;
        Fri, 08 May 2020 21:36:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=520DVozYcI1durffcC1g+bgC7qwaN6rEN099XCz3lNk=;
        b=ErLBxndXJV/denra0tDJsPiqL7DCh62lu4YZkMmO7wtaJ6MKbMwYqjPYHG29GLBXEm
         0RY5cJLk1EmsMKBQe4TBzI705u78YZebiV4VHcG4JC0S8VmjY26zWJRaWkAF0aRXTrcm
         Lyu25nbQ709R3mH+gUTfb+UcqOnf/kkxW1MjUG+ni4gtQqZOJ3Mxf3tjzeSlAYQOxHVZ
         jCB6JhhQ4NhVebch6odmUZoWeOgmuNak/QOaIP8hK3KGyPwXbDzqMc6EnMvTrOG04pwx
         jhfxAeHR8v4YWN6jHVzfPaNAx4pmT5tbnaRrvhJVvn4C1Mpmw6l+Oaz7mbB5rp2OmZea
         68mQ==
X-Gm-Message-State: AGi0PuZcLklntKBzGvIhQC5xJDZqQvpY842XTdy16plJOLpOsLCD/cTA
        CmG0DBGox/F6PU/Zej7OnWg=
X-Google-Smtp-Source: APiQypLhNxOZ9zSqwOivW1DuzLpv7GJhIJCq/zviwyHl3767b25FTJ1w7h//Pokrb8pRSaOfFnbSnw==
X-Received: by 2002:a17:902:7203:: with SMTP id ba3mr5308169plb.202.1588998967262;
        Fri, 08 May 2020 21:36:07 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id l1sm678301pgj.48.2020.05.08.21.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 21:36:01 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id D829841D00; Sat,  9 May 2020 04:36:00 +0000 (UTC)
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
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com
Subject: [PATCH 03/15] bnx2x: use new module_firmware_crashed()
Date:   Sat,  9 May 2020 04:35:40 +0000
Message-Id: <20200509043552.8745-4-mcgrof@kernel.org>
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

Cc: Ariel Elior <aelior@marvell.com>
Cc: Sudarsana Kalluru <skalluru@marvell.com>
CC: GR-everest-linux-l2@marvell.com
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index db5107e7937c..c38b8c9c8af0 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -909,6 +909,7 @@ void bnx2x_panic_dump(struct bnx2x *bp, bool disable_int)
 	bp->eth_stats.unrecoverable_error++;
 	DP(BNX2X_MSG_STATS, "stats_state - DISABLED\n");
 
+	module_firmware_crashed();
 	BNX2X_ERR("begin crash dump -----------------\n");
 
 	/* Indices */
-- 
2.25.1

