Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3104E69F35C
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 12:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbjBVLSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 06:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjBVLSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 06:18:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DED51E9E3;
        Wed, 22 Feb 2023 03:18:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB4DBB8123A;
        Wed, 22 Feb 2023 11:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE88C433D2;
        Wed, 22 Feb 2023 11:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677064720;
        bh=295Qb6ISVepxIQV0I1l25MiCOBTjQjYbtyzUMz6FO7Y=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=cdMflZDJyRMf9Fedjs52EKktuE3eOjkha3MA9skYsRpVAjW8iSV9Oz7qB5h5SMvIT
         s897EdONEenAfOKBeC+Rph0iN83IrcYzwHavTBYbEzpATrY1ZQuiJm4LWEB9lQSvsI
         qozAZQY1iT+1dy6/k7rdDHv6w51Kn1h79zzP1emSvS+vC19rW48SyNOx60yGSOlo7O
         haxZOjqI7cPx2mmJRMs5921yFX+AqUQ+XCvBHy2kgK1kUFn7NbCRkE9oMUiEcoSSPY
         QQKF4VhHZSsXici1S0Zkf8Ck1AULuh2zJqJaSed5Kd8AX7nY/BsLEZDTZoZJs3l8MQ
         +DNEsMLT7s/Vg==
Date:   Wed, 22 Feb 2023 12:18:36 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Helmut Grohne <helmut@subdivi.de>, Felix Fietkau <nbd@nbd.name>,
        Ryder Lee <ryder.lee@mediatek.com>,
        linux-wireless@vger.kernel.org,
        Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>, netdev@vger.kernel.org,
        1029116@bugs.debian.org
Subject: Re: [PATCH] wifi: mt76: mt7921: correctly handle removal in the
 absence of firmware
