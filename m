Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE3EA18741E
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 21:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732568AbgCPUfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 16:35:16 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42516 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732486AbgCPUfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 16:35:16 -0400
Received: by mail-oi1-f194.google.com with SMTP id 13so10386933oiy.9;
        Mon, 16 Mar 2020 13:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2WeeeQuIf6X+Fgo34LchZIqqcKLKtS9v2wrYypr8QcQ=;
        b=VdQPD2e+W+dj6T/pc1K7U0NlTgVjr9jQQJP3cDhSIFn2wVwfqqIrK+OEebkM2I5DdP
         6JeVtmsy3VsaNJIi8D8HiwH35Vqr/TvqZVzjip6PGSJokbfTz2xdUHuuD/qK+NbqhDmL
         Glco0sva6+pQPhZWzH9GLR0nAULr1i1WB5/IsucKUiF/9Gx6/LL8gg7XIVviJsuX4ZiB
         uQGZRfqr4wQZ/4WEmBoDzG2tddTZ9qQ2gbqdYTTT+jSTLpw9MSmZohk/sqxbi5ygP2cO
         2NW29gjwY0UgluKxwgABVfDjfI0Wins3t08xeangQCzKSmpEyDYRYiC1rMgV3OrjHc7v
         4sMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2WeeeQuIf6X+Fgo34LchZIqqcKLKtS9v2wrYypr8QcQ=;
        b=CKSNVcuyCmB+twr8BHPHW2VzuYou0or3qFmhXdugTULa0+6xQ302/abfnAWfAoeiZY
         /H3+3YO4vCVCVHqqmkYPSpWFmAZkNmAQ0evB62OVEGn++SItTiKQv3qXeoIdkWo5F1NB
         iU+TAQXs3hKUI+Mpp2LZQ+DQmgZ4wc5u8lh4pkdSz8Zr/xoYYYMYPSbrpLuLCcTnnt3R
         ZtSHS7NYJgGbT+s2WEgw+EiwJ8WOuepskx814Arz71RkoL+1f/E9OpBLx7y16RqXn9e1
         pMjp4BHlNqSstf3hhW1Fa+i9HZIi5JRqJoFxzv6Zp++sBQeaHNui5sRT5o4kcz6id8uT
         XTWg==
X-Gm-Message-State: ANhLgQ0hZAg7Ag4XmjeRFLC4DBnzhjDzT2R9ClOywxKv4GXuoiofN6Lk
        jRlO3n9270BrunjsSgcI8DA=
X-Google-Smtp-Source: ADFU+vt05REQiVpWVawSbU9b+0kISMA+KKSDQTRxNNjoSMj/l5oSCOSmZZuFg7XjV2AsmmlGhe64nA==
X-Received: by 2002:a05:6808:b17:: with SMTP id s23mr1049303oij.166.1584390914991;
        Mon, 16 Mar 2020 13:35:14 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id o6sm307086oti.65.2020.03.16.13.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 13:35:14 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] mlx5: Remove uninitialized use of key in mlx5_core_create_mkey
Date:   Mon, 16 Mar 2020 13:34:52 -0700
Message-Id: <20200316203452.32998-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.26.0.rc1
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

../drivers/net/ethernet/mellanox/mlx5/core/mr.c:63:21: warning: variable
'key' is uninitialized when used here [-Wuninitialized]
                      mkey_index, key, mkey->key);
                                  ^~~
../drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h:54:6: note:
expanded from macro 'mlx5_core_dbg'
                 ##__VA_ARGS__)
                   ^~~~~~~~~~~
../include/linux/dev_printk.h:114:39: note: expanded from macro
'dev_dbg'
        dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
                                             ^~~~~~~~~~~
../include/linux/dynamic_debug.h:158:19: note: expanded from macro
'dynamic_dev_dbg'
                           dev, fmt, ##__VA_ARGS__)
                                       ^~~~~~~~~~~
../include/linux/dynamic_debug.h:143:56: note: expanded from macro
'_dynamic_func_call'
        __dynamic_func_call(__UNIQUE_ID(ddebug), fmt, func, ##__VA_ARGS__)
                                                              ^~~~~~~~~~~
../include/linux/dynamic_debug.h:125:15: note: expanded from macro
'__dynamic_func_call'
                func(&id, ##__VA_ARGS__);               \
                            ^~~~~~~~~~~
../drivers/net/ethernet/mellanox/mlx5/core/mr.c:47:8: note: initialize
the variable 'key' to silence this warning
        u8 key;
              ^
               = '\0'
1 warning generated.

key's initialization was removed in commit fc6a9f86f08a ("{IB,net}/mlx5:
Assign mkey variant in mlx5_ib only") but its use was not fully removed.
Remove it now so that there is no more warning.

Fixes: fc6a9f86f08a ("{IB,net}/mlx5: Assign mkey variant in mlx5_ib only")
Link: https://github.com/ClangBuiltLinux/linux/issues/932
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/mr.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index fd3e6d217c3b..366f2cbfc6db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -44,7 +44,6 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
 	u32 mkey_index;
 	void *mkc;
 	int err;
-	u8 key;
 
 	MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
 
@@ -59,8 +58,7 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
 	mkey->key |= mlx5_idx_to_mkey(mkey_index);
 	mkey->pd = MLX5_GET(mkc, mkc, pd);
 
-	mlx5_core_dbg(dev, "out 0x%x, key 0x%x, mkey 0x%x\n",
-		      mkey_index, key, mkey->key);
+	mlx5_core_dbg(dev, "out 0x%x, mkey 0x%x\n", mkey_index, mkey->key);
 	return 0;
 }
 EXPORT_SYMBOL(mlx5_core_create_mkey);
-- 
2.26.0.rc1

