Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41548466BFD
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 23:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236008AbhLBWTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 17:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhLBWTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 17:19:11 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948D7C06174A;
        Thu,  2 Dec 2021 14:15:48 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id d9so1701512wrw.4;
        Thu, 02 Dec 2021 14:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yff+1FpOuMigZbAy73J63jy1kO8FukCv/6vnynIzzvw=;
        b=m7vw3K0ooNVuluM9tx9YuP9gt3hvjazf/xJuqhZaUTEyFbMV27ooosY8kotGRMfbUJ
         Ul/aC7auJnanWmh6B5rnVBGeZW0QMFEx2dlW6MIBRv538NC1B0T6peUzZcuI+oAo+9EZ
         wPWOOqiL9oe8oPFNiS2gzfK4NOaA9HSOannG9uHvwC41sqDg8L9MnQzqIBLjsxFZilx7
         mw/XLLN+QHq2kkt6I8xxjIkkS5USR4xSanBl+0L7uXh7hFt+ZKDWyWNjBAlCRMgNgKTD
         cf3+814AUWKcCgxsw5gJmul1K3+3nFAQLVbb2Pm4vzwbFZXxZEoQd6GoJ+nRVzjLZqtn
         Jx6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yff+1FpOuMigZbAy73J63jy1kO8FukCv/6vnynIzzvw=;
        b=COeMJHcLnfUqIL1ko2Qn71ARKu+0BiQCZQr7cb2sqNkbHT4L0RYYQXlXUQ9VbpbzhL
         eq9yfZo/WMvFgcnp4ILeYmZBgrmrs9jUyBfnEjoh83RJIcQSMhVYqD+AiCaRKF9DYyOi
         ORO6A0Efmy8/3zpj28azxFb4IMJcIPVHfKHL1dEJCcBnIu8yTJflw7ukgQrhgFaSfXhI
         2sdV7zaBgFJ7dyrUZH4thlBi9w3BC1KTnRDOvdVaiitbO2+AXf7OVJPmgVddpNekUEyQ
         P27pByp2ewNEeUwtnapBq6g1mAY0ghbYPWlqMz7I8dHq4yM1wpOCSPRXt91iH9QH6TYB
         xEOg==
X-Gm-Message-State: AOAM530vYkj7j4G2/eloqEe/hFJEgmntg55h91Nl5qX1fmDDCxRlha5A
        v+lQKikfCt26wOJrMCbkE/+SHGOJdNS5VAG0
X-Google-Smtp-Source: ABdhPJyw0fnVHwqCbx2j/3f+LhuiQhCMSFhQy7mZzArLrLknGa+6azR8ta8grSX8QHKGzuZfQd0QYg==
X-Received: by 2002:adf:dc44:: with SMTP id m4mr17644222wrj.550.1638483347151;
        Thu, 02 Dec 2021 14:15:47 -0800 (PST)
Received: from localhost.localdomain ([39.48.206.151])
        by smtp.gmail.com with ESMTPSA id h15sm3600820wmq.32.2021.12.02.14.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 14:15:46 -0800 (PST)
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, amhamza.mgc@gmail.com
Subject: [PATCH] net/mlx5: Fix dangling pointer access
Date:   Fri,  3 Dec 2021 03:15:39 +0500
Message-Id: <20211202221539.113434-1-amhamza.mgc@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix for dangling pointer access reported by Coverity.

Addresses-Coverity: 1494138 ("Use after free")

Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 3ca998874c50..856023321972 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -335,7 +335,7 @@ static int mlx5_health_try_recover(struct mlx5_core_dev *dev)
 {
 	mlx5_core_warn(dev, "handling bad device here\n");
 	mlx5_handle_bad_state(dev);
-	if (mlx5_health_wait_pci_up(dev)) {
+	if (dev->timeouts && mlx5_health_wait_pci_up(dev)) {
 		mlx5_core_err(dev, "health recovery flow aborted, PCI reads still not working\n");
 		return -EIO;
 	}
-- 
2.25.1

