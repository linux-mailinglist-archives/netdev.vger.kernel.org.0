Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEFD21D41A
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 12:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgGMK5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 06:57:41 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35114 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbgGMK5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 06:57:41 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594637856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ie9Ijkcb+qbIuf53rA53uiaoIepBJdSq89bFiQtWJZw=;
        b=mBi6A7DlrHvLRWgA/syd7HUquCzgEBKWBbJcDtAYADtTL6nOLgDHUO0yvIRL4NlZ/1UtmS
        PWvsW96p4b2fNbZQNPoM7L33I2C8H9kcaLOODVX4lqFYNKYTEV5Js/R1j9gMWzcQOMcCUP
        AAzBEBDzgqVLrcAo9d2DVg+Fyj3UAXlHODC7cbL5t/48VXYIZjYqyFWnN1B6+IZLNb9fQc
        ptRC0mvXDxh199PdKDr1BvQf2P0q2zP70NL817/8o4wO28OmQMo8iW8ew0LzGcLMbhIHjB
        ryxjOnfRiKUKzJjgYmWJcH5HDYM+fw/Q8bsSkyge8tTW3Yf98gHnWAmllXEdGw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594637856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ie9Ijkcb+qbIuf53rA53uiaoIepBJdSq89bFiQtWJZw=;
        b=mvaoodJEJdCR8UYM11WPnf2z9NrFf6NNFFzrCRqZ5FLt28L5hBdqE/F4rVz/t8b+1MpYtn
        qJtKtYNrcErL7PDQ==
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
Subject: Re: [PATCH v1 4/8] net: dsa: hellcreek: Add support for hardware timestamping
In-Reply-To: <20200713095700.rd4u4t6thkzfnlll@skbuf>
References: <20200710113611.3398-1-kurt@linutronix.de> <20200710113611.3398-5-kurt@linutronix.de> <20200713095700.rd4u4t6thkzfnlll@skbuf>
Date:   Mon, 13 Jul 2020 12:57:34 +0200
Message-ID: <87k0z7n0m9.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

On Mon Jul 13 2020, Vladimir Oltean wrote:
> Hi Kurt,
>
> On Fri, Jul 10, 2020 at 01:36:07PM +0200, Kurt Kanzenbach wrote:
>> From: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
>>=20
>> The switch has the ability to take hardware generated time stamps per po=
rt for
>> PTPv2 event messages in Rx and Tx direction. That is useful for achievin=
g needed
>> time synchronization precision for TSN devices/switches. So add support =
for it.
>>=20
>> There are two directions:
>>=20
>>  * RX
>>=20
>>    The switch has a single register per port to capture a timestamp. That
>>    mechanism is not used due to correlation problems. If the software pr=
ocessing
>>    is too slow and a PTPv2 event message is received before the previous=
 one has
>>    been processed, false timestamps will be captured. Therefore, the swi=
tch can
>>    do "inline" timestamping which means it can insert the nanoseconds pa=
rt of
>>    the timestamp directly into the PTPv2 event message. The reserved fie=
ld (4
>>    bytes) is leveraged for that. This might not be in accordance with (o=
lder)
>>    PTP standards, but is the only way to get reliable results.
>>=20
>>  * TX
>>=20
>>    In Tx direction there is no correlation problem, because the software=
 and the
>>    driver has to ensure that only one event message is "on the fly". How=
ever,
>>    the switch provides also a mechanism to check whether a timestamp is
>>    lost. That can only happen when a timestamp is read and at this point=
 another
