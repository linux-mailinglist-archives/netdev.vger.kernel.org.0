Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A743B4050
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 11:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhFYJ0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 05:26:53 -0400
Received: from inva020.nxp.com ([92.121.34.13]:60564 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230217AbhFYJ0x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 05:26:53 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 879CA1A16CF;
        Fri, 25 Jun 2021 11:24:29 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 201EA1A04A8;
        Fri, 25 Jun 2021 11:24:29 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id C8D19183ACDC;
        Fri, 25 Jun 2021 17:24:26 +0800 (+08)
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
Subject: [net-next, v4, 00/11] ptp: support virtual clocks and timestamping
Date:   Fri, 25 Jun 2021 17:35:02 +0800
Message-Id: <20210625093513.38524-1-yangbo.lu@nxp.com>
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
           | ethtool_get_phc_vclocks          | Convert HW timestamps
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
Changes for v4:
	- Used do_aux_work callback for vclock refreshing instead.
	- Used unsigned int for vclocks number, and max_vclocks
	  for limitiation.
	- Fixed mutex locking.
	- Dynamically allocated memory for vclock index storage.
	- Removed ethtool ioctl command for vclocks getting.
	- Updated doc for ethtool phc vclocks get.
	- Converted to mptcp_setsockopt_sol_socket_timestamping().
	- Passed so_timestamping for sock_set_timestamping.
	- Fixed checkpatch/build.
	- Other minor fixed.

Yangbo Lu (11):
  ptp: add ptp virtual clock driver framework
  ptp: support ptp physical/virtual clocks conversion
  ptp: track available ptp vclocks information
  ptp: add kernel API ptp_get_vclocks_index()
  ethtool: add a new command for getting PHC virtual clocks
  ptp: add kernel API ptp_convert_timestamp()
  mptcp: setsockopt: convert to
    mptcp_setsockopt_sol_socket_timestamping()
  net: sock: extend SO_TIMESTAMPING for PHC binding
  net: socket: support hardware timestamp conversion to PHC bound
  selftests/net: timestamping: support binding PHC
  MAINTAINERS: add entry for PTP virtual clock driver

 Documentation/ABI/testing/sysfs-ptp          |  20 ++
 Documentation/networking/ethtool-netlink.rst |  22 ++
 MAINTAINERS                                  |   7 +
 drivers/ptp/Makefile                         |   2 +-
 drivers/ptp/ptp_clock.c                      |  41 +++-
 drivers/ptp/ptp_private.h                    |  39 ++++
 drivers/ptp/ptp_sysfs.c                      | 160 ++++++++++++++
 drivers/ptp/ptp_vclock.c                     | 219 +++++++++++++++++++
 include/linux/ethtool.h                      |  10 +
 include/linux/ptp_clock_kernel.h             |  31 ++-
 include/net/sock.h                           |   8 +-
 include/uapi/linux/ethtool_netlink.h         |  15 ++
 include/uapi/linux/net_tstamp.h              |  17 +-
 net/core/sock.c                              |  65 +++++-
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/common.c                         |  14 ++
 net/ethtool/netlink.c                        |  10 +
 net/ethtool/netlink.h                        |   2 +
 net/ethtool/phc_vclocks.c                    |  94 ++++++++
 net/mptcp/sockopt.c                          |  69 ++++--
 net/socket.c                                 |  19 +-
 tools/testing/selftests/net/timestamping.c   |  62 ++++--
 22 files changed, 875 insertions(+), 53 deletions(-)
 create mode 100644 drivers/ptp/ptp_vclock.c
 create mode 100644 net/ethtool/phc_vclocks.c


base-commit: 19938bafa7ae8fc0a4a2c1c1430abb1a04668da1
-- 
2.25.1

