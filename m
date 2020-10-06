Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A0B2845CF
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgJFGJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgJFGJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:09:43 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EFFC0613A7;
        Mon,  5 Oct 2020 23:09:42 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601964580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xkKw/KBe2QM6+BRRUnULks28xEE3Zuw6lX7LXsbrlo8=;
        b=EdbEqiZY5mgNAJf/bi7iyeSlmNHr2knystSGbYcLefMOdQOXaBEahG74hKHLRYHgGWR4BQ
        AxNWJSmWnoz4CHQpps5iAl1aJCkVoN4CVDaoIEID6JS36GzF51jE4MZflHMQD9Jz21A08y
        cyBKuOzDOVh2WQqqj0hC5ZJ+jq0CU2nYCvu9JxnS04Y95Oxj9yz21aYpuc2lGmpiF58iA8
        oNaC77eroBWsjXY0/PJLTm59q62PzcHcCumUWtScdPyEqn4Jper5pO1q87wXak1oxdNj9v
        8GhzdXcMOzocVf+2BYIrrshSYY7axG8mKtBfSJT9rbJEh65LSYnZij1NWzHFKA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601964580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xkKw/KBe2QM6+BRRUnULks28xEE3Zuw6lX7LXsbrlo8=;
        b=v/70SZckHEdFDFDrNowD7wK4XpSKuZyY5Ky35lKG9vzrv8EJ6k5a3ZgncWVyqUXExtyG1D
        BCHTl7zXql1kLCBQ==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20201004125601.aceiu4hdhrawea5z@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de> <20201004112911.25085-3-kurt@linutronix.de> <20201004125601.aceiu4hdhrawea5z@skbuf>
Date:   Tue, 06 Oct 2020 08:09:39 +0200
Message-ID: <87lfgj997g.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Vladimir,

thanks for the review.

On Sun Oct 04 2020, Vladimir Oltean wrote:
> On Sun, Oct 04, 2020 at 01:29:06PM +0200, Kurt Kanzenbach wrote:
>> +static int hellcreek_vlan_del(struct dsa_switch *ds, int port,
>> +			      const struct switchdev_obj_port_vlan *vlan)
>> +{
>> +	struct hellcreek *hellcreek = ds->priv;
>> +	u16 vid;
>> +
>> +	dev_dbg(hellcreek->dev, "Remove VLANs (%d -- %d) on port %d\n",
>> +		vlan->vid_begin, vlan->vid_end, port);
>> +
>> +	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
>> +		mutex_lock(&hellcreek->ports[port].vlan_lock);
>> +		if (hellcreek->ports[port].vlan_filtering)
>> +			hellcreek_unapply_vlan(hellcreek, port, vid);
>
> I don't think this works.
>
> ip link add br0 type bridge vlan_filtering 1
> ip link set swp0 master br0
> bridge vlan add dev swp0 vid 100
> ip link set br0 type bridge vlan_filtering 0
> bridge vlan del dev swp0 vid 100
> ip link set br0 type bridge vlan_filtering 1
>
> The expectation would be that swp0 blocks vid 100 now, but with your
> scheme it doesn't (it is not unapplied, and not unqueued either, because
> it was never queued in the first place).

Yes, that's correct. So, I think we have to queue not only the addition
of VLANs, but rather the "action" itself such as add or del. And then
apply all pending actions whenever vlan_filtering is set.

