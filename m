Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C571625F9
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 13:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgBRMSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 07:18:14 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:5318 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbgBRMSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 07:18:14 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: Fy3wI87+FsibbDacOcy/yavLUIpxzyA/fgGHcAFur1hB1ZIK0sD6htEObM0AODUc/no3LPPyI7
 f8IMxDIEKzgJfI5/gHdDSGNr1AnMyd34+8srxY+hyJOPC6pqGn3UNjJIuyHBuy79GltpWR/5C1
 qphPYpzEb89mXlA+f540BqtX1mK8fvE4YfVftzef3gGb0+3a8z2yIuQwDGA71gvvmW17QoOvfr
 kdqZZ6FXcLUounqXCnzcf2ej2yhZak3cWkNJUbjEI5if7Pm2wrTKzfFKh6HrN3qKd1LK1VdS/h
 +R4=
X-IronPort-AV: E=Sophos;i="5.70,456,1574146800"; 
   d="scan'208";a="2754332"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Feb 2020 05:18:12 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 18 Feb 2020 05:18:17 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 18 Feb 2020 05:18:11 -0700
Date:   Tue, 18 Feb 2020 13:18:11 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <andrew@lunn.ch>, <jeffrey.t.kirsher@intel.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v3 00/10]  net: bridge: mrp: Add support for Media
 Redundancy Protocol (MRP)
Message-ID: <20200218121811.xo3o6zzrhl5p3j2s@lx-anielsen.microsemi.net>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200124161828.12206-1-horatiu.vultur@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi All,

Its been a while since posting this serie. We got some good and very
specific comments, but there has not been much discussion on the overall
architecture.

Here is the list of items we have noted to be fixed in the next version:
- The headless chicken (it keeps sending test frames if user-space
   daemon dies)
- Avoid loops when bringing up the network - meaning we need to let MRP
   do its work before the br0 device is set to up, and we need to
   preserve that state.
- Unnessecary ifdef on the include.
- Extend the existing mac-table flush instead of adding
   BR_MRP_GENL_FLUSH
- Further optimize the changes in br_handle_frame

In v1 & v2 we had the entire protocol implemented in kernel-space.
Everybody told us this is a bad idea, and in v3 we have moved as much as
possible to user-space, and only kept the HW offload facilites in
kernel-space. The protocol is then implemented in user-space.

This is nice because it simplifies the code in the kernel and moves it
to user-space where such complexity is easier to handle. The downside of
this is that it makes the netlink interface more specific to our HW.

The way v3 is implemented, the netlink API returns an error if a given
operation cannot be HW offloaded. If the netlink calls return Ok,
user-space will trust that HW do the offloading as requested, if the
netlink calls return an error, it will implement all the functionallity
in user-space.

This works at-least in 2 scenarios: The HW we have with full MRP offload
capabilities, and a pure SW bridge.

But we should try make sure this also works in a backwards compatible
way with future MRP aware HW, and with existing (and future) SwitchDev
offloaded HW. At the very least we want to make this run on Ocelot, HW
offload the MRC role, but do the MRM in SW (as the HW is not capable of
this).

If we use the kernel to abstract the MRP forwarding (not the entire
protocol like we did in v1/v2, not just the HW like we did in v3) then
we will have more flxibility to support other HW with a different set of
offload facilities, we can most likely achieve better performance, and
it would be a cleaner design.

This will mean, that if user-space ask for MRP frame to be generated,
the kernel should make sure it will happen. The kernel can try to
offload this via the switchdev API, or it can do it in kernel-space.

Again, it will mean putting back some code into kernel space, but I
think it is worth it.

What do you think, what is the right design.

/Allan


