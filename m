Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4C652B2A5
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbiERGtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbiERGtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:49:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06892228D
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:49:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98508B81E97
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B581C385A5;
        Wed, 18 May 2022 06:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856584;
        bh=j2TZ/FUdAdgV4v6NYC7dpJG/44iyva1F0aeVkiSi7dQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIHjXOfS4B2Hfd/XQCIvLcoMmDF+mCCYCXKqUKm3P0+mcALIoSszLeO7XO6d1FCI9
         hYaHlSq1rD+0pZrGeIcI2cg1LRRAFHolepV4C81/ySjHEWsYDb8QdJA1ohi2vu9XtQ
         fBqaH9EoHlZ53CttTaYrzFU+/UlkTB9BTriqXgenQ4hjh8a2P7zvNeJofca34URb51
         dXl3lL7tgkzHIhKlPsUe5xTuSuZjpd4OYJaUK3mWZ27l3v8dSo81Oaktqs6/zgxE1c
         3FlqlNh5qA08JWmkVbsPtWlyR6ExhZu99FMt2KPvvYrVkOEQgqqrNsCrkJCio9TMhm
         RW5VtJPa5/yPQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/16] net/mlx5: sparse: error: context imbalance in 'mlx5_vf_get_core_dev'
Date:   Tue, 17 May 2022 23:49:23 -0700
Message-Id: <20220518064938.128220-2-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518064938.128220-1-saeed@kernel.org>
References: <20220518064938.128220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Removing the annotation resolves the issue for some reason.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 84f75aa25214..87f1552b5d73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1886,7 +1886,6 @@ static struct pci_driver mlx5_core_driver = {
  * Return: Pointer to the associated mlx5_core_dev or NULL.
  */
 struct mlx5_core_dev *mlx5_vf_get_core_dev(struct pci_dev *pdev)
-			__acquires(&mdev->intf_state_mutex)
 {
 	struct mlx5_core_dev *mdev;
 
@@ -1912,7 +1911,6 @@ EXPORT_SYMBOL(mlx5_vf_get_core_dev);
  * access the mdev any more.
  */
 void mlx5_vf_put_core_dev(struct mlx5_core_dev *mdev)
-			__releases(&mdev->intf_state_mutex)
 {
 	mutex_unlock(&mdev->intf_state_mutex);
 }
-- 
2.36.1

