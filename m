Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC12B421B69
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhJEBHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhJEBHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 21:07:06 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33065C061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 18:05:17 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id v19so12822346pjh.2
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 18:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oasCdNDrUupSD53GzACIA6sFTSpGe5aBlRfxH8/1cQs=;
        b=XJdNJO9omP6+qMFbmusmoo0pC/NoEH9XW96jISDJI6+Nf/Hu4N8ErcfQ6cJIgiBYcE
         2LF2LjT+ESVihWcthiDcdzgIvBOfCJqsO8ajAE8+ofQML7sYLerLCd9CwsLH5373Obu/
         Jbws5NoN/sZYEdwdlF/ZKzDgRTUkGDUytVJMcXYzNwrs1tjZ4K8qVMGWkfYI4l8o3K3C
         lkprLErqOrsft60kEdJuaTDcGdRHcWWoi1jbxmPC0of+toR/Tjv/9cePrgain1z0cE+k
         7K4pq3+jH7sSXvSHktjxsbGfJRSido2TIqIWnc2AZuz+BpmDUDsWOZXoKWB2IZQGTfCh
         uSVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oasCdNDrUupSD53GzACIA6sFTSpGe5aBlRfxH8/1cQs=;
        b=eeJkGP6LbBGkFTiie0zp0XC37/IaY6w5k/SP0PEJ0OQnXUBNKKfwJ2uAz+PBNZsTGs
         Qk/cNPnDsypZLsZV/8KjWRv4Lb2zVNUs8vu3QjHvwJ7tZjVDJ+hg3vk+y+9B8BOkNt9G
         nHNhFfOnH+NIxG8Bl6oR1JFuj2akGIx0JF/DT3QsZVOZKvoWCDeLyw9zJu7pjrxhslKc
         yRSpEwA6xnrmIdGvhvv64TeBWO0tCbAoTK889Tkkx6WVuZDfw988NgUayJLIJj9jygTP
         lyPMjVaERgdmu4Y2J9bLsNgjh8YPj3x9zdN5ixY52NYK2kNk5TAIDdqNWNS8LfN5v7FD
         yuFg==
X-Gm-Message-State: AOAM5314UeqGWe8oPpVUtBYeS7JTb3ZYPkkXKReUun3FX4KHp6LfGAh5
        rCY6lRG6gcIBlDQ4f4bWmLI=
X-Google-Smtp-Source: ABdhPJzav5LAUKT7XlrCddIW8PekeORykKQF4KuvJ2AU9XNgA60Eif9LXWJBzIl/h76cwF6winCyhg==
X-Received: by 2002:a17:90a:9912:: with SMTP id b18mr354697pjp.46.1633395916723;
        Mon, 04 Oct 2021 18:05:16 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7236:cc97:8564:4e2a])
        by smtp.gmail.com with ESMTPSA id d67sm6509348pga.67.2021.10.04.18.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 18:05:16 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 2/2] net: bridge: fix under estimation in br_get_linkxstats_size()
Date:   Mon,  4 Oct 2021 18:05:08 -0700
Message-Id: <20211005010508.2194560-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
In-Reply-To: <20211005010508.2194560-1-eric.dumazet@gmail.com>
References: <20211005010508.2194560-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Commit de1799667b00 ("net: bridge: add STP xstats")
added an additional nla_reserve_64bit() in br_fill_linkxstats(),
but forgot to update br_get_linkxstats_size() accordingly.

This can trigger the following in rtnl_stats_get()

	WARN_ON(err == -EMSGSIZE);

Fixes: de1799667b00 ("net: bridge: add STP xstats")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 29b8f6373fb925d48ce876dcda7fccc10539240a..5c6c4305ed235891b2ed5c5a17eb8382f2aec1a0 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1667,6 +1667,7 @@ static size_t br_get_linkxstats_size(const struct net_device *dev, int attr)
 
 	return numvls * nla_total_size(sizeof(struct bridge_vlan_xstats)) +
 	       nla_total_size_64bit(sizeof(struct br_mcast_stats)) +
+	       (p ? nla_total_size_64bit(sizeof(p->stp_xstats)) : 0) +
 	       nla_total_size(0);
 }
 
-- 
2.33.0.800.g4c38ced690-goog

