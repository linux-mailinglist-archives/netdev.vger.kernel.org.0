Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7981E31AD75
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 18:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhBMRwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 12:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhBMRw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 12:52:29 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA261C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:51:42 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id ba1so1506642plb.1
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jW9Dez18xwILkq1/9jHzyGFuCSTTILOrwI1eS2y0tKE=;
        b=BPrO4V3DFaGYlUR4zhlzaXKhUMhnHvks2TFtyYDOD0dt0GkWa0vlAzvTvqG4pD1UBc
         JiUhOc6xMRk/0dFLFSjl1jLvhu1f8wOMT1vb/AEs712Bn4cBXsBlLKiNq90tILibg9HR
         PztoYprZjCCg2gBt87CBfoxE7M8mgRx4ah807kjKHJCJjh94tDdijkSYVgb4SnABfyYW
         37pQeAnFtOfCOwNkHg+xCSJdSQmVYXTS/tlkcADYUQOgrDkIkIX3IeFIDO0TxIRDes6k
         FVrDfszh9ECquMNwMynU2e6NACGcXn25hRSqJ31RFeAs8YHQmQDHRz7YBupNkLQuT5Bv
         D/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jW9Dez18xwILkq1/9jHzyGFuCSTTILOrwI1eS2y0tKE=;
        b=gcKUzd87i0bC7yl7xdC6bwBOwYy0mS7YR63h5Z0eLkhSFQRSnMbYPHipMaSgDNhRQe
         I39m0QRK+dsbh4omb7aMDnSH9/v4pWnldVtvbOX1RVY3hjOFsFLvg73CWlsGT5b2Ha5N
         N0mmMkYp7ZlozU/Wek1sHIPDSABngIjlavaR4w2ZBUJ4De3YxbfCmLdqgMPd9kkFvMEq
         7Xu1zH94T1mE0rJds9Q3vlbUFINspt7pSAfnM/Ajy2ExM8UaZplqniKX1lwngLowbsGe
         sCagV7C1S1yWMhc7xkuBq6jU4CKll8+lT+0qkrkl7SehAGYiyGwy3VortMf5bUUAxrTn
         IuXA==
X-Gm-Message-State: AOAM530giizxtp3RXR9vKPrN2wOKWBI7eNwW7x2Rqbvq+A2f3gDAvKXn
        1BnaJQAfQ5NL4q3hFEEskXI=
X-Google-Smtp-Source: ABdhPJztW0fHtLNb2UMT0JbocfnQXGC2ezAPLx+3B8sDKz+X7OJ1G8DzyUrHbVnkxpT2Gn5qs0cvgA==
X-Received: by 2002:a17:902:ce8b:b029:df:edfe:faf2 with SMTP id f11-20020a170902ce8bb02900dfedfefaf2mr7891033plg.56.1613238702434;
        Sat, 13 Feb 2021 09:51:42 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id 73sm12721844pfa.27.2021.02.13.09.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 09:51:41 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH net-next v2 2/7] mld: separate two flags from ifmcaddr6->mca_flags
Date:   Sat, 13 Feb 2021 17:51:27 +0000
Message-Id: <20210213175127.28300-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the ifmcaddr6->mca_flags, there are follows flags.
MAF_TIMER_RUNNING
MAF_LAST_REPORTER
MAF_LOADED
MAF_NOREPORT
MAF_GSQUERY

