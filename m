Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2221382BB
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 18:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbgAKRtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 12:49:49 -0500
Received: from bues.ch ([80.190.117.144]:45422 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730641AbgAKRtt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jan 2020 12:49:49 -0500
X-Greylist: delayed 2015 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Jan 2020 12:49:48 EST
Received: by bues.ch with esmtpsa (Exim 4.92)
        (envelope-from <m@bues.ch>)
        id 1iqKMY-0002Bp-7l; Sat, 11 Jan 2020 18:15:50 +0100
Date:   Sat, 11 Jan 2020 18:15:57 +0100
From:   Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, allison@lohutok.net,
        saurav.girepunje@gmail.com, tglx@linutronix.de, will@kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b43: Fix possible a data race in b43_op_tx()
Message-ID: <20200111181557.11b6b174@wiggum>
In-Reply-To: <20200111161455.26587-1-baijiaju1990@gmail.com>
References: <20200111161455.26587-1-baijiaju1990@gmail.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/edhf2Fx3kHYL6/4KBjkb=AD";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/edhf2Fx3kHYL6/4KBjkb=AD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Jan 2020 00:14:55 +0800
Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> The functions b43_op_tx() and b43_tx_work() may be concurrently executed.
>=20
> In b43_tx_work(), the variable wl->tx_queue_stopped[queue_num] is
> accessed with holding a mutex lock wl->mutex. But in b43_op_tx(), the
> identical variable wl->tx_queue_stopped[skb->queue_mapping] is accessed
> without holding this mutex lock. Thus, a possible data race may occur.
>=20
> To fix this data race, in b43_op_tx(), the variable=20
> wl->tx_queue_stopped[skb->queue_mapping] is accessed with holding the=20
> mutex lock wl->mutex.
>=20
> This data race is found by the runtime testing of our tool DILP-2.
>=20
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/net/wireless/broadcom/b43/main.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wirel=
ess/broadcom/b43/main.c
> index 39da1a4c30ac..adedb38f50f2 100644
> --- a/drivers/net/wireless/broadcom/b43/main.c
> +++ b/drivers/net/wireless/broadcom/b43/main.c
> @@ -3625,6 +3625,11 @@ static void b43_op_tx(struct ieee80211_hw *hw,
>  		      struct sk_buff *skb)
>  {
>  	struct b43_wl *wl =3D hw_to_b43_wl(hw);
> +	bool stopped;
> +
> +	mutex_lock(&wl->mutex);
> +	stopped =3D wl->tx_queue_stopped[skb->queue_mapping];
> +	mutex_unlock(&wl->mutex);
> =20
>  	if (unlikely(skb->len < 2 + 2 + 6)) {
>  		/* Too short, this can't be a valid frame. */
> @@ -3634,7 +3639,7 @@ static void b43_op_tx(struct ieee80211_hw *hw,
>  	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
> =20
>  	skb_queue_tail(&wl->tx_queue[skb->queue_mapping], skb);
> -	if (!wl->tx_queue_stopped[skb->queue_mapping]) {
> +	if (!stopped) {
>  		ieee80211_queue_work(wl->hw, &wl->tx_work);
>  	} else {
>  		ieee80211_stop_queue(wl->hw, skb->queue_mapping);

Hi,

thanks for your patch.

Unfortunately it is not possible to acquire a sleeping mutex in the tx
op:

/**
 * struct ieee80211_ops - callbacks from mac80211 to the driver
 *
 * @tx: Handler that 802.11 module calls for each transmitted frame.
 *      skb contains the buffer starting from the IEEE 802.11 header.
 *      The low-level driver should send the frame out based on
 *      configuration in the TX control data. This handler should,
 *      preferably, never fail and stop queues appropriately.
 *      Must be atomic.
        ^^^^^^^^^^^^^^

I also don't think that the change really fixes any race.
The variable tx_queue_stopped is a boolean. Reading that under mutex
and then doing the actual action based on a copy does not really change
anything. The other end may just set it to false after mutex_unlock,
but before the queue_work. Thus this change does probably even increase
the race window size.

The other thing to consider is:
What can actually go wrong, if the race happens?
I currently don't see any fatal behavior.
A packet might still make it into the queue, although it has already
been stopped. But that's not fatal.

--=20
Michael

--Sig_/edhf2Fx3kHYL6/4KBjkb=AD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAl4aAs0ACgkQ9TK+HZCN
iw6TPQ//d1QZTRW32tb9pJeehH2Z3IOrjYuu8UXzz47+ykPNCAg84T9kfhPdVV1n
y9FMecAuYqgPTWByYotMoeaVLj10pAJ5fqe+qtMbl3OvOuTmuzSRdOKzChJr1BJj
5FxM+j8e0bbUW+5Xovvkecs1aH4XN6onL0XGoI6rNefN+9iHD4OnC/3tVTh5cvXx
iY4dlFXWs21OcEamszU7RjZIulaI55GN9RTzctsjBsx/cGtxkeIhEG0AMwvAcH2g
PfoxTwpEiUIZhvfb4qyA9sonm1GANvwNUo1wlO4dHWl709ei1oK+gWSl4UMyxlaO
Jf7+c9LiB0R6gXAdpjIWDrdFoNhoZnJMrJ6yXwr7bxxvs8cbzOxloJ3rtllQdmf9
XNcmAakeSj19sDobTMDqup+ZFatXTs3zrgluzn9y7SJoysaV5+uU2HQAjjb5E5mn
fb51kot6LMO5aW06jxEsgEvZ66udxDR1hfjyxF5fmuHMEsgZLM8yoNpsB5YS/Mo7
YfR2bO2kgRXhXRxPBdL6RudtMOtv7ut3FoFg1kXZTzqMqAjFBpp9dp7LkVt9rRQM
Fg4/9/SuP/L8te7u2I3m5FnCCAgqKz5W+8FPtkgNrF3nHptqrPQqmzt6wOW76h/H
5hofJcfy2Its6lu34C6/pfSqTRbv+u4Nb34CphZCqwkuNiReVXI=
=DukR
-----END PGP SIGNATURE-----

--Sig_/edhf2Fx3kHYL6/4KBjkb=AD--
