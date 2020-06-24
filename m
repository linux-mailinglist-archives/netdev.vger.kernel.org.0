Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C933206EDC
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390314AbgFXIUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:20:20 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:43255 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387606AbgFXIUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:20:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1457C580519;
        Wed, 24 Jun 2020 04:20:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 24 Jun 2020 04:20:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yV27zIQ4XlJ/xx6zt
        NwDIA2QmILpO4HuOAPtqwcEOug=; b=vbcrgGBIdsa2Pfkhngpc6rzcAEjdMo+Vq
        Fd+5nxmWdkE01gb8GF5UMXxqvNQJ605FlvkO7uK6vzAUQjvaHB6Ad3g/WNDDCAfv
        8f1ftTTMa3mTc/0fg2md4qwS31JxKjf9AUWks5SgbC8fslUuP7iyuTx4kN0fUCoQ
        3NcTfjk+LQ4T6ohbr53nwjtSBHh0S26lBaLDU+WpZzEw3RPmx3gv2ja0pmHlgYLE
        iN6VMa49wPkKDE7ZDJxaUw3ZI2CkbJ2S6ju6UzNEMfbebYbRa2YGikub3mmKw3J7
        1+keUFMplhk+iTod4jQK2tNJjqR+8ICS945X3/yeDblW4/v/gmRiA==
X-ME-Sender: <xms:vwzzXqnvA2kuHOACpbZKMiPwwgGkB5lrjjgU7m60k-Ys2FkGqhJzLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekjedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeduleefrdegjedrudeihedrvdehuden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:vwzzXh39wAVaeVyNVl6iJmbXJrP_8iOWn1VYTJC1he75cHqpiGdh1A>
    <xmx:vwzzXoorsEoM4vCg8ue6xwbgWJi9phLW9QqEM6IpF4MNFor3B071mw>
    <xmx:vwzzXunxOygDnHpsSOEb0dCL1I-1XZLRA-Xt-4CjFB1KDhWpuB8foA>
    <xmx:wgzzXpIKSQlQkQ21dglUMItnGDM_z7eE_nVhGkYa53ky-8urd8jEFA>
Received: from shredder.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BB36230675F9;
        Wed, 24 Jun 2020 04:20:12 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/10] Add ethtool extended link state
Date:   Wed, 24 Jun 2020 11:19:13 +0300
Message-Id: <20200624081923.89483-1-idosch@idosch.org>
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

 Documentation/networking/ethtool-netlink.rst  |  110 +-
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |    3 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   51 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 1540 +--------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   45 +
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    |    6 +-
 .../mellanox/mlxsw/spectrum_ethtool.c         | 1644 +++++++++++++++++
 include/linux/ethtool.h                       |   22 +
 include/uapi/linux/ethtool.h                  |   70 +
 include/uapi/linux/ethtool_netlink.h          |    2 +
 net/ethtool/linkstate.c                       |   56 +-
 .../selftests/net/forwarding/ethtool.sh       |   17 -
 .../net/forwarding/ethtool_extended_state.sh  |  102 +
 .../selftests/net/forwarding/ethtool_lib.sh   |   17 +
 .../net/forwarding/forwarding.config.sample   |    3 +
 15 files changed, 2124 insertions(+), 1564 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_extended_state.sh

-- 
2.26.2

