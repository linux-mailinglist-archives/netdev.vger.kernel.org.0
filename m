Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73BF3E4C75
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 20:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbhHISy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 14:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235728AbhHISyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 14:54:44 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22F0C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 11:54:23 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id a8so29443247pjk.4
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 11:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=//U7CCUPzkVvZ039FxiY1y0/h8feXKOhmvxH+6Q1sis=;
        b=v25vMxYxO/agrKT52zVHWt8qJXrauYqHvubPagKkwUw5mOm7nAR93FJSJO1SUclwR7
         3ZYxRvOKdfWSp3QTOPuKgkC05zTvn2cz3lOP8mYsdkoWUxSl19NKoAEf4281nDzhkbBH
         gl4Hm2/DWHPaItaRxjT4m7C4PR59Ad3XkCoqdDHV5KIFG+hpgUZKM/qEkXn7l7bi5wUR
         btNEM+o3MXgRMmgJYG15fhK4Nyg/NOEtdXJAAjwRAHU3NBuejU5fP7McUnA0A4PHlQIA
         wdPDHNhjRaPc50tCefcBHtapGIJZ5Ugc0yJYLJS7IB7F8QXw6Cxhr1zZdckkVNwxT5nq
         hqPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=//U7CCUPzkVvZ039FxiY1y0/h8feXKOhmvxH+6Q1sis=;
        b=qbjDYpXKxBpMYrjA6aVsGDUN+XuwXbAzgQbT/5wkGvL7BLk366zFW1So1Q+4ln+BB6
         VrnFhpqj8Lz8ZmiJAmf1xCtBGyB4VrNaigmaI19gaF4Az8A5FZDjJm7OrEzFXEcZClTQ
         rG7fDtXdNnsa9CAVeoc39J9uyGjy9LUBfQY1LgLfm7X+uWmy21sEDJSwi4OUgtcgLXRo
         3TJMWuWI1ncuyOQnmBsKDbdTk1gBhCM2m8QFj01LETswXvHoj/fvOpTpG+AI6YH+ZegG
         8kB9qyAygorMy3XVVYQTMpJNcfKutxVRivQH0JSZ50dQvWv+lLMcYbOp7sGI1eIjtaUs
         W33A==
X-Gm-Message-State: AOAM530isZCR2f8O8T7bftDfpGtYH7XF4jnYr/OIObriQ7cM8OLmqyXp
        vqwvVfS9oUYSrOigRPfW6+8Usk3PGOVltIUd
X-Google-Smtp-Source: ABdhPJylgmEFP+voHLEdFmuoSUG/qWGVS/qN8+QTxkZL5y1Wa5BAJe96z8UAoatf29ETn8Hkf1TIwg==
X-Received: by 2002:a65:468c:: with SMTP id h12mr223437pgr.423.1628535263009;
        Mon, 09 Aug 2021 11:54:23 -0700 (PDT)
Received: from localhost.localdomain ([12.33.129.114])
        by smtp.gmail.com with ESMTPSA id b28sm21255364pff.155.2021.08.09.11.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 11:54:22 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, brakmo@fb.com,
        ycheng@google.com, eric.dumazet@gmail.com, a.e.azimov@gmail.com
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH net-next 3/3] txhash: Change default rethink behavior to be less aggressive
Date:   Mon,  9 Aug 2021 11:53:14 -0700
Message-Id: <20210809185314.38187-4-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809185314.38187-1-tom@herbertland.com>
References: <20210809185314.38187-1-tom@herbertland.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Revert the default rethink behavior to only do a rethink upon negative
advice (at three RTOs with current defaults). This is less aggressive
than the current default which is to rethink the hash at the first
RTO.

The rationale for this change is that IP anycast relies on consistent
routing and changing the hash may affect the routing of the packet
For instance, if the hash is changed then the flow label used for
a TCP connection is changed and so the routing of packets for the
connection may change. If the destination address is anycast, a
route change may direct packets to a different server than doesn't
have state for the connection thereby breaking the connection is broken.
---
 net/core/net_namespace.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 03d3767e6728..bf9696dd7106 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -367,10 +367,8 @@ static int __net_init net_defaults_init_net(struct net *net)
 {
 	net->core.sysctl_somaxconn = SOMAXCONN;
 
-	/* Default rethink mode is aggrssive (i.e. rethink on first RTO) */
-	net->core.sysctl_txrehash_mode = SOCK_TXREHASH_MODE_NEG_ADVICE |
-					 SOCK_TXREHASH_MODE_SYN_RTO |
-					 SOCK_TXREHASH_MODE_RTO;
+	/* Default rethink mode is negative advice (i.e. not rthink on RTO) */
+	net->core.sysctl_txrehash_mode = SOCK_TXREHASH_MODE_NEG_ADVICE;
 
 	return 0;
 }
-- 
2.25.1

