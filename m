Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D9C49B979
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348572AbiAYQ7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586531AbiAYQ5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:57:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82444C0617A3;
        Tue, 25 Jan 2022 08:54:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 498CAB81626;
        Tue, 25 Jan 2022 16:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D50C340E0;
        Tue, 25 Jan 2022 16:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643129683;
        bh=rw+3G6xtiUqoEm6IJINS6kg0qGUDlHZ60ZFR3a2STdw=;
        h=Date:From:To:Cc:Subject:From;
        b=OvIlRzdNs0u3TKQbD+zqONaqes09wji3XfQ/OdhWSiJNI9x4HiJ6+hDJe6TWjcmVo
         Ixl108Kp3dLorankwVLvgTuyHHjX6dv9J418QqD93hLZMvID0odhe0s9dRt45GxE0C
         uf81M+1H3xmwlOxJzOxNz3Dv3/S85GOuNa6vr3Ml0wKRzV8YU7RKvknFgUkLynWLqD
         advRLLvcLI1Bmp8p967m0/NEgWMKyrIyiNfP5SYb68OaYrvOF6Ih8YXhouE22ViX4s
         LsuwuzZX0hr4fX3VQWRkOwRgoKXc+VYn5kkEYZHa5sDjcpm+AqxS6jzFIx5FP3o+nq
         EKQeXrzA/m93Q==
Date:   Tue, 25 Jan 2022 11:01:28 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] mlxsw: spectrum_kvdl: Use struct_size() helper in
 kzalloc()
Message-ID: <20220125170128.GA60918@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version,
in order to avoid any potential type mistakes or integer overflows that,
in the worst scenario, could lead to heap overflows.

Also, address the following sparse warnings:
drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c:229:24: warning: using sizeof on a flexible structure

Link: https://github.com/KSPP/linux/issues/174
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c
index a9fff8adc75e..d20e794e01ca 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c
@@ -213,7 +213,6 @@ mlxsw_sp1_kvdl_part_init(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp1_kvdl_part *part;
 	bool need_update = true;
 	unsigned int nr_entries;
-	size_t usage_size;
 	u64 resource_size;
 	int err;
 
@@ -225,8 +224,8 @@ mlxsw_sp1_kvdl_part_init(struct mlxsw_sp *mlxsw_sp,
 	}
 
 	nr_entries = div_u64(resource_size, info->alloc_size);
-	usage_size = BITS_TO_LONGS(nr_entries) * sizeof(unsigned long);
-	part = kzalloc(sizeof(*part) + usage_size, GFP_KERNEL);
+	part = kzalloc(struct_size(part, usage, BITS_TO_LONGS(nr_entries)),
+		       GFP_KERNEL);
 	if (!part)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.27.0

