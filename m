Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A001DEF6A
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 20:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbgEVSmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 14:42:37 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12611 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730810AbgEVSmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 14:42:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1590172955; x=1621708955;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=63TQ2i0uwLk1Ry4qYh8gSAiS0M/T6s8O421GLAZBHRY=;
  b=CSgEJUT2t5xS47noHHoVUSyafXlAIHDnJeEsWCBrNvRME5BM6PjenKNf
   51+t5xafdwQy7u72/JYMtufVvh1x0AQQOkUaa0p2/ba70EM/B2g5UgIee
   YFn4A/24AjqUBYXppaQJkJXbCAIdqOxvIXnt3FS6OGajVPssvXMlK0p9U
   nUH5rArKkIyWEcdR1GbAvOJyJb0OQLPiPzpk21iY/UKm8GGt0FgMlLIbS
   UjN3eNgQWl8BcNLvSok9q0Kt6szKs3UUNMDqI3Ayjc5ubhnnFp/7e5loh
   u/7pBuJ32SSu4BMGQol690aynu6Y+8PCYayqas7O0wK+7lxnUdbmqshBX
   A==;
IronPort-SDR: AMacVx288s+1Tth9gq2S1IdCNyYT6dJqKNY/qLDwlQyVDde/8nG/t3za8ue//RLv9RZe7gpuyv
 e1wSYDu08zjtvTP0FwM7ZGXmVsePBMGtoF2LCfBOwBNLDJLCqYVXob7hTFfq7t8Ntr/jIEggOO
 XIR8A7+rnv8YOodf2ajSO9m/df/54yL8dE7Whnw9QUhX4+HspqV0TRPdFY/rM3QktzCC0OKrJ9
 lbFkuTBuR2mWUBZ/OakS1LnqTMBz2QeXFcVCuFVHfHpct4Djcc31PSrQgA3+TI/jcdPi/bKeNL
 Cpo=
X-IronPort-AV: E=Sophos;i="5.73,422,1583218800"; 
   d="scan'208";a="77605637"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2020 11:42:34 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 22 May 2020 11:42:35 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 22 May 2020 11:42:34 -0700
Date:   Fri, 22 May 2020 20:42:34 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <idosch@idosch.org>, <kuba@kernel.org>,
        <ivecera@redhat.com>, <netdev@vger.kernel.org>,
        <horatiu.vultur@microchip.com>, <nikolay@cumulusnetworks.com>,
        <roopa@cumulusnetworks.com>
Subject: Re: [PATCH RFC net-next 00/13] RX filtering for DSA switches
Message-ID: <20200522184104.nxjz35cxgj5iwxne@ws.localdomain>
References: <20200521211036.668624-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200521211036.668624-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

I'm very happy to see that you started working on this. Let me know if
you need help to update the Ocelot/Felix driver to support this.

/Allan

On 22.05.2020 00:10, Vladimir Oltean wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
>This is a WIP series whose stated goal is to allow DSA and switchdev
>drivers to flood less traffic to the CPU while keeping the same level of
>functionality.
>
>The strategy is to whitelist towards the CPU only the {DMAC, VLAN} pairs
>that the operating system has expressed its interest in, either due to
>those being the MAC addresses of one of the switch ports, or addresses
>added to our device's RX filter via calls to dev_uc_add/dev_mc_add.
>Then, the traffic which is not explicitly whitelisted is not sent by the
>hardware to the CPU, under the assumption that the CPU didn't ask for it
>and would have dropped it anyway.
>
>The ground for these patches were the discussions surrounding RX
>filtering with switchdev in general, as well as with DSA in particular:
>
>"[PATCH net-next 0/4] DSA: promisc on master, generic flow dissector code":
>https://www.spinics.net/lists/netdev/msg651922.html
>"[PATCH v3 net-next 2/2] net: dsa: felix: Allow unknown unicast traffic towards the CPU port module":
>https://www.spinics.net/lists/netdev/msg634859.html
>"[PATCH v3 0/2] net: core: Notify on changes to dev->promiscuity":
>https://lkml.org/lkml/2019/8/29/255
>LPC2019 - SwitchDev offload optimizations:
>https://www.youtube.com/watch?v=B1HhxEcU7Jg
>
>Unicast filtering comes to me as most important, and this includes
>termination of MAC addresses corresponding to the network interfaces in
>the system (DSA switch ports, VLAN sub-interfaces, bridge interface).
>The first 4 patches use Ivan Khoronzhuk's IVDF framework for extending
>network interface addresses with a Virtual ID (typically VLAN ID). This
>matches DSA switches perfectly because their FDB already contains keys
>of the {DMAC, VID} form.
>
>Multicast filtering was taken and reworked from Florian Fainelli's
>previous attempts, according to my own understanding of multicast
>forwarding requirements of an IGMP snooping switch. This is the part
>that needs the most extra work, not only in the DSA core but also in
>drivers. For this reason, I've left out of this patchset anything that
>has to do with driver-level configuration (since the audience is a bit
>larger than usual), as I'm trying to focus more on policy for now, and
>the series is already pretty huge.
>
>Florian Fainelli (3):
>  net: bridge: multicast: propagate br_mc_disabled_update() return
>  net: dsa: add ability to program unicast and multicast filters for CPU
>    port
>  net: dsa: wire up multicast IGMP snooping attribute notification
>
>Ivan Khoronzhuk (4):
>  net: core: dev_addr_lists: add VID to device address
>  net: 8021q: vlan_dev: add vid tag to addresses of uc and mc lists
>  net: 8021q: vlan_dev: add vid tag for vlan device own address
>  ethernet: eth: add default vid len for all ethernet kind devices
>
>Vladimir Oltean (6):
>  net: core: dev_addr_lists: export some raw __hw_addr helpers
>  net: dsa: don't use switchdev_notifier_fdb_info in
>    dsa_switchdev_event_work
>  net: dsa: mroute: don't panic the kernel if called without the prepare
>    phase
>  net: bridge: add port flags for host flooding
>  net: dsa: deal with new flooding port attributes from bridge
>  net: dsa: treat switchdev notifications for multicast router connected
>    to port
>
> include/linux/if_bridge.h |   3 +
> include/linux/if_vlan.h   |   2 +
> include/linux/netdevice.h |  11 ++
> include/net/dsa.h         |  17 +++
> net/8021q/Kconfig         |  12 ++
> net/8021q/vlan.c          |   3 +
> net/8021q/vlan.h          |   2 +
> net/8021q/vlan_core.c     |  25 ++++
> net/8021q/vlan_dev.c      | 102 +++++++++++---
> net/bridge/br_if.c        |  40 ++++++
> net/bridge/br_multicast.c |  21 ++-
> net/bridge/br_switchdev.c |   4 +-
> net/core/dev_addr_lists.c | 144 +++++++++++++++----
> net/dsa/Kconfig           |   1 +
> net/dsa/dsa2.c            |   6 +
> net/dsa/dsa_priv.h        |  27 +++-
> net/dsa/port.c            | 155 ++++++++++++++++----
> net/dsa/slave.c           | 288 +++++++++++++++++++++++++++++++-------
> net/dsa/switch.c          |  36 +++++
> net/ethernet/eth.c        |  12 +-
> 20 files changed, 780 insertions(+), 131 deletions(-)
>
>--
>2.25.1
>
/Allan
