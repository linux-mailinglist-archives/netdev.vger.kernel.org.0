Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED1932D525
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 15:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241884AbhCDOTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 09:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241785AbhCDOTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 09:19:02 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F99C061756;
        Thu,  4 Mar 2021 06:18:22 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id a4so18963467pgc.11;
        Thu, 04 Mar 2021 06:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LBqlEZyPcKTt510snqgHtrJs4QRW+RndpggZVW6Cb+U=;
        b=qtwFImKXhr7tSBAHx4h06wq7ZHcxq94ai6Fpd1sBmD+6WVbNfohmeL8bkmQZtT3Xn4
         BPsC2/bYDPPP/cFr+PoTaySPMZ36aZFfSqKJLvhEXXMFCJscqv+qNpjHdaMiqCWQwZMg
         4XgjY8eiphEDPWolW9izecbXkm+L5Hljb05iHeHlvKmFIOIfpun57GkrdZuJ9iAlSK7L
         kX+DZRRVmI9C1CdyvVw4tJS8Gf/6P/lF1VPEQMWAfKUza50s28hJBCVPwbpC+LxNh4UO
         3R2CmAi6HJEXAU3MF9SDKlr5nxP12NdSaCk6AnIpE6e0DbtA/rJ3YHHzoRGOiQSUReQB
         g6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LBqlEZyPcKTt510snqgHtrJs4QRW+RndpggZVW6Cb+U=;
        b=Tpns1et2D12YHwBPFJ289ip57QUzNI777/Mqatd3Ta5SUSUeppHBq7fiydA0jBqXeA
         Z7gXBH/7fTeCq3NT7LLeieFCehIn1TWI/jV80EI59NngEf0nwyXR8wkE4dTEnwepilKE
         OQLx40izqOHTuWvcCHrftyOfYyf1CbAsd0RyMzP8OVY+KUiz37bW3ngT88Ug1QfO3QTC
         aeYueWVhlMbXZ1dmrsZEgcbuHDbjoZvSOqY2eKId5IK3CfUAwJE0nbrq/FDfNGi/rETb
         Gz27qsPxqlkIcYrO3KTS9eW9JHIX8npmzTC8WwO5Fr6Z8mbpOqWfE8YbUo07rY0Llf1k
         UjBw==
X-Gm-Message-State: AOAM533K+KbuQ2IIvXOkAdb4YgiC2Wgdaf5/bGtSk2ePO0MN1opOShfa
        Y+cAIYckYKfoBhqY5MdXSGE=
X-Google-Smtp-Source: ABdhPJww6ZarzP1NxytLeX4O77IoK8O14A+I26ZWyCHmv/GKzvzp2A+zZQhVsCpgeb7RB9Hr2pBSbw==
X-Received: by 2002:aa7:9711:0:b029:1ee:b2c7:ecfe with SMTP id a17-20020aa797110000b02901eeb2c7ecfemr3928358pfg.58.1614867502027;
        Thu, 04 Mar 2021 06:18:22 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.129])
        by smtp.gmail.com with ESMTPSA id x14sm28445213pfm.207.2021.03.04.06.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 06:18:21 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     borisp@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: mellanox: mlx5: fix error return code in mlx5_fpga_device_start()
Date:   Thu,  4 Mar 2021 06:18:14 -0800
Message-Id: <20210304141814.8508-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When mlx5_is_fpga_lookaside() returns a non-zero value, no error 
return code is assigned.
To fix this bug, err is assigned with -EINVAL as error return code.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
index 2ce4241459ce..c9e6da97126f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
@@ -198,8 +198,10 @@ int mlx5_fpga_device_start(struct mlx5_core_dev *mdev)
 	mlx5_fpga_info(fdev, "FPGA card %s:%u\n", mlx5_fpga_name(fpga_id), fpga_id);
 
 	/* No QPs if FPGA does not participate in net processing */
-	if (mlx5_is_fpga_lookaside(fpga_id))
+	if (mlx5_is_fpga_lookaside(fpga_id)) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	mlx5_fpga_info(fdev, "%s(%d): image, version %u; SBU %06x:%04x version %d\n",
 		       mlx5_fpga_image_name(fdev->last_oper_image),
-- 
2.17.1

