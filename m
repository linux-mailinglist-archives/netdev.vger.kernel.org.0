Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEEF4A32AB
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 00:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353458AbiA2XkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 18:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353450AbiA2XkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 18:40:15 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CD4C061741
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:15 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id e9so8673670pgb.3
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dWVvR+duDBC2ViqiU0poNo4IacKATL/f4uhXaP1KcDU=;
        b=vDCTaCjzVNItlFSD0Cdk1R9P2yvfWqh2XavR8xBJz1NkWLOBgQqKlBVOFu3SzrJ9s6
         J+U26zf6N35EpixJzAJXdwT5YktcoFSi6MZ1GW+s0LRru8YKCgN2T5I+tNj4NQf2R1Di
         80ekE+1v+ygmJirr3+aciXzYd8X+CaSZZ2lxM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dWVvR+duDBC2ViqiU0poNo4IacKATL/f4uhXaP1KcDU=;
        b=inHML9P2jeK3tPTFY265zTybMS/8G3K+psJcLBXGZS96shiGTRXityjPKdtx8wTWWR
         b4dxfsiefQ/eeDYGC7pszF10Cf6xgGXktbL11+mhh53UyMB3lBKFe2oSsgqijnhpSPvq
         pp8DTrkRsSfH9iM8xxiN/2ktWhGXorNLvu9Milqy2WquQu3FumI18QqHtlxcb8Ym9ftA
         5PDn46UeZoBP2mDvvQRLif6mN2fwCzX4N7obJ5SHa9sQtCldWATR5CyB8Yp9VidwbiRZ
         CrHtZowl9LnRkgFFWHOOV0oxMZoNXdK2xOVXSZpUCVWssj2Cb+3Dhq2A6yZMQSpF7Vy/
         zkaA==
X-Gm-Message-State: AOAM533SgRGJcbQJTTV3UDTqTUI9n5ja1eOH/A5EjeEc+Su52mIiFXBC
        I085dH+Wup9NK79aoxVTxfyWnSeOD3vILk/fTPkrnpW+YKTJ/0+C3+SpIeiah5gE4oEagccT55A
        9ZEvnqUPAqdxw5S42vuvO9qObczklYW1coF6BWKlR6qM2IQThPjj9wWYIJbsfImuDBJAT
X-Google-Smtp-Source: ABdhPJwCAEKNiby2vYMUg5GSdivJHWkvhT6YTDTgBuFSbtKFYtSLzmJYq0pVZXhJJivGZSHI7Unm+A==
X-Received: by 2002:a63:5146:: with SMTP id r6mr11511954pgl.455.1643499614536;
        Sat, 29 Jan 2022 15:40:14 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id gb5sm6573276pjb.16.2022.01.29.15.40.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jan 2022 15:40:14 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v2 08/10] page_pool: Add stat tracking cache refill
Date:   Sat, 29 Jan 2022 15:38:58 -0800
Message-Id: <1643499540-8351-9-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
References: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a stat tracking succesfull allocations which triggered a refill.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 1 +
 net/core/page_pool.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index ed2bc73..4991109 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -149,6 +149,7 @@ struct page_pool_stats {
 		u64 empty; /* failed refills due to empty ptr ring, forcing
 			    * slow path allocation
 			    */
+		u64 refill; /* allocations via successful refill */
 	} alloc;
 };
 
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9d20b12..ffb68b8 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -185,6 +185,7 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 		page_pool_stat_alloc_inc(fast);
 	} else {
 		page = page_pool_refill_alloc_cache(pool);
+		page_pool_stat_alloc_inc(refill);
 	}
 
 	return page;
-- 
2.7.4

