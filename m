Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB89964C7E
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 21:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbfGJTFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 15:05:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34885 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfGJTFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 15:05:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id y4so3630029wrm.2;
        Wed, 10 Jul 2019 12:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QpN5CHwpzVqFTlvbsrr+q70h5+rFXHepQXU4UwgW+ak=;
        b=iPGy1Jrmt2gRxtF412YFifkUTN9fK7qKNXNPavYbpyRr3ZQ8LCSQBTWs9DNI5a7qBj
         1f42sTxWjq7PCoeTG3rGjaBr9eo4WoqGdTuhHO2somI7t8Vspvudrwu57a+wy2GZj+pj
         AzTFnz6zHKdD0YtnWo+Es9N/jsq+n8rmlNCzLY95WxC6GGA2oxgU/C8fJiBgdlMve0sz
         DpaSU6WLDNviqMvV4fuUs/PYlL1lu2vxv+l4lRQ5sRszzJvNx38VzxlhJ1EFGAWIpDJZ
         CWhms+nFQhkNKGPgMNC/NLfDrtcF27mVxrxrXeVLvxXM1UF4HJpDIWbItUV1eUnKzqzQ
         u8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QpN5CHwpzVqFTlvbsrr+q70h5+rFXHepQXU4UwgW+ak=;
        b=X2fqjZ1OEoMsgxFISrQKob9nK4ulby9m/Hm0WOnZdEvGNmZqlLWGNWxkqyDvBB+m96
         c10EmN0T5/Y5j9uwsXQVTPtw/j8IHjif4P86pDJEJ8Uhnd4v6mLWFjGK0SVi1cc3QEO3
         Jn/9/9XqW+l0vqNIB6gfs6nwvPOtzSO4YmaFBvTkaEZ+Ly4inWYUDfDK7IVRIsvtSyKt
         PVHgs7Hk9AV5p2Wu9aE3fS/4yYUiY70/4641Ik9ujR9GAkX7alzxyzCb3VEP04lOjBh0
         Qn6MRBf5Jo3C5e5tJjDXUSiCCYnbKH6QU3tet8YOVRrSUrj4vksasjViIrIvi55pILnN
         duqQ==
X-Gm-Message-State: APjAAAVPb0sB4kJAtTPYLVYY/baXoRlUlXQ79MHMT+pAyhX7Ys524ixa
        fnNFa14WqXxdXCQLjf0suJMGxIalfxCVxg==
X-Google-Smtp-Source: APXvYqyLA5hi4rqSfStW9zfDiOCykfIKuz4yycIzUOpHzjDAzYmb0ho1+ZaBmLj+T0pW1JsF0/IzFQ==
X-Received: by 2002:adf:f904:: with SMTP id b4mr34063592wrr.291.1562785504941;
        Wed, 10 Jul 2019 12:05:04 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id b2sm3727191wrp.72.2019.07.10.12.05.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 12:05:04 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] net/mlx5e: Move priv variable into case statement in mlx5e_setup_tc
Date:   Wed, 10 Jul 2019 12:05:02 -0700
Message-Id: <20190710190502.104010-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is an unused variable warning on arm64 defconfig when
CONFIG_MLX5_ESWITCH is unset:

drivers/net/ethernet/mellanox/mlx5/core/en_main.c:3467:21: warning:
unused variable 'priv' [-Wunused-variable]
        struct mlx5e_priv *priv = netdev_priv(dev);
                           ^
1 warning generated.

Move it down into the case statement where it is used.

Fixes: 4e95bc268b91 ("net: flow_offload: add flow_block_cb_setup_simple()")
Link: https://github.com/ClangBuiltLinux/linux/issues/597
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6d0ae87c8ded..651eb714eb5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3464,15 +3464,16 @@ static LIST_HEAD(mlx5e_block_cb_list);
 static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			  void *type_data)
 {
-	struct mlx5e_priv *priv = netdev_priv(dev);
-
 	switch (type) {
 #ifdef CONFIG_MLX5_ESWITCH
-	case TC_SETUP_BLOCK:
+	case TC_SETUP_BLOCK: {
+		struct mlx5e_priv *priv = netdev_priv(dev);
+
 		return flow_block_cb_setup_simple(type_data,
 						  &mlx5e_block_cb_list,
 						  mlx5e_setup_tc_block_cb,
 						  priv, priv, true);
+	}
 #endif
 	case TC_SETUP_QDISC_MQPRIO:
 		return mlx5e_setup_tc_mqprio(dev, type_data);
-- 
2.22.0

