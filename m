Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5571462076
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351341AbhK2TbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbhK2T3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 14:29:07 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBCAC0619E7
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 07:45:43 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id r11so73866699edd.9
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 07:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pyCZ3N2/s9z1KvrmmNMWax4N7x3EG1EhXxsdNmvBuM4=;
        b=VAgeWABXgNoJ0RN7xP8bO9tjnYW9+i82AQuYn26LhrT/TQTiqmnJAtV94v/oXTPRPb
         9fGOklJKE2PdOvuNFgYH7ljCypKpTmAFs/XyjDo/lH9PmfH6aUZweUdJ3dX3FOpo6Esp
         VrdmzBkbYawY//md1DMxklcQZy9rm4/Xl6CdJhVX4OaR3/L4WLiHvkzMVVAFvwxIka/g
         qZuW/+yj7fdf9j3yT81njp7TNdh3MJrcX+jZASpvFbSExTjusYya5aQFZhLQrgcbYAl+
         uuwcbDgDT2UHpRU+sFWXd2UnzsEkKJZOoiKV+jvTqHM+9xgLlG9oU3XnjCuYq627bcFy
         hNgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pyCZ3N2/s9z1KvrmmNMWax4N7x3EG1EhXxsdNmvBuM4=;
        b=azQDN/NXGW5tPskVSDjHARD4dzysM8zlLvVYn6WOe0i7CYs2DzpIPPHnycoZw2Amrf
         tmH+cKjbLH3MKe4QJLcB5OzshPVgR7DQvRl1ckzJe3PBfBuFLjcoVhLBFFOGzCC8TCpm
         SoOPjpPf4atuwVIbW6x0K77J6czBUh9T0Gv1j17blowQamMkK3AQs2dWLVI5IqZHwLOs
         TdHRDaBe+L6vifySevIdA9JobRWMzXLLp17rPuJbhWMbX/roJ+g8ZZ0Dr8jODzpKxz7M
         fQ0x0Z2Tq2i04G7odt7kZS4ORntdh9cBUsW2oYsB2aZgekWQHxpe4Y+x72wSWisEvpEQ
         K4eA==
X-Gm-Message-State: AOAM530FCp15ZUCpSwYm1VhnhYdyVHpEUq/uizvum53OXzhpznc620TA
        wO30KaBzbsswKP2moGc84eIap2J0qH/1FgRT
X-Google-Smtp-Source: ABdhPJzuZjfkDoLx/gV4cmgLUeki9U6mQqnaezNJ6EFVrjK8V9yoR9640t6HkfJnDo2xoJWyB50vxw==
X-Received: by 2002:a05:6402:1849:: with SMTP id v9mr75503663edy.335.1638200741324;
        Mon, 29 Nov 2021 07:45:41 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id e26sm9623972edr.82.2021.11.29.07.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 07:45:39 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2] net: ipv6: use the new fib6_nh_release_dsts helper in fib6_nh_release
Date:   Mon, 29 Nov 2021 17:44:11 +0200
Message-Id: <20211129154411.561783-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <8f11307c-9acf-2d83-a7f4-675c46966ede@nvidia.com>
References: <8f11307c-9acf-2d83-a7f4-675c46966ede@nvidia.com>
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
v2: no need to check for NULL rt6i_pcpu before calling free_percpu

 net/ipv6/route.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 62f1e16eea2b..f0d29fcb2094 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3656,24 +3656,8 @@ void fib6_nh_release(struct fib6_nh *fib6_nh)
 
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
-		free_percpu(fib6_nh->rt6i_pcpu);
-	}
+	fib6_nh_release_dsts(fib6_nh);
+	free_percpu(fib6_nh->rt6i_pcpu);
 
 	fib_nh_common_release(&fib6_nh->nh_common);
 }
-- 
2.31.1

