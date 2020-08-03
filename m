Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2455F23AA3D
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgHCQMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:12:32 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43479 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725945AbgHCQMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:12:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 937875C00D9;
        Mon,  3 Aug 2020 12:12:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 03 Aug 2020 12:12:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=YESboACVSPCnpuRI6
        Hv8Bd6HiJCT5Ab4KFWtN3M5vcI=; b=OREic4ZJBzH6fbOs9GoUVNNBupAQnYgo4
        JV89hMvlkgBmSkwzhAXX1rbcUNPsHTxtyIkMA2SvzumiibsPJAPx5F77Y/z18uob
        l5yL5pUJHBkXWbcI3tcYjY6tFnEyc2tu9Rax3eKV2leNw+9luQAtFANJ6YJn1jbn
        e5lRGtwI2E8Zuqy/QXXSRh+t61GFy1UxUXRUZtTGf8E2t/WPlieu71iSwA3pE+No
        Ij+OAirygfxMW8Zh9goM7U0SDEQNo91AsQQB/wAhuDXHijHNNLVni1TqZvKsO0aF
        c6x88IYAZo653bm02JaxaXCKxSd5+4PK+YVnzmSI1ALLO9dLfBS3Q==
X-ME-Sender: <xms:bjcoX1fXdZSqyVIIs9nrA3x1xKAV3OduBtNpzRF5phasvrD_BkIeOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeeggdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepjeelrddukedurdeirddvudelnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhse
    hiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:bjcoXzP2zlNiaOjjGMrFPDHn9O2W-iN_GAOrCfwAqZFzFVmRL3GYzg>
    <xmx:bjcoX-j9tMiw5vf4ojJqYgGWRIwYGfX_-GYz1fL0pUR4rtCV772KSA>
    <xmx:bjcoX-_38ZeCdWiQtMJUtuo2Bbs2qA9g34PsdATaYH1cFgl-gPndbQ>
    <xmx:bjcoX5IbMyxqgFkj-8TR6Rk9QFFXKpa9o-0AImmV1-CTL9siEMcI0w>
Received: from shredder.mtl.com (bzq-79-181-6-219.red.bezeqint.net [79.181.6.219])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D0243060272;
        Mon,  3 Aug 2020 12:12:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/9] mlxsw: Add support for buffer drop traps
Date:   Mon,  3 Aug 2020 19:11:32 +0300
Message-Id: <20200803161141.2523857-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Petr says:

A recent patch set added the ability to mirror buffer related drops
(e.g., early drops) through a netdev. This patch set adds the ability to
trap such packets to the local CPU for analysis.

The trapping towards the CPU is configured by using tc-trap action
instead of tc-mirred as was done when the packets were mirrored through
a netdev. A future patch set will also add the ability to sample the
dropped packets using tc-sample action.

The buffer related drop traps are added to devlink, which means that the
dropped packets can be reported to user space via the kernel's
drop_monitor module.

Patch set overview:

Patch #1 adds the early_drop trap to devlink

Patch #2 adds extack to a few devlink operations to facilitate better
error reporting to user space. This is necessary - among other things -
because the action of buffer drop traps cannot be changed in mlxsw

Patch #3 performs a small refactoring in mlxsw, patch #4 fixes a bug that
this patchset would trigger.

Patches #5-#6 add the infrastructure required to support different traps
/ trap groups in mlxsw per-ASIC. This is required because buffer drop
traps are not supported by Spectrum-1

Patch #7 extends mlxsw to register the early_drop trap

Patch #8 adds the offload logic for the "trap" action at a qevent block.

Patch #9 adds a mlxsw-specific selftest.

Amit Cohen (1):
  devlink: Add early_drop trap

Ido Schimmel (5):
  devlink: Pass extack when setting trap's action and group's parameters
  mlxsw: spectrum_trap: Use 'size_t' for array sizes
  mlxsw: spectrum_trap: Allow for per-ASIC trap groups initialization
  mlxsw: spectrum_trap: Allow for per-ASIC traps initialization
  mlxsw: spectrum_trap: Add early_drop trap

Petr Machata (3):
  mlxsw: spectrum_span: On policer_id_base_ref_count, use dec_and_test
  mlxsw: spectrum_qdisc: Offload action trap for qevents
  selftests: mlxsw: RED: Test offload of trapping on RED qevents

 .../networking/devlink/devlink-trap.rst       |   4 +
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  10 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  19 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   3 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  14 +-
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  |  75 +++++-
 .../ethernet/mellanox/mlxsw/spectrum_span.c   |   3 +-
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 255 ++++++++++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_trap.h   |  18 +-
 drivers/net/netdevsim/dev.c                   |   6 +-
 include/net/devlink.h                         |   9 +-
 net/core/devlink.c                            |   9 +-
 .../drivers/net/mlxsw/sch_red_core.sh         |  35 ++-
 .../drivers/net/mlxsw/sch_red_ets.sh          |  11 +
 15 files changed, 406 insertions(+), 66 deletions(-)

-- 
2.26.2

