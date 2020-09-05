Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3827925E67D
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 10:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgIEIZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 04:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728424AbgIEIZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 04:25:03 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481EBC061249
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 01:25:03 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a17so9645648wrn.6
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 01:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cLshL1qy2NWFVL3YMKKQ9DjLnzo1vTCjeiGuQjkekDY=;
        b=gUlcnVXhi18kYG1Srs+mVbGk2OpckgyGwERFFVf7L2ki1oDHWg1OskxZC4x2IPjacu
         bSTMtqIpIMoTP9zXiEKFnJpaVfH8JuHSmntxjzF3vn6BlwEPLaEry6PP+pMfX7LwMtWz
         Q4tPkiiwczOyD7Ea5Z363HLNBJUh/jzUw+RQE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cLshL1qy2NWFVL3YMKKQ9DjLnzo1vTCjeiGuQjkekDY=;
        b=m7JVVuvHzjhUr/VMJuR6IfCxk/wvcLYGQXghwcriNC3jcKMiUHYuQFjJodlQOit2Lz
         Cwtr6h4Qb2orOMBmgWSm7IUuJH13oZMM7+AF8KIE1lcUPAcJCdNpWf/uiSvY530ktp9s
         53wrymF487G3Z1Kzqonh/ynYcahNmLSph5KPbDm1Oez81mCI0+71oubkyygHWOmqd6QX
         a5xOXQH59fQpm6plPBQ2caOVIurSc8AnkD0+WbeWYXOjJ9yNRUGu/uO6tYC+kcDp7HmX
         h8IGqo0/h/9QHWeLSrD85SS73ptGp436A9Qqcu+clBh5sDlCwKpuD6kgqWB7ZS1bNqZm
         Wusw==
X-Gm-Message-State: AOAM5331TfHWXWRzCq78Gp2QthUH7BuN3BGDjM4DErVCS8ETh2BIEJ8n
        TuRHwJqWy8bCo/26fIjq3KiKOQ2/46orlZOU
X-Google-Smtp-Source: ABdhPJyiJVJyzt58L+LNX8R6h9gwXlTpQ2dlnuv/pk59SB1qXgakN1XsOTHwI//j5WdX6yVMDugbIQ==
X-Received: by 2002:adf:e449:: with SMTP id t9mr11561889wrm.154.1599294301545;
        Sat, 05 Sep 2020 01:25:01 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m185sm17169296wmf.5.2020.09.05.01.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 01:25:00 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 14/15] net: bridge: mcast: improve IGMPv3/MLDv2 query processing
Date:   Sat,  5 Sep 2020 11:24:09 +0300
Message-Id: <20200905082410.2230253-15-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
References: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an IGMPv3/MLDv2 query is received and we're operating in such mode
then we need to avoid updating group timers if the suppress flag is set.
Also we should update only timers for groups in exclude mode.

v3: add IPv6/MLDv2 support

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 2ded3f3c51c0..f146e00cea66 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2196,7 +2196,8 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 		}
 	} else if (transport_len >= sizeof(*ih3)) {
 		ih3 = igmpv3_query_hdr(skb);
-		if (ih3->nsrcs)
+		if (ih3->nsrcs ||
+		    (br->multicast_igmp_version == 3 && group && ih3->suppress))
 			goto out;
 
 		max_delay = ih3->code ?
@@ -2231,7 +2232,9 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 	     pp = &p->next) {
 		if (timer_pending(&p->timer) ?
 		    time_after(p->timer.expires, now + max_delay) :
-		    try_to_del_timer_sync(&p->timer) >= 0)
+		    try_to_del_timer_sync(&p->timer) >= 0 &&
+		    (br->multicast_igmp_version == 2 ||
+		     p->filter_mode == MCAST_EXCLUDE))
 			mod_timer(&p->timer, now + max_delay);
 	}
 
@@ -2281,6 +2284,10 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		mld2q = (struct mld2_query *)icmp6_hdr(skb);
 		if (!mld2q->mld2q_nsrcs)
 			group = &mld2q->mld2q_mca;
+		if (br->multicast_mld_version == 2 &&
+		    !ipv6_addr_any(&mld2q->mld2q_mca) &&
+		    mld2q->mld2q_suppress)
+			goto out;
 
 		max_delay = max(msecs_to_jiffies(mldv2_mrc(mld2q)), 1UL);
 	}
@@ -2314,7 +2321,9 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 	     pp = &p->next) {
 		if (timer_pending(&p->timer) ?
 		    time_after(p->timer.expires, now + max_delay) :
-		    try_to_del_timer_sync(&p->timer) >= 0)
+		    try_to_del_timer_sync(&p->timer) >= 0 &&
+		    (br->multicast_mld_version == 1 ||
+		     p->filter_mode == MCAST_EXCLUDE))
 			mod_timer(&p->timer, now + max_delay);
 	}
 
-- 
2.25.4

