Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66585B34A5
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 08:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbfIPGSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 02:18:47 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60859 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729398AbfIPGSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 02:18:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8DB4622040;
        Mon, 16 Sep 2019 02:18:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 16 Sep 2019 02:18:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rjyzSI5EEU/9COBVj
        Us6HQkoh+IlcYSvLUv59gEzvr4=; b=uzNW7TnTfYGqItdIv1CWoRTeSmxAuHYNk
        b7xjH/i0XGSMS5MUNrYm5Noz9Ni4hVLpiNjlOaKVfoxhLi53DqroLEZ0MU/btlvI
        7toStepm50sSV77KKjvZnePCbWvOzS+zW0b1E1Z18e466iOEKKQMgBcq/KoD5ClR
        dJqP+5inpH36BO+oMQHCMKn4HdUZ5UZmjUmzkWRBxr1GOZpeBSutqY9+0Vxna8+N
        YrSDTrR8X/21JUnQm2pkxJj8ARNnd/NDkDoTCV0NQLKyDgXAkArD1SrGQCe2kPhE
        jtKWe7mWbZVKhbjWpK7F7S0jMlf5bI+wP6GmZaHGOwLnnkL3fRuBw==
X-ME-Sender: <xms:RSl_XdWgIX37hyACbj8uwHaHECFF1O4bmbQ5bZARDqEW26kigIMGrA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:RSl_XS3iK4fapm3YnQy222ynFZuaafW0hM9bXv8aKUUXQlNR7taefQ>
    <xmx:RSl_XbFa81qgran36Wd-s6NgFiQY8KuO7Wj1npqhHWcVRiMnbL03tg>
    <xmx:RSl_XYiZjaoyRoOUm5JwAojc24dewWmJAXq1J9h9ytL6ZJrXnOtpGA>
    <xmx:RSl_XRZgiV_wbyk6CYxJSQ9XMU3wLahAEpH2I5FCSuegXHaHQyfgvg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B0AB480066;
        Mon, 16 Sep 2019 02:18:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 0/3] mlxsw: spectrum_buffers: Add the ability to query the CPU port's shared buffer
Date:   Mon, 16 Sep 2019 09:17:47 +0300
Message-Id: <20190916061750.26207-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Shalom says:

While debugging packet loss towards the CPU, it is useful to be able to
query the CPU port's shared buffer quotas and occupancy.

Patch #1 prevents changing the CPU port's threshold and binding.

Patch #2 registers the CPU port with devlink.

Patch #3 adds the ability to query the CPU port's shared buffer quotas and
occupancy.

v2:

Patch #1:
* s/0/MLXSW_PORT_CPU_PORT/
* Assign "mlxsw_sp->ports[MLXSW_PORT_CPU_PORT" at the end of
  mlxsw_sp_cpu_port_create() to avoid NULL assignment on error path
* Add common functions for mlxsw_core_port_init/fini()

Patch #2:
* Move "changing CPU port's threshold and binding" check to a separate
  patch

Shalom Toledo (3):
  mlxsw: spectrum_buffers: Prevent changing CPU port's configuration
  mlxsw: spectrum: Register CPU port with devlink
  mlxsw: spectrum_buffers: Add the ability to query the CPU port's
    shared buffer

 drivers/net/ethernet/mellanox/mlxsw/core.c    | 65 ++++++++++++++++---
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  5 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 46 +++++++++++++
 .../mellanox/mlxsw/spectrum_buffers.c         | 51 ++++++++++++---
 4 files changed, 150 insertions(+), 17 deletions(-)

-- 
2.21.0

