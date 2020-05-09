Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2CD1CBD7B
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbgEIEgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:36:44 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36822 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgEIEgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:36:17 -0400
Received: by mail-pg1-f194.google.com with SMTP id d22so1864357pgk.3;
        Fri, 08 May 2020 21:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=myNCixB4Wt/Dj4YEDmqFhw0GwtgJlBYyFB3jPG3Nx54=;
        b=S/AmHP6+zrcaIXvIcu7pyIQgx6ANOJ4aHgaR4hZ8EKZ3YDfJhubIGPg2k4206PMW++
         Fz1MmA+v8xW//HRr/rQhyDtSDCeiUbPkNKBFEAv7jFzZ2BE9lyEseDG71cKf0CBIs7mf
         4P5aOVfsgSZMdwlKH5c0SozwySebE+l89mF6k5+eAne0HprByyqPmsTxsjGP/JDlD58X
         1vUnaWHPqs2jeaUcsP79w9xu8bDlLc2h/xQDC/Vf4FtmeUBSWR3K/ocg8YvmSvcCRUpy
         bpe7rT+qbzDxXoCJa64BqiHzUuonF8vmkbxBjWTKHubdcN6E+llC8aruHk4Wb/ivZENF
         BBkA==
X-Gm-Message-State: AGi0PuZGKyFBfZjTIfWWNF58W9Lv/wOpqeaKAVTCvYBymtSjke9iLiGY
        4ih7KoAd0Ud2hD2cSeUdJtVZaZ5xbvvW2g==
X-Google-Smtp-Source: APiQypLM8elFsSmsIb97VrDyhu+XcSDHVdS0mODbH0OjwWueTY6Rt/ao0SdaeJu6GXa/+IQBQp9rMg==
X-Received: by 2002:a63:1820:: with SMTP id y32mr4836345pgl.182.1588998977066;
        Fri, 08 May 2020 21:36:17 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id h6sm3719180pje.37.2020.05.08.21.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 21:36:15 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 5F7E742340; Sat,  9 May 2020 04:36:01 +0000 (UTC)
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
Subject: [PATCH 13/15] ath6kl: use new module_firmware_crashed()
Date:   Sat,  9 May 2020 04:35:50 +0000
Message-Id: <20200509043552.8745-14-mcgrof@kernel.org>
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
2.25.1

