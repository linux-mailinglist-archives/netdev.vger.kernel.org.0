Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13402210DC6
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731490AbgGAOdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:33:18 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:58571 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730852AbgGAOdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:33:17 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 114095801C9;
        Wed,  1 Jul 2020 10:33:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 01 Jul 2020 10:33:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Cz4VrOPf6EhDp/M08
        Oo+4M7ZgRKUYlxQe8lttXVDxaE=; b=XFRlIBDjwY0QJm4nIFhvA1H/IBTeQkDbw
        gJI4tgbzchei9fPJKHH+mIh2LHNvLtnDhXRTHj5yU2FnBQtfxqNZkYuE0gFywjS4
        IiEjQVWYyh29HrerU2OeRHhUAbBsWFHxSA+6Xm7TVO82rlsSQ1PhgShFwGlFUvsC
        2zZdQv3prYN03Qckp2WBh8mqS82CeAKrc5dcHBFqAXd68ASJn2edupaZzZSlAqmL
        YkHPgOVCeFGr1NGDDPWyOlzfiLkIpcmk3IJ4yAMtl6yoSkhKwHivxeTYmePD9WQD
        GHFktYFdNoym0JCIzkBvUsE/f6SlT7vSPalZcILEnaBC3QRhuZDmw==
X-ME-Sender: <xms:qp78Xu7MLQkS3uk6CdpK0IJLcOBhevTTWjEqmetzYUti2ZcGgdpKSg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrtddvgdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepudelfedrgeejrdduieehrddvhedunecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:qp78Xn4x_KUaonEt4w5WVMyGdX6Nqz88N_Fy5QP-PqyGHDjsX113Dw>
    <xmx:qp78XteeYByhFGsiLWKPphInMyiKVdkPaLiz5_QJ2TrVNXcBxbcrzw>
    <xmx:qp78XrI38AgsYSxaRr_Ak6IOocPFKmAuSjWt9KB0Hk4KWMAJw6q_9A>
    <xmx:rJ78XvAFpCLjCKTgJfAlhfabJTBq5Y6ji9I8T35nPk0Q0w8QqJuCUg>
Received: from shredder.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 552E7328005E;
        Wed,  1 Jul 2020 10:33:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 0/9] devlink: Expose port split attributes
Date:   Wed,  1 Jul 2020 17:32:42 +0300
Message-Id: <20200701143251.456693-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Danielle says:

Currently, user space has no way of knowing if a port can be split and
into how many ports. Among other things, this makes it impossible to
write generic tests for port split functionality.

Therefore, this set exposes two new devlink port attributes to user
space: Number of lanes and whether the port can be split or not.

Patch set overview:

Patches #1-#4 cleanup 'struct devlink_port_attrs' and reduce the number
of parameters passed between drivers and devlink via
devlink_port_attrs_set()

Patch #5 adds devlink port lanes attributes

Patches #6-#7 add devlink port splittable attribute

Patch #8 exploits the fact that devlink is now aware of port's number of
lanes and whether the port can be split or not and moves some checks
from drivers to devlink

Patch #9 adds a port split test

Changes since v1:
* Rename 'width' attribute to 'lanes'
* Add 'splittable' attribute
* Move checks from drivers to devlink

Danielle Ratson (9):
  devlink: Move set attribute of devlink_port_attrs to devlink_port
  devlink: Move switch_port attribute of devlink_port_attrs to
    devlink_port
  devlink: Replace devlink_port_attrs_set parameters with a struct
  mlxsw: Set number of port lanes attribute in driver
  devlink: Add a new devlink port lanes attribute and pass to netlink
  mlxsw: Set port split ability attribute in driver
  devlink: Add a new devlink port split ability attribute and pass to
    netlink
  devlink: Move input checks from driver to devlink
  selftests: net: Add port split test

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  13 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |   6 +-
 .../ethernet/mellanox/mlx5/core/en/devlink.c  |  19 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  20 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  18 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |   4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  23 +-
 .../net/ethernet/mellanox/mlxsw/switchib.c    |   2 +-
 .../net/ethernet/mellanox/mlxsw/switchx2.c    |   2 +-
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  17 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |   5 +-
 drivers/net/netdevsim/dev.c                   |  14 +-
 include/net/devlink.h                         |  31 ++-
 include/uapi/linux/devlink.h                  |   3 +
 net/core/devlink.c                            |  90 +++---
 net/dsa/dsa2.c                                |  17 +-
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/devlink_port_split.py       | 259 ++++++++++++++++++
 19 files changed, 416 insertions(+), 132 deletions(-)
 create mode 100755 tools/testing/selftests/net/devlink_port_split.py

-- 
2.26.2

