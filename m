Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA5A257BDD
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgHaPLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbgHaPKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:10:15 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498CBC06123D
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:10:13 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id s13so5729840wmh.4
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5rHaHeEW27aQeKn7DgkSF8lCaC4zYOPlmbEcK5oKJ8E=;
        b=WLhTbdMtV0EhI2mcciSJy6Eh9ashl1aJ7f4sQM4a25KHqlpcCCiLXhGiIeocun9A2+
         nIhczss47B88cfHmYJ9R9pV3zL5604w5hWNdxaEvJ8uLr2OW9hp6B2GkdWjxwvCLkNKk
         U/MkvB+BRRwmxWAY9NrO06Wvywin3iVI56ST8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5rHaHeEW27aQeKn7DgkSF8lCaC4zYOPlmbEcK5oKJ8E=;
        b=ZyHsn3yON5+16j5hIBUHsUSMsGkrXPnOdFpugE7P5P3kbZam4qrny1UbTy4UU6WwxT
         nO7otoPMpRRk7zfVnUP1R6dBf4xnQRvbJMlf3t1MUC1vabsnYnMS9G7yC+0fCzUhSNZe
         440xkkH62oAAn0/AkzuYJ3D0W00QEislSOVAIr8mHRyhlEJqusBOIzWXs5mfNAUXLM7/
         uM3DGlh6s9/K5fJpW1aGmoSCLNaWieMHq/B3oO/ocfNFRSYwF1cJ9a3Mnc8oib+KPpSD
         azOrHXgdpXtHlqRe3qir2vBTRwjmFYga/+OZStYC1sMERlpFTlsQ2tFgRUTsYZ/KRwm2
         rIgw==
X-Gm-Message-State: AOAM530yJEKkZMDGZlDhCD5Qb7k/5cQuErKV1+ZOc4vPJue8HxHRTfyN
        7mZ4juQJAvf8/Jc9tefJgmX8KT/4umjMAjqd
X-Google-Smtp-Source: ABdhPJzAnlyVPxABDimUPXeNjF1QiCzR2RZtLMSMwEzHIf1Yk8gce86GvJVM9NQSkYxSWISERzesXw==
X-Received: by 2002:a1c:6187:: with SMTP id v129mr1711883wmb.35.1598886611622;
        Mon, 31 Aug 2020 08:10:11 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f6sm14181636wme.32.2020.08.31.08.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 08:10:10 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 14/15] net: bridge: mcast: improve v3 query processing
Date:   Mon, 31 Aug 2020 18:08:44 +0300
Message-Id: <20200831150845.1062447-15-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
References: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an IGMPv3 query is received and we're operating in v3 mode then we
need to avoid updating group timers if the suppress flag is set. Also we
should update only timers for groups in exclude mode.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 55c2729c61f4..3b1d9ef25723 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2052,7 +2052,8 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 		}
 	} else if (transport_len >= sizeof(*ih3)) {
 		ih3 = igmpv3_query_hdr(skb);
-		if (ih3->nsrcs)
+		if (ih3->nsrcs ||
+		    (br->multicast_igmp_version == 3 && group && ih3->suppress))
 			goto out;
 
 		max_delay = ih3->code ?
@@ -2087,7 +2088,9 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 	     pp = &p->next) {
 		if (timer_pending(&p->timer) ?
 		    time_after(p->timer.expires, now + max_delay) :
-		    try_to_del_timer_sync(&p->timer) >= 0)
+		    try_to_del_timer_sync(&p->timer) >= 0 &&
+		    (br->multicast_igmp_version == 2 ||
+		     p->filter_mode == MCAST_EXCLUDE))
 			mod_timer(&p->timer, now + max_delay);
 	}
 
-- 
2.25.4

