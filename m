Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8388B567803
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbiGETub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGETub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:50:31 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A10B1D3;
        Tue,  5 Jul 2022 12:50:30 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id n12so12508256pfq.0;
        Tue, 05 Jul 2022 12:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=37SdVu/I0AZorgpaKaU7xxUX/U/C9pM7788+cOvGxXo=;
        b=bP9AV1g4jXU7AaBQbqDeTt8A40XBQK+TrOXr7haMW0Z5QFg/THYEnIK0oYr9L94YYM
         X8OKch06J5dTr6kixfYy/af5QJqjFhtxL0mtMiYgOi6Ror8vzt1axavDbB6IOujayZyn
         mEj04GvEZ6fVCBI08D5mCo4CQq785hV8v9DlrZ28yf94CLJd6FyP6azjYTjRlH8e0aYn
         ik/xEUzsI8HAEsZAvAKpqDYil8AwsjSJHeAQtUOv6e+e04/W49DjSlFoYTporfV08Xlb
         a8EfJ2rcHqX2IletPO2hNvthIWSdxK9fY/UbS1VAmIg43NAf9/Fhq7xpQt42O/zBAbb8
         KadQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=37SdVu/I0AZorgpaKaU7xxUX/U/C9pM7788+cOvGxXo=;
        b=g6x8csPfKSDE/8TVSD1+ozPgoNub03JVbe0MG5g6l1JlztoAmZ0+Yaj8I3jR9Q6b51
         ro+2fYUfBhPi2w/aYs8Jgw586N/VdqRrTgIAVH8NjSu5LxRXkAhPCmX0tNGZ6QiRq+DA
         7E7Ri+huP9JjJAIR+rKHTO2Op8YMCwMwJ7/71DbD7bm9NaQWFhBln78elBNdojGsw++E
         SnQPl0bXHyLS4wd4itGyB4rz/fzu8BrChoQrCpQYteQMYqgbkc34tci1A8ayRbP33sC7
         EHFaetcUjUzqwi1g05ttXBUh8DvSRLCm6Lr4F3tYUImVRh0ynjqvtvV2dn+wE889Xioq
         lGCw==
X-Gm-Message-State: AJIora+pys5m6breIOuKcFQMbhBXRq+P8MouHABrnc5UHm+ziWiSRbUG
        FkYko6cnuaZ5jtjply0j4xxFHOgnAv6vmxOs
X-Google-Smtp-Source: AGRyM1s5YB3qHl69kOMEJZ015jOq3FOyorbYcGTuq2C8q05wm/FDscHTaWVxBsgIuQISAPKtkec0hw==
X-Received: by 2002:a63:a112:0:b0:40c:450e:b1ad with SMTP id b18-20020a63a112000000b0040c450eb1admr31468801pgf.493.1657050629579;
        Tue, 05 Jul 2022 12:50:29 -0700 (PDT)
Received: from octofox.hsd1.ca.comcast.net ([2601:641:401:1d20:3caa:449f:1bc2:21eb])
        by smtp.gmail.com with ESMTPSA id nk3-20020a17090b194300b001ef8407f6d2sm5848777pjb.46.2022.07.05.12.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 12:50:28 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-next@vger.kernel.org, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] net/mlx5e: use div64_u64 for long division
Date:   Tue,  5 Jul 2022 12:50:25 -0700
Message-Id: <20220705195025.3348953-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_LOCAL_NOVOWEL,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes the following build error on 32-bit architectures visible in
linux-next:

  ERROR: modpost: "__divdi3" [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
  ERROR: modpost: "__udivdi3" [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!

Fixes: 6ddac26cf763 ("net/mlx5e: Add support to modify hardware flow meter parameters")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
index 28962b2134c7..81e7fe819017 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 // Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
 
+#include <asm/div64.h>
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
2.30.2

