Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383CA4A32A9
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 00:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353455AbiA2XkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 18:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353457AbiA2XkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 18:40:12 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DFDC061714
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:12 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so14461116pjj.4
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1yfjqxRjSP8MT5gsQb3DyZFYqyWlknDY7YCco0qbtPE=;
        b=Jld+fVN1MmC8B9Y5uVQxx943tmXn52z1JrUV/yXWVc+VefgOvQZPDYvJUICFlH+wFl
         J1LciNCZ0psL3O9j2/hZzA99hDjec5V3piqZm8xHYriqI4AtowmKDNil/i9oSLBC5wry
         NCo/2jkaW3GpsAEawemNQSDl8JKxVvbZYz6vA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1yfjqxRjSP8MT5gsQb3DyZFYqyWlknDY7YCco0qbtPE=;
        b=3B1eJ9QR2i/XSxzc6qB6Wyf0wuiBGtqdUL7ldYInvSYjwTK7YVZyTTYE52cY0xCScE
         NwLof3zkwFfU/Hhow9hQcuU+WYVzTAeddhHnrVILbdNsk4g/5qjzltvmGPshi11wO4gj
         RZkcR1k8EEvxdpkmddmouGlnsN6dmahfqReE7J/CTS9ys4FMMZX2S4WNiEJxrUGV8x31
         ylKR+beHItvJ5X36syMOYu9ggCQ8IuDqIIQzKsDuX2rv4YdVAIGwaGPDF4nttuOmvxDs
         VEVwP0GnZaGKdzhmr5ZYCSX4vLy98OlPwoeU9qQIpuvCllpAsljWBiXGMZBr9LEfY11G
         oVKA==
X-Gm-Message-State: AOAM5338yXQ0MEj2ISzX/vT1y3dyries06DRAerV2HeNdnWTV7OIJ8Mp
        7NVl3OJRJxLrHDuwV/dX0q1LocIUWUQneYM3OKFbUlKqaqy64flNQVtPfq0oY5wukUzkIYTc3iF
        Xgz+EKbc45Au8ksoKx+F3IWKwnKox1w+FSEEPN+it5JvCqmZmYDc4vEWhMh2AIb9dHnUu
X-Google-Smtp-Source: ABdhPJyMIGYD3PAkmLbq6qgfhvV51QSJBYVUyZee9IFRKYlCH9Qmq7bz1YMvr4ASzRZWap4xd/2G8w==
X-Received: by 2002:a17:90b:2243:: with SMTP id hk3mr21308254pjb.181.1643499611787;
        Sat, 29 Jan 2022 15:40:11 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id gb5sm6573276pjb.16.2022.01.29.15.40.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jan 2022 15:40:11 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v2 06/10] page_pool: Add slow path high order allocation stat
Date:   Sat, 29 Jan 2022 15:38:56 -0800
Message-Id: <1643499540-8351-7-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
References: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
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
index ab67e86..f59b8a9 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -145,6 +145,7 @@ struct page_pool_stats {
 	struct {
 		u64 fast; /* fast path allocations */
 		u64 slow; /* slow-path order-0 allocations */
+		u64 slow_high_order; /* slow-path high order allocations */
 	} alloc;
 };
 
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 554a40e..24306d6 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -254,6 +254,7 @@ static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 		return NULL;
 	}
 
+	page_pool_stat_alloc_inc(slow_high_order);
 	page_pool_set_pp_info(pool, page);
 
 	/* Track how many pages are held 'in-flight' */
-- 
2.7.4

