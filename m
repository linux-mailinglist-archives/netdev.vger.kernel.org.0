Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E83226C8C
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbgGTQ6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:58:09 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:46860 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729409AbgGTQ6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 12:58:09 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06KGw46t079967;
        Mon, 20 Jul 2020 11:58:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1595264284;
        bh=Af+c9fzGxU8oyuPs8nbSZatlc5aE5qYa+rqXS215ND4=;
        h=From:To:Subject:Date;
        b=bYF+o6Qfs2G9vgdFkiQaLEIm5eWAdNpXfi33USfBtmtjylTSY3JXrw20aax9xqv90
         fwavcaQI+vSiPzlKFB3m1/YIaedYDkHKcBE2xC6AzmjBoK5/bPrYp08h89GnN4oT51
         wFkmJx4eA6SHRk1KgcNiyDGjSNXA9THhV63x2Jfs=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06KGw496128491
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Jul 2020 11:58:04 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 20
 Jul 2020 11:58:04 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 20 Jul 2020 11:58:04 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06KGw3B3041101;
        Mon, 20 Jul 2020 11:58:03 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
Subject: [net-next v4 PATCH 0/7] Add PRP driver
Date:   Mon, 20 Jul 2020 12:57:56 -0400
Message-ID: <20200720165803.17793-1-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series is dependent on the following patches sent out to
netdev list. 2 & 3 are already merged to net/master as of
sending this, but not on the net-next master branch. So need
to apply them to net-next before applying this series. v3 of
the iproute2 patches can be merged to work with this series
as there are no updates since then.

[1] https://marc.info/?l=linux-netdev&m=159526378131542&w=2
[2] https://marc.info/?l=linux-netdev&m=159499772225350&w=2
[3] https://marc.info/?l=linux-netdev&m=159499772425352&w=2

This series adds support for Parallel Redundancy Protocol (PRP)
in the Linux HSR driver as defined in IEC-62439-3. PRP Uses a
Redundancy Control Trailer (RCT) the format of which is
similar to HSR Tag. This is used for implementing redundancy.
RCT consists of 6 bytes similar to HSR tag and contain following
fields:-

- 16-bit sequence number (SeqNr);
- 4-bit LAN identifier (LanId);
- 12 bit frame size (LSDUsize);
- 16-bit suffix (PRPsuffix). 

The PRPsuffix identifies PRP frames and distinguishes PRP frames
from other protocols that also append a trailer to their useful
data. The LSDUsize field allows the receiver to distinguish PRP
frames from random, nonredundant frames as an additional check.
LSDUsize is the size of the Ethernet payload inclusive of the
RCT. Sequence number along with LanId is used for duplicate
detection and discard.

PRP node is also known as Dual Attached Node (DAN-P) since it
is typically attached to two different LAN for redundancy.
DAN-P duplicates each of L2 frames and send it over the two
Ethernet links. Each outgoing frame is appended with RCT.
Unlike HSR, these are added to the end of L2 frame and will be
treated as pad by bridges and therefore would be work with
traditional bridges or switches, where as HSR wouldn't as Tag
is prefixed to the Ethenet frame. At the remote end, these are
received and the duplicate frame is discarded before the stripped
frame is send up the networking stack. Like HSR, PRP also sends
periodic Supervision frames to the network. These frames are
received and MAC address from the SV frames are populated in a
database called Node Table. The above functions are grouped into
a block called Link Redundancy Entity (LRE) in the IEC spec.

As there are many similarities between HSR and PRP protocols,
this patch re-uses the code from HSR driver to implement PRP
driver. As per feedback from the RFC series, the implementation
uses the existing HSR Netlink socket interface to create the
PRP interface by adding a new proto parameter to the ip link
command to identify the PRP protocol. iproute2 is enhanced to
implement this new parameter. The hsr_netlink.c is enhanced
to handle the new proto parameter. As suggested during the RFC
review, the driver introduced a proto_ops structure to hold
protocol specfic functions to handle HSR and PRP specific
function pointers and use them in the code based on the
protocol to handle protocol specific part differently in the
driver.

Please review this and provide me feedback so that I can work to
incorporate them and spin the next version if needed.

The patch was tested using two TI AM57x IDK boards for PRP which
are connected back to back over two CPSW Ethernet ports. 

PRP Test setup
---------------

