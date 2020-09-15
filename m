Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFDF26B312
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbgIOW7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbgIOPHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 11:07:53 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9EFC06174A
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 07:57:38 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id n13so3324981edo.10
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 07:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V0oVeorJEn639RUtHYFD9WKWaUEUtKz13YDNA91Zt1M=;
        b=VNhG4zHEKDWxe/WBUk+BEg4hHxxdD4aw6BHfCqYM/7+u34DRHtu5P7rDWDKRF2SXSG
         QMPOQmY3+CnpDK/dDjJuZUnqmSfll9zei2DQFzwzvr+/V1+KWrIKCMAGdVLEMCvjcrTW
         AkNEB8uwQqlPiEDzKCsgb+uIg8h0PscZzoBhE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V0oVeorJEn639RUtHYFD9WKWaUEUtKz13YDNA91Zt1M=;
        b=fzHRuYqQsWj2CS5VJkEAAICnMR1UjuevHMoEQUM9uxFDqy5pbSA32Gz8RONXVcTUV3
         Vo0TOTJzp/xLF1P/m1vnyK1gWLCcn2CxTzweLfR/huw2QBuhabTYtr2mZqHYDj+lBC+K
         fbP7bJ9AFFagoLXyD3QMwlppDEUeEZjugYgs2BTNuWLa5MLYljh37ZBariNZWjOKXLrh
         3P6V0hKZjIDWpz8NuvNb8g54vZ5XdxKD00EkA/uza+nKQsRIr/zMizIouOjValUJsHYL
         xI7OWwzhEZR9GfVjiQLCuoX2xBUw2nG1pQS1tdnZ65IQ9VjSX1cDpv79lgWSt6qghV52
         29ig==
X-Gm-Message-State: AOAM533zFdpFkinpX4JHg8/M8+RJJJGwKflKsEMFMqAk/IYLwQWP1ol2
        Ph2AeWnMBgPwOjRv8Nf/HSPr22/JRoVwWA==
X-Google-Smtp-Source: ABdhPJzAY2rvtPAX3p+iCT0TCc1/IqUnwzAOXGRCF1BXWWkr1TNlJe8m5QiOvSUrdBN9sQEQ4mxZfg==
X-Received: by 2002:a50:fc87:: with SMTP id f7mr22614057edq.162.1600181856204;
        Tue, 15 Sep 2020 07:57:36 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m14sm10255700ejn.8.2020.09.15.07.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 07:57:35 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next] net: bridge: mcast: don't ignore return value of __grp_src_toex_excl
Date:   Tue, 15 Sep 2020 17:57:24 +0300
Message-Id: <20200915145724.2065042-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we're handling TO_EXCLUDE report in EXCLUDE filter mode we should
not ignore the return value of __grp_src_toex_excl() as we'll miss
sending notifications about group changes.

Fixes: 5bf1e00b6849 ("net: bridge: mcast: support for IGMPV3/MLDv2 CHANGE_TO_INCLUDE/EXCLUDE report")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 33adf44ef7ec..e77f1e27caf7 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1710,7 +1710,7 @@ static bool br_multicast_toex(struct net_bridge_port_group *pg,
 		changed = true;
 		break;
 	case MCAST_EXCLUDE:
-		__grp_src_toex_excl(pg, srcs, nsrcs, src_size);
+		changed = __grp_src_toex_excl(pg, srcs, nsrcs, src_size);
 		break;
 	}
 
-- 
2.25.4

