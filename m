Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 987DE178950
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 04:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgCDD4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 22:56:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727737AbgCDD4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 22:56:07 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87F6A20842;
        Wed,  4 Mar 2020 03:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583294166;
        bh=c4RNzaRkvk9Pwt8U6jIvnLLV7Jcy1KxMqbEmXF9LTRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2U3FDmnGYxg4y/4idzg+i+lN//QmDH/+mt/eq6MnfZw0+Jbvu0u+tn+ly5JofRgb
         pU4WHIKInAvuPMoz883Xl5pKOdluHI1uqn9tfzlBXMXnQtb301kgiyK4iUrFs4wSFP
         TOZAKGno2aXuLNAw9nWJIRlrOojR3LGFcS72trtA=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 10/12] mlx5: reject unsupported coalescing params
Date:   Tue,  3 Mar 2020 19:54:59 -0800
Message-Id: <20200304035501.628139-11-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304035501.628139-1-kuba@kernel.org>
References: <20200304035501.628139-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->coalesce_types to let the core reject
unsupported coalescing parameters.

This driver did not previously reject unsupported parameters.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c    | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c        | 6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c | 3 +++
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 06f6f08ff5eb..739a0771944a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1965,6 +1965,9 @@ static int mlx5e_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 }
 
 const struct ethtool_ops mlx5e_ethtool_ops = {
+	.coalesce_types = ETHTOOL_COALESCE_USECS |
+			  ETHTOOL_COALESCE_MAX_FRAMES |
+			  ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_drvinfo       = mlx5e_get_drvinfo,
 	.get_link          = ethtool_op_get_link,
 	.get_strings       = mlx5e_get_strings,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 1a8897f80547..abb8071e58c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -376,6 +376,9 @@ static int mlx5e_uplink_rep_set_link_ksettings(struct net_device *netdev,
 }
 
 static const struct ethtool_ops mlx5e_rep_ethtool_ops = {
+	.coalesce_types = ETHTOOL_COALESCE_USECS |
+			  ETHTOOL_COALESCE_MAX_FRAMES |
+			  ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_drvinfo	   = mlx5e_rep_get_drvinfo,
 	.get_link	   = ethtool_op_get_link,
 	.get_strings       = mlx5e_rep_get_strings,
@@ -392,6 +395,9 @@ static const struct ethtool_ops mlx5e_rep_ethtool_ops = {
 };
 
 static const struct ethtool_ops mlx5e_uplink_rep_ethtool_ops = {
+	.coalesce_types = ETHTOOL_COALESCE_USECS |
+			  ETHTOOL_COALESCE_MAX_FRAMES |
+			  ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_drvinfo	   = mlx5e_uplink_rep_get_drvinfo,
 	.get_link	   = ethtool_op_get_link,
 	.get_strings       = mlx5e_rep_get_strings,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index 90cb50fe17fd..0deeed70f128 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -235,6 +235,9 @@ static int mlx5i_get_link_ksettings(struct net_device *netdev,
 }
 
 const struct ethtool_ops mlx5i_ethtool_ops = {
+	.coalesce_types = ETHTOOL_COALESCE_USECS |
+			  ETHTOOL_COALESCE_MAX_FRAMES |
+			  ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_drvinfo        = mlx5i_get_drvinfo,
 	.get_strings        = mlx5i_get_strings,
 	.get_sset_count     = mlx5i_get_sset_count,
-- 
2.24.1

