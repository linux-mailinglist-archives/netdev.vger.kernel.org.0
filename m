Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28701CBD78
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgEIEgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:36:37 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37786 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbgEIEgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:36:18 -0400
Received: by mail-pj1-f67.google.com with SMTP id a7so5212352pju.2;
        Fri, 08 May 2020 21:36:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d9Crehj1GSqNkWIBx6oBRWEIaOhUeDUKthtt6ioogWY=;
        b=iSgZ8VMUNNC1vroyE9p1khznIlmX9vwLXbbgnX/9ozZLBrD80Q+i0uYt5Hy8mMC47w
         oQ/NSF5/CMuVv7HZWvuoEjO9e8DTWVZI9ShhoSOrCBjVmActPlq1jf+bDrsX4Ac51yFW
         L3QMNpyJi4AWBLmLmOjml/XkrZ/j6YEg6v7bIBcAExuqwxglZGqHeK9hF2BjKrGZE+b5
         Q65UwqdlszmJpzBTEqbzsYS8+FtncJu85zVQOUKu7/hmxkOQFLSAdrWtAXS2N7UBGfMI
         0eaE3BXZ9NjK0M4nLhh9Ge8R4FtCyQoqNRnzkUy8Nfh9P/mT06x1TLdSuhxVnqj7e2PG
         Phvg==
X-Gm-Message-State: AGi0PuaMrL8ryUsniBCP4a1A4NU3gu4TugicBKqonCCUHypVAvq91lbp
        hqmOQw33gHgpVVX+wy2XBO4=
X-Google-Smtp-Source: APiQypIU4o32j8RS8tQB2eiEqmJBzdWhDYA6pQVk2wb8WK8zzJKAF2L1MoxxJEX40cb2k4hlTVBl6w==
X-Received: by 2002:a17:902:b945:: with SMTP id h5mr5552788pls.224.1588998978020;
        Fri, 08 May 2020 21:36:18 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id o17sm2598387pgv.83.2020.05.08.21.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 21:36:15 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 4B2314230A; Sat,  9 May 2020 04:36:01 +0000 (UTC)
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
        linux-wimax@intel.com,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Subject: [PATCH 11/15] wimax/i2400m: use new module_firmware_crashed()
Date:   Sat,  9 May 2020 04:35:48 +0000
Message-Id: <20200509043552.8745-12-mcgrof@kernel.org>
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

Cc: linux-wimax@intel.com
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/wimax/i2400m/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wimax/i2400m/rx.c b/drivers/net/wimax/i2400m/rx.c
index c9fb619a9e01..307a62ca183f 100644
--- a/drivers/net/wimax/i2400m/rx.c
+++ b/drivers/net/wimax/i2400m/rx.c
@@ -712,6 +712,7 @@ void __i2400m_roq_queue(struct i2400m *i2400m, struct i2400m_roq *roq,
 	dev_err(dev, "SW BUG? failed to insert packet\n");
 	dev_err(dev, "ERX: roq %p [ws %u] skb %p nsn %d sn %u\n",
 		roq, roq->ws, skb, nsn, roq_data->sn);
+	module_firmware_crashed();
 	skb_queue_walk(&roq->queue, skb_itr) {
 		roq_data_itr = (struct i2400m_roq_data *) &skb_itr->cb;
 		nsn_itr = __i2400m_roq_nsn(roq, roq_data_itr->sn);
-- 
2.25.1

