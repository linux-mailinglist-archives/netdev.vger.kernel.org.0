Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934431CBD65
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgEIEgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:36:13 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33450 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728777AbgEIEgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:36:10 -0400
Received: by mail-pj1-f67.google.com with SMTP id 7so5932064pjo.0;
        Fri, 08 May 2020 21:36:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MiQNjcOpznNHJIwN/vJ7Wo/YnTDk8aSjxv7fQy7u2y8=;
        b=lj3luMkOFKQ6cvW2o87kLMdzWKSobF8LVSQeZVveeXbFlTssYOBB+JZ36k9wEupdLR
         A+OWE/27n04f6grfjCSPXlciSaM+d7uaX9OfsCJv++NQwcUmyKjDowopkWpM5EUOXHWx
         YnAX5052oHQ+rpTO2+KKyIYBRxJ/IFPo1JZNI0RqlRSQPD0AcBOXsqzf+aebqNwnhmBC
         1Vz4V7L4P7W0mlf2kdfmBBKbVLmEeUcdZRLi3GqcWEo30Xoa2PwTTS0/LW3gtLIc1miX
         qv0WqwOEDshnfvceeZF4Ft35Q36C8K56dd8EMGyPK9SE5ngT/V+EUA6Tmd2vz5KubXtw
         WruA==
X-Gm-Message-State: AGi0PuYbi8N6nakOQ4M+NPvFvWQObbOyyid1GqcR8Llp/gx9oLbUkKY4
        ULceZOm0h0VPjiqhnWRjpI8=
X-Google-Smtp-Source: APiQypLiur3keFVKRwB2MQgmwWD89BCGfVHpMjRj2wvjmigHkcG0FJgVA9QEo1AVCFJZLcU3k/L7gg==
X-Received: by 2002:a17:90a:2450:: with SMTP id h74mr9662376pje.57.1588998970163;
        Fri, 08 May 2020 21:36:10 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id p24sm3281813pff.92.2020.05.08.21.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 21:36:07 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 1208142000; Sat,  9 May 2020 04:36:01 +0000 (UTC)
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
Subject: [PATCH 06/15] liquidio: use new module_firmware_crashed()
Date:   Sat,  9 May 2020 04:35:43 +0000
Message-Id: <20200509043552.8745-7-mcgrof@kernel.org>
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

Cc: Derek Chickles <dchickles@marvell.com>
Cc: Satanand Burla <sburla@marvell.com>
Cc: Felix Manlunas <fmanlunas@marvell.com>
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
2.25.1

