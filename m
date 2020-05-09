Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A591CBD7C
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgEIEgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:36:51 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33126 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728817AbgEIEgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:36:17 -0400
Received: by mail-pf1-f193.google.com with SMTP id x77so2064725pfc.0;
        Fri, 08 May 2020 21:36:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6nV8PMylqoFPDUoYFmy1R2d+sPYm3cn1hK2t9F4BUt8=;
        b=Al0rNm92TXFjSiIFvJIeTtAlfdJZtazQ9V5vFaLzkrTWcbCWNzMCV3xWR8gzpJRTtl
         NEaO3UK6caLkbxCep9aN9FiNAaGho3TYOauTsKCOR9R7VB+t2ea+ettH7jYpg78nuvms
         AGyJ9vKJfwyj9aGh7zV7MU16IJ8fGpV0esaaVbRmjyFaB1C7cUnsG2TKFKOevB8QwQq3
         EPqYYSSuX+qOoyrsWjcH2obVy+8Cz1SPlH6a1kHd0Sbf3Shi52TKxEYKQYsVhvqnvb8r
         5IIQKF4U6JVOc65gFQDavrtnoKgEv7NiGt3VFt7YF6AUCi7D+TrhAAhP3W3HcLHdV+Cp
         VBVQ==
X-Gm-Message-State: AGi0PuaZrvUuOJwS/HokYR34C7lElu0Z2xpUAMw05U+JNKEnmIzDQWvw
        RlbM1s9h2ClHzffn+YzfhHY=
X-Google-Smtp-Source: APiQypKuG4kUhajeiVgN6J0AzzPbQ1GumNkGw3hrb/Pw+IiX28oIrHhxd4xUHRvYtWchrnwtXqLRiw==
X-Received: by 2002:a62:2582:: with SMTP id l124mr77401pfl.308.1588998975368;
        Fri, 08 May 2020 21:36:15 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id o140sm592530pfd.176.2020.05.08.21.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 21:36:07 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 3F16642309; Sat,  9 May 2020 04:36:01 +0000 (UTC)
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
        Alex Elder <elder@kernel.org>
Subject: [PATCH 10/15] soc: qcom: ipa: use new module_firmware_crashed()
Date:   Sat,  9 May 2020 04:35:47 +0000
Message-Id: <20200509043552.8745-11-mcgrof@kernel.org>
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

Cc: Alex Elder <elder@kernel.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/ipa/ipa_modem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index ed10818dd99f..1790b87446ed 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -285,6 +285,7 @@ static void ipa_modem_crashed(struct ipa *ipa)
 	struct device *dev = &ipa->pdev->dev;
 	int ret;
 
+	module_firmware_crashed();
 	ipa_endpoint_modem_pause_all(ipa, true);
 
 	ipa_endpoint_modem_hol_block_clear_all(ipa);
-- 
2.25.1

