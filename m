Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685844D3DFA
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238951AbiCJARr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238501AbiCJARq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:17:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DE7122F44
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:16:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D83EBB82446
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 00:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53112C340E8;
        Thu, 10 Mar 2022 00:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646871404;
        bh=uTQZ3m3tJjXDBvDl5TNSd44qgAlac61OaF70oP889GI=;
        h=From:To:Cc:Subject:Date:From;
        b=Smv/vZgICRzaFABMEwVfoWjZaiC6H5pSpy17Tf0WX6Du92EViSob/5kG/B8Gn2MZC
         qMAvLMyAkW08qRlZk0irtVvxxruFFOmTlYzI7DhDX+t4ASeFkFvtTViD0E/OwA3RRG
         Fa5gGJm2qDFzkmAaA3FpdRVt2NM9A1Gy8VeT2g9lDCGwVuGb7/62VHxQFlms2eJWJu
         hVLN03BykgPAOEWQBsxVybLMPyMxaU4TZOFuQtoQpehcKUrnd5jWP612FldF4o4+GZ
         lEo/GO3rxNSKk/j+qn3E3WJPQp0TbtoKmsMv4uu/eYJnA/iVdotvYXUeYkmT2ALWZR
         rAAL4BRE6CKFQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com
Cc:     netdev@vger.kernel.org, leonro@nvidia.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFT net-next 0/6] devlink: expose instance locking and simplify port splitting
Date:   Wed,  9 Mar 2022 16:16:26 -0800
Message-Id: <20220310001632.470337-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

I'd appreciate some testing, I don't have access to this HW.

Jakub Kicinski (6):
  devlink: expose instance locking and add locked port registering
  eth: nfp: wrap locking assertions in helpers
  eth: nfp: replace driver's "pf" lock with devlink instance lock
  eth: mlxsw: switch to explicit locking for port registration
  devlink: hold the instance lock in port_split / port_unsplit callbacks
  devlink: pass devlink_port to port_split / port_unsplit callbacks

 drivers/net/ethernet/mellanox/mlxsw/core.c    |  36 ++---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |   6 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   7 +
 .../net/ethernet/netronome/nfp/flower/main.c  |   4 +-
 drivers/net/ethernet/netronome/nfp/nfp_app.c  |   2 +-
 drivers/net/ethernet/netronome/nfp/nfp_app.h  |  12 +-
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  55 +++----
 drivers/net/ethernet/netronome/nfp/nfp_main.c |  19 +--
 drivers/net/ethernet/netronome/nfp/nfp_main.h |   6 +-
 .../net/ethernet/netronome/nfp/nfp_net_main.c |  34 ++--
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |   4 +-
 drivers/net/ethernet/netronome/nfp/nfp_port.c |  17 --
 drivers/net/ethernet/netronome/nfp/nfp_port.h |   2 -
 include/net/devlink.h                         |  15 +-
 net/core/devlink.c                            | 148 ++++++++++--------
 15 files changed, 196 insertions(+), 171 deletions(-)

-- 
2.34.1

