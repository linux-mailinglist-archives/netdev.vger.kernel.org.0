Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35F253FF50
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 14:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244172AbiFGMrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 08:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244164AbiFGMry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 08:47:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D607B101C1;
        Tue,  7 Jun 2022 05:47:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A8B8B81F6E;
        Tue,  7 Jun 2022 12:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2617C3411F;
        Tue,  7 Jun 2022 12:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654606071;
        bh=NvuhODq4GKtjVjoVnfnscoVLEkUMXgKJpbwCX235sk8=;
        h=From:To:Cc:Subject:Date:From;
        b=kB/tK727Fege3K1q7uMQeqxt8E1dt+K5k5R2ZbiPVF5fFgCA/w4e09kaoEN2I9bsm
         5fRIZ2GaVoQ2HVxy6xrROPYRNAUsOHvqghqOA210UhSiDnhlhupXgXEbUbgvheaBP0
         BHLxSLcci60dZ9bHTpsU3tmEQ4U0rm6EPGdLAddlBr0tAmwvoEmEmclz/RXlbBZ8P3
         T/kOTkl5X2CBwuiPUUwar4WF4ndtgoSYkeU5sN9duGm67YNeNYynwtiuVWUvG1ZCY+
         AgfjiOGP8wkcDfMgnp6hZuo6XAeS8v8fcCqyLUBUwbZi0+kpiFUX8PMYEWRnJDFdCn
         7ZNkgyJIB19xw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: [PATCH mlx5-next 0/3] Add ICM header-modify-pattern RDMA API
Date:   Tue,  7 Jun 2022 15:47:42 +0300
Message-Id: <cover.1654605768.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

SW steering manipulates packet's header using "modifying header" actions.
Many of these actions do the same operation, but use different data each time.
Currently we create and keep every one of these actions, which use expensive
and limited resources.

Now we introduce a new mechanism - pattern and argument, which splits
a modifying action into two parts:
1. action pattern: contains the operations to be applied on packet's header,
mainly set/add/copy of fields in the packet
2. action data/argument: contains the data to be used by each operation
in the pattern.

This way we reuse same patterns with different arguments to create new
modifying actions, and since many actions share the same operations, we end
up creating a small number of patterns that we keep in a dedicated cache.

These modify header patterns are implemented as new type of ICM memory,
so the following kernel patch series add the support for this new ICM type.

Thanks

Yevgeny Kliteynik (3):
  net/mlx5: Introduce header-modify-pattern ICM properties
  net/mlx5: Manage ICM of type modify-header pattern
  RDMA/mlx5: Support handling of modify-header pattern ICM area

 drivers/infiniband/hw/mlx5/dm.c               | 53 ++++++++++++-------
 drivers/infiniband/hw/mlx5/mr.c               |  1 +
 .../net/ethernet/mellanox/mlx5/core/lib/dm.c  | 42 +++++++++++++++
 include/linux/mlx5/driver.h                   |  1 +
 include/linux/mlx5/mlx5_ifc.h                 |  7 ++-
 include/uapi/rdma/mlx5_user_ioctl_verbs.h     |  1 +
 6 files changed, 85 insertions(+), 20 deletions(-)

-- 
2.36.1

