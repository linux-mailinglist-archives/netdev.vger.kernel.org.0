Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E06464741
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346971AbhLAGk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346956AbhLAGks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:40:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C672C061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 22:37:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CE6A8CE1D6F
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 06:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A471C53FD5;
        Wed,  1 Dec 2021 06:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638340645;
        bh=R8IT/wwuU0ZrP3IW16IKOHhfWge+khlPZbjJMUL/FY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExJzLM7xZE7dQpNJwH89aU/qHKfDKhJp3GVb0RcGq0Mpwk04dHfpy9DGt6SSirCxA
         smngeKmJ41BXhyxoIrZ24hVCnxgQWVCkkdKkIUYXpQKZKSGgPetT9CiWs8NsK6BZEc
         BDMJhIpAV3qU9szDdrSOt8mNHbGBX2Vbg4/vSSBt3Y4pz+GEEY2L3fBxUWvjw1oDW4
         94VjiB1eNyjfjYovvxyJX8dXJg/fiyrwNKWgsF0FxCvlVWhYSeHej7lJEGaCB0dpLF
         WW5sAluN3/PACTp0sA64ebQTPpFHxWSWdXsO60VJdeopnDojQChwbnnOOuACrxmVJq
         YEdxx6acgEAxA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 08/13] net/mlx5: E-Switch, Check group pointer before reading bw_share value
Date:   Tue, 30 Nov 2021 22:37:04 -0800
Message-Id: <20211201063709.229103-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201063709.229103-1-saeed@kernel.org>
References: <20211201063709.229103-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

If log_esw_max_sched_depth is not supported group pointer of the vport
is NULL. Hence, check the pointer before reading bw_share value.

Fixes: 0fe132eac38c ("net/mlx5: E-switch, Allow to add vports to rate groups")
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 4501e3d737f8..d377ddc70fc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -130,7 +130,7 @@ static u32 esw_qos_calculate_min_rate_divider(struct mlx5_eswitch *esw,
 	/* If vports min rate divider is 0 but their group has bw_share configured, then
 	 * need to set bw_share for vports to minimal value.
 	 */
-	if (!group_level && !max_guarantee && group->bw_share)
+	if (!group_level && !max_guarantee && group && group->bw_share)
 		return 1;
 	return 0;
 }
-- 
2.31.1

