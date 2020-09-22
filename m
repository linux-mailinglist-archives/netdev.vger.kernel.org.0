Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B8B273BE7
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbgIVHaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729843AbgIVHau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:30:50 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1EFC0613CF
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:30:49 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id a9so2226580wmm.2
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v0VyLBidFMgxaEIbE0qIA152wkMYPe0lHT8kdjtZmtI=;
        b=zbAOCZzno3G76ktSrpwFQ832xwc2ICqQyx1yQ4rBV/xmC/IoFF95FWd8yUAdc6Sm5W
         8LJpaWTWg7I8F4ipMdBDQDl4lylyzmJtfEZBLfS1JaGjX/ngr1b05vj/BH+vk/IcrRvu
         Nz0n1CQ30QMkNTsqN8mkeAA3QFPz0a8usehPA70ywRTeaload2kkOH59MCJWXPLjRqeg
         S0Ld7cB4QxTi6J1D0uIXwmtHWsTOz7/H2iKPuFlSDTjDj1AfIYe/ofPv502n+Q5DSWiq
         NE1zuN6KqA6nD8+im5KIKbDqB96O+wAnML3Y2WgIYZ4Equd13+9loI3D815Fdn3ZhCGb
         OOfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v0VyLBidFMgxaEIbE0qIA152wkMYPe0lHT8kdjtZmtI=;
        b=arYkuoA2tlf3sqOi2r8/puHNQ3EA0cnj1uh4oIUIm09CbcTSSUgU53aDOxRvfcuJca
         PyTtNuRshYh4ARErX2Icx/oqfo2T1XaQM8y5snZn0DM7bME423jpfsrOaGqSQlW9vc10
         6eF7brwkL/RrYtes52VKOQlqWCViN4TOA4GtBZzum/xbxjwAH+yb+iJchgsEBPWq5HF1
         9cpKl1pYWy0Yw9Zn7XteMuodv2KJBcly4k5X00QMgy3ehpcXcZOWWv7PZAVjYQOPk53B
         nJtHFx5O4uGrMR69hv8yUu4h+PK4ocq9pn3x/VlovxYmE+a+I7NVpjzjjsCb01XIYAFX
         J9gg==
X-Gm-Message-State: AOAM530potHfuyrsiyTm4IlivkYtrUkEApaRW98Z56BBaf9J8lzEDsnf
        sYij0kpL1Sq1J2OGlNZSImJLQgOSm9UEI6LidAsa0g==
X-Google-Smtp-Source: ABdhPJxTSZwlJKrXg8yIFU3293BDY5mSne2Y9I/rD8Z+ZuqoUPHMuah1/sWNvM3c9qDV0/E9vE1JhA==
X-Received: by 2002:a05:600c:2118:: with SMTP id u24mr3016942wml.59.1600759848026;
        Tue, 22 Sep 2020 00:30:48 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s26sm3258287wmh.44.2020.09.22.00.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 00:30:47 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2 04/16] net: bridge: add src field to br_ip
Date:   Tue, 22 Sep 2020 10:30:15 +0300
Message-Id: <20200922073027.1196992-5-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200922073027.1196992-1-razor@blackwall.org>
References: <20200922073027.1196992-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a new src field to struct br_ip which will be used to lookup S, G
entries. When SSM option is added we will enable full br_ip lookups.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/linux/if_bridge.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 6479a38e52fa..4fb9c4954f3a 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -18,6 +18,12 @@ struct br_ip {
 		__be32	ip4;
 #if IS_ENABLED(CONFIG_IPV6)
 		struct in6_addr ip6;
+#endif
+	} src;
+	union {
+		__be32	ip4;
+#if IS_ENABLED(CONFIG_IPV6)
+		struct in6_addr ip6;
 #endif
 	} u;
 	__be16		proto;
-- 
2.25.4

