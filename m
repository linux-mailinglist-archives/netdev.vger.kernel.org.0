Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EC42BAA89
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 13:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgKTMuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 07:50:04 -0500
Received: from correo.us.es ([193.147.175.20]:37906 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgKTMtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 07:49:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 66C8418CE88
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 13:49:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4FD3DFC5EE
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 13:49:42 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4520DDA73F; Fri, 20 Nov 2020 13:49:42 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF2BBFC5E6;
        Fri, 20 Nov 2020 13:49:39 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Nov 2020 13:49:39 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id A513C4265A5A;
        Fri, 20 Nov 2020 13:49:39 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        fw@strlen.de, razor@blackwall.org, jeremy@azazel.net,
        tobias@waldekranz.com
Subject: [PATCH net-next,v5 0/9] netfilter: flowtable bridge and vlan enhancements
Date:   Fri, 20 Nov 2020 13:49:12 +0100
Message-Id: <20201120124921.32172-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset augments the Netfilter flowtable fastpath to
support for network topologies that combine IP forwarding, bridge and
VLAN devices.

This v5 includes updates for:

- Patch #2: fix incorrect xmit type in IPv6 path, per Florian Westphal.
- Patch #3: fix possible off by one in dev_fill_forward_path() stack logic,
            per Florian Westphal.
- Patch #7: add a note to patch description to specify that FDB topology
            updates are not supported at this stage, per Jakub Kicinski.

A typical scenario that can benefit from this infrastructure is composed
of several VMs connected to bridge ports where the bridge master device
'br0' has an IP address. A DHCP server is also assumed to be running to
provide connectivity to the VMs. The VMs reach the Internet through
'br0' as default gateway, which makes the packet enter the IP forwarding
path. Then, netfilter is used to NAT the packets before they leave
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
                 eth0
           ab:cd:ef:ab:cd:ef
                  VM

The idea is to accelerate forwarding by building a fast path that takes
packets from the ingress path of the bridge port and place them in the
egress path of the wan device (and vice versa). Hence, skipping the
classic bridge and IP stack paths.

This patchset is composed of:

Patch #1 adds a placeholder for the hash calculation, instead of using
         the dir field.

Patch #2 adds the transmit path type field to the flow tuple. Two transmit
         paths are supported so far: the neighbour and the xfrm transmit
         paths. This patch comes in preparation to add a new direct ethernet
         transmit path (see patch #7).

Patch #3 adds dev_fill_forward_path() and .ndo_fill_forward_path() to
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
                   eth0
             ab:cd:ef:ab:cd:ef

          where veth1 and veth2 are bridge ports and eth0 provides Internet
          connectivity. eth0 is the interface in the VM which is connected to
          the veth1 bridge port. Then, for packets going to br0 whose
          destination MAC address is ab:cd:ef:ab:cd:ef, dev_fill_forward_path()
          provides the following path: br0 -> veth1.

Patch #4 adds .ndo_fill_forward_path for VLAN devices, which provides the next
         device hop via vlan->real_dev. This annotates the VLAN id and protocol.
         This is useful to know what VLAN headers are expected from the ingress
         device. This also provides information regarding the VLAN headers
         to be pushed in the egress path.

Patch #5 adds .ndo_fill_forward_path for bridge devices, which allows to make
         lookups to the FDB to locate the next device hop (bridge port) in the
         forwarding path.

Patch #6 updates the flowtable to use the dev_fill_forward_path()
         infrastructure to obtain the ingress device in the fastpath.

Patch #7 updates the flowtable to use dev_fill_forward_path() to obtain the
         egress device in the forwarding path. This also adds the direct
         ethernet transmit path, which pushes the ethernet header to the
         packet and send it through dev_queue_xmit(). This patch adds
         support for the bridge, so bridge ports use this direct xmit path.

Patch #8 adds ingress VLAN support (up to 2 VLAN tags, QinQ). The VLAN
         information is also provided by dev_fill_forward_path(). Store the
         VLAN id and protocol in the flow tuple for hash lookups. The VLAN
         support in the xmit path is achieved by annotating the first vlan
         device found in the xmit path and by calling dev_hard_header()
         (previous patch #7) before dev_queue_xmit().

Patch #9 extends nft_flowtable.sh selftest: This is adding a test to
         cover bridge and vlan support coming in this patchset.

= Performance numbers

My testbed environment consists of three containers:

  192.168.20.2     .20.1     .10.1   10.141.10.2
         veth0       veth0 veth1      veth0
        ns1 <---------> nsr1 <--------> ns2
                            SNAT
     iperf -c                          iperf -s

where nsr1 is used for forwarding. There is a bridge device br0 in nsr1,
veth0 is a port of br0. SNAT is performed on the veth1 device of nsr1.

- ns2 runs iperf -s
- ns1 runs iperf -c 10.141.10.2 -n 100G

My results are:

- Baseline (no flowtable, classic forwarding path + netfilter): ~16 Gbit/s
- Fastpath (with flowtable, this patchset): ~25 Gbit/s

This is an improvement of ~50% compared to baseline.

Please, apply. Thank you.

Pablo Neira Ayuso (9):
  netfilter: flowtable: add hash offset field to tuple
  netfilter: flowtable: add xmit path types
  net: resolve forwarding path from virtual netdevice and HW destination address
  net: 8021q: resolve forwarding path for vlan devices
  bridge: resolve forwarding path for bridge devices
  netfilter: flowtable: use dev_fill_forward_path() to obtain ingress device
  netfilter: flowtable: use dev_fill_forward_path() to obtain egress device
  netfilter: flowtable: add vlan support
  selftests: netfilter: flowtable bridge and VLAN support

 include/linux/netdevice.h                     |  35 +++
 include/net/netfilter/nf_flow_table.h         |  43 +++-
 net/8021q/vlan_dev.c                          |  15 ++
 net/bridge/br_device.c                        |  27 +++
 net/core/dev.c                                |  46 ++++
 net/netfilter/nf_flow_table_core.c            |  51 +++--
 net/netfilter/nf_flow_table_ip.c              | 200 ++++++++++++++----
 net/netfilter/nft_flow_offload.c              | 159 +++++++++++++-
 .../selftests/netfilter/nft_flowtable.sh      |  82 +++++++
 9 files changed, 598 insertions(+), 60 deletions(-)

--
2.20.1

