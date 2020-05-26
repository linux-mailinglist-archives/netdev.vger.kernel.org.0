Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D771E24C4
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731451AbgEZO6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:58:42 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46269 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731370AbgEZO6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 10:58:30 -0400
Received: by mail-pg1-f193.google.com with SMTP id p21so10173164pgm.13;
        Tue, 26 May 2020 07:58:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lLNCK+WRq9ug4fTBP9sca/wv2hUwl+4zOX5ypfLbsKY=;
        b=PRMSnGv9mhb+gmul9y6X87lLu6mjkdHuyfsamDsv/WYlYlThgQF+6/BczFv24RQh28
         L+lPITIjmSkrk6wO/uGPYzBFd051KF8qqDjWhbeq03/yWGLdoP4l9tRxJdU9cqFxWzL6
         mAuGdVIF39YP0xprXcM6hmG1QqsjR6pg/QBW7CNrkMEli2D/AYgvM/8ojuoS/cRwuZlL
         Ml7n2KKTUSPikvIvcZJBOCIk8yb0KkfMeqIb4bb5AGTyQZ1PbA2vUYH2JE7kPFtkNwbT
         rPAc2V4aiI1fcRhcenz8Y4biGUhhM6hoKIb6IhkZmypmQAatrLMQINzOHFZGJD368FFW
         A9SQ==
X-Gm-Message-State: AOAM531CVFYwY2upikhvWtfK+f73PfZfGgyeWTNQY3cMXddcYpMPgvJZ
        tSx713+1uVf6O4LOkQQdqEOBIsDQD70g4w==
X-Google-Smtp-Source: ABdhPJztJRZpLHdtJV036fTHC1B9gsIyCD7HAHmajg7pNI3kRXEq9jRzWhS4XEoXuX2KgzB1H0zWTA==
X-Received: by 2002:a65:41c8:: with SMTP id b8mr1383705pgq.265.1590505109347;
        Tue, 26 May 2020 07:58:29 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id y14sm15686666pfr.11.2020.05.26.07.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 07:58:25 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id D804142309; Tue, 26 May 2020 14:58:18 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     jeyu@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     michael.chan@broadcom.com, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, akpm@linux-foundation.org,
        arnd@arndb.de, rostedt@goodmis.org, mingo@redhat.com,
        aquini@redhat.com, cai@lca.pw, dyoung@redhat.com, bhe@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, gpiccoli@canonical.com,
        pmladek@suse.com, tiwai@suse.de, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, derosier@gmail.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, vkoul@kernel.org,
        mchehab+huawei@kernel.org, robh@kernel.org, mhiramat@kernel.org,
        sfr@canb.auug.org.au, linux@dominikbrodowski.net,
        glider@google.com, paulmck@kernel.org, elver@google.com,
        bauerman@linux.ibm.com, yamada.masahiro@socionext.com,
        samitolvanen@google.com, yzaikin@google.com, dvyukov@google.com,
        rdunlap@infradead.org, corbet@lwn.net, dianders@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v3 7/8] liquidio: use new taint_firmware_crashed()
Date:   Tue, 26 May 2020 14:58:14 +0000
Message-Id: <20200526145815.6415-8-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200526145815.6415-1-mcgrof@kernel.org>
References: <20200526145815.6415-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes use of the new taint_firmware_crashed() to help
annotate when firmware for device drivers crash. When firmware
crashes devices can sometimes become unresponsive, and recovery
sometimes requires a driver unload / reload and in the worst cases
a reboot.

Using a taint flag allows us to annotate when this happens clearly.

Cc: Derek Chickles <dchickles@marvell.com>
Cc: Satanand Burla <sburla@marvell.com>
Cc: Felix Manlunas <fmanlunas@marvell.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Reviewed-by: Derek Chickles <dchickles@marvell.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 66d31c018c7e..ee1796ea4818 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -801,6 +801,7 @@ static int liquidio_watchdog(void *param)
 			continue;
 
 		WRITE_ONCE(oct->cores_crashed, true);
+		taint_firmware_crashed();
 		other_oct = get_other_octeon_device(oct);
 		if (other_oct)
 			WRITE_ONCE(other_oct->cores_crashed, true);
-- 
2.26.2

