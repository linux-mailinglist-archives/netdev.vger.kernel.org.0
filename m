Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69D83368CC
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhCKAgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:36:42 -0500
Received: from correo.us.es ([193.147.175.20]:49994 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhCKAgM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 19:36:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E3EA512E82A
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C7D18DA78A
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:10 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BCCD8DA73F; Thu, 11 Mar 2021 01:36:10 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5409DDA704;
        Thu, 11 Mar 2021 01:36:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 01:36:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 1F9EC42DC6E2;
        Thu, 11 Mar 2021 01:36:08 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next 00/23] netfilter: flowtable enhancements
Date:   Thu, 11 Mar 2021 01:35:41 +0100
Message-Id: <20210311003604.22199-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset augments the Netfilter flowtable fastpath to
support for network topologies that combine IP forwarding, bridge,
classic VLAN devices, bridge VLAN filtering, DSA and PPPoE. This
includes support for the flowtable software and hardware datapaths.

The following pictures provides an example scenario:

                        fast path!
                .------------------------.
               /                          \
               |           IP forwarding  |
               |          /             \ \/
               |       br0               wan ..... eth0
               .       / \                         host C
               -> veth1  veth2
                   .           switch/router
                   .
                   .
                 eth0
		host A

The bridge master device 'br0' has an IP address and a DHCP server is
also assumed to be running to provide connectivity to host A which
reaches the Internet through 'br0' as default gateway. Then, packet
enters the IP forwarding path and Netfilter is used to NAT the packets
before they leave through the wan device.

The general idea is to accelerate forwarding by building a fast path
that takes packets from the ingress path of the bridge port and place
them in the egress path of the wan device (and vice versa). Hence,
skipping the classic bridge and IP stack paths.

** Patch from #1 to #6 add the infrastructure which describes the list of
   netdevice hops to reach a given destination MAC address in the local
   network topology.

Patch #1 adds dev_fill_forward_path() and .ndo_fill_forward_path() to
         netdev_ops.

Patch #2 adds .ndo_fill_forward_path for vlan devices, which provides
	 the next device hop via vlan->real_dev, the vlan ID and the
         protocol.

Patch #3 adds .ndo_fill_forward_path for bridge devices, which allows to make
         lookups to the FDB to locate the next device hop (bridge port) in the
         forwarding path.

Patch #4 extends bridge .ndo_fill_forward_path to support for bridge VLAN
	 filtering.

Patch #5 adds .ndo_fill_forward_path for PPPoE devices.

Patch #6 adds .ndo_fill_forward_path for DSA.

Patches from #7 to #14 update the flowtable software datapath:

Patch #7 adds the transmit path type field to the flow tuple. Two transmit
         paths are supported so far: the neighbour and the xfrm transmit
         paths.

Patch #8 and #9 update the flowtable datapath to use dev_fill_forward_path()
         to obtain the real ingress/egress device for the flowtable datapath.
	 This adds the new ethernet xmit direct path to the flowtable.

Patch #10 adds native flowtable VLAN support (up to 2 VLAN tags) through
          dev_fill_forward_path(). The flowtable stores the VLAN id and
          protocol in the flow tuple.

Patch #11 adds native flowtable bridge VLAN filter support through
          dev_fill_forward_path().

Patch #12 adds native flowtable bridge PPPoE through dev_fill_forward_path().

Patch #13 adds DSA support through dev_fill_forward_path().

Patch #14 extends flowtable selftests to cover for flowtable software
	  datapath enhancements.

** Patches from #15 to #20 update the flowtable hardware offload datapath:

Patch #15 extends the flowtable hardware offload to support for the
          direct ethernet xmit path. This also includes VLAN support.

Patch #16 stores the egress real device in the flow tuple. The software
          flowtable datapath uses dev_hard_header() to transmit packets,
          hence it might refer to VLAN/DSA/PPPoE software device, not
          the real ethernet device.

Patch #17 deals with switchdev PVID hardware offload to skip it on
	  egress.

Patch #18 adds FLOW_ACTION_PPPOE_PUSH to the flow_offload action API.

Patch #19 extends the flowtable hardware offload to support for PPPoE

Patch #20 adds TC_SETUP_FT support for DSA.

** Patches from #20 to #23: Felix Fietkau adds a new driver which support
   hardware offload for the mtk PPE engine through the existing flow
   offload API which supports for the flowtable enhancements coming in
   this batch.

Felix Fietkau (7):
  net: bridge: resolve forwarding path for VLAN tag actions in bridge devices
  net: ppp: resolve forwarding path for bridge pppoe devices
  net: dsa: resolve forwarding path for dsa slave ports
  netfilter: flowtable: bridge vlan hardware offload and switchdev
  net: ethernet: mtk_eth_soc: add support for initializing the PPE
  net: ethernet: mtk_eth_soc: add flow offloading support
  net: ethernet: mtk_eth_soc: fix parsing packets in GDM

Pablo Neira Ayuso (16):
  net: resolve forwarding path from virtual netdevice and HW destination address
  net: 8021q: resolve forwarding path for vlan devices
  net: bridge: resolve forwarding path for bridge devices
  netfilter: flowtable: add xmit path types
  netfilter: flowtable: use dev_fill_forward_path() to obtain ingress device
  netfilter: flowtable: use dev_fill_forward_path() to obtain egress device
  netfilter: flowtable: add vlan support
  netfilter: flowtable: add bridge vlan filtering support
  netfilter: flowtable: add pppoe support
  netfilter: flowtable: add dsa support
  selftests: netfilter: flowtable bridge and vlan support
  netfilter: flowtable: add offload support for xmit path types
  netfilter: nft_flow_offload: use direct xmit if hardware offload is enabled
  net: flow_offload: add FLOW_ACTION_PPPOE_PUSH
  netfilter: flowtable: support for FLOW_ACTION_PPPOE_PUSH
  dsa: slave: add support for TC_SETUP_FT

 drivers/net/ethernet/mediatek/Makefile        |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  41 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  23 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c       | 511 ++++++++++++++++++
 drivers/net/ethernet/mediatek/mtk_ppe.h       | 287 ++++++++++
 .../net/ethernet/mediatek/mtk_ppe_debugfs.c   | 217 ++++++++
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 485 +++++++++++++++++
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h  | 144 +++++
 drivers/net/ppp/ppp_generic.c                 |  22 +
 drivers/net/ppp/pppoe.c                       |  23 +
 include/linux/netdevice.h                     |  59 ++
 include/linux/ppp_channel.h                   |   3 +
 include/net/flow_offload.h                    |   4 +
 include/net/netfilter/nf_flow_table.h         |  47 +-
 net/8021q/vlan_dev.c                          |  21 +
 net/bridge/br_device.c                        |  49 ++
 net/bridge/br_private.h                       |  20 +
 net/bridge/br_vlan.c                          |  55 ++
 net/core/dev.c                                |  46 ++
 net/dsa/slave.c                               |  36 +-
 net/netfilter/nf_flow_table_core.c            |  49 +-
 net/netfilter/nf_flow_table_ip.c              | 270 +++++++--
 net/netfilter/nf_flow_table_offload.c         | 179 ++++--
 net/netfilter/nft_flow_offload.c              | 211 +++++++-
 .../selftests/netfilter/nft_flowtable.sh      |  82 +++
 25 files changed, 2768 insertions(+), 118 deletions(-)
 create mode 100644 drivers/net/ethernet/mediatek/mtk_ppe.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_ppe.h
 create mode 100644 drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_ppe_offload.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_ppe_regs.h

-- 
2.20.1

