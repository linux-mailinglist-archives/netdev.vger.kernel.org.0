Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192336B8DF1
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjCNI65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjCNI64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:58:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB491BC2
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 01:58:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDA3FB818B6
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D386CC433EF;
        Tue, 14 Mar 2023 08:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678784332;
        bh=EMJRiPOQPuLovutY7q0QnHuHG4EoUApQqR33gbi/SjQ=;
        h=From:To:Cc:Subject:Date:From;
        b=DC0/UP09/Hmw9g0OKa1NbpyeAWbd7u9lcWENZjzd/OtUuOpLAJInDKZm1/+jlB1gm
         1XS3frJFI47aN122SO6uvzCK7cNSlpToZNGgrMopQA+n/3yFUMDJBLHM3sCSryxfLn
         GwDpYqRK+1bB/lYQv+/K1U3CAs3u/Jlqe0uEYPFb1nZaycqtJ+Ea5o36R5CPQAbjZG
         cRVUUtW4J5tn8CT6XSA/kTUmL5MiCZCrfxCiWXLx6AWQ8USFKdTJiwSdfkLrjYLMWG
         iHRFgHn401g8X7G7Wz3SpSybyRpF1e/fUKAx8SoczXzqTmTjPY74m87IT6yc3GKtpc
         w9d5IKUofmHqQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 0/9] Extend packet offload to fully support libreswan
Date:   Tue, 14 Mar 2023 10:58:35 +0200
Message-Id: <cover.1678714336.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi Steffen,

The following patches are an outcome of Raed's work to add packet
offload support to libreswan [1].

The series includes:
 * Priority support to IPsec policies
 * Statistics per-SA (visible through "ip -s xfrm state ..." command)
 * Support to IKE policy holes
 * Fine tuning to acquire logic.

--------------------------
Future submission roadmap, which can be seen here [2]:
 * Support packet offload in IPsec tunnel mode
 * Rework lifetime counters support to avoid HW bugs/limitations
 * Some general cleanup.

So how do you want me to route the patches, as they have a dependency between them?
xfrm-next/net-next/mlx5-next?

Thanks

[1] https://github.com/libreswan/libreswan/pull/986q
[2] https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=xfrm-next

Paul Blakey (3):
  net/mlx5: fs_chains: Refactor to detach chains from tc usage
  net/mlx5: fs_core: Allow ignore_flow_level on TX dest
  net/mlx5e: Use chains for IPsec policy priority offload

Raed Salem (6):
  xfrm: add new device offload acquire flag
  xfrm: copy_to_user_state fetch offloaded SA packets/bytes statistics
  net/mlx5e: Allow policies with reqid 0, to support IKE policy holes
  net/mlx5e: Support IPsec acquire default SA
  net/mlx5e: Use one rule to count all IPsec Tx offloaded traffic
  net/mlx5e: Update IPsec per SA packets/bytes count

 .../mellanox/mlx5/core/en_accel/ipsec.c       |  71 ++-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  13 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 528 ++++++++++++++----
 .../mlx5/core/en_accel/ipsec_offload.c        |  32 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  20 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |   6 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   5 +-
 .../mellanox/mlx5/core/lib/fs_chains.c        |  89 ++-
 .../mellanox/mlx5/core/lib/fs_chains.h        |   9 +-
 include/net/xfrm.h                            |   5 +
 net/xfrm/xfrm_state.c                         |   1 +
 net/xfrm/xfrm_user.c                          |   2 +
 12 files changed, 553 insertions(+), 228 deletions(-)

-- 
2.39.2

