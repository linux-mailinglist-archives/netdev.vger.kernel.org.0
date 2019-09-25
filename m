Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28A83BD6A5
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 05:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411491AbfIYDUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 23:20:51 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39804 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729566AbfIYDUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 23:20:51 -0400
Received: by mail-io1-f66.google.com with SMTP id a1so9886175ioc.6;
        Tue, 24 Sep 2019 20:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AMQHeW4iwg1cC0jNZyLdmDs+JNlvjY193iwsLSoiahg=;
        b=aZvt//L91Q9a5+qjjLpXV/AkFXSpmuqrWM+fn9515REKF9MBWs2U2aOYSbRBCcVtOP
         E1YH4c9yMgbuZSI9rezDoPAaw/Ww3wWztQIln2F7EeFyqiXwQs8XBPTqUi80GKi3hQX0
         3V0mudMYsoNMn5YUwvaPMVPj3gHZuc/IgCKsQ34YloMNpfnK1ZoBFjJLK4aJk9kHRh6X
         NG+jgzY6slCYPUXZMjpNMzxLdU/nlSx6y7055Gp8tN+MWuIsON8du87q/7FxQukVo9ah
         ftL/pmUaoAsa48VkRZjbsUYh82S4Ag128MRs9RWBWhSjZO7ZGLjGXcTiLfHUnAMgsNDg
         J+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AMQHeW4iwg1cC0jNZyLdmDs+JNlvjY193iwsLSoiahg=;
        b=N/9qtZZGm4EHykTwXJ/YVaVyv0rwLqEwMD0NPQHO1cOVWvEryr0X2f9GpZ0YT2iL3c
         IBmx6xhKz2KW8Cu3zolADMrmOMRrOdxh/kVeicAfij3Z7DuZJYQ8Sf70to4ExYRhXFU4
         MMCCgSp8lO/4gBg8vndgqF9TO5/ASeWYufW+EruddUxXTdmu2Dib1bHrfKGEaVxIRH6I
         gaeu8yq5Va54NGn0iAFP7GcVkZd6kXEw3M3HdS3LOebe+hJZYxtL1GQQSdnSnNiifHnd
         RQ0XIEAMCcFFEBOnEQUiBG2R+lRS1O5BNTjHGC/wS9zfcK3qW982Yr9F7whpVUAtaaOQ
         RS5g==
X-Gm-Message-State: APjAAAXzcrjTZk0jmtF4tonEXpnqctQ6sJw7QLaBtDJPmIAD6m5oZHUF
        InqfczyzW+THqE+nCzxrmsQ=
X-Google-Smtp-Source: APXvYqx889DB8YB5toYzJW7umDas80cCCrtq2DAi+XCOTjNWwyhpR8EWrsou7GxN8ZfbPASi1+7bDw==
X-Received: by 2002:a02:80d:: with SMTP id 13mr2980357jac.50.1569381648785;
        Tue, 24 Sep 2019 20:20:48 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id e9sm3849993iot.88.2019.09.24.20.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 20:20:47 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Yishai Hadas <yishaih@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Bodong Wang <bodong@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: prevent memory leak in mlx5_fpga_conn_create_cq
Date:   Tue, 24 Sep 2019 22:20:34 -0500
Message-Id: <20190925032038.22943-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mlx5_fpga_conn_create_cq if mlx5_vector2eqn fails the allocated
memory should be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 4c50efe4e7f1..61021133029e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -464,8 +464,10 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_conn *conn, int cq_size)
 	}
 
 	err = mlx5_vector2eqn(mdev, smp_processor_id(), &eqn, &irqn);
-	if (err)
+	if (err) {
+		kvfree(in);
 		goto err_cqwq;
+	}
 
 	cqc = MLX5_ADDR_OF(create_cq_in, in, cq_context);
 	MLX5_SET(cqc, cqc, log_cq_size, ilog2(cq_size));
-- 
2.17.1

