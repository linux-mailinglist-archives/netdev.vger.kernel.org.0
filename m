Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE7D4DE1BC
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 20:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240357AbiCRTZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 15:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240345AbiCRTZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 15:25:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A369130CAB1
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 12:23:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4953BB82504
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 19:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C266EC340E8;
        Fri, 18 Mar 2022 19:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647631433;
        bh=N74lFhHthFC7g02EJeLjpFIauXfbMG+dwI+uc21Td20=;
        h=From:To:Cc:Subject:Date:From;
        b=bnSJSYIiJGr0SjpcZj188jJb28+SCXlzpAY0hcQaet+TChLnXivsWGgxDcBufs04Z
         sUXSvIJGaCqaxAG3JuaS5qJLEJMQ7DPpczBQzqvFCcKRhLUmi3dAHL0MdomJOepd9O
         GHuDYZPHddPmplJ84XEtcm7aulu/IoU8mqieLFOVMGFoEV4c1bK10b1D4H2h3n41KW
         QePmSwsfkvCh4SwBvKA3emtbGyLjdObXwjjem/May4IwkxNUZDojkYN9hP5DDfHME5
         9h9Gj7O3Ehec2FBp/jwr5veOHG5Y6n9aesYKI4YJmCxlljLVIvhdAJ4byXgYNCPh5s
         kQ9NjKIwaBcFw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, leonro@nvidia.com,
        saeedm@nvidia.com, idosch@idosch.org, michael.chan@broadcom.com,
        simon.horman@corigine.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/5] devlink: hold the instance lock in eswitch callbacks
Date:   Fri, 18 Mar 2022 12:23:39 -0700
Message-Id: <20220318192344.1587891-1-kuba@kernel.org>
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

Series number 2 in the effort to hold the devlink instance lock
in call driver callbacks. We have the following drivers using
this API:

 - bnxt, nfp, netdevsim - their own locking is removed / simplified
   by this series; all of them needed a lock to protect from changes
   to the number of VFs while switching modes, now the VF config bus
   callback takes the devlink instance lock via devl_lock();
 - ice - appears not to allow changing modes while SR-IOV enabled,
   so nothing to do there;
 - liquidio - does not contain any locking;
 - octeontx2/af - is very special but at least doesn't have locking
   so doesn't get in the way either;
 - mlx5 has a wealth of locks - I chickened out and dropped the lock
   in the callbacks so that I can leave the driver be, for now.

The last one is obviously not ideal, but I would prefer to transition
the API already as it make take longer.

v2: use a wrapper in mlx5 and extend the comment

Jakub Kicinski (5):
  bnxt: use the devlink instance lock to protect sriov
  devlink: add explicitly locked flavor of the rate node APIs
  netdevsim: replace port_list_lock with devlink instance lock
  netdevsim: replace vfs_lock with devlink instance lock
  devlink: hold the instance lock during eswitch_mode callbacks

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  6 --
 .../net/ethernet/broadcom/bnxt/bnxt_sriov.c   |  4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 22 ++---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 54 ++++++++---
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  7 +-
 drivers/net/netdevsim/dev.c                   | 85 +++++++++---------
 drivers/net/netdevsim/netdevsim.h             |  2 -
 include/net/devlink.h                         |  4 +
 net/core/devlink.c                            | 90 ++++++++++++-------
 10 files changed, 156 insertions(+), 119 deletions(-)

-- 
2.34.1

