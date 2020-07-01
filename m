Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCA7210F9D
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731948AbgGAPrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:47:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:44382 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731763AbgGAPrC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 11:47:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D9634AEDE;
        Wed,  1 Jul 2020 15:47:00 +0000 (UTC)
Subject: Re: [PATCH] brcmfmac: expose firmware config files through modinfo
To:     Hans de Goede <hdegoede@redhat.com>, matthias.bgg@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Double Lo <double.lo@cypress.com>,
        Frank Kao <frank.kao@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        netdev@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Saravanan Shanmugham <saravanan.shanmugham@cypress.com>,
        brcm80211-dev-list@cypress.com, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Soeren Moch <smoch@web.de>
References: <20200701153123.25602-1-matthias.bgg@kernel.org>
 <338e3cff-dfa0-c588-cf53-a160d75af2ee@redhat.com>
From:   Matthias Brugger <mbrugger@suse.com>
Message-ID: <1013c7e6-f1fb-af0c-fe59-4d6cd612f959@suse.com>
Date:   Wed, 1 Jul 2020 17:46:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <338e3cff-dfa0-c588-cf53-a160d75af2ee@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hans,

On 01/07/2020 17:38, Hans de Goede wrote:
> Hi,
> 
> On 7/1/20 5:31 PM, matthias.bgg@kernel.org wrote:
>> From: Matthias Brugger <mbrugger@suse.com>
>>
>> Apart from a firmware binary the chip needs a config file used by the
>> FW. Add the config files to modinfo so that they can be read by
>> userspace.
> 
> The configfile firmware filename is dynamically generated, just adding the list
> of all currently shipped ones is not really helpful and this is going to get
> out of sync with what we actually have in linux-firmware.

I'm aware of this, and I agree.

> 
> I must honestly say that I'm not a fan of this, I guess you are trying to
> get some tool which builds a minimal image, such as an initrd generator
> to add these files to the image ?
> 

Yes exactly.

> I do not immediately have a better idea, but IMHO the solution
> this patch proposes is not a good one, so nack from me for this change.
> 

Another path we could go is add a wildcard string instead, for example:
MODULE_FIRMWARE("brcm/brcmfmac43455-sdio.*.txt");

AFAIK there is no driver in the kernel that does this. I checked with our dracut
developer and right now dracut can't cope with that. But he will try to
implement that in the future.

So my idea was to maintain that list for now and switch to the wildcard approach
once we have dracut support that.

Regards,
Matthias

> Regards,
> 
> Hans
> 
> 
> 
>>
>> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
>>
>> ---
>>
>>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.c  | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> index 310d8075f5d7..ba18df6d8d94 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> @@ -624,6 +624,22 @@ BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");
>>   BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
>>   BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
>>   +/* firmware config files */
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>> "brcm/brcmfmac4330-sdio.Prowise-PT301.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>> "brcm/brcmfmac43340-sdio.meegopad-t08.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>> "brcm/brcmfmac43340-sdio.pov-tab-p1006w-data.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>> "brcm/brcmfmac43362-sdio.cubietech,cubietruck.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>> "brcm/brcmfmac43430a0-sdio.jumper-ezpad-mini3.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430a0-sdio.ONDA-V80
>> PLUS.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.AP6212.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>> "brcm/brcmfmac43430-sdio.Hampoo-D2D3_Vi8A1.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.MUR1DX.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>> "brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43455-sdio.MINIX-NEO
>> Z83-4.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>> "brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>> "brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>> "brcm/brcmfmac4356-pcie.gpd-win-pocket.txt");
>> +
>>   static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
>>       BRCMF_FW_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),
>>       BRCMF_FW_ENTRY(BRCM_CC_43241_CHIP_ID, 0x0000001F, 43241B0),
>>
> 
