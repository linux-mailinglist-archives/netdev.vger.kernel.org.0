Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D2150766D
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 19:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350098AbiDSRZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 13:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348515AbiDSRZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 13:25:09 -0400
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344243C4B3;
        Tue, 19 Apr 2022 10:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1650388939; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V5MZ44J/2p8fy6DuvcxG86awKyPycaxt+fsG7bZhs1M=;
        b=NEBwuEgxhM19apjy6kKt9GrTDsZoBBGDWU2ZgYgPer3n7SvOqsFJ+DUsQ1pIgB4+F/vk9H
        rOGiYyfKvkzS7g0Rp9uvovjoBpTIvxp+4Xo7qjs+6+DZK09qsExxcwTLRoRDdzu7z97trg
        EYYwEDCxzmZcauHNO2JYncVeYrydSD8=
Date:   Tue, 19 Apr 2022 18:22:09 +0100
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH] brcmfmac: Remove #ifdef guards for PM related functions
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <X8KLAR.4CU0LCMZIMJH@crapouillou.net>
In-Reply-To: <afb9ea60-7f93-a646-da82-4f408051c748@broadcom.com>
References: <20220415200322.7511-1-paul@crapouillou.net>
        <afb9ea60-7f93-a646-da82-4f408051c748@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arend,

Le lun., avril 18 2022 at 09:09:46 +0200, Arend van Spriel=20
<arend.vanspriel@broadcom.com> a =E9crit :
> On 4/15/2022 10:03 PM, Paul Cercueil wrote:
>> Use the new DEFINE_SIMPLE_DEV_PM_OPS() and pm_sleep_ptr() macros to
>> handle the .suspend/.resume callbacks.
>>=20
>> These macros allow the suspend and resume functions to be=20
>> automatically
>> dropped by the compiler when CONFIG_SUSPEND is disabled, without=20
>> having
>> to use #ifdef guards. The advantage is then that these functions are=20
>> not
>> conditionally compiled.
>=20
> The advantage stated here may not be obvious to everyone and that is=20
> because it only scratches the surface. The code is always compiled=20
> independent from the Kconfig options used and because of that the=20
> real advantage is that build regressions are easier to catch.

Exactly. I will improve the commit message to make this a bit more=20
explicit.

>> Some other functions not directly called by the .suspend/.resume
>> callbacks, but still related to PM were also taken outside #ifdef
>> guards.
>=20
> a few comments on this inline...
>=20
>> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>> ---
>>   .../broadcom/brcm80211/brcmfmac/bcmsdh.c      | 44=20
>> +++++++------------
>>   .../broadcom/brcm80211/brcmfmac/sdio.c        |  5 +--
>>   .../broadcom/brcm80211/brcmfmac/sdio.h        | 16 -------
>>   3 files changed, 19 insertions(+), 46 deletions(-)
>>=20
>> diff --git=20
>> a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c=20
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
>> index ac02244a6fdf..a8cf5a570101 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
>=20
> [...]
>=20
>> @@ -873,7 +865,8 @@ int brcmf_sdiod_remove(struct brcmf_sdio_dev=20
>> *sdiodev)
>>   		sdiodev->bus =3D NULL;
>>   	}
>>   =7F-	brcmf_sdiod_freezer_detach(sdiodev);
>> +	if (IS_ENABLED(CONFIG_PM_SLEEP))
>> +		brcmf_sdiod_freezer_detach(sdiodev);
>=20
> Please move the if statement inside the function to keep the code=20
> flow in the calling function the same as before.
>=20
>>   =7F  	/* Disable Function 2 */
>>   	sdio_claim_host(sdiodev->func2);
>> @@ -949,9 +942,11 @@ int brcmf_sdiod_probe(struct brcmf_sdio_dev=20
>> *sdiodev)
>>   		goto out;
>>   	}
>>   =7F-	ret =3D brcmf_sdiod_freezer_attach(sdiodev);
>> -	if (ret)
>> -		goto out;
>> +	if (IS_ENABLED(CONFIG_PM_SLEEP)) {
>> +		ret =3D brcmf_sdiod_freezer_attach(sdiodev);
>> +		if (ret)
>> +			goto out;
>> +	}
>=20
> Dito. Move the if statement inside the function.

Sure.

Cheers,
-Paul

>=20
>>   =7F  	/* try to attach to the target device */
>>   	sdiodev->bus =3D brcmf_sdio_probe(sdiodev);


