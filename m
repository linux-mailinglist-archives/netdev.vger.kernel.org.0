Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263051D5B79
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgEOV25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:28:57 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43365 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbgEOV2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 17:28:55 -0400
Received: by mail-pg1-f193.google.com with SMTP id f4so1588986pgi.10;
        Fri, 15 May 2020 14:28:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Os/9pOAyuFP5rE18cPqNjIzCr5UNKNMa70RxbYuAtoQ=;
        b=BLUUinTZb4bn1XwI4Sbw0k1YwFvObAbJ76yDFFi2D6kYhxyYjBqrdkYZd8TsFJC6cT
         lzAv4/3uN3LPyYBmvdQQJr35Qo64pUr7t41qhno8B6KDGghGw+HbOkX/htvDZGIDyExK
         aXB3D3HoB/FlBXdGJCsmN8u3CHkh389CALRHiOdtfrjvs47La+90o8Gjl5A0/1vW6uFb
         zFiPflefNNWFEIOSVjYjXz9D9NmRQxu3hpcFcVza1x67tX924W9jCfNRB7JJZsBQi6NH
         PagsDNan9mF0XBTCIFQtho+IKrxYIqrvFZ8ED7omzWRnKmEmqkZBT9paOgz12U4SzW0f
         KpvQ==
X-Gm-Message-State: AOAM532H8RWgWRcEKHphaz0lWbp+McCWDaH1bd+4gexLAL8HT71Pxwmu
        MqFS3Xm7E2si7XSH0bXRLlc=
X-Google-Smtp-Source: ABdhPJxA6chVMk3VbtmoOXv21M2cB33WLyUbJtzdTmRjvXxRRJ0EACaWlp73Wt9JQyukkevMHDPzbg==
X-Received: by 2002:a62:68c1:: with SMTP id d184mr5878271pfc.138.1589578134871;
        Fri, 15 May 2020 14:28:54 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id o9sm2171534pjp.4.2020.05.15.14.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 14:28:50 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id A958C41D95; Fri, 15 May 2020 21:28:49 +0000 (UTC)
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
Subject: [PATCH v2 03/15] bnx2x: use new module_firmware_crashed()
Date:   Fri, 15 May 2020 21:28:34 +0000
Message-Id: <20200515212846.1347-4-mcgrof@kernel.org>
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
2.26.2

