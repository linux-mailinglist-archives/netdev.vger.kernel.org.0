Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325035A45A3
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiH2JCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiH2JCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:02:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235B45A3CC;
        Mon, 29 Aug 2022 02:02:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FD7EB80DB2;
        Mon, 29 Aug 2022 09:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781D3C433C1;
        Mon, 29 Aug 2022 09:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661763759;
        bh=0uM2LvbVnQyiYbs9u0/L77mjcG8pOtqLBMbT1Msxdfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJovKZXLtObsH8NebOCUtO842iShsLPOEK1scNWd/DyJAKWIknqZ17uSUVSc7GGAB
         VB2bqhnYHh/1PNaXMtgYxynEWELA4mv7Zn5Im4Xs8IayRHV+McIHw1zJ20jsqlVuxg
         MghcSurpjFy5hjT+FI8vJad8Gp0TvQnMMjxhw6B0w+dhWgW2UjJbQCbDDvurDr7FcV
         fe0hrX+xgGiDsDcJtd1YtiTImZ5VL2TDu/wVwne2n2mGgttubZqL46LVLob58jGv33
         949ZpUJsgKCeYfDBAx8AhgiLnFlGlM0y0CBpVR+PjMU6x4piTJlN+Z2VfNEhqa41Nl
         ShJg8LUrz1V9g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Chris Mi <cmi@nvidia.com>, linux-rdma@vger.kernel.org,
        Maher Sanalla <msanalla@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH rdma-rc 2/3] RDMA/mlx5: Set local port to one when accessing counters
Date:   Mon, 29 Aug 2022 12:02:28 +0300
Message-Id: <6c5086c295c76211169e58dbd610fb0402360bab.1661763459.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1661763459.git.leonro@nvidia.com>
References: <cover.1661763459.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

When accessing Ports Performance Counters Register (PPCNT),
local port must be one if it is Function-Per-Port HCA that
HCA_CAP.num_ports is 1.

The offending patch can change the local port to other values
when accessing PPCNT after enabling switchdev mode. The following
syndrome will be printed:

 # cat /sys/class/infiniband/rdmap4s0f0/ports/2/counters/*
 # dmesg
 mlx5_core 0000:04:00.0: mlx5_cmd_check:756:(pid 12450): ACCESS_REG(0x805) op_mod(0x1) failed, status bad parameter(0x3), syndrome (0x1e5585)

Fix it by setting local port to one for Function-Per-Port HCA.

Fixes: 210b1f78076f ("IB/mlx5: When not in dual port RoCE mode, use provided port as native")
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mad.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 293ed709e5ed..b4dc52392275 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -166,6 +166,12 @@ static int process_pma_cmd(struct mlx5_ib_dev *dev, u32 port_num,
 		mdev = dev->mdev;
 		mdev_port_num = 1;
 	}
+	if (MLX5_CAP_GEN(dev->mdev, num_ports) == 1) {
+		/* set local port to one for Function-Per-Port HCA. */
+		mdev = dev->mdev;
+		mdev_port_num = 1;
+	}
+
 	/* Declaring support of extended counters */
 	if (in_mad->mad_hdr.attr_id == IB_PMA_CLASS_PORT_INFO) {
 		struct ib_class_port_info cpi = {};
-- 
2.37.2

