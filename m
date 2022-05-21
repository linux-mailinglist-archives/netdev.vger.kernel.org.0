Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F1352F971
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 08:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240407AbiEUG6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 02:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbiEUG6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 02:58:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F158AE25A;
        Fri, 20 May 2022 23:58:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42BD2B82DC0;
        Sat, 21 May 2022 06:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A6BC385A5;
        Sat, 21 May 2022 06:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653116314;
        bh=n7ISQ52fmTirYXGkOGDSWt2dlrzq64OUgt9spbHNesA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PoMz3/MOpSTcS3dE1bNNKjir9/ZAwj+MXXp4WIVjPgAB4jOKPV4KEXhcHq0jNdf19
         V95kZ7vQLrcxWlAddOByv4PQheumGOmSTPTk4WRvxU2MZFgJ1N3Jox1jG6LBZpyn3V
         NFPvE+CqKud8G3KTkdIzHoGcrygGq3wZS5IVEA4tIXZd6dc24cHpkXEU8ko+LTnJx9
         WI6n/tgNMDL+0BKCeNwbfDeh0yVlUuwRnxUn2k2nxAdeMk7TJLFHP/JQAu7jmYkkZx
         PC0eqPPbTqECYObQ02Qj3/R/0oTdLqzpZ/My9wpPRpWKsxXP077IX8T9qJjDiTxqbX
         iGFVQekEX+YAQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, toke@toke.dk,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH net-next 2/8] wifi: ath9k: silence array-bounds warning on GCC 12
References: <20220520194320.2356236-1-kuba@kernel.org>
        <20220520194320.2356236-3-kuba@kernel.org>
Date:   Sat, 21 May 2022 09:58:28 +0300
In-Reply-To: <20220520194320.2356236-3-kuba@kernel.org> (Jakub Kicinski's
        message of "Fri, 20 May 2022 12:43:14 -0700")
Message-ID: <87h75j1iej.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ arnd, kees, lkml

Jakub Kicinski <kuba@kernel.org> writes:

> GCC 12 says:
>
> drivers/net/wireless/ath/ath9k/mac.c: In function =E2=80=98ath9k_hw_reset=
txqueue=E2=80=99:
> drivers/net/wireless/ath/ath9k/mac.c:373:22: warning: array subscript
> 32 is above array bounds of =E2=80=98struct ath9k_tx_queue_info[10]=E2=80=
=99
> [-Warray-bounds]
>   373 |         qi =3D &ah->txq[q];
>       |               ~~~~~~~^~~
>
> I don't know where it got the 32 from, relegate the warning to W=3D1+.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: toke@toke.dk
> CC: kvalo@kernel.org
> CC: linux-wireless@vger.kernel.org
> ---
>  drivers/net/wireless/ath/ath9k/Makefile | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wirele=
ss/ath/ath9k/Makefile
> index eff94bcd1f0a..9bdfcee2f448 100644
> --- a/drivers/net/wireless/ath/ath9k/Makefile
> +++ b/drivers/net/wireless/ath/ath9k/Makefile
> @@ -45,6 +45,11 @@ ath9k_hw-y:=3D	\
>  		ar9003_eeprom.o \
>  		ar9003_paprd.o
>=20=20
> +# FIXME: temporarily silence -Warray-bounds on non W=3D1+ builds
> +ifndef KBUILD_EXTRA_WARN
> +CFLAGS_mac.o +=3D -Wno-array-bounds
> +endif

There are now four wireless drivers which need this hack. Wouldn't it be
easier to add -Wno-array-bounds for GCC 12 globally instead of adding
the same hack to multiple drivers?

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
