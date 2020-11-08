Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387792AAD36
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 20:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgKHTea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 14:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHTea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 14:34:30 -0500
Received: from smtp.gentoo.org (mail.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC742C0613CF;
        Sun,  8 Nov 2020 11:34:29 -0800 (PST)
Subject: Re: [PATCH] mac80211: fix regression where EAPOL frames were sent in
 plaintext
To:     Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Christian Hesse <list@eworm.de>
References: <20201019160113.350912-1-Mathy.Vanhoef@kuleuven.be>
From:   Thomas Deutschmann <whissi@gentoo.org>
Organization: Gentoo Foundation, Inc
Message-ID: <259a6efa-da48-c946-3008-3c2edaf1a3d0@gentoo.org>
Date:   Sun, 8 Nov 2020 20:34:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201019160113.350912-1-Mathy.Vanhoef@kuleuven.be>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="R5tkUsv0kM4zeXCMDp0T6apX1o2RS4q4h"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R5tkUsv0kM4zeXCMDp0T6apX1o2RS4q4h
Content-Type: multipart/mixed; boundary="GTsbpTkYQpHu27Ysllmf4CVn9N5m5uRUr";
 protected-headers="v1"
From: Thomas Deutschmann <whissi@gentoo.org>
To: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
 Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: Christian Hesse <list@eworm.de>
Message-ID: <259a6efa-da48-c946-3008-3c2edaf1a3d0@gentoo.org>
Subject: Re: [PATCH] mac80211: fix regression where EAPOL frames were sent in
 plaintext
References: <20201019160113.350912-1-Mathy.Vanhoef@kuleuven.be>
In-Reply-To: <20201019160113.350912-1-Mathy.Vanhoef@kuleuven.be>

--GTsbpTkYQpHu27Ysllmf4CVn9N5m5uRUr
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

On 2020-10-19 18:01, Mathy Vanhoef wrote:
> When sending EAPOL frames via NL80211 they are treated as injected
> frames in mac80211. Due to commit 1df2bdba528b ("mac80211: never drop
> injected frames even if normally not allowed") these injected frames
> were not assigned a sta context in the function ieee80211_tx_dequeue,
> causing certain wireless network cards to always send EAPOL frames in
> plaintext. This may cause compatibility issues with some clients or
> APs, which for instance can cause the group key handshake to fail and
> in turn would cause the station to get disconnected.
>=20
> This commit fixes this regression by assigning a sta context in
> ieee80211_tx_dequeue to injected frames as well.
>=20
> Note that sending EAPOL frames in plaintext is not a security issue
> since they contain their own encryption and authentication protection.
>=20
> Fixes: 1df2bdba528b ("mac80211: never drop injected frames even if norm=
ally not allowed")
> Reported-by: Thomas Deutschmann <whissi@gentoo.org>
> Tested-by: Christian Hesse <list@eworm.de>
> Tested-by: Thomas Deutschmann <whissi@gentoo.org>
> Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
> ---
>   net/mac80211/tx.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 8ba10a48d..55b41167a 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -3619,13 +3619,14 @@ struct sk_buff *ieee80211_tx_dequeue(struct iee=
e80211_hw *hw,
>   	tx.skb =3D skb;
>   	tx.sdata =3D vif_to_sdata(info->control.vif);
>  =20
> -	if (txq->sta && !(info->flags & IEEE80211_TX_CTL_INJECTED)) {
> +	if (txq->sta) {
>   		tx.sta =3D container_of(txq->sta, struct sta_info, sta);
>   		/*
>   		 * Drop unicast frames to unauthorised stations unless they are
> -		 * EAPOL frames from the local station.
> +		 * injected frames or EAPOL frames from the local station.
>   		 */
> -		if (unlikely(ieee80211_is_data(hdr->frame_control) &&
> +		if (unlikely(!(info->flags & IEEE80211_TX_CTL_INJECTED) &&
> +			     ieee80211_is_data(hdr->frame_control) &&
>   			     !ieee80211_vif_is_mesh(&tx.sdata->vif) &&
>   			     tx.sdata->vif.type !=3D NL80211_IFTYPE_OCB &&
>   			     !is_multicast_ether_addr(hdr->addr1) &&
>=20

Can we please get this applied to linux-5.10 and linux-5.9?

Is there anything left to do where I can help with?

Thanks!


--=20
Regards,
Thomas Deutschmann / Gentoo Linux Developer
C4DD 695F A713 8F24 2AA1 5638 5849 7EE5 1D5D 74A5


--GTsbpTkYQpHu27Ysllmf4CVn9N5m5uRUr--

--R5tkUsv0kM4zeXCMDp0T6apX1o2RS4q4h
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEExKRzo+LDXJgXHuURObr3Jv2BVkFAl+oSD4FAwAAAAAACgkQRObr3Jv2BVnM
WwgArKT4D/J9+m3E3baILW6z3T1f6RVrrB+jf/chjHs9xqjnvt7jF8zSCsWsIb8c/OQpFbq7wOUY
LkoiPtqSQ5VquGApFG1WUdI5CSkxj9dUfq42YphWQC+ah8F86nS9q3x/KIImUkpRhMK2D9N15alb
pVfJg4gFgm29cd3ArcaKFe5odB8Rb4Os/UnvX7t9bqZaCsD5sQ28wcG1u1EojPzdeFzpwCLvenkV
IBNfqtIGaBWhzGHo9QHPEeDAYYN6t/cABJGcirV7IVtdiOWqh2hGmpUrHVFebG00A1GcrZHq6kHr
V9xcoN0EbItP2fbYnXdmxVS0jeu/G77v8zHPXxpewQ==
=M+nH
-----END PGP SIGNATURE-----

--R5tkUsv0kM4zeXCMDp0T6apX1o2RS4q4h--
