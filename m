Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BC63505D8
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 19:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbhCaRxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 13:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234514AbhCaRwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 13:52:30 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3721DC061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:30 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so1581502pjc.2
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5uLhSHaWYKzXQJcTFkj0+rCG5g90ufvbrRzEZYu+vmg=;
        b=Y+zp9ECcLwjZOpO+YSq7Fy/0pQpiG8QSEyC4aCLixHYxvsXqQKGOD2HRElDUHaktk+
         PmnUQMcmh1FHnTT8nXGQVQBFfY7tL53vJpZaArZfMKWz5xcZjc9Ji0V2YkvnoTCPIvHp
         1WRtdJVbbCegXt/Q2pLs0WPs4DO1p8x5NLDwo+/rd3/ysh7tYjGMXz99R8/a4UxY/UYD
         g3yKDiP+yxLpu5vo93FGgs8fYWS5GVVhA+Dt109I9NgivstQGQ/+LPhj/Ofq5L7JBTne
         1NLpmtr4jC6zVo9lvDR+eYPynq5lNyfWYp/AkUI2SH+wvIFlyzFuq5Q0zIWL/gtR2Z+0
         HJCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5uLhSHaWYKzXQJcTFkj0+rCG5g90ufvbrRzEZYu+vmg=;
        b=AVVT/GVxLyHyvIunlBjEppDWjF+3hk7MiBrtWk5jv/HQ9w7zpGqV6kleTzL0Mr/FYZ
         7OtlXvFrQG/177L5X9eA244zAaRBo4HbE+KChRPKh0f+lbIk1Bc2yASQzzjEFxqcnt+e
         G9NoP92Mhpa3rsb0e3x9do+SCvsbqf77bdQHFRYJy9aj5fzEsTWtWU5XLEke7SOsnchV
         adrpg+npM0c9xs5/HhUESWlIQg0UCMfx0/8Ag0xVzYJNtj1tecMxt5rws3Reu2I3yhV6
         stMc7Tg1s3UxxdH+udLTXyhdhex6fhk3AmDv4sQAnQhAMFOPUmJdjSumEGX1Sukn4a3x
         mLTg==
X-Gm-Message-State: AOAM530HX+Ie6ZxnFkJF6hoM4tWfsyNowpBeeU3g1KHkMXiek4wpeimx
        /dLEXhGqIn7yJfGetO6uUgE=
X-Google-Smtp-Source: ABdhPJzHYLnm/eiTEXMIOlnskACHKtqqWqpkWvtwUG4gICsZX1y9q3BKNz+y+Lmj+xsF9Zh+lyKPIA==
X-Received: by 2002:a17:90b:608:: with SMTP id gb8mr4549363pjb.121.1617213149868;
        Wed, 31 Mar 2021 10:52:29 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9107:b184:4a71:45d0])
        by smtp.gmail.com with ESMTPSA id q17sm3319028pfq.171.2021.03.31.10.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 10:52:29 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 9/9] ipv6: move ip6_dst_ops first in netns_ipv6
Date:   Wed, 31 Mar 2021 10:52:13 -0700
Message-Id: <20210331175213.691460-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210331175213.691460-1-eric.dumazet@gmail.com>
References: <20210331175213.691460-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

ip6_dst_ops have cache line alignement.

Moving it at beginning of netns_ipv6
removes a 48 byte hole, and shrinks netns_ipv6
from 12 to 11 cache lines.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv6.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 84f4a8bec397dc5a15d84fae118cda33d87671bb..808f0f79ea9c9b9094dc94b71e295e26a9202ad1 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -55,6 +55,9 @@ struct netns_sysctl_ipv6 {
 };
 
 struct netns_ipv6 {
+	/* Keep ip6_dst_ops at the beginning of netns_sysctl_ipv6 */
+	struct dst_ops		ip6_dst_ops;
+
 	struct netns_sysctl_ipv6 sysctl;
 	struct ipv6_devconf	*devconf_all;
 	struct ipv6_devconf	*devconf_dflt;
@@ -76,7 +79,6 @@ struct netns_ipv6 {
 	struct hlist_head       *fib_table_hash;
 	struct fib6_table       *fib6_main_tbl;
 	struct list_head	fib6_walkers;
-	struct dst_ops		ip6_dst_ops;
 	rwlock_t		fib6_walker_lock;
 	spinlock_t		fib6_gc_lock;
 	unsigned int		 ip6_rt_gc_expire;
-- 
2.31.0.291.g576ba9dcdaf-goog

