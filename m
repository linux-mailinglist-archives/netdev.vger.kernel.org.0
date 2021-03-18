Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BB5340B8C
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 18:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhCRRSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 13:18:36 -0400
Received: from mga07.intel.com ([134.134.136.100]:22332 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230040AbhCRRSE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 13:18:04 -0400
IronPort-SDR: DKD4dPUu7GXVN0lJPjInDl+X2RGKc53W5kGMry8R2AoruNK+WxLRlRxILM76wenJs3KapYluge
 zFFq9Pb3ttWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="253740860"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="253740860"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 10:18:04 -0700
IronPort-SDR: R+AVaVa3UUPEnjTZIc5WRzDImR+71PIiIFNfeACe4wNl9uJlLsk6qgn4MnxQJ4omynn7PvhPIi
 i5VgrFO2Mn4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="374641106"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga006.jf.intel.com with ESMTP; 18 Mar 2021 10:18:00 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 0/2] stmmac: add VLAN priority based RX steering
Date:   Fri, 19 Mar 2021 01:22:02 +0800
Message-Id: <20210318172204.23766-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The current tc flower implementation in stmmac supports both L3 and L4
filter offloading. This patch adds the support of VLAN priority based
RX frame steering into different Rx Queues.

The patches have been tested on both configuration test (include L3/L4)
and traffic test (multi VLAN ping streams with RX Frame Steering) below:-

#################################
# A) tc flower configuration test
#########################################################################
# eth0: Delete tc filter
> tc qdisc delete dev eth0 ingress

# eth0: Delete all QDiscs
> tc qdisc del dev eth0 parent root 2&> /dev/null
> tc qdisc del dev eth0 parent ffff: 2&> /dev/null

# eth0: Add tc filter
> tc qdisc add dev eth0 ingress

# eth0: Add tc flower (192.168.0.1:5201 192.168.1.1:6201 - ip - tcp) action drop
> tc filter add dev eth0 parent ffff: protocol ip flower dst_ip 192.168.0.1 \
  src_ip 192.168.1.1 ip_proto tcp dst_port 5201 src_port 6201 action drop

# eth0: Add tc flower (192.168.0.2:5202 192.168.1.2:6202 - ip - tcp) action drop
> tc filter add dev eth0 parent ffff: protocol ip flower dst_ip 192.168.0.2 \
  src_ip 192.168.1.2 ip_proto tcp dst_port 5202 src_port 6202 action drop

# eth0: Show tc filter - ingress
> tc filter show dev eth0 ingress
filter parent ffff: protocol ip pref 49151 flower chain 0
filter parent ffff: protocol ip pref 49151 flower chain 0 handle 0x1
  eth_type ipv4
  ip_proto tcp
  dst_ip 192.168.0.2
  src_ip 192.168.1.2
  dst_port 5202
  src_port 6202
  in_hw in_hw_count 1
        action order 1: gact action drop
         random type none pass val 0
         index 2 ref 1 bind 1

filter parent ffff: protocol ip pref 49152 flower chain 0
filter parent ffff: protocol ip pref 49152 flower chain 0 handle 0x1
  eth_type ipv4
  ip_proto tcp
  dst_ip 192.168.0.1
  src_ip 192.168.1.1
  dst_port 5201
  src_port 6201
  in_hw in_hw_count 1
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1

# eth0: Delete tc filter
> tc qdisc delete dev eth0 ingress

# eth0: Delete all QDiscs
> tc qdisc del dev eth0 parent root 2&> /dev/null
> tc qdisc del dev eth0 parent ffff: 2&> /dev/null

# eth0: Add tc filter
> tc qdisc add dev eth0 ingress

# eth0: MQPRIO 4 TC add
> tc qdisc add dev eth0 root mqprio num_tc 4 \
  map 0 1 2 3 0 0 0 0 0 0 0 0 0 0 0 0 \
  queues 1@0 1@1 1@2 1@3 hw 0

# eth0: Add tc flower RX vlan_prio(0) --> RX traffic class(3)
> tc filter add dev eth0 parent ffff: protocol 802.1Q flower vlan_prio 0 hw_tc 3

# eth0: Add tc flower RX vlan_prio(1) --> RX traffic class(2)
> tc filter add dev eth0 parent ffff: protocol 802.1Q flower vlan_prio 1 hw_tc 2

