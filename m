Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE7F4A6987
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 02:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243636AbiBBBNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 20:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243631AbiBBBNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 20:13:17 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79ADFC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 17:13:17 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id y5-20020a17090aca8500b001b8127e3d3aso4419155pjt.3
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 17:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1yfjqxRjSP8MT5gsQb3DyZFYqyWlknDY7YCco0qbtPE=;
        b=PkPJsuhGl6ADqWE1Fco3J+iMxYdhrFNnCz3/BXwPQC7/SZ3QaHEFOWzHEyBZDYJIzW
         bUcaY6AquWSQtvQjJMRWr10bs5tl+XJGkGBfrxhMCypJ7IGr/SQiaz4TrUi3mJypgZrC
         iHBqPOyWF6WK4h95/lSeUIpieFmqMf3Le9em0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1yfjqxRjSP8MT5gsQb3DyZFYqyWlknDY7YCco0qbtPE=;
        b=P9D3OSPC1cQCa0HxC44LHSkbq2LHY7ajVOgLl+8Q/GsA7YN2usM6p4tZ5DKISvTkPp
         IV+Q/ejJI9rtfa9ndaURXYGJhyUiU8Wbr5sP2B/D/UvcjQLGTv0L2LhKdWbS7G/AXpgD
         MLz4Exet97mdAZ096KdyJ2gvJuTmgsj4GXMyaVr66xvcGLwGNQpdql0Y+lcwSzVFBJKs
         Q0++lBb8Qw+CYvFQGb+pT94eg/coLA1U9YpX3+vnwj1IYtnfSNdTjiC8WcvLNON0PxfE
         mh1O4W/bHcY2vSIVa0//LwV9CaZnOrRVpN0LmQtOL82Y75FOY+UstXfWqhXCvo1b3eP/
         Z3bg==
X-Gm-Message-State: AOAM5322OPj6Dlabs+LpQscD5xVfAWa6at3IzqRZHUJuJR0STY+RRLAO
        bITTwNy1ANETSPzGLvL6Xiji/lSiGQJM8pNPDHVlWS0WTrYHvvWFZpOU1wOKjQ6iF6ebNPJKteo
        LT1+Z4Dgzw25CWGNrpcf5/v8Q3/4531LtRFkdKZxo26/cyHQgWIUZsY6Oz3wdf0BdUhYA
X-Google-Smtp-Source: ABdhPJw+h5f8g7rz+kbNVGdPQzpmQ4AHC6n9TKHh+Rrbwcsjq5k/2ZSz710TFGY8SGQlVNcvB/8TNQ==
X-Received: by 2002:a17:90b:3b46:: with SMTP id ot6mr5496954pjb.179.1643764396560;
        Tue, 01 Feb 2022 17:13:16 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id a125sm15170025pfa.205.2022.02.01.17.13.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Feb 2022 17:13:15 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v3 06/10] page_pool: Add slow path high order allocation stat
Date:   Tue,  1 Feb 2022 17:12:12 -0800
Message-Id: <1643764336-63864-7-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
References: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
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

