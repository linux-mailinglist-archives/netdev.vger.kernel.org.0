Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CED416C175
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 13:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbgBYMzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 07:55:49 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:28411 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729066AbgBYMzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 07:55:49 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: Un2Z847CYaRyvb8ZyViBhqEZMsIgTP62wyTalxS1DMmhrwaDLnO7fiqvQEl01xQd3l8dOjeipc
 LwCuzuUbWegGZlBdmObLCcaAYrv6WGgMXA12MLB5MoyrVfzC9Z6H7ey7XheDkXL2nC/FufzOMv
 gx8enw/8KHbhWIWOvi7eV71x3zuydCTmC4722t/5Hxtm6tUsbkPOG5Vz7biuGcuw9J17WD/erb
 vCuTW39oQo8frdFfGsZwrV2GHDbNDSvk+7uxRZ33YA7eQZUkeyeWGp46nt2vogTEd7XThhmwWp
 z2s=
X-IronPort-AV: E=Sophos;i="5.70,484,1574146800"; 
   d="scan'208";a="66642402"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Feb 2020 05:55:48 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 25 Feb 2020 05:55:58 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 25 Feb 2020 05:55:46 -0700
Date:   Tue, 25 Feb 2020 13:55:46 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <horatiu.vultur@microchip.com>,
        <alexandre.belloni@bootlin.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <joergen.andreasen@microchip.com>, <alexandru.marginean@nxp.com>,
        <claudiu.manoil@nxp.com>, <xiaoliang.yang_1@nxp.com>,
        <yangbo.lu@nxp.com>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v2 net-next 1/2] net: mscc: ocelot: eliminate confusion
 between CPU and NPI port
Message-ID: <20200225125546.l32oe6ikwmamf6e3@lx-anielsen.microsemi.net>
References: <20200224213458.32451-1-olteanv@gmail.com>
 <20200224213458.32451-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200224213458.32451-2-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.02.2020 23:34, Vladimir Oltean wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
>In Ocelot, the CPU port module is a set of queues which, depending upon
>hardware integration, may be connected to a DMA engine or similar
>(register access), or to an Ethernet port (the so-called NPI mode).
>
>The CPU port module has a [fixed] number, just like the physical switch
>ports.  In VSC7514 (a 10-port switch), there are 2 CPU port modules -
>ports 10 and 11, aka the eleventh and twelfth port.
In Ocelot, there is only 1 CPU port (from the analysers perspective -
which this is about). This is why the ANA:PORT group has index 0-11 and
DEV has index 0-10.

So in Ocelot the CPU is port 11 (the twelfth port).

The 2 CPU mentioned in the DS is because it has two extraction channels
(register based or DMA based).

>Similarly, in VSC9959 (a 6-port switch), the CPU port module is port 6,
>the seventh port.
>
>The VSC7514 instantiation (ocelot_board.c) uses register access for
>frame injection/extraction, while the VSC9959 instantiation
>(felix_vsc9959.c) uses an NPI port. The NPI functionality is actually
>equivalent to the "CPU port" concept from DSA, hence the tendency of
>using the ocelot->cpu variable to hold:
> - The CPU port module, for the switchdev ocelot_board.c
> - The NPI port, for the DSA felix_vsc9959.c
>
>But Ocelot and Felix have been operating in different hardware modes,
>with 2 very different things being configured by the same "ocelot->cpu"
>umbrella. The difference has to do with how a frame reaches the CPU with
>the Ocelot switch.

>The CPU port module has a "god mode" view of the switch. Even though it
>is assigned a number in hardware just like the physical ports, the CPU
>port doesn't need to be in the forwarding matrix of the other source
>ports (PGID_SRC + p, where p is a physical port) in order to be able to
>receive frames from them.
Actually it does not matter if it is there.

>The actual process by which the CPU sees frames in Ocelot is by
>"copying" them to the CPU.
This is not true. Normal traffic to the CPU is L2 forwarded to the CPU
via the MAC table. As I explained in an earlier mail, it can also be
flooded to the CPU.

>This is a term used in the hardware docs which means that the frames
>are "mirrored" to the CPU port. The distinction here is that the frames
>are not supposed to reach the CPU through the regular L2 forwarding
>process. Instead, there is a meticulous hardware process in place, by
>which the destination PGIDs (aka PGIDs in the range 0-63) which have
>BIT(ocelot->num_phys_ports) set will cause the frames to be copied
>[unconditionally] to the CPU.
Not true.

