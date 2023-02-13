Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB029694E16
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjBMRdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjBMRdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:33:12 -0500
Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425CD1CACF;
        Mon, 13 Feb 2023 09:33:00 -0800 (PST)
Date:   Mon, 13 Feb 2023 17:32:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemb.ch;
        s=protonmail; t=1676309577; x=1676568777;
        bh=IAvPwW5JFdNEA6N93fJnWUTElrXDvQHH5qEMqEhQ+gc=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=QBE40F4hyiMCm7q4ItAr2ynOs/uLyGeUPilBgdqmgVvpFyvJadYqBDW6l15VVAY9q
         efzj+XoG1CYMLyPRrch3p3KRpfQpxi/16315dnmNkLIUGrxDTGcCKNMahjNrFk32JR
         FdAr0Qb8Dm0oDMKFvmmSq7A7hDo5md3mHHgAtX17FXxkfPGlT+JdpHmce5nvHiQJWv
         c8JqBYF6G3F1ZKFsmfTEGvsJLY2sDJuxQYoVamLJtduf5+TrJLPP5zQcyK1fLVG9O6
         zc0bsT9B0cqkC17taARQF2Ez0DJ3goEPql6Lif//DeV8gMZKj0p6BPWVkbvP+8IKn+
         gUTunu8gf4jTw==
To:     Johannes Berg <johannes@sipsolutions.net>
From:   Marc Bornand <dev.mbornand@systemb.ch>
Cc:     linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Yohan Prod'homme <kernel@zoddo.fr>, stable@vger.kernel.org
Subject: Re: [PATCH v2] Set ssid when authenticating
Message-ID: <NTBtzDurDf0W90JuEPzaHfxCYkWzyZ5jjPwcy6LpqebS6S1NekVcfBU3sNWczfvhHEJGOSyzQrb40UfSIK8AFZpd71MExKldK7EFnMkkdUk=@systemb.ch>
In-Reply-To: <5a1d1244c8d3e20408732858442f264d26cc2768.camel@sipsolutions.net>
References: <20230213105436.595245-1-dev.mbornand@systemb.ch> <5a1d1244c8d3e20408732858442f264d26cc2768.camel@sipsolutions.net>
Feedback-ID: 65519157:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, February 13th, 2023 at 12:01, Johannes Berg <johannes@sipsolutio=
ns.net> wrote:
>=20
>=20
> On Mon, 2023-02-13 at 10:55 +0000, Marc Bornand wrote:
>=20
> > changes since v1:
> > - add some informations
> > - test it on wireless-2023-01-18 tag
> > - no real code change
> >=20
> > When a connexion was established without going through
> > NL80211_CMD_CONNECT, the ssid was never set in the wireless_dev struct.
> > Now we set it during when an NL80211_CMD_AUTHENTICATE is issued.
>=20
>=20
> This is incorrect, doing an authentication doesn't require doing an
> association afterwards, and doesn't necessarily imply any state change
> in the kernel.

So is it intended behavior that the ssid in wireless_dev is not set
or is there a place were this state change should happen?

>=20
> > alternatives:
> > 1. Do the same but during association and not authentication.
>=20
>=20
> Which should probably be done after successful authentication, even in
> the CONNECT command case, which currently does it in cfg80211_connect()
> but I guess that should move to __cfg80211_connect_result().

Is there an existing way to get the ssid in __cfg80211_connect_result()?


>=20
> > 2. use ieee80211_bss_get_elem in nl80211_send_iface, this would report
> > the right ssid to userspace, but this would not fix the root cause,
> > this alos wa the behavior prior to 7b0a0e3c3a882 when the bug was
> > introduced.
>=20
>=20
> That would be OK too but the reason I changed it there (missing the fact
> that it wasn't set) is that we have multiple BSSes with MLO. So it's
> hard to get one to do this with.
>=20
> johannes

Just a side question do the BSSes all have the same SSID?

Marc
