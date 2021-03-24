Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4088346EB2
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbhCXBbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbhCXBbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:31:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F6C4C061763;
        Tue, 23 Mar 2021 18:31:09 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7BBDE62C0E;
        Wed, 24 Mar 2021 02:30:59 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 00/24] netfilter: flowtable enhancements
Date:   Wed, 24 Mar 2021 02:30:31 +0100
Message-Id: <20210324013055.5619-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

[ This is v2 that includes documentation enhancements, including
  existing limitations. This is a rebase on top on net-next. ]

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

Patch #24 extends the documentation and describe existing limitations.

Please, apply, thanks.

Felix Fietkau (7):
  net: bridge: resolve forwarding path for VLAN tag actions in bridge devices
  net: ppp: resolve forwarding path for bridge pppoe devices
  net: dsa: resolve forwarding path for dsa slave ports
  netfilter: flowtable: bridge vlan hardware offload and switchdev
  net: ethernet: mtk_eth_soc: fix parsing packets in GDM
  net: ethernet: mtk_eth_soc: add support for initializing the PPE
  net: ethernet: mtk_eth_soc: add flow offloading support

Pablo Neira Ayuso (17):
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
  docs: nf_flowtable: update documentation with enhancements

 Documentation/networking/nf_flowtable.rst     | 170 +++++-
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
 net/netfilter/nf_flow_table_ip.c              | 252 +++++++--
 net/netfilter/nf_flow_table_offload.c         | 179 ++++--
 net/netfilter/nft_flow_offload.c              | 211 +++++++-
 .../selftests/netfilter/nft_flowtable.sh      |  82 +++
 26 files changed, 2892 insertions(+), 146 deletions(-)
 create mode 100644 drivers/net/ethernet/mediatek/mtk_ppe.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_ppe.h
 create mode 100644 drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_ppe_offload.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_ppe_regs.h

--
2.20.1

