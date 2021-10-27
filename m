Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D427B43BFF4
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 04:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238456AbhJ0ChM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 22:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236608AbhJ0ChG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 22:37:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7DC661074;
        Wed, 27 Oct 2021 02:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635302082;
        bh=qwRHl7q++FjZoBqv3qUl2Fg/aVroCjrk2DjjGNmnZ8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLoJFeiVsS00B7D1IUTDeB2xgcCXQPaLcTy5xIonbAn4r6acwTEpuVn0d1KxdMORA
         Q2S0I6Nm/QxZP8I073qJzPQ6N8DlxLZaLDGUe95/DtHSiDOyFMothFdVvEcYu59eQV
         Vu/zTQnSJsfzEu3Q0bcX9+phgSKo2o560h4n4LK9TlZ4oP4eNxiaMwebxj+W15SVKe
         jF0D2MkKK5QLJtLL+NG55+1o5OdNsF5fVFVc6zsvrdofnOVaDflrP9dWT4/GMezUcg
         g3A59KinOUsugjG35SqITiBjdD3IzDz+HtvUjfuCjs95a1RmJxAfJC/aR/aTOmzsi9
         e+S+GQwz2sx+A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Ben Ben-ishay <benishay@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/14] net: Prevent HW-GRO and LRO features operate together
Date:   Tue, 26 Oct 2021 19:33:35 -0700
Message-Id: <20211027023347.699076-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027023347.699076-1-saeed@kernel.org>
References: <20211027023347.699076-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-ishay <benishay@nvidia.com>

LRO and HW-GRO are mutually exclusive, this commit adds this restriction
in netdev_fix_feature. HW-GRO is preferred, that means in case both
HW-GRO and LRO features are requested, LRO is cleared.

Signed-off-by: Ben Ben-ishay <benishay@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 net/core/dev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 4e3d19a06de4..e8754560e641 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9922,6 +9922,11 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 		}
 	}
 
+	if ((features & NETIF_F_GRO_HW) && (features & NETIF_F_LRO)) {
+		netdev_dbg(dev, "Dropping LRO feature since HW-GRO is requested.\n");
+		features &= ~NETIF_F_LRO;
+	}
+
 	if (features & NETIF_F_HW_TLS_TX) {
 		bool ip_csum = (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) ==
 			(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
-- 
2.31.1

