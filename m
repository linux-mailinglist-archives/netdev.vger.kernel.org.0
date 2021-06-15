Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FEA3A7AC5
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 11:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhFOJij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 05:38:39 -0400
Received: from inva020.nxp.com ([92.121.34.13]:56350 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231187AbhFOJii (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 05:38:38 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7FF6B1A049D;
        Tue, 15 Jun 2021 11:36:32 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 37EBC1A0466;
        Tue, 15 Jun 2021 11:36:26 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id AC0D040338;
        Tue, 15 Jun 2021 17:36:17 +0800 (+08)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, mptcp@lists.linux.dev,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: [net-next, v3, 00/10] ptp: support virtual clocks and timestamping
Date:   Tue, 15 Jun 2021 17:45:07 +0800
Message-Id: <20210615094517.48752-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current PTP driver exposes one PTP device to user which binds network
interface/interfaces to provide timestamping. Actually we have a way
utilizing timecounter/cyclecounter to virtualize any number of PTP
clocks based on a same free running physical clock for using.
The purpose of having multiple PTP virtual clocks is for user space
to directly/easily use them for multiple domains synchronization.

user
space:     ^                                  ^
           | SO_TIMESTAMPING new flag:        | Packets with
           | SOF_TIMESTAMPING_BIND_PHC        | TX/RX HW timestamps
           v                                  v
         +--------------------------------------------+
sock:    |     sock (new member sk_bind_phc)          |
         +--------------------------------------------+
           ^                                  ^
           | ethtool_op_get_phc_vclocks       | Convert HW timestamps
           |                                  | to sk_bind_phc
           v                                  v
         +--------------+--------------+--------------+
vclock:  | ptp1         | ptp2         | ptpN         |
         +--------------+--------------+--------------+
pclock:  |             ptp0 free running              |
         +--------------------------------------------+

The block diagram may explain how it works. Besides the PTP virtual
clocks, the packet HW timestamp converting to the bound PHC is also
done in sock driver. For user space, PTP virtual clocks can be
created via sysfs, and extended SO_TIMESTAMPING API (new flag
SOF_TIMESTAMPING_BIND_PHC) can be used to bind one PTP virtual clock
for timestamping.

The test tool timestamping.c (together with linuxptp phc_ctl tool) can
be used to verify:

  # echo 4 > /sys/class/ptp/ptp0/n_vclocks
  [  129.399472] ptp ptp0: new virtual clock ptp2
  [  129.404234] ptp ptp0: new virtual clock ptp3
  [  129.409532] ptp ptp0: new virtual clock ptp4
  [  129.413942] ptp ptp0: new virtual clock ptp5
  [  129.418257] ptp ptp0: guarantee physical clock free running
  #
  # phc_ctl /dev/ptp2 set 10000
  # phc_ctl /dev/ptp3 set 20000
  #
  # timestamping eno0 2 SOF_TIMESTAMPING_TX_HARDWARE SOF_TIMESTAMPING_RAW_HARDWARE SOF_TIMESTAMPING_BIND_PHC
  # timestamping eno0 2 SOF_TIMESTAMPING_RX_HARDWARE SOF_TIMESTAMPING_RAW_HARDWARE SOF_TIMESTAMPING_BIND_PHC
  # timestamping eno0 3 SOF_TIMESTAMPING_TX_HARDWARE SOF_TIMESTAMPING_RAW_HARDWARE SOF_TIMESTAMPING_BIND_PHC
  # timestamping eno0 3 SOF_TIMESTAMPING_RX_HARDWARE SOF_TIMESTAMPING_RAW_HARDWARE SOF_TIMESTAMPING_BIND_PHC

Changes for v2:
	- Converted to num_vclocks for creating virtual clocks.
	- Guranteed physical clock free running when using virtual
	  clocks.
	- Fixed build warning.
	- Updated copyright.
Changes for v3:
	- Supported PTP virtual clock in default in PTP driver.
	- Protected concurrency of ptp->num_vclocks accessing.
	- Supported PHC vclocks query via ethtool.
	- Extended SO_TIMESTAMPING API for PHC binding.
	- Converted HW timestamps to PHC bound, instead of previous
	  binding domain value to PHC idea.
	- Other minor fixes.

Yangbo Lu (10):
  ptp: add ptp virtual clock driver framework
  ptp: support ptp physical/virtual clocks conversion
  ptp: track available ptp vclocks information
  ptp: add kernel API ptp_get_vclocks_index()
  ethtool: add a new command for getting PHC virtual clocks
  ptp: add kernel API ptp_convert_timestamp()
  net: sock: extend SO_TIMESTAMPING for PHC binding
  net: socket: support hardware timestamp conversion to PHC bound
  selftests/net: timestamping: support binding PHC
  MAINTAINERS: add entry for PTP virtual clock driver

 Documentation/ABI/testing/sysfs-ptp        |  13 ++
 MAINTAINERS                                |   7 +
 drivers/ptp/Makefile                       |   2 +-
 drivers/ptp/ptp_clock.c                    |  27 ++-
 drivers/ptp/ptp_private.h                  |  34 ++++
 drivers/ptp/ptp_sysfs.c                    |  95 +++++++++
 drivers/ptp/ptp_vclock.c                   | 212 +++++++++++++++++++++
 include/linux/ethtool.h                    |   2 +
 include/linux/ptp_clock_kernel.h           |  29 ++-
 include/net/sock.h                         |   8 +-
 include/uapi/linux/ethtool.h               |  14 ++
 include/uapi/linux/ethtool_netlink.h       |  15 ++
 include/uapi/linux/net_tstamp.h            |  17 +-
 include/uapi/linux/ptp_clock.h             |   5 +
 net/core/sock.c                            |  65 ++++++-
 net/ethtool/Makefile                       |   2 +-
 net/ethtool/common.c                       |  24 +++
 net/ethtool/common.h                       |   2 +
 net/ethtool/ioctl.c                        |  27 +++
 net/ethtool/netlink.c                      |  10 +
 net/ethtool/netlink.h                      |   2 +
 net/ethtool/phc_vclocks.c                  |  86 +++++++++
 net/mptcp/sockopt.c                        |  10 +-
 net/socket.c                               |  19 +-
 tools/testing/selftests/net/timestamping.c |  62 ++++--
 25 files changed, 750 insertions(+), 39 deletions(-)
 create mode 100644 drivers/ptp/ptp_vclock.c
 create mode 100644 net/ethtool/phc_vclocks.c


base-commit: 89212e160b81e778f829b89743570665810e3b13
-- 
2.25.1

