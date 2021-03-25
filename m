Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B487B348E0B
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 11:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhCYKbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 06:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbhCYKbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 06:31:11 -0400
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E96C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 03:31:10 -0700 (PDT)
Received: by mail-wm1-x34a.google.com with SMTP id n2so1501462wmi.2
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 03:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=dLw4VRosCkcZw85W/pqml6ocuJW2bn9GiHagNmFx+8U=;
        b=Bf5ebED3GpabknwxA53RGJzTH7lTgdn22pnG8hkWiSy0ulq7dYOwCFduXnv8+EYfGr
         VE4uYG/PyUKhvusQRxDxsv4ujB6f05W/QZ+WGhEkduABSWt1uxv7DjXu0wEZfppWRmCK
         ddkJOF6Ke3U345SAuTSXWu+jBqzEdc9pd10kHrQk4tVm19ccCdUpzhqevmqfALQmC67m
         LaV1/AfrVpCFQ+awQgHcesBAA0LOa1BLyRSEokVlEfDz8K2LFje5cPvM5JMxMpj/l/o+
         gg0JV65ZOPz+ztHqRx8D0TLF92Hh0Ttxcckcn1eA/nN6wEHB/T7nIWvDokcsjTedgGV3
         1ryA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=dLw4VRosCkcZw85W/pqml6ocuJW2bn9GiHagNmFx+8U=;
        b=AySUYw1Okv1DUdMOkx63GHGBvGJ0K2WUyjxlRpC/eLEV1XjAZhG/YW9ihxF1NGmtpZ
         bi08xGcfPVL90aDvrK7cU/H/A6TRKw/kTjA0FnVUNVO/B7V6me/LLpDNNRPfq7+VQqwa
         ND30h9+a0Q76PyegbH0pDfCwJWsBUPbYmh3mWLZebLhE2+JD3XGz8xvTEolK9ZgEBnbo
         F6CGTAJEbXja6NGewWcfmJNqX0y+NBSznPLTRa55wNK7oAc2xBB5qfamYAU6+PPWqf1A
         WobcjOvghLE4nQDNNIehjnj6O+qvlnTwCSXts6k531jab7Fs0XZdSdPIKcUkq7gErUpu
         GAdg==
X-Gm-Message-State: AOAM531FbLfZKFOeAoILn9s1dtUDxNIzJdaKs+zsDKy1y642WGNmwP4S
        C8Aftr0WOEivSiMvFMwBekLdEngo62qx
X-Google-Smtp-Source: ABdhPJz2gE/3uf2IECinj1iOuPsPf+EOohmNIGs7zU6PAJNFr7DoRP57q7FXuPGLz7QHPPRoECb2yqID8ceR
X-Received: from dvyukov-desk.muc.corp.google.com ([2a00:79e0:15:13:8903:2da7:c857:1a50])
 (user=dvyukov job=sendgmr) by 2002:a05:6000:23c:: with SMTP id
 l28mr8410551wrz.251.1616668269433; Thu, 25 Mar 2021 03:31:09 -0700 (PDT)
Date:   Thu, 25 Mar 2021 11:31:05 +0100
Message-Id: <20210325103105.3090303-1-dvyukov@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH] net: change netdev_unregister_timeout_secs min value to 1
From:   Dmitry Vyukov <dvyukov@google.com>
To:     edumazet@google.com, davem@davemloft.net
Cc:     leon@kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev_unregister_timeout_secs=0 can lead to printing the
"waiting for dev to become free" message every jiffy.
This is too frequent and unnecessary.
Set the min value to 1 second.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Fixes: 5aa3afe107d9 ("net: make unregister netdev warning timeout configurable")
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/admin-guide/sysctl/net.rst | 2 +-
 net/core/sysctl_net_core.c               | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 2090bfc69aa50..c941b214e0b7f 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -320,7 +320,7 @@ waiting for a network device refcount to drop to 0 during device
 unregistration. A lower value may be useful during bisection to detect
 a leaked reference faster. A larger value may be useful to prevent false
 warnings on slow/loaded systems.
-Default value is 10, minimum 0, maximum 3600.
+Default value is 10, minimum 1, maximum 3600.
 
 optmem_max
 ----------
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index d84c8a1b280e2..c8496c1142c9d 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -577,7 +577,7 @@ static struct ctl_table net_core_table[] = {
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
+		.extra1		= SYSCTL_ONE,
 		.extra2		= &int_3600,
 	},
 	{ }

base-commit: 84c7f6c33f42a12eb036ebf0f0e3670799304120
-- 
2.31.0.291.g576ba9dcdaf-goog

