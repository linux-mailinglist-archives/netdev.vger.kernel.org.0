Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D5327A0A8
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 13:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgI0Ld0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 07:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgI0LdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 07:33:23 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A08CC0613D3;
        Sun, 27 Sep 2020 04:33:23 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x14so8567593wrl.12;
        Sun, 27 Sep 2020 04:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0SaoC8kG8C3/x0IiW1U1E/6eFnvfrg3HY2k89yqprS0=;
        b=GNTMvVNIIJGVkMvMl8sdVQ+i0xAZayQussBef54oU8jeNjR7ls9MXmCis8muScpmhq
         Y0Z2y4/CjRjQK6pIPWFs/2PQLM2rcWc/Hi8gNiwUrAvBiQwkkimL+i6wFe+kuJRTGmg6
         4U6vujGH/IEBJL6CS/FnW7QA3DJ2XOiPS7dVZmxTzGkGRO0leoyC/UI7f8N6l4KTHCN6
         yrkSZYU5OUTe1HDJ8p5ZKb2OYLP4qLTomlsbI6ZNUsjWl6BfwZiACJlPXu8yDYk+ipcF
         dvg/NKDxIrIZIp9OufmasO4FCKKYC1VfBgI2tCyPvTsryVJm/6QwIyDRrO+V58u2/bVm
         lFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0SaoC8kG8C3/x0IiW1U1E/6eFnvfrg3HY2k89yqprS0=;
        b=D6KhVa57J8WVv1gInEQkSS3z4JHYVpJFTyUxzADUtOKObYBPnv8WLS04IvUdqH3xpR
         Vh8gTg8nNQoN00bXW3AO9hSQvOM+d87YGCFyXzZO2+KWwDELB+55FBpM1GtQH8XCIQKm
         13pKS56axlQ1qPbiDQ635Ugb1Ei5KyOqges6qsb9nRUEPMqQCLFc531Ed7DqczeQmv8o
         eSFfNcME1TU0ko0guURH2JdMQDegu77Z5cLRYo3nwOgHbqs4WW4Blh3pWu43NpEkF4lb
         FPU4jsW5oKldl256pStQ2hMqOBZ+yzkQXx5iVcJND/P2r/2Ms8th8FpC6PZvZy1vr1LT
         GMNg==
X-Gm-Message-State: AOAM530boEZOZ3G7FKiSGwLU92NbfKoxvEpvnA5G2tFMrFbdFV3hSIpu
        d2gXdfjSKS8fu0uD+AtaHuE=
X-Google-Smtp-Source: ABdhPJyi7ecSTXBvW2qpOwmSJeg3xZWDMWJ0EgIQZNtnvvLKzklASMrH8x44OfKNosYNIlHpNLFkDg==
X-Received: by 2002:adf:f78c:: with SMTP id q12mr13868290wrp.6.1601206401830;
        Sun, 27 Sep 2020 04:33:21 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id d83sm5671565wmf.23.2020.09.27.04.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 04:33:21 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] net/mlx5e: Fix possible null pointer dereference
Date:   Sun, 27 Sep 2020 12:32:54 +0100
Message-Id: <20200927113254.362480-4-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200927113254.362480-1-alex.dewar90@gmail.com>
References: <20200927113254.362480-1-alex.dewar90@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mlx5e_tc_unoffload_from_slow_path() a null check is performed for the
variable slow_attr and a warning is issued if it is null. However,
slow_attr is used later on in the function regardless. Fix this by
returning if slow_attr is null.

Addresses-Coverity: CID 1497163: Null pointer dereferences (FORWARD_NULL)
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f815b0c60a6c..b3c57b984a2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1238,8 +1238,10 @@ mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *esw,
 	struct mlx5_flow_attr *slow_attr;
 
 	slow_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
-	if (!slow_attr)
+	if (!slow_attr) {
 		mlx5_core_warn(flow->priv->mdev, "Unable to unoffload slow path rule\n");
+		return;
+	}
 
 	memcpy(slow_attr, flow->attr, ESW_FLOW_ATTR_SZ);
 	slow_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-- 
2.28.0

