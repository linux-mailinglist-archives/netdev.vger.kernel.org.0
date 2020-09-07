Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648DD25F727
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgIGKBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728514AbgIGKAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:00:36 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC20C061574
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 03:00:35 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id t10so15192101wrv.1
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 03:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gcib5npC4llvtu4+LbYVHXG0s/irec0HvJtAMaXEsuA=;
        b=ZIDfZGPxAQkTQXSDtB8+PJTEtY90uoFIXO2gmEPLNfFxIq2Ap68yD4hTccf7IGV9Jw
         CMuLilXTrkxtZ/1D9jLiADgI8Pan2WqWwTwbjYoCuofFsJcstLEws0SoGBcbLTELv7w/
         YAL8GyevJzPUZYcv2Uf7vn+JiHAOPAc4IyB7Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gcib5npC4llvtu4+LbYVHXG0s/irec0HvJtAMaXEsuA=;
        b=qB5vxkGhBK9U2Szw6h/EfyTIrlqX6g8CxInD/r6oIzHM1T3jA66i36mujztGv+fdFO
         p/HWDlKEcO6JE6bYftPb1ch50ALC8TLjUjsT+hmArGyDqthox7uaoUhiNaRMJ98EKz/W
         7myryv4RQgVelCRy6hTAo8tkeGOsqcOZX31s5wCtGG3/wQDm6BrTOWwXOGzR8OqkJWOS
         JC0K+2sZHd4yZXmanecNEk5pZRBp60ebe5/zpfkFafd32woca8zrQ8+muSiUL7Xf1zIs
         rCvj/BfO058mhIJuV9aoEa7xya+OJsdzkQPhfrdbBiZyULLVAIV50YlR3poWokmfsgXu
         MrsA==
X-Gm-Message-State: AOAM531y4WHWB7g/uNZvZ2rsKdDPsVONaTntvJINUxBdkqhtxP4vM1lX
        sPBK2U4YWTFGRRhOwWbW8lT1tUhPEI/r732X
X-Google-Smtp-Source: ABdhPJzkOD+reBG25304mK3qJigYYg32yVreS/zABWM9YSkBDWxr4rc6yt4AhNBnoppbUKolI4gbsg==
X-Received: by 2002:a5d:5150:: with SMTP id u16mr20752969wrt.197.1599472832322;
        Mon, 07 Sep 2020 03:00:32 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 9sm6686289wmf.7.2020.09.07.03.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:00:31 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v4 14/15] net: bridge: mcast: improve IGMPv3/MLDv2 query processing
Date:   Mon,  7 Sep 2020 12:56:18 +0300
Message-Id: <20200907095619.11216-15-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
References: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
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
index 6cfac6cbaf3b..0bf791ed0f56 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2194,7 +2194,8 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 		}
 	} else if (transport_len >= sizeof(*ih3)) {
 		ih3 = igmpv3_query_hdr(skb);
-		if (ih3->nsrcs)
+		if (ih3->nsrcs ||
+		    (br->multicast_igmp_version == 3 && group && ih3->suppress))
 			goto out;
 
 		max_delay = ih3->code ?
@@ -2229,7 +2230,9 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 	     pp = &p->next) {
 		if (timer_pending(&p->timer) ?
 		    time_after(p->timer.expires, now + max_delay) :
-		    try_to_del_timer_sync(&p->timer) >= 0)
+		    try_to_del_timer_sync(&p->timer) >= 0 &&
+		    (br->multicast_igmp_version == 2 ||
+		     p->filter_mode == MCAST_EXCLUDE))
 			mod_timer(&p->timer, now + max_delay);
 	}
 
@@ -2279,6 +2282,10 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		mld2q = (struct mld2_query *)icmp6_hdr(skb);
 		if (!mld2q->mld2q_nsrcs)
 			group = &mld2q->mld2q_mca;
+		if (br->multicast_mld_version == 2 &&
+		    !ipv6_addr_any(&mld2q->mld2q_mca) &&
+		    mld2q->mld2q_suppress)
+			goto out;
 
 		max_delay = max(msecs_to_jiffies(mldv2_mrc(mld2q)), 1UL);
 	}
@@ -2312,7 +2319,9 @@ static int br_ip6_multicast_query(struct net_bridge *br,
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

