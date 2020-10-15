Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D779628F6BD
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 18:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389949AbgJOQau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 12:30:50 -0400
Received: from correo.us.es ([193.147.175.20]:47234 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389793AbgJOQat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 12:30:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C8A40E2C4E
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 18:30:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B85C0DA792
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 18:30:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AD8D7DA791; Thu, 15 Oct 2020 18:30:46 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44DCCDA73F;
        Thu, 15 Oct 2020 18:30:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 15 Oct 2020 18:30:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 0423C42EF4E1;
        Thu, 15 Oct 2020 18:30:43 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 0/9] netfilter: flowtable bridge and vlan enhancements
Date:   Thu, 15 Oct 2020 18:30:29 +0200
Message-Id: <20201015163038.26992-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

[ This is v2 fixing up the sparse warnings. ]

The following patchset adds infrastructure to augment the Netfilter
flowtable fastpath [1] to support for local network topologies that
combine IP forwarding, bridge and vlan devices.

A typical scenario that can benefit from this infrastructure is composed
of several VMs connected to bridge ports where the bridge master device
'br0' has an IP address. A DHCP server is also assumed to be running to
provide connectivity to the VMs. The VMs reach the Internet through
'br0' as default gateway, which makes the packet enter the IP forwarding
path. Then, netfilter is used to NAT the packets before they leave to
through the wan device.

Something like this:

                       fast path
                .------------------------.
               /                          \
               |           IP forwarding   |
               |          /             \  .
               |       br0               eth0
               .       / \
               -- veth1  veth2
                   .
                   .
                   .
                 ethX
           ab:cd:ef:ab:cd:ef
                  VM

The idea is to accelerate forwarding by building a fast path that takes
packets from the ingress path of the bridge port and place them in the
egress path of the wan device (and vice versa). Hence, skipping the
classic bridge and IP stack paths.

Patch #1 adds the transmit path type field to the flow tuple. Two transmit
         paths are supported so far: the neighbour and the xfrm transmit
         paths. This patch comes in preparation to add a new direct ethernet
         transmit path (see patch #7).

Patch #2 adds dev_fill_forward_path() and .ndo_fill_forward_path() to
         netdev_ops. This new function describes the list of netdevice hops
         to reach a given destination MAC address in the local network topology,
         e.g.
                           IP forwarding
                          /             \
                       br0              eth0
                       / \
                   veth1 veth2
                    .
                    .
                    .
                   ethX
             ab:cd:ef:ab:cd:ef

          where veth1 and veth2 are bridge ports and eth0 provides Internet
          connectivity. ethX is the interface in the VM which is connected to
          the veth1 bridge port. Then, for packets going to br0 whose
          destination MAC address is ab:cd:ef:ab:cd:ef, dev_fill_forward_path()
          provides the following path: br0 -> veth1.

Patch #3 adds .ndo_fill_forward_path for vlan devices, which provides the next
         device hop via vlan->real_dev. This also annotates the vlan id and
         protocol. This is useful to know what vlan headers are expected from
         the ingress device. This also provides information regarding the vlan
         headers to be pushed before transmission via the egress device.

Patch #4 adds .ndo_fill_forward_path for bridge devices, which allows to make
         lookups to the FDB to locate the next device hop (bridge port) in the
         forwarding path.

Patch #5 updates the flowtable to use the dev_fill_forward_path()
         infrastructure to obtain the ingress device in the forwarding path.

Patch #6 updates the flowtable to use the dev_fill_forward_path()
         infrastructure to obtain the egress device in the forwarding path.

Patch #7 adds the direct ethernet transmit path, which pushes the
         ethernet header to the packet and send it through dev_queue_xmit().

Patch #8 uses the direct ethernet transmit path (added in the previous
         patch) to transmit packets to bridge ports - in case
         dev_fill_forward_path() describes a topology that includes a bridge.

Patch #9 updates the flowtable to include the vlan information in the flow tuple
         for lookups from the ingress path as well as the vlan headers to be
         pushed into the packet before transmission to the egress device.
         802.1q and 802.1ad (q-in-q) are supported. The vlan information is
         also described by dev_fill_forward_path().

Please, apply.

[1] https://www.kernel.org/doc/html/latest/networking/nf_flowtable.html

Pablo Neira Ayuso (9):
  netfilter: flowtable: add xmit path types
  net: resolve forwarding path from virtual netdevice and HW destination address
  net: 8021q: resolve forwarding path for vlan devices
  bridge: resolve forwarding path for bridge devices
  netfilter: flowtable: use dev_fill_forward_path() to obtain ingress device
  netfilter: flowtable: use dev_fill_forward_path() to obtain egress device
  netfilter: flowtable: add direct xmit path
  netfilter: flowtable: bridge port support
  netfilter: flowtable: add vlan support

 include/linux/netdevice.h             |  35 ++++
 include/net/netfilter/nf_flow_table.h |  41 ++++-
 net/8021q/vlan_dev.c                  |  15 ++
 net/bridge/br_device.c                |  22 +++
 net/core/dev.c                        |  31 ++++
 net/netfilter/nf_flow_table_core.c    |  27 ++-
 net/netfilter/nf_flow_table_ip.c      | 247 ++++++++++++++++++++++----
 net/netfilter/nft_flow_offload.c      | 107 ++++++++++-
 8 files changed, 484 insertions(+), 41 deletions(-)

--
2.20.1

