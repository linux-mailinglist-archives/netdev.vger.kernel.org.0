Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2399F1D5B87
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgEOV3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:29:09 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44006 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgEOV3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 17:29:07 -0400
Received: by mail-pl1-f196.google.com with SMTP id k22so1420778pls.10;
        Fri, 15 May 2020 14:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aC7L6/f42/gPjIDsH2AkyT3HK+i3vctnLudoDWO4A04=;
        b=AjRDRWxVI1WN7GDdK6vjTn5SnQsS2mN8zRsjdrP7IWtWYZbszAuLxVMczdZJhB1b4l
         EjVWOyRKLCMJNfmtFed1M9mUiwjz6IfcQ/zdbqtgf68gVDwaT3GJVuGBTV9sQiqCinAi
         UwGyQ8QOVaEmITnedKpN8LBHVsga4l6aDUZ8uBzA+s8qnXeN3js0d4gH0RTrByZUr4fU
         Fhm+Zp2gxIMoKWSm3iFlccjku5CzAVa/OrP+3ti8mcJb68fZlG/iBUtfXTfoyqUVmw3O
         NA6d4RuTC4mA+QImQPBPxEZi+8vz2X6AG0yKeWfzBztGwAW1xvq978P2wusLN4c9u8d4
         mslw==
X-Gm-Message-State: AOAM531K7v+evP/tw2qlD6CfBRAeGsFAz12yq6TSCPH8/36ST4e3nsDQ
        ImtxfAyO6D7y8MizlDmzSQI=
X-Google-Smtp-Source: ABdhPJxXNou50yIHSh6fq7UacJSKWUh4Fh8iActeIPzYhcfbgAV9CeFNZwMPi6ZjkC+/+JSXSaCiwQ==
X-Received: by 2002:a17:90a:d818:: with SMTP id a24mr5616179pjv.75.1589578146344;
        Fri, 15 May 2020 14:29:06 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id w190sm2302171pfw.35.2020.05.15.14.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 14:29:04 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 42D5442376; Fri, 15 May 2020 21:28:50 +0000 (UTC)
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
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: [PATCH v2 13/15] ath6kl: use new module_firmware_crashed()
Date:   Fri, 15 May 2020 21:28:44 +0000
Message-Id: <20200515212846.1347-14-mcgrof@kernel.org>
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

Cc: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/hif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index d1942537ea10..cfd838607544 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -120,6 +120,7 @@ static int ath6kl_hif_proc_dbg_intr(struct ath6kl_device *dev)
 	int ret;
 
 	ath6kl_warn("firmware crashed\n");
+	module_firmware_crashed();
 
 	/*
 	 * read counter to clear the interrupt, the debug error interrupt is
-- 
2.26.2

