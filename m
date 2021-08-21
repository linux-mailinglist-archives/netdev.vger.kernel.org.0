Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDCBF3F3A5E
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 13:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbhHULPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 07:15:23 -0400
Received: from vulcan.natalenko.name ([104.207.131.136]:42230 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbhHULPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 07:15:22 -0400
Received: from spock.localnet (unknown [151.237.229.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 08A92BA4FC6;
        Sat, 21 Aug 2021 13:14:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1629544476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=umVteWhtE2Y6pX84ROLTjZT8B1ZFi83/8HYc7YQclzY=;
        b=mUHHl8on5x48NmhhWuSxB/2DSG63lQmB32tN9CtssgeK/mJFO2EwrqzABRxUA+SqhsWG2w
        ls9EMRzkb/mKA2IFMP+I7zgMHZUlp2oVu/gEtf7oajQFlJyzfhv/CPo6wpNHBGtjCnr012
        NVTsreoBWP6nb2/eCpDS2DRwiVV62yc=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: Divide error in minstrel_ht_get_tp_avg()
Date:   Sat, 21 Aug 2021 13:14:34 +0200
Message-ID: <2137329.lhgpPQ2jGW@natalenko.name>
In-Reply-To: <20210607145223.tlxo5ge42mef44m5@spock.localdomain>
References: <20210529165728.bskaozwtmwxnvucx@spock.localdomain> <20210607145223.tlxo5ge42mef44m5@spock.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On pond=C4=9Bl=C3=AD 7. =C4=8Dervna 2021 16:52:30 CEST Oleksandr Natalenko =
wrote:
> On Sat, May 29, 2021 at 06:57:29PM +0200, Oleksandr Natalenko wrote:
> > The following woe happened on my home router running as a Wi-Fi AP with
> > MT7612:
> >=20
> > ```
> > [16592.157962] divide error: 0000 [#1] PREEMPT SMP PTI
> > [16592.163169] CPU: 2 PID: 683 Comm: mt76-tx phy0 Tainted: G         C =
  =20
> >    5.12.0-pf4 #1 [16592.171745] Hardware name: To Be Filled By O.E.M. To
> > Be Filled By O.E.M./J3710-ITX, BIOS P1.50 04/16/2018 [16592.182155] RIP:
> > 0010:minstrel_ht_get_tp_avg+0xb1/0x100 [mac80211] [16592.188795] Code: =
04
> > 00 00 00 7f 1c 31 c9 81 fa f1 49 02 00 0f 9c c1 8d 0c cd 08 00 00 00 eb
> > 08 8b 47 30 b9 01 00 00 00 69 c0 e8 03 00 00 31 d2 <f7> f1 ba 66 0e 00 =
00
> > 39 d6 0f 4f f2 49 63 d1 48 8d 0c 52 48 8d 0c [16592.208796] RSP:
> > 0018:ffffb6a601293be8 EFLAGS: 00010246
> > [16592.214292] RAX: 000000000001a5e0 RBX: ffff9c658ee95170 RCX:
> > 0000000000000000 [16592.222054] RDX: 0000000000000000 RSI:
> > 0000000000000585 RDI: ffff9c658ee94000 [16592.229620] RBP:
> > 0000000000000006 R08: 0000000000000006 R09: 0000000000000012
> > [16592.237254] R10: 0000000000000007 R11: 0000000000000000 R12:
> > ffff9c658ee94000 [16592.244828] R13: 0000000000000012 R14:
> > ffff9c658ee9534c R15: 0000000000000585 [16592.252635] FS:=20
> > 0000000000000000(0000) GS:ffff9c66f8500000(0000) knlGS:0000000000000000
> > [16592.261086] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [16592.267326] CR2: 0000555d81abe7b8 CR3: 0000000116c10000 CR4:
> > 00000000001006e0 [16592.274904] Call Trace:
> > [16592.277549]  minstrel_ht_update_stats+0x1fe/0x1320 [mac80211]
> > [16592.283730]  minstrel_ht_tx_status+0x67f/0x710 [mac80211]
> > [16592.289442]  rate_control_tx_status+0x6e/0xb0 [mac80211]
> > [16592.295267]  ieee80211_tx_status_ext+0x22e/0xb00 [mac80211]
> > [16592.311290]  ieee80211_tx_status+0x7d/0xa0 [mac80211]
> > [16592.316714]  mt76_tx_status_unlock+0x83/0xa0 [mt76]
> > [16592.321999]  mt76x02_send_tx_status+0x1b7/0x400 [mt76x02_lib]
> > [16592.334516]  mt76x02_tx_worker+0x8f/0xd0 [mt76x02_lib]
> > [16592.340091]  __mt76_worker_fn+0x78/0xb0 [mt76]
> > [16592.345067]  kthread+0x183/0x1b0
> > [16592.353378]  ret_from_fork+0x22/0x30
> > ```
> >=20
> > `faddr2line` says it is this:
> >=20
> > ```
> >=20
> >  430 int
> >  431 minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int
> >  rate,
> >  432                int prob_avg)
> >  433 {
> >=20
> > =E2=80=A6
> >=20
> >  435     unsigned int ampdu_len =3D 1;
> >=20
> > =E2=80=A6
> >=20
> >  441     if (minstrel_ht_is_legacy_group(group))
> >=20
> > =E2=80=A6
> >=20
> >  443     else
> >  444         ampdu_len =3D minstrel_ht_avg_ampdu_len(mi);
> >=20
> > =E2=80=A6
> >=20
> >  446     nsecs =3D 1000 * overhead / ampdu_len;
> > =20
> >          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >=20
> > ```
> >=20
> > So, it seems `minstrel_ht_avg_ampdu_len()` can return 0, which is not
> > really legitimate.
> >=20
> > Looking at `minstrel_ht_avg_ampdu_len()`, I see the following:
> >=20
> > ```
> > 16:#define MINSTREL_SCALE  12
> > =E2=80=A6
> > 18:#define MINSTREL_TRUNC(val) ((val) >> MINSTREL_SCALE)
> > ```
> >=20
> > ```
> >=20
> >  401 static unsigned int
> >  402 minstrel_ht_avg_ampdu_len(struct minstrel_ht_sta *mi)
> >  403 {
> >=20
> > =E2=80=A6
> >=20
> >  406     if (mi->avg_ampdu_len)
> >  407         return MINSTREL_TRUNC(mi->avg_ampdu_len);
> >=20
> > ```
> >=20
> > So, likely, `mi->avg_ampdu_len` is non-zero, but it's too small, hence
> > right bitshift makes it zero.
> >=20
> > Should there be some protection against such a situation?
> >=20
> > Felix, could you maybe check this? Looks like you were the last one to
> > overhaul that part of code.
>=20
> Quick hack from me:
>=20
> commit a23d3f77658de968c5bb852ba478402c93958f7f
> Author: Oleksandr Natalenko <oleksandr@natalenko.name>
> Date:   Mon Jun 7 16:45:45 2021 +0200
>=20
>     mac80211: minstrel_ht: force ampdu_len to be > 0
>=20
>     This is a hack.
>=20
>     Work around the following crash:
>=20
>     ```
>     divide error: 0000 [#1] PREEMPT SMP PTI
>     CPU: 2 PID: 683 Comm: mt76-tx phy0 Tainted: G         C      =20
> 5.12.0-pf4 #1 Hardware name: To Be Filled By O.E.M. To Be Filled By
> O.E.M./J3710-ITX, BIOS P1.50 04/16/2018 RIP:
> 0010:minstrel_ht_get_tp_avg+0xb1/0x100 [mac80211]
>     =E2=80=A6
>     Call Trace:
>      minstrel_ht_update_stats+0x1fe/0x1320 [mac80211]
>      minstrel_ht_tx_status+0x67f/0x710 [mac80211]
>      rate_control_tx_status+0x6e/0xb0 [mac80211]
>      ieee80211_tx_status_ext+0x22e/0xb00 [mac80211]
>      ieee80211_tx_status+0x7d/0xa0 [mac80211]
>      mt76_tx_status_unlock+0x83/0xa0 [mt76]
>      mt76x02_send_tx_status+0x1b7/0x400 [mt76x02_lib]
>      mt76x02_tx_worker+0x8f/0xd0 [mt76x02_lib]
>      __mt76_worker_fn+0x78/0xb0 [mt76]
>      kthread+0x183/0x1b0
>      ret_from_fork+0x22/0x30
>     ```
>=20
>     Link:
> https://lore.kernel.org/lkml/20210529165728.bskaozwtmwxnvucx@spock.locald=
om
> ain/ Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> ---
> diff --git a/net/mac80211/rc80211_minstrel_ht.c
> b/net/mac80211/rc80211_minstrel_ht.c index ecad9b10984f..6ad188c4101e
> 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -440,8 +440,13 @@ minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, i=
nt
> group, int rate,
>=20
>  	if (minstrel_ht_is_legacy_group(group))
>  		overhead =3D mi->overhead_legacy;
> -	else
> +	else {
>  		ampdu_len =3D minstrel_ht_avg_ampdu_len(mi);
> +		if (unlikely(!ampdu_len)) {
> +			pr_err_once("minstrel_ht_get_tp_avg: ampdu_len =3D=3D 0!");
> +			ampdu_len =3D 1;
> +		}
> +	}
>=20
>  	nsecs =3D 1000 * overhead / ampdu_len;
>  	nsecs +=3D minstrel_mcs_groups[group].duration[rate] <<

I've also found out that this happens exactly at midnight, IOW, at 00:00:00=
=2E=20
Not every midnight, though.

Does it have something to do with timekeeping? This is strange, I wouldn't=
=20
expect kernel to act like that. Probably, some client sends malformed frame=
?=20
How to find out?

Thanks.

P.S. The hack works, BTW, the system survives, and AP runs as if nothing=20
happened.

=2D-=20
Oleksandr Natalenko (post-factum)