>In the way the Ocelot driver sets the destination PGIDs up, these
>destination PGIDs are _only_ PGID_CPU and PGID_MC. So a frame is not
>supposed to reach the CPU via any other mechanism.

>On the other hand, the NPI port, as currently configured for Felix, the
>DSA consumer of Ocelot, is set up to receive frames via L2 forwarding.
>So in that case, the forwarding matrix does indeed need to contain the
>NPI port as a valid destination port for all other ports, via the
>PGID_SRC + p source port masks.
>
>But the NPI port doesn't benefit from the "god mode" view that the CPU
>port module has upon the other switch ports, or at least not in the L2
>forwarding way of frames reaching it. It is literally only the CPU port
>(the first non-physical port) who has the power of getting frames
>copied.
Yes, the CPU port is special, which is why it should be used even when
connected to the CPU via a NPI port.

>In Ocelot, CPU copying works because PGID_CPU contains ocelot->cpu which
>is 11 (the CPU port module).
>In Felix, CPU copying doesn't work, because PGID_CPU contains
>ocelot->cpu which is the NPI port (a number in the range 0-5, definitely
>not 6 which would be the CPU port module).
>
>But in the way that the NPI port is supposed to be used, it should
>actually be configured such that the CPU port module just sends all
>traffic to it (it is connected to the queues). So we can get all
>benefits of the CPU port module in NPI mode as well.
>
>Doing this configuration change for Felix is mostly a mindset thing: we
>need to make the distinction between the CPU port module and the NPI
>port. This is a bit unfortunate for readers accustomed with the DSA
>terminology. The DSA CPU port is the NPI port, while the CPU port module
>is fixed at 6 and has no equivalent.
>
>We need to stop calling the NPI port ocelot->cpu, and we need to stop
>trying to make frames reach the NPI port directly via forwarding. The
>result is a code simplification.

This was a really long explanation (almost correct per my understanding,
but not entirely). I'm okay with this but I think it could be explained
better.

Here is my understanding of what is going on in the chip and in this
patch:

"
Ocelot has a concept of a CPU port. The CPU port is represented in the
forwarding and the queueing system, but it is not a physical device. The
CPU port can either be accessed via register-based injection/extraction
(which is the case of Ocelot), via Frame-DMA (similar to the first one),
or "connected" to a physical port (called NPI in the datasheet) which is
the case of Felix.

In Ocelot the CPU port is at index 11.
In Felix the CPU port is at index 6.

The CPU bit is treated special in the forwarding, as it is never cleared
from a forwarding mask (once added to the mask). Other from that it is
the same as a normal front port.

Both Felix and Ocelot should use the CPU port in the same way. This
means that Felix should not use the NPI port directly when forwarding to
the CPU, but instead use the CPU port.

This patch is fixing this such that Felix will use port 6 as its CPU
port, and just use the NPI port to carry the traffic.
"

Vladimir, it is up to you if you want to update this. If you spin
another version of this, then please delete the num_cpu_ports variable
as well (see below).

/Allan