--------eth0             eth0 --------
|AM572x|----------------------|AM572x|
|      |----------------------|      |
--------eth1             eth1 --------


To build, enable CONFIG_HSR=y or m
make omap2plus_defconfig
make zImage; make modules; make dtbs 
Copy the zImage and dtb files to the file system on SD card
and power on the AM572x boards. 
This can be tested on any platforms with 2 Ethernet interfaces.
So will appreciate if you can give it a try and provide your
Tested-by.

Command to create PRP interface
-------------------------------
ifconfig eth0 0.0.0.0 down
ifconfig eth1 0.0.0.0 down
ifconfig eth0 hw ether 70:FF:76:1C:0E:8C
ifconfig eth1 hw ether 70:FF:76:1C:0E:8C
ifconfig eth0 up
ifconfig eth1 up
ip link add name prp0 type hsr slave1 eth0 slave2 eth1 supervision 45 proto 1 
ifconfig prp0 192.168.2.10

ifconfig eth0 0.0.0.0 down
ifconfig eth1 0.0.0.0 down
ifconfig eth0 hw ether 70:FF:76:1C:0E:8D
ifconfig eth1 hw ether 70:FF:76:1C:0E:8D
ifconfig eth0 up
ifconfig eth1 up
ip link add name prp0 type hsr slave1 eth0 slave2 eth1 supervision 45 proto 1
ifconfig prp0 192.168.2.20

command to show node table
----------------------------
Ping the peer board after the prp0 interface is up.

The remote node (DAN-P) will be shown in the node table as below.

root@am57xx-evm:~# cat /sys/kernel/debug/hsr/prp0/node_table                                                
Node Table entries for (PRP) device                                                                         
MAC-Address-A,    MAC-Address-B,    time_in[A], time_in[B], Address-B port, SAN-A, SAN-B, DAN-P 
70:ff:76:1c:0e:8c 00:00:00:00:00:00   ffffe83f,   ffffe83f,              0,     0,     0,     1

Try to capture the raw PRP frames at the eth0 interface as
tcpdump -i eth0 -xxx

Sample Supervision frames and ARP frames shown below.

==================================================================================
Successive Supervision frames captured with tcpdump (with RCT at the end):

