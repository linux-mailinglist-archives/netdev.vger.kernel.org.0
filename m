Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71B14A917B
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356160AbiBDAK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356174AbiBDAKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:10:54 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B36C061401
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 16:10:54 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id e16so3660664pgn.4
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 16:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6YfR8wWEKlkfuLAKubG6N8BAv3Qg/s/kRTiUe01e+q4=;
        b=dow8iX/fA8NTU3euLf/9nIYxu5qqBZE7eQhbOBaZU/FQVxsHn2XYQzkTzVA05S3UhT
         +cFxV8ss8IkLNO3lwEc7enUzdzPCBZZOHStBe8ZjDehtd1IR5G5Laz1c/eKWvSJGzP18
         f1S4VzHCuxR0booppJXWV7QsbA2dKOIYAJfEo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6YfR8wWEKlkfuLAKubG6N8BAv3Qg/s/kRTiUe01e+q4=;
        b=w5nCYdN+gt3Oz6Fj89cmoHAgzcxEOWXIHQiBZMOJ0oGDoGWWgyBab0HmrRV/9Y3voQ
         B4BjJnsmhyVl7UM5P/QOVvMPeChusu6kI8CXDuKLTxFc//9bp1XbEVRHvtInNDvm0W0b
         u+v4YW/hD7hyOyBcf1+scerl/GoJu7NrsGzVtlyVIHzco+CDa6w6ofcfOXab7+oACRbC
         Lvv5cQjZQjSr8QrfGLeTFZ46tpZGXOSHU1q1syrzpcZDvgex/nL6SEHd7riejCt/x7/U
         pVjecTpj+nFkkISfPpJ6crBIDYzoTQNypOIIJAGSMbVEzQSxtea3zeAW/Z014Pb1FruC
         QbGw==
X-Gm-Message-State: AOAM532dcB5dg1ouZM/eU728OT67wPpMFNMQ4m6vsUbRlSdGr9V78bKV
        OdHWD6JLKVZK96hphaez9oc48hjFQ93JCsldlnc/Xbmsb6t8/e9pwuwAnlSJX0eEA8h8XhFno80
        QX46LGqR9hY7vWR0NtuyEeNY7js60o1xUNeBX28rCXjMKU1dExehNdNTPLzwHDeSIkIWt
X-Google-Smtp-Source: ABdhPJzCKpCFrETMdz0E1VC6Zno37IYkdWbiPGd4QTyCQ2WKu3F1mZ9LfP7g9m+zJQPehpCLYAgHKA==
X-Received: by 2002:a65:414a:: with SMTP id x10mr414070pgp.125.1643933453793;
        Thu, 03 Feb 2022 16:10:53 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id z22sm159822pfe.42.2022.02.03.16.10.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:10:53 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v4 07/11] page_pool: Add slow path high order alloc stat
Date:   Thu,  3 Feb 2022 16:09:29 -0800
Message-Id: <1643933373-6590-8-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Track high order allocations in the slow path which cause an interaction
with the buddy allocator.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 1 +
 net/core/page_pool.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 7d5f202..0c4cb49 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -145,6 +145,7 @@ struct page_pool_stats {
 	struct {
 		u64 fast; /* fast path allocations */
 		u64 slow; /* slow-path order 0 allocations */
+		u64 slow_high_order; /* slow-path high order allocations */
 	} alloc;
 };
 #endif
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 264d8c9..b7d0995 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -259,6 +259,7 @@ static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 		return NULL;
 	}
 
+	this_cpu_inc_alloc_stat(pool, slow_high_order);
 	page_pool_set_pp_info(pool, page);
 
 	/* Track how many pages are held 'in-flight' */
-- 
2.7.4