>>    message is timestamped. So, that lost bit is checked just in case to =
indicate
>>    to the user that the driver or the software is somewhat buggy.
>>=20
>> Signed-off-by: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> ---
>>  drivers/net/dsa/hirschmann/Makefile           |   1 +
>>  drivers/net/dsa/hirschmann/hellcreek.c        |  15 +
>>  drivers/net/dsa/hirschmann/hellcreek.h        |  25 +
>>  .../net/dsa/hirschmann/hellcreek_hwtstamp.c   | 498 ++++++++++++++++++
>>  .../net/dsa/hirschmann/hellcreek_hwtstamp.h   |  58 ++
>>  drivers/net/dsa/hirschmann/hellcreek_ptp.c    |  48 +-
>>  drivers/net/dsa/hirschmann/hellcreek_ptp.h    |   4 +
>>  7 files changed, 635 insertions(+), 14 deletions(-)
>>  create mode 100644 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
>>  create mode 100644 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h
>>=20
>> diff --git a/drivers/net/dsa/hirschmann/Makefile b/drivers/net/dsa/hirsc=
hmann/Makefile
>> index 39de02a03640..f4075c2998b5 100644
>> --- a/drivers/net/dsa/hirschmann/Makefile
>> +++ b/drivers/net/dsa/hirschmann/Makefile
>> @@ -2,3 +2,4 @@
>>  obj-$(CONFIG_NET_DSA_HIRSCHMANN_HELLCREEK)	+=3D hellcreek_sw.o
>>  hellcreek_sw-objs :=3D hellcreek.o
>>  hellcreek_sw-objs +=3D hellcreek_ptp.o
>> +hellcreek_sw-objs +=3D hellcreek_hwtstamp.o
>> diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hi=
rschmann/hellcreek.c
>> index 9901d6435d97..3941a9a3252d 100644
>> --- a/drivers/net/dsa/hirschmann/hellcreek.c
>> +++ b/drivers/net/dsa/hirschmann/hellcreek.c
>> @@ -26,6 +26,7 @@
>>=20=20
>>  #include "hellcreek.h"
>>  #include "hellcreek_ptp.h"
>> +#include "hellcreek_hwtstamp.h"
>>=20=20
>>  static const struct hellcreek_counter hellcreek_counter[] =3D {
>>  	{ 0x00, "RxFiltered", },
>> @@ -1103,6 +1104,11 @@ static const struct dsa_switch_ops hellcreek_ds_o=
ps =3D {
>>  	.port_bridge_leave   =3D hellcreek_port_bridge_leave,
>>  	.port_stp_state_set  =3D hellcreek_port_stp_state_set,
>>  	.phylink_validate    =3D hellcreek_phylink_validate,
>> +	.port_hwtstamp_set   =3D hellcreek_port_hwtstamp_set,
>> +	.port_hwtstamp_get   =3D hellcreek_port_hwtstamp_get,
>> +	.port_txtstamp	     =3D hellcreek_port_txtstamp,
>> +	.port_rxtstamp	     =3D hellcreek_port_rxtstamp,
>> +	.get_ts_info	     =3D hellcreek_get_ts_info,
>>  };
>>=20=20
>>  static int hellcreek_probe(struct platform_device *pdev)
>> @@ -1202,10 +1208,18 @@ static int hellcreek_probe(struct platform_devic=
e *pdev)
>>  		goto err_ptp_setup;
>>  	}
>>=20=20
>> +	ret =3D hellcreek_hwtstamp_setup(hellcreek);
>> +	if (ret) {
>> +		dev_err(dev, "Failed to setup hardware timestamping!\n");
>> +		goto err_tstamp_setup;
>> +	}
>> +
>>  	platform_set_drvdata(pdev, hellcreek);
>>=20=20
>>  	return 0;
>>=20=20
>> +err_tstamp_setup:
>> +	hellcreek_ptp_free(hellcreek);
>>  err_ptp_setup:
>>  	dsa_unregister_switch(hellcreek->ds);
>>=20=20
>> @@ -1216,6 +1230,7 @@ static int hellcreek_remove(struct platform_device=
 *pdev)
