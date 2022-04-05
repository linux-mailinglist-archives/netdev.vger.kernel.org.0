Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4224F44BB
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379480AbiDEUE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456964AbiDEQCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:02:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAC8E7F75;
        Tue,  5 Apr 2022 08:25:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 859BBB81E30;
        Tue,  5 Apr 2022 15:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1782C385A0;
        Tue,  5 Apr 2022 15:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649172337;
        bh=+xFbJqvwMJbQSj9nFNnlG1Arjg38F6OzcmwY3dTsFQ4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=uIuEDxP6ZeCDhTVHagvUEbxwEJq2viGhA/Lc3oGsoongfmoEMblsuITW0rw1MIaza
         Xd8biZfxObEYo1U+FJpjsLVAtadGW4aMg7NTYPwedhQGeIyAQFZvKbRdxwPcpznhWl
         DLyxV7ipXnY9exHsnUktrYNcD/ZSyekx69EIZ1DT8fayxtwkcy+0XfFf8eyLOYrOKH
         iw+JK+P5f6vFct8RAkzV5ss9bLnhT8mGEqqHV3hkIlFTawW/z5sEIUllDIsoBjwQPz
         ol7+B7F1SPT9HffpPgncyq5M1GqVk+3NUjsaFlNjC5wSb9OsiUIMFmBlLTyaAPx8DG
         2Scic8xo0aZnw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/11] brcmfmac: sdio: Fix undefined behavior due to shift overflowing the constant
References: <20220405151517.29753-1-bp@alien8.de>
        <20220405151517.29753-7-bp@alien8.de>
Date:   Tue, 05 Apr 2022 18:25:30 +0300
In-Reply-To: <20220405151517.29753-7-bp@alien8.de> (Borislav Petkov's message
        of "Tue, 5 Apr 2022 17:15:12 +0200")
Message-ID: <87y20jr1qt.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ linux-wireless

Borislav Petkov <bp@alien8.de> writes:

> From: Borislav Petkov <bp@suse.de>
>
> Fix:
>
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c: In function =
=E2=80=98brcmf_sdio_drivestrengthinit=E2=80=99:
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:3798:2: error: =
case label does not reduce to an integer constant
>     case SDIOD_DRVSTR_KEY(BRCM_CC_43143_CHIP_ID, 17):
>     ^~~~
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:3809:2: error: =
case label does not reduce to an integer constant
>     case SDIOD_DRVSTR_KEY(BRCM_CC_43362_CHIP_ID, 13):
>     ^~~~
>
> See https://lore.kernel.org/r/YkwQ6%2BtIH8GQpuct@zn.tnic for the gory
> details as to why it triggers with older gccs only.
>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Arend van Spriel <aspriel@gmail.com>
> Cc: Franky Lin <franky.lin@broadcom.com>
> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: brcm80211-dev-list.pdl@broadcom.com
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/dr=
ivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index ba3c159111d3..d78ccc223709 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -557,7 +557,7 @@ enum brcmf_sdio_frmtype {
>  	BRCMF_SDIO_FT_SUB,
>  };
>=20=20
> -#define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
> +#define SDIOD_DRVSTR_KEY(chip, pmu)     (((unsigned int)(chip) << 16) | =
(pmu))

Via which tree is this going? I assume not the wireless tree, so:

Acked-by: Kalle Valo <kvalo@kernel.org>

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
