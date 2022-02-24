Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50564C38A3
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 23:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbiBXWP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 17:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235311AbiBXWP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 17:15:57 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA2129DD04;
        Thu, 24 Feb 2022 14:15:27 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id d28so1763113wra.4;
        Thu, 24 Feb 2022 14:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=23uPqqlxtmnZRHLs9v3vgksA5KeOpFw/ThnhTpkf+2w=;
        b=S6nCprqxh0JglbBAqwKJDoHoVIjtj4T6nsOoxoor9OqZxzcWSmesnc8rh8G+UcJWwk
         mc13iC3iU8uKZp4mj0CgARdJtp+90Ud9bgn5xxixO3CyqpAeGCn0AN3oF1cX3oJB8QHI
         8UDrUzs36GYtOFY6uAjLWQanpjCWTIYlFlqjK+5LUI+xyxfWFQ6tVS0z0hiVKS+6d/0p
         uDzEg8pnt+wxr4pKPMoXM/zFFnEQk9VlaKv2+C5Vd2mQ7edNv+t4RTkX4Sr9Xtq8hNMz
         ujeMJtqjfqPyaAiw66xkhG8E57AyVTyOdWffuxDtoxuEQE1wiizAlDyCwHPUFQtj1pHX
         q82g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=23uPqqlxtmnZRHLs9v3vgksA5KeOpFw/ThnhTpkf+2w=;
        b=w2hc+VyG5yjyra+NFXy2ClKUEgfH2tdF0yiGVRlyQOkYVDFSHp2xuOLFEwPQozVg8J
         gttDbdi5tVcMCyRElPVA5hgc2+TO07lv5ecf/E2o/DQs8yYyLdsW/FMZ3UCKQ/diycsz
         mtxO+r/WNk7wbunAncECtjIK3lxJyQjP4jaCk0n7RYljPXavfd3SUmz45EZlYtDay4UV
         qUd1T18AwZgljoXNo7emjcXFF18MEcX7WKhMVyiHinpGbUeLPbHK/HBr4T/mzj3Bc0zT
         BgjiAE6lo4a/tX4dqIuV6GEaCSQ99sD4Vkf59/orkq2mvSXppLBTvhrn0d9nCJmOWPcT
         qvYg==
X-Gm-Message-State: AOAM533Clabvnq1Pcxc8xb27lp+u42Bch0sFmvGADyvJApkxlLm3r1O0
        va+xS3Yk2yYsRoGkD/zNee4=
X-Google-Smtp-Source: ABdhPJwAm/jUbae804Iirsh2TE+k/iRCYA06xF1rFmTlmPTvYCNCE4wR20beM9tBYDQ6CUCuGmHO7g==
X-Received: by 2002:a05:6000:1789:b0:1ea:7bb7:312c with SMTP id e9-20020a056000178900b001ea7bb7312cmr3861415wrg.660.1645740926020;
        Thu, 24 Feb 2022 14:15:26 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id r15-20020a05600c35cf00b003808165fbc2sm584330wmq.25.2022.02.24.14.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 14:15:25 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH] net/mlx5e: Fix return of a kfree'd object instead of NULL
Date:   Thu, 24 Feb 2022 22:15:24 +0000
Message-Id: <20220224221525.147744-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently in the case where parse_attr fails to be allocated the memory
pointed to by attr2 is kfree'd but the non-null pointer attr2 is returned
and a potential use of a kfree'd object can occur.  Fix this by returning
NULL to indicate a memory allocation error.

Addresses issue found by clang-scan:
drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:3401:3: warning: Use of
memory after it is freed [unix.Malloc]

Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 76a015dfc5fc..c0776a4a3845 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3398,7 +3398,7 @@ mlx5e_clone_flow_attr_for_post_act(struct mlx5_flow_attr *attr,
 	if (!attr2 || !parse_attr) {
 		kvfree(parse_attr);
 		kfree(attr2);
-		return attr2;
+		return NULL;
 	}
 
 	memcpy(attr2, attr, attr_sz);
-- 
2.34.1

