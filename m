Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED94D467DD4
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 20:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353309AbhLCTOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 14:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344093AbhLCTOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 14:14:06 -0500
X-Greylist: delayed 476 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Dec 2021 11:10:41 PST
Received: from gimli.kloenk.dev (gimli.kloenk.dev [IPv6:2a0f:4ac0:0:1::cb2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938B2C061751;
        Fri,  3 Dec 2021 11:10:41 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.dev; s=mail;
        t=1638558160; bh=PJHqZmjT3PnRyKxLBEa+PZQKrzNlbhOqvNAuE9mhDOs=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To;
        b=sOLaR4R9vIPwFEJjSjtLPLGE25SIm7tqOMgaCmB5kmfT2OQ1gWqqgwEsrHjMmq8+1
         bXt9cR2IsJW2958D4HkPWNhazRQF+TZlQ+fByCzP0QSC7oUjGGHfJzW5PJQVfC3hFM
         /UnHs9ApwCgX1ACoQED5yqWoZ4cHHnC+uuTVp4dk=
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH] nl80211: use correct enum type in reg_reload_regdb
From:   Finn Behrens <me@kloenk.dev>
In-Reply-To: <20211203185700.756121-1-arnd@kernel.org>
Date:   Fri, 3 Dec 2021 20:02:38 +0100
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Sriram R <srirrama@codeaurora.org>,
        Qiheng Lin <linqiheng@huawei.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E95BFD18-CB51-4CA5-A6A8-370444F9E714@kloenk.dev>
References: <20211203185700.756121-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 3. Dec 2021, at 19:56, Arnd Bergmann <arnd@kernel.org> wrote:
>=20
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> NL80211_USER_REG_HINT_USER is not something that can be
> assigned to an 'enum nl80211_reg_initiator', as pointed out
> by gcc.
>=20
> net/wireless/reg.c: In function 'reg_reload_regdb':
> net/wireless/reg.c:1137:28: error: implicit conversion from 'enum =
nl80211_user_reg_hint_type' to 'enum nl80211_reg_initiator' =
[-Werror=3Denum-conversion]
>=20
> I don't know what was intended here, most likely it was either
> NL80211_REGDOM_SET_BY_CORE (same numeric value) or
> NL80211_REGDOM_SET_BY_USER (most similar name), so I pick the former
> here, leaving the behavior unchanged while avoiding the warning.
>=20
> Fixes: 1eda919126b4 ("nl80211: reset regdom when reloading regdb")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Thanks,
I did miss it somehow, but after Intels robot mail about it, I did write =
a proper patch, as this is a different value as I wanted for the =
original proposed patch. But It works better this way.
See =
https://lore.kernel.org/linux-wireless/YadvTolO8rQcNCd%2F@gimli.kloenk.dev=
/

Cheers,
Finn

> net/wireless/reg.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 61f1bf1bc4a7..edb2081f75e8 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1134,7 +1134,7 @@ int reg_reload_regdb(void)
> 	request->wiphy_idx =3D WIPHY_IDX_INVALID;
> 	request->alpha2[0] =3D current_regdomain->alpha2[0];
> 	request->alpha2[1] =3D current_regdomain->alpha2[1];
> -	request->initiator =3D NL80211_USER_REG_HINT_USER;
> +	request->initiator =3D NL80211_REGDOM_SET_BY_CORE;
> 	request->user_reg_hint_type =3D NL80211_USER_REG_HINT_USER;
> 	request->reload =3D true;
>=20
> --=20
> 2.29.2
>=20

