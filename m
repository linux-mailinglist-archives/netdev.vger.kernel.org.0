Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DE15E5649
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 00:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiIUWet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 18:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiIUWer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 18:34:47 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5942A96F
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 15:34:45 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id BE1EC504D44;
        Thu, 22 Sep 2022 01:31:04 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru BE1EC504D44
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1663799466; bh=ju/HCv3l0569wyceIb2DgQQcFzXHNG6w7bmCZC/X1PE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=zjZ4Rw3TXTLHMHqPBUCrIdqHDuYXNbbpVcaZCIxtF3QvA+JIUG5pHbiwdnY9nZJh4
         Uy5pISELFBZmE6QaLqrt9CNrTpTl8BogBj1Wx1eCixW7knGKWbm5MYyH/Mn8vR7Dt9
         Yw/3EqEdDgXID1wWfQuXlMG/e9wvYjOzg8si1BOI=
Message-ID: <bf5936da-e04d-37e4-00b2-81e9c6fa4170@novek.ru>
Date:   Wed, 21 Sep 2022 23:34:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] bnxt_en: replace reset with config timestamps
Content-Language: en-US
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
References: <20220919183907.6689-1-vfedorenko@novek.ru>
 <CACKFLikj17yP3KZfMCiq3pQk9DZrBCYjA7AFuqjTr72H=_Z-TQ@mail.gmail.com>
 <CACKFLikxsS_arFNuqA8XkUBT09t2g0Qb0-9Z5jVQ5=W3KcV-_w@mail.gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <CACKFLikxsS_arFNuqA8XkUBT09t2g0Qb0-9Z5jVQ5=W3KcV-_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.09.2022 22:33, Michael Chan wrote:
> On Tue, Sep 20, 2022 at 7:36 AM Michael Chan <michael.chan@broadcom.com> wrote:
>>
>> On Mon, Sep 19, 2022 at 11:39 AM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>>>
>>> Any change to the hardware timestamps configuration triggers nic restart,
>>> which breaks transmition and reception of network packets for a while.
>>> But there is no need to fully restart the device because while configuring
>>> hardware timestamps. The code for changing configuration runs after all
>>> of the initialisation, when the NIC is actually up and running. This patch
>>> changes the code that ioctl will only update configuration registers and
>>> will not trigger carrier status change. Tested on BCM57504.
>>>
>>> Fixes: 11862689e8f1 ("bnxt_en: Configure ptp filters during bnxt open")
>>> Cc: Richard Cochran <richardcochran@gmail.com>
>>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
>>> ---
>>>   drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 6 ++----
>>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
>>> index 8e316367f6ce..36e9148468b5 100644
>>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
>>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
>>> @@ -505,10 +505,8 @@ static int bnxt_hwrm_ptp_cfg(struct bnxt *bp)
>>>          ptp->tstamp_filters = flags;
>>>
>>>          if (netif_running(bp->dev)) {
>>> -               rc = bnxt_close_nic(bp, false, false);
>>> -               if (!rc)
>>> -                       rc = bnxt_open_nic(bp, false, false);
>>> -               if (!rc && !ptp->tstamp_filters)
>>> +               bnxt_ptp_cfg_tstamp_filters(bp);
>>> +               if (!ptp->tstamp_filters)
>>
>> Closing and opening is the correct sequence, but this might work too.
>> Please give us a day to review this.  Thanks.
> 
> We have internally discussed this issue in great detail.  If the user
> is changing the ALL_RX setting (enabling it or disabling it), just
> calling bnxt_ptp_cfg_tstamp_filters() is not sufficient.  The reason
> is that there is no synchronization after we send the new setting to
> the FW.  We don't know when valid timestamps will start showing up in
> the RX completion ring after turning on ALL_RX.  That's why we need to
> close and open.  After open, all RX packets are guaranteed to have
> valid timestamps.
> 
> So what we can do is to detect any changes to ALL_RX setting.  If
> ALL_RX is not changing, we can just do what this patch is doing.  If
> ALL_RX is changing, we can do something less intrusive than
> close/open.  We can just shutdown RX and restart RX.  This way we
> don't have to toggle carrier and cause a bigger disruption.
> 
Thanks for the review. I got your point regarding timestamps for all RX packets,
but for now I care about the case when ALL_RX is not supported. I can send a v2
with the check for this condition while you are working on the improvements for
all cases. Will it be to review and commit such patch?

Thanks.
