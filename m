Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC91A6D9053
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbjDFHTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235269AbjDFHT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:19:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA8D6585
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 00:19:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD20063F6C
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 07:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88600C433D2;
        Thu,  6 Apr 2023 07:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680765567;
        bh=BjtVcRTqbTmBqy8HavXKSrLq62KIOXeLV/pxjwl3nDM=;
        h=From:To:Cc:Subject:Date:From;
        b=Iiem3S/rRIbv12qEE45Aen5ClbMoFuEqITqC+3SqjCanMmcBM3fKYjRivjnfWOKBZ
         7V2agrooD7pV28IxBkNN7J719wvFWB17+VzucsGV3Hk2FJavtmOWsoUS5WDSZHi8TO
         sDxfsajvybpjeEbGHZ6BWm6NqYQHRfv2fHI/dIgMKwubgUZGo/1FMhnOUph3gWLsR5
         Wme5D34OcnqQHTPL0WGJH0erijB4ncHrV7l3tIlhmNjNRE/CMRruwMOg9sx/eNkOtr
         JslMqbRlRuitwc6fdH7h40xUp9SiiClKXPDFLZ+qBO7egY1b3EukXw2kE4dQgrjdPd
         fc8ZnifhUybPA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [GIT PULL v1] Improve IPsec limits, ESN and replay window
Date:   Thu,  6 Apr 2023 10:19:02 +0300
Message-Id: <20230406071902.712388-1-leon@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series overcomes existing hardware limitations in Mellanox ConnectX
devices around handling IPsec soft and hard limits.

In addition, the ESN logic is tied and added an interface to configure
replay window sequence numbers through existing iproute2 interface.

  ip xfrm state ... [ replay-seq SEQ ] [ replay-oseq SEQ ]
                    [ replay-seq-hi SEQ ] [ replay-oseq-hi SEQ ]

Link: https://lore.kernel.org/all/cover.1680162300.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
----------------------------------------------------------------
Changelog:
v1:
 * Added Steffen's Acked-by to XFRM patch
 https://lore.kernel.org/all/ZC1Prk8HqIcpedcm@gauss3.secunet.de
 * Fixed memory leak in "net/mlx5e: Generalize IPsec work structs" patch
https://lore.kernel.org/all/285a1550242363de181bab3a07a69296f66ad9a8.1680162300.git.leonro@nvidia.com

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 0916309cf296..9a4c4bc64155 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -707,6 +707,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 release_dwork:
        kfree(sa_entry->dwork);
 release_work:
+       kfree(sa_entry->work->data);
        kfree(sa_entry->work);
 err_xfrm:
        kfree(sa_entry);
@@ -750,6 +751,7 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
        mlx5e_accel_ipsec_fs_del_rule(sa_entry);
        mlx5_ipsec_free_sa_ctx(sa_entry);
        kfree(sa_entry->dwork);
+       kfree(sa_entry->work->data);
        kfree(sa_entry->work);
 sa_entry_free:
        kfree(sa_entry);

v0: https://lore.kernel.org/all/20230403064154.12443-1-leon@kernel.org
----------------------------------------------------------------

The following changes since commit 5a6cddb89b51d99a7702e63829644a5860dd9c41:

  net/mlx5e: Update IPsec per SA packets/bytes count (2023-03-20 11:29:52 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/ tags/ipsec-esn-replay

for you to fetch changes up to b2f7b01d36a9b94fbd7489bd1228025ea7e7a2f4:

  net/mlx5e: Simulate missing IPsec TX limits hardware functionality (2023-04-06 10:12:03 +0300)

----------------------------------------------------------------
Leon Romanovsky (10):
      net/mlx5e: Factor out IPsec ASO update function
      net/mlx5e: Prevent zero IPsec soft/hard limits
      net/mlx5e: Add SW implementation to support IPsec 64 bit soft and hard limits
      net/mlx5e: Overcome slow response for first IPsec ASO WQE
      xfrm: don't require advance ESN callback for packet offload
      net/mlx5e: Remove ESN callbacks if it is not supported
      net/mlx5e: Set IPsec replay sequence numbers
      net/mlx5e: Reduce contention in IPsec workqueue
      net/mlx5e: Generalize IPsec work structs
      net/mlx5e: Simulate missing IPsec TX limits hardware functionality

 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   | 331 ++++++++++++++++++---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |  47 ++-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  31 +-
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    | 198 +++++++++---
 net/xfrm/xfrm_device.c                             |   2 +-
 5 files changed, 498 insertions(+), 111 deletions(-)
