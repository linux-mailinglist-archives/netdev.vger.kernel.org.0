Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B164A63EF50
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 12:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiLALUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 06:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiLALTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 06:19:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E50317FA;
        Thu,  1 Dec 2022 03:16:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82BECB81F09;
        Thu,  1 Dec 2022 11:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE20BC433D6;
        Thu,  1 Dec 2022 11:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669893381;
        bh=gjIpFgiHsSCfwp8Iivsv/TFloWDIpl99lTs5icYgtPo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=e6PNRziMC39/JyphXTu1pksXHr+d0VaToDwVTnILg3dnd2jFTmj20kueJbb6iPZYQ
         pnTaxYJHdhTEUQfRzkpsG3fpz21Ltzjjy+8dVPta72u+LDK7T+mt6ZMmITIWjyDhfJ
         HjS2ufesBaaBUPpnHvqhgGBmFR8xePh0FYNhUO8Eui6i33MYMmQVCcy1DbrMEs7MgH
         grFSIZVOQHPXHLnONWYr/nijsyyqD8YeN2koixQC6EnYxSz8o5A6vIByFxqeUG1939
         RKN0d/os7cto8EcsdSkjpzOK3U3ewy5qdp9rQmgb1DK2JJeOnGsQ3o75Xv3hVQ0uMb
         yFQ+kp/gK9LGA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     wangyufen <wangyufen@huawei.com>,
        Franky Lin <franky.lin@broadcom.com>, <aspriel@gmail.com>,
        <hante.meuleman@broadcom.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <arend@broadcom.com>
Subject: Re: [PATCH] wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()
References: <1669716458-15327-1-git-send-email-wangyufen@huawei.com>
        <CA+8PC_czBYZUsOH7brTh4idjg3ps58PtanqtmTD0mPN3Sp9Xhw@mail.gmail.com>
        <4e61f6e5-94bd-9e29-d12f-d5928f00c8a8@huawei.com>
        <5dd42599-ace7-42cb-8b3c-90704d18fc21@broadcom.com>
        <14e5c329-03c4-e82e-8ae2-97d30d53e4fd@huawei.com>
        <184cc562ed8.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Date:   Thu, 01 Dec 2022 13:16:17 +0200
In-Reply-To: <184cc562ed8.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
        (Arend Van Spriel's message of "Thu, 01 Dec 2022 07:18:32 +0100")
Message-ID: <87bkon4bni.fsf@kernel.org>
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

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On December 1, 2022 4:01:39 AM wangyufen <wangyufen@huawei.com> wrote:
>
>> =E5=9C=A8 2022/11/30 19:19, Arend van Spriel =E5=86=99=E9=81=93:
>>> On 11/30/2022 3:00 AM, wangyufen wrote:
>>>>
>>>>
>>>> =E5=9C=A8 2022/11/30 1:41, Franky Lin =E5=86=99=E9=81=93:
>>>>> On Tue, Nov 29, 2022 at 1:47 AM Wang Yufen <wangyufen@huawei.com> wro=
te:
>>>>>>
>>>>>> Fix to return a negative error code -EINVAL instead of 0.
>>>>>>
>>>>>> Compile tested only.
>>>>>>
>>>>>> Fixes: d380ebc9b6fb ("brcmfmac: rename chip download functions")
>>>>>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>>>>>> ---
>>>>>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
>>>>>>  1 file changed, 1 insertion(+)
>>>>>>
>>>>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>>>> index 465d95d..329ec8ac 100644
>>>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>>>> @@ -3414,6 +3414,7 @@ static int brcmf_sdio_download_firmware(struct
>>>>>> brcmf_sdio *bus,
>>>>>>         /* Take arm out of reset */
>>>>>>         if (!brcmf_chip_set_active(bus->ci, rstvec)) {
>>>>>>                 brcmf_err("error getting out of ARM core reset\n");
>>>>>> +               bcmerror =3D -EINVAL;
>>>>>
>>>>> ENODEV seems more appropriate here.
>>>>
>>>> However, if brcmf_chip_set_active()  fails in
>>>> brcmf_pcie_exit_download_state(), "-EINVAL" is returned.
>>>> Is it necessary to keep consistent?
>>>
>>> If we can not get the ARM on the chip out of reset things will fail soon
>>> enough further down the road. Anyway, the other function calls return
>>> -EIO so let's do the same here.
>>
>> So -EIO is better?  Anyone else have any other opinions? =F0=9F=98=84
>
> Obviously it is no better than -EINVAL when you look at the behavior.
> It is just a feeble attempt to be a little bit more consistent. Feel
> free to change the return value for brcmf_pcie_exit_download_state()
> as well.

Weirdly Arend's last comment is not visible in patchwork:

https://patchwork.kernel.org/project/linux-wireless/patch/1669716458-15327-=
1-git-send-email-wangyufen@huawei.com/

His last email is visible, but the last paragraph is not shown. Some
strange hiccup somewhere I guess, just wanted to mention it in case we
see more of them.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
