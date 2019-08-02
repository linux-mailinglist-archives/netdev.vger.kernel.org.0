Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F457FEE3
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 18:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391249AbfHBQsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 12:48:35 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37135 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388211AbfHBQse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 12:48:34 -0400
Received: by mail-pg1-f194.google.com with SMTP id d1so3528302pgp.4;
        Fri, 02 Aug 2019 09:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YgwNXbdRzIMClAStYn5LCztSjKPnlA/LIgZ8UT/xatA=;
        b=UZDxJOLnyvIswpZAxRFxNHwJm7Sbkf3AJsD7L880wY/ytbPBIqrn41SiyqfmmNkP0x
         51xVnMUUExEV7nKSioYeuLKhH3igFZ2dDoSruiyutXOd4HWje7n8SCbTVZHmVZTbCPLQ
         WoMSTfIUDMoTmTfXnHs8ntlzFphDeLT8zdrKCJzYpaKMTUfyuWdjxwF+9IZX4sKxz+Y0
         iItIvWi9aezEG+60j+jsr7JtlUW6o9p2vadfuSc4hDe877ZUfjaZvSRriMPBwH3DrdzP
         zoKkMLM8ii9asLUbdgNaSkRmD03zWs3HN8i4Kkm/xiYm5eI9XyhPlweKi4wNKdgMNTGR
         jYWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YgwNXbdRzIMClAStYn5LCztSjKPnlA/LIgZ8UT/xatA=;
        b=Nw01D/lG1oKYfkDyfm2L9ItFT4Flu1CMFtvJhVxHewydgCd5GklGV7r3+TWxup4Tuo
         KTZ3w7YPL9uvXSlrHD/5YGahswDU9TXPP7nUvSJ+9RFkZNBLoCKk/hq7uPiAmIBelVsm
         8B131sFmRYfLJpjH87vmjQFAJ44dlCiFdxjscmDe02A5AhMwkrqmsuGKlYWMpnbf9Msz
         T+lfWAW9TaMj9HH1qRj6daMiyOG3BwVC8vvAzZv+N5DYcLDSeif2u6G5OE5z305Rfndk
         J/6eXOs9Q6Y1gfhCivyC7cm2eGET9fmdAGq3S2SW5pWtBnCanZag2E6+umE+XpJ4s0aC
         VNXQ==
X-Gm-Message-State: APjAAAUyv3NL73nVSuhqWlvmRWpccJibz05w0VYYMmThmhG6XWdSrUL0
        OPsWWIKYIgOxqSaBH+j3Stk=
X-Google-Smtp-Source: APXvYqyM9GUGvhdkBJkzKQIlr97cN5tCZAawYEf/vOiB8h+Kr5z5GRq3TMMEYl/eeC3uge+Hg72zIw==
X-Received: by 2002:a17:90a:898e:: with SMTP id v14mr5176595pjn.119.1564764513767;
        Fri, 02 Aug 2019 09:48:33 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id m31sm14470902pjb.6.2019.08.02.09.48.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 09:48:33 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v2] net/mlx5e: Use refcount_t for refcount
Date:   Sat,  3 Aug 2019 00:48:28 +0800
Message-Id: <20190802164828.20243-1-hslester96@gmail.com>
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
Changes in v2:
  - Add #include.

 drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
index b9d4f4e19ff9..148b55c3db7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
@@ -32,6 +32,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/refcount.h>
 #include <linux/mlx5/driver.h>
 #include <net/vxlan.h>
 #include "mlx5_core.h"
@@ -48,7 +49,7 @@ struct mlx5_vxlan {
 
 struct mlx5_vxlan_port {
 	struct hlist_node hlist;
-	atomic_t refcount;
+	refcount_t refcount;
 	u16 udp_port;
 };
 
@@ -113,7 +114,7 @@ int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
 
 	vxlanp = mlx5_vxlan_lookup_port(vxlan, port);
 	if (vxlanp) {
-		atomic_inc(&vxlanp->refcount);
+		refcount_inc(&vxlanp->refcount);
 		return 0;
 	}
 
@@ -137,7 +138,7 @@ int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
 	}
 
 	vxlanp->udp_port = port;
-	atomic_set(&vxlanp->refcount, 1);
+	refcount_set(&vxlanp->refcount, 1);
 
 	spin_lock_bh(&vxlan->lock);
 	hash_add(vxlan->htable, &vxlanp->hlist, port);
@@ -170,7 +171,7 @@ int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port)
 		goto out_unlock;
 	}
 
-	if (atomic_dec_and_test(&vxlanp->refcount)) {
+	if (refcount_dec_and_test(&vxlanp->refcount)) {
 		hash_del(&vxlanp->hlist);
 		remove = true;
 	}
-- 
2.20.1

