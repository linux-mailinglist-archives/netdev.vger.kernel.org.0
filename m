Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C4031AD7A
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 18:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhBMRxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 12:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbhBMRxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 12:53:12 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AB6C0613D6
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:52:32 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d15so1494854plh.4
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=z1cf+f1fiGYI7zzf+P+a0WeccVhMuwpCe8uIH4ZnIBU=;
        b=m4Mg1bRHlGKl3R1kduEaxxXXBX3/KZIAPD4ve1w89e6h012jpo5DQ/9Y4wI4of8s2Y
         Abyq4Lrsjo+BTUw+hg4kj0abyxnFZlVlMSyfN7AhbdhKHiq6dqwAwDGDv2k8XJza8k/P
         6AAObd6FE5dSEDglkd1w5EtCeol3FeDmgeDRNNpp7oQ3JKHGHotZ3deqfeYvOBA6/RUt
         pEECQQNsXepUmV9w1dxOmd0Dssmas2N6J5dR493VQ54W3KH2nihhDwFq557F/5kl00gW
         llliKfvr8NIXmVLvWC8ZiBsRF8QJNMuXGAv5PqEKhjzRUVXQVAsFPDYBiA6M/0WvIu6F
         0t4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=z1cf+f1fiGYI7zzf+P+a0WeccVhMuwpCe8uIH4ZnIBU=;
        b=nCgw06sSJLSJLtjvExKavRtAWCt6f6oW4Az47BUL8JH+jyPTHsNodDMHO6VgDyo9Gg
         m8yz8FoBH7GtIzOi2sHcnUI0QTDTWBq2Zke3flcufl3Q4NebtaIR9OrkmDWkbivkE4f/
         5IPXXSdlAf12kCmIr0avxSpaC97sejFwwODAUO4mLQQC0rbZOL37Tf8SIOzgHYx89QKt
         qq6fGj/Yml/DIfqJvxuH/9Jc2pmTzsIn4WAlNvykCkf43EQSa7KQrQTYY45R/IwjFDt2
         gwlN1Dm02J187smB6AMEjTsaLquBf+EeBU9f0VUwguTHJuc8fdLtlX3qu5uXDU++Gno3
         z35w==
X-Gm-Message-State: AOAM5336Vp6n6L3DJlqt9jaYIl6jHc0+/5F+yFSJIMi+g3SIrQ/Nl8CH
        qErmGsWhSOedXQgYX8OGPSA=
X-Google-Smtp-Source: ABdhPJyWkQ4Xx5poLAxEV2ojCEG7ywKFMksqOUqDiuFdggpXb56XD4wROkV1dd6OAuF6267qT3jSjA==
X-Received: by 2002:a17:90a:7108:: with SMTP id h8mr3909836pjk.98.1613238751807;
        Sat, 13 Feb 2021 09:52:31 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id c6sm11173248pjd.21.2021.02.13.09.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 09:52:31 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH net-next v2 4/7] mld: get rid of inet6_dev->mc_lock
Date:   Sat, 13 Feb 2021 17:52:24 +0000
Message-Id: <20210213175224.28511-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
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
v1 -> v2:
 - Separated from previous big one patch.

 include/net/if_inet6.h | 1 -
 net/ipv6/mcast.c       | 9 ---------
 2 files changed, 10 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 5946b5d76f7b..4d9855be644c 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -167,7 +167,6 @@ struct inet6_dev {
 
 	struct ifmcaddr6	*mc_list;
 	struct ifmcaddr6	*mc_tomb;
-	spinlock_t		mc_lock;
 
 	unsigned char		mc_qrv;		/* Query Robustness Variable */
 	unsigned char		mc_gq_running;
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index ca8ca6faca4e..e80b78b1a8a7 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -748,10 +748,8 @@ static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	}
 	spin_unlock_bh(&im->mca_lock);
 
-	spin_lock_bh(&idev->mc_lock);
 	pmc->next = idev->mc_tomb;
 	idev->mc_tomb = pmc;
-	spin_unlock_bh(&idev->mc_lock);
 }
 
 static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
@@ -760,7 +758,6 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	struct ip6_sf_list *psf;
 	struct in6_addr *pmca = &im->mca_addr;
 
-	spin_lock_bh(&idev->mc_lock);
 	pmc_prev = NULL;
 	for (pmc = idev->mc_tomb; pmc; pmc = pmc->next) {
 		if (ipv6_addr_equal(&pmc->mca_addr, pmca))
@@ -773,7 +770,6 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 		else
 			idev->mc_tomb = pmc->next;
 	}
-	spin_unlock_bh(&idev->mc_lock);
 
 	spin_lock_bh(&im->mca_lock);
 	if (pmc) {
@@ -797,10 +793,8 @@ static void mld_clear_delrec(struct inet6_dev *idev)
 {
 	struct ifmcaddr6 *pmc, *nextpmc;
 
-	spin_lock_bh(&idev->mc_lock);
 	pmc = idev->mc_tomb;
 	idev->mc_tomb = NULL;
-	spin_unlock_bh(&idev->mc_lock);
 
 	for (; pmc; pmc = nextpmc) {
 		nextpmc = pmc->next;
@@ -1919,7 +1913,6 @@ static void mld_send_cr(struct inet6_dev *idev)
 	int type, dtype;
 
 	read_lock_bh(&idev->lock);
-	spin_lock(&idev->mc_lock);
 
 	/* deleted MCA's */
 	pmc_prev = NULL;
@@ -1953,7 +1946,6 @@ static void mld_send_cr(struct inet6_dev *idev)
 		} else
 			pmc_prev = pmc;
 	}
-	spin_unlock(&idev->mc_lock);
 
 	/* change recs */
 	for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
@@ -2615,7 +2607,6 @@ void ipv6_mc_up(struct inet6_dev *idev)
 void ipv6_mc_init_dev(struct inet6_dev *idev)
 {
 	write_lock_bh(&idev->lock);
-	spin_lock_init(&idev->mc_lock);
 	idev->mc_gq_running = 0;
 	INIT_DELAYED_WORK(&idev->mc_gq_work, mld_gq_work);
 	idev->mc_tomb = NULL;
-- 
2.17.1

