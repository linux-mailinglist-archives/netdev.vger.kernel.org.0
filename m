Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9735A31AD77
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 18:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhBMRwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 12:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhBMRwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 12:52:45 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFE6C061756
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:52:05 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id z9so1436471pjl.5
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pxli47LgSRMbu8PU178GClDlDkM8tqhxlPi1HIPfNF8=;
        b=cHqrqD4RV+hw95XMTucTPNVfY/24Xv3/BcLUayztBGnqFHOQw5kBTRwI6N/Mj+se7T
         jq0B25sBOpVr1GM7roFTalN52A/d2xFC5kO4l2xPRNgsQXBoWT1flDENZ0qZSgEO+Z0w
         h+U3VE1u/vMtS1fzI1SPDxMmm5zxysTQJQI8lhIbTuK06dLrmgobielyr/6hpg2bBjgl
         Zb7xH3yM+fjZEOb/LkUlSdbcqiphdDdxxAkOR6u01v++jlF+HoUyuy+X+KlzlArWyCF2
         jbfG+QlmAv7/7JxJKzUlEtaa+5k9DEFFuTspARFEuU6MR6A2ZfhXcOf5vnHBnY+KFEmY
         64Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pxli47LgSRMbu8PU178GClDlDkM8tqhxlPi1HIPfNF8=;
        b=TtdpfRidPdERSLO2+goOaqs/ntD4CiMyEom8VEtJoIxhgib6Q/75Xmg+b1uBan8dSF
         p/YSMqPbaECH6h3lqxbPhd3Vlb8Owh3MfLQM9B+HI7qEKOTjpwKgDtMvKUJVG6PseNTS
         8DlkvqGPw0I5GHw4gtuFj4iDKdZvgT+TQB5VKKUFzsOKJ4ef5UGRRRQr2M5xvXehVTVl
         LeKO9bW/SJrxzWbQmQhbSgM7T/CMspvwKrCDefR97jvcye2TIDUi6Ovgg7/xCvS4I9eT
         11G4CmmhrZ6mEMI9w4REb/44ZiL/7WtoL/YR8Ui2mbu8IA16e/DtsN1KEVT5a2J2j13R
         E0fw==
X-Gm-Message-State: AOAM531IOPKXVPY5YpQY0RZ97CIB79B5QzroowTni9QqozWHrgpMLZkZ
        syBij/4B234YQ+7RHkabCWg=
X-Google-Smtp-Source: ABdhPJynlPq9UP0BLmX5CZm7Fw4Ozb/K/4mnywi5LrAyXbdiEIbKoeE/QtswHP8AcFLdP/ci9QV+0w==
X-Received: by 2002:a17:90a:588c:: with SMTP id j12mr7894559pji.93.1613238724964;
        Sat, 13 Feb 2021 09:52:04 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id n1sm12678171pfd.212.2021.02.13.09.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 09:52:04 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH net-next v2 3/7] mld: add a new delayed_work, mc_delrec_work
Date:   Sat, 13 Feb 2021 17:51:48 +0000
Message-Id: <20210213175148.28375-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal of mc_delrec_work delayed work is to call mld_clear_delrec().
The mld_clear_delrec() is called under both data path and control path.
So, the context of mld_clear_delrec() can be atomic.
But this function accesses struct ifmcaddr6 and struct ip6_sf_list.
These structures are going to be protected by RTNL.
So, this function should be called in a sleepable context.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v1 -> v2:
 - Separated from previous big one patch.

 include/net/if_inet6.h |  1 +
 net/ipv6/mcast.c       | 32 +++++++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index bec372283ac0..5946b5d76f7b 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -182,6 +182,7 @@ struct inet6_dev {
 	struct delayed_work	mc_gq_work;	/* general query work */
 	struct delayed_work	mc_ifc_work;	/* interface change work */
 	struct delayed_work	mc_dad_work;	/* dad complete mc work */
+	struct delayed_work     mc_delrec_work; /* delete records work */
 
 	struct ifacaddr6	*ac_list;
 	rwlock_t		lock;
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 1f7fd3fbb4b6..ca8ca6faca4e 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1067,6 +1067,22 @@ static void mld_dad_stop_work(struct inet6_dev *idev)
 		__in6_dev_put(idev);
 }
 
+static void mld_clear_delrec_start_work(struct inet6_dev *idev)
+{
+	write_lock_bh(&idev->lock);
+	if (!mod_delayed_work(mld_wq, &idev->mc_delrec_work, 0))
+		in6_dev_hold(idev);
+	write_unlock_bh(&idev->lock);
+}
+
+static void mld_clear_delrec_stop_work(struct inet6_dev *idev)
+{
+	write_lock_bh(&idev->lock);
+	if (cancel_delayed_work(&idev->mc_delrec_work))
+		__in6_dev_put(idev);
+	write_unlock_bh(&idev->lock);
+}
+
 /*
  *	IGMP handling (alias multicast ICMPv6 messages)
  */
@@ -1304,7 +1320,7 @@ static int mld_process_v1(struct inet6_dev *idev, struct mld_msg *mld,
 	/* cancel the interface change work */
 	mld_ifc_stop_work(idev);
 	/* clear deleted report items */
-	mld_clear_delrec(idev);
+	mld_clear_delrec_start_work(idev);
 
 	return 0;
 }
@@ -2120,6 +2136,18 @@ static void mld_dad_work(struct work_struct *work)
 	in6_dev_put(idev);
 }
 
+static void mld_clear_delrec_work(struct work_struct *work)
+{
+	struct inet6_dev *idev = container_of(to_delayed_work(work),
+			struct inet6_dev,
+			mc_delrec_work);
+
+	rtnl_lock();
+	mld_clear_delrec(idev);
+	rtnl_unlock();
+	in6_dev_put(idev);
+}
+
 static int ip6_mc_del1_src(struct ifmcaddr6 *pmc, int sfmode,
 	const struct in6_addr *psfsrc)
 {
@@ -2553,6 +2581,7 @@ void ipv6_mc_down(struct inet6_dev *idev)
 	mld_gq_stop_work(idev);
 	mld_dad_stop_work(idev);
 	read_unlock_bh(&idev->lock);
+	mld_clear_delrec_stop_work(idev);
 }
 
 static void ipv6_mc_reset(struct inet6_dev *idev)
@@ -2593,6 +2622,7 @@ void ipv6_mc_init_dev(struct inet6_dev *idev)
 	idev->mc_ifc_count = 0;
 	INIT_DELAYED_WORK(&idev->mc_ifc_work, mld_ifc_work);
 	INIT_DELAYED_WORK(&idev->mc_dad_work, mld_dad_work);
+	INIT_DELAYED_WORK(&idev->mc_delrec_work, mld_clear_delrec_work);
 	ipv6_mc_reset(idev);
 	write_unlock_bh(&idev->lock);
 }
-- 
2.17.1