>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>---
> drivers/net/dsa/ocelot/felix.c           |  7 +--
> drivers/net/ethernet/mscc/ocelot.c       | 62 ++++++++++++++----------
> drivers/net/ethernet/mscc/ocelot_board.c |  5 +-
> include/soc/mscc/ocelot.h                |  7 ++-
> net/dsa/tag_ocelot.c                     |  3 +-
> 5 files changed, 48 insertions(+), 36 deletions(-)
>
>diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
>index 35124ef7e75b..17f84c636c8f 100644
>--- a/drivers/net/dsa/ocelot/felix.c
>+++ b/drivers/net/dsa/ocelot/felix.c
>@@ -510,10 +510,11 @@ static int felix_setup(struct dsa_switch *ds)
>        for (port = 0; port < ds->num_ports; port++) {
>                ocelot_init_port(ocelot, port);
>
>+               /* Bring up the CPU port module and configure the NPI port */
>                if (dsa_is_cpu_port(ds, port))
>-                       ocelot_set_cpu_port(ocelot, port,
>-                                           OCELOT_TAG_PREFIX_NONE,
>-                                           OCELOT_TAG_PREFIX_LONG);
>+                       ocelot_configure_cpu(ocelot, port,
>+                                            OCELOT_TAG_PREFIX_NONE,
>+                                            OCELOT_TAG_PREFIX_LONG);
>        }
>
>        /* It looks like the MAC/PCS interrupt register - PM0_IEVENT (0x8040)
>diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
>index 86d543ab1ab9..341092f9097c 100644
>--- a/drivers/net/ethernet/mscc/ocelot.c
>+++ b/drivers/net/ethernet/mscc/ocelot.c
>@@ -1398,7 +1398,7 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
>         * a source for the other ports.
>         */
>        for (p = 0; p < ocelot->num_phys_ports; p++) {
>-               if (p == ocelot->cpu || (ocelot->bridge_fwd_mask & BIT(p))) {
>+               if (ocelot->bridge_fwd_mask & BIT(p)) {
>                        unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(p);
>
>                        for (i = 0; i < ocelot->num_phys_ports; i++) {
>@@ -1413,18 +1413,10 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
>                                }
>                        }
>
>-                       /* Avoid the NPI port from looping back to itself */
>-                       if (p != ocelot->cpu)
>-                               mask |= BIT(ocelot->cpu);
>-
>                        ocelot_write_rix(ocelot, mask,
>                                         ANA_PGID_PGID, PGID_SRC + p);
>                } else {
>-                       /* Only the CPU port, this is compatible with link
>-                        * aggregation.
>-                        */
>-                       ocelot_write_rix(ocelot,
>-                                        BIT(ocelot->cpu),
>+                       ocelot_write_rix(ocelot, 0,
>                                         ANA_PGID_PGID, PGID_SRC + p);
>                }
>        }
>@@ -2293,27 +2285,34 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
> }
> EXPORT_SYMBOL(ocelot_probe_port);
>
>-void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
>-                        enum ocelot_tag_prefix injection,
>-                        enum ocelot_tag_prefix extraction)
>+/* Configure and enable the CPU port module, which is a set of queues.
>+ * If @npi contains a valid port index, the CPU port module is connected
>+ * to the Node Processor Interface (NPI). This is the mode through which
>+ * frames can be injected from and extracted to an external CPU,
>+ * over Ethernet.
>+ */
>+void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
>+                         enum ocelot_tag_prefix injection,
>+                         enum ocelot_tag_prefix extraction)
> {
>-       /* Configure and enable the CPU port. */
>+       int cpu = ocelot->num_phys_ports;
>+
>+       /* The unicast destination PGID for the CPU port module is unused */
>        ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, cpu);
>+       /* Instead set up a multicast destination PGID for traffic copied to
>+        * the CPU. Whitelisted MAC addresses like the port netdevice MAC
>+        * addresses will be copied to the CPU via this PGID.
>+        */
>        ocelot_write_rix(ocelot, BIT(cpu), ANA_PGID_PGID, PGID_CPU);
>        ocelot_write_gix(ocelot, ANA_PORT_PORT_CFG_RECV_ENA |
>                         ANA_PORT_PORT_CFG_PORTID_VAL(cpu),
>                         ANA_PORT_PORT_CFG, cpu);
>
>-       /* If the CPU port is a physical port, set up the port in Node
>-        * Processor Interface (NPI) mode. This is the mode through which
>-        * frames can be injected from and extracted to an external CPU.
>-        * Only one port can be an NPI at the same time.
>-        */
>-       if (cpu < ocelot->num_phys_ports) {
>+       if (npi >= 0 && npi < ocelot->num_phys_ports) {
>                int mtu = VLAN_ETH_FRAME_LEN + OCELOT_TAG_LEN;
>
>                ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
>-                            QSYS_EXT_CPU_CFG_EXT_CPU_PORT(cpu),
>+                            QSYS_EXT_CPU_CFG_EXT_CPU_PORT(npi),
>                             QSYS_EXT_CPU_CFG);
>
>                if (injection == OCELOT_TAG_PREFIX_SHORT)
>@@ -2321,14 +2320,27 @@ void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
>                else if (injection == OCELOT_TAG_PREFIX_LONG)
>                        mtu += OCELOT_LONG_PREFIX_LEN;
>
>-               ocelot_port_set_mtu(ocelot, cpu, mtu);
>+               ocelot_port_set_mtu(ocelot, npi, mtu);
>+
>+               /* Enable NPI port */
>+               ocelot_write_rix(ocelot,
>+                                QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
>+                                QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
>+                                QSYS_SWITCH_PORT_MODE_PORT_ENA,
>+                                QSYS_SWITCH_PORT_MODE, npi);
>+               /* NPI port Injection/Extraction configuration */
>+               ocelot_write_rix(ocelot,
>+                                SYS_PORT_MODE_INCL_XTR_HDR(extraction) |
>+                                SYS_PORT_MODE_INCL_INJ_HDR(injection),
>+                                SYS_PORT_MODE, npi);
>        }
>
>-       /* CPU port Injection/Extraction configuration */
>+       /* Enable CPU port module */
>        ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
>                         QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
>                         QSYS_SWITCH_PORT_MODE_PORT_ENA,
>                         QSYS_SWITCH_PORT_MODE, cpu);
>+       /* CPU port Injection/Extraction configuration */
>        ocelot_write_rix(ocelot, SYS_PORT_MODE_INCL_XTR_HDR(extraction) |
>                         SYS_PORT_MODE_INCL_INJ_HDR(injection),
>                         SYS_PORT_MODE, cpu);
>@@ -2338,10 +2350,8 @@ void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
>                                 ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
>                                 ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1),
>                         ANA_PORT_VLAN_CFG, cpu);
>-
>-       ocelot->cpu = cpu;
> }
>-EXPORT_SYMBOL(ocelot_set_cpu_port);
>+EXPORT_SYMBOL(ocelot_configure_cpu);
>
> int ocelot_init(struct ocelot *ocelot)
> {
>diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
>index 1135a18019c7..7c3dae87d505 100644
>--- a/drivers/net/ethernet/mscc/ocelot_board.c
>+++ b/drivers/net/ethernet/mscc/ocelot_board.c
>@@ -363,8 +363,9 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>                                     sizeof(struct ocelot_port *), GFP_KERNEL);
>
>        ocelot_init(ocelot);
>-       ocelot_set_cpu_port(ocelot, ocelot->num_phys_ports,
>-                           OCELOT_TAG_PREFIX_NONE, OCELOT_TAG_PREFIX_NONE);
>+       /* No NPI port */
>+       ocelot_configure_cpu(ocelot, -1, OCELOT_TAG_PREFIX_NONE,
>+                            OCELOT_TAG_PREFIX_NONE);
>
>        for_each_available_child_of_node(ports, portnp) {
>                struct ocelot_port_private *priv;
>diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
>index 068f96b1a83e..abe912715b54 100644
>--- a/include/soc/mscc/ocelot.h
>+++ b/include/soc/mscc/ocelot.h
>@@ -449,7 +449,6 @@ struct ocelot {
>

Can we add a comment here explaining that the CPU port is at index
'num_phys_ports'. Something like:

          /* In tables like ANA:PORT and the ANA:PGID:PGID
           * mask the CPU is located after the physical ports (at
           * num_phys_ports index).
           */
>        u8                              num_phys_ports;
>        u8                              num_cpu_ports;
Maybe we should also delete the num_cpu_ports as part of this clean up.
I think it was introduced as a misunderstanding.

>-       u8                              cpu;
>
>        u32                             *lags;
>
>@@ -500,9 +499,9 @@ void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
> int ocelot_regfields_init(struct ocelot *ocelot,
>                          const struct reg_field *const regfields);
> struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res);
>-void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
>-                        enum ocelot_tag_prefix injection,
>-                        enum ocelot_tag_prefix extraction);
>+void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
>+                         enum ocelot_tag_prefix injection,
>+                         enum ocelot_tag_prefix extraction);
> int ocelot_init(struct ocelot *ocelot);
> void ocelot_deinit(struct ocelot *ocelot);
> void ocelot_init_port(struct ocelot *ocelot, int port);
>diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
>index 8e3e7283d430..59de1315100f 100644
>--- a/net/dsa/tag_ocelot.c
>+++ b/net/dsa/tag_ocelot.c
>@@ -153,7 +153,8 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
>
>        memset(injection, 0, OCELOT_TAG_LEN);
>
>-       src = dsa_upstream_port(ds, port);
>+       /* Set the source port as the CPU port module and not the NPI port */
>+       src = ocelot->num_phys_ports;
>        dest = BIT(port);
>        bypass = true;
>        qos_class = skb->priority;
>--
>2.17.1
>
/Allan