03:43:29.500999 70:ff:76:1c:0e:8d (oui Unknown) > 01:15:4e:00:01:2d (oui Unknown), ethertype Unknown (0x88f 
        0x0000:  0115 4e00 012d 70ff 761c 0e8d 88fb 0001                                                    
        0x0010:  7e0a 1406 70ff 761c 0e8d 0000 0000 0000                                                    
        0x0020:  0000 0000 0000 0000 0000 0000 0000 0000                                                    
        0x0030:  0000 0000 0000 0000 0000 0000 fc2b a034                                                    
        0x0040:  88fb         
                   
03:43:31.581025 70:ff:76:1c:0e:8d (oui Unknown) > 01:15:4e:00:01:2d (oui Unknown), ethertype Unknown (0x88f 
        0x0000:  0115 4e00 012d 70ff 761c 0e8d 88fb 0001                                                    
        0x0010:  7e0b 1406 70ff 761c 0e8d 0000 0000 0000                                                    
        0x0020:  0000 0000 0000 0000 0000 0000 0000 0000                                                    
        0x0030:  0000 0000 0000 0000 0000 0000 fc2c a034                                                    
        0x0040:  88fb                                                                                       

ICMP Echo request frame with RCT
03:43:33.805354 IP 192.168.2.20 > 192.168.2.10: ICMP echo request, id 63748, seq 1, length 64               
        0x0000:  70ff 761c 0e8c 70ff 761c 0e8d 0800 4500                                                    
        0x0010:  0054 26a4 4000 4001 8e96 c0a8 0214 c0a8                                                    
        0x0020:  020a 0800 c28e f904 0001 202e 1c3d 0000                                                    
        0x0030:  0000 0000 0000 0000 0000 0000 0000 0000                                                    
        0x0040:  0000 0000 0000 0000 0000 0000 0000 0000                                                    
        0x0050:  0000 0000 0000 0000 0000 0000 0000 0000                                                    
        0x0060:  0000 fc31 a05a 88fb                                      
==================================================================================
The iperf3 traffic test logs can be accessed at the links below.
DUT-1: https://pastebin.ubuntu.com/p/8SkQzWJMn8/
DUT-2: https://pastebin.ubuntu.com/p/j2BZvvs7p4/

Other tests done.
 - Connect a SAN (eth0 and eth1 without prp interface) and
   do ping test from eth0 (192.168.2.40) to prp0 (192.168.2.10)
   verify the SAN node shows at the correct link A and B as shown
   in the node table dump
 - Regress HSR interface using 3 nodes connected in a ring topology.
   create hsr link version 0. Do iperf3 test between all nodes
   create hsr link version 1. Do iperf3 test between all nodes.

         --------eth0             eth1 --------eth0      eth1-------|
         |AM572x|----------------------|AM572x|--------------|AM572x|
         |      |                      |      |        ------|      |
         --------eth1---|               -------        | eth0 ------- 
                        |-------------------------------

   command used for HSR interface

   HSR V0

   ifconfig eth0 0.0.0.0 down
   ifconfig eth1 0.0.0.0 down
   ifconfig eth0 hw ether 70:FF:76:1C:0E:8C
   ifconfig eth1 hw ether 70:FF:76:1C:0E:8C
   ifconfig eth0 up
   ifconfig eth1 up
   ip link add name hsr0 type hsr slave1 eth0 slave2 eth1 supervision 45 version 0
   ifconfig hsr0 192.168.2.10

   HSR V1

   ifconfig eth0 0.0.0.0 down
   ifconfig eth1 0.0.0.0 down
   ifconfig eth0 hw ether 70:FF:76:1C:0E:8C
   ifconfig eth1 hw ether 70:FF:76:1C:0E:8C
   ifconfig eth0 up
   ifconfig eth1 up
   ip link add name hsr0 type hsr slave1 eth0 slave2 eth1 supervision 45 version 1
   ifconfig hsr0 192.168.2.10

   Logs at
   DUT-1 : https://pastebin.ubuntu.com/p/6PSJbZwQ6y/
   DUT-2 : https://pastebin.ubuntu.com/p/T8TqJsPRHc/
   DUT-3 : https://pastebin.ubuntu.com/p/VNzpv6HzKj/
 - Build tests :-
   Build with CONFIG_HSR=m
   allmodconfig build
   build with CONFIG_HSR=y and rebuild with sparse checker
   make C=1 zImage; make modules

Version history:
  v4 : fixed following vs v3
       reverse xmas tree for local variables
       check for return type in call to skb_put_padto()
  v3 : Separated bug fixes from this series and send them for immediate merge
       But for that this is same as v2.
 
  v2 : updated comments on RFC. Following are the main changes:-
       - Removed the hsr_prp prefix
       - Added PRP information in header files to indicate 
         the support for PRP explicitely
       - Re-use netlink socket interface with an added 
         parameter proto for identifying PRP.
       - Use function pointers using a proto_ops struct
         to do things differently for PRP vs HSR.

   RFC: initial version posted and discussed at 
       https://www.spinics.net/lists/netdev/msg656229.html

Murali Karicheri (7):
  hsr: enhance netlink socket interface to support PRP
  net: hsr: introduce common code for skb initialization
  net: hsr: introduce protocol specific function pointers
  net: prp: add supervision frame generation utility function
  net: hsr: define and use proto_ops ptrs to handle hsr specific frames
  net: prp: add packet handling support
  net: prp: enhance debugfs to display PRP info

 include/uapi/linux/hsr_netlink.h |   2 +-
 include/uapi/linux/if_link.h     |  12 +-
 net/hsr/Kconfig                  |  37 ++--
 net/hsr/hsr_debugfs.c            |  33 +++-
 net/hsr/hsr_device.c             | 181 ++++++++++++++----
 net/hsr/hsr_device.h             |   2 +
 net/hsr/hsr_forward.c            | 314 ++++++++++++++++++++++++-------
 net/hsr/hsr_forward.h            |  16 +-
 net/hsr/hsr_framereg.c           |  95 ++++++++--
 net/hsr/hsr_framereg.h           |  31 ++-
 net/hsr/hsr_main.c               |   2 +
 net/hsr/hsr_main.h               | 120 +++++++++++-
 net/hsr/hsr_netlink.c            |  38 +++-
 net/hsr/hsr_netlink.h            |   2 +
 net/hsr/hsr_slave.c              |  26 ++-
 net/hsr/hsr_slave.h              |   4 +
 16 files changed, 745 insertions(+), 170 deletions(-)

-- 
2.17.1

