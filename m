Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7957D27A0A3
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 13:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgI0LdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 07:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgI0LdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 07:33:14 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA934C0613CE;
        Sun, 27 Sep 2020 04:33:13 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e11so2484403wme.0;
        Sun, 27 Sep 2020 04:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U6g2ZpAIrDanv/8riCJB/j/6qbsRd6ES2Pscw/yj6fg=;
        b=nW546U5DnV7NuzRNb+NJAvl90TJLXZXZtRNHJhblKbnHceA+P5kFpHQUOwW+LeTgA+
         +jocm3T5ZdgFYEyEum8PrhaVtMjTADnYXEbGBh2bdN6gXruujYPYRS5GCgzufYtXZiCU
         hpIMCwAT8qKviYSLuJKTT/3zxDXnagYvVBn9T0ZEZlivNWJ/+Z8Y8mqmPZ4c+p47kd6Q
         ewXHyWBFEEhHUHUxY5dOPZ/HU4pMRX0YgKaVt8fNGKhjDNSLt6zHfI3bilZE1yQEXE37
         cgvnnUsjw8Z8GPfLLYRI6Dvfz79GsNqh88+rgDqxYJmhrPv+Z7kUrOxlohMkU5dhCYLF
         6qqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U6g2ZpAIrDanv/8riCJB/j/6qbsRd6ES2Pscw/yj6fg=;
        b=C33NdYtcCgSmdkQKoLXbcUVa8+13bZeYDONifG9+qeejFLc+6yzM//8ON+2qJ+LXws
         oIfRhKSlkKW2cpD+ppCupYJ0yjA9fJAEApjpMueMHMdf36WxpQD2KKbSPuDguDDufBmp
         o8LN+5HPlKivJcb5FYA6MLZhdq2cO3vAt5gbBdKv1VpZ9yVTcXrxzpQz/3E37wyz3wNg
         fSfAShGGmOMTj4F2QBVUk5A/8mYpyV64p8HfR1neWhzZsfNeF0ZaOogTfUnDZuSj+BuW
         EUhihJVYyczbsUEU7XrcfKebCrlmOpgMDUmRdUQRRyyoKPcvis57us2rkqriorYkUH+2
         t3iA==
X-Gm-Message-State: AOAM530lGZhHAufbyF2ME5CjbbVdZp4W9yn3s7GR76A6KkHCVvr8ZsKY
        URE7tlkDZGBS4E1MQhSJlTU=
X-Google-Smtp-Source: ABdhPJypDSYyT31lI6wdsV+KduxXbPlof26ggCkPYgvAtZ8pp2O0GuiGieJQ0ng0whwWsI6NNDlsSg==
X-Received: by 2002:a05:600c:210c:: with SMTP id u12mr7121692wml.185.1601206392580;
        Sun, 27 Sep 2020 04:33:12 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id d83sm5671565wmf.23.2020.09.27.04.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 04:33:12 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] net/mlx5e: Clean up error handling in mlx5e_alloc_flow()
Date:   Sun, 27 Sep 2020 12:32:52 +0100
Message-Id: <20200927113254.362480-2-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200927113254.362480-1-alex.dewar90@gmail.com>
References: <20200927113254.362480-1-alex.dewar90@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable flow is used after being allocated but before being
null-checked, which will cause a null pointer dereference if the
allocation failed. Fix this and tidy up the error-checking logic in this
function.

Addresses-Coverity: CID 1497154: Null pointer dereferences (REVERSE_INULL)
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 20 ++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index b3c57b984a2a..ed308407be6f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4536,20 +4536,22 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr;
 	struct mlx5e_tc_flow *flow;
-	int out_index, err;
+	int out_index;
 
 	flow = kzalloc(sizeof(*flow), GFP_KERNEL);
+	if (!flow)
+		return -ENOMEM;
 	parse_attr = kvzalloc(sizeof(*parse_attr), GFP_KERNEL);
+	if (!parse_attr)
+		goto err_free_flow;
 
 	flow->flags = flow_flags;
 	flow->cookie = f->cookie;
 	flow->priv = priv;
 
 	attr = mlx5_alloc_flow_attr(get_flow_name_space(flow));
-	if (!parse_attr || !flow || !attr) {
-		err = -ENOMEM;
-		goto err_free;
-	}
+	if (!attr)
+		goto err_free_parse_attr;
 	flow->attr = attr;
 
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++)
@@ -4564,11 +4566,11 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 
 	return 0;
 
-err_free:
-	kfree(flow);
+err_free_parse_attr:
 	kvfree(parse_attr);
-	kfree(attr);
-	return err;
+err_free_flow:
+	kfree(flow);
+	return -ENOMEM;
 }
 
 static void
-- 
2.28.0

