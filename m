Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B16F5663D1
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 09:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiGEHR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 03:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiGEHR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 03:17:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1AEA225E1
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 00:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657005447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JQ1OFEEXREBZQ2kK5VcGGpVpXnNBA8TnrdKqCCL16JE=;
        b=iiM1oPWDq23NR5Zw+eBPd5c1EwWv7ya/Wnw/RpYHgZg/F3nSVLUdUOwqqktBddIc5/pZGs
        Gi7gK+S7B7EqhsUiEtemOSehl/hMvrjIjjel46ul1XjECUU+KbH3vBY/VIbkaJ2VKa5Y7Z
        oFc9aqXiFfG1LGBhDTXmDVjShi6uGo0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-BD4y3l4KND-ny20XU9v0Hw-1; Tue, 05 Jul 2022 03:17:23 -0400
X-MC-Unique: BD4y3l4KND-ny20XU9v0Hw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E18F1C05158;
        Tue,  5 Jul 2022 07:17:22 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AED81492C3B;
        Tue,  5 Jul 2022 07:17:20 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jianbo Liu <jianbol@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: [PATCH net-next] net/mlx5: fix 32bit build
Date:   Tue,  5 Jul 2022 09:17:04 +0200
Message-Id: <ecb00ddd1197b4f8a4882090206bd2eee1eb8b5b.1657005206.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't use the division operator on 64 bits integers, that breaks
32 bits build. Instead use the relevant helper.

Fixes: 6ddac26cf763 ("net/mlx5e: Add support to modify hardware flow meter parameters")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
index 28962b2134c7..ca33f673396f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 // Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
 
+#include <linux/math64.h>
 #include "lib/aso.h"
 #include "en/tc/post_act.h"
 #include "meter.h"
@@ -61,7 +62,7 @@ mlx5e_flow_meter_cir_calc(u64 cir, u8 *man, u8 *exp)
 		m = cir << e;
 		if ((s64)m < 0) /* overflow */
 			break;
-		m /= MLX5_CONST_CIR;
+		m = div64_u64(m, MLX5_CONST_CIR);
 		if (m > 0xFF) /* man width 8 bit */
 			continue;
 		_cir = MLX5_CALC_CIR(m, e);
-- 
2.35.3

