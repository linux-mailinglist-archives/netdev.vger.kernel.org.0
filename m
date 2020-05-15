Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D311D5B7F
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgEOV3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:29:02 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37558 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbgEOV27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 17:28:59 -0400
Received: by mail-pf1-f193.google.com with SMTP id y198so16653pfb.4;
        Fri, 15 May 2020 14:28:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z+ArGLDYdSJ0w7Ek09g85tZFCS/nTsClbFEBaRYmVeE=;
        b=JKj/b0lhoe91hvSIP4HwSrtqmQV9Zmq7gBg//kOnQ6nJPk49bZqU/6FmQwJiI4WMOZ
         aSE+ehqCEg/QCemRs+2sfu858cebfalP55rGkobjcTV5Pl16xdYxG5cIlZPFB0Ju2aOL
         zkB++V8lSS2JOYE7P+BaHcB47liizJ8e+W8b8H9e6BQ3eXiccfIjAd9yjG3kd7Ef+asP
         GqA4kQtmO27dvmDEbZ6d/lTICzg1mciiL3tnV/hhXgll5ALFI4exu6i/Ag7dO82UIQKN
         +zUtuO2m432IzTOFxHoQuM00tJJMXLeru1NK6wepk9jm4syq7B0ALAUO0GLmC652/3ur
         ljQg==
X-Gm-Message-State: AOAM53321W61l1qU/ACg1FaVlhwvWdJ6PO1f8YM1ryvOk9/l8kUdjTxZ
        T3Xvcj8wXsG5/rhcVauC0Aw=
X-Google-Smtp-Source: ABdhPJyh4noS75cFo4UeBGQrE1rurDnL6NYp88Jw6dMIn4GnhLizAu+jGFCLtYQLhffbGewrUXICdw==
X-Received: by 2002:a62:38d5:: with SMTP id f204mr5547097pfa.284.1589578138203;
        Fri, 15 May 2020 14:28:58 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id b74sm2424048pga.31.2020.05.15.14.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 14:28:55 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id D6EE2422E5; Fri, 15 May 2020 21:28:49 +0000 (UTC)
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
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>
Subject: [PATCH v2 06/15] liquidio: use new module_firmware_crashed()
Date:   Fri, 15 May 2020 21:28:37 +0000
Message-Id: <20200515212846.1347-7-mcgrof@kernel.org>
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

Cc: Derek Chickles <dchickles@marvell.com>
Cc: Satanand Burla <sburla@marvell.com>
Cc: Felix Manlunas <fmanlunas@marvell.com>
Reviewed-by: Derek Chickles <dchickles@marvell.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 66d31c018c7e..f18085262982 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -801,6 +801,7 @@ static int liquidio_watchdog(void *param)
 			continue;
 
 		WRITE_ONCE(oct->cores_crashed, true);
+		module_firmware_crashed();
 		other_oct = get_other_octeon_device(oct);
 		if (other_oct)
 			WRITE_ONCE(other_oct->cores_crashed, true);
-- 
2.26.2

