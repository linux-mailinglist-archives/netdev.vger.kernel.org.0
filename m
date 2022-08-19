Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1302C599511
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 08:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346677AbiHSGKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 02:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346556AbiHSGJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 02:09:03 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96C43ED73
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 23:08:34 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id f22so4447315edc.7
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 23:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=MQQ5ueYXwF1mgVuBzhpDoSiarWWxcP+kFd0K52asQnw=;
        b=UJ8fUY4TBBq/TG6MOQupt3Ca8oMqHbkfKb3rW32eIJXKGf8rriXtcQuht5HRT+uI+b
         /1I/3QlQTBiYtQyoCjG3k8PmdewX1V/uYmtVT9QY4yVxm9VZ7arJUigNUV//Z6LZj1ts
         UP6L4uHCOc8l1xbbiZPLnLO9Lu3mj2x0J4S9A9ZshmFeIPMpzFFoGn4rIxOhHdCNlp3v
         ks8QLaHIx2sYfETf4glt1lcF4B1ty3UFK4WsMunfm8bv0UoPjy7V0NA5t4JFcwwU6z1y
         mvfHq/oAbzId5oj+M3S89Vds8ALHVVB/ojTU0sWRNMVajI/dW+sLa9z3o3F3pOPVYaBq
         73hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=MQQ5ueYXwF1mgVuBzhpDoSiarWWxcP+kFd0K52asQnw=;
        b=ZCRpgIWuE1qinauOnPFeqSAWOZtBsTKe1YQD27X4yIdCi8RK1t0rnHrhNuqtt1HndJ
         B9u6309+2cAhrthkOU67CZNhiJ0zNATsj+pFJS8VihzVywx3gkzfHBsbFWOS+FJub/pU
         8J9dmL5ZMDApt8MVNbQ5DtO5AwVfNHLIj41YM3dWG1oLamYs98hDqBjk4ZgLPNL9HMmA
         FD4ZmI62jW1NaO3pTO8W+d2PfeuAjhCzOXEhfDiFAOPY6DWcUt62ygOhRUmuPIUeGCoZ
         AhqkQpbooU8TBXknRYj1ml9XMVQzaByM+oS8cP82CQkOjl332VGAByD6nAihZyMSz25m
         hajA==
X-Gm-Message-State: ACgBeo0kTFPHmgLqqE0Nc3OV8K2II7d4mJMAOLIgKzFOUDcl1Tj07VcL
        Zg/UshkshcJOC7OFkA3zAW3/WA==
X-Google-Smtp-Source: AA6agR5qrhKSw7oa0pDZk68ViIpC2FB5ZmkkWaDCBIhx8mIj19+nf9D2Fwy8CN4MThe75Z3lcCNpuw==
X-Received: by 2002:aa7:dd50:0:b0:440:3e9d:784 with SMTP id o16-20020aa7dd50000000b004403e9d0784mr4859887edw.195.1660889313038;
        Thu, 18 Aug 2022 23:08:33 -0700 (PDT)
Received: from lb02065.fritz.box ([2001:9e8:143b:fd00:5207:8c7f:747a:b80d])
        by smtp.gmail.com with ESMTPSA id y14-20020a1709063a8e00b0073a644ef803sm1809660ejd.101.2022.08.18.23.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 23:08:32 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     linux-kernel@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH v1 19/19] net/mlx4: Fix error check for dma_map_sg
Date:   Fri, 19 Aug 2022 08:08:01 +0200
Message-Id: <20220819060801.10443-20-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220819060801.10443-1-jinpu.wang@ionos.com>
References: <20220819060801.10443-1-jinpu.wang@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dma_map_sg return 0 on error.

Cc: Tariq Toukan <tariqt@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/net/ethernet/mellanox/mlx4/icm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.c b/drivers/net/ethernet/mellanox/mlx4/icm.c
index d89a3da89e5a..59b8b3c73582 100644
--- a/drivers/net/ethernet/mellanox/mlx4/icm.c
+++ b/drivers/net/ethernet/mellanox/mlx4/icm.c
@@ -208,7 +208,7 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 						chunk->sg, chunk->npages,
 						DMA_BIDIRECTIONAL);
 
-			if (chunk->nsg <= 0)
+			if (!chunk->nsg)
 				goto fail;
 		}
 
@@ -222,7 +222,7 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 		chunk->nsg = dma_map_sg(&dev->persist->pdev->dev, chunk->sg,
 					chunk->npages, DMA_BIDIRECTIONAL);
 
-		if (chunk->nsg <= 0)
+		if (!chunk->nsg)
 			goto fail;
 	}
 
-- 
2.34.1

