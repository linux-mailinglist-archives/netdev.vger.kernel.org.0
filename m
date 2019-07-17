Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C206B7D2
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 10:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfGQIDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 04:03:45 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45214 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfGQIDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 04:03:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id o13so10743807pgp.12;
        Wed, 17 Jul 2019 01:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2QQA3vCexTn2frwX9oyaSyj/otI+PVKWAPqRt9xz/tI=;
        b=mMRLX4vd9rAOrjLK91NV8g2jlkCx3xJaU2OcazQoxMCK2uQXVArVpft9CPKPpqbFM/
         rrD099qPhOMLuCV1/g87WIEBAZgSEMY3clCtKASRrzsesFzTCODuztCmFmVD1RjEQ+IF
         uZiNfWEMScgQMyGfLB5FO6u2QlrbJnSVApVUxCifUxJPWfuy3+Q8OtjuThQTgFK4GmrG
         TwE8M0jztpLh36qWBtyTZ+A+udw/YLUvPDHD/fKlIXalce/oK9pXXk64aWn0JfRU3E4p
         DUCop+I3+UQEzoMYSOkjXOMgSjw5ccXpsc58WM9C0MlrEaTnArS1p8FUl/T9HELLboEr
         mVng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2QQA3vCexTn2frwX9oyaSyj/otI+PVKWAPqRt9xz/tI=;
        b=atALVDJst69s2yHVMtZMslL6mJw37SdXRLSJzz0odnmgixVanYgsg9Hcqpz8q93zc5
         1x9jDG1bx7GrCKsXcMpQe+97S/o0/nnlAagq6snsvGCSxAMO4jSrI/69gYZ0/S+nZ3LI
         Dg3GKj5ZA0RmQDqhCUEr+WDZBwgOhCJ6/oDOuz3Povid6Uew9KXiMvbc4dD2BT3XXrZh
         H7LzdMjNJjkBlRc2t/+8kPNpqnwomFOYVNUpzOqrUWSkO1GUx/1bTDGAWnRz9591fAzW
         ihPm5KOKZWPR2fRGQwLpuJz89l5wSURCg4THt26iQKaaR0fjH1xXUNVR2piHJ+VxFB02
         GSDw==
X-Gm-Message-State: APjAAAXX7zYOBGE1+Kbm28FRZj07S9HVUwg01YiHQCvmH/pqWi4fD71C
        QDsgj0f/sjXXQ1qsZRVIVsY=
X-Google-Smtp-Source: APXvYqxDN1G3bzBqD87mS88HozaTAIPTkQtuuVcqf/+I4IBdSowWubpAA0iomTS8usiVu23dzXx4iQ==
X-Received: by 2002:a17:90a:3724:: with SMTP id u33mr41943097pjb.19.1563350624551;
        Wed, 17 Jul 2019 01:03:44 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id y11sm27348761pfb.119.2019.07.17.01.03.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 01:03:43 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] net/mlx5: Replace kfree with kvfree
Date:   Wed, 17 Jul 2019 16:03:22 +0800
Message-Id: <20190717080322.13631-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable allocated by kvmalloc should not be freed by kfree.
Because it may be allocated by vmalloc.
So replace kfree with kvfree here.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 2fe6923f7ce0..9314777d99e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -597,7 +597,7 @@ mlx5_fw_fatal_reporter_dump(struct devlink_health_reporter *reporter,
 	err = devlink_fmsg_arr_pair_nest_end(fmsg);
 
 free_data:
-	kfree(cr_data);
+	kvfree(cr_data);
 	return err;
 }
 
-- 
2.20.1

