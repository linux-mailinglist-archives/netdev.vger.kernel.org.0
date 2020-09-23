Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4537276429
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgIWWtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:49:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgIWWso (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 18:48:44 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BD6E235FC;
        Wed, 23 Sep 2020 22:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600901323;
        bh=LAlsvS8AiwsAi1Q6EauqbCeorgbdfmpWcu/Ay3tw8k4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b7sCMqE0JDXGsc69AWSN4fiDg/4J4/ZBaKCRpgdqtfp8AzgzbcxFzhROZfd6uiUzV
         xdXi/x6kzp3p6q8O+gFnduKcKb5jzI7JbQA7Q9GpZFlo6CvmAhQPktStfrXQ7CREu4
         +bTaCpAUxQ4NZqrfdN8Kxh/Gh4WUYdl1dJDUUbTc=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 12/15] net/mlx5e: IPsec: Use kvfree() for memory allocated with kvzalloc()
Date:   Wed, 23 Sep 2020 15:48:21 -0700
Message-Id: <20200923224824.67340-13-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923224824.67340-1-saeed@kernel.org>
References: <20200923224824.67340-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

Variables flow_group_in, spec in rx_fs_create() are allocated with
kvzalloc(). It's incorrect to free them with kfree(). Use kvfree()
instead.

Fixes: 5e466345291a ("net/mlx5e: IPsec: Add IPsec steering in local NIC RX")
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 429428bbc903..b974f3cd1005 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -228,8 +228,8 @@ static int rx_fs_create(struct mlx5e_priv *priv,
 	fs_prot->miss_rule = miss_rule;
 
 out:
-	kfree(flow_group_in);
-	kfree(spec);
+	kvfree(flow_group_in);
+	kvfree(spec);
 	return err;
 }
 
-- 
2.26.2

