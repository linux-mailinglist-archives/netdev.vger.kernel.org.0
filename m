Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 742F97F68C
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 14:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392209AbfHBMKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 08:10:34 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44053 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388969AbfHBMKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 08:10:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id t16so35923834pfe.11;
        Fri, 02 Aug 2019 05:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zb76oH2B0EgvBnkGvjJsVprorUYMzOXSeiMXnMsRgPI=;
        b=L9/FIrnLuXe1WbHvwqtmCM7Z2JRZnDeL7xGy1Ftr2+ookandTsC8Q8pNagMoPZ686H
         k6ygyhLXbhec0JXqpkY36bOfRETpxkBxajqh9aRahRElr5KKMM36NSft24N9HHB8Rwai
         yRjl9xQNL163975wtJvb8N7IfWWXw0u+VjrylcbPz8Ft4iE6J2Ijm9d7o6q/gjtndYWt
         jmise7uMiRGzwt2qxfdlpMEG6zUBuqtXJ/v3ju4z1CT53m5gVOumwS0ooJ+ZybI6qLKv
         7u7vjG+RLoCZGk4hklfSm2Dqiefg9aJ46MeLbUI9OLXVyYGaQmfkGqf+7UENSIprlH1X
         gdAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zb76oH2B0EgvBnkGvjJsVprorUYMzOXSeiMXnMsRgPI=;
        b=pyUBoNOSv5gc3g1lOUyjZamlq14Y8OfwAMXMn7ZTm9BXGd/xP2M3LaaojWTpLdvo0r
         da/Pcf3OyiiVHBP1NxpimtfYS0st7HMOlAunEXByhZIk+UVFK0JJRLhcvvAbhjX+2vl4
         67hdcLSuy+2i1FbFE+LgOdc14UYdsjrXEf3+PorNnsm4teDAOePEW69f1TjmMNs3fyVq
         8qbs5Pt7SrDq1q7vR/I4VcpsWDspNppoTha7C6LBTd3t6boj/SCpePI1zU4I0pGNw17j
         yNtVO/4pNTr4TnvCx1KhQBwGf/gozcCFHwMhI5H5EzZOXxAVO9hyB7JXGmc8WHKFMotq
         ab0Q==
X-Gm-Message-State: APjAAAUKQ0gVO/7S/PPbK+cfx0u7Cvi9+O2+rZBi2Hj2B/m6DrH2Q9of
        C1f2w4Tjr0OyGcqiS7aR3dA=
X-Google-Smtp-Source: APXvYqxhrIwTxSjL4n696+iArx1lYw+t7rCGWcRw7ajbGla5R8w32dhhwKvS4GA3uB82/hPyGBd1ew==
X-Received: by 2002:a17:90a:20a2:: with SMTP id f31mr4008731pjg.90.1564747832743;
        Fri, 02 Aug 2019 05:10:32 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id w22sm80162301pfi.175.2019.08.02.05.10.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 05:10:32 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] net/mlx5e: Use refcount_t for refcount
Date:   Fri,  2 Aug 2019 20:10:27 +0800
Message-Id: <20190802121027.1252-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t is better for reference counters since its
implementation can prevent overflows.
So convert atomic_t ref counters to refcount_t.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
index b9d4f4e19ff9..045e6564481f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
@@ -48,7 +48,7 @@ struct mlx5_vxlan {
 
 struct mlx5_vxlan_port {
 	struct hlist_node hlist;
-	atomic_t refcount;
+	refcount_t refcount;
 	u16 udp_port;
 };
 
@@ -113,7 +113,7 @@ int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
 
 	vxlanp = mlx5_vxlan_lookup_port(vxlan, port);
 	if (vxlanp) {
-		atomic_inc(&vxlanp->refcount);
+		refcount_inc(&vxlanp->refcount);
 		return 0;
 	}
 
@@ -137,7 +137,7 @@ int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
 	}
 
 	vxlanp->udp_port = port;
-	atomic_set(&vxlanp->refcount, 1);
+	refcount_set(&vxlanp->refcount, 1);
 
 	spin_lock_bh(&vxlan->lock);
 	hash_add(vxlan->htable, &vxlanp->hlist, port);
@@ -170,7 +170,7 @@ int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port)
 		goto out_unlock;
 	}
 
-	if (atomic_dec_and_test(&vxlanp->refcount)) {
+	if (refcount_dec_and_test(&vxlanp->refcount)) {
 		hash_del(&vxlanp->hlist);
 		remove = true;
 	}
-- 
2.20.1

