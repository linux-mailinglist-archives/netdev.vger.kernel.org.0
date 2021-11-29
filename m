Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB12A461671
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343686AbhK2NfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238862AbhK2NdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:33:03 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87546C0048FA
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 04:10:40 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id r11so70923571edd.9
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 04:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZnvxHcoCwvsT2y6DTDcaYouzUiZYaxyX3t2w9EbtwoE=;
        b=UXOuRqwkrvfv4rTm5uoy08HMnKfoeVeOem7tu32CjtD5RLhX6L5k4hjA60enK9EU3i
         szCVhApOOMynb2TnITdACHUW5oKsMZ+8k0Q5dqk2sLr7Ymgm3InPY21HEQEt7GfhOnOY
         UXxithWKv6XcnotjAF2A2Ax/l1QxrivIVBs6id7fFS1A7QoGqHJneoipomq/xNsNgpai
         OFf+jeULqsZc6pWk3E2Rc1dPBh7nzEOWs/l0uc4H8HmGfjmwFTYxjyiKfwivpxxLGVO+
         vxBlmOQ0yQexiBp44CAMXnLSjAe8oTBFHPnzKp7oWxS150scekqTyxA/SIDUMkvv1HnN
         sJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZnvxHcoCwvsT2y6DTDcaYouzUiZYaxyX3t2w9EbtwoE=;
        b=bjc/A+ul+AjNG5El9mv7RFrnp+euUj1C34uAWNvBbx1AU5LaT0SYj2ZCKCockjZFMu
         mtoR69a08F/QEbpaEuornFc7WL/rF+zodDrHB/3VtMS8AC+jnpVGOmT1DrVxFKR36W2Q
         RIk7B0VJWGNYosfhnNzJEcHPDwuS5Shi9S4g7+LwtTUy/iFUFSMKx26t1wsI1jZvasqW
         ifPKrC77gGELUepCSQ7q6VY0oXAOp1r0Z1b0/3T3jcJ7bU38GSyDA6PUAaiGirI4+vpb
         5EAAVctmeT6Zqr73PEJ1Bq3yM5nhAMR7Z7ObIGcos/hdbvVQraT9V/ENqyG6Rrtu+f9U
         j04Q==
X-Gm-Message-State: AOAM532Ef8geJCrDMFJynYN7lL/D/BlIuH97RCudCcj7se7/bjnacZUo
        Wuy+tVGezIqLoWwq0tVZyvjWmggGjvUeZafC
X-Google-Smtp-Source: ABdhPJzEbv0Vbvvm3IzL8V8761UdUkGF937xAMXCAbHB9AHQTvzG3bUDWUm1hsSPxjbi3cYPrpw41A==
X-Received: by 2002:aa7:c390:: with SMTP id k16mr74162307edq.161.1638187838849;
        Mon, 29 Nov 2021 04:10:38 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f22sm9882089edf.93.2021.11.29.04.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 04:10:38 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next] net: ipv6: use the new fib6_nh_release_dsts helper in fib6_nh_release
Date:   Mon, 29 Nov 2021 14:09:35 +0200
Message-Id: <20211129120935.461678-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We can remove a bit of code duplication by reusing the new
fib6_nh_release_dsts helper in fib6_nh_release. Their only difference is
that fib6_nh_release's version doesn't use atomic operation to swap the
pointers because it assumes the fib6_nh is no longer visible, while
fib6_nh_release_dsts can be used anywhere.

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/ipv6/route.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 62f1e16eea2b..b44438b9a030 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3656,24 +3656,9 @@ void fib6_nh_release(struct fib6_nh *fib6_nh)
 
 	rcu_read_unlock();
 
-	if (fib6_nh->rt6i_pcpu) {
-		int cpu;
-
-		for_each_possible_cpu(cpu) {
-			struct rt6_info **ppcpu_rt;
-			struct rt6_info *pcpu_rt;
-
-			ppcpu_rt = per_cpu_ptr(fib6_nh->rt6i_pcpu, cpu);
-			pcpu_rt = *ppcpu_rt;
-			if (pcpu_rt) {
-				dst_dev_put(&pcpu_rt->dst);
-				dst_release(&pcpu_rt->dst);
-				*ppcpu_rt = NULL;
-			}
-		}
-
+	fib6_nh_release_dsts(fib6_nh);
+	if (fib6_nh->rt6i_pcpu)
 		free_percpu(fib6_nh->rt6i_pcpu);
-	}
 
 	fib_nh_common_release(&fib6_nh->nh_common);
 }
-- 
2.31.1

