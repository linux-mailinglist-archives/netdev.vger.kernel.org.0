Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30AD1D8D7F
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 04:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgESCOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 22:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgESCOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 22:14:40 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA4EC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 19:14:40 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id a13so3445515pls.8
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 19:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gM1khFbo54Dj8gffsTK3ggliXkocyz9R7J9sU9rV25o=;
        b=cNfsORm2hclxl5LIPUew/w5JuiGqqfVBueY6bP5VbkPYxpqErtTcWq0f8RDqMTExY1
         PWTk0aAlx/XWFUl5uR8qTRO6fEdYuWYjrL520gaZSgaQt5kxquWUFJ62adWGscWY2JDR
         Se5TL7cYZWcFQ5DpMXtmrZx16/8WkSVu8gZVk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gM1khFbo54Dj8gffsTK3ggliXkocyz9R7J9sU9rV25o=;
        b=C+ZiWXJS3qNHCgEbBIiGWiOK4PSTy6H0hSFURJVebrQUAUyQE0zbgI/DIF9WmGiDfM
         gVSP5nk8l4QobWGImzixzQ8bavKifoh2UPgiHNcfnqXbSlEYFnj0qjXUL58xQ1eJbV4x
         m4G2AOGOtLFsy2gTJb04T/i6GQgp+pjw+1ozcWexEB/9IIAz1lwbCaQtks9wW+ggPEMp
         BCDAyvFqryfeIbGw1pZwEckJWb9EEJxhRuxncs1sU8WXcNMp6oJAKvneW9QaQOaIYQxU
         En0+qQvSuEYHgKWaHssFwP/uLdeMyDBfs2L38mlW5iVTB4I6XkO/B8fuNz856v+chQMP
         n3oA==
X-Gm-Message-State: AOAM5302B7NDtgohs4cTFokypVrvoPzvbRl818X/TdZtWAhjDCtG0cLg
        bsevjcVRjJzga48pXz2/HSgEcQ==
X-Google-Smtp-Source: ABdhPJzIPTvz4AoDyUgmjBkdpr/byA5ZOZZVoKpqLDdq1rdo6FghysUd3rlw/KkG3NiyW0rRRNPZUw==
X-Received: by 2002:a17:90a:d3d3:: with SMTP id d19mr2390631pjw.42.1589854479984;
        Mon, 18 May 2020 19:14:39 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id 5sm664753pjf.19.2020.05.18.19.14.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 19:14:39 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next 1/6] nexthop: dereference nh only once in nexthop_select_path
Date:   Mon, 18 May 2020 19:14:29 -0700
Message-Id: <1589854474-26854-2-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
References: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

the ->nh pointer might become suddenly null while we're selecting the
path and we may dereference it. Dereference it only once in the
beginning and use that if it's not null, we rely on the refcounting and
rcu to protect against use-after-free. (This is needed for later
vxlan patches that exposes the problem)

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 net/ipv4/nexthop.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 3957364..992e841 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -490,28 +490,33 @@ struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
 	nhg = rcu_dereference(nh->nh_grp);
 	for (i = 0; i < nhg->num_nh; ++i) {
 		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
+		struct nexthop *nhge_nh;
 		struct nh_info *nhi;
 
 		if (hash > atomic_read(&nhge->upper_bound))
 			continue;
 
+		nhge_nh = READ_ONCE(nhge->nh);
+		if (unlikely(!nhge_nh))
+			continue;
+
 		/* nexthops always check if it is good and does
 		 * not rely on a sysctl for this behavior
 		 */
-		nhi = rcu_dereference(nhge->nh->nh_info);
+		nhi = rcu_dereference(nhge_nh->nh_info);
 		switch (nhi->family) {
 		case AF_INET:
 			if (ipv4_good_nh(&nhi->fib_nh))
-				return nhge->nh;
+				return nhge_nh;
 			break;
 		case AF_INET6:
 			if (ipv6_good_nh(&nhi->fib6_nh))
-				return nhge->nh;
+				return nhge_nh;
 			break;
 		}
 
 		if (!rc)
-			rc = nhge->nh;
+			rc = nhge_nh;
 	}
 
 	return rc;
-- 
2.1.4

