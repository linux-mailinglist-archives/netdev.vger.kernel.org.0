Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5072B47521C
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239890AbhLOFdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:33:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48128 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239884AbhLOFdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:33:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F8E5B81D4C
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 05:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9343CC34604;
        Wed, 15 Dec 2021 05:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639546381;
        bh=aLUAMv5IvYVdL6IPUg3sxmBEw9/uf2c9QSwN1JptOmQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ds7FNY1Tm5vKjfLLqyddmVHDK6K/Go6BtYvKJEqqgtFpLkXylwo0C1YqHbmFHcSAc
         RRPfSCjHXsSMxwWlyAGCws35WCZmfRuomgRGiwG/ZjxwxhHPFdI1GPXwljB/mYHxuy
         qSD4Z8kl4kkCRPuiWKC41h8aq39RYxL4mZ2jqg97swlZX4HPy1vXBB1owtMk53c3Kg
         Cqgbkd6KzuO79K4AnAU/wyje2lK3mnPAExzIcd2zTLnZD0v9TYz2MAG2mI1keJUkMX
         F6JwpK8P5ZaEccrFmenqprp5UjTvGpdBtk+9paVrdO3UTfiHnl0MUdMMRnfq+qjyxV
         H2hJBs2q7hOUQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next v0 00/16] mlx5 updates 2021-12-14
Date:   Tue, 14 Dec 2021 21:32:44 -0800
Message-Id: <20211215053300.130679-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series provides refactoring to the TC actions parsing code we have
in the driver to help improving driver structure and extensibility for
future actions support.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 6cf7a1ac0fedad8a70c050ade8a27a2071638500:

  Merge branch 'net-dsa-hellcreek-fix-handling-of-mgmt-protocols' (2021-12-14 18:46:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-12-14

for you to fetch changes up to 35bb5242148fa16fd5b2f28b508e0c031e90c672:

  net/mlx5e: Move goto action checks into tc_action goto post parse op (2021-12-14 21:29:46 -0800)

----------------------------------------------------------------
mlx5-updates-2021-12-14

Parsing Infrastructure for TC actions:

The series introduce a TC action infrastructure to help
parsing TC actions in a generic way for both FDB and NIC rules.

To help maintain the parsing code of TC actions, we the parsing code to
action parser per action TC type in separate files, instead of having one
big switch case loop, duplicated between FDB and NIC parsers as before this
patchset.

Each TC flow_action->id is represented by a dedicated mlx5e_tc_act handler
which has callbacks to check if the specific action is offload supported and
to parse the specific action.

We move each case (TC action) handling into the specific handler, which is
responsible for parsing and determining if the action is supported.

----------------------------------------------------------------
Roi Dayan (16):
      net/mlx5e: Add tc action infrastructure
      net/mlx5e: Add goto to tc action infra
      net/mlx5e: Add tunnel encap/decap to tc action infra
      net/mlx5e: Add csum to tc action infra
      net/mlx5e: Add pedit to tc action infra
      net/mlx5e: Add vlan push/pop/mangle to tc action infra
      net/mlx5e: Add mpls push/pop to tc action infra
      net/mlx5e: Add mirred/redirect to tc action infra
      net/mlx5e: Add ct to tc action infra
      net/mlx5e: Add sample and ptype to tc_action infra
      net/mlx5e: Add redirect ingress to tc action infra
      net/mlx5e: TC action parsing loop
      net/mlx5e: Move sample attr allocation to tc_action sample parse op
      net/mlx5e: Add post_parse() op to tc action infrastructure
      net/mlx5e: Move vlan action chunk into tc action vlan post parse op
      net/mlx5e: Move goto action checks into tc_action goto post parse op

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    9 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/accept.c |   31 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |  103 ++
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |   75 ++
 .../ethernet/mellanox/mlx5/core/en/tc/act/csum.c   |   61 ++
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c |   50 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/drop.c   |   30 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/goto.c   |  122 +++
 .../ethernet/mellanox/mlx5/core/en/tc/act/mark.c   |   35 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |  315 ++++++
 .../mellanox/mlx5/core/en/tc/act/mirred_nic.c      |   51 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/mpls.c   |   86 ++
 .../ethernet/mellanox/mlx5/core/en/tc/act/pedit.c  |  165 +++
 .../ethernet/mellanox/mlx5/core/en/tc/act/pedit.h  |   32 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/ptype.c  |   35 +
 .../mlx5/core/en/tc/act/redirect_ingress.c         |   79 ++
 .../ethernet/mellanox/mlx5/core/en/tc/act/sample.c |   51 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/trap.c   |   38 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/tun.c    |   61 ++
 .../ethernet/mellanox/mlx5/core/en/tc/act/vlan.c   |  218 ++++
 .../ethernet/mellanox/mlx5/core/en/tc/act/vlan.h   |   30 +
 .../mellanox/mlx5/core/en/tc/act/vlan_mangle.c     |   87 ++
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   12 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 1073 ++------------------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |    1 -
 25 files changed, 1855 insertions(+), 995 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/csum.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mark.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred_nic.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ptype.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/redirect_ingress.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/tun.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c
