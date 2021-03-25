Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A11349690
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhCYQRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhCYQRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:17:23 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF6AC06174A;
        Thu, 25 Mar 2021 09:17:22 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c17so2562867pfn.6;
        Thu, 25 Mar 2021 09:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ChKEADg0vg3cJHSoLhniBIbLYuRGuBZcp326QuaxabM=;
        b=ceEj3CHfsGFxfZiJo8R2gtoTGZqbdTRwgIDP2QrSCIYdt1PbiBMXz5X95S7VwAJMi3
         /aQOlxSwIP/px/nx+qocNTsVHRF9AyTtio9vuG5YGqeA7VCqCbvo+5QM6WlSrb+U763c
         gZDmqIhdkY9mT+mAxinrZ9kBf31bDp+yIiMaCjkFEPXQ2PBeY8VX+iqfYxz1yMUtChk/
         S9k/VhoCGfo2Bnwoe2jV6oBMw//2nbLjf5O+ddQ9onm5oe4G1l1752DiSIUXPSop+BxS
         P+H4/RXM1g29F8X3+p2OSBNwtFrRVymDr/yADrmJcww4nd/IEtey1BL17CTzTx7Pf9Z8
         GCeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ChKEADg0vg3cJHSoLhniBIbLYuRGuBZcp326QuaxabM=;
        b=AlsSaLSZkEtZK3elXw3JtvTP3InR5ekT8KA2WI6Acsg2oQiAvarEWWZj8A9qZm58Mw
         LaSzptvzYX6PHrRH8/qZkAYBJjg6XryguUkxVahTr5owvVKWM5EetMt1N7xOrVC8I91U
         tjaJWhGas68WqMECDHSgfNwWoIi9KjmJ+FqXhqr8/fprubSx2NB8e7mIAs4cN1I/CTVD
         DAb8lTnKCagD6MnKwOzshjxnEmfbfTz1gQgvxZTYHgQbBC+PoFw2WbKKlkxCE7eQInQy
         o85qTNMHXTNmec7Op0QztYLjNvP3IVP56QYOBrKLYvUsqTkN8r7oZgZwX17Ib+sB0dq4
         cNXw==
X-Gm-Message-State: AOAM5309dOZE64Fq02CvDu25wOe4NPqSpbmHGc3PKWLLSFNsrc5wdvQe
        4Kre7rJFRSNOuLVhRlFuNp9JzpFrEMircQ==
X-Google-Smtp-Source: ABdhPJy3WVE9CrfV8+wG/JPQxhwT7Os6ORae9B37Gp59oww88kyypDSnRj0NhrzC3P7JAypSgzjX/A==
X-Received: by 2002:a63:c90c:: with SMTP id o12mr8476535pgg.210.1616689041583;
        Thu, 25 Mar 2021 09:17:21 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id s15sm6416917pgs.28.2021.03.25.09.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 09:17:20 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     ap420073@gmail.com, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-s390@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: [PATCH net-next v3 2/7] mld: get rid of inet6_dev->mc_lock
Date:   Thu, 25 Mar 2021 16:16:52 +0000
Message-Id: <20210325161657.10517-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210325161657.10517-1-ap420073@gmail.com>
References: <20210325161657.10517-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of mc_lock is to protect inet6_dev->mc_tomb.
But mc_tomb is already protected by RTNL and all functions,
which manipulate mc_tomb are called under RTNL.
So, mc_lock is not needed.
Furthermore, it is spinlock so the critical section is atomic.
In order to reduce atomic context, it should be removed.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v2 -> v3:
 - No change
v1 -> v2:
 - Separated from previous big one patch.

 include/net/if_inet6.h | 1 -
 net/ipv6/mcast.c       | 9 ---------
 2 files changed, 10 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index af5244c9ca5c..1080d2248304 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -167,7 +167,6 @@ struct inet6_dev {
 
 	struct ifmcaddr6	*mc_list;
 	struct ifmcaddr6	*mc_tomb;
-	spinlock_t		mc_lock;
 
 	unsigned char		mc_qrv;		/* Query Robustness Variable */
 	unsigned char		mc_gq_running;
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 692a6dec8959..35962aa3cc22 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -752,10 +752,8 @@ static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	}
 	spin_unlock_bh(&im->mca_lock);
 
-	spin_lock_bh(&idev->mc_lock);
 	pmc->next = idev->mc_tomb;
 	idev->mc_tomb = pmc;
-	spin_unlock_bh(&idev->mc_lock);
 }
 
 static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
@@ -764,7 +762,6 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	struct ip6_sf_list *psf;
 	struct in6_addr *pmca = &im->mca_addr;
 
-	spin_lock_bh(&idev->mc_lock);
 	pmc_prev = NULL;
 	for (pmc = idev->mc_tomb; pmc; pmc = pmc->next) {
 		if (ipv6_addr_equal(&pmc->mca_addr, pmca))
@@ -777,7 +774,6 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 		else
 			idev->mc_tomb = pmc->next;
 	}
-	spin_unlock_bh(&idev->mc_lock);
 
 	spin_lock_bh(&im->mca_lock);
 	if (pmc) {
@@ -801,10 +797,8 @@ static void mld_clear_delrec(struct inet6_dev *idev)
 {
 	struct ifmcaddr6 *pmc, *nextpmc;
 
-	spin_lock_bh(&idev->mc_lock);
 	pmc = idev->mc_tomb;
 	idev->mc_tomb = NULL;
-	spin_unlock_bh(&idev->mc_lock);
 
 	for (; pmc; pmc = nextpmc) {
 		nextpmc = pmc->next;
@@ -1907,7 +1901,6 @@ static void mld_send_cr(struct inet6_dev *idev)
 	int type, dtype;
 
 	read_lock_bh(&idev->lock);
-	spin_lock(&idev->mc_lock);
 
 	/* deleted MCA's */
 	pmc_prev = NULL;
@@ -1941,7 +1934,6 @@ static void mld_send_cr(struct inet6_dev *idev)
 		} else
 			pmc_prev = pmc;
 	}
-	spin_unlock(&idev->mc_lock);
 
 	/* change recs */
 	for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
@@ -2582,7 +2574,6 @@ void ipv6_mc_up(struct inet6_dev *idev)
 void ipv6_mc_init_dev(struct inet6_dev *idev)
 {
 	write_lock_bh(&idev->lock);
-	spin_lock_init(&idev->mc_lock);
 	idev->mc_gq_running = 0;
 	INIT_DELAYED_WORK(&idev->mc_gq_work, mld_gq_work);
 	idev->mc_tomb = NULL;
-- 
2.17.1

