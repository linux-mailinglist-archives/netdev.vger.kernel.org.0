Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2ACC0E11
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 00:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbfI0Whk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 18:37:40 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45303 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfI0Whj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 18:37:39 -0400
Received: by mail-io1-f66.google.com with SMTP id c25so20523594iot.12;
        Fri, 27 Sep 2019 15:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KJsbedDzJ9he4QxIG59rwsjEIiza9En3mHn6hNsWXYY=;
        b=fG+4yMDVI7aamOPCQtrzFijl8LlI8DkwqlCNN/DQ5QSvUSI+F7dPUTk7I8gsyOizYj
         KMXn4v0/GbkqCoOdyD9mUa9gXElJuiba8droHLI1mH0pzNfN98J5yS98LWGVmgFlLf60
         8DRYT/RvmMfuTlxNdVk88HWmLFjxgvxuyg2ynY/lB+3JpTGX8wa1Ig5SFOrdoPGLnOcc
         WJGUyLxB+xQ08jbHUpww7k8Xjn2tEm6ZlNTfgxCVqS5D2gIMgzUoidI1MXc+Juf4ug7N
         +R62JVtMI8d/2RxALavHgXv6pE4GZY+y3XhDaLolr7q9/AbjLHMbRaOAgI8cazidtqLP
         InMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KJsbedDzJ9he4QxIG59rwsjEIiza9En3mHn6hNsWXYY=;
        b=IicyxFBghcGAVC3260nb67beQ2Pab6YK7NVXtoLuQojCuWyZM5v3vz+ptLip3P1m8t
         jeA4gGGvj4mrG05JFGwRrIsw52Y86KU8EYG3pQ7gjH2PliiIiZdq2D8ove7wVsDqR+yy
         rPT/bEdbjuI5dcLaQHMTe2P9jxwEoC3BPTGtefdFyuYtHlR/ce5jGP9gL8OL6wskEKcJ
         D5GxAHvwYw1mA7wl4C0iD3L5Z/tc6kF5JYokdoBf9WKX6cK+AGAiEnge1G6wSWU6Gc7F
         OOgiW4fOeVvIfjGn3CpUG+KaO2mmHW9kDwtHMMddHbdh2jTZSXiWER3WO2osjBp+72JO
         2HWw==
X-Gm-Message-State: APjAAAUsn64WClix9onbqlf5A/hxiiNzF+mYAZrlL3QacRAgtw/gYI/a
        wJ41o05HkjGezFJ9qmEJaNc=
X-Google-Smtp-Source: APXvYqwcqRpB0l7iGwdaF88jD4psj19/i3NVAL0LUs/V4p5ib8sAyMZN/0gVlI6oS8ierQ+80JpdaQ==
X-Received: by 2002:a6b:4403:: with SMTP id r3mr10878681ioa.2.1569623858759;
        Fri, 27 Sep 2019 15:37:38 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id g68sm1678229ilh.88.2019.09.27.15.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 15:37:38 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: fix memory leak in mlx5_fw_fatal_reporter_dump
Date:   Fri, 27 Sep 2019 17:37:28 -0500
Message-Id: <20190927223729.18043-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mlx5_fw_fatal_reporter_dump if mlx5_crdump_collect fails the
allocated memory for cr_data must be released otherwise there will be
memory leak. To fix this, this commit changes the return instruction
into goto error handling.

Fixes: 9b1f29823605 ("net/mlx5: Add support for FW fatal reporter dump")

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index d685122d9ff7..c07f3154437c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -572,7 +572,7 @@ mlx5_fw_fatal_reporter_dump(struct devlink_health_reporter *reporter,
 		return -ENOMEM;
 	err = mlx5_crdump_collect(dev, cr_data);
 	if (err)
-		return err;
+		goto free_data;
 
 	if (priv_ctx) {
 		struct mlx5_fw_reporter_ctx *fw_reporter_ctx = priv_ctx;
-- 
2.17.1

