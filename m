Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14E432FB12
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 15:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhCFOH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 09:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbhCFOH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 09:07:29 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0451C06174A;
        Sat,  6 Mar 2021 06:07:26 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id o10so3329742pgg.4;
        Sat, 06 Mar 2021 06:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=F0SjiCboT6GDUEHPfbG3Clqv3ILwMSQy+iD8PAxRb5c=;
        b=LS82c58fxfkTcP+tx8loY2y5a9C2zL73pbG9BxOyVHx0FYlUDsgGu670PdyLVkS75g
         Shvtb4avdMzEGp+bLJo3xnZUmgolkJJmzh3pR3YlQAom0zx2x9GsyrFGxWD+Q+l32mlh
         aSDfRM9WMmoZ7WFOkTRuQQj13O1XAWwB26WE924o0GbRV0Esn5BemDfRy1KX4HcQf+Fs
         CK7VqIqCihvqBp5N2AELRgZ6WyVcU0/4oCcIz9T5ipigm3NUAy7V3G/MtO6iuWdCRiWu
         3P9eBGiNurr9kBqZePxe+Vs00vA82Ei+QKu+BVwn80qmd8Zfd6OhWyVBqZKcwCZWC4E1
         +Flw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=F0SjiCboT6GDUEHPfbG3Clqv3ILwMSQy+iD8PAxRb5c=;
        b=NsPgLbi68Fm/wOCboqjpFc+/A0+YX7N+qcj7reW2sobc8WSrR18hD0sX8c26yzDDwY
         VSgkw+7Rd16xdvuhsEjdxMVcjknO26iYNduhw3NVXTHafOUT9DOX/nPoGNYdY9LsrPwl
         yI9tEIeCil3hDCYex4rzkODpLoAPNaKx9zYtyTupV6xFld6YJRE1Zik9c1vzQYDiwnJl
         2Mya6C2JE/D4XxKJpGycLvTmXiKvQz8oxO/pF9rrqod0R17umiS+BwPUfS034uth6aRa
         3cbYfzJt06xoUdSMjyDdLxS3s2NCFW4HhobB6u8p22MImjFj5ENuo8ngPOLkxiw9Gi4e
         Ks6A==
X-Gm-Message-State: AOAM531cNbTH8Z24fBtrZRT+pidXh8da6O0aUoUIGV6z3/3uC7ltM+Oc
        7D8HUZpxS1k5gRqg2MsM9WHeiBVdnjFpWw==
X-Google-Smtp-Source: ABdhPJz8ny5s0BgnkeQPqUwSQGLzytCMVZShB3wt53a39/w1iArL5x7ZB4Ocg+Ci6e3HWdz/g4BQdg==
X-Received: by 2002:a63:2262:: with SMTP id t34mr13381075pgm.303.1615039646370;
        Sat, 06 Mar 2021 06:07:26 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.79])
        by smtp.gmail.com with ESMTPSA id v1sm5653116pjt.1.2021.03.06.06.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 06:07:25 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     jiri@nvidia.com, idosch@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: mellanox: mlxsw: fix error return code of mlxsw_sp_router_nve_promote_decap()
Date:   Sat,  6 Mar 2021 06:07:05 -0800
Message-Id: <20210306140705.18517-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When fib_entry is NULL, no error return code of
mlxsw_sp_router_nve_promote_decap() is assigned.
To fix this bug, err is assigned with -EINVAL in this case.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 9ce90841f92d..7b260e25df1b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1981,8 +1981,10 @@ int mlxsw_sp_router_nve_promote_decap(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
 	fib_entry = mlxsw_sp_router_ip2me_fib_entry_find(mlxsw_sp, ul_tb_id,
 							 ul_proto, ul_sip,
 							 type);
-	if (!fib_entry)
+	if (!fib_entry) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	fib_entry->decap.tunnel_index = tunnel_index;
 	fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_NVE_DECAP;
-- 
2.17.1

