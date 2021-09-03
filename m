Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939A33FFD3E
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 11:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348911AbhICJfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 05:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348847AbhICJfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 05:35:39 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FB3C061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 02:34:40 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id u19so7142846edb.3
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 02:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aiR23CdvX/YW7ASJTZF8b+8Ds0NXrhmWhy57VeViwyo=;
        b=QLeBRmfebetUgt50tunwIMdWH6Xh1XJU9NxhzbFJAB/SEky4PZPW1vehsAR9QpJ1jd
         xnwHiEdsUpkVp20AXnOhuhqv4wrkuEjJUMej4dHJCqo87Bx5RtJ50Pnt35QfLSCW110V
         O6BT5W/I6LvhXGAadQUXekqC7NFdbPWz9lVQPpHVuoA0aJpWuoBz6Jd7GOm+epqC4AxX
         BzNWPn8aBkBPVwINR4Sk3omo8C/M1BzSgwWTODeAs0P52L0HMrc3Yz4637W0bbelGtZL
         LVCDk8IijuC90eH7mP8I5Yp5mCNT7b3nb8tFBQ/9QP6h/CqUf1mxAdjMfYpjFlRMLi4B
         oHCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aiR23CdvX/YW7ASJTZF8b+8Ds0NXrhmWhy57VeViwyo=;
        b=bEVmu8oPeT8t8yzOL4IM9OQ2HIe+xcYp4ybNa22omAk3fO9Zk0xcqPDeAsA0stYWAl
         8JKKYtkBAgnabXa6HzeaPvQR7EKbuGXZ9xIDWHXbX3Vb+MOkKwr/U3N30Zgear3Gu6Y8
         1K4MI7SkgCAkqaldoj8RFslVrXJYPzxzz9mrxQqMPj9tcb6We0PKgaLVJC39Ai5MyjSO
         KNudsnBti5Nre2n7Vks6zG7qZaqFPtMe85EDi1HY71DKjQw2bkv0AKG5RffQG88nzvr1
         981AxxwR4Kn3+2cOba6T7GnTSYzxLL0G//IeF9cwoGptXWVpXJjUT29NOowCxVbnXC1G
         ISeg==
X-Gm-Message-State: AOAM533Qmg0xfQ7chvZkp8hqcOlfsaeHYKoO34b+0U6ff80XZyR2q2sO
        MWyn/MDQLwqGi6rIivO4woq5DILCokvAjaXu
X-Google-Smtp-Source: ABdhPJzGrUF6AYGm5GxlQiWgn7mYn1S8u6cNLXl+74+F+FMUItvxWJaejiL4PMudXeR6R8o86OePeQ==
X-Received: by 2002:aa7:c903:: with SMTP id b3mr3061137edt.23.1630661678298;
        Fri, 03 Sep 2021 02:34:38 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id ck4sm2586391edb.67.2021.09.03.02.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 02:34:37 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net] net: bridge: mcast: fix vlan port router deadlock
Date:   Fri,  3 Sep 2021 12:34:15 +0300
Message-Id: <20210903093415.1544837-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Before vlan/port mcast router support was added
br_multicast_set_port_router was used only with bh already disabled due
to the bridge port lock, but that is no longer the case and when it is
called to configure a vlan/port mcast router we can deadlock with the
timer, so always disable bh to make sure it can be called from contexts
with both enabled and disabled bh.

Fixes: 2796d846d74a ("net: bridge: vlan: convert mcast router global option to per-vlan entry")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 9231617a16e4..3523c8c7068f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4255,7 +4255,7 @@ int br_multicast_set_port_router(struct net_bridge_mcast_port *pmctx,
 	bool del = false;
 
 	brmctx = br_multicast_port_ctx_get_global(pmctx);
-	spin_lock(&brmctx->br->multicast_lock);
+	spin_lock_bh(&brmctx->br->multicast_lock);
 	if (pmctx->multicast_router == val) {
 		/* Refresh the temp router port timer */
 		if (pmctx->multicast_router == MDB_RTR_TYPE_TEMP) {
@@ -4305,7 +4305,7 @@ int br_multicast_set_port_router(struct net_bridge_mcast_port *pmctx,
 	}
 	err = 0;
 unlock:
-	spin_unlock(&brmctx->br->multicast_lock);
+	spin_unlock_bh(&brmctx->br->multicast_lock);
 
 	return err;
 }
-- 
2.31.1