On 24.01.2020 17:18, Horatiu Vultur wrote:
>Media Redundancy Protocol is a data network protocol standardized by
>International Electrotechnical Commission as IEC 62439-2. It allows rings of
>Ethernet switches to overcome any single failure with recovery time faster than
>STP. It is primarily used in Industrial Ethernet applications.
>
>Based on the previous RFC[1][2], the MRP state machine and all the
>timers were moved to userspace. A generic netlink interface is added to
>allow configuring the HW, and logic added to to implement the MRP
>specific forwarding rules.
>
>The userspace application that is using the new netlink can be found here[3].
>
>The current implementation both in kernel and userspace supports only 2 roles:
>
>  MRM - this one is responsible to send MRP_Test and MRP_Topo frames on both
>  ring ports. It needs to process MRP_Test to know if the ring is open or
>  closed. This operation is desired to be offloaded to the HW because it
>  requires to generate and process up to 4000 frames per second. Whenever it
>  detects that the ring open it sends MRP_Topo frames to notify all MRC about
>  changes in the topology. MRM needs also to process MRP_LinkChange frames,
>  these frames are generated by the MRC. When the ring is open the the state
>  of both ports is to forward frames and when the ring is closed then the
>  secondary port is blocked.
>
>  MRC - this one is responsible to forward MRP frames between the ring ports.
>  In case one of the ring ports gets a link down or up, then MRC will generate
>  a MRP_LinkChange frames. This node should also process MRP_Topo frames and to
>  clear its FDB when it receives this frame.
>
> Userspace
>               Deamon +----------+ Client
>                +
>                |
> +--------------|-----------------------------------------+
>  Kernel        |
>                + Netlink
>
>                |                              + Interrupt
>                |                              |
> +--------------|------------------------------|----------+
>  HW            | Switchdev                    |
>                +                              |
>
>The user interacts using the client (called 'mrp'), the client talks to the
>deamon (called 'mrp_server'), which talks with the kernel using netlink. The
>kernel will try to offload the requests to the HW via switchdev API. For this a
>new generic netlink interface was added to the bridge.
>
>If the kernel cannot offload MRP to HW (maybe it does not have a switchdev
>driver, or it is just not supported), then all the netlink calls will return
>-EOPNOTSUPP. In this case the user-space deamon fallback to SW only
>implementation.
>
>There are required changes to the SW bridge to be able to run the MRP. First the
>bridge needs to initialize the netlink interface. And second it needs to know if
>a MRP frame was received on a MRP ring port. In case it was received the SW
>bridge should not forward the frame it needs to redirected to upper layes. In
>case it was not received on a ring port then it just forwards it as usual.
>
>To be able to offload this to the HW, it was required to extend the switchdev
>API.
>
>If this will be accepted then in the future the netlink interface can be
>expended with multiple attributes which are required by different roles of the
>MRP. Like Media Redundancy Automanager(MRA), Media Interconnect Manager(MIM) and
>Media Interconnect Client(MIC).
>
>[1] https://www.spinics.net/lists/netdev/msg623647.html
>[2] https://www.spinics.net/lists/netdev/msg624378.html
>[3] https://github.com/microchip-ung/mrp/tree/patch-v3
>
>Horatiu Vultur (10):
>  net: bridge: mrp: Expose mrp attributes.
>  net: bridge: mrp: Expose function br_mrp_port_open
>  net: bridge: mrp: Add MRP interface used by netlink
>  net: bridge: mrp: Add generic netlink interface to configure MRP
>  net: bridge: mrp: Update MRP interface to add switchdev support
>  net: bridge: mrp: switchdev: Extend switchdev API to offload MRP
>  net: bridge: mrp: switchdev: Implement MRP API for switchdev
>  net: bridge: mrp: Connect MRP api with the switchev API
>  net: bridge: mrp: Integrate MRP into the bridge
>  net: bridge: mrp: Update Kconfig and Makefile
>
> include/linux/mrp_bridge.h      |  25 ++
> include/net/switchdev.h         |  51 +++
> include/uapi/linux/if_ether.h   |   1 +
> include/uapi/linux/mrp_bridge.h | 118 ++++++
> net/bridge/Kconfig              |  12 +
> net/bridge/Makefile             |   2 +
> net/bridge/br.c                 |  11 +
> net/bridge/br_device.c          |   3 +
> net/bridge/br_if.c              |   6 +
> net/bridge/br_input.c           |  14 +
> net/bridge/br_mrp.c             | 193 ++++++++++
> net/bridge/br_mrp_netlink.c     | 655 ++++++++++++++++++++++++++++++++
> net/bridge/br_mrp_switchdev.c   | 147 +++++++
> net/bridge/br_private.h         |  14 +
> net/bridge/br_private_mrp.h     |  58 +++
> 15 files changed, 1310 insertions(+)
> create mode 100644 include/linux/mrp_bridge.h
> create mode 100644 include/uapi/linux/mrp_bridge.h
> create mode 100644 net/bridge/br_mrp.c
> create mode 100644 net/bridge/br_mrp_netlink.c
> create mode 100644 net/bridge/br_mrp_switchdev.c
> create mode 100644 net/bridge/br_private_mrp.h
>
>-- 
>2.17.1
>
/Allan
