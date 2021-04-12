Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9906D35D3B4
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 01:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344010AbhDLXEq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Apr 2021 19:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241815AbhDLXEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 19:04:45 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84F5C061574;
        Mon, 12 Apr 2021 16:04:26 -0700 (PDT)
Received: from thinkpad (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 0FA8B13FC7A;
        Tue, 13 Apr 2021 01:04:24 +0200 (CEST)
Date:   Tue, 13 Apr 2021 01:04:23 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20210413010423.6986bd85@thinkpad>
In-Reply-To: <20210412224805.sgweqvx7ngbtmf4n@skbuf>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
        <20210411200135.35fb5985@thinkpad>
        <20210411185017.3xf7kxzzq2vefpwu@skbuf>
        <878s5nllgs.fsf@waldekranz.com>
        <20210412213045.4277a598@thinkpad>
        <8735vvkxju.fsf@waldekranz.com>
        <20210412213402.vwvon2fdtzf4hnrt@skbuf>
        <87zgy3jhr1.fsf@waldekranz.com>
        <20210412220655.27rsiyxlf3f3tydm@skbuf>
        <87tuobjg0j.fsf@waldekranz.com>
        <20210412224805.sgweqvx7ngbtmf4n@skbuf>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021 01:48:05 +0300
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Tue, Apr 13, 2021 at 12:26:52AM +0200, Tobias Waldekranz wrote:
> > On Tue, Apr 13, 2021 at 01:06, Vladimir Oltean <olteanv@gmail.com> wrote:  
> > > On Mon, Apr 12, 2021 at 11:49:22PM +0200, Tobias Waldekranz wrote:  
> > >> On Tue, Apr 13, 2021 at 00:34, Vladimir Oltean <olteanv@gmail.com> wrote:  
> > >> > On Mon, Apr 12, 2021 at 11:22:45PM +0200, Tobias Waldekranz wrote:  
> > >> >> On Mon, Apr 12, 2021 at 21:30, Marek Behun <marek.behun@nic.cz> wrote:  
> > >> >> > On Mon, 12 Apr 2021 14:46:11 +0200
> > >> >> > Tobias Waldekranz <tobias@waldekranz.com> wrote:
> > >> >> >  
> > >> >> >> I agree. Unless you only have a few really wideband flows, a LAG will
> > >> >> >> typically do a great job with balancing. This will happen without the
> > >> >> >> user having to do any configuration at all. It would also perform well
> > >> >> >> in "router-on-a-stick"-setups where the incoming and outgoing port is
> > >> >> >> the same.  
> > >> >> >
> > >> >> > TLDR: The problem with LAGs how they are currently implemented is that
> > >> >> > for Turris Omnia, basically in 1/16 of configurations the traffic would
> > >> >> > go via one CPU port anyway.
> > >> >> >
> > >> >> >
> > >> >> >
> > >> >> > One potencial problem that I see with using LAGs for aggregating CPU
> > >> >> > ports on mv88e6xxx is how these switches determine the port for a
> > >> >> > packet: only the src and dst MAC address is used for the hash that
> > >> >> > chooses the port.
> > >> >> >
> > >> >> > The most common scenario for Turris Omnia, for example, where we have 2
> > >> >> > CPU ports and 5 user ports, is that into these 5 user ports the user
> > >> >> > plugs 5 simple devices (no switches, so only one peer MAC address for
> > >> >> > port). So we have only 5 pairs of src + dst MAC addresses. If we simply
> > >> >> > fill the LAG table as it is done now, then there is 2 * 0.5^5 = 1/16
> > >> >> > chance that all packets would go through one CPU port.
> > >> >> >
> > >> >> > In order to have real load balancing in this scenario, we would either
> > >> >> > have to recompute the LAG mask table depending on the MAC addresses, or
> > >> >> > rewrite the LAG mask table somewhat randomly periodically. (This could
> > >> >> > be in theory offloaded onto the Z80 internal CPU for some of the
> > >> >> > switches of the mv88e6xxx family, but not for Omnia.)  
> > >> >> 
> > >> >> I thought that the option to associate each port netdev with a DSA
> > >> >> master would only be used on transmit. Are you saying that there is a
> > >> >> way to configure an mv88e6xxx chip to steer packets to different CPU
> > >> >> ports depending on the incoming port?
> > >> >> 
> > >> >> The reason that the traffic is directed towards the CPU is that some
> > >> >> kind of entry in the ATU says so, and the destination of that entry will
> > >> >> either be a port vector or a LAG. Of those two, only the LAG will offer
> > >> >> any kind of balancing. What am I missing?
> > >> >> 
> > >> >> Transmit is easy; you are already in the CPU, so you can use an
> > >> >> arbitrarily fancy hashing algo/ebpf classifier/whatever to load balance
> > >> >> in that case.  
> > >> >
> > >> > Say a user port receives a broadcast frame. Based on your understanding
> > >> > where user-to-CPU port assignments are used only for TX, which CPU port
> > >> > should be selected by the switch for this broadcast packet, and by which
> > >> > mechanism?  
> > >> 
> > >> AFAIK, the only option available to you (again, if there is no LAG set
> > >> up) is to statically choose one CPU port per entry. But hopefully Marek
> > >> can teach me some new tricks!
> > >> 
> > >> So for any known (since the broadcast address is loaded in the ATU it is
> > >> known) destination (b/m/u-cast), you can only "load balance" based on
> > >> the DA. You would also have to make sure that unknown unicast and
> > >> unknown multicast is only allowed to egress one of the CPU ports.
> > >> 
> > >> If you have a LAG OTOH, you could include all CPU ports in the port
> > >> vectors of those same entries. The LAG mask would then do the final
> > >> filtering so that you only send a single copy to the CPU.  
> > >
> > > I forgot that mv88e6xxx keeps the broadcast address in the ATU. I wanted
> > > to know what is done in the flooding case, therefore I should have asked
> > > about unknown destination traffic. It is sent to one CPU but not the
> > > other based on what information?
> > >
> > > And for destinations loaded into the ATU, how is user port isolation
> > > performed? Say lan0 and lan1 have the same MAC address of 00:01:02:03:04:05,
> > > but lan0 goes to the eth0 DSA master and lan1 goes to eth1. How many ATU
> > > entries would there be for host addresses, and towards which port would
> > > they point? Are they isolated by a port private VLAN or something along
> > > those lines?  
> > 
> > This is what I do not understand. This is what I hope that Marek can
> > tell me. To my knowledge, there is no way to per-port load balancing
> > from the switch to the CPU. In any given FID, there can be only one
> > entry per address, and that entry can only point to either a vector or a
> > LAG.
> > 
> > So my theory is that the only way of getting any load balancing, however
> > flawed, on receive (from switch to CPU) is by setting up a
> > LAG. Hopefully there is some trick that I do not know about which means
> > we have another option available to us.  
> 
> Understood. So as far as you know the Marvell Linkstreet hardware
> capabilities, it isn't possible to do a clean-cut "all traffic from port
> X goes to CPU port A and none to B", but instead it's more of a mushy
> mess like "unknown unicast is flooded to CPU port A, unknown multicast
> to CPU port B, MAC address 00:01:02:03:04:05 may go to CPU port A, MAC
> address 00:01:02:03:04:06 to CPU port B". Basically an open-coded mess
> of a LAG handled by some logic like DSA, once the RX filtering series
> gets merged. Until then, all traffic to the CPU is unknown-destination
> traffic as long as I know the mv88e6xxx (due to that limitation where it
> doesn't learn from the MAC SA of FROM_CPU packets, and DSA does not
> install into the ATU any of the host addresses, nor does it send any
> FORWARD frames). But if this is the case and everything towards the CPU
> is currently flooded, what sort of load balancing do we even have?
> Between unknown unicast and unknown multicast? :)
> 
> So excuse me for believing that the hardware is capable of doing what
> these 3 patches pretend without seeing the driver-side code!

