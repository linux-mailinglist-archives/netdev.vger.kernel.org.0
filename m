Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6E8417B4D
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348198AbhIXSuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346717AbhIXStz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 14:49:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC6A361260;
        Fri, 24 Sep 2021 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632509302;
        bh=zmQRImXug+aMp0HX6fm5FgIAq70Fgi9BnDY2gEr5iMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=caVJFQ/hqJwpBYQvIIvpJNTGXo/bkwa0SY3An8qmYRaEawXghDeApKKDh3vdOm3Wj
         /Iz5hx8XlZFXiXsIq1rqI9t0G1lshVlqcj93XFSocaNYuxooW8ml/axr3fWUw2gGzn
         zsVt6EzJW5rwncYamT3wXrCAnTaTZ6p8Syxm+hygeDK5JcGPK4QaLSiMMVmAQnscZg
         HATQmVh+mW2LB7b/GCQCwRjyBXDuDuCedUgASzr3VsfAiDZrIyyTWFdGFM/IMgx6wC
         iTEr0Zv0NsXXH6eq3zoUFnWeCysChbv1AWNuJ3JqYEMrtsaeu5yUZOpEEtZrfFBVqx
         MSfuYFR7b85XA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/12] net/mlx5e: Enable TC offload for egress MACVLAN
Date:   Fri, 24 Sep 2021 11:48:07 -0700
Message-Id: <20210924184808.796968-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924184808.796968-1-saeed@kernel.org>
References: <20210924184808.796968-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

Support offloading of TC rules that mirror/redirect egress traffic to a
MACVLAN device, which is attached to mlx5 representor net device.

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 07ab02f7b284..0e03cefc5eeb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -39,6 +39,7 @@
 #include <linux/rhashtable.h>
 #include <linux/refcount.h>
 #include <linux/completion.h>
+#include <linux/if_macvlan.h>
 #include <net/tc_act/tc_pedit.h>
 #include <net/tc_act/tc_csum.h>
 #include <net/psample.h>
@@ -3907,6 +3908,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 						return err;
 				}
 
+				if (netif_is_macvlan(out_dev))
+					out_dev = macvlan_dev_real_dev(out_dev);
+
 				err = verify_uplink_forwarding(priv, flow, out_dev, extack);
 				if (err)
 					return err;
-- 
2.31.1

