Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD561D94E2
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 13:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbgESLFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 07:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgESLFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 07:05:07 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48A6C061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 04:05:06 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id z6so2251103ljm.13
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 04:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uoyuPqJL+YpP54xcKRDlWfAKsafN7+WQZupPCP2W3fM=;
        b=azLxVH2sr8CvTXodq79b+mS5zP8WQoY9LT8avBEIPHUxpLK1uDgr1HDTFVIG7Uo1UP
         Xs5Mi7lBYsT3+OZGPIyW5U2sQTeT/TpKlq5ckm0p56RFdB2zUYQOdr2C29KR4KTvCSkw
         SBFRaoGMe7jANVcO/UmuiOHXsV5ZXX/VFQ66E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uoyuPqJL+YpP54xcKRDlWfAKsafN7+WQZupPCP2W3fM=;
        b=bf4KhammnVp7OUjuYlD1Ioic4rmOMRV8H0T4ZHBkY5sa0QIAH45mqYP+uxVobhAtVI
         /4DJGrTGVXkt9JNDCXYrFxf0tmrvb2fwGq9lM/O63iwnJWYjJBJ+NLZUXnKsrXl2hlQW
         1mZdh7unnq1w/bmgw1sMLJt/3hUrKTvROHuRCZ/NJpp3IvWCe8Cyz1FYgdn8xbqwFBff
         O79mctDT9T03FBZ7s66U1IdFi/EAa9/dLbZzO59B0EKJi6uH2RCbJcUCbu2GhgY7pVRb
         kirizfi/PTogjws4g55+sxryqj+ynUh1dsYPG7jAdPxcaYDFQVqSQxYpMuLfQbDMhhr0
         jP6Q==
X-Gm-Message-State: AOAM530E+Ebo8XGfTlTpQYpcaN+Srrl4RVdWFZwPrZKQnmSQG0VoyryL
        FduzXsQLj+AP3c23igxGqTkeugfAPpll8w==
X-Google-Smtp-Source: ABdhPJzu7/JBbxOqd2KjZOdy4hBG0Re50TMtfINCMPBRqRpoCEO4DHyvRjaPFt4jH28Rxk7NDwTG7Q==
X-Received: by 2002:a2e:958d:: with SMTP id w13mr6820855ljh.207.1589886304714;
        Tue, 19 May 2020 04:05:04 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t30sm7959443lfd.29.2020.05.19.04.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 04:05:03 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net 2/2] net: nexthop: check for null return by nexthop_select_path()
Date:   Tue, 19 May 2020 14:04:24 +0300
Message-Id: <20200519110424.2397623-3-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200519110424.2397623-1-nikolay@cumulusnetworks.com>
References: <20200519110424.2397623-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nexthop_select_path() may return null if either .nh is null or the
number of nexthops is 0 (rc == NULL). We need to check its return value
before use to avoid deferencing a null ptr.

Fixes: 4c7e8084fd46 ("ipv4: Plumb support for nexthop object in a fib_info")
Fixes: f88d8ea67fbd ("ipv6: Plumb support for nexthop object in a fib6_info")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
Could you please confirm that simply returning in the IPv6 case is ok?
AFAICT it's fine, I've also tested it, but I'm a bit worried about
ip6_pol_route_lookup -> ip6_create_rt_rcu and the second directly
deferencing res->nh. I think rt6_device_match() should take care of
that case, but I'd appreciate more eyes on that. :)

 include/net/nexthop.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index c440ccc861fc..7cc4343cdbfc 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -203,6 +203,8 @@ static inline void nexthop_path_fib_result(struct fib_result *res, int hash)
 	struct nexthop *nh;
 
 	nh = nexthop_select_path(res->fi->nh, hash);
+	if (unlikely(!nh))
+		return;
 	nhi = rcu_dereference(nh->nh_info);
 	res->nhc = &nhi->fib_nhc;
 }
@@ -290,7 +292,8 @@ static inline void nexthop_path_fib6_result(struct fib6_result *res, int hash)
 	struct nh_info *nhi;
 
 	nh = nexthop_select_path(nh, hash);
-
+	if (unlikely(!nh))
+		return;
 	nhi = rcu_dereference_rtnl(nh->nh_info);
 	if (nhi->reject_nh) {
 		res->fib6_type = RTN_BLACKHOLE;
-- 
2.25.2

