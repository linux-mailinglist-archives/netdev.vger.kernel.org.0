Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF154C206E
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245188AbiBXANB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245179AbiBXAMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:12:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F085F4FF
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:12:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1E2060B53
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5230C340EB;
        Thu, 24 Feb 2022 00:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645661542;
        bh=hKpVr3E/b832SDOsg2UcxdhvGYlwPPk3UCf0eMuIuTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdxO4k6kECwceLpiD4FSwH+dnyCjHaeZNVgq9L4UcNxZMO348yUTEufeh77zg2H9F
         B3o4WcEYrRwDhpVrBGiWjvwqmaotvHLA1PLRn9aQsfgsRyC8C7wZ8CuoZd8hfdVcb3
         /gqO14CWXeg6qKnBviA0ksAaSCGKbqdXr6LrS1BRu+EkFFBJaVU1p+MHn9BTW/qOo1
         NUJXXRjhKZ36Cp61c8CFELaKcJGyi0AW7vAQ/bRMxIUgKBT4pjwI8ShwuxbpJtMUE/
         olTWYyHylcOHLF7lAWns9CtVgc9k3+/vXgDZ+SbNMntU/OsKi6AKspUGU2JM6ONsxZ
         mm9jOGBOzNa0g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 09/19] net/mlx5: Fix possible deadlock on rule deletion
Date:   Wed, 23 Feb 2022 16:11:13 -0800
Message-Id: <20220224001123.365265-10-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224001123.365265-1-saeed@kernel.org>
References: <20220224001123.365265-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Add missing call to up_write_ref_node() which releases the semaphore
in case the FTE doesn't have destinations, such in drop rule case.

Fixes: 465e7baab6d9 ("net/mlx5: Fix deletion of duplicate rules")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index b628917e38e4..537c82b9aa53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2074,6 +2074,8 @@ void mlx5_del_flow_rules(struct mlx5_flow_handle *handle)
 		fte->node.del_hw_func = NULL;
 		up_write_ref_node(&fte->node, false);
 		tree_put_node(&fte->node, false);
+	} else {
+		up_write_ref_node(&fte->node, false);
 	}
 	kfree(handle);
 }
-- 
2.35.1

