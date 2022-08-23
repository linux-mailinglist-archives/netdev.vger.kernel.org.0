Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F7D59D0D5
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240350AbiHWFzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240339AbiHWFzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:55:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3E65F121
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:55:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71CC5B81B79
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0986C433D7;
        Tue, 23 Aug 2022 05:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661234144;
        bh=VJQpiksHOUod6qgWbGSbh2NaUCfKSBZlI1W2DqvbHFk=;
        h=From:To:Cc:Subject:Date:From;
        b=shPkcfVs5XHeoo+qNwcfPmtFG+LykRe/DKkhn0R0UZVqOFmq31VDDrRjCgYSjevtP
         vD1UXLpptLFDl5Kj+VBME/dR3SilCWjQP1xSLJPsea/MxGz1B/n8PEo9xDZFMvbExt
         2d83FEtRFuR1YokZvushvOImtr95fVKFZwsj7ZLJ2AlMAbKvtkLYWyoMIX7/3a8epi
         OIbLaSKL3isrWRGOCN6YhK+biqp2g4qSmIfG3bBelySLJ+toe3cpcSHQDTKMUOAGvP
         y1fIzZr+cQNBv6X2JUyJENFU+lDsu49kuRMri/TdW+Ej8KD/qwo7mGaCfsPDAZQp9M
         fyHe3BX4sGP5w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2022-08-22
Date:   Mon, 22 Aug 2022 22:55:18 -0700
Message-Id: <20220823055533.334471-1-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
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

From: Saeed Mahameed <saeedm@nvidia.com>

This series adds two updates to mlx5 driver:

Roi Dayan adds the support for tunnel offloads for SFs.
Lama continues to decouple mlx5 auxiliary sub-modules from the main
mlx5_priv (the netdev private data).
 
For more information please see tag log below.

Please pull and let me know if there is any problem.

Merge conflict:
When merged with latest mlx5 net PR [1], the following conflict will pop-up:

++<<<<<<< HEAD
 +err_free_tc:
 +      mlx5e_fs_tc_free(fs);
 +err_free_fs:
 +      kvfree(fs);
++||||||| 4c2d0b039c5c
++err_free_fs:
++      kvfree(fs);
++=======
+ 
++>>>>>>> submit/net-mlx5
  err_free_vlan:
        mlx5e_fs_vlan_free(fs);
+ err_free_fs:
+       kvfree(fs);


To resolve simply use this hunk:

err_free_tc:                                                                  
      mlx5e_fs_tc_free(fs);                                                   
err_free_vlan:                                                                
        mlx5e_fs_vlan_free(fs);                                                 
err_free_fs:                                                                  
       kvfree(fs);             

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20220822195917.216025-1-saeed@kernel.org/

Thanks,
Saeed.


The following changes since commit 97d29b9231c73d8c2c1c5b6add6d1f679bb579f9:

  Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2022-08-22 20:24:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-08-22

for you to fetch changes up to 72e0bcd1563602168391ea52157bdd82e6d7875a:

  net/mlx5: TC, Add support for SF tunnel offload (2022-08-22 22:44:26 -0700)

----------------------------------------------------------------
mlx5-updates-2022-08-22

Roi Dayan Says:
===============
Add support for SF tunnel offload

Mlx5 driver only supports VF tunnel offload.
To add support for SF tunnel offload the driver needs to:
1. Add send-to-vport metadata matching rules like done for VFs.
2. Set an indirect table for SF vport, same as VF vport.

info smaller sub functions for better maintainability.

rules from esw init phase to representor load phase.
SFs could be created after esw initialized and thus the send-to-vport
meta rules would not be created for those SFs.
By moving the creation of the rules to representor load phase
we ensure creating the rules also for SFs created later.

===============

Lama Kayal Says:
================
Make flow steering API loosely coupled from mlx5e_priv, in a manner to
introduce more readable and maintainable modules.

Make TC's private, let mlx5e_flow_steering struct be dynamically allocated,
and introduce its API to maintain the code via setters and getters
instead of publicly exposing it.

Introduce flow steering debug macros to provide an elegant finish to the
decoupled flow steering API, where errors related to flow steering shall
be reported via them.

All flow steering related files will drop any coupling to mlx5e_priv,
instead they will get the relevant members as input. Among these,
fs_tt_redirect, fs_tc, and arfs.
================

----------------------------------------------------------------
Jianbo Liu (1):
      net/mlx5: E-Switch, Add default drop rule for unmatched packets

Lama Kayal (11):
      net/mlx5e: Introduce flow steering API
      net/mlx5e: Decouple fs_tt_redirect from en.h
      net/mlx5e: Decouple fs_tcp from en.h
      net/mlx5e: Drop priv argument of ptp function in en_fs
      net/mlx5e: Convert ethtool_steering member of flow_steering struct to pointer
      net/mlx5e: Directly get flow_steering struct as input when init/cleanup ethtool steering
      net/mlx5e: Separate ethtool_steering from fs.h and make private
      net/mlx5e: Introduce flow steering debug macros
      net/mlx5e: Make flow steering arfs independent of priv
      net/mlx5e: Make all ttc functions of en_fs get fs struct as argument
      net/mlx5e: Completely eliminate priv from fs.h

Roi Dayan (3):
      net/mlx5: E-Switch, Split creating fdb tables into smaller chunks
      net/mlx5: E-Switch, Move send to vport meta rule creation
      net/mlx5: TC, Add support for SF tunnel offload

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   5 -
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    | 158 +++----
 .../ethernet/mellanox/mlx5/core/en/fs_ethtool.h    |  29 ++
 .../mellanox/mlx5/core/en/fs_tt_redirect.c         | 188 ++++----
 .../mellanox/mlx5/core/en/fs_tt_redirect.h         |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |  44 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |   6 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/goto.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  |   8 +-
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  | 111 ++---
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h  |  14 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  15 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |   8 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  | 141 +++---
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    | 436 ++++++++++++------
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |  76 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  42 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  77 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  85 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   1 +
 .../ethernet/mellanox/mlx5/core/esw/indir_table.c  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   7 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 495 +++++++++++++--------
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |   1 +
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  25 +-
 29 files changed, 1246 insertions(+), 765 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/fs_ethtool.h
