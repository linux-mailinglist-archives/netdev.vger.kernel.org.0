Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9731392319
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 01:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbhEZXPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 19:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbhEZXPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 19:15:23 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC71C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 16:13:49 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id i5so2837439qkf.12
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 16:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JrSuS0A86qN/bGvdpsl7GGzUqjciMY8/pkrotORM/UM=;
        b=nJL2ISAljXQ0ZkP8A67+hBgQxgUs3Pq2feV4h9P9RypzOpUtcDhNpqTg4OFOTpwYrc
         u4KrvdMWWihikDSmpmqZBSUUYk2A1D0XJwRzdTbZpSgY0SdFw6rGCl0DyAajd4D/RVDr
         1Da4uNY+cAsvJDQBW57nV9fV0ZcQUN2hsOmV10xBQor/HM07VKLnIzVSyvT+p0GbAqPF
         BLhAm3c+kfgTmkRaOLH0UKAG2U65Edtzr7O+Yf5U4jnEspZSC13oBrefoaNIXHNZTTkZ
         kvOnBSq0wO7eey19EFOWDjuSG1/5itVQA0cdifESCK7U9614T9OfCJig8jrh1U7ELMrH
         mzuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JrSuS0A86qN/bGvdpsl7GGzUqjciMY8/pkrotORM/UM=;
        b=Sq+qo5vd1DGJpVpBLIqxXFN1bZBVxhFSa4jShB/cO45G9NbEuQRE7HqZLO2O7uMFmP
         Y9RU9XN4JxTZtPkfk1iGdWYbMNR+uT//lC6R5RJl7CREMVUR4q+4s75+ZXFtjG/N0nz1
         8n4CWntjd8o4yKMd065n5RmJ3/RCy7jsmrXLC3fj0HnwTeN6w3pIdNDzk06VfY78qjsC
         BTWm8QfFtc1vlrqbSui9tX6pscXq6BvEotXU8RYtMiF+wRQHU4/xrHy2wC7FTCKQv2Ue
         AlV3RWF7TDMMvKmZIs5YN8d7p0qM6+fCZg16CxkrPUE28tjYhtLcNB07/bC8tPE/3ZOJ
         uxCQ==
X-Gm-Message-State: AOAM533des5QRrMX88naN0Fb3XfjdWPb86gYJeoOwA2WefQUZRgtY5hK
        wTZl9E5QH/Y+mUIHpqeMgIRCVS8MBS0=
X-Google-Smtp-Source: ABdhPJxMSMHH50XoqwXGMD9hPDcH0OH1SsGKYfDDv4zCpNkR2on45oe/ywGOzb8wdgHb+aCz+YJMdw==
X-Received: by 2002:a05:620a:886:: with SMTP id b6mr503377qka.327.1622070828556;
        Wed, 26 May 2021 16:13:48 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:557d:8eb6:c0af:d526])
        by smtp.gmail.com with ESMTPSA id k24sm290476qtq.49.2021.05.26.16.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 16:13:48 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Subject: [PATCH net-next,v2,2/2] net: update netdev_rx_csum_fault() print dump only once
Date:   Wed, 26 May 2021 19:13:36 -0400
Message-Id: <20210526231336.2772011-3-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
In-Reply-To: <20210526231336.2772011-1-tannerlove.kernel@gmail.com>
References: <20210526231336.2772011-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

Printing this stack dump multiple times does not provide additional
useful information, and consumes time in the data path. Printing once
is sufficient.

Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Mahesh Bandewar <maheshb@google.com>
---
 net/core/dev.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index febb23708184..af2d109b7266 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -148,6 +148,7 @@
 #include <net/devlink.h>
 #include <linux/pm_runtime.h>
 #include <linux/prandom.h>
+#include <linux/once_lite.h>
 
 #include "net-sysfs.h"
 
@@ -3487,13 +3488,16 @@ EXPORT_SYMBOL(__skb_gso_segment);
 
 /* Take action when hardware reception checksum errors are detected. */
 #ifdef CONFIG_BUG
+static void do_netdev_rx_csum_fault(struct net_device *dev, struct sk_buff *skb)
+{
+	pr_err("%s: hw csum failure\n", dev ? dev->name : "<unknown>");
+	skb_dump(KERN_ERR, skb, true);
+	dump_stack();
+}
+
 void netdev_rx_csum_fault(struct net_device *dev, struct sk_buff *skb)
 {
-	if (net_ratelimit()) {
-		pr_err("%s: hw csum failure\n", dev ? dev->name : "<unknown>");
-		skb_dump(KERN_ERR, skb, true);
-		dump_stack();
-	}
+	DO_ONCE_LITE(do_netdev_rx_csum_fault, dev, skb);
 }
 EXPORT_SYMBOL(netdev_rx_csum_fault);
 #endif
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

