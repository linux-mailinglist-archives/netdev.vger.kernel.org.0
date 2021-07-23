Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53013D36AE
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 10:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhGWHtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 03:49:19 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33968 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234276AbhGWHtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 03:49:14 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id E2865213D2; Fri, 23 Jul 2021 16:29:45 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: [PATCH net-next v3 00/16] Add Management Component Transport Protocol support
Date:   Fri, 23 Jul 2021 16:29:16 +0800
Message-Id: <20210723082932.3570396-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds core MCTP support to the kernel. From the Kconfig
description:

  Management Component Transport Protocol (MCTP) is an in-system
  protocol for communicating between management controllers and
  their managed devices (peripherals, host processors, etc.). The
  protocol is defined by DMTF specification DSP0236.

  This option enables core MCTP support. For communicating with other
  devices, you'll want to enable a driver for a specific hardware
  channel.

This implementation allows a sockets-based API for sending and receiving
MCTP messages via sendmsg/recvmsg on SOCK_DGRAM sockets. Kernel stack
control is all via netlink, using existing RTM_* messages. The userspace
ABI change is fairly small; just the necessary AF_/ETH_P_/ARPHDR_
constants, a new sockaddr, and a new netlink attribute.

For MAINTAINERS, I've just included netdev@ as the list entry. I'm happy
to alter this based on preferences here - an alternative would be the
OpenBMC list (the main user of the MCTP interface), or we can create a
new list entirely.

We have a couple of interface drivers almost ready to go at the moment,
but those can wait until the core code has some review.

This is v3 of the series, but v1 and v2 were both RFC.

Review, comments, questions etc. are most welcome.

Cheers,


Jeremy

v2:
 - change to match spec terminology: controller -> component
 - require specific capabilities for bind() & sendmsg()
 - add address and tag defintions to uapi
 - add selinux AF_MCTP table definitions
 - remove strict cflags; warnings are present in common headers

v3:
 - comment typo fixes
 - switch to an array for local EIDs
 - fix addrinfo dump iteration & error path
 - add RTM_DELADDR
 - remove GENMASK() and BIT() from uapi

Jeremy Kerr (10):
  mctp: Add MCTP base
  mctp: Add base socket/protocol definitions
  mctp: Add base packet definitions
  mctp: Add sockaddr_mctp to uapi
  mctp: Add initial driver infrastructure
  mctp: Add device handling and netlink interface
  mctp: Add initial routing framework
  mctp: Populate socket implementation
  mctp: Implement message fragmentation & reassembly
  mctp: Add MCTP overview document

Matt Johnston (6):
  mctp: Add netlink route management
  mctp: Add neighbour implementation
  mctp: Add neighbour netlink interface
  mctp: Add dest neighbour lladdr to route output
  mctp: Allow per-netns default networks
  mctp: Allow MCTP on tun devices

 Documentation/networking/index.rst  |    1 +
 Documentation/networking/mctp.rst   |  213 ++++++
 MAINTAINERS                         |   12 +
 drivers/net/Kconfig                 |    2 +
 drivers/net/Makefile                |    1 +
 drivers/net/mctp/Kconfig            |    8 +
 drivers/net/mctp/Makefile           |    0
 include/linux/netdevice.h           |    3 +
 include/linux/socket.h              |    6 +-
 include/net/mctp.h                  |  235 ++++++
 include/net/mctpdevice.h            |   36 +
 include/net/net_namespace.h         |    4 +
 include/net/netns/mctp.h            |   36 +
 include/uapi/linux/if_arp.h         |    1 +
 include/uapi/linux/if_ether.h       |    3 +
 include/uapi/linux/if_link.h        |   10 +
 include/uapi/linux/mctp.h           |   36 +
 net/Kconfig                         |    1 +
 net/Makefile                        |    1 +
 net/mctp/Kconfig                    |   13 +
 net/mctp/Makefile                   |    3 +
 net/mctp/af_mctp.c                  |  396 ++++++++++
 net/mctp/device.c                   |  427 +++++++++++
 net/mctp/neigh.c                    |  342 +++++++++
 net/mctp/route.c                    | 1095 +++++++++++++++++++++++++++
 security/selinux/hooks.c            |    4 +-
 security/selinux/include/classmap.h |    4 +-
 27 files changed, 2890 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/networking/mctp.rst
 create mode 100644 drivers/net/mctp/Kconfig
 create mode 100644 drivers/net/mctp/Makefile
 create mode 100644 include/net/mctp.h
 create mode 100644 include/net/mctpdevice.h
 create mode 100644 include/net/netns/mctp.h
 create mode 100644 include/uapi/linux/mctp.h
 create mode 100644 net/mctp/Kconfig
 create mode 100644 net/mctp/Makefile
 create mode 100644 net/mctp/af_mctp.c
 create mode 100644 net/mctp/device.c
 create mode 100644 net/mctp/neigh.c
 create mode 100644 net/mctp/route.c

-- 
2.30.2

