Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B656C4D9443
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 07:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245413AbiCOGB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 02:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239667AbiCOGB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 02:01:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCB247386
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 23:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 277A9612C9
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 06:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E334C340E8;
        Tue, 15 Mar 2022 06:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647324015;
        bh=5Kkpg0El5XSx/SNlgT9m+T+s7Puwid+e+RR7VVYslW4=;
        h=From:To:Cc:Subject:Date:From;
        b=EXfHFTzctjcLCNzj0fc1bKKWYtSQDmFMqvOF5ixN/tRe9+eVJkPlW0103k3Xtly8g
         m1bA9zxOw+L3cmHQBAxLLqmbi5vxZ0Mao8Kx0jGVfadWPMGlBjY86a7e47F7KBdUBF
         hnnEjNxmA6u2SSirDkCzI5y56UFagIMLqrkJlOSTLNYZl/x2hUQ8G5QdGat//Rsbb3
         PWN6QF/Wq2/R8Mnkm/TqYdQdjKH0gWe8X9DamZKoAVDY+ik0O1kb+ZhQFo78KRpQgB
         pstMmaflRFM6KrZw3Mw/qfL94KNB+GpAe0EjOO4ReA3QkOByQikXPppW92I8ToubJC
         TJwR4R6FuoqOw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, idosch@nvidia.com,
        petrm@nvidia.com, simon.horman@corigine.com,
        louis.peens@corigine.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/6] devlink: expose instance locking and simplify port splitting
Date:   Mon, 14 Mar 2022 23:00:03 -0700
Message-Id: <20220315060009.1028519-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series puts the devlink ports fully under the devlink instance
lock's protection. As discussed in the past it implements my preferred
solution of exposing the instance lock to the drivers. This way drivers
which want to support port splitting can lock the devlink instance
themselves on the probe path, and we can take that lock in the core
on the split/unsplit paths.

nfp and mlxsw are converted, with slightly deeper changes done in
nfp since I'm more familiar with that driver.

Now that the devlink port is protected we can pass a pointer to
the drivers, instead of passing a port index and forcing the drivers
to do their own lookups. Both nfp and mlxsw can container_of() to
their own structures.

v1:
 - redo the lockdep check (patch 1)
 - add a small section to the docs (patch 1)
 - build fix (patch 2)
 - keeping the devl_ prefix :X

Jakub Kicinski (6):
  devlink: expose instance locking and add locked port registering
  eth: nfp: wrap locking assertions in helpers
  eth: nfp: replace driver's "pf" lock with devlink instance lock
  eth: mlxsw: switch to explicit locking for port registration
  devlink: hold the instance lock in port_split / port_unsplit callbacks
  devlink: pass devlink_port to port_split / port_unsplit callbacks

 Documentation/networking/devlink/index.rst    |  16 ++
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  36 ++---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |   6 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   7 +
 .../net/ethernet/netronome/nfp/flower/main.c  |   4 +-
 drivers/net/ethernet/netronome/nfp/nfp_app.c  |   2 +-
 drivers/net/ethernet/netronome/nfp/nfp_app.h  |  12 +-
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  55 +++----
 drivers/net/ethernet/netronome/nfp/nfp_main.c |  19 +--
 drivers/net/ethernet/netronome/nfp/nfp_main.h |   6 +-
 .../net/ethernet/netronome/nfp/nfp_net_main.c |  34 +++--
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |   4 +-
 drivers/net/ethernet/netronome/nfp/nfp_port.c |  17 ---
 drivers/net/ethernet/netronome/nfp/nfp_port.h |   2 -
 include/net/devlink.h                         |  15 +-
 net/core/devlink.c                            | 144 ++++++++++--------
 16 files changed, 208 insertions(+), 171 deletions(-)

-- 
2.34.1

