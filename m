Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA851CBD69
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgEIEgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:36:22 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43377 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728846AbgEIEgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:36:19 -0400
Received: by mail-pl1-f196.google.com with SMTP id z6so1625457plk.10;
        Fri, 08 May 2020 21:36:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WzAUhm9PAzr7uU8H1Lc2ngEyBupzXwHNyDw+1FmrAuk=;
        b=ABo2hpRjR7QwDjQAzeVuBVN1+ujsAAnhezO+qg1r3MO1zyxXMWsonIYOiPhSECGsLQ
         kQ76j5GjlBCf6W1vpagB4SE8W5Dx9bRdB+8RzZhV6MMmboiZ9eALX7JE2MwBQAiNHMe1
         J36mVZlOf6FPKwLJodnBjwcfpv55x7hMCfYRQE9YbwtRNT5DfpECsTQAalBAeQgG+JU7
         C4Dwel2wfOZpGjBvbMJUOxx9fmnjD874Iw21JqoVc+pPyMzS4u7o8Vvl2Lf8bZ9tX4T2
         G3+AD0DeQ8hz89fLXfNEZbIg2YzIUH1o+2qKOT1jzKzC/MQWkJ283b+LI8vhRes+QwCm
         ldXQ==
X-Gm-Message-State: AGi0PuY6fLMTaLNQ2HrtvXDqfM8Ri5e9i8v/X5tFsHa2geKEJYQt5NmT
        C6wLYzBrJZ0Rdx9SSd09Q18=
X-Google-Smtp-Source: APiQypLTFb2RAG3FyXNjeEw4HN1+FeVK1th9HhFtNsa33Z6gZafA063iGaEXxunyudg4OhViLAcglQ==
X-Received: by 2002:a17:90b:19c9:: with SMTP id nm9mr9798057pjb.86.1588998978909;
        Fri, 08 May 2020 21:36:18 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id b20sm3293544pff.8.2020.05.08.21.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 21:36:15 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 76BD542349; Sat,  9 May 2020 04:36:01 +0000 (UTC)
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
        linux-wireless@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>
Subject: [PATCH 15/15] mwl8k: use new module_firmware_crashed()
Date:   Sat,  9 May 2020 04:35:52 +0000
Message-Id: <20200509043552.8745-16-mcgrof@kernel.org>
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
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/wireless/marvell/mwl8k.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index 97f23f93f6e7..d609ef1bb879 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -1551,6 +1551,7 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 	 * the firmware has crashed
 	 */
 	if (priv->hw_restart_in_progress) {
+		module_firmware_crashed();
 		if (priv->hw_restart_owner == current)
 			return 0;
 		else
-- 
2.25.1

