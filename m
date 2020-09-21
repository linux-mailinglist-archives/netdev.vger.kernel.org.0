Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127CE272BDC
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgIUQY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:24:27 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39575 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728282AbgIUQY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 12:24:26 -0400
Received: by mail-lf1-f68.google.com with SMTP id q8so14699130lfb.6;
        Mon, 21 Sep 2020 09:24:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UmsE6D5yGUl632K7T+FNTDnk1JQIT/BEp8imjFqsP34=;
        b=ojikTMr3mkttBwvs8xYRzzybDsUX6i+TYoBXbrLD88oslqhtC2G0/y4VVfjial4Umz
         Sl+CfZ3VCBfy26imS43thVgHK0qUqDjg1lruEH/wuilIFmTJH1Kmv6oXnbuQV17ht60K
         a3W7oGaJcHkpigRWQZlHl7lxB/MlNEZzDd52nBkIcfvkgRqX4G/yu/kaG2uHBZrRTv6S
         woNfr1KWdFn6QGCpGnpFrsb462J3tvXvrR2ri1Etm0w6DTPpylAvtaYQB88aP4jmdx/r
         wUtxj5CUmpsMHgM/cpCHUH5T8QMny29ts6Up/v06RkXps4McAhujC2otlQ6GosdOuE+m
         Pp+A==
X-Gm-Message-State: AOAM533SlaiDkmqGxyG7sw5PSy5o2kpBIh1EDwh212ajBk+uvwms0L/O
        B4CanFk/O9raG6vzZQ/fkTw=
X-Google-Smtp-Source: ABdhPJwJUu6qALfb5QsIsu/Fb64Vhjz3Yx/nJhH77oE944SS2v9lO4t1vC7omvnJJxy3+nkmyhuMxw==
X-Received: by 2002:ac2:4c11:: with SMTP id t17mr221649lfq.230.1600705464752;
        Mon, 21 Sep 2020 09:24:24 -0700 (PDT)
Received: from green.intra.ispras.ru (winnie.ispras.ru. [83.149.199.91])
        by smtp.googlemail.com with ESMTPSA id x21sm2686642lff.67.2020.09.21.09.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 09:24:24 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net/mlx5e: Use kfree() to free fd->g in accel_fs_tcp_create_groups()
Date:   Mon, 21 Sep 2020 19:23:45 +0300
Message-Id: <20200921162345.78097-2-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921162345.78097-1-efremov@linux.com>
References: <20200921162345.78097-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Memory ft->g in accel_fs_tcp_create_groups() is allocaed with kcalloc().
It's excessive to free ft->g with kvfree(). Use kfree() instead.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 4cdd9eac647d..97f1594cee11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -191,7 +191,7 @@ static int accel_fs_tcp_create_groups(struct mlx5e_flow_table *ft,
 	ft->g = kcalloc(MLX5E_ACCEL_FS_TCP_NUM_GROUPS, sizeof(*ft->g), GFP_KERNEL);
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if  (!in || !ft->g) {
-		kvfree(ft->g);
+		kfree(ft->g);
 		kvfree(in);
 		return -ENOMEM;
 	}
-- 
2.26.2

