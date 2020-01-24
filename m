Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D35D1485E2
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387948AbgAXNYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:24:04 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51433 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387562AbgAXNYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:24:03 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 40F6621D73;
        Fri, 24 Jan 2020 08:24:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Jan 2020 08:24:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=r1drckmz9r0lTdY87
        TXoV0c15SyGzpwiyaCoCI8sbXs=; b=kT5x/MmCvOUhB9/qDcluMTrGBMpujcGsj
        H8FyYXZcZLhbqRZafgp6NSMI9HQ4U10Vy1ShdcWnLKhznfNs3PAPC4DnuRAXk/lI
        +UVlT7KbENg9NOGSWp1yqCadVPx3l+ac9G3byruNdU0eoTPLQ3v4YLLkTQnStpq1
        K/0RLSucT2s6LoFNuKmg1q0Mzrr75rpoU9mN/ciZRCP1ZjoYzLIvd7B3z7NCqK2M
        Nntoi8gbz/A9fO2UKbSpx3WUveoAB4P7PIItUvAR2fBpk7HhGDUZw4x3iXdzms8p
        UZ2PNx5Xtpv5OCLKnrdzyRGQ44wfkvsop8xL54esHLesAlqhVJpWA==
X-ME-Sender: <xms:8u8qXogs12EApX-t7vWjFi_triOtQt3VrMm7N58BqT016HtkOesK3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepjeelrddukeefrddutdejrdduvddtnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdr
    ohhrgh
X-ME-Proxy: <xmx:8u8qXgmm09D0mk8Jig85CGbUVZOM45ThaeCYagjUTSpOv72FI_ul6A>
    <xmx:8u8qXq5uilWoqusWsUWMKXWu7TGB1CS91i92J8rWseTOU6YSyMxHjQ>
    <xmx:8u8qXmsDTpGK9OFdNAp5MJoz-CcNXzFw6qA68X244Bh3b_v-LwQTIw>
    <xmx:8u8qXsRhaNGymm3nXhhwJFjfc4rc30HifJPbVflOYA9ryQQsVRsfXg>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id D41083060F1F;
        Fri, 24 Jan 2020 08:23:59 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/14] mlxsw: Offload TBF
Date:   Fri, 24 Jan 2020 15:23:04 +0200
Message-Id: <20200124132318.712354-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Petr says:

In order to allow configuration of shapers on Spectrum family of
machines, recognize TBF either as root Qdisc, or as a child of ETS or
PRIO. Configure rate of maximum shaper according to TBF rate setting,
and maximum shaper burst size according to TBF burst setting.

- Patches #1 and #2 make the TBF shaper suitable for offloading.
- Patches #3, #4 and #5 are refactoring aimed at easier support of leaf
  Qdiscs in general.
- Patches #6 to #10 gradually introduce TBF offload.
- Patches #11 to #14 add selftests.

Petr Machata (14):
  net: sched: sch_tbf: Don't overwrite backlog before dumping
  net: sched: Make TBF Qdisc offloadable
  mlxsw: spectrum_qdisc: Extract a per-TC stat function
  mlxsw: spectrum_qdisc: Add mlxsw_sp_qdisc_get_class_stats()
  mlxsw: spectrum_qdisc: Extract a common leaf unoffload function
  mlxsw: reg: Add max_shaper_bs to QoS ETS Element Configuration
  mlxsw: reg: Increase MLXSW_REG_QEEC_MAS_DIS
  mlxsw: spectrum: Add lowest_shaper_bs to struct mlxsw_sp
  mlxsw: spectrum: Configure shaper rate and burst size together
  mlxsw: spectrum_qdisc: Support offloading of TBF Qdisc
  selftests: Move two functions from mlxsw's qos_lib to lib
  selftests: forwarding: lib: Add helpers for busywaiting
  selftests: forwarding: lib: Allow reading TC rule byte counters
  selftests: mlxsw: Add a TBF selftest

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  19 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  16 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   5 +-
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    |   5 +-
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 346 +++++++++++++++---
 include/linux/netdevice.h                     |   1 +
 include/net/pkt_cls.h                         |  22 ++
 net/sched/sch_tbf.c                           |  56 ++-
 .../selftests/drivers/net/mlxsw/qos_lib.sh    |  24 --
 .../drivers/net/mlxsw/sch_tbf_ets.sh          |   9 +
 .../drivers/net/mlxsw/sch_tbf_prio.sh         |   9 +
 .../drivers/net/mlxsw/sch_tbf_root.sh         |   9 +
 tools/testing/selftests/net/forwarding/lib.sh |  45 ++-
 .../selftests/net/forwarding/sch_tbf_core.sh  | 233 ++++++++++++
 .../selftests/net/forwarding/sch_tbf_ets.sh   |   6 +
 .../net/forwarding/sch_tbf_etsprio.sh         |  39 ++
 .../selftests/net/forwarding/sch_tbf_prio.sh  |   6 +
 .../selftests/net/forwarding/sch_tbf_root.sh  |  33 ++
 18 files changed, 793 insertions(+), 90 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh
 create mode 100644 tools/testing/selftests/net/forwarding/sch_tbf_core.sh
 create mode 100755 tools/testing/selftests/net/forwarding/sch_tbf_ets.sh
 create mode 100644 tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh
 create mode 100755 tools/testing/selftests/net/forwarding/sch_tbf_prio.sh
 create mode 100755 tools/testing/selftests/net/forwarding/sch_tbf_root.sh

-- 
2.24.1

