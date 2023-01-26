Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C794567D51F
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 20:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjAZTLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 14:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjAZTLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 14:11:18 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C396F5B8D
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 11:11:16 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id u21so2799886edv.3
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 11:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DlpJfV4hWe2uhPAfHOImfRNc1k8rQdcTwafyBbxLpcQ=;
        b=eNlt4Xv9gxJSH6oG8ZLm/4QCKvVM7AbgwM3gbY+xQMIt1Bd/eZjnSTT+1JBbIWz21H
         Zf3Gql6PCYDL+n7twrZyLCse/WpM9jIsIU+y9/5WrwfA4EGZYS+89MrTQVB/NQYKcirb
         shBnyV1t9qGgI8mSbzpAbxjZ1DiCE3XTn1US72kJEUcGf6z46JWeeAbkYGemJ3jc0QQW
         nn9uWdpYBVmEl6Lzx57df5OJVeiE43C6L0JwF6NAzvlhQyWw14KCuWYhA3dIzpmLEu+Y
         MOhjWbPzb3tf4xvAo6gVfVA2Xbl7mmi+YuGBsSfYk8FeQqgg6+LTnDSDaT7IoNKUIbMS
         Otgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DlpJfV4hWe2uhPAfHOImfRNc1k8rQdcTwafyBbxLpcQ=;
        b=7s5A/ZnAuWaYPGSFpVVa2mZfZ9T2tIhM06a9EQZdC6flK+adBrdwtHZNVw1aKXOqdv
         b3pRARQMGtgKrZWuIdhWAURvJSIGJZeBdr4kf+aupu6q6a4uAh+CBKBI5cGvvAe5vP64
         EkIcoM1zWAzbtEpRK/n/WFHEZS+fbWuSkSSx3UxChB0t3+/d+HAZ5dc9l1yscaNIDzPb
         nI07bLz7yCSAyfF69lKRioxvFeQEPzCsyovCWQM5uCdWcay14A4Bh19Tcm50JwBvk0wJ
         zcNCda1Ieu/UVpV4UHlHp4WeAU0AkAODLQoVM7NR5JsLXuJZ3J77Y1rowsUEC9Xt4LyI
         z0UA==
X-Gm-Message-State: AFqh2kpaBMXMLgZKpGY9HcuarMoe1rGtgFO20IL4BwPR8KttQKK4vZnz
        dr2OAk+O1Ejx6EB+1yabfacAbKeeLt51s5yf3vk=
X-Google-Smtp-Source: AMrXdXuX4A6qIWKBJWAwli9uxVj89RSrh0sE0962NDZeWcAjC5dwEXNTnhzcTXXKIJ4/kkvZ6+o7YQ==
X-Received: by 2002:aa7:cc98:0:b0:486:ecd3:15f8 with SMTP id p24-20020aa7cc98000000b00486ecd315f8mr37748654edt.6.1674760274974;
        Thu, 26 Jan 2023 11:11:14 -0800 (PST)
Received: from localhost (tor-exit-relay-3.anonymizing-proxy.digitalcourage.de. [185.220.102.249])
        by smtp.gmail.com with ESMTPSA id u24-20020a509518000000b0047a3a407b49sm1158311eda.43.2023.01.26.11.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 11:11:14 -0800 (PST)
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net 1/2] net/mlx5e: XDP, Allow growing tail for XDP multi buffer
Date:   Thu, 26 Jan 2023 21:10:49 +0200
Message-Id: <20230126191050.220610-2-maxtram95@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126191050.220610-1-maxtram95@gmail.com>
References: <20230126191050.220610-1-maxtram95@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cited commits missed passing frag_size to __xdp_rxq_info_reg, which
is required by bpf_xdp_adjust_tail to support growing the tail pointer
in fragmented packets. Pass the missing parameter when the current RQ
mode allows XDP multi buffer.

Fixes: ea5d49bdae8b ("net/mlx5e: Add XDP multi buffer support to the non-linear legacy RQ")
Fixes: 9cb9482ef10e ("net/mlx5e: Use fragments of the same size in non-linear legacy RQ with XDP")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index abcc614b6191..cdd1e47e18f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -576,9 +576,10 @@ static void mlx5e_free_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
 }
 
 static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
-			     struct mlx5e_rq *rq)
+			     struct mlx5e_rq_param *rq_params, struct mlx5e_rq *rq)
 {
 	struct mlx5_core_dev *mdev = c->mdev;
+	u32 xdp_frag_size = 0;
 	int err;
 
 	rq->wq_type      = params->rq_wq_type;
@@ -599,7 +600,11 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 	if (err)
 		return err;
 
-	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id);
+	if (rq->wq_type == MLX5_WQ_TYPE_CYCLIC && rq_params->frags_info.num_frags > 1)
+		xdp_frag_size = rq_params->frags_info.arr[1].frag_stride;
+
+	return __xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id,
+				  xdp_frag_size);
 }
 
 static int mlx5_rq_shampo_alloc(struct mlx5_core_dev *mdev,
@@ -2214,7 +2219,7 @@ static int mlx5e_open_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 {
 	int err;
 
-	err = mlx5e_init_rxq_rq(c, params, &c->rq);
+	err = mlx5e_init_rxq_rq(c, params, rq_params, &c->rq);
 	if (err)
 		return err;
 
-- 
2.39.1

