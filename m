Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6646232F4
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 13:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbfETLpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 07:45:05 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39719 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728719AbfETLpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 07:45:05 -0400
Received: by mail-pl1-f196.google.com with SMTP id g9so6607552plm.6
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 04:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=d690Nqeu/t4AXfT9vxWNRK5PHiGxTOFeDAiCOR1nZzE=;
        b=h6vw/CiB8+CgRnAWiHjdEXCO3no1JTd3zcmkSXplMOCK38R4d7mxyfylJETMy4JVx7
         8/FnAJvLzo5wJM1wlG11jIbl4ePoaSKEx1hoTkh3I4tOHJ8sRZ7OQE6fJR8Cucn46ecs
         /6Iox8P+f89ceEuL2kmPuNkDzkEYWJIGkbGPXIEUw56KUddpn9FLf2x4xr/ZjH194y0B
         p6r+euI2l0XUu+Wh7xm6AVzqO0SqRoCghj7wCzR0InQFsVweGVxncoJv5KrZ3tXZSWPl
         nEQlUUwUH002mz1i2MEvffprberYlJumoIAU4IsIEZaLAI7JB40RdNEv759migbI4Tc4
         BHVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=d690Nqeu/t4AXfT9vxWNRK5PHiGxTOFeDAiCOR1nZzE=;
        b=RgGpxZ4R1MZCb+7Mbt9GWWAAlxRDdAIPMAMP8lrMKYBIKHp1TttJWLA10znPSKeBR2
         bzVPg+D38iYb6PcEPYKQSkhWASnioL+Q0v1FM0Lzo+eKVwIqj+5u2euJOcR2nUZjg3VN
         9sV2cbkIyQOATUfTp2t1RqGWKoWMHC0qJuyKk0/RSc9cn/uQuX7APCfKhnBfZZx3CZOq
         dLk1ZwJovYCPfEGIaULQrDpSdKsdgsZJDMUYS4IglAfUu+Gct8FBb6X5IBorIxuS3Zdg
         2DCWc2Ne5rk62pilEDYrAKo9l4wktQc1TK3/YOvRhwb53gzdCvb4ApjujllqWYjjiA3S
         know==
X-Gm-Message-State: APjAAAXTITggQKOUor1DBihvrnmO+MXIvChkhgkFLsFPVgOHHiQfqneG
        3sjmRWuT2bh2EKZ71YDYuCk=
X-Google-Smtp-Source: APXvYqy5+FruWcm0rKate2E6oPlEeUO/74RIu5VSADhNBWxaqPv7JeQOOe+2ge6Le+lfWz4TpHP07g==
X-Received: by 2002:a17:902:b407:: with SMTP id x7mr76648880plr.28.1558352704860;
        Mon, 20 May 2019 04:45:04 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id h5sm1406837pfk.163.2019.05.20.04.45.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 04:45:04 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     roid@mellanox.com, saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH] net/mlx5e: Allow removing representors netdev to other namespace
Date:   Fri, 17 May 2019 17:54:41 -0700
Message-Id: <1558140881-91716-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

At most case, we use the ConnectX-5 NIC on compute node for VMs,
but we will offload forwarding rules to NICs on gateway node.
On the gateway node, we will install multiple NICs and set them to
different dockers which contain different net namespace, different
routing table. In this way, we can specify the agent process on one
docker. More dockers mean more high throughput.

The commit abd3277287c7 ("net/mlx5e: Disallow changing name-space for VF representors")
disallow it, but we can change it now for gateway use case.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 91e24f1..15e932f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1409,7 +1409,7 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev)
 	netdev->watchdog_timeo    = 15 * HZ;
 
 
-	netdev->features	 |= NETIF_F_HW_TC | NETIF_F_NETNS_LOCAL;
+	netdev->features	 |= NETIF_F_HW_TC;
 	netdev->hw_features      |= NETIF_F_HW_TC;
 
 	netdev->hw_features    |= NETIF_F_SG;
-- 
1.8.3.1

