Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2745E5A4F
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiIVEnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiIVEnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:43:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1721893226;
        Wed, 21 Sep 2022 21:43:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A66D660E15;
        Thu, 22 Sep 2022 04:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD3DC433C1;
        Thu, 22 Sep 2022 04:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663821792;
        bh=PhAbgL0g6IiPTeCsm/2ov7dmC59SuI25dD03BZIxxk0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TY3LAUxKuiZf0lCB4i2rxsK8RJZcPtnuHNhubNMG3XhOS4LgwVH4YWlcg8YFqCyBl
         JwtOcFLsnJ8GwbMj597NHiD982jm800vmWyGe8m+BiC5ka248IUxdOZfJ96pxHjrvr
         lbwo3h8ReyH2gvDFbISBfRKu1N/SVhUYJGNxYsiE+eUSwuqLDC50ITYeJep77nnjcQ
         sI3+Czi+qyS2uLNqKnu92Jh3Y+z/Z89TiE5/axdr+Y9GYoJ/COlG8PzpHLTBqUxn0r
         wNjOYynuhrGOXYZMzh7qtV52L75kidJBcPFn2Mrjx1z611d16X+FxWHVs8lRTiTxGf
         3cxYgzsEBwdWQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Syed Rafiuddeen <syed.rafiuddeen@cypress.com>,
        Syed Rafiuddeen <syed.rafiuddeen@infineon.com>,
        Chung-Hsien Hsu <chung-hsien.hsu@infineon.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] brcmfmac: Update SSID of hidden AP while informing its bss to cfg80211 layer
References: <20220722115632.620681-1-alvin@pqrs.dk>
        <20220722115632.620681-7-alvin@pqrs.dk>
Date:   Thu, 22 Sep 2022 07:43:03 +0300
In-Reply-To: <20220722115632.620681-7-alvin@pqrs.dk> ("Alvin
 \=\?utf-8\?Q\?\=C5\=A0ipraga\=22's\?\=
        message of "Fri, 22 Jul 2022 13:56:31 +0200")
Message-ID: <874jx06mug.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alvin =C5=A0ipraga <alvin@pqrs.dk> writes:

> From: Syed Rafiuddeen <syed.rafiuddeen@cypress.com>
>
> cfg80211 layer on DUT STA is disconnecting ongoing connection attempt aft=
er
> receiving association response, because cfg80211 layer does not have valid
> AP bss information. On association response event, brcmfmac communicates
> the AP bss information to cfg80211 layer, but SSID seem to be empty in AP
> bss information, and cfg80211 layer prints kernel warning and then
> disconnects the ongoing connection attempt.
>
> SSID is empty in SSID IE, but 'bi->SSID' contains a valid SSID, so
> updating the SSID for hidden AP while informing its bss information
> to cfg80211 layer.
>
> Signed-off-by: Syed Rafiuddeen <syed.rafiuddeen@infineon.com>

Syed's email address in From and s-o-b doesn't match.

> @@ -3018,6 +3019,12 @@ static s32 brcmf_inform_single_bss(struct brcmf_cf=
g80211_info *cfg,
>  	notify_ielen =3D le32_to_cpu(bi->ie_length);
>  	bss_data.signal =3D (s16)le16_to_cpu(bi->RSSI) * 100;
>=20=20
> +	ssid =3D brcmf_parse_tlvs(notify_ie, notify_ielen, WLAN_EID_SSID);
> +	if (ssid && ssid->data[0] =3D=3D '\0' && ssid->len =3D=3D bi->SSID_len)=
 {
> +		/* Update SSID for hidden AP */
> +		memcpy((u8 *)ssid->data, bi->SSID, bi->SSID_len);
> +	}

memcpy() takes a void pointer so the cast is not needed.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
