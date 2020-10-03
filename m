Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5E62823C9
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 13:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgJCLLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 07:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgJCLLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 07:11:16 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDF7C0613D0;
        Sat,  3 Oct 2020 04:11:14 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z1so4517601wrt.3;
        Sat, 03 Oct 2020 04:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GnbMU4sFZhNsugLjOl+CGPMW76afg/wZKnEggQ7T6cw=;
        b=cQOcDINVS6MiDBoZKsVMyRqVQndYXKkZv9tcvtlRcL4SrZnv/24eiwn5b/p1J6XoRq
         b/bK231L8x74LwsmxCPPci0Cza+i0lyJfv/treN4Nlxw4Z31yj4b5YggHn2CUD1pXvXY
         x9hue13PdN3HoWgypxTIggRgMfm0rnwzOsCQEeg5Aci+iiCDMOg82qzfXWVr1HRuC3Gm
         wS4BmbpF867fcebKoIg1hWrJFOXn5/r75G/UXaLLAefpAjBgAZeGGWGtO/y6Uj4f9hgn
         uSvMoynfHQG7pQExdsucOacjEe1fKSvMLQdu3L5cQIxR4BXAT1fjxvhd/loetEQakmeo
         2/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GnbMU4sFZhNsugLjOl+CGPMW76afg/wZKnEggQ7T6cw=;
        b=kOdnj8hf3Oh1jWxzmx+nkJTbli5SkOSJHtjiqNTvdupzZBIEeJOdo1ChsiiHXvopYp
         VNJqWwXWZ1u7L3x9KAmBPY58Ot59WRxFudMe1rXztGK9WeUQ5JZ2RJnG8QBRHezVKDbw
         dL2vICXe+sQWBTXTO9hJbwgIHXLTQCV2DUrWgTSJVJT4TGg6jBtbCW4giAxZkyXej65Y
         80qBq3VOw612rEdtAeoXqM/p+oFJE1hNziLwDjG2+jM4onMX6497wc27uRzbVsfFiKBk
         2ElVCv/VZhD7pzSoPqtKsY7/oEMCM3LiTR18BdqZpmyVQ90st0BCYK0PW5Aj9zJfPLen
         gLwg==
X-Gm-Message-State: AOAM5336VSpnsVhWQh+XvAq4EUWfj9aCB86x/k7Qtr2VQfAmHYgFxhBw
        UtgzcLYM2n0bzD7qtleu6qU=
X-Google-Smtp-Source: ABdhPJye6XSLqhpp984Q4kjRQ4Giw0MReRk2oETDk5NV4q7zUshaQCPtwEXp+7vyYu6U5DSl0W9HKQ==
X-Received: by 2002:a5d:630a:: with SMTP id i10mr7550051wru.137.1601723473224;
        Sat, 03 Oct 2020 04:11:13 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id u17sm5571995wri.45.2020.10.03.04.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 04:11:12 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5e: Fix freeing of unassigned pointer
Date:   Sat,  3 Oct 2020 12:10:50 +0100
Message-Id: <20201003111050.25130-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ff7ea04ad579 ("net/mlx5e: Fix potential null pointer dereference")
added some missing null checks but the error handling in
mlx5e_alloc_flow() was left broken: the variable attr is passed to kfree
although it is never assigned to and never needs to be freed in this
function. Fix this.

Addresses-Coverity-ID: 1497536 ("Memory - illegal accesses")
Fixes: ff7ea04ad579 ("net/mlx5e: Fix potential null pointer dereference")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a0c356987e1a..88298e96c4ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4536,13 +4536,14 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr;
 	struct mlx5e_tc_flow *flow;
-	int err = -ENOMEM;
 	int out_index;
 
 	flow = kzalloc(sizeof(*flow), GFP_KERNEL);
+	if (!flow)
+		return -ENOMEM;
 	parse_attr = kvzalloc(sizeof(*parse_attr), GFP_KERNEL);
-	if (!parse_attr || !flow)
-		goto err_free;
+	if (!parse_attr)
+		goto err_free_flow;
 
 	flow->flags = flow_flags;
 	flow->cookie = f->cookie;
@@ -4550,7 +4551,7 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 
 	attr = mlx5_alloc_flow_attr(get_flow_name_space(flow));
 	if (!attr)
-		goto err_free;
+		goto err_free_parse_attr;
 
 	flow->attr = attr;
 
@@ -4566,11 +4567,11 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 
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

