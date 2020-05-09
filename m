Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331C01CBD70
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgEIEgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:36:09 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:55093 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbgEIEgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:36:08 -0400
Received: by mail-pj1-f67.google.com with SMTP id y6so5221022pjc.4;
        Fri, 08 May 2020 21:36:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QJXnP62KLztaJdrV69YlA0+UUHz93O9d1I2NYSRHz+Q=;
        b=tbS1EfFIyZcCzJujI8tIg9FF2RZ73FXHNCsKckDenoyW9of7sID1TcNeD8099Uo1th
         7HGNeyCrF4OXEvhbZlCFOq7Ro9jxUgGodglVZoP8bSc6vtWq57B4SCeSBwuzv6yUZCi7
         D1eCzJW8GbVRNx1szSkXT60ARCskOq89eU12FXcUQhjqB0HC0MydesCb5WpTTuO8BpKr
         Sicza5F8kLqsH3UJe9IYLZoCcebbpYgHpGeLHpVtW6tpfysrAccS4HmF4bnnHTp7Md/q
         FDAIlYv5GlZWNsFH7G3PnY8e8LJDxyJ5V5Ie4Ck4GzkiwWgvbzS6aco2IA2P2E5NR+/o
         IzlA==
X-Gm-Message-State: AGi0PuYbYnLJFARC7TctpGsOoZ/sI5pypGKOnZvtYCW7H/9CS+V5YlfG
        rW5QmvmDqqMLN7lHzPSgSAU=
X-Google-Smtp-Source: APiQypJphI7aZtPAxu0REWRaFUCZ5/wgOk5Z6Tw6ri2tWqa9HyhgVhQ/qZ4KCgzlvcw+F2p6JthR1w==
X-Received: by 2002:a17:902:347:: with SMTP id 65mr5615196pld.21.1588998966510;
        Fri, 08 May 2020 21:36:06 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id j23sm3622135pjz.13.2020.05.08.21.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 21:36:01 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id E8A5F41D67; Sat,  9 May 2020 04:36:00 +0000 (UTC)
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
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH 04/15] bnxt: use new module_firmware_crashed()
Date:   Sat,  9 May 2020 04:35:41 +0000
Message-Id: <20200509043552.8745-5-mcgrof@kernel.org>
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

Cc: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index dd0c3f227009..5ba1bd0734e9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3503,6 +3503,7 @@ static int bnxt_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
 
 	dump->flag = bp->dump_flag;
 	if (dump->flag == BNXT_DUMP_CRASH) {
+		module_firmware_crashed();
 #ifdef CONFIG_TEE_BNXT_FW
 		return tee_bnxt_copy_coredump(buf, 0, dump->len);
 #endif
-- 
2.25.1