# eth0: Add tc flower RX vlan_prio(2) --> RX traffic class(1)
> tc filter add dev eth0 parent ffff: protocol 802.1Q flower vlan_prio 2 hw_tc 1

# eth0: Add tc flower RX vlan_prio(3) --> RX traffic class(0)
> tc filter add dev eth0 parent ffff: protocol 802.1Q flower vlan_prio 3 hw_tc 0

# eth0: Show tc filter - ingress
> tc filter show dev eth0 ingress
filter parent ffff: protocol 802.1Q pref 49149 flower chain 0
filter parent ffff: protocol 802.1Q pref 49149 flower chain 0 handle 0x1 hw_tc 0
  vlan_prio 3
  in_hw in_hw_count 1
filter parent ffff: protocol 802.1Q pref 49150 flower chain 0
filter parent ffff: protocol 802.1Q pref 49150 flower chain 0 handle 0x1 hw_tc 1
  vlan_prio 2
  in_hw in_hw_count 1
filter parent ffff: protocol 802.1Q pref 49151 flower chain 0
filter parent ffff: protocol 802.1Q pref 49151 flower chain 0 handle 0x1 hw_tc 2
  vlan_prio 1
  in_hw in_hw_count 1
filter parent ffff: protocol 802.1Q pref 49152 flower chain 0
filter parent ffff: protocol 802.1Q pref 49152 flower chain 0 handle 0x1 hw_tc 3
  vlan_prio 0
  in_hw in_hw_count 1

# eth0: Delete tc filter
> tc qdisc delete dev eth0 ingress
#########################################################################

##########################
# B) VLAN-based ping streams with RX Frame steering based on VLAN priority
##########################################################################

# For DUT-A:
# Restore DUT IP address for VLAN and non-VLAN interface
> ip address flush dev eth0
> ip address add 169.254.1.11/24 dev eth0

> ip link delete dev eth0.vlan1 2> /dev/null
> ip link add link eth0 name eth0.vlan1 type vlan id 1
> ip address flush dev eth0.vlan1 2> /dev/null
> ip address add 169.254.11.11/24 dev eth0.vlan1

> ip link delete dev eth0.vlan2 2> /dev/null
> ip link add link eth0 name eth0.vlan2 type vlan id 2
> ip address flush dev eth0.vlan2 2> /dev/null
> ip address add 169.254.12.11/24 dev eth0.vlan2

> ip link delete dev eth0.vlan3 2> /dev/null
> ip link add link eth0 name eth0.vlan3 type vlan id 3
> ip address flush dev eth0.vlan3 2> /dev/null
> ip address add 169.254.13.11/24 dev eth0.vlan3

> ip link delete dev eth0.vlan4 2> /dev/null
> ip link add link eth0 name eth0.vlan4 type vlan id 4
> ip address flush dev eth0.vlan4 2> /dev/null
> ip address add 169.254.14.11/24 dev eth0.vlan4

# For DUT-B:
# Restore DUT IP address for VLAN and non-VLAN interface
> ip address flush dev eth0
> ip address add 169.254.1.22/24 dev eth0

> ip link delete dev eth0.vlan1 2> /dev/null
> ip link add link eth0 name eth0.vlan1 type vlan id 1
> ip address flush dev eth0.vlan1 2> /dev/null
> ip address add 169.254.11.22/24 dev eth0.vlan1

> ip link delete dev eth0.vlan2 2> /dev/null
> ip link add link eth0 name eth0.vlan2 type vlan id 2
> ip address flush dev eth0.vlan2 2> /dev/null
> ip address add 169.254.12.22/24 dev eth0.vlan2

> ip link delete dev eth0.vlan3 2> /dev/null
> ip link add link eth0 name eth0.vlan3 type vlan id 3
> ip address flush dev eth0.vlan3 2> /dev/null
> ip address add 169.254.13.22/24 dev eth0.vlan3

> ip link delete dev eth0.vlan4 2> /dev/null
> ip link add link eth0 name eth0.vlan4 type vlan id 4
> ip address flush dev eth0.vlan4 2> /dev/null
> ip address add 169.254.14.22/24 dev eth0.vlan4

# For DUT-A and DUT-B:

