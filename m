Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039D31D94E1
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 13:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgESLFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 07:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgESLFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 07:05:05 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B3EC061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 04:05:05 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id o14so13265355ljp.4
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 04:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eSIqIensD5kTG2OFw+qHkUDhInpNgbxwlYI4j1K7t18=;
        b=L0ht4p/tGakuoyM80/dCiPixROTO1LkEMU/rfKtruL9TSSa/OEvALjH5OcFP9gLyS6
         vXDc2TY6eOC2C/Qubmyu2NJmZDLr3mVdo8OZldYQ2hZtNPN316RdJZVHMxvArAl1kMdP
         BY+RdhwsLBsF4pvhY4oRLCal5/tZ0oCDAMspc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eSIqIensD5kTG2OFw+qHkUDhInpNgbxwlYI4j1K7t18=;
        b=Jvj6y2c16aCqUuyfr762i9SZQwXO0mXaovwH9kgFlK7WPIx7LpdL+KBNQv2lN0Kedw
         LM5z+QoQiKpquI4jMGdvWyteNRosWwAdRDzqQ1o0bV0vPnsrl1pmALy2bIpvItFd3Ub/
         k/4nGldTWqpNojVMfwyEpudq7lT52CL8KMOa4fNTx2afRlGX+pOizG+ZjfjLtcF0bvxs
         nfVtZbIaIhPZDtfj3tOrLtqCQPt7l2KvRDIID2UtgHDEx9gbo9xbPowp2LxiaCT5r9vl
         sjvnwOlkH3kEq19IhJj94wiMgRQG++5RkHFpHrejjnS2vNDwKcYBSTkWW4PnMg/OSWvK
         VnLA==
X-Gm-Message-State: AOAM533Q7ny9R28i2bm228MO+CZGMNp4TV1zvgef89xjrYapWR1O1Ihv
        5upyw0BEE4T/RC4a6PQv3EkWDKLWA3z4Yw==
X-Google-Smtp-Source: ABdhPJyV9vk6xAZjpp5NbfbgbLPz+QzNGLOz508e6Ap0pM7WuVw2d3gO2DObIhccCgCKFYYTmokQSw==
X-Received: by 2002:a2e:864f:: with SMTP id i15mr14036545ljj.179.1589886303224;
        Tue, 19 May 2020 04:05:03 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t30sm7959443lfd.29.2020.05.19.04.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 04:05:02 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net 1/2] net: nexthop: dereference nh only once in nexthop_select_path
Date:   Tue, 19 May 2020 14:04:23 +0300
Message-Id: <20200519110424.2397623-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200519110424.2397623-1-nikolay@cumulusnetworks.com>
References: <20200519110424.2397623-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the ->nh pointer might become suddenly null while we're selecting the
path and we may dereference it. Dereference it only once in the
beginning and use that if it's not null, we rely on the refcounting and
rcu to protect against use-after-free.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/ipv4/nexthop.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 2a31c4af845e..a6ffdb067253 100644
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
2.25.2

