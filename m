Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6401E86C4
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgE2ShX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:37:23 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56197 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727013AbgE2ShW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:37:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A72765C00AF;
        Fri, 29 May 2020 14:37:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 29 May 2020 14:37:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KP32SJ6OMQ0ZGmc3n
        VYLnBOd5SL6dV6u5n4cQENvG9A=; b=zguoWmda/yWLTK6AdEsTpOPdAHiaTXTxn
        eblLM22ooNXQulLZF3j4+PAesX9zthryfqYOirhQ0wrddoyzA3+VnXQw4duWy0pN
        rOkgOqDDh50QxEXyLrer656KtQdFBPmv+C50j1Ro8f78ZyPFtVi9Z3tqXi33j2S8
        iMP2FSOfpsHcGJQqSiCBB3JJSM6K7+LHPdn6MXb3vo/PUPP/vk0QvoysaHW+9RDu
        iKJgLmzUSdvY6b9sguFI4ZiIi5evcNOZ+WTxDPQyEewJAfnYjf5ry10+oH0XUQT1
        bTZvUA3rXrK2vtABy+YAdl4NCNe+/Yfhk5IFbKCWRUf1X6BwbLOfg==
X-ME-Sender: <xms:YVbRXokNRJ7zZZwLnp4eDimg3CnowldaAd-9TXtvxPF3Op5i9xb5VA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucfkphepjeelrddujeeirddvgedruddtjeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:YVbRXn31ZBe11D0v6NaO-p3vmRi3Ecqx1m-7CEXxJ1RVyXt-10B7kA>
    <xmx:YVbRXmosJ1eSpiEnRvo7_WdTGZ2FvQz4xTat7o__Ncp368wW5c724g>
    <xmx:YVbRXkmRMHDxpT6oPWI9l3Xet7huWcK6BBn4Jv6He3kcXhzeAGGJTg>
    <xmx:YVbRXr8cYxKnVwspafOpMk84_ZsR2DIOEp09e5f3fYJ9c9kc3rPwWg>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 535313061CB6;
        Fri, 29 May 2020 14:37:20 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/14] devlink: Add support for control packet traps
Date:   Fri, 29 May 2020 21:36:35 +0300
Message-Id: <20200529183649.1602091-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

So far device drivers were only able to register drop and exception
packet traps with devlink. These traps are used for packets that were
either dropped by the underlying device or encountered an exception
(e.g., missing neighbour entry) during forwarding.

However, in the steady state, the majority of the packets being trapped
to the CPU are packets that are required for the correct functioning of
the control plane. For example, ARP request and IGMP query packets.

This patch set allows device drivers to register such control traps with
devlink and expose their default control plane policy to user space.
User space can then tune the packet trap policer settings according to
its needs, as with existing packet traps.

In a similar fashion to exception traps, the action associated with such
traps cannot be changed as it can easily break the control plane. Unlike
drop and exception traps, packets trapped via control traps are not
reported to the kernel's drop monitor as they are not indicative of any
problem.

Patch set overview:

Patches #1-#3 break out layer 3 exceptions to a different group to
provide better granularity. A future patch set will make this completely
configurable.

Patch #4 adds a new trap action ('mirror') that is used for packets that
are forwarded by the device and sent to the CPU. Such packets are marked
by device drivers with 'skb->offload_fwd_mark = 1' in order to prevent
the kernel from forwarding them again.

Patch #5 adds the new trap type, 'control'.

Patches #6-#8 gradually add various control traps to devlink with proper
documentation.

Patch #9 adds a few control traps to netdevsim, which are automatically
exercised by existing devlink-trap selftest.

Patches #10 performs small refactoring in mlxsw.

Patches #11-#13 change mlxsw to register its existing control traps with
devlink.

Patch #14 adds a selftest over mlxsw that exercises all the registered
control traps.

Ido Schimmel (14):
  devlink: Create dedicated trap group for layer 3 exceptions
  mlxsw: spectrum_trap: Move layer 3 exceptions to exceptions trap group
  netdevsim: Move layer 3 exceptions to exceptions trap group
  devlink: Add 'mirror' trap action
  devlink: Add 'control' trap type
  devlink: Add layer 2 control packet traps
  devlink: Add layer 3 control packet traps
  devlink: Add ACL control packet traps
  netdevsim: Register control traps
  mlxsw: spectrum_trap: Factor out common Rx listener function
  mlxsw: spectrum_trap: Register layer 2 control traps
  mlxsw: spectrum_trap: Register layer 3 control traps
  mlxsw: spectrum_trap: Register ACL control traps
  selftests: mlxsw: Add test for control packets

 .../networking/devlink/devlink-trap.rst       | 219 +++++-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 149 +---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   4 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 583 ++++++++++++++-
 drivers/net/netdevsim/dev.c                   |  10 +-
 include/net/devlink.h                         | 189 +++++
 include/uapi/linux/devlink.h                  |   9 +
 net/core/devlink.c                            |  73 +-
 .../drivers/net/mlxsw/devlink_trap_control.sh | 688 ++++++++++++++++++
 .../selftests/net/forwarding/devlink_lib.sh   |  23 +
 11 files changed, 1781 insertions(+), 168 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_control.sh

-- 
2.26.2