# Setup VLAN I/F socket priority using cgroup net_prio
> mkdir -p /sys/fs/cgroup/net_prio/grp0
> echo eth0 0 > /sys/fs/cgroup/net_prio/grp0/net_prio.ifpriomap
> echo eth0.vlan1 0 >  /sys/fs/cgroup/net_prio/grp0/net_prio.ifpriomap
> mkdir -p /sys/fs/cgroup/net_prio/grp1
> echo eth0 0 > /sys/fs/cgroup/net_prio/grp1/net_prio.ifpriomap
> echo eth0.vlan2 1 >  /sys/fs/cgroup/net_prio/grp1/net_prio.ifpriomap
> mkdir -p /sys/fs/cgroup/net_prio/grp2
> echo eth0 0 > /sys/fs/cgroup/net_prio/grp2/net_prio.ifpriomap
> echo eth0.vlan3 2 >  /sys/fs/cgroup/net_prio/grp2/net_prio.ifpriomap
> mkdir -p /sys/fs/cgroup/net_prio/grp3
> echo eth0 0 > /sys/fs/cgroup/net_prio/grp3/net_prio.ifpriomap
> echo eth0.vlan4 3 >  /sys/fs/cgroup/net_prio/grp3/net_prio.ifpriomap

# Setup tc ...
# eth0: Delete all QDiscs
> tc qdisc del dev eth0 parent root 2&> /dev/null
> tc qdisc del dev eth0 parent ffff: 2&> /dev/null

# eth0: Add tc filter
> tc qdisc add dev eth0 ingress
> tc qdisc add dev eth0 root mqprio num_tc 4 map 0 1 2 3 0 0 0 0 0 0 0 0 0 0 0 0 queues 1@0 1@1 1@2 1@3 hw 0

# eth0: Add tc flower RX vlan_prio(0) --> RX traffic class(0)
> tc filter add dev eth0 parent ffff: protocol 802.1Q flower vlan_prio 0 hw_tc 0

# eth0: Add tc flower RX vlan_prio(1) --> RX traffic class(1)
> tc filter add dev eth0 parent ffff: protocol 802.1Q flower vlan_prio 1 hw_tc 1

# eth0: Add tc flower RX vlan_prio(2) --> RX traffic class(2)
> tc filter add dev eth0 parent ffff: protocol 802.1Q flower vlan_prio 2 hw_tc 2

# eth0: Add tc flower RX vlan_prio(3) --> RX traffic class(3)
> tc filter add dev eth0 parent ffff: protocol 802.1Q flower vlan_prio 3 hw_tc 3

# For VLAN TX interface, VLANID[1-4] has SOCK_PRIO[0-3] mapped to VLAN PRIO[0-3]
> ip link set eth0.vlan1 type vlan egress-qos-map 0:0
> ip link set eth0.vlan2 type vlan egress-qos-map 1:1
> ip link set eth0.vlan3 type vlan egress-qos-map 2:2
> ip link set eth0.vlan4 type vlan egress-qos-map 3:3

# eth0: Show tc filter - ingress
> tc filter show dev eth0 ingress
filter parent ffff: protocol 802.1Q pref 49149 flower chain 0
filter parent ffff: protocol 802.1Q pref 49149 flower chain 0 handle 0x1 hw_tc 3
  vlan_prio 3
  in_hw in_hw_count 1
filter parent ffff: protocol 802.1Q pref 49150 flower chain 0
filter parent ffff: protocol 802.1Q pref 49150 flower chain 0 handle 0x1 hw_tc 2
  vlan_prio 2
  in_hw in_hw_count 1
filter parent ffff: protocol 802.1Q pref 49151 flower chain 0
filter parent ffff: protocol 802.1Q pref 49151 flower chain 0 handle 0x1 hw_tc 1
  vlan_prio 1
  in_hw in_hw_count 1
filter parent ffff: protocol 802.1Q pref 49152 flower chain 0
filter parent ffff: protocol 802.1Q pref 49152 flower chain 0 handle 0x1 hw_tc 0
  vlan_prio 0
  in_hw in_hw_count 1

# rx-0 with IRQ-131 mapped to Core-1
> echo 1 > /proc/irq/131/smp_affinity
# tx-0 with IRQ-132 mapped to Core-1
> echo 1 > /proc/irq/132/smp_affinity

