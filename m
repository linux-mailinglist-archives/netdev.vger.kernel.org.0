Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533C46E2C52
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjDNWKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjDNWJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:09:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70BC448B
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:09:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A57E464A8E
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBECC433EF;
        Fri, 14 Apr 2023 22:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510188;
        bh=+fFh6WmnFp388iNv3NwqAdQnBav0YfVbkrZoUhTA9gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCaDs/43BS7KI2zxqxKkZ4U+Ty4o58mXs0S4ZyWddpxjhgdE+B8+HF1rDat+FGVf8
         G6WeR3e3J5kqeoGJWMrHCIAhHzPTe8346Z4hDSBUPFyWsQB24vhgRVm198U2yarMzz
         NCmcrchRz/VPFI/1V2Qw3z2BDkkYY/Ic1W8ZIIbx+bjxOMb2mQLFe7KSewNwju4vig
         POUacN5KsTIkjuX9QHbjDvrYu3v6AptzRC7BuZkakyNc1nt/Bs01DUjGdMzMVShJOc
         ZG7vIxhMA7jOdL72ok9Kht3MmP8QWGFh+jU6h6TYo87MRsfXXwHakJijbbAFleUtfV
         YzOhTHznI1nLg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 08/15] net/mlx5: DR, Fix QP continuous allocation
Date:   Fri, 14 Apr 2023 15:09:32 -0700
Message-Id: <20230414220939.136865-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414220939.136865-1-saeed@kernel.org>
References: <20230414220939.136865-1-saeed@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When allocating a QP we allocate an RQ and an SQ, the RQ is stored first
in memory and followed by the SQ.
This allocation is not physically continiuos - it may span across different
physical pages. SW Steering code always writes in pairs: 1BB write + 1BB read,
or 2 continuous BBs of GTA WQE.

This lead to an issue where RQ allocation was 4x16 which is equal to 1 WQE BB,
causing 1 BB offset in the page and splitting the GTA WQE between different
physical pages.

The solution was to create the RQ with a even number of BBs and to have the
RQ aligned to a page.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index d052d469d4df..4a5ae86e2b62 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -267,7 +267,7 @@ static struct mlx5dr_qp *dr_create_rc_qp(struct mlx5_core_dev *mdev,
 
 	dr_qp->rq.pc = 0;
 	dr_qp->rq.cc = 0;
-	dr_qp->rq.wqe_cnt = 4;
+	dr_qp->rq.wqe_cnt = 256;
 	dr_qp->sq.pc = 0;
 	dr_qp->sq.cc = 0;
 	dr_qp->sq.head = 0;
-- 
2.39.2

