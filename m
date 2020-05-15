Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DD21D5B83
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgEOV3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:29:06 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53441 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbgEOV3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 17:29:02 -0400
Received: by mail-pj1-f65.google.com with SMTP id hi11so1478894pjb.3;
        Fri, 15 May 2020 14:29:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BVI90Jx0mfg2mzobQ93FBFZYLfrAY+kFFbLRK534ymo=;
        b=ar/M2cEv/VBx2QHo3CeSYjVh1shWk97jwOG9PNwmNumzRX7dxVUdwip7nwQ+6fEeW0
         BY1mLcn5ZJdqNQILAyLVBrSiQH9p7zasqRksdYiXcsLwfOycIQvvZmWK9F09bYcIWB3K
         gb1lXEFzb+KjodAL7UIHM+mw/lvgyfBajiWusT5NMy294dxDxOtQmQz60x+oPGOYBl9G
         BZzFexzQ5Gi27DOJkREVjqfIMjaYAGmO7OCHLLAOh9p6BacgZxkhWLJyOPbvAsiGMBj6
         lcR2cfZ8AOf0du9cdtSOyAaPY+k7+p2PmeXwY/jQs7bpUN7waAgxnKaYk3h9sHbAaVZQ
         Vjuw==
X-Gm-Message-State: AOAM531RbIPEYAJuOewWibkXYYUjXICt1H/23gIcJvH9I4Sw9qLCa7sj
        EVqFkC9cG7Ws6b6UWWZBxq8=
X-Google-Smtp-Source: ABdhPJxnQmcqRbJRGZ8iB7ghw3anMd7q93j51/pmVs2akYDs6Ntm0WHQQx7X7QEZmBozSzdYQTrPQg==
X-Received: by 2002:a17:90a:bf08:: with SMTP id c8mr5687943pjs.13.1589578140564;
        Fri, 15 May 2020 14:29:00 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id kr1sm2174731pjb.26.2020.05.15.14.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 14:28:55 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id ED1424230A; Fri, 15 May 2020 21:28:49 +0000 (UTC)
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
        Douglas Miller <dougmill@linux.ibm.com>
Subject: [PATCH v2 08/15] ehea: use new module_firmware_crashed()
Date:   Fri, 15 May 2020 21:28:39 +0000
Message-Id: <20200515212846.1347-9-mcgrof@kernel.org>
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

Cc: Douglas Miller <dougmill@linux.ibm.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/ethernet/ibm/ehea/ehea_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 0273fb7a9d01..6ae35067003f 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -3285,6 +3285,8 @@ static void ehea_crash_handler(void)
 {
 	int i;
 
+	module_firmware_crashed();
+
 	if (ehea_fw_handles.arr)
 		for (i = 0; i < ehea_fw_handles.num_entries; i++)
 			ehea_h_free_resource(ehea_fw_handles.arr[i].adh,
-- 
2.26.2

