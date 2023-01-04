Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6D165CFD5
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 10:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbjADJnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 04:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjADJnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 04:43:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD60AE7A;
        Wed,  4 Jan 2023 01:43:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5869EB811A2;
        Wed,  4 Jan 2023 09:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DE1C433EF;
        Wed,  4 Jan 2023 09:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672825423;
        bh=GFCkxrwWNgg3EDS4bs73kYo8VaU7YWYv528Dyhkwodg=;
        h=From:To:Cc:Subject:Date:From;
        b=cBRdYwaF9rvneXWWpfBfXtC04WI/HLROvyAyCiBqFH9E6SHUI9oVJUnccX4MIYCJQ
         RE7Eea0nyS/BgIkiRGu3cTAmxEESMDcd1jaivPbSP78mAnFh2oowRnuAO8JDDGHEbi
         hgREYjjJ6ivL79VC0TsQLKnuOuE4g1FIVRik5fQ6C3tudtDDGv2IlAOizFxoZU1skD
         eus5Rb+3ImcV0O4WeRE5Dd4KaqexD6UoMxEkBf3REOOIP9yzpYpDfSSh9obuVQREcP
         VfG+nerm/fW1lCD6KzMtArHCVl96S24h12ThhEO3s1GxjsVR8FRc99s7y/Gm5yacZb
         Q745KtNOJCh3w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Patrisious Haddad <phaddad@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH rdma-next v1 0/3] Provide more error details when a QP moves to error state
Date:   Wed,  4 Jan 2023 11:43:33 +0200
Message-Id: <cover.1672821186.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v1: 
 * Reworked mlx4 to allow non-atomic IB QP event handler.
v0: https://lore.kernel.org/linux-rdma/20220907113800.22182-1-phaddad@nvidia.com/

------------------------------------------
The following series adds ability to get information about fatal QP events.

This functionality is extremely useful for the following reasons:
 * Provides an information about the reason why QP moved to error state,
   in cases where CQE isn't generated.
 * Allows to provide vendor specfic error codes and information that
   could be very useful to users who know them.

An example of a case without CQE is a remote write with RKEY violation.
In this flow, on remote side no CQEs are generated and such error without
indication is hard to debug.

Thanks.

Mark Zhang (1):
  RDMA/mlx: Calling qp event handler in workqueue context

Patrisious Haddad (2):
  net/mlx5: Introduce CQE error syndrome
  RDMA/mlx5: Print error syndrome in case of fatal QP errors

 drivers/infiniband/hw/mlx4/main.c       |   8 ++
 drivers/infiniband/hw/mlx4/mlx4_ib.h    |   3 +
 drivers/infiniband/hw/mlx4/qp.c         | 121 +++++++++++------
 drivers/infiniband/hw/mlx5/main.c       |   7 +
 drivers/infiniband/hw/mlx5/qp.c         | 164 ++++++++++++++++++------
 drivers/infiniband/hw/mlx5/qp.h         |   4 +-
 drivers/infiniband/hw/mlx5/qpc.c        |   7 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c |  14 +-
 include/linux/mlx4/qp.h                 |   1 +
 include/linux/mlx5/mlx5_ifc.h           |  47 ++++++-
 include/rdma/ib_verbs.h                 |   2 +-
 11 files changed, 292 insertions(+), 86 deletions(-)

-- 
2.38.1

