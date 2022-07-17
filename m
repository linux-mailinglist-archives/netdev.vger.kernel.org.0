Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED3957785F
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 23:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiGQVgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 17:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbiGQVf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 17:35:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148F110558
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 14:35:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3193B80EC3
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 21:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3C4C341C0;
        Sun, 17 Jul 2022 21:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658093753;
        bh=YisMAetjrULpPFps2zJKVNK9o1I6wPo2BTTmyAozXY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ad8Je6vy1bQreTp3kQyXrVR9c55CBjEHtZYWwKmcUFmXSZvWb/FbWlKnd6GakzeLa
         flH494UJ29Mq3QGJF0hLk4f6cjhhi8vAyg08Ohfocoo1Ghl7IpyOdMmP79ZlAUOxkD
         CBRUVJ+jKhPWqc/paNz4SYUMEVddpaOPrh+BU8XBhkQeQ52xYpOVzM47kcwrcUdUuf
         Dspk0QTzp3XYoltqcrobUo5kdYZHwYwnApqyem6tfArAHPkYulXPQks3q2XwV3O/mg
         IujE3EyR594zZICynD8BBrvTQWsEZYAqg5HhSKMp9UZ6k3bSOmeqX0xdxaEm5jMKFl
         +erHxFN6D/ADA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [net-next 12/14] net/mlx5: Expose ts_cqe_metadata_size2wqe_counter
Date:   Sun, 17 Jul 2022 14:33:50 -0700
Message-Id: <20220717213352.89838-13-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220717213352.89838-1-saeed@kernel.org>
References: <20220717213352.89838-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add capability field which indicates the mask for wqe_counter which
connects between loopback CQE and the original WQE. With this connection
the driver can identify lost of the loopback CQE and reply PTP
synchronization with timestamp given in the original CQE.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 8e571acc9ed8..5cd835f48bbb 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1835,7 +1835,11 @@ struct mlx5_ifc_cmd_hca_cap_2_bits {
 	u8	   sw_vhca_id[0xe];
 	u8	   reserved_at_230[0x10];
 
-	u8	   reserved_at_240[0x5c0];
+	u8	   reserved_at_240[0xb];
+	u8	   ts_cqe_metadata_size2wqe_counter[0x5];
+	u8	   reserved_at_250[0x10];
+
+	u8	   reserved_at_260[0x5a0];
 };
 
 enum mlx5_ifc_flow_destination_type {
-- 
2.36.1

