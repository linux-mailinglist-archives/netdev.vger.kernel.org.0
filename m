Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57B3275160
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 08:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgIWGYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 02:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbgIWGYq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 02:24:46 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B0D323787;
        Wed, 23 Sep 2020 06:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600842285;
        bh=LAlsvS8AiwsAi1Q6EauqbCeorgbdfmpWcu/Ay3tw8k4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifZ64UmlJzEvKxgpe45GqgfZ7ML5KSiigrffElLfWnt2PC4Igrtfw/2Su3ajCvZ4q
         9KXPApTQUlJbeAebBIFfj5K4JYO5rf+IwAIVpS3U+ygULb74o2MHiyf9PZFC2zhtcW
         rrly5coz+n4TMVT0EH3Pv0e5y4G5/uVUycD2hSD4=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5e: IPsec: Use kvfree() for memory allocated with kvzalloc()
Date:   Tue, 22 Sep 2020 23:24:35 -0700
Message-Id: <20200923062438.15997-13-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923062438.15997-1-saeed@kernel.org>
References: <20200923062438.15997-1-saeed@kernel.org>
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

