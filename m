Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6224B20E08F
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389776AbgF2UrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:47:23 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:53523 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389767AbgF2UrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:47:21 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id BF2445800BF;
        Mon, 29 Jun 2020 16:47:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 29 Jun 2020 16:47:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UQaBCYHdyLLUGT958
        QbQSP1rtUNF8ar9qZIpu5Oor7M=; b=pKH/S5kVnvtjwQCdeJ3g9jdB1IaOHZtGz
        BSFrxs/LsTHOCpOXKS2Dq+nHyvCJILy0MCwV5q+mTXGEkSmm3Ws+pIn6I/J5Iaca
        ObzxXcKGi5RY4CHI4S84N5YixbCw1B7L6N3CrUM+ENE3nOlfwqv5WyLVYHlz1zr0
        gbNd3OWeyDvDWcVedNaWrq2shP6olsCZP2r6Y5cQUdSbtZxmluM+n4dZXfUxmqMy
        sraWpkyTUAoo6z8LOFDRk6olFBEQvKm56fNvRPz50kQk+hav1NpkKlEaxhOVqe25
        nn7EqnrdzU4aQEuW+hwzCMMrDjdS3M9LJremoQL0Uz5GNRGrn5Dqw==
X-ME-Sender: <xms:VVP6XpiNUMIqKiSV0TB2i5PzT2b4JMOiLKq3pY7uBt4flSAA9NVJDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelledgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppedutdelrdeiiedrudelrddufeefnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:VVP6XuD1mLvy9QQ2NV5ZDAdhU_ur-h9aDw40nbfyvIYY88fNogV07w>
    <xmx:VVP6XpFI6C4oWhOoEfTH8NhXlf7OxwTs-Xna8PRu0MaoFDLVuibHTg>
    <xmx:VVP6XuSXqJKNytAblhhuvcYwU_ZQ-CNFIgFyh6ksicdrOjYz_ibZoA>
    <xmx:V1P6Xll37jJrvSprb9YJh6w-sWSxAPZE2iZc3XVCocBjISGxgFxPGw>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4C6FB328005D;
        Mon, 29 Jun 2020 16:47:14 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 00/10] Add ethtool extended link state
Date:   Mon, 29 Jun 2020 23:46:11 +0300
Message-Id: <20200629204621.377239-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Amit says:

Currently, device drivers can only indicate to user space if the network
link is up or down, without additional information.

This patch set provides an infrastructure that allows these drivers to
expose more information to user space about the link state. The
information can save users' time when trying to understand why a link is
not operationally up, for example.

The above is achieved by extending the existing ethtool LINKSTATE_GET
command with attributes that carry the extended state.

For example, no link due to missing cable:

$ ethtool ethX
...
Link detected: no (No cable)

Beside the general extended state, drivers can pass additional
information about the link state using the sub-state field. For example:

$ ethtool ethX
...
Link detected: no (Autoneg, No partner detected)

In the future the infrastructure can be extended - for example - to
allow PHY drivers to report whether a downshift to a lower speed
occurred. Something like:

$ ethtool ethX
...
Link detected: yes (downshifted)

Patch set overview:

Patches #1-#3 move mlxsw ethtool code to a separate file
Patches #4-#5 add the ethtool infrastructure for extended link state
Patches #6-#7 add support of extended link state in the mlxsw driver
Patches #8-#10 add test cases

Changes since v1:

* In documentation, show ETHTOOL_LINK_EXT_STATE_* and
  ETHTOOL_LINK_EXT_SUBSTATE_* constants instead of user-space strings
* Add `_CI_` to cable_issue substates to be consistent with
  other substates
* Keep the commit messages within 75 columns
* Use u8 variable for __link_ext_substate
* Document the meaning of -ENODATA in get_link_ext_state() callback
  description
* Do not zero data->link_ext_state_provided after getting an error
* Use `ret` variable for error value

Changes since RFC:

* Move documentation patch before ethtool patch
* Add nla_total_size() instead of sizeof() directly
* Return an error code from linkstate_get_ext_state()
* Remove SHORTED_CABLE, add CABLE_TEST_FAILURE instead
* Check if the interface is administratively up before setting ext_state
* Document all sub-states

Amit Cohen (10):
  mlxsw: spectrum_dcb: Rename mlxsw_sp_port_headroom_set()
  mlxsw: Move ethtool_ops to spectrum_ethtool.c
  mlxsw: spectrum_ethtool: Move mlxsw_sp_port_type_speed_ops structs
  Documentation: networking: ethtool-netlink: Add link extended state
  ethtool: Add link extended state
  mlxsw: reg: Port Diagnostics Database Register
  mlxsw: spectrum_ethtool: Add link extended state
  selftests: forwarding: ethtool: Move different_speeds_get() to
    ethtool_lib
  selftests: forwarding: forwarding.config.sample: Add port with no
    cable connected
  selftests: forwarding: Add tests for ethtool extended state

 Documentation/networking/ethtool-netlink.rst  |  128 +-
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |    3 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   51 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 1540 +--------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   45 +
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    |    6 +-
 .../mellanox/mlxsw/spectrum_ethtool.c         | 1644 +++++++++++++++++
 include/linux/ethtool.h                       |   23 +
 include/uapi/linux/ethtool.h                  |   70 +
 include/uapi/linux/ethtool_netlink.h          |    2 +
 net/ethtool/linkstate.c                       |   52 +-
 .../selftests/net/forwarding/ethtool.sh       |   17 -
 .../net/forwarding/ethtool_extended_state.sh  |  102 +
 .../selftests/net/forwarding/ethtool_lib.sh   |   17 +
 .../net/forwarding/forwarding.config.sample   |    3 +
 15 files changed, 2140 insertions(+), 1563 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_extended_state.sh

-- 
2.26.2

