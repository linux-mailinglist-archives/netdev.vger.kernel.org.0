Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA8F3B5C45
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 12:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbhF1KOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 06:14:36 -0400
Received: from saphodev.broadcom.com ([192.19.11.229]:35520 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232520AbhF1KO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 06:14:29 -0400
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 365027DBA;
        Mon, 28 Jun 2021 03:12:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 365027DBA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1624875123;
        bh=7GV6KFu0g0aVtH9w1qkWYhk+UZVnJoVDXbi4mnUgM8A=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=a0t9svh8UgV3kAvIFMZjZNffcxOes+3AdcHzR64lGDUt3nqfZ6PvQg132ULT7WKMI
         pEiivpVU0xzcyHds+hTrtVSQGclFkprkY5G6EfQRCzjZGP39BV/vF+3Dacas1d2lwz
         6/3Su9Qs1DFX/BXjE9cs55UXff96WHRaSJXOh3OY=
Received: from [10.176.68.80] (39y1yf2.dhcp.broadcom.net [10.176.68.80])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id 857B71874BE;
        Mon, 28 Jun 2021 03:11:59 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: use separate firmware for 43430 revision 2
To:     Kalle Valo <kvalo@codeaurora.org>,
        Mikhail Rudenko <mike.rudenko@gmail.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Double Lo <double.lo@cypress.com>,
        Remi Depommier <rde@setrix.com>,
        Amar Shankar <amsr@cypress.com>,
        Saravanan Shanmugham <saravanan.shanmugham@cypress.com>,
        Frank Kao <frank.kao@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210509233010.2477973-1-mike.rudenko@gmail.com>
 <d1bac6c3-aa52-5d76-1f2a-4af9edef71c5@broadcom.com>
 <87a6oxpsn8.fsf@gmail.com> <87o8bvgqt8.fsf@tynnyri.adurom.net>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <bb4eece6-e164-7dc2-bd9a-33fe0714d7a7@broadcom.com>
Date:   Mon, 28 Jun 2021 12:11:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87o8bvgqt8.fsf@tynnyri.adurom.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/2021 6:39 PM, Kalle Valo wrote:
> Mikhail Rudenko <mike.rudenko@gmail.com> writes:
> 
>> On 2021-05-10 at 11:06 MSK, Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
>>> On 5/10/2021 1:30 AM, Mikhail Rudenko wrote:
>>>> A separate firmware is needed for Broadcom 43430 revision 2.  This
>>>> chip can be found in e.g. certain revisions of Ampak AP6212 wireless
>>>> IC. Original firmware file from IC vendor is named
>>>> 'fw_bcm43436b0.bin', but brcmfmac and also btbcm drivers report chip
>>>
>>> That is bad naming. There already is a 43436 USB device.
>>>
>>>> id 43430, so requested firmware file name is
>>>> 'brcmfmac43430b0-sdio.bin' in line with other 43430 revisions.
>>>
>>> As always there is the question about who will be publishing this
>>> particular firmware file to linux-firmware.
>>
>> The above mentioned file can be easily found by web search. Also, the
>> corresponding patch for the bluetooth part has just been accepted
>> [1]. Is it strictly necessary to have firmware file in linux-firmware in
>> order to have this patch accepted?
> 
> This patch is a bit in the gray area. We have a rule that firmware
> images should be in linux-firmware, but as the vendor won't submit one
> and I assume the license doesn't approve the community submit it either,
> there is not really any solution for the firmware problem.

At the moment I am not sure which company/division is shipping the 43430 
rev 2 or 43436. Having it in linux-firmware is still preferred.

> On the other hand some community members have access to the firmware
> somehow so this patch is useful to the community, and I think taking an
> exception to the rule in this case is justified. So I am inclined
> towards applying the patch.

As an end-user community members using the device are allowed to use the 
firmware to run on that device. So I tend to agree with you.

> Thoughts? I also have another similar patch in the queue:
> 
> https://patchwork.kernel.org/project/linux-wireless/patch/20210307113550.7720-1-konrad.dybcio@somainline.org/

I will review both and comment/ack them.

Regards,
Arend
