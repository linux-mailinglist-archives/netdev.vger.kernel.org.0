Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0913236876C
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 21:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239051AbhDVTsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 15:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVTsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 15:48:31 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EE6C06138E
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 12:47:56 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id gv2so13361846qvb.8
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 12:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GUNg497FpZ8teQXdqiLqOVPoiukxMOOVSjbroCtlrzw=;
        b=RXJW2XuTjJdwhdR+WgkSZgJGdmWf5XFY7QeVgCLMy7qioFqhuUd9WLt2owjnwZpkH1
         pvK6jN9jt2Cz0ckOx4hd1IIx6orBFtV4/2VF0HJjGeyrFapYt7be7NC3KX12/PccWBdZ
         52THKsDlpNQd6RZTPP26pxN+kn2BgDALm4i14bSBM2nhujv6852js8nXzDcIMxqtlKUd
         5Ds70qE+wOhhNwvPU0Cq7DA7ehynsarh+dkbbczVC4Ke2NLkK/vH45XThLyxjEFzOjH6
         JXZpjJQuSqeSPCfAOLXdlVpXUhy1vhkctCa2zDMCtKyr5h+q8y7VzYBTu25HLXcX+ir0
         x+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GUNg497FpZ8teQXdqiLqOVPoiukxMOOVSjbroCtlrzw=;
        b=IRBDnDtF9CLLEIgvrwObbQQdeX9e+6dLCBehP4S0bFo3atuPlvCBPKcs3AsRcI0+oU
         MZL2WU8D8J83ZwtKNORFPTNf/E4v38t3vWgt6QinhOa9BEuUco33C09Asu7rDByaFcd/
         EBvywwtzWWIii6fLbtG5Y0SigePbAT+j4Zt/BzA3h4o/t8ZupVTTOnIixDYgfGv9AnrB
         p23MWew2MWm2Srgokhgxd3Y+Mlor2WOiDAykTVMbxmhqdshFBnhdW0+iN3RVSW51ljxM
         50tr6zJ2FMM5M7XT+Yd/29DspmRenCZ6KtV6/RZapH6fgQml0jDosG+vBO3UxnqwKvgy
         uYqQ==
X-Gm-Message-State: AOAM530k+hfuCDLLAkFRpJBDHRv/nOFqWcDOmMRmukaG85i1QtqoLlPE
        F6lQG/qvxwP/B5zAYrKtb1EcwXRXKew=
X-Google-Smtp-Source: ABdhPJzRYVFg/e1orm/wMfGEYZYUiwzz1NExHDQQ5xZeAH0e9Rhsj1vEex/cS6gGK9jc7a11FDCGmg==
X-Received: by 2002:a05:6214:5ad:: with SMTP id by13mr345646qvb.15.1619120875535;
        Thu, 22 Apr 2021 12:47:55 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:e069:ac66:9dd7:6f76])
        by smtp.gmail.com with ESMTPSA id a4sm2821781qta.19.2021.04.22.12.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 12:47:55 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Subject: [PATCH net-next 3/3] net: update netdev_rx_csum_fault() print dump only once
Date:   Thu, 22 Apr 2021 15:47:38 -0400
Message-Id: <20210422194738.2175542-4-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
In-Reply-To: <20210422194738.2175542-1-tannerlove.kernel@gmail.com>
References: <20210422194738.2175542-1-tannerlove.kernel@gmail.com>
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
 net/core/dev.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d9bf63dbe4fd..26b82b5d8563 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -148,6 +148,7 @@
 #include <net/devlink.h>
 #include <linux/pm_runtime.h>
 #include <linux/prandom.h>
+#include <linux/once.h>
 
 #include "net-sysfs.h"
 
@@ -3487,13 +3488,16 @@ EXPORT_SYMBOL(__skb_gso_segment);
 
 /* Take action when hardware reception checksum errors are detected. */
 #ifdef CONFIG_BUG
-void netdev_rx_csum_fault(struct net_device *dev, struct sk_buff *skb)
+static void do_netdev_rx_csum_fault(struct net_device *dev, struct sk_buff *skb)
 {
-	if (net_ratelimit()) {
 		pr_err("%s: hw csum failure\n", dev ? dev->name : "<unknown>");
 		skb_dump(KERN_ERR, skb, true);
 		dump_stack();
-	}
+}
+
+void netdev_rx_csum_fault(struct net_device *dev, struct sk_buff *skb)
+{
+	DO_ONCE_LITE(do_netdev_rx_csum_fault, dev, skb);
 }
 EXPORT_SYMBOL(netdev_rx_csum_fault);
 #endif
-- 
2.31.1.498.g6c1eba8ee3d-goog

