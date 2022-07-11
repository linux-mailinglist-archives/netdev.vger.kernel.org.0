Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B159656D77E
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiGKIOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiGKIOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:14:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516C813F46
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:14:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CCE7B80D2C
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 08:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F68FC34115;
        Mon, 11 Jul 2022 08:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657527253;
        bh=veVitC+VW/fIgZQ2FgbmCXV3hG+bd6P7IEVhvA/0qtg=;
        h=From:To:Cc:Subject:Date:From;
        b=HY//AvCEOUYPT8pe81/iqZVcR8D3nUHbBFaaHXFFTBF92ornMGwQC3ojXhlQfTLJx
         VsScsk2STnnPOOgXBiQ7iggkC7TYvmT0EpU3mfwnb7Iu/9HOlHqFJ7rSZ21xfLWZPr
         GigXoxP1wz6l1e3/mFU02er2WdgS4V7F68sjW0QX+4AepGwpN5UMnKCRsFQc9kwl1v
         xg9ZitxYJt5fzmUvXVwSnkjOemjDoQxyZquyhzJNSpEKNkEeKElHxiuZ+naZs6q6Id
         9Vok7+VkhvtVw4R6XekuNehxh/Y1mEfU6Sjvtempv/1dm+tB//dPSH9v7kBjLIIbG/
         NgSAkMCirLJvg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/9] mlx5 devlink mutex removal part 1 
Date:   Mon, 11 Jul 2022 01:13:59 -0700
Message-Id: <20220711081408.69452-1-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

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

 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 29 +++++++-
 .../ethernet/mellanox/mlx5/core/en/devlink.c  | 16 ++++-
 .../mellanox/mlx5/core/esw/devlink_port.c     | 20 +++---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 18 ++++-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 57 +++++-----------
 include/linux/mlx5/driver.h                   |  4 ++
 include/net/devlink.h                         |  3 -
 net/core/devlink.c                            | 66 +++----------------
 8 files changed, 94 insertions(+), 119 deletions(-)

-- 
2.36.1

