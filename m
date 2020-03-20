Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE6A18C536
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgCTCQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:16:53 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:34009 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbgCTCQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 22:16:52 -0400
Received: by mail-oi1-f196.google.com with SMTP id j5so5030974oij.1;
        Thu, 19 Mar 2020 19:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=89WFqHSLk0grEsQCNT9OeVbEIPTIenyQQOmFqx/NL78=;
        b=kAIRu4pUhIlwxbiZxg0ycNNwYymI+sZ6Fvz3jXT/MZbhuw8HBC2zwLd1y91gHshsGJ
         HMi7HcbEmrbiDRjrBPMD0FKe+/yMFBH97gCjJ9rKwFlaiYkimbPxLzwgBdaaIawNwJx+
         rqbtYtxgTpz5CZjg07H/5fmOlAVx6syro/EHiZALgjMBiJExBS3c0slHMhsdQaP6vzhx
         oJR+cXG9LBna3rg/eWWfhXVY5Uca4mMTXAqqf/ZNAnr7D12PqZOMuXGKEhwp7S0z764h
         yJ+wlo+znWPNlSq12TrME7elo/QXyWUkbs+FmtAwqHGI8+AMPb0JvByMa7X8osn6GqjL
         6VXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=89WFqHSLk0grEsQCNT9OeVbEIPTIenyQQOmFqx/NL78=;
        b=DWCJyPlTf8BtDt06F878cIvyuRZqo7Xp8NtZolxvhv+1U9VbAAlxVLx9RDC2bXeAfX
         8VVGPl3eMZy49VVfTg7WZ+0kCgScaBGO9ZrzoywQWm0XF4jPkL1UbqdtTn+TfDkw3n0s
         fDPGNafRJnwZHDPUiyessiOkVPk1rWJEuPeGClRIyLukKqNnTdcy24gL6UT2JdXKW6y4
         ORNzFbkxMnO9L34eFQGsjKkJbELK3cbWX25RW7UAl9YtM1qTbUoKYEo/xhy9Zqy4MqoV
         5fxLnsr7iT8j83Qo87b4AHhOr7mSE+vqZ2MOVFMi4yP1EFgF5zc5QW9oSuP09C4X+qRB
         czIw==
X-Gm-Message-State: ANhLgQ3QCsZ9wnfGXaPX/BgWqc/Sz9bxfAlu9adBKNImqJZ5E60q1vV9
        XfaGagp+gOOlRGKvtIu/+J3qHY2n
X-Google-Smtp-Source: ADFU+vtdYN4hEqu0MrneDZ4oEhwKL87CpvbOgt5Vi0pTk4wnmDGJpC5MNv+YFgesgGCY5oKATCEwyg==
X-Received: by 2002:aca:4991:: with SMTP id w139mr4852785oia.145.1584670611950;
        Thu, 19 Mar 2020 19:16:51 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id j23sm1484287oib.32.2020.03.19.19.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 19:16:51 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] mlxsw: spectrum_cnt: Fix 64-bit division in mlxsw_sp_counter_resources_register
Date:   Thu, 19 Mar 2020 19:16:38 -0700
Message-Id: <20200320021638.1916-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.26.0.rc1
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building arm32 allyesconfig:

ld.lld: error: undefined symbol: __aeabi_uldivmod
>>> referenced by spectrum_cnt.c
>>>               net/ethernet/mellanox/mlxsw/spectrum_cnt.o:(mlxsw_sp_counter_resources_register) in archive drivers/built-in.a
>>> did you mean: __aeabi_uidivmod
>>> defined in: arch/arm/lib/lib.a(lib1funcs.o)

pool_size and bank_size are u64; use div64_u64 so that 32-bit platforms
do not error.

Fixes: ab8c4cc60420 ("mlxsw: spectrum_cnt: Move config validation along with resource register")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
index 0268f0a6662a..7974982533b5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
@@ -303,7 +303,7 @@ int mlxsw_sp_counter_resources_register(struct mlxsw_core *mlxsw_core)
 	}
 
 	/* Check config is valid, no bank over subscription */
-	if (WARN_ON(total_bank_config > pool_size / bank_size + 1))
+	if (WARN_ON(total_bank_config > div64_u64(pool_size, bank_size) + 1))
 		return -EINVAL;
 
 	return 0;
-- 
2.26.0.rc1

