Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40EE66039E1
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiJSGjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiJSGjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:39:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4306EF2F
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:38:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC0556177E
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252DCC433D6;
        Wed, 19 Oct 2022 06:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666161525;
        bh=VR4cjo8PYzxLQmHP5P3rcBhN9h1bGFNLccU9pIbzqrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gi67VVQDEL0Fr5w7t+4yspjTq65dk3qA90MHfmBTWCfkUozDeWO7hPO+Fe7lp199p
         z4WskF4sGkry7muTN9iZbGeg14jeuSlnjjZZZBYqUePJPz5uOoQxLWeuicogaZWvqV
         Fzlx5EDaiRfk3HRQdS+W6WkTRehR4xeygnnKG//s0gK8ZI0JulKz+dZNidl35q0OYW
         YPg0H5tog33ZP3aQeNW7d/u0m38k+7Jwr8U0H5gjmz+rp0mAo+jj9DN8YPT4wainhY
         bGtfl5R7940lJyMVY3VDBQBabK9WPRNJSKpEnLo0vmq+x3emvUhCWiR58vTMx5JyCD
         G8DupCkOo6sRQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Roy Novich <royno@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [net 11/16] net/mlx5: Update fw fatal reporter state on PCI handlers successful recover
Date:   Tue, 18 Oct 2022 23:38:08 -0700
Message-Id: <20221019063813.802772-12-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221019063813.802772-1-saeed@kernel.org>
References: <20221019063813.802772-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roy Novich <royno@nvidia.com>

Update devlink health fw fatal reporter state to "healthy" is needed by
strictly calling devlink_health_reporter_state_update() after recovery
was done by PCI error handler. This is needed when fw_fatal reporter was
triggered due to PCI error. Poll health is called and set reporter state
to error. Health recovery failed (since EEH didn't re-enable the PCI).
PCI handlers keep on recover flow and succeed later without devlink
acknowledgment. Fix this by adding devlink state update at the end of
the PCI handler recovery process.

Fixes: 6181e5cb752e ("devlink: add support for reporter recovery completion")
Signed-off-by: Roy Novich <royno@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 0b459d841c3a..283c4cc28944 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1872,6 +1872,10 @@ static void mlx5_pci_resume(struct pci_dev *pdev)
 
 	err = mlx5_load_one(dev, false);
 
+	if (!err)
+		devlink_health_reporter_state_update(dev->priv.health.fw_fatal_reporter,
+						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+
 	mlx5_pci_trace(dev, "Done, err = %d, device %s\n", err,
 		       !err ? "recovered" : "Failed");
 }
-- 
2.37.3

