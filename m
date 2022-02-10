Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3754B17F3
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 23:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344841AbiBJWKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 17:10:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344832AbiBJWKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 17:10:03 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB43F6F
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 14:10:03 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id n23so12804389pfo.1
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 14:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qPFE4Zp5rbm2IQyqlfm7NXsxDl+45f9FHKMcmltWZhM=;
        b=BecGAhNqQKYBtuSt99I5RDK+OvickszP+NeK3ijUCL77o0dlQTbAy7BggM8aX4IETb
         cEpXpjKIFS7AJLjIwvKdvmPWB1Vni6UAFNlCB40EP1Whtvmhh9PIcbfuDUk0IFMrGJH6
         2EHsAlEV0bVFb7TTxLd5m4MQ9wwFizcKa4RZrAa5ryY4J0yi9PA/55ewUkwp4ZN5yYOK
         sjGtR6sq1gFrg6cmc34y6GDB5jXmh8Q9riwznb6bhB59llLXYVHLRFQJgpUj+3tVFAy3
         SauljF+zxpTbCj5Mau4X2QEY4vf3By6ULIoM+4mnpYOJHKZrlXdCLxRdPPCwzL4TvPmK
         Ks6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qPFE4Zp5rbm2IQyqlfm7NXsxDl+45f9FHKMcmltWZhM=;
        b=fsJzPjqj51ILouRsdGmvoWoMl0l+YpNMhFjqLJW8TWxzxKf0kl/7xlAeUCi21TiUe6
         TgMi+XxxQlMXg5mSvtHHmi+mrzO3g4FQM67OH6ThQmGx5xIMYQV8zEZV8/Xz46jvFqKF
         eHZ5cmY96YT1u0AOsqQA/Lf3aL0dW37Qc/ysy7ftWTFGdxSwgZeTzFmloozSHDQkeM0U
         15zcTp6dT6wfc7hXLqopDQG4gxV9aXkREtACDBZWA7NsQsFW/ajbBTFY1C2eqom412k/
         R7evFkI/EXKjutJLi3+k/n8V85c1c+sdSDSL7TNfgtF1EDpoczEMu6O0qU4tFwwG8LAG
         xgWQ==
X-Gm-Message-State: AOAM533YU3mMbI2LZo3ApN2LrqmudxmH+a1hp3tBMUvUJkFYPjNinHps
        jq2dzwYNk2nPdl11b1KF3laZHx6+MiF2X7A5Fpg=
X-Google-Smtp-Source: ABdhPJy/6kfvRUGKsTucEgxDqPV2QGBA53s+SzuHMp3+/NwS5tGBIzsr2EtjnYA0ie6BtvIfuitpDQ==
X-Received: by 2002:a62:86cd:: with SMTP id x196mr5610683pfd.26.1644531002471;
        Thu, 10 Feb 2022 14:10:02 -0800 (PST)
Received: from kalash.aristanetworks.com ([64.180.125.150])
        by smtp.googlemail.com with ESMTPSA id c4sm12470147pfl.131.2022.02.10.14.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 14:10:01 -0800 (PST)
From:   Kalash Nainwal <kalash@arista.com>
To:     netdev@vger.kernel.org
Cc:     fruggeri@arista.com, kalash@arista.com, dsahern@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] Generate netlink notification when default IPv6 route preference changes
Date:   Thu, 10 Feb 2022 14:09:35 -0800
Message-Id: <20220210220935.21139-1-kalash@arista.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Generate RTM_NEWROUTE netlink notification when the route preference
 changes on an existing kernel generated default route in response to
 RA messages. Currently netlink notifications are generated only when
 this route is added or deleted but not when the route preference
 changes, which can cause userspace routing application state to go
 out of sync with kernel.

Signed-off-by: Kalash Nainwal <kalash@arista.com>
---
 net/ipv6/ndisc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index f03b597e4121..1c06d0cd02f7 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1337,8 +1337,12 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 			return;
 		}
 		neigh->flags |= NTF_ROUTER;
-	} else if (rt) {
+	} else if (rt && IPV6_EXTRACT_PREF(rt->fib6_flags) != pref) {
+		struct nl_info nlinfo = {
+			.nl_net = net,
+		};
 		rt->fib6_flags = (rt->fib6_flags & ~RTF_PREF_MASK) | RTF_PREF(pref);
+		inet6_rt_notify(RTM_NEWROUTE, rt, &nlinfo, NLM_F_REPLACE);
 	}
 
 	if (rt)
-- 
2.30.1 (Apple Git-130)

