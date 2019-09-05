Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 425D8A9841
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 04:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbfIECOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 22:14:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44188 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfIECOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 22:14:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id 30so746994wrk.11;
        Wed, 04 Sep 2019 19:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X5134pBIdnytA6ZzcOXQhnJlea3uuUXNY6SHx+YSKfA=;
        b=TXmzWHfnB1CM0ESblscTdWZZYKsIQTq3JlAer52lVTJFU1czh3TpTYtK4izmWlS+c0
         h5k931AL+CkUR8Og1YHk2sPOw8Cz3mS9kblciB/ylD2FTztPskWQFUZkfnL0TberKB50
         zu4+Q60H/WYogNysFv00JoNC3U58pliRCRLIjL9KfJQWbhlev1UeWcRq2CiONLqjleWB
         4TlQ+8ZWjZAz3rE0HP74hegyI+qNd3EOJKa8QlfzukeoNVocytVlr3i0rQT0lGb4MCuK
         E9Xtyps7RfndY0HHXfiov3KkC4+P0BYDtFdlBR3HJaZ9I02JvYAspaKiQk8pB0MwyFm2
         dMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X5134pBIdnytA6ZzcOXQhnJlea3uuUXNY6SHx+YSKfA=;
        b=s2zVYYUHYPUSb1y2h/im68ihTphMS5x2iA2BYUSmH2im85lYj2S7g3YynScesawKWD
         6xtsm7gZTZDFAs73U44ZWkpCoKllX6iOcjCA1LVhJAQegJrGBrjlJfU15aF5g4TawC0S
         5bBi/toKB4XhhNl0yFmkeC6qp57KuTem3iBwGSfUKCUePacTX5KC6iBQ2ja1CX7A0yRn
         X22P6T339IgumNtrepfb6nHMpJYtEdQCEO0FZh3Pt3mf+e15lf3UD7H8sgc+ghzRkYPw
         BtFaG3k/im8aBvQfyOcktj8h+Q7Gw/FGTrXrqS5xBgUZdKY7lzj1+EK/cFwT8ld8tkgD
         oIgw==
X-Gm-Message-State: APjAAAULR4EewZLc/zIwe+tx5tC67yp17SzL7qhp6iXtr6kshg5EoEtv
        C6J0E2NObMH3AI1Bs1pkYUI=
X-Google-Smtp-Source: APXvYqxB7OspmbW8mVZiPuvUJLIxQZZt6vplfmKx5leKkt0lUkNG03FoAUDHEAZsHktBoak3xQUOaQ==
X-Received: by 2002:a5d:574c:: with SMTP id q12mr455847wrw.69.1567649667300;
        Wed, 04 Sep 2019 19:14:27 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id r18sm674127wmh.6.2019.09.04.19.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 19:14:26 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] net/mlx5: Fix addr's type in mlx5dr_icm_dm
Date:   Wed,  4 Sep 2019 19:14:15 -0700
Message-Id: <20190905021415.8936-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang errors when CONFIG_PHYS_ADDR_T_64BIT is not set:

drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c:121:8:
error: incompatible pointer types passing 'u64 *' (aka 'unsigned long
long *') to parameter of type 'phys_addr_t *' (aka 'unsigned int *')
[-Werror,-Wincompatible-pointer-types]
                                   &icm_mr->dm.addr, &icm_mr->dm.obj_id);
                                   ^~~~~~~~~~~~~~~~
include/linux/mlx5/driver.h:1092:39: note: passing argument to parameter
'addr' here
                         u64 length, u16 uid, phys_addr_t *addr, u32 *obj_id);
                                                           ^
1 error generated.

Use phys_addr_t for addr's type in mlx5dr_icm_dm, which won't change
anything with 64-bit builds because phys_addr_t is u64 when
CONFIG_PHYS_ADDR_T_64BIT is set, which is always when CONFIG_64BIT is
set.

Fixes: 29cf8febd185 ("net/mlx5: DR, ICM pool memory allocator")
Link: https://github.com/ClangBuiltLinux/linux/issues/653
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index e76f61e7555e..913f1e5aaaf2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -53,7 +53,7 @@ struct mlx5dr_icm_pool {
 struct mlx5dr_icm_dm {
 	u32 obj_id;
 	enum mlx5_sw_icm_type type;
-	u64 addr;
+	phys_addr_t addr;
 	size_t length;
 };
 
-- 
2.23.0

