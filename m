Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391111E3AF5
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 09:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387580AbgE0HvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 03:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729052AbgE0HvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 03:51:07 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B04C061A0F;
        Wed, 27 May 2020 00:51:07 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q24so1164448pjd.1;
        Wed, 27 May 2020 00:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lVQfYsDAh0Z24p4AneVfNcvrH/seQIrLDjjV5CDfqUA=;
        b=XmeGLa0EtTmu/2gSfi5c1sXBVVRgeLyoAEq8SYefdqXVvWWvvDqkvjb5c0GRxLaam0
         IPOGn+/AI9uCkUQDuodifGbYvT0nB21tjPxt7rcb/xMOfxvUihM8QPdZrzScsq9HUbyD
         uYE5zrQD99iTXQno+528dOCLB4oaD48/TmPeoARY9h2KDXV5UnvV/7YIY/OUzYaGca+7
         WbgZM9dKTugi95NNUuo4ZADrHP49F29Fe+38KuUHP1SggGJwZkQQNsK22HhOXeIN0EJQ
         ASm1MvGxC8/PqQ2LR24mKtVNw+708lyqi9770tCxMGKWUIjbPLDaJyeIPmplQQHpDEOs
         ntyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lVQfYsDAh0Z24p4AneVfNcvrH/seQIrLDjjV5CDfqUA=;
        b=EjgvLoqGijmR7OxIZYJfbvaLwq9i45K6XuMKB9HHvBm++D+wV4RlRYWusEP/doVkOs
         XSloW+ZESO6IBYBUHLBr8bd1rDTCsxJ98JLC2oyCGODYUgfdTLl4mTuJx0RZOIExFMK8
         3AgCuJQVbnl1nYvYJzjnoQ623xNz5zDpr9p0Px0H/Nvvzf4B+IbKAA2TPzNDQZb7bbfK
         e5Oo/o+o0a4Ma0xnWTabNhDTsIPU+B0Oi0vnR+Yk7SLxiSqIfc0LWE94kwP3qYL2PIU4
         RHmSyf9ZjLt2O7owxXWNGJD7oPdtIU2lJDqrQI6byK3Ok5uUDlMsMlLsDS5fDpV3rtXU
         M1yQ==
X-Gm-Message-State: AOAM533+2EW9ahqD1MuHxw8B5tufOcLLgv5RD34sWlPKpDdEiaGPH31/
        PmU2JDFRvhFV+nHXn7QOnt0=
X-Google-Smtp-Source: ABdhPJxr8ZxmDGZ+hM3kVqELCR7QP1gaFkHTm7tIQeOayjhIS9dRSFDLUX0jX/fgqWbW+MmD4eDv0g==
X-Received: by 2002:a17:90a:2586:: with SMTP id k6mr3595800pje.121.1590565866882;
        Wed, 27 May 2020 00:51:06 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id 206sm1341234pfy.97.2020.05.27.00.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 00:51:06 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] net/mlx5e: Don't use err uninitialized in mlx5e_attach_decap
Date:   Wed, 27 May 2020 00:50:22 -0700
Message-Id: <20200527075021.3457912-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.27.0.rc0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:3712:6: warning:
variable 'err' is used uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]
        if (IS_ERR(d->pkt_reformat)) {
            ^~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:3718:6: note:
uninitialized use occurs here
        if (err)
            ^~~
drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:3712:2: note: remove the
'if' if its condition is always true
        if (IS_ERR(d->pkt_reformat)) {
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:3670:9: note: initialize
the variable 'err' to silence this warning
        int err;
               ^
                = 0
1 warning generated.

It is not wrong, err is only ever initialized in if statements but this
one is not in one. Initialize err to 0 to fix this.

Fixes: 14e6b038afa0 ("net/mlx5e: Add support for hw decapsulation of MPLS over UDP")
Link: https://github.com/ClangBuiltLinux/linux/issues/1037
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index fdb7d2686c35..6d0d4896fe0c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3667,7 +3667,7 @@ static int mlx5e_attach_decap(struct mlx5e_priv *priv,
 	struct mlx5e_decap_entry *d;
 	struct mlx5e_decap_key key;
 	uintptr_t hash_key;
-	int err;
+	int err = 0;
 
 	parse_attr = attr->parse_attr;
 	if (sizeof(parse_attr->eth) > MLX5_CAP_ESW(priv->mdev, max_encap_header_size)) {

base-commit: d3d9065ad99d0d8d732c950cc0a37a7883cd0c60
-- 
2.27.0.rc0