>>  {
>>  	struct hellcreek *hellcreek =3D platform_get_drvdata(pdev);
>>=20=20
>> +	hellcreek_hwtstamp_free(hellcreek);
>>  	hellcreek_ptp_free(hellcreek);
>>  	dsa_unregister_switch(hellcreek->ds);
>>  	platform_set_drvdata(pdev, NULL);
>> diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hi=
rschmann/hellcreek.h
>> index 2d4422fd2567..1d3de72a48a5 100644
>> --- a/drivers/net/dsa/hirschmann/hellcreek.h
>> +++ b/drivers/net/dsa/hirschmann/hellcreek.h
>> @@ -212,11 +212,36 @@ struct hellcreek_counter {
>>=20=20
>>  struct hellcreek;
>>=20=20
>> +/* State flags for hellcreek_port_hwtstamp::state */
>> +enum {
>> +	HELLCREEK_HWTSTAMP_ENABLED,
>> +	HELLCREEK_HWTSTAMP_TX_IN_PROGRESS,
>> +};
>> +
>> +/* A structure to hold hardware timestamping information per port */
>> +struct hellcreek_port_hwtstamp {
>> +	/* Timestamping state */
>> +	unsigned long state;
>> +
>> +	/* Resources for receive timestamping */
>> +	struct sk_buff_head rx_queue; /* For synchronization messages */
>> +
>> +	/* Resources for transmit timestamping */
>> +	unsigned long tx_tstamp_start;
>> +	struct sk_buff *tx_skb;
>> +
>> +	/* Current timestamp configuration */
>> +	struct hwtstamp_config tstamp_config;
>> +};
>> +
>>  struct hellcreek_port {
>>  	struct hellcreek *hellcreek;
>>  	int port;
>>  	u16 ptcfg;		/* ptcfg shadow */
>>  	u64 *counter_values;
>> +
>> +	/* Per-port timestamping resources */
>> +	struct hellcreek_port_hwtstamp port_hwtstamp;
>>  };
>>=20=20
>>  struct hellcreek_fdb_entry {
>> diff --git a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c b/drivers/n=
et/dsa/hirschmann/hellcreek_hwtstamp.c
>> new file mode 100644
>> index 000000000000..dc0ab75d099b
>> --- /dev/null
>> +++ b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
>> @@ -0,0 +1,498 @@
>> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
>> +/*
>> + * DSA driver for:
>> + * Hirschmann Hellcreek TSN switch.
>> + *
>> + * Copyright (C) 2019,2020 Hochschule Offenburg
>> + * Copyright (C) 2019,2020 Linutronix GmbH
>> + * Authors: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
>> + *	    Kurt Kanzenbach <kurt@linutronix.de>
>> + */
>> +
>> +#include <linux/ptp_classify.h>
>> +
>> +#include "hellcreek.h"
>> +#include "hellcreek_hwtstamp.h"
>> +#include "hellcreek_ptp.h"
>> +
>> +int hellcreek_get_ts_info(struct dsa_switch *ds, int port,
>> +			  struct ethtool_ts_info *info)
>> +{
>> +	struct hellcreek *hellcreek =3D ds->priv;
>> +
>> +	info->phc_index =3D hellcreek->ptp_clock ?
>> +		ptp_clock_index(hellcreek->ptp_clock) : -1;
>> +	info->so_timestamping =3D SOF_TIMESTAMPING_TX_HARDWARE |
>> +		SOF_TIMESTAMPING_RX_HARDWARE |
>> +		SOF_TIMESTAMPING_RAW_HARDWARE;
>> +
>> +	/* enabled tx timestamping */
>> +	info->tx_types =3D BIT(HWTSTAMP_TX_ON);
>> +
>> +	/* L2 & L4 PTPv2 event rx messages are timestamped */
>> +	info->rx_filters =3D BIT(HWTSTAMP_FILTER_PTP_V2_EVENT);
>> +
>> +	return 0;
>> +}
>> +
>> +/* Enabling/disabling TX and RX HW timestamping for different PTP messa=
ges is
>> + * not available in the switch. Thus, this function only serves as a ch=
eck if
>> + * the user requested what is actually available or not
>> + */
>> +static int hellcreek_set_hwtstamp_config(struct hellcreek *hellcreek, i=
nt port,
>> +					 struct hwtstamp_config *config)
>> +{
>> +	struct hellcreek_port_hwtstamp *ps =3D
>> +		&hellcreek->ports[port].port_hwtstamp;
>> +	bool tx_tstamp_enable =3D false;
>> +	bool rx_tstamp_enable =3D false;
>> +
>> +	/* Interaction with the timestamp hardware is prevented here.  It is
>> +	 * enabled when this config function ends successfully
>> +	 */
>> +	clear_bit_unlock(HELLCREEK_HWTSTAMP_ENABLED, &ps->state);
>> +
>> +	/* Reserved for future extensions */
>> +	if (config->flags)
>> +		return -EINVAL;
>> +
>> +	switch (config->tx_type) {
>> +	case HWTSTAMP_TX_ON:
>> +		tx_tstamp_enable =3D true;
>> +		break;
>> +
>> +	/* TX HW timestamping can't be disabled on the switch */
>> +	case HWTSTAMP_TX_OFF:
>> +		config->tx_type =3D HWTSTAMP_TX_ON;
>> +		break;
>> +
>> +	default:
>> +		return -ERANGE;
>> +	}
>> +
>> +	switch (config->rx_filter) {
>> +	/* RX HW timestamping can't be disabled on the switch */
>> +	case HWTSTAMP_FILTER_NONE:
>> +		config->rx_filter =3D HWTSTAMP_FILTER_PTP_V2_EVENT;
>> +		break;
>> +
>> +	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
>> +	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
>> +	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
>> +	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
>> +	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
>> +	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
>> +	case HWTSTAMP_FILTER_PTP_V2_EVENT:
>> +	case HWTSTAMP_FILTER_PTP_V2_SYNC:
>> +	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
>> +		config->rx_filter =3D HWTSTAMP_FILTER_PTP_V2_EVENT;
>> +		rx_tstamp_enable =3D true;
>> +		break;
>> +
>> +	/* RX HW timestamping can't be enabled for all messages on the switch =
*/
>> +	case HWTSTAMP_FILTER_ALL:
>> +		config->rx_filter =3D HWTSTAMP_FILTER_PTP_V2_EVENT;
>> +		break;
>> +
>> +	default:
>> +		return -ERANGE;
>> +	}
>> +
>> +	if (!tx_tstamp_enable)
>> +		return -ERANGE;
>> +
>> +	if (!rx_tstamp_enable)
>> +		return -ERANGE;
>> +
>> +	/* If this point is reached, then the requested hwtstamp config is
>> +	 * compatible with the hwtstamp offered by the switch.  Therefore,
>> +	 * enable the interaction with the HW timestamping
>> +	 */
>> +	set_bit(HELLCREEK_HWTSTAMP_ENABLED, &ps->state);
>> +
>> +	return 0;
>> +}
>> +
>> +int hellcreek_port_hwtstamp_set(struct dsa_switch *ds, int port,
>> +				struct ifreq *ifr)
>> +{
>> +	struct hellcreek *hellcreek =3D ds->priv;
>> +	struct hellcreek_port_hwtstamp *ps;
>> +	struct hwtstamp_config config;
>> +	int err;
>> +
>> +	ps =3D &hellcreek->ports[port].port_hwtstamp;
>> +
>> +	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
>> +		return -EFAULT;
>> +
>> +	err =3D hellcreek_set_hwtstamp_config(hellcreek, port, &config);
>> +	if (err)
>> +		return err;
>> +
>> +	/* Save the chosen configuration to be returned later */
>> +	memcpy(&ps->tstamp_config, &config, sizeof(config));
>> +
>> +	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
>> +		-EFAULT : 0;
>> +}
>> +
>> +int hellcreek_port_hwtstamp_get(struct dsa_switch *ds, int port,
>> +				struct ifreq *ifr)
>> +{
>> +	struct hellcreek *hellcreek =3D ds->priv;
>> +	struct hellcreek_port_hwtstamp *ps;
>> +	struct hwtstamp_config *config;
>> +
>> +	ps =3D &hellcreek->ports[port].port_hwtstamp;
>> +	config =3D &ps->tstamp_config;
>> +
>> +	return copy_to_user(ifr->ifr_data, config, sizeof(*config)) ?
>> +		-EFAULT : 0;
>> +}
>> +
>> +/* Get a pointer to the PTP header in this skb */
>> +static u8 *parse_ptp_header(struct sk_buff *skb, unsigned int type)
>
> Maybe this and the function from mv88e6xxx could share the same
> implementation somehow.

Actually both functions are identical. Should it be moved to the ptp
core, maybe? Then, all drivers could use that. I guess we should also
define a PTP offset for the reserved field which is accessed in
hellcreek_get_reserved_field() just with 16 instead of a proper macro
constant.

>
>> +{
>> +	u8 *data =3D skb_mac_header(skb);
>> +	unsigned int offset =3D 0;
>> +
>> +	if (type & PTP_CLASS_VLAN)
>> +		offset +=3D VLAN_HLEN;
>> +
>> +	switch (type & PTP_CLASS_PMASK) {
>> +	case PTP_CLASS_IPV4:
>> +		offset +=3D ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
>> +		break;
>> +	case PTP_CLASS_IPV6:
>> +		offset +=3D ETH_HLEN + IP6_HLEN + UDP_HLEN;
>> +		break;
>> +	case PTP_CLASS_L2:
>> +		offset +=3D ETH_HLEN;
>> +		break;
>> +	default:
>> +		return NULL;
>> +	}
>> +
>> +	/* Ensure that the entire header is present in this packet. */
>> +	if (skb->len + ETH_HLEN < offset + 34)
>> +		return NULL;
>> +
>> +	return data + offset;
>> +}
>> +
>> +/* Returns a pointer to the PTP header if the caller should time stamp,=
 or NULL
>> + * if the caller should not.
>> + */
>> +static u8 *hellcreek_should_tstamp(struct hellcreek *hellcreek, int por=
t,
>> +				   struct sk_buff *skb, unsigned int type)
>> +{
>> +	struct hellcreek_port_hwtstamp *ps =3D
>> +		&hellcreek->ports[port].port_hwtstamp;
>> +	u8 *hdr;
>> +
>> +	hdr =3D parse_ptp_header(skb, type);
>> +	if (!hdr)
>> +		return NULL;
>> +
>> +	if (!test_bit(HELLCREEK_HWTSTAMP_ENABLED, &ps->state))
>> +		return NULL;
>> +
>> +	return hdr;
>> +}
>> +
>> +static u64 hellcreek_get_reserved_field(u8 *ptp_hdr)
>> +{
>> +	__be32 *ts;
>> +
>> +	/* length is checked by parse_ptp_header() */
>> +	ts =3D (__force __be32 *)&ptp_hdr[16];
>> +
>> +	return be32_to_cpup(ts);
>> +}
>> +
>> +static int hellcreek_ptp_hwtstamp_available(struct hellcreek *hellcreek,
>> +					    unsigned int ts_reg)
>> +{
>> +	u16 status;
>> +
>> +	status =3D hellcreek_ptp_read(hellcreek, ts_reg);
>> +
>> +	if (status & PR_TS_STATUS_TS_LOST)
>> +		dev_err(hellcreek->dev,
>> +			"Tx time stamp lost! This should never happen!\n");
>> +
>> +	/* If hwtstamp is not available, this means the previous hwtstamp was
>> +	 * successfully read, and the one we need is not yet available
>> +	 */
>> +	return (status & PR_TS_STATUS_TS_AVAIL) ? 1 : 0;
>> +}
>> +
>> +/* Get nanoseconds timestamp from timestamping unit */
>> +static u64 hellcreek_ptp_hwtstamp_read(struct hellcreek *hellcreek,
>> +				       unsigned int ts_reg)
>> +{
>> +	u16 nsl, nsh;
>> +
>> +	nsh =3D hellcreek_ptp_read(hellcreek, ts_reg);
>> +	nsh =3D hellcreek_ptp_read(hellcreek, ts_reg);
>> +	nsh =3D hellcreek_ptp_read(hellcreek, ts_reg);
>> +	nsh =3D hellcreek_ptp_read(hellcreek, ts_reg);
>> +	nsl =3D hellcreek_ptp_read(hellcreek, ts_reg);
>> +
>> +	return (u64)nsl | ((u64)nsh << 16);
>> +}
>> +
>> +static int hellcreek_txtstamp_work(struct hellcreek *hellcreek,
>> +				   struct hellcreek_port_hwtstamp *ps, int port)
>> +{
>> +	struct skb_shared_hwtstamps shhwtstamps;
>> +	unsigned int status_reg, data_reg;
>> +	struct sk_buff *tmp_skb;
>> +	int ts_status;
>> +	u64 ns =3D 0;
>> +
>> +	if (!ps->tx_skb)
>> +		return 0;
>> +
>> +	switch (port) {
>> +	case 2:
>> +		status_reg =3D PR_TS_TX_P1_STATUS_C;
>> +		data_reg   =3D PR_TS_TX_P1_DATA_C;
>> +		break;
>> +	case 3:
>> +		status_reg =3D PR_TS_TX_P2_STATUS_C;
>> +		data_reg   =3D PR_TS_TX_P2_DATA_C;
>> +		break;
>> +	default:
>> +		dev_err(hellcreek->dev, "Wrong port for timestamping!\n");
>> +		return 0;
>> +	}
>> +
>> +	ts_status =3D hellcreek_ptp_hwtstamp_available(hellcreek, status_reg);
>> +
>> +	/* Not available yet? */
>> +	if (ts_status =3D=3D 0) {
>> +		/* Check whether the operation of reading the tx timestamp has
>> +		 * exceeded its allowed period
>> +		 */
>> +		if (time_is_before_jiffies(ps->tx_tstamp_start +
>> +					   TX_TSTAMP_TIMEOUT)) {
>> +			dev_err(hellcreek->dev,
>> +				"Timeout while waiting for Tx timestamp!\n");
>> +			goto free_and_clear_skb;
>> +		}
>> +
>> +		/* The timestamp should be available quickly, while getting it
>> +		 * in high priority. Restart the work
>> +		 */
>> +		return 1;
>> +	}
>> +
>> +	spin_lock(&hellcreek->ptp_lock);
>> +	ns  =3D hellcreek_ptp_hwtstamp_read(hellcreek, data_reg);
>> +	ns +=3D hellcreek_ptp_gettime_seconds(hellcreek, ns);
>> +	spin_unlock(&hellcreek->ptp_lock);
>> +
>> +	/* Now we have the timestamp in nanoseconds, store it in the correct
>> +	 * structure in order to send it to the user
>> +	 */
>> +	memset(&shhwtstamps, 0, sizeof(shhwtstamps));
>> +	shhwtstamps.hwtstamp =3D ns_to_ktime(ns);
>> +
>> +	tmp_skb =3D ps->tx_skb;
>> +	ps->tx_skb =3D NULL;
>> +
>> +	/* skb_complete_tx_timestamp() frees up the client to make another
>> +	 * timestampable transmit.  We have to be ready for it by clearing the
>> +	 * ps->tx_skb "flag" beforehand
>> +	 */
>> +	clear_bit_unlock(HELLCREEK_HWTSTAMP_TX_IN_PROGRESS, &ps->state);
>> +
>> +	/* Deliver a clone of the original outgoing tx_skb with tx hwtstamp */
>> +	skb_complete_tx_timestamp(tmp_skb, &shhwtstamps);
>> +
>> +	return 0;
>> +
>> +free_and_clear_skb:
>> +	dev_kfree_skb_any(ps->tx_skb);
>> +	ps->tx_skb =3D NULL;
>> +	clear_bit_unlock(HELLCREEK_HWTSTAMP_TX_IN_PROGRESS, &ps->state);
>> +
>> +	return 0;
>> +}
>> +
>> +static void hellcreek_get_rxts(struct hellcreek *hellcreek,
>> +			       struct hellcreek_port_hwtstamp *ps,
>> +			       struct sk_buff *skb, struct sk_buff_head *rxq,
>> +			       int port)
>> +{
>> +	struct skb_shared_hwtstamps *shwt;
>> +	struct sk_buff_head received;
>> +	unsigned long flags;
>> +
>> +	/* The latched timestamp belongs to one of the received frames. */
>> +	__skb_queue_head_init(&received);
>> +
>> +	/* Lock & disable interrupts */
>> +	spin_lock_irqsave(&rxq->lock, flags);
>> +
>> +	/* Add the reception queue "rxq" to the "received" queue an reintialize
>> +	 * "rxq".  From now on, we deal with "received" not with "rxq"
>> +	 */
>> +	skb_queue_splice_tail_init(rxq, &received);
>> +
>> +	spin_unlock_irqrestore(&rxq->lock, flags);
>> +
>> +	for (; skb; skb =3D __skb_dequeue(&received)) {
>> +		unsigned int type;
>> +		u8 *hdr;
>> +		u64 ns;
>> +
>> +		/* Get nanoseconds from ptp packet */
>> +		type =3D SKB_PTP_TYPE(skb);
>> +		hdr  =3D parse_ptp_header(skb, type);
>> +		ns   =3D hellcreek_get_reserved_field(hdr);
>> +
>> +		/* Add seconds part */
>> +		spin_lock(&hellcreek->ptp_lock);
>> +		ns +=3D hellcreek_ptp_gettime_seconds(hellcreek, ns);
>> +		spin_unlock(&hellcreek->ptp_lock);
>> +
>> +		/* Save time stamp */
>> +		shwt =3D skb_hwtstamps(skb);
>> +		memset(shwt, 0, sizeof(*shwt));
>> +		shwt->hwtstamp =3D ns_to_ktime(ns);
>> +		netif_rx_ni(skb);
>> +	}
>> +}
>> +
>> +static void hellcreek_rxtstamp_work(struct hellcreek *hellcreek,
>> +				    struct hellcreek_port_hwtstamp *ps,
>> +				    int port)
>> +{
>> +	struct sk_buff *skb;
>> +
>> +	skb =3D skb_dequeue(&ps->rx_queue);
>> +	if (skb)
>> +		hellcreek_get_rxts(hellcreek, ps, skb, &ps->rx_queue, port);
>> +}
>> +
>> +long hellcreek_hwtstamp_work(struct ptp_clock_info *ptp)
>> +{
>> +	struct hellcreek *hellcreek =3D ptp_to_hellcreek(ptp);
>> +	struct dsa_switch *ds =3D hellcreek->ds;
>> +	struct hellcreek_port_hwtstamp *ps;
>> +	int i, restart =3D 0;
>> +
>> +	for (i =3D 2; i < ds->num_ports; i++) {
>> +		ps =3D &hellcreek->ports[i].port_hwtstamp;
>> +
>> +		if (test_bit(HELLCREEK_HWTSTAMP_TX_IN_PROGRESS, &ps->state))
>> +			restart |=3D hellcreek_txtstamp_work(hellcreek, ps, i);
>> +
>> +		hellcreek_rxtstamp_work(hellcreek, ps, i);
>> +	}
>> +
>> +	return restart ? 1 : -1;
>> +}
>> +
>> +bool hellcreek_port_txtstamp(struct dsa_switch *ds, int port,
>> +			     struct sk_buff *clone, unsigned int type)
>> +{
>> +	struct hellcreek *hellcreek =3D ds->priv;
>> +	struct hellcreek_port_hwtstamp *ps;
>> +	u8 *hdr;
>> +
>> +	ps =3D &hellcreek->ports[port].port_hwtstamp;
>> +
>> +	/* Check if the driver is expected to do HW timestamping */
>> +	if (!(skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP))
>> +		return false;
>> +
>
> I would like to get some clarification on whether "SKBTX_IN_PROGRESS"
> should be set in shtx->tx_flags or not. On one hand, it's asking for
> trouble, on the other hand, it's kind of required for proper compliance
> to API pre-SO_TIMESTAMPING...

Hm. We actually oriented our code on the mv88e6xxx time stamping code base.

>
>> +	/* Make sure the message is a PTP message that needs to be timestamped
>> +	 * and the interaction with the HW timestamping is enabled. If not, st=
op
>> +	 * here
>> +	 */
>> +	hdr =3D hellcreek_should_tstamp(hellcreek, port, clone, type);
>> +	if (!hdr)
>> +		return false;
>> +
>> +	if (test_and_set_bit_lock(HELLCREEK_HWTSTAMP_TX_IN_PROGRESS,
>> +				  &ps->state))
>> +		return false;
>> +
>> +	ps->tx_skb =3D clone;
>> +
>> +	/* store the number of ticks occurred since system start-up till this
>> +	 * moment
>> +	 */
>> +	ps->tx_tstamp_start =3D jiffies;
>> +
>> +	ptp_schedule_worker(hellcreek->ptp_clock, 0);
>> +
>> +	return true;
>> +}
>> +
>> +bool hellcreek_port_rxtstamp(struct dsa_switch *ds, int port,
>> +			     struct sk_buff *skb, unsigned int type)
>> +{
>> +	struct hellcreek *hellcreek =3D ds->priv;
>> +	struct hellcreek_port_hwtstamp *ps;
>> +	u8 *hdr;
>> +
>> +	ps =3D &hellcreek->ports[port].port_hwtstamp;
>> +
>> +	/* This check only fails if the user did not initialize hardware
>> +	 * timestamping beforehand.
>> +	 */
>> +	if (ps->tstamp_config.rx_filter !=3D HWTSTAMP_FILTER_PTP_V2_EVENT)
>> +		return false;
>> +
>> +	/* Make sure the message is a PTP message that needs to be timestamped
>> +	 * and the interaction with the HW timestamping is enabled. If not, st=
op
>> +	 * here
>> +	 */
>> +	hdr =3D hellcreek_should_tstamp(hellcreek, port, skb, type);
>> +	if (!hdr)
>> +		return false;
>> +
>> +	SKB_PTP_TYPE(skb) =3D type;
>> +
>> +	skb_queue_tail(&ps->rx_queue, skb);
>> +
>> +	ptp_schedule_worker(hellcreek->ptp_clock, 0);
>> +
>> +	return true;
>> +}
>> +
>> +static void hellcreek_hwtstamp_port_setup(struct hellcreek *hellcreek, =
int port)
>> +{
>> +	struct hellcreek_port_hwtstamp *ps =3D
>> +		&hellcreek->ports[port].port_hwtstamp;
>> +
>> +	skb_queue_head_init(&ps->rx_queue);
>> +}
>> +
>> +int hellcreek_hwtstamp_setup(struct hellcreek *hellcreek)
>> +{
>> +	int i;
>> +
>> +	/* Initialize timestamping ports. */
>> +	for (i =3D 2; i < NUM_PORTS; ++i)
>> +		hellcreek_hwtstamp_port_setup(hellcreek, i);
>> +
>
> Would something like this work better instead?
>
> 	for (port =3D 0; port < ds->num_ports; port++) {
> 		if (!dsa_is_user_port(ds, port))
> 			continue;
>
> 		hellcreek_hwtstamp_port_setup(hellcreek, port);
> 	}
>
> It is easier to follow for the non-expert reviewer (the information that
> port 0 is CPU and port 1 is "tunnel port" is not immediately findable)
> and (I don't know if this is going to be true or not) in the long term,
> you'd need to do less driver rework when this switch IP is instantiated
> in other chips that will have a different port layout.

That's true. It might not be obvious for someone else. Your code should
work. I'll adjust it. I assume there are more instances in the code
starting at i =3D 2. And sometimes it uses NUM_PORTS and sometimes
ds->num_ports...

>
>> +	/* Select the synchronized clock as the source timekeeper for the
>> +	 * timestamps and enable inline timestamping.
>> +	 */
>> +	hellcreek_ptp_write(hellcreek, PR_SETTINGS_C_TS_SRC_TK_MASK |
>> +			    PR_SETTINGS_C_RES3TS,
>> +			    PR_SETTINGS_C);
>> +
>> +	return 0;
>> +}
>> +
>> +void hellcreek_hwtstamp_free(struct hellcreek *hellcreek)
>> +{
>> +	/* Nothing todo */
>> +}
>> diff --git a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h b/drivers/n=
et/dsa/hirschmann/hellcreek_hwtstamp.h
>> new file mode 100644
>> index 000000000000..c0745ffa1ebb
>> --- /dev/null
>> +++ b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h
>> @@ -0,0 +1,58 @@
>> +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
>> +/*
>> + * DSA driver for:
>> + * Hirschmann Hellcreek TSN switch.
>> + *
>> + * Copyright (C) 2019,2020 Hochschule Offenburg
>> + * Copyright (C) 2019,2020 Linutronix GmbH
>> + * Authors: Kurt Kanzenbach <kurt@linutronix.de>
>> + *	    Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
>> + */
>> +
>> +#ifndef _HELLCREEK_HWTSTAMP_H_
>> +#define _HELLCREEK_HWTSTAMP_H_
>> +
>> +#include <net/dsa.h>
>> +#include "hellcreek.h"
>> +
>> +/* Timestamp Register */
>> +#define PR_TS_RX_P1_STATUS_C	(0x1d * 2)
>> +#define PR_TS_RX_P1_DATA_C	(0x1e * 2)
>> +#define PR_TS_TX_P1_STATUS_C	(0x1f * 2)
>> +#define PR_TS_TX_P1_DATA_C	(0x20 * 2)
>> +#define PR_TS_RX_P2_STATUS_C	(0x25 * 2)
>> +#define PR_TS_RX_P2_DATA_C	(0x26 * 2)
>> +#define PR_TS_TX_P2_STATUS_C	(0x27 * 2)
>> +#define PR_TS_TX_P2_DATA_C	(0x28 * 2)
>> +
>> +#define PR_TS_STATUS_TS_AVAIL	BIT(2)
>> +#define PR_TS_STATUS_TS_LOST	BIT(3)
>> +
>> +#define SKB_PTP_TYPE(__skb) (*(unsigned int *)((__skb)->cb))
>> +
>
> Since mv88e6xxx also uses this, maybe we could consider adding it to
> DSA_SKB_CB.

I'm not sure if that's something which should belong in DSA_SKB_CB.

>
>> +/* TX_TSTAMP_TIMEOUT: This limits the time spent polling for a TX
>> + * timestamp. When working properly, hardware will produce a timestamp
>> + * within 1ms. Software may enounter delays, so the timeout is set
>> + * accordingly.
>> + */
>> +#define TX_TSTAMP_TIMEOUT	msecs_to_jiffies(40)
>> +
>> +int hellcreek_port_hwtstamp_set(struct dsa_switch *ds, int port,
>> +				struct ifreq *ifr);
>> +int hellcreek_port_hwtstamp_get(struct dsa_switch *ds, int port,
>> +				struct ifreq *ifr);
>> +
>> +bool hellcreek_port_rxtstamp(struct dsa_switch *ds, int port,
>> +			     struct sk_buff *clone, unsigned int type);
>> +bool hellcreek_port_txtstamp(struct dsa_switch *ds, int port,
>> +			     struct sk_buff *clone, unsigned int type);
>> +
>> +int hellcreek_get_ts_info(struct dsa_switch *ds, int port,
>> +			  struct ethtool_ts_info *info);
>> +
>> +long hellcreek_hwtstamp_work(struct ptp_clock_info *ptp);
>> +
>> +int hellcreek_hwtstamp_setup(struct hellcreek *chip);
>> +void hellcreek_hwtstamp_free(struct hellcreek *chip);
>> +
>> +#endif /* _HELLCREEK_HWTSTAMP_H_ */
>> diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/ds=
a/hirschmann/hellcreek_ptp.c
>> index c606a26a130e..8c2cef2b60fb 100644
>> --- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
>> +++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
>> @@ -12,14 +12,15 @@
>>  #include <linux/ptp_clock_kernel.h>
>>  #include "hellcreek.h"
>>  #include "hellcreek_ptp.h"
>> +#include "hellcreek_hwtstamp.h"
>>=20=20
>> -static u16 hellcreek_ptp_read(struct hellcreek *hellcreek, unsigned int=
 offset)
>> +u16 hellcreek_ptp_read(struct hellcreek *hellcreek, unsigned int offset)
>>  {
>>  	return readw(hellcreek->ptp_base + offset);
>>  }
>>=20=20
>> -static void hellcreek_ptp_write(struct hellcreek *hellcreek, u16 data,
>> -				unsigned int offset)
>> +void hellcreek_ptp_write(struct hellcreek *hellcreek, u16 data,
>> +			 unsigned int offset)
>>  {
>>  	writew(data, hellcreek->ptp_base + offset);
>>  }
>> @@ -61,6 +62,24 @@ static u64 __hellcreek_ptp_gettime(struct hellcreek *=
hellcreek)
>>  	return ns;
>>  }
>>=20=20
>> +/* Retrieve the seconds parts in nanoseconds for a packet timestamped w=
ith @ns.
>> + * There has to be a check whether an overflow occurred between the pac=
ket
>> + * arrival and now. If so use the correct seconds (-1) for calculating =
the
>> + * packet arrival time.
>> + */
>> +u64 hellcreek_ptp_gettime_seconds(struct hellcreek *hellcreek, u64 ns)
>> +{
>> +	u64 s;
>> +
>> +	__hellcreek_ptp_gettime(hellcreek);
>> +	if (hellcreek->last_ts > ns)
>> +		s =3D hellcreek->seconds * NSEC_PER_SEC;
>> +	else
>> +		s =3D (hellcreek->seconds - 1) * NSEC_PER_SEC;
>> +
>> +	return s;
>> +}
>> +
>>  static int hellcreek_ptp_gettime(struct ptp_clock_info *ptp,
>>  				 struct timespec64 *ts)
>>  {
>> @@ -238,17 +257,18 @@ int hellcreek_ptp_setup(struct hellcreek *hellcree=
k)
>>  	 * accumulator_overflow_rate shall not exceed 62.5 MHz (which adjusts
>>  	 * the nominal frequency by 6.25%)
>>  	 */
>> -	hellcreek->ptp_clock_info.max_adj   =3D 62500000;
>> -	hellcreek->ptp_clock_info.n_alarm   =3D 0;
>> -	hellcreek->ptp_clock_info.n_pins    =3D 0;
>> -	hellcreek->ptp_clock_info.n_ext_ts  =3D 0;
>> -	hellcreek->ptp_clock_info.n_per_out =3D 0;
>> -	hellcreek->ptp_clock_info.pps	    =3D 0;
>> -	hellcreek->ptp_clock_info.adjfine   =3D hellcreek_ptp_adjfine;
>> -	hellcreek->ptp_clock_info.adjtime   =3D hellcreek_ptp_adjtime;
>> -	hellcreek->ptp_clock_info.gettime64 =3D hellcreek_ptp_gettime;
>> -	hellcreek->ptp_clock_info.settime64 =3D hellcreek_ptp_settime;
>> -	hellcreek->ptp_clock_info.enable    =3D hellcreek_ptp_enable;
>> +	hellcreek->ptp_clock_info.max_adj     =3D 62500000;
>> +	hellcreek->ptp_clock_info.n_alarm     =3D 0;
>> +	hellcreek->ptp_clock_info.n_pins      =3D 0;
>> +	hellcreek->ptp_clock_info.n_ext_ts    =3D 0;
>> +	hellcreek->ptp_clock_info.n_per_out   =3D 0;
>> +	hellcreek->ptp_clock_info.pps	      =3D 0;
>> +	hellcreek->ptp_clock_info.adjfine     =3D hellcreek_ptp_adjfine;
>> +	hellcreek->ptp_clock_info.adjtime     =3D hellcreek_ptp_adjtime;
>> +	hellcreek->ptp_clock_info.gettime64   =3D hellcreek_ptp_gettime;
>> +	hellcreek->ptp_clock_info.settime64   =3D hellcreek_ptp_settime;
>> +	hellcreek->ptp_clock_info.enable      =3D hellcreek_ptp_enable;
>> +	hellcreek->ptp_clock_info.do_aux_work =3D hellcreek_hwtstamp_work;
>>=20=20
>
> Could you minimize the diff here by indenting these assignments properly
> in the first place, to avoid reindenting them later? It's hard to follow
> what changed. There are also some tabs vs spaces inconsistencies.

Sure.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8MPh4ACgkQeSpbgcuY
8KZHvhAA1Uldzwv8lSyI5CeXr5BOiQUH6fiz6OB4JO1ErqmInMGZV3eGpBA5ZzRZ
K9Bp1Rrzhtjly6v3yg3YtnN6pe3RTB+TUBwY8+cH5Pk0RGWyWC+/4LWWEmfpyD1J
GGY+SufywDvZtqim9BI0mzL9CNUH9d2DU+d6NhZk7YY0dO6FRxsqwEpRxqkek6CB
+zMPz/Tyu9+hRI4lDIaV2KOYTXGd/BT8vddwS3xzdoYcLib4sxU9SVrufM6p6dFU
4UqOIyFk7bJYHUxpgneTLaUxoqmEYWsWIF1S3ri6eNR9kAsSXKM+D+iqxBvXhqRO
ySOo4GwXWD0RLo6xfV1XPrsln2oD5/ACITKHR2YpO7c4tvSQeP03leXmif/gU/Iz
+3GmS1VYSiydq1qYTXIlNpy4TKKA1d2anpeEnji05sBx0Cl/0fj4ffb4W9kHOg8/
eST3+vpTX8C595gE9iT8shsbfjWkbX4rx6Qhhsg66L5EPIITS03235KRi4uukGcE
THoeHwmfKocvsVPRCOjudOLazwE+MLtKo6aOPP3KIbKFjXdH1LdZPoYcQNmDOrKq
AyFTqHfsvjN0Wl4uju10zenl8wVxEnTb0Ny6klQRbSR9XQ5NYWBC2iXZH8Hr3jj4
S37nyblye7DA9U4oNzb7k5tIglsArgqHL8Ac/8w9wj32huXW/5w=
=tI/f
-----END PGP SIGNATURE-----
--=-=-=--
