Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969B31D5B9A
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgEOV34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:29:56 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38786 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgEOV3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 17:29:03 -0400
Received: by mail-pl1-f194.google.com with SMTP id m7so1431073plt.5;
        Fri, 15 May 2020 14:29:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q9PwzdCQf8OZTe8dAYOPmHkC2y8QfZP7n40O3xNZ4X4=;
        b=df8TRJLJ1RXLSRHcRrfIw6OS3qe40NKqM4dfJfApWY1E4d+dz9n9baaCmPYQ/DBwRp
         jc3meNVqVGCIpN36KXwDybymH9HtacPx9md6eVmV1jzSRy741aXHSB4qqELBdHVBILwZ
         PNm3cSm1BA/1cJSdItK8w655sVthAphMKvmneGVOdVHNHO0JYN884aI0iEl02ulTGkVB
         xFY0+B3tGCPVmTsWWUcaWBK2ViftfwRG98YbLjZEzwquB+0Jp6cdOSLQIPecnw5f7k1s
         E6O9vyjv6aXkr768hn7O21cstq//0SK+WXSISk7YLB+p586L7xYWm/YUbmcmpBD+DIHc
         bu7A==
X-Gm-Message-State: AOAM532O50ZBCKvJ04TEdlr8N/DXD7jAVS9PkhjgDYzmtrlGRAow97NF
        sWtEUAS4/kzoEJfNzw3aKIg=
X-Google-Smtp-Source: ABdhPJyrm+xaRGTabJz/en5ByrR3PDdgfo69rGBaeEQxT6mtQVCqVD2NZl0Yj2IiJxaWLZHc4xWqTQ==
X-Received: by 2002:a17:902:988a:: with SMTP id s10mr5292140plp.204.1589578142589;
        Fri, 15 May 2020 14:29:02 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id cc8sm2217813pjb.11.2020.05.15.14.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 14:28:55 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 0FF8E42340; Fri, 15 May 2020 21:28:50 +0000 (UTC)
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
Subject: [PATCH v2 10/15] soc: qcom: ipa: use new module_firmware_crashed()
Date:   Fri, 15 May 2020 21:28:41 +0000
Message-Id: <20200515212846.1347-11-mcgrof@kernel.org>
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
2.26.2

