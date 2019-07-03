Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF0E5E8EF
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 18:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfGCQ3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 12:29:23 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36821 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfGCQ3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 12:29:23 -0400
Received: by mail-pf1-f194.google.com with SMTP id r7so1539787pfl.3;
        Wed, 03 Jul 2019 09:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ukpE5Efrih9741FF7Ptz3AuMTrxldvMpVIelefrMWd8=;
        b=VFHvaY/QUR9CJw4LutZIS4l0tUOkLM5t0vNYQ30haFIf5YyYSh1WLHWyWAXEsApdc7
         WDF5ufihNTI7HCrR68HRwXKFuHxtNQx19PVylk3H22RDNYkeatjP7N4dKNnfD01Irw2K
         KgyX1+Vh72pgGgLFVvgBG/Gu+FJwAOSMjRvR5JbbFPacClGOQbsCskt39i3qW4vKKweu
         /DZUSSaQWnfF7fRhc+ENl+OCGNc0fhhYIzt2lWlCYhnHQUx7Y+MKu0v3vHBvPtNXds7n
         TE4evUq6Ap8ktZgRQV9lr20nBT8VOkBIQcvT+2ymesppZ10wVC0cTLTZeyn4qLahlrS0
         Zd2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ukpE5Efrih9741FF7Ptz3AuMTrxldvMpVIelefrMWd8=;
        b=qnJ4KRriy1TFsLb7f+BhJRo/E2ChTO6Pi9wiAs67Ix+MlbeCfmIIq4XwW3XBuM03V8
         ucnXo3eMd0vDqmhog5s0TzYWo7NFygwrGAyJAB0iRaQXdmGKZWlpsYJawE3SZ8lsRIq5
         56AnKaec2GXUE5GFrGpPmUqH8DkbV0CtQD1B8eCSiMjTRx920HAX9y8b1m1mADmlOtv0
         WA3SoLxNBVZYiDU/AmAEWyKhHblTITkE2p68yZXOtvgWGpqRaE4s/Q1Jjl/AaDpj1EWc
         svVIqdSPY+MNhYnEyLq4L98uxaRNTBZBjf6ZAq84w3kJER3+VaQ7QBRdMvSHVIPA1ZgP
         klDg==
X-Gm-Message-State: APjAAAWs8i/Sb/95xdX9dX2VoEgoErmUlcdbrKWi1SVYH7IoFBwDfGFU
        WGd1RbCh2YXHpgCHCfdrn7w=
X-Google-Smtp-Source: APXvYqxMigY6yXy1tg8RzAOEMC+Nj7Azp9cC3vcL3i/BkcU6PUw+owKmeMJwcO6kkTv1M+g+BaOhWA==
X-Received: by 2002:a65:55c2:: with SMTP id k2mr25617330pgs.217.1562171362526;
        Wed, 03 Jul 2019 09:29:22 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id u10sm2693913pgk.41.2019.07.03.09.29.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 09:29:22 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v2 15/35] net/ethernet: Use kmemdup rather than duplicating its implementation
Date:   Thu,  4 Jul 2019 00:29:15 +0800
Message-Id: <20190703162915.32553-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemdup is introduced to duplicate a region of memory in a neat way.
Rather than kmalloc/kzalloc + memcpy, which the programmer needs to
write the size twice (sometimes lead to mistakes), kmemdup improves
readability, leads to smaller code and also reduce the chances of mistakes.
Suggestion to use kmemdup rather than using kmalloc/kzalloc + memcpy.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
Changes in v2:
  - Fix a typo in commit message (memset -> memcpy)

 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 4356f3a58002..e971a6bdf0d5 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -4437,14 +4437,13 @@ int mlx4_QP_FLOW_STEERING_ATTACH_wrapper(struct mlx4_dev *dev, int slave,
 		goto err_detach;
 
 	mbox_size = qp_attach_mbox_size(inbox->buf);
-	rrule->mirr_mbox = kmalloc(mbox_size, GFP_KERNEL);
+	rrule->mirr_mbox = kmemdup(inbox->buf, mbox_size, GFP_KERNEL);
 	if (!rrule->mirr_mbox) {
 		err = -ENOMEM;
 		goto err_put_rule;
 	}
 	rrule->mirr_mbox_size = mbox_size;
 	rrule->mirr_rule_id = 0;
-	memcpy(rrule->mirr_mbox, inbox->buf, mbox_size);
 
 	/* set different port */
 	ctrl = (struct mlx4_net_trans_rule_hw_ctrl *)rrule->mirr_mbox;
-- 
2.11.0