Message-ID: <Y/X6DPaxF0TMaUBh@lore-desk>
References: <Y/Ss5LYSYG2M7jSq@alf.mars>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="W/r38GG1U0C/BE2Q"
Content-Disposition: inline
In-Reply-To: <Y/Ss5LYSYG2M7jSq@alf.mars>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--W/r38GG1U0C/BE2Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Trying to probe a mt7921e pci card without firmware results in a
> successful probe where ieee80211_register_hw hasn't been called. When
> removing the driver, ieee802111_unregister_hw is called unconditionally
> leading to a kernel NULL pointer dereference among other things.
>=20
> As with other drivers that delay registration after probe, we track the
> registration state in a flag variable and conidtionalize deregistration.
>=20
> Link: https://bugs.debian.org/1029116
> Link: https://bugs.kali.org/view.php?id=3D8140
> Reported-by: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
> Fixes: 1c71e03afe4b ("mt76: mt7921: move mt7921_init_hw in a dedicated wo=
rk")
> Signed-off-by: Helmut Grohne <helmut@freexian.com>
> Cc: stable@vger.kernel.org
> Sponsored-by: Freexian and Offensive Security

Hi Helmut,

Thx for working on this. I would say it is a more general issue since we ha=
ve
dbdc support in mt7915/mt7996/mt7915 devices. I think we can move the check=
 in
mac80211.c, what do you think? Something like (please note this patch is not
tested):

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wi=
reless/mediatek/mt76/mac80211.c
index b117e4467c87..34abf70f44af 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -539,6 +539,7 @@ int mt76_register_phy(struct mt76_phy *phy, bool vht,
 	if (ret)
 		return ret;
=20
+	set_bit(MT76_STATE_REGISTERED, &phy->state);
 	phy->dev->phys[phy->band_idx] =3D phy;
=20
 	return 0;
@@ -549,6 +550,9 @@ void mt76_unregister_phy(struct mt76_phy *phy)
 {
 	struct mt76_dev *dev =3D phy->dev;
=20
+	if (!test_bit(MT76_STATE_REGISTERED, &phy->state))
+		return;
+
 	if (IS_ENABLED(CONFIG_MT76_LEDS))
 		mt76_led_cleanup(phy);
 	mt76_tx_status_check(dev, true);
@@ -719,6 +723,7 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 		return ret;
=20
 	WARN_ON(mt76_worker_setup(hw, &dev->tx_worker, NULL, "tx"));
+	set_bit(MT76_STATE_REGISTERED, &phy->state);
 	sched_set_fifo_low(dev->tx_worker.task);
=20
 	return 0;
@@ -729,6 +734,9 @@ void mt76_unregister_device(struct mt76_dev *dev)
 {
 	struct ieee80211_hw *hw =3D dev->hw;
=20
+	if (!test_bit(MT76_STATE_REGISTERED, &dev->phy.state))
+		return;
+
 	if (IS_ENABLED(CONFIG_MT76_LEDS))
 		mt76_led_cleanup(&dev->phy);
 	mt76_tx_status_check(dev, true);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wirele=
ss/mediatek/mt76/mt76.h
index 4ffb6be63571..38c311760d15 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -402,6 +402,7 @@ struct mt76_tx_cb {
=20
 enum {
 	MT76_STATE_INITIALIZED,
+	MT76_STATE_REGISTERED,
 	MT76_STATE_RUNNING,
 	MT76_STATE_MCU_RUNNING,
 	MT76_SCANNING,

Regards,
Lorenzo

> ---
>  drivers/net/wireless/mediatek/mt76/mt7921/init.c   | 1 +
>  drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h | 1 +
>  drivers/net/wireless/mediatek/mt76/mt7921/pci.c    | 3 ++-
>  drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   | 3 ++-
>  drivers/net/wireless/mediatek/mt76/mt7921/usb.c    | 3 ++-
>  5 files changed, 8 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/n=
et/wireless/mediatek/mt76/mt7921/init.c
> index 542dfd425129..d5438212d5ff 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
> @@ -315,6 +315,7 @@ static void mt7921_init_work(struct work_struct *work)
>  		dev_err(dev->mt76.dev, "register device failed\n");
>  		return;
>  	}
> +	dev->hw_registered =3D true;
> =20
>  	ret =3D mt7921_init_debugfs(dev);
>  	if (ret) {
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers=
/net/wireless/mediatek/mt76/mt7921/mt7921.h
> index 15d6b7fe1c6c..e3b5d8ebf243 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
> @@ -288,6 +288,7 @@ struct mt7921_dev {
>  	bool hw_full_reset:1;
>  	bool hw_init_done:1;
>  	bool fw_assert:1;
> +	bool hw_registered:1;
> =20
>  	struct list_head sta_poll_list;
>  	spinlock_t sta_poll_lock;
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7921/pci.c
> index cb72ded37256..1841eb7345dc 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
> @@ -110,7 +110,8 @@ static void mt7921e_unregister_device(struct mt7921_d=
ev *dev)
>  	struct mt76_connac_pm *pm =3D &dev->pm;
> =20
>  	cancel_work_sync(&dev->init_work);
> -	mt76_unregister_device(&dev->mt76);
> +	if (dev->hw_registered)
> +		mt76_unregister_device(&dev->mt76);
>  	mt76_for_each_q_rx(&dev->mt76, i)
>  		napi_disable(&dev->mt76.napi[i]);
>  	cancel_delayed_work_sync(&pm->ps_work);
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c b/drivers/n=
et/wireless/mediatek/mt76/mt7921/sdio.c
> index 8ce4252b8ae7..23a9dd3c6450 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
> @@ -43,7 +43,8 @@ static void mt7921s_unregister_device(struct mt7921_dev=
 *dev)
>  	struct mt76_connac_pm *pm =3D &dev->pm;
> =20
>  	cancel_work_sync(&dev->init_work);
> -	mt76_unregister_device(&dev->mt76);
> +	if (dev->hw_registered)
> +		mt76_unregister_device(&dev->mt76);
>  	cancel_delayed_work_sync(&pm->ps_work);
>  	cancel_work_sync(&pm->wake_work);
> =20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7921/usb.c
> index 5321d20dcdcb..e55e1b50f760 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
> @@ -301,7 +301,8 @@ static void mt7921u_disconnect(struct usb_interface *=
usb_intf)
>  	if (!test_bit(MT76_STATE_INITIALIZED, &dev->mphy.state))
>  		return;
> =20
> -	mt76_unregister_device(&dev->mt76);
> +	if (dev->hw_registered)
> +		mt76_unregister_device(&dev->mt76);
>  	mt7921u_cleanup(dev);
> =20
>  	usb_set_intfdata(usb_intf, NULL);
> --=20
> 2.39.0
>=20
>=20

--W/r38GG1U0C/BE2Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY/X6DAAKCRA6cBh0uS2t
rC4cAQCFwKDTkJb1JjkR6UTkTzE7pOo5BO+mtZvpFvWnJMOYeAEAgHeBci5psd+6
jsjkH+UszJBa+6ZC63JUsi2kVnoO4gg=
=YcRl
-----END PGP SIGNATURE-----

--W/r38GG1U0C/BE2Q--
