Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2757C280237
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732511AbgJAPMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:12:00 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36018 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732104AbgJAPL7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 11:11:59 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 00D6F1A0097;
        Thu,  1 Oct 2020 17:11:57 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E83951A007C;
        Thu,  1 Oct 2020 17:11:56 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A45F820308;
        Thu,  1 Oct 2020 17:11:56 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     jiri@nvidia.com, idosch@nvidia.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 0/4] dpaa2-eth: add devlink parser error drop trap support
Date:   Thu,  1 Oct 2020 18:11:44 +0300
Message-Id: <20201001151148.18720-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support in the dpaa2-eth driver for a new group of
devlink drop traps - PARSER_ERROR_DROPS.

The first patch adds a new generic trap group and associated traps,
their definitions in devlink and their corresponding entries in the
Documentation.

Because there might be more devices (besides DPAA2) which do not support
changing the action independently on each trap, a nre devlink callback
is introduced - .trap_group_action_set(). If this callback is populated,
it will take precedence over .trap_action_set() when the user requests
changing the action on all the traps in a group.

The next patches add basic linkage with devlink for the dpaa2-eth driver
and support for the newly added PARSER_ERROR_DROPS. Nothing special
here, just setting up the Rx error queue, interpreting the parse result,
and then reporting any frame received on that queue to devlink.

Changes in v2:
 - fix build error in 3/4

Changes in v3:
 - removed a commented line in 4/4
 - added an extack in 4/4
 - fixed up a warning on 32bit in 4/4
 - reworded the trap_group_action_set() description in 2/4

Ioana Ciornei (4):
  devlink: add parser error drop packet traps
  devlink: add .trap_group_action_set() callback
  dpaa2-eth: add basic devlink support
  dpaa2-eth: add support for devlink parser error drop traps

 .../networking/devlink/devlink-trap.rst       |  70 ++++
 drivers/net/ethernet/freescale/dpaa2/Makefile |   2 +-
 .../freescale/dpaa2/dpaa2-eth-devlink.c       | 309 ++++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 114 +++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  81 ++++-
 include/net/devlink.h                         |  62 ++++
 net/core/devlink.c                            |  35 ++
 7 files changed, 671 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c

-- 
2.28.0

