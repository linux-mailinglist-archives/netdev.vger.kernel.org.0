Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF8631AD7B
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 18:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhBMRyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 12:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhBMRxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 12:53:52 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5877AC061756
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:53:12 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id t2so1449942pjq.2
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KyJKsxyhWhIGoacEnCll6j750J1cvUNLWDsywvBaATY=;
        b=DN0hlMjSu18+Kxkbbc9sfD1kCjYp6DzSdbHNOXCuBrFcvC3L57oh9DhixO76RXlwWR
         ACZNpyLOj4Ufw8nT3EeqJvtFOJOaK1FJT1ib3yZPr3uQ/mBMOj9+omqT7qwDDxsIrVVV
         F3583ZevX09RR7I/QpBuukLKpPOgDxRCoFDMgD3HUxqL98hlb6R8fVFf5DLkHQ5JJjBe
         CJw5I0GOCOofo7gdh7r8adbzMVJs0b4zdTn147qhU6/M7MIyfHjv4uRrob/dQuK7L/Zi
         8Wyba8TSQykURWxYU2WkspAMd7jXMLz6I2yADJsglcqFqXKBPiduxcD5mUul6QMJyFup
         WnRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KyJKsxyhWhIGoacEnCll6j750J1cvUNLWDsywvBaATY=;
        b=pZupjghuNM3NcPuANjmnYZnl3lZujWsmBOdPldDEoTi59cOiAYiIhj4R3wheyeF17X
         GsffE8MzaSYTlczVfIGjaJ5YiQNoS89qi6Qx+xNcEizofng9lndIrrTmW4s+hqzPUfhk
         1SYQQ07RdOeZa0GkCKzniYsAiWSBw9CWkMYQPmamONgkZ86yLlA+JZFXFaQrnpsCLHvL
         NA7j4tHXiwURqkCuzo3k4xl375MUBxbvdaU3ds4FQhOsfKPVTPyIlmn8OZrYuROwXsMV
         FFr/YUioiUFM0xU/eAedEJxVeL5ybU8Bv4CEZoRonMC36klLbaUtFaIjg0Su8oJGlmPT
         CfsA==
X-Gm-Message-State: AOAM530Sx/podL+WIQznIn8UsaLPLAWKfJIBwUNCU03nP84GKdL0BI4B
        qCt9XCAfssmCyYkRHRNfUOA=
X-Google-Smtp-Source: ABdhPJxkz1kjV1t/SyaO4ffuno1sJU5g+cct6SgAzNKLvVgnSMOn4Fq6808rNxyi2wUNlZKh1QlWfQ==
X-Received: by 2002:a17:902:c3c2:b029:e3:29a8:1504 with SMTP id j2-20020a170902c3c2b02900e329a81504mr5639963plj.22.1613238791823;
        Sat, 13 Feb 2021 09:53:11 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id h12sm12610410pgs.7.2021.02.13.09.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 09:53:11 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH net-next v2 6/7] mld: convert ip6_sf_list to RCU
Date:   Sat, 13 Feb 2021 17:52:57 +0000
Message-Id: <20210213175257.28642-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ip6_sf_list has been protected by mca_lock(spin_lock) so that the
critical section is atomic context. In order to switch this context,
changing locking is needed. The ip6_sf_list actually already protected
by RTNL So if it's converted to use RCU, its control path context can
be switched to sleepable.
But It doesn't remove mca_lock yet because ifmcaddr6 isn't converted
to RCU yet. So, It's not fully converted to the sleepable context.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v1 -> v2:
 - Separated from previous big one patch.

 include/net/if_inet6.h |   5 +-
 net/ipv6/mcast.c       | 150 +++++++++++++++++++++++++----------------
 2 files changed, 95 insertions(+), 60 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index d8507bef0a0c..b26fecb669e3 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -97,12 +97,13 @@ struct ipv6_mc_socklist {
 };
 
 struct ip6_sf_list {
-	struct ip6_sf_list	*sf_next;
+	struct ip6_sf_list	__rcu *sf_next;
 	struct in6_addr		sf_addr;
 	unsigned long		sf_count[2];	/* include/exclude counts */
 	unsigned char		sf_gsresp;	/* include in g & s response? */
 	unsigned char		sf_oldin;	/* change state */
 	unsigned char		sf_crcount;	/* retrans. left to send */
+	struct rcu_head		rcu;
 };
 
 #define MAF_TIMER_RUNNING	0x01
