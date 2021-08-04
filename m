Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0D33E04DF
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239544AbhHDPwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbhHDPwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:52:22 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CBDC0613D5;
        Wed,  4 Aug 2021 08:52:09 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id c24so1966453lfi.11;
        Wed, 04 Aug 2021 08:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LOerQFZ0jK8/gKUx7F6VWzq+EmsyF6Mh3+2EWyBwV7k=;
        b=WxflTTjBUcRlekTmCCDw38zuvU4FNXPHhQjcZ7jbxeVORh5S85vqOYRllxyWYgS7Zg
         vxfaf3QBRh7yOO5gxN76nvOiaGtXeh7K2QCJH/C7098CRiVup0TXdyJodFhPctFSclmt
         2JDdCpe3Kskg1PwPo9Ksiad01ocnHZn96FE+FvEglegL60NCXxi3JR05VOwZvGI7iZ8X
         VN5VJKQoXegCc28K4oTADbzUUpUtS1Yjfb59hOpZxnn859XaLVQ7wPHjqu4qi19GKQJD
         an9ocK/KzADhJZdapLbWtE7BbaEfhkU+m0p8QXxmE6d5T5gR3xTHJGS8C+Jl1pNXgCZ2
         AIjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LOerQFZ0jK8/gKUx7F6VWzq+EmsyF6Mh3+2EWyBwV7k=;
        b=RdmF9CJcMqLAOMuo2d1eiacyg1qvT3M72rFpiAchQcLj9crAUpX9YOfYrGi7CINHY9
         jnbpzUqgNR6wMaq+/jURMxiB5nRsSsvyLQJEZNydV6pQFUhU6h3S9VJbnu8SbH0Akak+
         j0m53eDeg3eDazq/EIgHiKF6EAzk1iGb7FoGm7erEy2oUfHT7OP3n820OOJplCqjNMQ2
         AQvn7Yl7v8ROGx0PjCBq8bBX0MxkxIrS4bImZkIATYxxbh8fr2iOHGsW0DUBf8KuFbA4
         8LG7NFfXT6wAOVx8Ox8HDX2wxIpFoOKmPoZr3sveVK3Lx+mYQEHQnxk62i7CtU6QEQ4K
         1IWA==
X-Gm-Message-State: AOAM533v7sRQJwwurneXZBpESGk1b9BBJJPQJoG+dKj3J/j7dSexrujx
        auTXJo5jUsqNWmnReCOZD5k=
X-Google-Smtp-Source: ABdhPJzsrxxqWvViyKle7Uk8+V1sK5RIVOnDfRgeJB9MD8pBmOEK6S3CmL9y00EWnS5fH33BS3UbeQ==
X-Received: by 2002:a05:6512:3b89:: with SMTP id g9mr21267607lfv.96.1628092327374;
        Wed, 04 Aug 2021 08:52:07 -0700 (PDT)
Received: from localhost.localdomain ([94.103.226.235])
        by smtp.gmail.com with ESMTPSA id o8sm231658lfu.25.2021.08.04.08.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 08:52:06 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, qiangqing.zhang@nxp.com,
        hslester96@gmail.com, fugang.duan@nxp.com
Cc:     dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 1/2] net: fec: fix use-after-free in fec_drv_remove
Date:   Wed,  4 Aug 2021 18:51:51 +0300
Message-Id: <25ad9ae695546c0ce23edb25cb2a67575cbda26b.1628091954.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628091954.git.paskripkin@gmail.com>
References: <cover.1628091954.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch says:
	drivers/net/ethernet/freescale/fec_main.c:3994 fec_drv_remove() error: Using fep after free_{netdev,candev}(ndev);
	drivers/net/ethernet/freescale/fec_main.c:3995 fec_drv_remove() error: Using fep after free_{netdev,candev}(ndev);

Since fep pointer is netdev private data, accessing it after free_netdev()
call can cause use-after-free bug. Fix it by moving free_netdev() call at
the end of the function

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: a31eda65ba21 ("net: fec: fix clock count mis-match")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 8aea707a65a7..7e4c4980ced7 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3843,13 +3843,13 @@ fec_drv_remove(struct platform_device *pdev)
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(fep->phy_node);
-	free_netdev(ndev);
 
 	clk_disable_unprepare(fep->clk_ahb);
 	clk_disable_unprepare(fep->clk_ipg);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
+	free_netdev(ndev);
 	return 0;
 }
 
-- 
2.32.0

