Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82AFD4DBDE2
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 05:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiCQE4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 00:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiCQE4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 00:56:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58C5111DD7
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 21:37:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B62E3615BA
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 04:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA117C340E9;
        Thu, 17 Mar 2022 04:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647490840;
        bh=8zfaVU/EOOOvw6HIkRmpAGPpUrn4cldwm5fE0UoNGTg=;
        h=From:To:Cc:Subject:Date:From;
        b=tfDDMNxscOTb0NM2Ve4w0/BU7S447H8diTMnDhyM0medJZLt+e8N/XkpJJdLcOP90
         Y2+2KXu0Pkpgd3wcYvNv8RwI/Bhci3ITrHSGOtOyu6wIitFiIJlImMnFf+pEdYUWYD
         K8kA1ZS7DVNW+lpJzWzO+SVrjS0JVwAgS+8JtehrZYfTy5L+XkGrIhGrIwLJB2JKGU
         AYtaAd2y8QdwUFcyFEEwqTYtBAGpN/4GdyIAQVzdaeC2PT9SCDzyLkS11AVE8eb8gn
         /JpAHM8wiHl2GPhQhruqtid9AzJt5YgiSkQRmZzYFpoisNiB8ADrPqkkCI37eUshS8
         hw3DW6P5lDsMA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, leonro@nvidia.com,
        saeedm@nvidia.com, idosch@idosch.org, michael.chan@broadcom.com,
        simon.horman@corigine.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/5] devlink: hold the instance lock in eswitch callbacks
Date:   Wed, 16 Mar 2022 21:20:18 -0700
Message-Id: <20220317042023.1470039-1-kuba@kernel.org>
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

LMK if it's an abuse of power / I'm not thinking straight.

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
 .../mellanox/mlx5/core/eswitch_offloads.c     | 15 +++-
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  7 +-
 drivers/net/netdevsim/dev.c                   | 85 +++++++++---------
 drivers/net/netdevsim/netdevsim.h             |  2 -
 include/net/devlink.h                         |  4 +
 net/core/devlink.c                            | 90 ++++++++++++-------
 10 files changed, 128 insertions(+), 108 deletions(-)

-- 
2.34.1