# rx-1 with IRQ-133 mapped to Core-4
> echo 4 > /proc/irq/133/smp_affinity
# tx-1 with IRQ-134 mapped to Core-4
> echo 4 > /proc/irq/134/smp_affinity

# rx-2 with IRQ-135 mapped to Core-4
> echo 4 > /proc/irq/135/smp_affinity
# tx-2 with IRQ-136 mapped to Core-4
> echo 4 > /proc/irq/136/smp_affinity

# rx-3 with IRQ-137 mapped to Core-2
> echo 2 > /proc/irq/137/smp_affinity
# tx-3 with IRQ-138 mapped to Core-2
> echo 2 > /proc/irq/138/smp_affinity

# For DUT-A:
> ping -i 0.001 169.254.11.22 2&> /dev/null &
> PID1="$!"
> echo $PID1 >  /sys/fs/cgroup/net_prio/grp0/cgroup.procs

> ping -i 0.001 169.254.12.22 2&> /dev/null &
> PID2="$!"
> echo $PID2 >  /sys/fs/cgroup/net_prio/grp1/cgroup.procs

> ping -i 0.001 169.254.13.22 2&> /dev/null &
> PID3="$!"
> echo $PID3 >  /sys/fs/cgroup/net_prio/grp2/cgroup.procs

> ping -i 0.001 169.254.14.22 2&> /dev/null &
> PID4="$!"
> echo $PID4 >  /sys/fs/cgroup/net_prio/grp3/cgroup.procs

# For DUT-B:
> ping -i 0.001 169.254.11.11 2&> /dev/null &
> PID1="$!"
> echo $PID1 >  /sys/fs/cgroup/net_prio/grp0/cgroup.procs

> ping -i 0.001 169.254.12.11 2&> /dev/null &
> PID2="$!"
> echo $PID2 >  /sys/fs/cgroup/net_prio/grp1/cgroup.procs

> ping -i 0.001 169.254.13.11 2&> /dev/null &
> PID3="$!"
> echo $PID3 >  /sys/fs/cgroup/net_prio/grp2/cgroup.procs

> ping -i 0.001 169.254.14.11 2&> /dev/null &
> PID4="$!"
> echo $PID4 >  /sys/fs/cgroup/net_prio/grp3/cgroup.procs

# Example of result on DUT-B:
> watch -n 0.5 -d "cat /proc/interrupts | grep eth0"
 131:     251918         41          0          0  IR-PCI-MSI 477184-edge      eth0:rx-0
 132:      18969          1          0          0  IR-PCI-MSI 477185-edge      eth0:tx-0
 133:          0          0     295872          0  IR-PCI-MSI 477186-edge      eth0:rx-1
 134:          0          0      16136          0  IR-PCI-MSI 477187-edge      eth0:tx-1
 135:          0          0     288042          0  IR-PCI-MSI 477188-edge      eth0:rx-2
 136:          0          0      16135          0  IR-PCI-MSI 477189-edge      eth0:tx-2
 137:          0     211177          0          0  IR-PCI-MSI 477190-edge      eth0:rx-3
 138:          2      16144          0          0  IR-PCI-MSI 477191-edge      eth0:tx-3
 139:          0          0          0          0  IR-PCI-MSI 477192-edge      eth0:rx-4
 140:          0          0          0          0  IR-PCI-MSI 477193-edge      eth0:tx-4
 141:          0          0          0          0  IR-PCI-MSI 477194-edge      eth0:rx-5
 142:          0          0          0          0  IR-PCI-MSI 477195-edge      eth0:tx-5
 143:          0          0          0          0  IR-PCI-MSI 477196-edge      eth0:rx-6
 144:          0          0          0          0  IR-PCI-MSI 477197-edge      eth0:tx-6
 145:          0          0          0          0  IR-PCI-MSI 477198-edge      eth0:rx-7
 146:          0          0          0          0  IR-PCI-MSI 477199-edge      eth0:tx-7
 157:          0          0          0          0  IR-PCI-MSI 477210-edge      eth0:safety-ue

#########################################################################


Thank You,
Boon Leong

Ong Boon Leong (2):
  net: stmmac: restructure tc implementation for RX VLAN Priority
    steering
  net: stmmac: add RX frame steering based on VLAN priority in tc flower

 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 85 ++++++++++++++++++-
 1 file changed, 83 insertions(+), 2 deletions(-)

-- 
2.25.1