The mca_flags value will be protected by a spinlock since
the next patches. But MAF_LOADED and MAF_NOREPORT do not need
spinlock because they will be protected by RTNL.
So, if they are separated from mca_flags, it could reduce atomic context.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v1 -> v2:
 - Separated from previous big one patch.

 include/net/if_inet6.h |  8 ++++----
 net/ipv6/mcast.c       | 26 +++++++++++---------------
 2 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index af5244c9ca5c..bec372283ac0 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -107,9 +107,7 @@ struct ip6_sf_list {
 
 #define MAF_TIMER_RUNNING	0x01
 #define MAF_LAST_REPORTER	0x02
-#define MAF_LOADED		0x04
-#define MAF_NOREPORT		0x08
-#define MAF_GSQUERY		0x10
+#define MAF_GSQUERY		0x04
 
 struct ifmcaddr6 {
 	struct in6_addr		mca_addr;
@@ -121,7 +119,9 @@ struct ifmcaddr6 {
 	unsigned char		mca_crcount;
 	unsigned long		mca_sfcount[2];
 	struct delayed_work	mca_work;
-	unsigned int		mca_flags;
+	unsigned char		mca_flags;
+	bool                    mca_noreport;
+	bool                    mca_loaded;
 	int			mca_users;
 	refcount_t		mca_refcnt;
 	spinlock_t		mca_lock;
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 80597dc56f2a..1f7fd3fbb4b6 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -661,15 +661,13 @@ static void igmp6_group_added(struct ifmcaddr6 *mc)
 	    IPV6_ADDR_SCOPE_LINKLOCAL)
 		return;
 
-	spin_lock_bh(&mc->mca_lock);
-	if (!(mc->mca_flags&MAF_LOADED)) {
-		mc->mca_flags |= MAF_LOADED;
+	if (!mc->mca_loaded) {
+		mc->mca_loaded = true;
 		if (ndisc_mc_map(&mc->mca_addr, buf, dev, 0) == 0)
 			dev_mc_add(dev, buf);
 	}
-	spin_unlock_bh(&mc->mca_lock);
 
-	if (!(dev->flags & IFF_UP) || (mc->mca_flags & MAF_NOREPORT))
+	if (!(dev->flags & IFF_UP) || mc->mca_noreport)
 		return;
 
 	if (mld_in_v1_mode(mc->idev)) {
@@ -697,15 +695,13 @@ static void igmp6_group_dropped(struct ifmcaddr6 *mc)
 	    IPV6_ADDR_SCOPE_LINKLOCAL)
 		return;
 
-	spin_lock_bh(&mc->mca_lock);
-	if (mc->mca_flags&MAF_LOADED) {
-		mc->mca_flags &= ~MAF_LOADED;
+	if (mc->mca_loaded) {
+		mc->mca_loaded = false;
 		if (ndisc_mc_map(&mc->mca_addr, buf, dev, 0) == 0)
 			dev_mc_del(dev, buf);
 	}
 
-	spin_unlock_bh(&mc->mca_lock);
-	if (mc->mca_flags & MAF_NOREPORT)
+	if (mc->mca_noreport)
 		return;
 
 	if (!mc->idev->dead)
@@ -868,7 +864,7 @@ static struct ifmcaddr6 *mca_alloc(struct inet6_dev *idev,
 
 	if (ipv6_addr_is_ll_all_nodes(&mc->mca_addr) ||
 	    IPV6_ADDR_MC_SCOPE(&mc->mca_addr) < IPV6_ADDR_SCOPE_LINKLOCAL)
-		mc->mca_flags |= MAF_NOREPORT;
+		mc->mca_noreport = true;
 
 	return mc;
 }
@@ -1733,7 +1729,7 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 	int scount, stotal, first, isquery, truncate;
 	unsigned int mtu;
 
-	if (pmc->mca_flags & MAF_NOREPORT)
+	if (pmc->mca_noreport)
 		return skb;
 
 	mtu = READ_ONCE(dev->mtu);
@@ -1855,7 +1851,7 @@ static void mld_send_report(struct inet6_dev *idev, struct ifmcaddr6 *pmc)
 	read_lock_bh(&idev->lock);
 	if (!pmc) {
 		for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
-			if (pmc->mca_flags & MAF_NOREPORT)
+			if (pmc->mca_noreport)
 				continue;
 			spin_lock_bh(&pmc->mca_lock);
 			if (pmc->mca_sfcount[MCAST_EXCLUDE])
@@ -2149,7 +2145,7 @@ static int ip6_mc_del1_src(struct ifmcaddr6 *pmc, int sfmode,
 			psf_prev->sf_next = psf->sf_next;
 		else
 			pmc->mca_sources = psf->sf_next;
-		if (psf->sf_oldin && !(pmc->mca_flags & MAF_NOREPORT) &&
+		if (psf->sf_oldin && !pmc->mca_noreport &&
 		    !mld_in_v1_mode(idev)) {
 			psf->sf_crcount = idev->mc_qrv;
 			psf->sf_next = pmc->mca_tomb;
@@ -2410,7 +2406,7 @@ static void igmp6_join_group(struct ifmcaddr6 *ma)
 {
 	unsigned long delay;
 
-	if (ma->mca_flags & MAF_NOREPORT)
+	if (ma->mca_noreport)
 		return;
 
 	igmp6_send(&ma->mca_addr, ma->idev->dev, ICMPV6_MGM_REPORT);
-- 
2.17.1

