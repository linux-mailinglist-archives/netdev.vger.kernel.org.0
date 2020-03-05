Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F14A179F0B
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 06:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgCEFQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 00:16:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbgCEFQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 00:16:40 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E36B021741;
        Thu,  5 Mar 2020 05:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583385399;
        bh=suoiLiAlkAiJu8hWGCtC13WsdoF1BXoMBVS6+E+SNKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q73otRvo6Fkb07l6lLb8x30SRH5vT0j1AmVGeETo1IHat5w4FlrtsfYKaHRuP9Pbz
         GnDaqyJlveTlookOf1rCiUmS+AxRbrlPkpZ4gT6EwYhlWOf9ZiQ2F0u2PpwNjAIbT0
         tD7qyuANgy4IN935h1Ch5DOFYV02BqhFNY3RLjBg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, ecree@solarflare.com, mkubecek@suse.cz,
        thomas.lendacky@amd.com, benve@cisco.com, _govind@gmx.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, snelson@pensando.io, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, alexander.h.duyck@linux.intel.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 10/12] mlx5: reject unsupported coalescing params
Date:   Wed,  4 Mar 2020 21:15:40 -0800
Message-Id: <20200305051542.991898-11-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305051542.991898-1-kuba@kernel.org>
References: <20200305051542.991898-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver did not previously reject unsupported parameters.

v3: adjust commit message for new member name

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c    | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c        | 6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c | 3 +++
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 06f6f08ff5eb..01539b874b5e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1965,6 +1965,9 @@ static int mlx5e_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 }
 
 const struct ethtool_ops mlx5e_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_drvinfo       = mlx5e_get_drvinfo,
 	.get_link          = ethtool_op_get_link,
 	.get_strings       = mlx5e_get_strings,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 1a8897f80547..c506143c8559 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -376,6 +376,9 @@ static int mlx5e_uplink_rep_set_link_ksettings(struct net_device *netdev,
 }
 
 static const struct ethtool_ops mlx5e_rep_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_drvinfo	   = mlx5e_rep_get_drvinfo,
 	.get_link	   = ethtool_op_get_link,
 	.get_strings       = mlx5e_rep_get_strings,
@@ -392,6 +395,9 @@ static const struct ethtool_ops mlx5e_rep_ethtool_ops = {
 };
 
 static const struct ethtool_ops mlx5e_uplink_rep_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_drvinfo	   = mlx5e_uplink_rep_get_drvinfo,
 	.get_link	   = ethtool_op_get_link,
 	.get_strings       = mlx5e_rep_get_strings,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index 90cb50fe17fd..1eef66ee849e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -235,6 +235,9 @@ static int mlx5i_get_link_ksettings(struct net_device *netdev,
 }
 
 const struct ethtool_ops mlx5i_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_drvinfo        = mlx5i_get_drvinfo,
 	.get_strings        = mlx5i_get_strings,
 	.get_sset_count     = mlx5i_get_sset_count,
-- 
2.24.1

