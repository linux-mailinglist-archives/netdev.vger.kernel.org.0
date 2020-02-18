Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5483D16258E
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 12:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgBRLcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 06:32:19 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:34716 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgBRLcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 06:32:19 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: XdQVMSiLAvtdWjTpV4I1RAoN39BlxpCNoQNtQBktHcxJuAWLabQRxYFYdcSTiVywLSeV/uLJco
 Aw25TRvbOBDzwGMB2nOpp75g6gfYyfaCa2/al9mSPDeZLJT5YCzb3pya13/U6OG1vUN9JnChDl
 zcuEhJ0Pt7emosqYzyOHyT4p3FyUn7h1mOycRy/bXYEDT2fDG84DOPPcYw3gx3BnHT8Xny7vr4
 yoxWHd3sgkC5HRYSv4wmqSZV1tPPOw0Un10kYHMQ3YfOsKL89fQWl2WsE+U9yCn2xdE77Vh8gF
 cPk=
X-IronPort-AV: E=Sophos;i="5.70,456,1574146800"; 
   d="scan'208";a="68891879"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Feb 2020 04:32:17 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 18 Feb 2020 04:32:01 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 18 Feb 2020 04:31:55 -0700
Date:   Tue, 18 Feb 2020 12:31:59 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <horatiu.vultur@microchip.com>,
        <alexandre.belloni@bootlin.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <joergen.andreasen@microchip.com>, <claudiu.manoil@nxp.com>,
        <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: Workaround to allow traffic
 to CPU in standalone mode
Message-ID: <20200218113159.qiema7jj2b3wq5bb@lx-anielsen.microsemi.net>
References: <20200217150058.5586-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200217150058.5586-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.02.2020 17:00, Vladimir Oltean wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
>The Ocelot switches have what is, in my opinion, a design flaw: their
>DSA header is in front of the Ethernet header, which means that they
>subvert the DSA master's RX filter, which for all practical purposes,
>either needs to be in promiscuous mode, or the OCELOT_TAG_PREFIX_LONG
>needs to be used for extraction, which makes the switch add a fake DMAC
>of ff:ff:ff:ff:ff:ff so that the DSA master accepts the frame.
>
>The issue with this design, of course, is that the CPU will be spammed
>with frames that it doesn't want to respond to, and there isn't any
>hardware offload in place by default to drop them.
In the case of Ocelot, the NPI port is expected to be connected back to
back to the CPU, meaning that it should not matter what DMAC is set.

It was also my understanding that this is how you have connected this.

I'm not able to see why this would cause spamming.