@@ -113,7 +114,7 @@ struct ifmcaddr6 {
 	struct in6_addr		mca_addr;
 	struct inet6_dev	*idev;
 	struct ifmcaddr6	*next;
-	struct ip6_sf_list	*mca_sources;
+	struct ip6_sf_list	__rcu *mca_sources;
 	struct ip6_sf_list	*mca_tomb;
 	unsigned int		mca_sfmode;
 	unsigned char		mca_crcount;
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index cffa2eeb88c5..792f16e2ad83 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -113,10 +113,20 @@ int sysctl_mld_qrv __read_mostly = MLD_QRV_DEFAULT;
  */
 
 #define for_each_pmc_rcu(np, pmc)				\
-	for (pmc = rcu_dereference(np->ipv6_mc_list);		\
-	     pmc != NULL;					\
+	for (pmc = rcu_dereference((np)->ipv6_mc_list);		\
+	     pmc;						\
 	     pmc = rcu_dereference(pmc->next))
 
+#define for_each_psf_rtnl(mc, psf)				\
+	for (psf = rtnl_dereference((mc)->mca_sources);		\
+	     psf;						\
+	     psf = rtnl_dereference(psf->sf_next))
+
+#define for_each_psf_rcu(mc, psf)				\
+	for (psf = rcu_dereference((mc)->mca_sources);		\
+	     psf;						\
+	     psf = rcu_dereference(psf->sf_next))
+
 static int unsolicited_report_interval(struct inet6_dev *idev)
 {
 	int iv;
@@ -731,22 +741,25 @@ static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 		struct ip6_sf_list *psf;
 
 		pmc->mca_tomb = im->mca_tomb;
-		pmc->mca_sources = im->mca_sources;
-		im->mca_tomb = im->mca_sources = NULL;
-		for (psf = pmc->mca_sources; psf; psf = psf->sf_next)
+		rcu_assign_pointer(pmc->mca_sources,
+				   rtnl_dereference(im->mca_sources));
+		im->mca_tomb = NULL;
+		RCU_INIT_POINTER(im->mca_sources, NULL);
+
+		for_each_psf_rtnl(pmc, psf)
 			psf->sf_crcount = pmc->mca_crcount;
 	}
 	spin_unlock_bh(&im->mca_lock);
 
-	pmc->next = idev->mc_tomb;
+	rcu_assign_pointer(pmc->next, idev->mc_tomb);
 	idev->mc_tomb = pmc;
 }
 
 static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 {
-	struct ifmcaddr6 *pmc, *pmc_prev;
-	struct ip6_sf_list *psf;
 	struct in6_addr *pmca = &im->mca_addr;
+	struct ip6_sf_list *psf, *sources;
+	struct ifmcaddr6 *pmc, *pmc_prev;
 
 	pmc_prev = NULL;
 	for (pmc = idev->mc_tomb; pmc; pmc = pmc->next) {
@@ -766,8 +779,12 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 		im->idev = pmc->idev;
 		if (im->mca_sfmode == MCAST_INCLUDE) {
 			swap(im->mca_tomb, pmc->mca_tomb);
-			swap(im->mca_sources, pmc->mca_sources);
-			for (psf = im->mca_sources; psf; psf = psf->sf_next)
+
+			sources = rcu_replace_pointer(im->mca_sources,
+						      pmc->mca_sources,
+						      lockdep_rtnl_is_held());
+			rcu_assign_pointer(pmc->mca_sources, sources);
+			for_each_psf_rtnl(im, psf)
 				psf->sf_crcount = idev->mc_qrv;
 		} else {
 			im->mca_crcount = idev->mc_qrv;
@@ -803,8 +820,8 @@ static void mld_clear_delrec(struct inet6_dev *idev)
 		pmc->mca_tomb = NULL;
 		spin_unlock_bh(&pmc->mca_lock);
 		for (; psf; psf = psf_next) {
-			psf_next = psf->sf_next;
-			kfree(psf);
+			psf_next = rtnl_dereference(psf->sf_next);
+			kfree_rcu(psf, rcu);
 		}
 	}
 	read_unlock_bh(&idev->lock);
@@ -986,7 +1003,7 @@ bool ipv6_chk_mcast_addr(struct net_device *dev, const struct in6_addr *group,
 				struct ip6_sf_list *psf;
 
 				spin_lock_bh(&mc->mca_lock);
-				for (psf = mc->mca_sources; psf; psf = psf->sf_next) {
+				for_each_psf_rcu(mc, psf) {
 					if (ipv6_addr_equal(&psf->sf_addr, src_addr))
 						break;
 				}
@@ -1101,7 +1118,7 @@ static bool mld_xmarksources(struct ifmcaddr6 *pmc, int nsrcs,
 	int i, scount;
 
 	scount = 0;
-	for (psf = pmc->mca_sources; psf; psf = psf->sf_next) {
+	for_each_psf_rcu(pmc, psf) {
 		if (scount == nsrcs)
 			break;
 		for (i = 0; i < nsrcs; i++) {
@@ -1134,7 +1151,7 @@ static bool mld_marksources(struct ifmcaddr6 *pmc, int nsrcs,
 	/* mark INCLUDE-mode sources */
 
 	scount = 0;
-	for (psf = pmc->mca_sources; psf; psf = psf->sf_next) {
+	for_each_psf_rcu(pmc, psf) {
 		if (scount == nsrcs)
 			break;
 		for (i = 0; i < nsrcs; i++) {
@@ -1544,7 +1561,7 @@ mld_scount(struct ifmcaddr6 *pmc, int type, int gdeleted, int sdeleted)
 	struct ip6_sf_list *psf;
 	int scount = 0;
 
-	for (psf = pmc->mca_sources; psf; psf = psf->sf_next) {
+	for_each_psf_rtnl(pmc, psf) {
 		if (!is_in(pmc, psf, type, gdeleted, sdeleted))
 			continue;
 		scount++;
@@ -1719,14 +1736,16 @@ static struct sk_buff *add_grhead(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 #define AVAILABLE(skb)	((skb) ? skb_availroom(skb) : 0)
 
 static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
-	int type, int gdeleted, int sdeleted, int crsend)
+				int type, int gdeleted, int sdeleted,
+				int crsend)
 {
+	int scount, stotal, first, isquery, truncate;
+	struct ip6_sf_list __rcu **psf_list;
+	struct ip6_sf_list *psf, *psf_prev;
 	struct inet6_dev *idev = pmc->idev;
 	struct net_device *dev = idev->dev;
-	struct mld2_report *pmr;
 	struct mld2_grec *pgr = NULL;
-	struct ip6_sf_list *psf, *psf_next, *psf_prev, **psf_list;
-	int scount, stotal, first, isquery, truncate;
+	struct mld2_report *pmr;
 	unsigned int mtu;
 
 	if (pmc->mca_noreport)
@@ -1743,10 +1762,13 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 
 	stotal = scount = 0;
 
-	psf_list = sdeleted ? &pmc->mca_tomb : &pmc->mca_sources;
-
-	if (!*psf_list)
-		goto empty_source;
+	if (sdeleted) {
+		if (!pmc->mca_tomb)
+			goto empty_source;
+	} else {
+		if (!rcu_access_pointer(pmc->mca_sources))
+			goto empty_source;
+	}
 
 	pmr = skb ? (struct mld2_report *)skb_transport_header(skb) : NULL;
 
@@ -1761,10 +1783,12 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 	}
 	first = 1;
 	psf_prev = NULL;
-	for (psf = *psf_list; psf; psf = psf_next) {
+	for (psf_list = &pmc->mca_sources;
+	     (psf = rtnl_dereference(*psf_list)) != NULL;
+	      psf_list = &psf->sf_next) {
 		struct in6_addr *psrc;
 
-		psf_next = psf->sf_next;
+		*psf_list = rtnl_dereference(psf->sf_next);
 
 		if (!is_in(pmc, psf, type, gdeleted, sdeleted) && !crsend) {
 			psf_prev = psf;
@@ -1811,10 +1835,11 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 			psf->sf_crcount--;
 			if ((sdeleted || gdeleted) && psf->sf_crcount == 0) {
 				if (psf_prev)
-					psf_prev->sf_next = psf->sf_next;
+					rcu_assign_pointer(psf_prev->sf_next,
+							   rtnl_dereference(psf->sf_next));
 				else
-					*psf_list = psf->sf_next;
-				kfree(psf);
+					*psf_list = rtnl_dereference(psf->sf_next);
+				kfree_rcu(psf, rcu);
 				continue;
 			}
 		}
@@ -1883,16 +1908,18 @@ static void mld_clear_zeros(struct ip6_sf_list **ppsf)
 	struct ip6_sf_list *psf_prev, *psf_next, *psf;
 
 	psf_prev = NULL;
-	for (psf = *ppsf; psf; psf = psf_next) {
-		psf_next = psf->sf_next;
+	for (psf = rtnl_dereference(*ppsf); psf; psf = psf_next) {
+		psf_next = rtnl_dereference(psf->sf_next);
 		if (psf->sf_crcount == 0) {
 			if (psf_prev)
-				psf_prev->sf_next = psf->sf_next;
+				rcu_assign_pointer(psf_prev->sf_next,
+						   rtnl_dereference(psf->sf_next));
 			else
-				*ppsf = psf->sf_next;
-			kfree(psf);
-		} else
+				*ppsf = rtnl_dereference(psf->sf_next);
+			kfree_rcu(psf, rcu);
+		} else {
 			psf_prev = psf;
+		}
 	}
 }
 
@@ -2137,7 +2164,7 @@ static int ip6_mc_del1_src(struct ifmcaddr6 *pmc, int sfmode,
 	int rv = 0;
 
 	psf_prev = NULL;
-	for (psf = pmc->mca_sources; psf; psf = psf->sf_next) {
+	for_each_psf_rtnl(pmc, psf) {
 		if (ipv6_addr_equal(&psf->sf_addr, psfsrc))
 			break;
 		psf_prev = psf;
@@ -2152,17 +2179,20 @@ static int ip6_mc_del1_src(struct ifmcaddr6 *pmc, int sfmode,
 
 		/* no more filters for this source */
 		if (psf_prev)
-			psf_prev->sf_next = psf->sf_next;
+			rcu_assign_pointer(psf_prev->sf_next,
+					   rtnl_dereference(psf->sf_next));
 		else
-			pmc->mca_sources = psf->sf_next;
+			rcu_assign_pointer(pmc->mca_sources,
+					   rtnl_dereference(psf->sf_next));
 		if (psf->sf_oldin && !pmc->mca_noreport &&
 		    !mld_in_v1_mode(idev)) {
 			psf->sf_crcount = idev->mc_qrv;
-			psf->sf_next = pmc->mca_tomb;
+			rcu_assign_pointer(psf->sf_next, pmc->mca_tomb);
 			pmc->mca_tomb = psf;
 			rv = 1;
-		} else
-			kfree(psf);
+		} else {
+			kfree_rcu(psf, rcu);
+		}
 	}
 	return rv;
 }
@@ -2214,7 +2244,7 @@ static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 		pmc->mca_sfmode = MCAST_INCLUDE;
 		pmc->mca_crcount = idev->mc_qrv;
 		idev->mc_ifc_count = pmc->mca_crcount;
-		for (psf = pmc->mca_sources; psf; psf = psf->sf_next)
+		for_each_psf_rtnl(pmc, psf)
 			psf->sf_crcount = 0;
 		mld_ifc_event(pmc->idev);
 	} else if (sf_setstate(pmc) || changerec)
@@ -2233,7 +2263,7 @@ static int ip6_mc_add1_src(struct ifmcaddr6 *pmc, int sfmode,
 	struct ip6_sf_list *psf, *psf_prev;
 
 	psf_prev = NULL;
-	for (psf = pmc->mca_sources; psf; psf = psf->sf_next) {
+	for_each_psf_rtnl(pmc, psf) {
 		if (ipv6_addr_equal(&psf->sf_addr, psfsrc))
 			break;
 		psf_prev = psf;
@@ -2245,9 +2275,10 @@ static int ip6_mc_add1_src(struct ifmcaddr6 *pmc, int sfmode,
 
 		psf->sf_addr = *psfsrc;
 		if (psf_prev) {
-			psf_prev->sf_next = psf;
-		} else
-			pmc->mca_sources = psf;
+			rcu_assign_pointer(psf_prev->sf_next, psf);
+		} else {
+			rcu_assign_pointer(pmc->mca_sources, psf);
+		}
 	}
 	psf->sf_count[sfmode]++;
 	return 0;
@@ -2258,13 +2289,15 @@ static void sf_markstate(struct ifmcaddr6 *pmc)
 	struct ip6_sf_list *psf;
 	int mca_xcount = pmc->mca_sfcount[MCAST_EXCLUDE];
 
-	for (psf = pmc->mca_sources; psf; psf = psf->sf_next)
+	for_each_psf_rtnl(pmc, psf) {
 		if (pmc->mca_sfcount[MCAST_EXCLUDE]) {
 			psf->sf_oldin = mca_xcount ==
 				psf->sf_count[MCAST_EXCLUDE] &&
 				!psf->sf_count[MCAST_INCLUDE];
-		} else
+		} else {
 			psf->sf_oldin = psf->sf_count[MCAST_INCLUDE] != 0;
+		}
+	}
 }
 
 static int sf_setstate(struct ifmcaddr6 *pmc)
@@ -2275,7 +2308,7 @@ static int sf_setstate(struct ifmcaddr6 *pmc)
 	int new_in, rv;
 
 	rv = 0;
-	for (psf = pmc->mca_sources; psf; psf = psf->sf_next) {
+	for_each_psf_rtnl(pmc, psf) {
 		if (pmc->mca_sfcount[MCAST_EXCLUDE]) {
 			new_in = mca_xcount == psf->sf_count[MCAST_EXCLUDE] &&
 				!psf->sf_count[MCAST_INCLUDE];
@@ -2317,7 +2350,6 @@ static int sf_setstate(struct ifmcaddr6 *pmc)
 				if (!dpsf)
 					continue;
 				*dpsf = *psf;
-				/* pmc->mca_lock held by callers */
 				dpsf->sf_next = pmc->mca_tomb;
 				pmc->mca_tomb = dpsf;
 			}
@@ -2382,7 +2414,7 @@ static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 
 		pmc->mca_crcount = idev->mc_qrv;
 		idev->mc_ifc_count = pmc->mca_crcount;
-		for (psf = pmc->mca_sources; psf; psf = psf->sf_next)
+		for_each_psf_rtnl(pmc, psf)
 			psf->sf_crcount = 0;
 		mld_ifc_event(idev);
 	} else if (sf_setstate(pmc))
@@ -2401,11 +2433,13 @@ static void ip6_mc_clear_src(struct ifmcaddr6 *pmc)
 		kfree(psf);
 	}
 	pmc->mca_tomb = NULL;
-	for (psf = pmc->mca_sources; psf; psf = nextpsf) {
-		nextpsf = psf->sf_next;
-		kfree(psf);
+	for (psf = rtnl_dereference(pmc->mca_sources);
+	     psf;
+	     psf = nextpsf) {
+		nextpsf = rtnl_dereference(psf->sf_next);
+		kfree_rcu(psf, rcu);
 	}
-	pmc->mca_sources = NULL;
+	RCU_INIT_POINTER(pmc->mca_sources, NULL);
 	pmc->mca_sfmode = MCAST_EXCLUDE;
 	pmc->mca_sfcount[MCAST_INCLUDE] = 0;
 	pmc->mca_sfcount[MCAST_EXCLUDE] = 1;
@@ -2823,7 +2857,7 @@ static inline struct ip6_sf_list *igmp6_mcf_get_first(struct seq_file *seq)
 		im = idev->mc_list;
 		if (likely(im)) {
 			spin_lock_bh(&im->mca_lock);
-			psf = im->mca_sources;
+			psf = rcu_dereference(im->mca_sources);
 			if (likely(psf)) {
 				state->im = im;
 				state->idev = idev;
@@ -2840,7 +2874,7 @@ static struct ip6_sf_list *igmp6_mcf_get_next(struct seq_file *seq, struct ip6_s
 {
 	struct igmp6_mcf_iter_state *state = igmp6_mcf_seq_private(seq);
 
-	psf = psf->sf_next;
+	psf = rcu_dereference(psf->sf_next);
 	while (!psf) {
 		spin_unlock_bh(&state->im->mca_lock);
 		state->im = state->im->next;
@@ -2862,7 +2896,7 @@ static struct ip6_sf_list *igmp6_mcf_get_next(struct seq_file *seq, struct ip6_s
 		if (!state->im)
 			break;
 		spin_lock_bh(&state->im->mca_lock);
-		psf = state->im->mca_sources;
+		psf = rcu_dereference(state->im->mca_sources);
 	}
 out:
 	return psf;
-- 
2.17.1

