Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F805E86DD
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 03:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiIXBAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 21:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiIXBAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 21:00:17 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B9D6CF4A;
        Fri, 23 Sep 2022 18:00:15 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MZ9Yt5jrKzlXJD;
        Sat, 24 Sep 2022 08:56:02 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 09:00:12 +0800
Message-ID: <b5e39818-2961-ba3d-8552-f618c19f8fe6@huawei.com>
Date:   Sat, 24 Sep 2022 09:00:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH -next] wifi: brcmfmac: pcie: add missing
 pci_disable_device() in brcmf_pcie_get_resource()
Content-Language: en-US
To:     Franky Lin <franky.lin@broadcom.com>
CC:     <aspriel@gmail.com>, <hante.meuleman@broadcom.com>,
        <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <marcan@marcan.st>,
        <linus.walleij@linaro.org>, <rmk+kernel@armlinux.org.uk>,
        <soontak.lee@cypress.com>, <linux-wireless@vger.kernel.org>,
        <SHA-cyfmac-dev-list@infineon.com>,
        <brcm80211-dev-list.pdl@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220923093806.3108119-1-ruanjinjie@huawei.com>
 <CA+8PC_eCwv321DxoCMOrWNLw7NWkT9F0sD-=8GzygEXPJHFWWA@mail.gmail.com>
From:   Ruan Jinjie <ruanjinjie@huawei.com>
In-Reply-To: <CA+8PC_eCwv321DxoCMOrWNLw7NWkT9F0sD-=8GzygEXPJHFWWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/9/24 0:50, Franky Lin wrote:
> On Fri, Sep 23, 2022 at 2:42 AM ruanjinjie <ruanjinjie@huawei.com> wrote:
>>
>> Add missing pci_disable_device() if brcmf_pcie_get_resource() fails.
> 
> Did you encounter any issue because of the absensent
> pci_disable_device? A bit more context will be very helpful.
> 

We use static analysis via coccinelle to find the above issue. The
command we use is below:

spatch -I include -timeout 60 -very_quiet -sp_file
pci_disable_device_missing.cocci
drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c

>>
>> Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
>> ---
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> index f98641bb1528..25fa69793d86 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> @@ -1725,7 +1725,8 @@ static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
>>         if ((bar1_size == 0) || (bar1_addr == 0)) {
>>                 brcmf_err(bus, "BAR1 Not enabled, device size=%ld, addr=%#016llx\n",
>>                           bar1_size, (unsigned long long)bar1_addr);
>> -               return -EINVAL;
>> +               err = -EINVAL;
>> +               goto err_disable;
>>         }
>>
>>         devinfo->regs = ioremap(bar0_addr, BRCMF_PCIE_REG_MAP_SIZE);
>> @@ -1734,7 +1735,8 @@ static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
>>         if (!devinfo->regs || !devinfo->tcm) {
>>                 brcmf_err(bus, "ioremap() failed (%p,%p)\n", devinfo->regs,
>>                           devinfo->tcm);
>> -               return -EINVAL;
>> +               err = -EINVAL;
>> +               goto err_disable;
>>         }
>>         brcmf_dbg(PCIE, "Phys addr : reg space = %p base addr %#016llx\n",
>>                   devinfo->regs, (unsigned long long)bar0_addr);
>> @@ -1743,6 +1745,9 @@ static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
>>                   (unsigned int)bar1_size);
>>
>>         return 0;
>> +err_disable:
>> +       pci_disable_device(pdev);
> 
> Isn't brcmf_pcie_release_resource() a better choice which also unmap
> the io if any was mapped?
> 
> Regards,
> - Franky
> 
>> +       return err;
>>  }
>>
>>
>> --
>> 2.25.1
>>
