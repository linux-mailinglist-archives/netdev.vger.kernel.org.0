Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4379621AC10
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 02:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgGJAm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 20:42:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgGJAmz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 20:42:55 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE0202065D;
        Fri, 10 Jul 2020 00:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594341775;
        bh=4dgnEreX/57rT5iLLOYPxBVwyuQhFUNStVnX2tc5MC8=;
        h=From:To:Cc:Subject:Date:From;
        b=sEs4RNMbqQNLNL1b38I5tuquyncqXD1kfWpqLmCyCPTaLNlE540eMbjQfhhUJMhtn
         7kgpoc4II56LtAKGOvJqrHcL23yU+FeK25wVt0v2RxY2gjZ+VJLjzxl2scKs3sCoNI
         jkinkaclQ2qlO8p+j3Q2RqYh5nT2TAbwPgXMcowg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, emil.s.tantilov@intel.com,
        alexander.h.duyck@linux.intel.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v4 00/10] udp_tunnel: add NIC RX port offload infrastructure
Date:   Thu,  9 Jul 2020 17:42:43 -0700
Message-Id: <20200710004253.211130-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel has a facility to notify drivers about the UDP tunnel ports
so that devices can recognize tunneled packets. This is important
mostly for RX - devices which don't support CHECKSUM_COMPLETE can
report checksums of inner packets, and compute RSS over inner headers.
Some drivers also match the UDP tunnel ports also for TX, although
doing so may lead to false positives and negatives.

Unfortunately the user experience when trying to take adavantage
of these facilities is suboptimal. First of all there is no way
for users to check which ports are offloaded. Many drivers resort
to printing messages to aid debugging, other use debugfs. Even worse
the availability of the RX features (NETIF_F_RX_UDP_TUNNEL_PORT)
is established purely on the basis of the driver having the ndos
installed. For most drivers, however, the ability to perform offloads
is contingent on device capabilities (driver support multiple device
and firmware versions). Unless driver resorts to hackish clearing
of features set incorrectly by the core - users are left guessing
whether their device really supports UDP tunnel port offload or not.

There is currently no way to indicate or configure whether RX
features include just the checksum offload or checksum and using
inner headers for RSS. Many drivers default to not using inner
headers for RSS because most implementations populate the source
port with entropy from the inner headers. This, however, is not
always the case, for example certain switches are only able to
use a fixed source port during encapsulation.

We have also seen many driver authors get the intricacies of UDP
tunnel port offloads wrong. Most commonly the drivers forget to
perform reference counting, or take sleeping locks in the callbacks.

This work tries to improve the situation by pulling the UDP tunnel
port table maintenance out of the drivers. It turns out that almost
all drivers maintain a fixed size table of ports (in most cases one
per tunnel type), so we can take care of all the refcounting in the
core, and let the driver specify if they need to sleep in the
callbacks or not. The new common implementation will also support
replacing ports - when a port is removed from a full table it will
try to find a previously missing port to take its place.

This patch only implements the core functionality along with a few
drivers I was hoping to test manually [1] along with a test based
on a netdevsim implementation. Following patches will convert all
the drivers. Once that's complete we can remove the ndos, and rely
directly on the new infrastrucutre.

Then after RSS (RXFH) is converted to netlink we can add the ability
to configure the use of inner RSS headers for UDP tunnels.

[1] Unfortunately I wasn't able to, turns out 2 of the devices
I had access to were older generation or had old FW, and they
did not actually support UDP tunnel port notifications (see
the second paragraph). The thrid device appears to program
the UDP ports correctly but it generates bad UDP checksums with
or without these patches. Long story short - I'd appreciate
reviews and testing here..

v4:
 - better build fix (hopefully this one does it..)
v3:
 - fix build issue;
 - improve bnxt changes.

Jakub Kicinski (10):
  debugfs: make sure we can remove u32_array files cleanly
  udp_tunnel: re-number the offload tunnel types
  udp_tunnel: add central NIC RX port offload infrastructure
  ethtool: add tunnel info interface
  netdevsim: add UDP tunnel port offload support
  selftests: net: add a test for UDP tunnel info infra
  ixgbe: don't clear UDP tunnel ports when RXCSUM is disabled
  ixgbe: convert to new udp_tunnel_nic infra
  bnxt: convert to new udp_tunnel_nic infra
  mlx4: convert to new udp_tunnel_nic infra

 Documentation/filesystems/debugfs.rst         |  12 +-
 Documentation/networking/ethtool-netlink.rst  |  33 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 141 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  12 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |   3 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 200 +---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 107 +--
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |   2 -
 drivers/net/geneve.c                          |   6 +-
 drivers/net/netdevsim/Makefile                |   2 +-
 drivers/net/netdevsim/dev.c                   |   1 +
 drivers/net/netdevsim/netdev.c                |  12 +-
 drivers/net/netdevsim/netdevsim.h             |  19 +
 drivers/net/netdevsim/udp_tunnels.c           | 192 ++++
 drivers/net/vxlan.c                           |   6 +-
 fs/debugfs/file.c                             |  27 +-
 include/linux/debugfs.h                       |  12 +-
 include/linux/netdevice.h                     |   8 +
 include/net/udp_tunnel.h                      | 164 +++-
 include/uapi/linux/ethtool.h                  |   2 +
 include/uapi/linux/ethtool_netlink.h          |  55 ++
 mm/cma.h                                      |   3 +
 mm/cma_debug.c                                |   7 +-
 net/ethtool/Makefile                          |   3 +-
 net/ethtool/common.c                          |   9 +
 net/ethtool/common.h                          |   1 +
 net/ethtool/netlink.c                         |  12 +
 net/ethtool/netlink.h                         |   4 +
 net/ethtool/strset.c                          |   5 +
 net/ethtool/tunnels.c                         | 259 +++++
 net/ipv4/Makefile                             |   3 +-
 net/ipv4/{udp_tunnel.c => udp_tunnel_core.c}  |   0
 net/ipv4/udp_tunnel_nic.c                     | 890 ++++++++++++++++++
 net/ipv4/udp_tunnel_stub.c                    |   7 +
 .../drivers/net/netdevsim/udp_tunnel_nic.sh   | 786 ++++++++++++++++
 35 files changed, 2608 insertions(+), 397 deletions(-)
 create mode 100644 drivers/net/netdevsim/udp_tunnels.c
 create mode 100644 net/ethtool/tunnels.c
 rename net/ipv4/{udp_tunnel.c => udp_tunnel_core.c} (100%)
 create mode 100644 net/ipv4/udp_tunnel_nic.c
 create mode 100644 net/ipv4/udp_tunnel_stub.c
 create mode 100644 tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh

-- 
2.26.2

