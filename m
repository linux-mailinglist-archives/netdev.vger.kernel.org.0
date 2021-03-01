Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EEC327C2C
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbhCAKbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:31:14 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55024 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234251AbhCAKbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:31:08 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 637341C0B76; Mon,  1 Mar 2021 11:30:24 +0100 (CET)
Date:   Mon, 1 Mar 2021 11:30:24 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Ben Whitten <ben.whitten@gmail.com>
Subject: Re: [PATCH RFC leds + net-next 2/7] leds: trigger: netdev: simplify
 the driver by using bit field members
Message-ID: <20210301103024.GA31897@duo.ucw.cz>
References: <20201030114435.20169-1-kabel@kernel.org>
 <20201030114435.20169-3-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20201030114435.20169-3-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2020-10-30 12:44:30, Marek Beh=FAn wrote:
> Use bit fields members in struct led_netdev_data instead of one mode
> member and set_bit/clear_bit/test_bit functions. These functions are
> suitable for longer or variable length bit arrays.

They also provide atomicity guarantees. If you can explain why this is
safe, we can do this, but it needs _way_ better changelog.

								Pavel

> Signed-off-by: Marek Beh=FAn <kabel@kernel.org>
> ---
>  drivers/leds/trigger/ledtrig-netdev.c | 69 ++++++++++++---------------
>  1 file changed, 30 insertions(+), 39 deletions(-)
>=20
> diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger=
/ledtrig-netdev.c
> index 4f6b73e3b491..8f013b6df4fa 100644
> --- a/drivers/leds/trigger/ledtrig-netdev.c
> +++ b/drivers/leds/trigger/ledtrig-netdev.c
> @@ -49,11 +49,11 @@ struct led_netdev_data {
>  	atomic_t interval;
>  	unsigned int last_activity;
> =20
> -	unsigned long mode;
> -#define NETDEV_LED_LINK	0
> -#define NETDEV_LED_TX	1
> -#define NETDEV_LED_RX	2
> -#define NETDEV_LED_MODE_LINKUP	3
> +	unsigned link:1;
> +	unsigned tx:1;
> +	unsigned rx:1;
> +
> +	unsigned linkup:1;
>  };
> =20
>  enum netdev_led_attr {
> @@ -73,10 +73,10 @@ static void set_baseline_state(struct led_netdev_data=
 *trigger_data)
>  	if (!led_cdev->blink_brightness)
>  		led_cdev->blink_brightness =3D led_cdev->max_brightness;
> =20
> -	if (!test_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode))
> +	if (!trigger_data->linkup)
>  		led_set_brightness(led_cdev, LED_OFF);
>  	else {
> -		if (test_bit(NETDEV_LED_LINK, &trigger_data->mode))
> +		if (trigger_data->link)
>  			led_set_brightness(led_cdev,
>  					   led_cdev->blink_brightness);
>  		else
> @@ -85,8 +85,7 @@ static void set_baseline_state(struct led_netdev_data *=
trigger_data)
>  		/* If we are looking for RX/TX start periodically
>  		 * checking stats
>  		 */
> -		if (test_bit(NETDEV_LED_TX, &trigger_data->mode) ||
> -		    test_bit(NETDEV_LED_RX, &trigger_data->mode))
> +		if (trigger_data->tx || trigger_data->rx)
>  			schedule_delayed_work(&trigger_data->work, 0);
>  	}
>  }
> @@ -131,10 +130,10 @@ static ssize_t device_name_store(struct device *dev,
>  		trigger_data->net_dev =3D
>  		    dev_get_by_name(&init_net, trigger_data->device_name);
> =20
> -	clear_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
> +	trigger_data->linkup =3D 0;
>  	if (trigger_data->net_dev !=3D NULL)
>  		if (netif_carrier_ok(trigger_data->net_dev))
> -			set_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
> +			trigger_data->linkup =3D 1;
> =20
>  	trigger_data->last_activity =3D 0;
> =20
> @@ -150,23 +149,24 @@ static ssize_t netdev_led_attr_show(struct device *=
dev, char *buf,
>  	enum netdev_led_attr attr)
>  {
>  	struct led_netdev_data *trigger_data =3D led_trigger_get_drvdata(dev);
> -	int bit;
> +	int val;
> =20
>  	switch (attr) {
>  	case NETDEV_ATTR_LINK:
> -		bit =3D NETDEV_LED_LINK;
> +		val =3D trigger_data->link;
>  		break;
>  	case NETDEV_ATTR_TX:
> -		bit =3D NETDEV_LED_TX;
> +		val =3D trigger_data->tx;
>  		break;
>  	case NETDEV_ATTR_RX:
> -		bit =3D NETDEV_LED_RX;
> +		val =3D trigger_data->rx;
>  		break;
>  	default:
> -		return -EINVAL;
> +		/* unreachable */
> +		break;
>  	}
> =20
> -	return sprintf(buf, "%u\n", test_bit(bit, &trigger_data->mode));
> +	return sprintf(buf, "%u\n", val);
>  }
> =20
>  static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
> @@ -175,33 +175,28 @@ static ssize_t netdev_led_attr_store(struct device =
*dev, const char *buf,
>  	struct led_netdev_data *trigger_data =3D led_trigger_get_drvdata(dev);
>  	unsigned long state;
>  	int ret;
> -	int bit;
> =20
>  	ret =3D kstrtoul(buf, 0, &state);
>  	if (ret)
>  		return ret;
> =20
> +	cancel_delayed_work_sync(&trigger_data->work);
> +
>  	switch (attr) {
>  	case NETDEV_ATTR_LINK:
> -		bit =3D NETDEV_LED_LINK;
> +		trigger_data->link =3D state;
>  		break;
>  	case NETDEV_ATTR_TX:
> -		bit =3D NETDEV_LED_TX;
> +		trigger_data->tx =3D state;
>  		break;
>  	case NETDEV_ATTR_RX:
> -		bit =3D NETDEV_LED_RX;
> +		trigger_data->rx =3D state;
>  		break;
>  	default:
> -		return -EINVAL;
> +		/* unreachable */
> +		break;
>  	}
> =20
> -	cancel_delayed_work_sync(&trigger_data->work);
> -
> -	if (state)
> -		set_bit(bit, &trigger_data->mode);
> -	else
> -		clear_bit(bit, &trigger_data->mode);
> -
>  	set_baseline_state(trigger_data);
> =20
>  	return size;
> @@ -315,7 +310,7 @@ static int netdev_trig_notify(struct notifier_block *=
nb,
> =20
>  	spin_lock_bh(&trigger_data->lock);
> =20
> -	clear_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
> +	trigger_data->linkup =3D 0;
>  	switch (evt) {
>  	case NETDEV_CHANGENAME:
>  	case NETDEV_REGISTER:
> @@ -331,7 +326,7 @@ static int netdev_trig_notify(struct notifier_block *=
nb,
>  	case NETDEV_UP:
>  	case NETDEV_CHANGE:
>  		if (netif_carrier_ok(dev))
> -			set_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
> +			trigger_data->linkup =3D 1;
>  		break;
>  	}
> =20
> @@ -360,21 +355,17 @@ static void netdev_trig_work(struct work_struct *wo=
rk)
>  	}
> =20
>  	/* If we are not looking for RX/TX then return  */
> -	if (!test_bit(NETDEV_LED_TX, &trigger_data->mode) &&
> -	    !test_bit(NETDEV_LED_RX, &trigger_data->mode))
> +	if (!trigger_data->tx && !trigger_data->rx)
>  		return;
> =20
>  	dev_stats =3D dev_get_stats(trigger_data->net_dev, &temp);
> -	new_activity =3D
> -	    (test_bit(NETDEV_LED_TX, &trigger_data->mode) ?
> -		dev_stats->tx_packets : 0) +
> -	    (test_bit(NETDEV_LED_RX, &trigger_data->mode) ?
> -		dev_stats->rx_packets : 0);
> +	new_activity =3D (trigger_data->tx ? dev_stats->tx_packets : 0) +
> +		       (trigger_data->rx ? dev_stats->rx_packets : 0);
> =20
>  	if (trigger_data->last_activity !=3D new_activity) {
>  		led_stop_software_blink(trigger_data->led_cdev);
> =20
> -		invert =3D test_bit(NETDEV_LED_LINK, &trigger_data->mode);
> +		invert =3D trigger_data->link;
>  		interval =3D jiffies_to_msecs(
>  				atomic_read(&trigger_data->interval));
>  		/* base state is ON (link present) */
> --=20
> 2.26.2

--=20
http://www.livejournal.com/~pavelmachek

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYDzCQAAKCRAw5/Bqldv6
8kHFAKCNwKKtKSy97DppcH5jmGLRM1bGGwCdHfW8OksJn+5c5lvwAukojPbEYic=
=S5me
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
