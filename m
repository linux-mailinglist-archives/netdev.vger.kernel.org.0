Return-Path: <netdev+bounces-3986-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B1F1709EB0
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 20:00:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5362D1C21353
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 18:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA2614AA0;
	Fri, 19 May 2023 17:56:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1722EDDCA
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93AFC433D2;
	Fri, 19 May 2023 17:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684518981;
	bh=BKu3hvVUUGTBikOIRfCM+g9EJD4pBYaEXJjME39YNwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWF4RHNF3O8CX9tMnj4qQG3Le04JmpT8fUtmHq3hSi72O7AI7o6wK5UEpViDZ8yax
	 wNJi84bC3YcQTCxzmq9UWZU8FC7XDPydc6w/KF0JiTtt8Qe3j2dQ7VPEfZL/6RMloz
	 HaX9gnEYfyrFHra+zZagI8yYGDMtaSedoSwVKJCdo9q3xjkbmB7m05l6EKdkFvss4m
	 S0ko4OlqN4e2H/P++mpAQGGFaQWIVHmF8NMxIHq5TJQnBH0iMa0Eimi8DByFw4Dg7i
	 HP4Nhmmi6DBx0OmbXurR1DyzQt5iSn+NUXeYbkHrcKLzlCTfcOZQY9o9eAZ+LnI79z
	 EQwxjF4NJNmpw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>
Subject: [net-next 14/15] net/mlx5: devlink, Only show PF related devlink warning when needed
Date: Fri, 19 May 2023 10:55:56 -0700
Message-Id: <20230519175557.15683-15-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230519175557.15683-1-saeed@kernel.org>
References: <20230519175557.15683-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Roi Dayan <roid@nvidia.com>

Limit the PF related warning to show if device is actually a PF.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 0e07971e024a..bfaec67abf0d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -162,9 +162,8 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 		return -EOPNOTSUPP;
 	}
 
-	if (pci_num_vf(pdev)) {
+	if (mlx5_core_is_pf(dev) && pci_num_vf(pdev))
 		NL_SET_ERR_MSG_MOD(extack, "reload while VFs are present is unfavorable");
-	}
 
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
-- 
2.40.1


