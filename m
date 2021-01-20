Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473912FCED4
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbhATLJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:09:14 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18047 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731533AbhATJiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 04:38:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6007f9d80000>; Wed, 20 Jan 2021 01:37:28 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 20 Jan 2021 09:37:25 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <mkubecek@suse.cz>,
        <mlxsw@nvidia.com>, <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v3 0/7] Support setting lanes via ethtool
Date:   Wed, 20 Jan 2021 11:37:06 +0200
Message-ID: <20210120093713.4000363-1-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611135448; bh=Vdpd6/Xia9xow9mF96nY3CfNrbb2FXETyM8EzE7yLj4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=q8SImyKSGY+7YmmzNOmaXFT3kygczZ+YjAXbyf5noEn+e9XCdhjnyfSZ/f3ajb2hj
         uNlYn3B1xMp+VUdus8l8bVin4nIqG/1ZHYNFNSh6En78dez0fqxO9RNP3ZzaCEC8C0
         iQhOC+rW/odU8GKIUijlEhYPnVDGNbneNmYZA0Xzi4+8tGihdi9AMlRtBV5vEPd6NX
         9I6Sl9lw7qACqxi+sM+m5YvbTrSM6t3TrysfsXeVw+W+yUInFGqkWi68ZaCa45ONri
         2g/7EKLO50wezUHeVQcocf4iAVhzTotum2HYk3RFGZtTDfS92ySK7lA22OyTasI7Vu
         q9oSUiOL87z8g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some speeds can be achieved with different number of lanes. For example,
100Gbps can be achieved using two lanes of 50Gbps or four lanes of
25Gbps. This patchset adds a new selector that allows ethtool to
advertise link modes according to their number of lanes and also force a
specific number of lanes when autonegotiation is off.

Advertising all link modes with a speed of 100Gbps that use two lanes:

$ ethtool -s swp1 speed 100000 lanes 2 autoneg on

Forcing a speed of 100Gbps using four lanes:

$ ethtool -s swp1 speed 100000 lanes 4 autoneg off

Patchset overview:

Patch #1 allows user space to configure the desired number of lanes.

Patch #2-#3 adjusts ethtool to dump to user space the number of lanes
currently in use.

Patches #4-#6 add support for lanes configuration in mlxsw.

Patch #7 adds a selftest.

v3:
	* Patch #1: Change ethtool_ops.capabilities to be a bitfield,
	  and set min and max for the lanes policy.
	* Patch #2: Remove LINK_MODE_UNKNOWN and move the speed, duplex
	  and lanes derivation to the wrapper
	  __ethtool_get_link_ksettings().
	* Patch #5: Set the bitfield of supporting lanes in the driver to 'true'.
	* Patch #7: Move the test to drivers/net/mlxsw.

v2:
	* Patch #1: Remove ETHTOOL_LANES defines and simply use a number
	  instead.
	* Patches #2,#6: Pass link mode from driver to ethtool instead
	* of the parameters themselves.
	* Patch #5: Add an actual width field for spectrum-2 link modes
	  in order to set the suitable link mode when lanes parameter is
	  passed.
	* Patch #6: Changed lanes to be unsigned in
	  'struct link_mode_info'.
	* Patch #7: Remove the test for recieving max_width when lanes
	* is not set by user. When not setting lanes, we don't promise
	  anything regarding what number of lanes will be chosen.

Danielle Ratson (7):
  ethtool: Extend link modes settings uAPI with lanes
  ethtool: Get link mode in use instead of speed and duplex parameters
  ethtool: Expose the number of lanes in use
  mlxsw: ethtool: Remove max lanes filtering
  mlxsw: ethtool: Add support for setting lanes when autoneg is off
  mlxsw: ethtool: Pass link mode in use to ethtool
  net: selftests: Add lanes setting test

 Documentation/networking/ethtool-netlink.rst  |  11 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  13 +-
 .../mellanox/mlxsw/spectrum_ethtool.c         | 196 +++++++++++-------
 include/linux/ethtool.h                       |   5 +
 include/uapi/linux/ethtool.h                  |   2 +
 include/uapi/linux/ethtool_netlink.h          |   1 +
 net/ethtool/common.c                          | 114 ++++++++++
 net/ethtool/common.h                          |   7 +
 net/ethtool/ioctl.c                           |  18 +-
 net/ethtool/linkmodes.c                       | 179 +++++-----------
 net/ethtool/netlink.h                         |   2 +-
 .../drivers/net/mlxsw/ethtool_lanes.sh        | 188 +++++++++++++++++
 .../selftests/net/forwarding/ethtool_lib.sh   |  34 +++
 tools/testing/selftests/net/forwarding/lib.sh |  28 +++
 14 files changed, 576 insertions(+), 222 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/ethtool_lanes=
.sh

--=20
2.26.2

