Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8136C01E4
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 14:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjCSNAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 09:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbjCSNA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 09:00:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2260D206B6;
        Sun, 19 Mar 2023 05:59:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02C4CB80B91;
        Sun, 19 Mar 2023 12:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58D7C4339B;
        Sun, 19 Mar 2023 12:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679230785;
        bh=6Z4VlGlzFyNwLj9RhTs5XzQAa08LX/sHycLA30928Zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gidYDq0FpAo9/9DdgagO91HN6GyEZMxAQnHnZ5Ys7K1ArbWRvx02HQmpwqHL7c6QS
         vWJxW/4OEEudZywsYutLLLQ4brZuIbMR0ftWl+h/6O7qB+UIYl1uU6Akhm0ylxbQkD
         B5vculTkAiq38VcraDIL7Cv1oEYI39DLMMOnEDtoOz0qxOKUrXvYbquUwAQkrl/axV
         RCdy86kgYMhqV/NALy69n+sIozQUvJGi1LfEHWMfkQ9rpfiuSV6BaZm6qQMJil82XC
         q+VMNgi437JOAa1XHXDg3QLBsGzRfdeTQO9/u+5Ddv35svxlCoUwQqCp9x1l1WMvCN
         SHTGDgylchk+w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Or Har-Toov <ohartoov@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 1/3] net/mlx5: Expose bits for enabling out-of-order by default
Date:   Sun, 19 Mar 2023 14:59:30 +0200
Message-Id: <75d6dfe263989a05c08c43406132b336ea12d00a.1679230449.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1679230449.git.leon@kernel.org>
References: <cover.1679230449.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Har-Toov <ohartoov@nvidia.com>

Add needed HW bits for enabling out-of-order by default and
use go_back_n when out-of-order is not needed.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 15a850f52ef2..e4306cd87cd7 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1077,7 +1077,9 @@ struct mlx5_ifc_roce_cap_bits {
 	u8         sw_r_roce_src_udp_port[0x1];
 	u8         fl_rc_qp_when_roce_disabled[0x1];
 	u8         fl_rc_qp_when_roce_enabled[0x1];
-	u8         reserved_at_7[0x17];
+	u8         reserved_at_7[0x1];
+	u8	   qp_ooo_transmit_default[0x1];
+	u8         reserved_at_9[0x15];
 	u8	   qp_ts_format[0x2];
 
 	u8         reserved_at_20[0x60];
@@ -1493,7 +1495,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_b0[0x1];
 	u8         uplink_follow[0x1];
 	u8         ts_cqe_to_dest_cqn[0x1];
-	u8         reserved_at_b3[0x7];
+	u8         reserved_at_b3[0x6];
+	u8         go_back_n[0x1];
 	u8         shampo[0x1];
 	u8         reserved_at_bb[0x5];
 
@@ -3263,7 +3266,8 @@ struct mlx5_ifc_qpc_bits {
 	u8         log_rq_stride[0x3];
 	u8         no_sq[0x1];
 	u8         log_sq_size[0x4];
-	u8         reserved_at_55[0x3];
+	u8         reserved_at_55[0x1];
+	u8	   retry_mode[0x2];
 	u8	   ts_format[0x2];
 	u8         reserved_at_5a[0x1];
 	u8         rlky[0x1];
-- 
2.39.2

