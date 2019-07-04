Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA665F33D
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfGDHI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:08:59 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57365 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726120AbfGDHI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 03:08:59 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 04CE121F4C;
        Thu,  4 Jul 2019 03:08:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Jul 2019 03:08:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=TieZLcHfJjDI39ZmR
        jmM0WA9Z38os3q4mehClk94yME=; b=OuUYBiWYekuZR3eIIgkvxelfI8vsQb2UR
        zp4121gMAKWc+s+jjOkcB84r+oUh8oWSo0tKo6Su7wZa5oxFPNfPxXmah+l6Kp8Y
        LM8URm8K8pcR297zlxztdb3d8aAmH+d/zSyXf0qkN88cZD1Q32iKWa6j7ymW61jD
        GNwffkmbMEsFTJ4SJeKetg+2Mb2dS5ppT/HUr7obY2fOkKxTHZSIua6IfehFd1JR
        0lvht2NEf5s7jhIHQxre7oDqguLHJ7R4XtD0AC/8Q5cUkwdwDHzWBMglX9V3QRs9
        lXGZO+V+Minu43vwhhetLfyfxQ9fkk8sZB3/n3Htxo98LbjnfN/Ew==
X-ME-Sender: <xms:CaYdXXU0koOcZLOmMd0J_KtG3pTXxCVutuyrKd6FY5IG_zY_J4eA8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfedugdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:CaYdXT1pYtNPA23Oa20gPrA_DnjqxiEEXFZPbwLqQjOReWG2Birfqg>
    <xmx:CaYdXeaJWhcEfkrQPlnLEUpRfNKntVdxCEP1SZStxJ_-PPN4c5mQKg>
    <xmx:CaYdXWpkeOw489YJyvZWqtlp7XxLqYXzMznBocYcITgwu2ubVDClKg>
    <xmx:CaYdXbvo6XOEoDQgFbxiNbldvZxuJ3_aEQ5q9GNZ4aNlCZbp88Gy4Q>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 16FE6380075;
        Thu,  4 Jul 2019 03:08:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/8] mlxsw: Enable/disable PTP shapers
Date:   Thu,  4 Jul 2019 10:07:32 +0300
Message-Id: <20190704070740.302-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Shalom says:

In order to get more accurate hardware time stamping in Spectrum-1, the
driver needs to apply a shaper on the port for speeds lower than 40Gbps.
This shaper is called a PTP shaper and it is applied on hierarchy 0,
which is the port hierarchy. This shaper may affect the shaper rates of
all hierarchies.

This patchset adds the ability to enable or disable the PTP shaper on
the port in two scenarios:
 1. When the user wants to enable/disable the hardware time stamping
 2. When the port is brought up or down (including port speed change)

Patch #1 adds the QEEC.ptps field that is used for enabling or disabling
the PTP shaper on a port.

Patch #2 adds a note about disabling the PTP shaper when calling to
mlxsw_sp_port_ets_maxrate_set().

Patch #3 adds the QPSC register that is responsible for configuring the
PTP shaper parameters per speed.

Patch #4 sets the PTP shaper parameters during the ptp_init().

Patch #5 adds new operation for getting the port's speed.

Patch #6 enables/disables the PTP shaper when turning on or off the
hardware time stamping.

Patch #7 enables/disables the PTP shaper when the port's status has
changed (including port speed change).

Patch #8 applies the PTP shaper enable/disable logic by filling the PTP
shaper parameters array.

Shalom Toledo (8):
  mlxsw: reg: Add ptps field in QoS ETS Element Configuration Register
  mlxsw: spectrum: Add note about the PTP shaper
  mlxsw: reg: Add QoS PTP Shaper Configuration Register
  mlxsw: spectrum_ptp: Set the PTP shaper parameters
  mlxsw: spectrum: Add new operation for getting the port's speed
  mlxsw: spectrum_ptp: Enable/disable PTP shaper on a port when getting
    HWTSTAMP on/off
  mlxsw: spectrum: Set up PTP shaper when port status has changed
  mlxsw: spectrum_ptp: Apply the PTP shaper enable/disable logic

 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 129 ++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  81 +++++----
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 +
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 158 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    |  10 ++
 5 files changed, 350 insertions(+), 30 deletions(-)

-- 
2.20.1

