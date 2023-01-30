Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A5C681B25
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 21:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjA3UNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 15:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjA3UNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 15:13:54 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5B234C33
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 12:13:51 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id m2so34832862ejb.8
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 12:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CdepUb0Cf+NMGQp5AZtJg6+OIbVexrLKQo1VoGD0toc=;
        b=ogKgBKNLhHMfoUS8Vw4OZYVEzq2HhP5OPH99NIkCA0dHYbYvNtNJk06361OyheXg9b
         ERDdBX+5SddSka2PS5JGOS8nrEkvRzXIT8/pMQfCpP/Uz0PAVQBhTtX4kCDenRmmLdI5
         BuJb5Rf4Bm2j3+Y8NtEg5s5NWu9vIAzamD1f5NSUsaXNWOiUN5/yKX3zL3PzrXQWtsq4
         4xD0q9ZzTJyODO3DnRMP0KrBBrOoK0LU2Zq9eDv0dTY9C7GR+pO1yP2ReMR47yBLZkWE
         cURhb2FdRDVTfkPXCqaRDrikiutnuz3f9AknYGPJBjlDDPlB3P6736Y4V+9Kv71nBJ04
         uAgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CdepUb0Cf+NMGQp5AZtJg6+OIbVexrLKQo1VoGD0toc=;
        b=maPMHHvswm4N6eOfASZa0qlVoR+3zPkNKsNXqvXXDhLhlHzWYmNmdn5IMt+ZLOTtDH
         nHB33+sWB/osfPmcIdCo+qXmuJ+XGUqjDZY4/yhm/brOZSUr6P5OYk+XfiSV7L8xOiDP
         xuvEWXk2R3Tdl7+HxguE72G4LEOBeexDhpUXPngkk1rmo2iI3aqC/4fixGbR2OPWm8wm
         E1cZzeGMh15aMDlRTG9MW9VD0DGDMPhtTvKXarsybbP48Iz7zCqAYELfC2yYzzPUaXfP
         Yeb54/OzQ0kuRZJ9jeb2QQhGjOEB4Db0VSMnn4yIWMh4VgjZTeV0sPNMkZcxonEBFfvE
         o4Vw==
X-Gm-Message-State: AO0yUKUQaQShKIxHaJWN04O8S7ENa2cRPNO4yAIrKzSnwqTjVK1xdimu
        btWxjJLHpxLPBha0qxClx5/XgrGPrAP5IEsr8u8=
X-Google-Smtp-Source: AK7set+c/4e3LyVh35DFBbWLXK5ZY5k0404v+X2uoQCm3Fyam+xTrN1ab20kt0SytpAuES+0DKhDZg==
X-Received: by 2002:a17:906:8d86:b0:878:5a35:c83b with SMTP id ry6-20020a1709068d8600b008785a35c83bmr19330742ejc.15.1675109629457;
        Mon, 30 Jan 2023 12:13:49 -0800 (PST)
Received: from localhost (onion.xor.sc. [185.56.83.83])
        by smtp.gmail.com with ESMTPSA id e18-20020a17090681d200b0088519b92080sm3505766ejx.127.2023.01.30.12.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 12:13:49 -0800 (PST)
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net v2 2/2] net/mlx5e: xsk: Set napi_id to support busy polling on XSK RQ
Date:   Mon, 30 Jan 2023 22:13:28 +0200
Message-Id: <20230130201328.132063-3-maxtram95@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130201328.132063-1-maxtram95@gmail.com>
References: <20230130201328.132063-1-maxtram95@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cited commit missed setting napi_id on XSK RQs, it only affected
regular RQs. Add the missing part to support socket busy polling on XSK
RQs.

Fixes: a2740f529da2 ("net/mlx5e: xsk: Set napi_id to support busy polling")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index ff03c43833bb..53c93d1daa7e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -71,7 +71,7 @@ static int mlx5e_init_xsk_rq(struct mlx5e_channel *c,
 	if (err)
 		return err;
 
-	return  xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix, 0);
+	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix, c->napi.napi_id);
 }
 
 static int mlx5e_open_xsk_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
-- 
2.39.1

