Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FFA1D5B7D
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgEOV3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:29:00 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35786 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbgEOV27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 17:28:59 -0400
Received: by mail-pj1-f67.google.com with SMTP id ms17so1569000pjb.0;
        Fri, 15 May 2020 14:28:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fd2Ff5siORQ4NZvgjnMFoAiHp6dqIbzzKwIfZcm3FIc=;
        b=BbU7nLLCnL0CMc8B1TK0v++o+EgMFOAYQ3+v6FFOGj2YdIDThd9W2S+xLoHY3f53VK
         Z6UNPlzpnzM0OWToW5yKB1Y7NA58aX/CQTeAdhiUlVs7/2JlfOKHv8ba2TddhJsWzXIP
         BVe6wQU3zfKS1xA4oF47NMdMJhMk537ZYxHj7XF8CUjAxDykrEqo7QuxD0+cXf3Sx7HM
         d/iRiJqYwM0BtNM5WFAkZfU3T7HveQGAVVL2PrYhvh3+Dri0arZc0f80w+Wy3dnDxCQQ
         RikXnVAFWKrHBUuvqaQ95ZeQzlHQINf/vXe28Kk3QwT1ga78fPRQ2OSHxnIPNHYETOV6
         +HJw==
X-Gm-Message-State: AOAM533yGFVeuFt3WtfHo3WysSAKyvXm/C3I6p0e3rn74TNL66x/UY65
        9yM4opW7Yau2oUUUYKU5PwE=
X-Google-Smtp-Source: ABdhPJwAUG/0eLuXRMlJSjdKAtnNa9OX6nQKuBKKPQ9d/8v8pxImlglzByIaxepGuWvS5k1Ufbpawg==
X-Received: by 2002:a17:90b:3650:: with SMTP id nh16mr3915296pjb.135.1589578139466;
        Fri, 15 May 2020 14:28:59 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id cx11sm2284688pjb.36.2020.05.15.14.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 14:28:55 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id E19F342309; Fri, 15 May 2020 21:28:49 +0000 (UTC)
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
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH v2 07/15] cxgb4: use new module_firmware_crashed()
Date:   Fri, 15 May 2020 21:28:38 +0000
Message-Id: <20200515212846.1347-8-mcgrof@kernel.org>
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

Cc: Vishal Kulkarni <vishal@chelsio.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index a70018f067aa..c67fc86c0e42 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3646,6 +3646,7 @@ void t4_fatal_err(struct adapter *adap)
 	 * could be exposed to the adapter.  RDMA MWs for example...
 	 */
 	t4_shutdown_adapter(adap);
+	module_firmware_crashed();
 	for_each_port(adap, port) {
 		struct net_device *dev = adap->port[port];
 
-- 
2.26.2

