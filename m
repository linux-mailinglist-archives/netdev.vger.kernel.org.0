Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496D3225D46
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 13:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgGTLUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 07:20:30 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:40974 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbgGTLU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 07:20:29 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1262B1C0BE2; Mon, 20 Jul 2020 13:20:28 +0200 (CEST)
Date:   Mon, 20 Jul 2020 13:20:27 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next 1/3] leds: trigger: add support for
 LED-private device triggers
Message-ID: <20200720112027.GB12916@amd>
References: <20200716171730.13227-1-marek.behun@nic.cz>
 <20200716171730.13227-2-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Content-Disposition: inline
In-Reply-To: <20200716171730.13227-2-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Some LED controllers may come with an internal HW triggering mechanism
> for the LED and the ability to switch between SW control and the
> internal HW control. This includes most PHYs, various ethernet switches,
> the Turris Omnia LED controller or AXP20X PMIC.
>=20
> This adds support for registering such triggers.
>=20
> This code is based on work by Pavel Machek <pavel@ucw.cz> and
> Ond=C5=99ej Jirman <megous@megous.com>.
>=20
> Signed-off-by: Marek Beh=C3=BAn <marek.behun@nic.cz>

Looks good to me. I'll likely apply it soon...

Best regards,
								Pavel


> ---
>  drivers/leds/led-triggers.c | 26 ++++++++++++++++++++------
>  include/linux/leds.h        | 10 ++++++++++
>  2 files changed, 30 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
> index 79e30d2cb7a5..81e758d5a048 100644
> --- a/drivers/leds/led-triggers.c
> +++ b/drivers/leds/led-triggers.c
> @@ -27,6 +27,12 @@ LIST_HEAD(trigger_list);
> =20
>   /* Used by LED Class */
> =20
> +static inline bool
> +trigger_relevant(struct led_classdev *led_cdev, struct led_trigger *trig)
> +{
> +	return !trig->trigger_type || trig->trigger_type =3D=3D led_cdev->trigg=
er_type;
> +}
> +
>  ssize_t led_trigger_write(struct file *filp, struct kobject *kobj,
>  			  struct bin_attribute *bin_attr, char *buf,
>  			  loff_t pos, size_t count)
> @@ -50,7 +56,7 @@ ssize_t led_trigger_write(struct file *filp, struct kob=
ject *kobj,
> =20
>  	down_read(&triggers_list_lock);
>  	list_for_each_entry(trig, &trigger_list, next_trig) {
> -		if (sysfs_streq(buf, trig->name)) {
> +		if (sysfs_streq(buf, trig->name) && trigger_relevant(led_cdev, trig)) {
>  			down_write(&led_cdev->trigger_lock);
>  			led_trigger_set(led_cdev, trig);
>  			up_write(&led_cdev->trigger_lock);
> @@ -93,8 +99,12 @@ static int led_trigger_format(char *buf, size_t size,
>  				       led_cdev->trigger ? "none" : "[none]");
> =20
>  	list_for_each_entry(trig, &trigger_list, next_trig) {
> -		bool hit =3D led_cdev->trigger &&
> -			!strcmp(led_cdev->trigger->name, trig->name);
> +		bool hit;
> +
> +		if (!trigger_relevant(led_cdev, trig))
> +			continue;
> +
> +		hit =3D led_cdev->trigger && !strcmp(led_cdev->trigger->name, trig->na=
me);
> =20
>  		len +=3D led_trigger_snprintf(buf + len, size - len,
>  					    " %s%s%s", hit ? "[" : "",
> @@ -243,7 +253,8 @@ void led_trigger_set_default(struct led_classdev *led=
_cdev)
>  	down_read(&triggers_list_lock);
>  	down_write(&led_cdev->trigger_lock);
>  	list_for_each_entry(trig, &trigger_list, next_trig) {
> -		if (!strcmp(led_cdev->default_trigger, trig->name)) {
> +		if (!strcmp(led_cdev->default_trigger, trig->name) &&
> +		    trigger_relevant(led_cdev, trig)) {
>  			led_cdev->flags |=3D LED_INIT_DEFAULT_TRIGGER;
>  			led_trigger_set(led_cdev, trig);
>  			break;
> @@ -280,7 +291,9 @@ int led_trigger_register(struct led_trigger *trig)
>  	down_write(&triggers_list_lock);
>  	/* Make sure the trigger's name isn't already in use */
>  	list_for_each_entry(_trig, &trigger_list, next_trig) {
> -		if (!strcmp(_trig->name, trig->name)) {
> +		if (!strcmp(_trig->name, trig->name) &&
> +		    (trig->trigger_type =3D=3D _trig->trigger_type ||
> +		     !trig->trigger_type || !_trig->trigger_type)) {
>  			up_write(&triggers_list_lock);
>  			return -EEXIST;
>  		}
> @@ -294,7 +307,8 @@ int led_trigger_register(struct led_trigger *trig)
>  	list_for_each_entry(led_cdev, &leds_list, node) {
>  		down_write(&led_cdev->trigger_lock);
>  		if (!led_cdev->trigger && led_cdev->default_trigger &&
> -			    !strcmp(led_cdev->default_trigger, trig->name)) {
> +		    !strcmp(led_cdev->default_trigger, trig->name) &&
> +		    trigger_relevant(led_cdev, trig)) {
>  			led_cdev->flags |=3D LED_INIT_DEFAULT_TRIGGER;
>  			led_trigger_set(led_cdev, trig);
>  		}
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 2451962d1ec5..6a8d6409c993 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -57,6 +57,10 @@ struct led_init_data {
>  	bool devname_mandatory;
>  };
> =20
> +struct led_hw_trigger_type {
> +	int dummy;
> +};
> +
>  struct led_classdev {
>  	const char		*name;
>  	enum led_brightness	 brightness;
> @@ -141,6 +145,9 @@ struct led_classdev {
>  	void			*trigger_data;
>  	/* true if activated - deactivate routine uses it to do cleanup */
>  	bool			activated;
> +
> +	/* LEDs that have private triggers have this set */
> +	struct led_hw_trigger_type	*trigger_type;
>  #endif
> =20
>  #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
> @@ -345,6 +352,9 @@ struct led_trigger {
>  	int		(*activate)(struct led_classdev *led_cdev);
>  	void		(*deactivate)(struct led_classdev *led_cdev);
> =20
> +	/* LED-private triggers have this set */
> +	struct led_hw_trigger_type *trigger_type;
> +
>  	/* LEDs under control by this trigger (for simple triggers) */
>  	rwlock_t	  leddev_list_lock;
>  	struct list_head  led_cdevs;

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8VffsACgkQMOfwapXb+vLp/gCeMtMMSvEjqFCokvWeugfa/eSu
D38AniUHyDzcR/0UVqRmGSszhklWHjka
=BIyE
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--
