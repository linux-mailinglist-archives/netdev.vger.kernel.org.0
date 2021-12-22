Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C38047CD24
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 07:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239262AbhLVGzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 01:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbhLVGzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 01:55:07 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13731C061574;
        Tue, 21 Dec 2021 22:55:07 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id u20so1496630pfi.12;
        Tue, 21 Dec 2021 22:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=uohWpaXjI8g/PY6FinDVNdsod7i1s4bkwCFo5JR4qSE=;
        b=LPiF0zBhPGMQBYyo1QzxQWjgbpGx9KVnXKOXD05EPQNVC50teGcqahjTDN961k9gba
         xXQ4YGtKtGcDacZMvyr8Suo8Ndfq/4j4oyYuo3HSjMcLs+0nu8dmtExIKSOSlPvKeFvX
         3BviGPCgY1yJyQ8eHMzK0VL9LD5PuBGr7kfuH0/Cpo+aFIP3lgRnHXAk1eV3omq0blig
         1GYstadNZMDJD2XIKjXyPRxsYG3pjvInwai7/savbiP36iR/55a2cJge3YDfmHRdrq5H
         TOrQJKXQcOFFwhM9EkDAEHWqcoPF9iFgu4eh3Wtbyrv3k9f8+79PBkMaGVaZbpdXzvqU
         mhJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uohWpaXjI8g/PY6FinDVNdsod7i1s4bkwCFo5JR4qSE=;
        b=ncTS9rkTnWL0JklVv7BX8bm+xl+joY/g3ArPdUATsgp3iFPBA5+4NQVE0koMnOlYyy
         1bPvOIkpbr3Ber22tr5wLMERXYlbYRi2XkULEZpiwiUm4HDZ04LFXeThyfAHWiKaAemc
         AnQYwc99skwhjp9kyEAYzGjmuN8aFqukBEVeIEbhyJezpNCkN4JeTLKiV2LgVxG0ZFX3
         RAf4Dz1eVUMeDlnTFnMxyNrg67WQJr27gC604fjj/P7MH18lg8tjzo/Yr4YvpJK2to+k
         PRYSBAC1QcCwJxtf5bcXHXq4gkzfNL3SamzBpSpu+fZ6T+opwVgmMvua/Ri1WdCPEzTI
         utQA==
X-Gm-Message-State: AOAM532+haxdic9saZ+daCDeLTxLBmole7Iir5kbchyFpi6BycKzp6Xq
        On8ncmhOLfrYrFmt3DjF4f4=
X-Google-Smtp-Source: ABdhPJxPDLkyV6b1Mo2D2Tns9DkwrAy/SYRH/5mxP9u91aahy9p8WbZB/o9ixOieNN9sQo+kwQKSxQ==
X-Received: by 2002:a05:6a00:b89:b0:4bb:15c:908c with SMTP id g9-20020a056a000b8900b004bb015c908cmr1979587pfj.34.1640156106630;
        Tue, 21 Dec 2021 22:55:06 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id lp6sm4993004pjb.55.2021.12.21.22.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 22:55:06 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
Cc:     linmq006@gmail.com, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: DR, Fix NULL vs IS_ERR checking in  dr_domain_init_resources
Date:   Wed, 22 Dec 2021 06:54:53 +0000
Message-Id: <20211222065455.32573-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlx5_get_uars_page() function  returns error pointers.
Using IS_ERR() to check the return value to fix this.

Fixes: 4ec9e7b02697("net/mlx5: DR, Expose steering domain functionality")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 8cbd36c82b3b..f6e6d9209766 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019 Mellanox Technologies. */
 
 #include <linux/mlx5/eswitch.h>
+#include <linux/err.h>
 #include "dr_types.h"
 
 #define DR_DOMAIN_SW_STEERING_SUPPORTED(dmn, dmn_type)	\
@@ -72,9 +73,9 @@ static int dr_domain_init_resources(struct mlx5dr_domain *dmn)
 	}
 
 	dmn->uar = mlx5_get_uars_page(dmn->mdev);
-	if (!dmn->uar) {
+	if (IS_ERR(dmn->uar)) {
 		mlx5dr_err(dmn, "Couldn't allocate UAR\n");
-		ret = -ENOMEM;
+		ret = PTR_ERR(dmn->uar);
 		goto clean_pd;
 	}
 
-- 
2.17.1

