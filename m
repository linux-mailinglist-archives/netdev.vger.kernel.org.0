Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C355695C7
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbiGFXYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbiGFXY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:24:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3FE2BB10
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:24:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFCC7B81F45
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C36C3411C;
        Wed,  6 Jul 2022 23:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149864;
        bh=hqdvnTx8Z0QkoUSHCLTIp7o7oguWIZ+0pHwD4AOnVbY=;
        h=From:To:Cc:Subject:Date:From;
        b=rB4bnoqDQ316nYCjS0B8aEGLACceV9IVq2Hnh4YEOpEf/ZKUD1XM9MtJo4vCqD2PR
         85DZ0KlheeacD41RDNWiEsvBu6q51y0dl98bIaxQQA2TOD4IGGNRWBf/gTlRZJ0I6U
         AYg+m6l58RdEblGfrZNwxm2YIdmxO44Mii7y9byaeljW17txxF2dPZPYrpeRkoC30O
         LFNIOOxp5b972Y/vGCYqnGHTa1G3rTqhZ4Y3DcKlyuKbVhHJDhAjpWQES56PStnAXE
         FFEcv8rTnxsnhuxwXgx7VO7IOFLAKWsUKhSToUQjqzGjQzz0R46X5kU8eeEXMF3uhJ
         z4hbrwbRfVgWg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
Subject: [pull request][net-next 00/15] mlx5 updates 2022-07-06
Date:   Wed,  6 Jul 2022 16:24:06 -0700
Message-Id: <20220706232421.41269-1-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series provides two updates to mlx5:
1) Fix devlink lock in mlx5 devlink eswitch callbacks
2) Pool hw objects to increase KTLs connection rates

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit cd355d0bc60df51266d228c0f69570cdcfa1e6ba:

  Merge branch 'hinic-dev_get_stats-fixes' (2022-07-06 13:09:28 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-07-06

for you to fetch changes up to 7b8e904d60fc01ae8edf46dc142f58f72f3d3780:

  net/mlx5e: kTLS, Dynamically re-size TX recycling pool (2022-07-06 16:20:09 -0700)

----------------------------------------------------------------
mlx5-updates-2022-07-06

Moshe Shemesh Says:
===================
1) Fix devlink lock in mlx5 devlink eswitch callbacks

Following the commit 14e426bf1a4d "devlink: hold the instance lock
during eswitch_mode callbacks" which takes devlink instance lock for all
devlink eswitch callbacks and adds a temporary workaround, this patchset
removes the workaround, replaces devlink API functions by devl_ API
where called from mlx5 driver eswitch callbacks flows and adds devlink
instance lock in other driver's path that leads to these functions.
While moving to devl_ API the patchset removes part of the devlink API
functions which mlx5 was the last one to use and so not used by any
driver now.

The patchset also remove DEVLINK_NL_FLAG_NO_LOCK flag from the callbacks
of port_new/port which are called only from mlx5 driver and the already
locked by the patchset as parallel paths to the eswitch callbacks using
devl_ API functions.

This patchset will be followed by another patchset that will remove
DEVLINK_NL_FLAG_NO_LOCK flag from devlink reload and devlink health
callbacks. Thus we will have all devlink callbacks locked and it will
pave the way to remove devlink mutex.
===================

Tariq Toukan Says:
==================
2) Use TLS TX pool to improve connection rate

To offload encryption operations, the device maintains state and keeps
track of every kTLS device-offloaded connection.  Two HW objects are used
per TX context of a kTLS offloaded connection:
a. Transport interface send (TIS) object, to reach the HW context.
b. Data Encryption Key (DEK) to perform the crypto operations.

These two objects are created and destroyed per TLS TX context, via FW
commands.  In total, 4 FW commands are issued per TLS TX context, which
seriously limits the connection rate.

In this series, we aim to save creation and destroy of TIS objects by
recycling them.  Upon recycling of a TIS, the HW still needs to be
notified for the re-mapping between a TIS and a context. This is done by
posting WQEs via an SQ, significantly faster API than the FW command
interface.

A pool is used for recycling. The pool dynamically interacts to the load
and connection rate, growing and shrinking accordingly.

Saving the TIS FW commands per context increases connection rate by ~42%,
from 11.6K to 16.5K connections per sec.

Connection rate is still limited by FW bottleneck due to the remaining
per context FW commands (DEK create/destroy). This will soon be addressed
in a followup series.  By combining the two series, the FW bottleneck
will be released, and a significantly higher (about 100K connections per
sec) kTLS TX device-offloaded connection rate is reached.
==================

----------------------------------------------------------------
Moshe Shemesh (9):
      net/mlx5: Remove devl_unlock from mlx5_eswtich_mode_callback_enter
      net/mlx5: Use devl_ API for rate nodes destroy
      devlink: Remove unused function devlink_rate_nodes_destroy
      net/mlx5: Use devl_ API in mlx5_esw_offloads_devlink_port_register
      net/mlx5: Use devl_ API in mlx5_esw_devlink_sf_port_register
      devlink: Remove unused functions devlink_rate_leaf_create/destroy
      net/mlx5: Use devl_ API in mlx5e_devlink_port_register
      net/mlx5: Remove devl_unlock from mlx5_devlink_eswitch_mode_set
      devlink: Hold the instance lock in port_new / port_del callbacks

Tariq Toukan (6):
      net/tls: Perform immediate device ctx cleanup when possible
      net/tls: Multi-threaded calls to TX tls_dev_del
      net/mlx5e: kTLS, Introduce TLS-specific create TIS
      net/mlx5e: kTLS, Take stats out of OOO handler
      net/mlx5e: kTLS, Recycle objects of device-offloaded TLS TX connections
      net/mlx5e: kTLS, Dynamically re-size TX recycling pool

 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  29 +-
 .../net/ethernet/mellanox/mlx5/core/en/devlink.c   |  16 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |  10 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |  14 +
 .../mellanox/mlx5/core/en_accel/ktls_stats.c       |   2 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 513 ++++++++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   9 +
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |  20 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  18 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  57 +--
 include/linux/mlx5/driver.h                        |   4 +
 include/net/devlink.h                              |   3 -
 include/net/tls.h                                  |   6 +
 net/core/devlink.c                                 |  66 +--
 net/tls/tls_device.c                               |  56 +--
 15 files changed, 603 insertions(+), 220 deletions(-)
