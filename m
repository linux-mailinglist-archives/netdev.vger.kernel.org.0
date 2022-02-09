Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B937F4AFEA0
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 21:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbiBIUih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 15:38:37 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbiBIUig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 15:38:36 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7B3E00FA5B
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 12:38:38 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id y5so6427088pfe.4
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 12:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3CCwZDVWnTz0k1KLIvecC5nUo5ERwSy7pI4Pplg9Wl8=;
        b=euriZtsupOGjw8a7umqT2cBDmUzLH4VaDyzNGSo3vCdzBeVAEQwlwdsjpyhTvCDcnf
         JyhDahslFehlYA6KhhswwXeyV06XZ1Z8AvIonnkIK4H89xRvmsGGZiV1RknHadkxAAFH
         Lo23ARtbPshgAgbZ5Q1oDW9X0gpXcf/+JtqBpbJzJDh7xsrzE7Rl0UC3UZ0WH3z5Q/rk
         GiDZZt1HKmY1lDcSkVAj1sQxF1wd2env4RoJJ5jTxGBZgj1Y0vxX8w/VdAOUPY+wEXB6
         J2A21hXcM7EQu/d2RTLnOSzRpHUpRIA6NGtm2pJzx+J9VwH6n9hZgi2Ku8P6GVrgdLb5
         Xxqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3CCwZDVWnTz0k1KLIvecC5nUo5ERwSy7pI4Pplg9Wl8=;
        b=f/ZQRuKgFIE382kIjPQD6XkMVunOyBRtHDDLF7BOgPviPnH4Tbg4LQuKvls859iAe3
         13La4jLEyQcnL0lX2q6KXup6XYFxUdI3Ftx/GyMdvZceDLhQHRnQn9NA5RGWm0vKEwQB
         KIv2i5pe1p5IUGrfRzxJXyhAHslNediyfFV+luD7dVemSln11q7lEHoz4S250W6IrPta
         pNQlniNLoSWQtIybVmMHNH9qEYO0C8Pm9IdB3XSx7R4lf3iJCUBEtd/CejXtzvYHcD6g
         hWuD90xsUmqJkAnUEPcmJtmlaKjqijg5ab84CVt/RImChE8QasRjXDswxb70zh4VZdyu
         ek/Q==
X-Gm-Message-State: AOAM533qpmNiyIeGvRLtwhSKpfVgXbg4Si1vMvWy25h5iqWXlp8NIaba
        qKe3rZs7B6rCT2o7MLAv9TTAN2o5ulKdQX3s
X-Google-Smtp-Source: ABdhPJyZl9J2c7WQrcgVt2vZAMPqb1B2hJwEtuDLTLIv0TWjgnD8a+scZYKTNFnmpQ1YT7P8fEtFnA==
X-Received: by 2002:a63:89:: with SMTP id 131mr3348551pga.253.1644439117946;
        Wed, 09 Feb 2022 12:38:37 -0800 (PST)
Received: from kalash.aristanetworks.com (d64-180-125-150.bchsia.telus.net. [64.180.125.150])
        by smtp.googlemail.com with ESMTPSA id v123sm3722386pfb.12.2022.02.09.12.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 12:38:36 -0800 (PST)
From:   Kalash Nainwal <kalash@arista.com>
To:     netdev@vger.kernel.org
Cc:     fruggeri@arista.com, kalash@arista.com,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Generate netlink notification when default IPv6 route preference changes
Date:   Wed,  9 Feb 2022 12:38:18 -0800
Message-Id: <20220209203818.11351-1-kalash@arista.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
index f03b597e4121..fd14f5b1c767 100644
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
+		inet6_rt_notify(RTM_NEWROUTE, rt, &nlinfo, NLM_F_CREATE);
 	}
 
 	if (rt)
-- 
2.30.1 (Apple Git-130)

