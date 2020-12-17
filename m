Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE6D2DD278
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 14:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgLQNzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 08:55:39 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9902 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgLQNzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 08:55:38 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CxYQ06c18z7G1l;
        Thu, 17 Dec 2020 21:54:16 +0800 (CST)
Received: from [10.67.100.138] (10.67.100.138) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Thu, 17 Dec 2020 21:54:54 +0800
Subject: Re: [PATCH net-next v2 0/7] Support setting lanes via ethtool
To:     Danielle Ratson <danieller@mellanox.com>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <mkubecek@suse.cz>,
        <mlxsw@nvidia.com>, <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
References: <20201217085717.4081793-1-danieller@mellanox.com>
From:   "lipeng (Y)" <lipeng321@huawei.com>
Message-ID: <33839f7a-2196-f7cd-ada3-007b2f630de5@huawei.com>
Date:   Thu, 17 Dec 2020 21:54:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201217085717.4081793-1-danieller@mellanox.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.100.138]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2020/12/17 16:57, Danielle Ratson Ð´µÀ:
> From: Danielle Ratson <danieller@nvidia.com>
>
> Some speeds can be achieved with different number of lanes. For example,
> 100Gbps can be achieved using two lanes of 50Gbps or four lanes of
> 25Gbps. This patch set adds a new selector that allows ethtool to


patch set -> patchset


> advertise link modes according to their number of lanes and also force a
> specific number of lanes when autonegotiation is off.
>
> Advertising all link modes with a speed of 100Gbps that use two lanes:
>
> # ethtool -s swp1 speed 100000 lanes 2 autoneg on
>
> Forcing a speed of 100Gbps using four lanes:
>
> # ethtool -s swp1 speed 100000 lanes 4 autoneg off
>
> Patch set overview:
>
> Patch #1 allows user space to configure the desired number of lanes.
>
> Patch #2-#3 adjusts ethtool to dump to user space the number of lanes
> currently in use.
>
> Patches #4-#6 add support for lanes configuration in mlxsw.
>
> Patch #7 adds a selftest.
>
> v2:
> 	* Patch #1:Remove ETHTOOL_LANES defines and simply use a number
> 	  instead.
> 	* Patches #2,#6: Pass link mode from driver to ethtool instead of
> 	  the parameters themselves.
> 	* Patch #5: Add an actual width field for spectrum-2 link modes
> 	  in order to set the suitable link mode when lanes parameter is
> 	  passed.
> 	* Patch #6: Changed lanes to be unsigned in
> 	  'struct link_mode_info'.
> 	* Patch #7: Remove the test for recieving max_width when lanes is
> 	  not set by user. When not setting lanes, we don't promise
> 	  anything regarding what number of lanes will be chosen.
>
> Danielle Ratson (7):
>    ethtool: Extend link modes settings uAPI with lanes
>    ethtool: Get link mode in use instead of speed and duplex parameters
>    ethtool: Expose the number of lanes in use
>    mlxsw: ethtool: Remove max lanes filtering
>    mlxsw: ethtool: Add support for setting lanes when autoneg is off
>    mlxsw: ethtool: Pass link mode in use to ethtool
>    net: selftests: Add lanes setting test
>
>   Documentation/networking/ethtool-netlink.rst  |  12 +-
>   .../net/ethernet/mellanox/mlxsw/spectrum.h    |  13 +-
>   .../mellanox/mlxsw/spectrum_ethtool.c         | 168 +++++----
>   include/linux/ethtool.h                       |   5 +
>   include/uapi/linux/ethtool.h                  |   4 +
>   include/uapi/linux/ethtool_netlink.h          |   1 +
>   net/ethtool/linkmodes.c                       | 321 +++++++++++-------
>   net/ethtool/netlink.h                         |   2 +-
>   .../selftests/net/forwarding/ethtool_lanes.sh | 186 ++++++++++
>   .../selftests/net/forwarding/ethtool_lib.sh   |  34 ++
>   tools/testing/selftests/net/forwarding/lib.sh |  28 ++
>   11 files changed, 570 insertions(+), 204 deletions(-)
>   create mode 100755 tools/testing/selftests/net/forwarding/ethtool_lanes.sh
>