I just now noticed that this series does not include the proposed code
change for mv88e6xxx.

I am attaching below a patch we use for our TurrisOS 5.4 kernel that
uses this API for Omnia in the mv88e6xxx driver.

Subject: [PATCH] net: dsa: mv88e6xxx: support multi-CPU DSA
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add support for multi-CPU DSA for mv88e6xxx.
Currently only works with multiple CPUs when there is only one switch in
the switch tree.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 48 ++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 33b391376352..804ba563540e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1080,6 +1080,7 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 {
 	struct dsa_switch *ds = NULL;
 	struct net_device *br;
+	u8 upstream;
 	u16 pvlan;
 	int i;
 
@@ -1091,17 +1092,36 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 		return 0;
 
 	/* Frames from DSA links and CPU ports can egress any local port */
-	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
+	if (dsa_is_dsa_port(ds, port))
 		return mv88e6xxx_port_mask(chip);
 
+	if (dsa_is_cpu_port(ds, port)) {
+		u16 pmask = mv88e6xxx_port_mask(chip);
+		pvlan = 0;
+
+		for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
+			if (dsa_is_cpu_port(ds, i)) {
+				if (i == port)
+					pvlan |= BIT(i);
+				continue;
+			}
+			if ((pmask & BIT(i)) &&
+			     dsa_upstream_port(chip->ds, i) == port)
+				pvlan |= BIT(i);
+		}
+
+		return pvlan;
+	}
+
 	br = ds->ports[port].bridge_dev;
 	pvlan = 0;
 
 	/* Frames from user ports can egress any local DSA links and CPU ports,
 	  * as well as any local member of their bridge group.
 	  */
+	upstream = dsa_upstream_port(chip->ds, port);
 	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i)
-		if (dsa_is_cpu_port(chip->ds, i) ||
+		if ((dsa_is_cpu_port(chip->ds, i) && i == upstream) ||
 		     dsa_is_dsa_port(chip->ds, i) ||
 		     (br && dsa_to_port(chip->ds, i)->bridge_dev == br))
 			pvlan |= BIT(i);
@@ -2388,6 +2408,7 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 	}
 
 	if (port == upstream_port) {
+		dev_info(chip->dev, "Setting CPU port as port %i\n", port);
 		if (chip->info->ops->set_cpu_port) {
 			err = chip->info->ops->set_cpu_port(chip,
 							     upstream_port);
@@ -2406,6 +2427,28 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 	return 0;
 }
 
+static int mv88e6xxx_port_change_cpu_port(struct dsa_switch *ds, int port,
+					   struct dsa_port *new_cpu_dp)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+
+	err = mv88e6xxx_setup_upstream_port(chip, port);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_port_vlan_map(chip, port);
+	if (err)
+		goto unlock;
+
+unlock:
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
 static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
 	struct dsa_switch *ds = chip->ds;
@@ -4996,6 +5039,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_hwtstamp_get	= mv88e6xxx_port_hwtstamp_get,
 	.port_txtstamp		= mv88e6xxx_port_txtstamp,
 	.port_rxtstamp		= mv88e6xxx_port_rxtstamp,
+	.port_change_cpu_port	= mv88e6xxx_port_change_cpu_port,
 	.get_ts_info		= mv88e6xxx_get_ts_info,
 };
 
-- 
2.24.1
