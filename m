Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 332067D897
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 11:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbfHAJbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 05:31:00 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44251 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfHAJa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 05:30:59 -0400
Received: by mail-pg1-f193.google.com with SMTP id i18so33846908pgl.11
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 02:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+rhMnLA+w80mi30OPe/rIR1GZHk3iZBFbYGSHMHQdRI=;
        b=SGi/oia8tw6HXa1+GrtpX5/moXS+XyvOHdE9Wyr9dmkZGiNp5h67SkbkVMWejd/na2
         tcAzpw9FzDrC7jV47M0MagTbYPcxFEKmqOcA5U7WvMTM/6SFYNNTKdxR1P2BCf1YueNk
         Rc4zC5STjjq/5ARS6KNadI+EjgZFKy64/vQoHWIX7w7Sm5zm9q38X7P7f4WnnPTq6J2O
         cAx7+ludn3qS6BsIuvwPlfkNduyWKHWv5DJa9pa5Mi/XuqBpJIBlv/5pfORTVK+YNWgD
         wYG/m/EpfMUMvhqYo4OcMfBasF7Ipc/QSDlQY0cvDc1gqy2G8LBa6dFH6JNNrcOWLZrQ
         hV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+rhMnLA+w80mi30OPe/rIR1GZHk3iZBFbYGSHMHQdRI=;
        b=MQ+s2/Gwr6rPJmo6nDDYhiaYpoNOme/7ZJGeXKwZ5NDy12DoQ7JGW2ad2wT4pDcPTD
         atwcFjPrsMLKYEFT9dEU1LNP1m72ML0x6L1IuQDIJ+BnhTGBQ9En/5kf+eeu6uuOCnBE
         LSr3AI/XWJ3BshQtUW3Kj9ksQAuEwWubwwCO64Gt0exac5L4Hp0x9N24vsEmx3j8JFsK
         kykA1i2qEpp5D/FTupp4I5hP5+Ivu2iNufSMY6INKGgcG9Ohy0+65aLbw0Ne5y0cEnSg
         n+9J6RsYEabXVc1J1qpaY5BRg5RXAj6Qi5+EYESh7hdvFZxZ4vakEMhjgP/k3+3vrxgg
         MY5A==
X-Gm-Message-State: APjAAAUj4sHMrMhWIMDAV6+HSIkz72kP5Te9n7Ky2ulYhsNX/yVUbFv8
        w6fbL8+8pxVBmzuzYmgt+jE=
X-Google-Smtp-Source: APXvYqwfXBCAX+JG/099IDn8UwfxBCdH9C4T1LA3kp25hsxVnuWMoUDGzYsqPeqUQXPfpO9rjL6BoA==
X-Received: by 2002:a17:90a:8c06:: with SMTP id a6mr7740687pjo.45.1564651859214;
        Thu, 01 Aug 2019 02:30:59 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id f6sm72357603pga.50.2019.08.01.02.30.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 02:30:57 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     roid@mellanox.com, saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next] net/mlx5e: Allow dropping specific tunnel packets
Date:   Thu,  1 Aug 2019 16:40:59 +0800
Message-Id: <1564648859-17369-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

In some case, we don't want to allow specific tunnel packets
to host that can avoid to take up high CPU (e.g network attacks).
But other tunnel packets which not matched in hardware will be
sent to host too.

    $ tc filter add dev vxlan_sys_4789 \
	    protocol ip chain 0 parent ffff: prio 1 handle 1 \
	    flower dst_ip 1.1.1.100 ip_proto tcp dst_port 80 \
	    enc_dst_ip 2.2.2.100 enc_key_id 100 enc_dst_port 4789 \
	    action tunnel_key unset pipe action drop

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f3ed028..25d423e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2485,7 +2485,8 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 
 	if (flow_flag_test(flow, EGRESS) &&
 	    !((actions & MLX5_FLOW_CONTEXT_ACTION_DECAP) ||
-	      (actions & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP)))
+	      (actions & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP) ||
+	      (actions & MLX5_FLOW_CONTEXT_ACTION_DROP)))
 		return false;
 
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
-- 
1.8.3.1