>> +static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
>> +				      struct net_device *br)
>> +{
>> +	struct hellcreek *hellcreek = ds->priv;
>> +	int i;
>> +
>> +	dev_dbg(hellcreek->dev, "Port %d joins a bridge\n", port);
>> +
>> +	/* Configure port's vid to all other ports as egress untagged */
>> +	for (i = 0; i < ds->num_ports; ++i) {
>> +		if (!dsa_is_user_port(ds, i))
>> +			continue;
>> +
>> +		if (i == port)
>> +			continue;
>> +
>> +		hellcreek_apply_vlan(hellcreek, i, port, false, true);
>> +	}
>
> I think this is buggy when joining a VLAN filtering bridge. Your ports
> will pass frames with VID=2 with no problem, even without the user
> specifying 'bridge vlan add dev swp0 vid 2', and that's an issue. My
> understanding is that VLANs 1, 2, 3 stop having any sort of special
> meaning when the upper bridge has vlan_filtering=1.

Yes, that understanding is correct. So, what happens is when a port is
joining a VLAN filtering bridge is:

|root@tsn:~# ip link add name br0 type bridge
|root@tsn:~# ip link set dev br0 type bridge vlan_filtering 1
|root@tsn:~# ip link set dev lan0 master br0
|[  209.375055] br0: port 1(lan0) entered blocking state
|[  209.380073] br0: port 1(lan0) entered disabled state
|[  209.385340] hellcreek ff240000.switch: Port 2 joins a bridge
|[  209.391584] hellcreek ff240000.switch: Apply VLAN: port=3 vid=2 pvid=0 untagged=1
|[  209.399439] device lan0 entered promiscuous mode
|[  209.404043] device eth0 entered promiscuous mode
|[  209.409204] hellcreek ff240000.switch: Enable VLAN filtering on port 2
|[  209.415716] hellcreek ff240000.switch: Unapply VLAN: port=2 vid=2
|[  209.421840] hellcreek ff240000.switch: Unapply VLAN: port=0 vid=2
|[  209.428170] hellcreek ff240000.switch: Apply queued VLANs: port2
|[  209.434158] hellcreek ff240000.switch: Apply VLAN: port=2 vid=0 pvid=0 untagged=0
|[  209.441649] hellcreek ff240000.switch: Clear queued VLANs: port2
|[  209.447920] hellcreek ff240000.switch: Apply queued VLANs: port0
|[  209.453910] hellcreek ff240000.switch: Apply VLAN: port=0 vid=0 pvid=0 untagged=0
|[  209.461402] hellcreek ff240000.switch: Clear queued VLANs: port0
|[  209.467620] hellcreek ff240000.switch: VLAN prepare for port 2
|[  209.473476] hellcreek ff240000.switch: VLAN prepare for port 0
|[  209.479534] hellcreek ff240000.switch: Add VLANs (1 -- 1) on port 2, untagged, PVID
|[  209.487164] hellcreek ff240000.switch: Apply VLAN: port=2 vid=1 pvid=1 untagged=1
|[  209.494659] hellcreek ff240000.switch: Add VLANs (1 -- 1) on port 0, untagged, no PVID
|[  209.502794] hellcreek ff240000.switch: Apply VLAN: port=0 vid=1 pvid=0 untagged=1
|root@tsn:~# bridge vlan show
|port    vlan ids
|lan0     1 PVID Egress Untagged
|
|br0      1 PVID Egress Untagged

... which looks correct to me. The VLAN 2 is unapplied as expected. Or?

>
> And how do you deal with the case where swp1 and swp2 are bridged and
> have the VLAN 3 installed via 'bridge vlan', but swp3 isn't bridged?
> Will swp1/swp2 communicate with swp3? If yes, that's a problem.

There is no swp3. Currently there are only two ports and either they are
bridged or not.

>> +static int __hellcreek_fdb_del(struct hellcreek *hellcreek,
>> +			       const struct hellcreek_fdb_entry *entry)
>> +{
>> +	dev_dbg(hellcreek->dev, "Delete FDB entry: MAC=%pM!\n", entry->mac);
>> +
>
> Do these dev_dbg statements bring much value at all, even to you?

Yes, they do. See the log snippet above.

>> +/* Default setup for DSA: VLAN <X>: CPU and Port <X> egress untagged. */
>> +static int hellcreek_setup_vlan_membership(struct dsa_switch *ds, int port,
>> +					   bool enabled)
>
> This function always returns zero, so it should be void.

Yes. I noticed that as well and wanted to fix it before sending. Sorry, my bad.

>> +static int hellcreek_vlan_filtering(struct dsa_switch *ds, int port,
>> +				    bool vlan_filtering)
>> +{
>> +	struct hellcreek *hellcreek = ds->priv;
>> +
>> +	dev_dbg(hellcreek->dev, "%s VLAN filtering on port %d\n",
>> +		vlan_filtering ? "Enable" : "Disable", port);
>> +
>> +	/* Configure port to drop packages with not known vids */
>> +	hellcreek_setup_ingressflt(hellcreek, port, vlan_filtering);
>> +
>> +	/* Drop DSA vlan membership config. The user can now do it. */
>> +	hellcreek_setup_vlan_membership(ds, port, !vlan_filtering);
>> +
>> +	/* Apply saved vlan configurations while not filtering for port <X>. */
>> +	hellcreek_apply_vlan_filtering(hellcreek, port, vlan_filtering);
>> +
>> +	/* Do the same for the cpu port. */
>> +	hellcreek_apply_vlan_filtering(hellcreek, CPU_PORT, vlan_filtering);
>
> I think we should create a DSA_NOTIFIER_VLAN_FILTERING so you wouldn't
> have to do this, but not now.

OK.

>> +static int hellcreek_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct hellcreek *hellcreek;
>> +	struct resource *res;
>> +	int ret, i;
>> +
>> +	hellcreek = devm_kzalloc(dev, sizeof(*hellcreek), GFP_KERNEL);
>> +	if (!hellcreek)
>> +		return -ENOMEM;
>> +
>> +	hellcreek->vidmbrcfg = devm_kcalloc(dev, 4096,
>
> VLAN_N_VID

Thanks!

>> +static const struct hellcreek_platform_data de1soc_r1_pdata = {
>> +	.num_ports	 = 4,
>> +	.is_100_mbits	 = 1,
>> +	.qbv_support	 = 1,
>> +	.qbv_on_cpu_port = 1,
>
> Why does this matter?

Because Qbv on the CPU port is a feature and not all switch variants
have that. It will matter as soon as TAPRIO is implemented.

>> +#include <linux/bitops.h>
>> +#include <linux/kernel.h>
>> +#include <linux/device.h>
>> +#include <linux/ptp_clock_kernel.h>
>> +#include <linux/timecounter.h>
>> +#include <linux/mutex.h>
>
> Could you sort alphabetically?

Sure.

>
>> +#include <linux/platform_data/hirschmann-hellcreek.h>
>> +#include <net/dsa.h>
>> +
>> +/* Ports:
>> + *  - 0: CPU
>> + *  - 1: Tunnel
>> + *  - 2: TSN front port 1
>> + *  - 3: TSN front port 2
>> + *  - ...
>> + */
>> +#define CPU_PORT			0
>> +#define TUNNEL_PORT			1
>
> What's a tunnel port exactly?

AFAIK it's a debugging port for mirroring or looping traffic. Anyhow,
that is not a regular port and cannot be treated as such.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl98CiMACgkQeSpbgcuY
8KbhHxAAhOoJU4I2d4KFLiOZaNgcRlR+DoRXVyz97TnzC4n4PuOFhg6qDgMM5aPR
zhWaiHvI96aMXFU+FZAPmbHimKWox1zVRLN5lp8otQ6O77wVnNgGlYq7+f5fn4kw
zz5uvsoXfxmTl2ceS6wfWhXy6O90ka/PDCcHP5cFhZukSNzgJRZhwF5QdZocUq9S
QP1gWwhsh8YAMvPUwfTiErXxxioz0HQfQPZBcaIYtqV/D3a9jiDrzyf1+YhyM+J5
/MOlWZlpeSfXBL/SifpyV3lSJNFzbeqj1eWctdc1q4lgqsOKSffAYE0H1TXsCauy
NDVcFZY1fH1/L1wbgdqzvSabu76sojytkEWuJAf9ytk9wLxRGD932ooG8RIpnLmR
Df+38t/H8nvuHh/AunM8EIa8KToPdGCdlLRJjn4z9z4MdkNe+jKLPwf/Lr+JsykD
pqbe95xBa6mMAq2xQBFGzBGH+jV6Q2a2/Exm1FZBj1PJ5IypoCEoVznxg7Cvr0hB
3J1u054dk1nMtPrjZPXJ7W0chrgOpf4091/6gG8Rp//LFoFiQgB5LrDMEUPdqrEY
YsaaxS9iBVBWCLBLnWTflTdl6c/fhSP+8PhFAdP0eMCrFwWSnVVk1AsyPsu9G9iZ
I63VCwt0WvP4k2/xqqlHSKHxgnIh8HGf7AUPH4iKs2rwLBOdhY8=
=CCR6
-----END PGP SIGNATURE-----
--=-=-=--
