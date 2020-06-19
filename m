Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF41200355
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 10:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbgFSIMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 04:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731124AbgFSIMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 04:12:34 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B19C0613EF;
        Fri, 19 Jun 2020 01:12:33 -0700 (PDT)
Received: from [5.158.153.52] (helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jmC8J-0003gr-To; Fri, 19 Jun 2020 10:12:20 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 2/9] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20200618152247.GF240559@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de> <20200618064029.32168-3-kurt@linutronix.de> <20200618152247.GF240559@lunn.ch>
Date:   Fri, 19 Jun 2020 10:12:19 +0200
Message-ID: <87eeqbqxss.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Andrew,

first off thank you for the review.

On Thu Jun 18 2020, Andrew Lunn wrote:
>> +static void __hellcreek_select_port(struct hellcreek *hellcreek, int port)
>
> Hi Kurt
>
> In general, please can you drop all these __ prefixes. They are useful
> when you have for example hellcreek_select_port() takes a lock and
> then calls _hellcreek_select_port(), but here, there is no need for
> them.

OK, sure.

>
>> +static int hellcreek_detect(struct hellcreek *hellcreek)
>> +{
>> +	u8 tgd_maj, tgd_min;
>> +	u16 id, rel_low, rel_high, date_low, date_high, tgd_ver;
>> +	u32 rel, date;
>
> Reverse Christmas tree please. Here and everywhere else.

OK.

>
>> +
>> +	id	  = hellcreek_read(hellcreek, HR_MODID_C);
>> +	rel_low	  = hellcreek_read(hellcreek, HR_REL_L_C);
>> +	rel_high  = hellcreek_read(hellcreek, HR_REL_H_C);
>> +	date_low  = hellcreek_read(hellcreek, HR_BLD_L_C);
>> +	date_high = hellcreek_read(hellcreek, HR_BLD_H_C);
>> +	tgd_ver   = hellcreek_read(hellcreek, TR_TGDVER);
>> +
>> +	if (id != HELLCREEK_MODULE_ID)
>> +		return -ENODEV;
>> +
>> +	rel	= rel_low | (rel_high << 16);
>> +	date	= date_low | (date_high << 16);
>> +	tgd_maj = (tgd_ver & TR_TGDVER_REV_MAJ_MASK) >> TR_TGDVER_REV_MAJ_SHIFT;
>> +	tgd_min = (tgd_ver & TR_TGDVER_REV_MIN_MASK) >> TR_TGDVER_REV_MIN_SHIFT;
>> +
>> +	dev_info(hellcreek->dev, "Module ID=%02x Release=%04x Date=%04x TGD Version=%02x.%02x\n",
>> +		 id, rel, date, tgd_maj, tgd_min);
>> +
>> +	return 0;
>> +}
>
>> +static int hellcreek_port_enable(struct dsa_switch *ds, int port,
>> +				 struct phy_device *phy)
>> +{
>> +	struct hellcreek *hellcreek = ds->priv;
>> +	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
>> +	unsigned long flags;
>> +	u16 val;
>> +
>> +	if (port >= NUM_PORTS)
>> +		return -EINVAL;
>> +
>> +	dev_info(hellcreek->dev, "Enable port %d\n", port);
>
> dev_dbg().

These are debug messages. I'll change that in the complete code.

>
> +
>> +	spin_lock_irqsave(&hellcreek->reg_lock, flags);
>
> I've not seen any interrupt handling code in the driver, and there is
> no mention of an interrupt in the DT binding. Do you really need
> _irqsave spin locks?

Yes, I do. The TAPRIO offloading patch later adds hrtimers and that's
why it's needed. However, in this particular patch it is not required,
but I didn't want to change all spin lock calls later.

>
>> +
>> +	__hellcreek_select_port(hellcreek, port);
>> +	val = hellcreek_port->ptcfg;
>> +	val |= HR_PTCFG_ADMIN_EN;
>> +	hellcreek_write(hellcreek, val, HR_PTCFG);
>> +	hellcreek_port->ptcfg = val;
>> +
>> +	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
>> +
>> +	return 0;
>> +}
>> +
>> +static void hellcreek_port_disable(struct dsa_switch *ds, int port)
>> +{
>> +	struct hellcreek *hellcreek = ds->priv;
>> +	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
>> +	unsigned long flags;
>> +	u16 val;
>> +
>> +	if (port >= NUM_PORTS)
>> +		return;
>
> I don't think this test is actually needed, here or in any of the
> other callbacks. If it does happen, it means we have a core bug we
> should fix.

Agreed.

>
>> +
>> +	dev_info(hellcreek->dev, "Disable port %d\n", port);
>
> dev_dbg()
>
>> +	spin_lock_irqsave(&hellcreek->reg_lock, flags);
>> +
>> +	__hellcreek_select_port(hellcreek, port);
>> +	val = hellcreek_port->ptcfg;
>> +	val &= ~HR_PTCFG_ADMIN_EN;
>> +	hellcreek_write(hellcreek, val, HR_PTCFG);
>> +	hellcreek_port->ptcfg = val;
>> +
>> +	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
>> +}
>> +
>
>> +static void hellcreek_get_ethtool_stats(struct dsa_switch *ds, int port,
>> +					uint64_t *data)
>> +{
>> +	struct hellcreek *hellcreek = ds->priv;
>> +	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
>> +	unsigned long flags;
>> +	int i;
>> +
>> +	if (port >= NUM_PORTS)
>> +		return;
>> +
>> +	spin_lock_irqsave(&hellcreek->reg_lock, flags);
>> +	for (i = 0; i < ARRAY_SIZE(hellcreek_counter); ++i) {
>> +		const struct hellcreek_counter *counter = &hellcreek_counter[i];
>> +		u8 offset = counter->offset + port * 64;
>> +		u16 high, low;
>> +		u64 value = 0;
>> +
>> +		__hellcreek_select_counter(hellcreek, offset);
>> +
>> +		high  = hellcreek_read(hellcreek, HR_CRDH);
>> +		low   = hellcreek_read(hellcreek, HR_CRDL);
>> +		value = (high << 16) | low;
>
> Is there some sort of snapshot happening here? Or do you need to read
> high again, to make sure it has not incremented when low was being
> read?

Yes, there is. When the counter is selected via
__hellcreek_select_counter() both registers are locked. That's why
there's no need to read high again. I'll add a comment for clarity.

>
>> +
>> +		hellcreek_port->counter_values[i] += value;
>> +		data[i] = hellcreek_port->counter_values[i];
>> +	}
>> +	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
>> +}
>> +
>> +static int hellcreek_vlan_prepare(struct dsa_switch *ds, int port,
>> +				  const struct switchdev_obj_port_vlan *vlan)
>> +{
>> +	struct hellcreek *hellcreek = ds->priv;
>> +
>> +	/* Nothing todo */
>> +	dev_info(hellcreek->dev, "VLAN prepare for port %d\n", port);
>
> dev_dbg()
>
>> +
>> +	return 0;
>> +}
>> +
>
>> +static void hellcreek_vlan_add(struct dsa_switch *ds, int port,
>> +			       const struct switchdev_obj_port_vlan *vlan)
>> +{
>> +	struct hellcreek *hellcreek = ds->priv;
>> +	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
>> +	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
>> +	unsigned long flags;
>> +	u16 vid;
>> +
>> +	if (port >= NUM_PORTS || vlan->vid_end >= 4096)
>
> Again, if vlan->vid_end >= 4096 is true, there is a core bug which
> needs fixing.
>
>> +		return;
>> +
>> +	dev_info(hellcreek->dev, "Add VLANs (%d -- %d) on port %d, %s, %s\n",
>> +		 vlan->vid_begin, vlan->vid_end, port,
>> +		 untagged ? "untagged" : "tagged",
>> +		 pvid ? "PVID" : "no PVID");
>
> Please go thought the driver and consider all you dev_info()
> statements. Should they be dev_dbg()?

I'll do.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl7sc2MACgkQeSpbgcuY
8Kb1oA/5AWhu0QbhtT2SH1zmrMKl9CTn47AuclJuudZQTM5ffnsT/M+mCCusz5Je
9O7pna+YjBfe8wfiRRF7JClmqbRWoDZUwOa+Mhoqwk/r/WpH267JwpSAV+sSaI2X
qBzLSLpLfPZnsIh6P4D+zzD8RMEBddsQDpXyabl7+K3AcLn69Oe7tjRDq80+0QGm
btKkrLiLIRE1s9+YXY9U1ifp6Kzt1uxkrnkT/7OlbTWIbaMBI84xSPqpW3tGzDqX
/Djt0Xo3gAlpSOdawimLI9qgQNPVVCJ40+HglNFoRGXKsRGJlL1cuZHeeN3yDqxj
+JWT3A7XFyQfrTNoCzpJ9dH9twxdHXaanidOl3SusmQNGBOyOSUV/ppPx+fA6i1G
I/98OTqLmU5kZaw4oNyJ2ttvI0S7fIOkUrixEADk4EEpso0S3KOns/trzrSnfxY+
fSUkFor6Hg+PHvRLVUhs6Dg2iDDj1XIVmWoZgiUWfqSU0DP3SsMCyVe1VByTGYnN
Hp9E6TkigTNvUvzS6Oc2HSSpmTpm05hktRHZtSoE8N3FFp52eP6cKX64uFxb+IoX
SuX5ClCEPr5XKYHX/N1wyQm2J1bIJ9NAvzigz4mF5e+q+4s9vckX2snA/wPDGg1m
o4QKqyDsw+V+VofIoRtSbcrFPac6ZzFeMp/bWXgxKQ4lwAUXiJQ=
=fUT8
-----END PGP SIGNATURE-----
--=-=-=--
