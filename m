Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EC74917C9
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347793AbiARCm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:42:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43148 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345420AbiARCbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:31:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02B93B81235;
        Tue, 18 Jan 2022 02:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD5BC36AEF;
        Tue, 18 Jan 2022 02:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473090;
        bh=Py0Utb8K/TKDOXRe9hLUxo0KxcgvtJEQobvTI9y/7YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qj9sjjVUy40lF4WQnU42Zlk5r8pGZ2Inhv9MYPYkxX+FCSPbkDwwNrY7abLOgsEHx
         ISkoI6HdPCsgEVPMCOwYFVFYAyXw0/s5WDcIP5i2kbkbZ/mx2rrylqqZGi+NpmFHEE
         5KLYI3FfpyynKTt6TcNZrS56BoNtvwJlZqDPsvJJpkH+vn5CXh3jd/C0r0jTV30eXJ
         k+9izOHYF9MeP1iqJ7zwdW3MdwFvqSQ4UmJV01eTJl7RKyy6q8sAEPDwS/EqSCeXMl
         INNq0ESHrgkoYUiVyIE8yHrGF4Y5ROtC3I+AQvwYbVIQ/zJWU+B4MR80IJTz/PhVhb
         8Bp1cvdzHnH+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, parav@nvidia.com, mbloch@nvidia.com,
        dlinkin@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 210/217] net/mlx5e: Unblock setting vid 0 for VF in case PF isn't eswitch manager
Date:   Mon, 17 Jan 2022 21:19:33 -0500
Message-Id: <20220118021940.1942199-210-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 7846665d3504812acaebf920d1141851379a7f37 ]

When using libvirt to passthrough VF to VM it will always set the VF vlan
to 0 even if user didn’t request it, this will cause libvirt to fail to
boot in case the PF isn't eswitch owner.

Example of such case is the DPU host PF which isn't eswitch manager, so
any attempt to passthrough VF of it using libvirt will fail.

Fix it by not returning error in case set VF vlan is called with vid 0.

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
index df277a6cddc0b..0c4c743ca31e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
@@ -431,7 +431,7 @@ int mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 	int err = 0;
 
 	if (!mlx5_esw_allowed(esw))
-		return -EPERM;
+		return vlan ? -EPERM : 0;
 
 	if (vlan || qos)
 		set_flags = SET_VLAN_STRIP | SET_VLAN_INSERT;
-- 
2.34.1

