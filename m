Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A5C2F9185
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 10:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbhAQJL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 04:11:28 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:52761 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726298AbhAQIEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 03:04:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 64B45F92;
        Sun, 17 Jan 2021 03:02:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 17 Jan 2021 03:02:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uFKIjpmRG+5KV7nkW
        CyVaUerYQ5AP8aXf5Izor5NEbk=; b=H/FsINAHBVpOJaA/k55P6JhEB8wZktme2
        Cv8dAC+in4T4bcYdfcWhYotJaNhwBjk/U0uJLAOnHXYrDvCqkTCFGMj4JkPHhEGY
        n+TixGnvLI7DYaaxgh8Ap6Dibjxq39MqQhk0RvExbRH18mFLB+nQPzFtCfWVTkCi
        7sq+okCGOHF+hdkm4bjMjKF9gvKqzclC+KFl9JfzKVJ5n73YRs47qBddm9yRnjun
        SJbeB/2vIbAdIx7+wlN2JFZWQeVmKXZUU6kreh10BI69znO1b88GX2I5dio8LWrv
        FtWjZlidvCMipKm6mvNC7MDzZK2OZHdgUZcuYkgDcWRi3XC4QCd5A==
X-ME-Sender: <xms:Ke8DYAm0m4W00S_q-Mhp4oIw-xIx3hw_f0eg-dQbL9tMKtuMCgaQ2Q>
    <xme:Ke8DYP3ZTdUtyOQ1Ix-gT6mBvnzb_U3aMamVFKr3VCyDLYmAyVuLCjL4S7y77KxPO
    CLhKH3dJAUD2Ck>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdehgdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrgeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Ke8DYOp2mxb0mDm4F7fXVBsAzcE_0vxkCqdhfkjIMzjbt3PTHAS5TQ>
    <xmx:Ke8DYMlJox1dyolpcyFIgrKpx3MNoNNl118Yk96mw7vrncrEoYIZRw>
    <xmx:Ke8DYO3EYOJ-3SJIJ5aj7HKcFpkZRgudoNA0GNYBisB8g5ogNIW9Kw>
    <xmx:Ku8DYBRSkq-BWJM-dcHHjh31-uqUFPD0w296DKu27IqEew6q9fj9Tw>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id B5F8C24005B;
        Sun, 17 Jan 2021 03:02:47 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/5] mlxsw: Add support for RED qevent "mark"
Date:   Sun, 17 Jan 2021 10:02:18 +0200
Message-Id: <20210117080223.2107288-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Petr says:

The RED qdisc currently supports two qevents: "early_drop" and "mark". The
filters added to the block bound to the "early_drop" qevent are executed on
packets for which the RED algorithm decides that they should be
early-dropped. The "mark" filters are similarly executed on ECT packets
that are marked as ECN-CE (Congestion Encountered).

A previous patchset has offloaded "early_drop" filters on Spectrum-2 and
later, provided that the classifier used is "matchall", that the action
used is either "trap" or "mirred", and a handful or further limitations.

This patchset similarly offloads "mark" filters.

Patch set overview:

Patches #1 and #2 add the trap, under which packets will be reported to the
CPU, if the qevent filter uses the action "trap".

Patch #3 then recognizes FLOW_BLOCK_BINDER_TYPE_RED_MARK as a binder type,
and offloads the attached filters similarly to _EARLY_DROP.

Patch #4 cleans up some unused variables in a selftest, and patch #5 adds a
new selftest for the RED "mark" qevent offload.

Petr Machata (5):
  devlink: Add ecn_mark trap
  mlxsw: spectrum_trap: Add ecn_mark trap
  mlxsw: spectrum_qdisc: Offload RED qevent mark
  selftests: mlxsw: sch_red_core: Drop two unused variables
  selftests: mlxsw: RED: Add selftests for the mark qevent

 .../networking/devlink/devlink-trap.rst       |  4 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  2 +
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 14 +++-
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 16 ++++
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  9 ++
 include/net/devlink.h                         |  3 +
 net/core/devlink.c                            |  1 +
 .../drivers/net/mlxsw/sch_red_core.sh         | 84 ++++++++++++++++++-
 .../drivers/net/mlxsw/sch_red_ets.sh          | 74 ++++++++++++++--
 11 files changed, 200 insertions(+), 10 deletions(-)

-- 
2.29.2