>What is being done in the VSC7514 Ocelot driver is a process of
>selective whitelisting. The "MAC address" of each Ocelot switch net
>device, with all VLANs installed on that port, is being added as a FDB
>entry towards PGID_CPU.
>
>PGID_CPU is is a multicast set containing only BIT(cpu). I don't know
>why it was chosen to be a multicast PGID (59) and not simply the unicast
>one of this port, but it doesn't matter. The point is that the the CPU
>port is special, and frames are "copied" to the CPU, disregarding the
>source masks (third PGID lookup), if BIT(cpu) is found to be set in the
>destination masks (first PGID lookup).
>
>Frames that match the FDB will go to PGID_CPU by virtue of the DEST_IDX
>from the respective MAC table entry, and frames that don't will go to
>PGID_UC or PGID_MC, by virtue of the FLD_UNICAST, FLD_BROADCAST etc
>settings for flooding. And that is where the distinction is made:
>flooded frames will be subject to the third PGID lookup, while frames
>that are whitelisted to the PGID_CPU by the MAC table aren't.
>
>So we can use this mechanism to simulate an RX filter, given that we are
>subverting the DSA master's implicit one, as mentioned in the first
>paragraph. But this has some limitations:
>
>- In Ocelot each net device has its own MAC address. When simulating
>  this with MAC table entries, it will practically result in having N
>  MAC addresses for each of the N front-panel ports (because FDB entries
>  are not per source port). A bit strange, I think.
>
>- In DSA we don't have the infrastructure in place to support this
>  whitelisting mechanism. Calling .port_fdb_add on the CPU port for each
>  slave net device dev_addr isn't, in itself, hard. The problem is with
>  the VLANs that this port is part of. We would need to keep a duplicate
>  list of the VLANs from the bridge, plus the ones added from 8021q, for
>  each port. And we would need reference counting on each MAC address,
>  such that when a front-panel port changes its MAC address and we need
>  to delete the old FDB entry, we don't actually delete it if the other
>  front-panel ports are still using it. Not to mention that this FDB
>  entry would have to be added on the whole net of upstream DSA switches.
>
>- Cascading a different DSA switch that has tags before the Ethernet
>  header would not possibly work if we rely on the whitelisting
>  mechanism exclusively.
>
>So... it's complicated. What this patch does is to simply allow frames
>to be flooded to the CPU, which is anyway what the Ocelot driver is
>doing after removing the bridge from the net devices, see this snippet
>from ocelot_bridge_stp_state_set:
>
>    /* Apply FWD mask. The loop is needed to add/remove the current port as
>     * a source for the other ports.
>     */
>    for (p = 0; p < ocelot->num_phys_ports; p++) {
>            if (p == ocelot->cpu || (ocelot->bridge_fwd_mask & BIT(p))) {
>                    (...)
>            } else {
>                    /* Only the CPU port, this is compatible with link
>                     * aggregation.
>                     */
>                    ocelot_write_rix(ocelot,
>                                     BIT(ocelot->cpu),
>                                     ANA_PGID_PGID, PGID_SRC + p);
>            }
>
>Otherwise said, the ocelot driver itself is already not self-coherent,
>since immediately after probe time, and immediately after removal from a
>bridge, it behaves in different ways, although the front panel ports are
>standalone in both cases.
Maybe you found a bug, maybe you have different expectations.

The idea is that after probe time all the ports must behave as NIC
devices. No forwarding are being done, and all traffic is copied to the
CPU.

When a port is added to the bridge, the given ports-bit must be set in
the PGID_SRC.

As I read the code, this seems to be done right. If you believe you have
found a bug regarding this then please clarify this a bit.

>While standalone traffic _does_ work for the Felix DSA wrapper after
>enslaving and removing the ports from a bridge, this patch makes
>standalone traffic work at probe time too, with the caveat that even
>irrelevant frames will get processed by software, making it more
>susceptible to potential denial of service.
>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>---
> drivers/net/ethernet/mscc/ocelot.c | 12 ++++++++++++
> 1 file changed, 12 insertions(+)
>
>diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
>index 86d543ab1ab9..94d39ccea017 100644
>--- a/drivers/net/ethernet/mscc/ocelot.c
>+++ b/drivers/net/ethernet/mscc/ocelot.c
>@@ -2297,6 +2297,18 @@ void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
>                         enum ocelot_tag_prefix injection,
>                         enum ocelot_tag_prefix extraction)
> {
>+       int port;
>+
>+       for (port = 0; port < ocelot->num_phys_ports; port++) {
>+               /* Disable old CPU port and enable new one */
>+               ocelot_rmw_rix(ocelot, 0, BIT(ocelot->cpu),
>+                              ANA_PGID_PGID, PGID_SRC + port);
I do not understand why you have an "old" CPU. The ocelot->cpu field is
not initialized at this point (at least not in case of Ocelot).

Are you trying to move the NPI port?

>+               if (port == cpu)
>+                       continue;
>+               ocelot_rmw_rix(ocelot, BIT(cpu), BIT(cpu),
>+                              ANA_PGID_PGID, PGID_SRC + port);
So you want all ports to be able to forward traffic to your CPU port,
regardless of if these ports are member of a bridge...

I have read through this several times, and I'm still not convinced I
understood it.

Can you please provide a specific example of how things are being
forwarded (wrongly), and describe how you would like them to be
forwarded.

/Allan

