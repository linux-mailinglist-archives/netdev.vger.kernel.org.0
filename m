Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3599663E81E
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 04:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiLADBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 22:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiLADBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 22:01:23 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475479580E;
        Wed, 30 Nov 2022 19:01:21 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NN13724flzJp2q;
        Thu,  1 Dec 2022 10:57:55 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Dec 2022 11:01:15 +0800
Message-ID: <14e5c329-03c4-e82e-8ae2-97d30d53e4fd@huawei.com>
Date:   Thu, 1 Dec 2022 11:01:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] wifi: brcmfmac: Fix error return code in
 brcmf_sdio_download_firmware()
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
CC:     <aspriel@gmail.com>, <hante.meuleman@broadcom.com>,
        <kvalo@kernel.org>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <arend@broadcom.com>
References: <1669716458-15327-1-git-send-email-wangyufen@huawei.com>
 <CA+8PC_czBYZUsOH7brTh4idjg3ps58PtanqtmTD0mPN3Sp9Xhw@mail.gmail.com>
 <4e61f6e5-94bd-9e29-d12f-d5928f00c8a8@huawei.com>
 <5dd42599-ace7-42cb-8b3c-90704d18fc21@broadcom.com>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <5dd42599-ace7-42cb-8b3c-90704d18fc21@broadcom.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/11/30 19:19, Arend van Spriel 写道:
> On 11/30/2022 3:00 AM, wangyufen wrote:
>>
>>
>> 在 2022/11/30 1:41, Franky Lin 写道:
>>> On Tue, Nov 29, 2022 at 1:47 AM Wang Yufen <wangyufen@huawei.com> wrote:
>>>>
>>>> Fix to return a negative error code -EINVAL instead of 0.
>>>>
>>>> Compile tested only.
>>>>
>>>> Fixes: d380ebc9b6fb ("brcmfmac: rename chip download functions")
>>>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>>>> ---
>>>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
>>>>   1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c 
>>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>> index 465d95d..329ec8ac 100644
>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>> @@ -3414,6 +3414,7 @@ static int brcmf_sdio_download_firmware(struct 
>>>> brcmf_sdio *bus,
>>>>          /* Take arm out of reset */
>>>>          if (!brcmf_chip_set_active(bus->ci, rstvec)) {
>>>>                  brcmf_err("error getting out of ARM core reset\n");
>>>> +               bcmerror = -EINVAL;
>>>
>>> ENODEV seems more appropriate here.
>>
>> However, if brcmf_chip_set_active()  fails in 
>> brcmf_pcie_exit_download_state(), "-EINVAL" is returned.
>> Is it necessary to keep consistent?
> 
> If we can not get the ARM on the chip out of reset things will fail soon 
> enough further down the road. Anyway, the other function calls return 
> -EIO so let's do the same here.
> 

So -EIO is better?  Anyone else have any other opinions? 😄

Thanks,
Wang

> Thanks,
> Arend
