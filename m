Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED889320AF5
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 15:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhBUOgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 09:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhBUOgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 09:36:50 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C22C061574;
        Sun, 21 Feb 2021 06:36:10 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id e9so6014552plh.3;
        Sun, 21 Feb 2021 06:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0NKlohU11NhDaMLzPFWNpnCD3UlsUYj1N/lz0ikZqEU=;
        b=unte5hEVeIHbWIlnmFSIky6LLV07dwUI9HCak7zYa6fyGvPNNKaCoM0RYeToLptvNz
         uiOpXFxkFPEj53cmXnQRg2GbmHWGmxAN0kJSuZ4fgS7OVLsUWzPRq1tu9Y49DDDAa7jJ
         OqA++CAkcigfdc0vp6o9fRs6YAmiLH3GiH+9QfFcFUjRrL2gBNl31UqDuLWnxyS/Lb7c
         rNkWE2Ei3xaQh5TdWWyinKkTiZu5E+Z/YFSIliBwjPW+AHOuttKjvwryP2s0GCzCC80a
         qFaMSy4szmUCE/mJ4bUqpjoAywITS6MSST35bVbaah6hDvVMSKL7xtI4EyLPd9tS+n9p
         1rUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0NKlohU11NhDaMLzPFWNpnCD3UlsUYj1N/lz0ikZqEU=;
        b=lzYyLRb2MCzL29IOWCZnEdcVvIFktTcTQ8JPtvomD40HytvouG+Ojx9y56Mbl1SDnr
         vCybXy7Mwa/Rs2gGVowbTIDxkgI5ocw6KYCd/VFGncWItIQV3nbRZXFIsrGP5RlJRHk5
         otCNsSVwUYBdavfG7ZXDva71g467SCNPa7cGAvgYQO6nCZz6LoYi2oX7Mvcg5z2D+3MF
         xu2QAx8K19pV6ui5r3g9dWhBQXDxgl9VyWZrNA5PGWkhcgMbg8d85sNDvwXFd5mU9k3C
         6KMvJpgot24kXVYkiPi1aHRQgVqEvmRWjAF0s6qYtl9X9GOkz0IVr+rQwRE+SBQnDLuy
         ekZg==
X-Gm-Message-State: AOAM531yNLWHDbXPdSQ2AbnZLoR6a6Xm47ula5kbF4lVCO2zPTOBkONs
        1kuXWuDzJb1+xqbPLCbC0aw=
X-Google-Smtp-Source: ABdhPJx/3JBAbs1QqHYNQuzH/72GS4CrMvmYREX2IaZalk4T+qmnBdKr18y3/UzCAnPzfq4QS34oVw==
X-Received: by 2002:a17:90a:1904:: with SMTP id 4mr18658104pjg.212.1613918169730;
        Sun, 21 Feb 2021 06:36:09 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id m16sm16142189pfd.203.2021.02.21.06.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 06:36:09 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Moni Shoua <monis@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] net/mlx4_core: Add missed mlx4_free_cmd_mailbox()
Date:   Sun, 21 Feb 2021 22:35:59 +0800
Message-Id: <20210221143559.390277-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx4_do_mirror_rule() forgets to call mlx4_free_cmd_mailbox() to
free the memory region allocated by mlx4_alloc_cmd_mailbox() before
an exit.
Add the missed call to fix it.

Fixes: 78efed275117 ("net/mlx4_core: Support mirroring VF DMFS rules on both ports")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 394f43add85c..a99e71bc7b3c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -4986,6 +4986,7 @@ static int mlx4_do_mirror_rule(struct mlx4_dev *dev, struct res_fs_rule *fs_rule
 
 	if (!fs_rule->mirr_mbox) {
 		mlx4_err(dev, "rule mirroring mailbox is null\n");
+		mlx4_free_cmd_mailbox(dev, mailbox);
 		return -EINVAL;
 	}
 	memcpy(mailbox->buf, fs_rule->mirr_mbox, fs_rule->mirr_mbox_size);
-- 
2.27.0

