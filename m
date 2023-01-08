Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7791166145B
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 10:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbjAHJot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 04:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjAHJoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 04:44:34 -0500
X-Greylist: delayed 903 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 08 Jan 2023 01:44:33 PST
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A94E167FA;
        Sun,  8 Jan 2023 01:44:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1673170159; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ApJxBsFagfLBZ6g2WdlZTDoPz3csRVAiiOmHpWyB6Hl1glwhII2HhkoqfrLhN/l/xglnyOR3128FJ1bryu8xvASJbs7wqgB9e/hH1SS5ncFBVLoNXIDyfz1cMJrn+NaPjWGcCJ932NCsOdqSNKIrKXoQNd9lye/Jgote+TOGPBM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1673170159; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=5s6CMT1pjxwEQCq3cglEI3dDGlHe9K+JZV8PKzcZTY4=; 
        b=ERvBZQWbVwPjE0ztx9Jo5rI6D5iKxa2Ij/oRj516WmgP1Du1pvmfEfKbNQIqriySJk3Le7Ccd/ZwZ7Yq5iUMEGDkPPdFCMeuecTf7Llte3mFJiHKW4C8IVLGcu19xFKMQvvcE01utZG8gKiRQPCZe9p0ZhC9SJvl9aaF5imEmKM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=zzy040330.moe;
        spf=pass  smtp.mailfrom=JunASAKA@zzy040330.moe;
        dmarc=pass header.from=<JunASAKA@zzy040330.moe>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1673170159;
        s=zmail; d=zzy040330.moe; i=JunASAKA@zzy040330.moe;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=5s6CMT1pjxwEQCq3cglEI3dDGlHe9K+JZV8PKzcZTY4=;
        b=C1vCVKNcdlY0H52Hwttp0bZ6KbGqBVtuMAu29qZFxVG4xqDKxb/HtfcGKAxPXtnF
        HLb0lhTDFXz49NIzbSjccUmA5+D3Uvm2KKzJFYyhL//VoPFJadgknizutqOCrF88xDL
        GgVhb3aKgze9PZrMGJXsuScPClP6/JF6cJu3E5p4=
Received: from [10.8.0.2] (convallaria.eternalshinra.com [103.201.131.226]) by mx.zohomail.com
        with SMTPS id 1673170158209761.6004763996474; Sun, 8 Jan 2023 01:29:18 -0800 (PST)
Message-ID: <56a335f1-3558-e496-4b0b-b024a935f881@zzy040330.moe>
Date:   Sun, 8 Jan 2023 17:29:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
Content-Language: en-US
To:     Bitterblue Smith <rtl8821cerfe2@gmail.com>, Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221217030659.12577-1-JunASAKA@zzy040330.moe>
 <18907e6b-93b4-d850-8a17-95ad43501136@gmail.com>
From:   Jun ASAKA <JunASAKA@zzy040330.moe>
In-Reply-To: <18907e6b-93b4-d850-8a17-95ad43501136@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/01/2023 22:17, Bitterblue Smith wrote:

> On 17/12/2022 05:06, Jun ASAKA wrote:
>> Fixing transmission failure which results in
>> "authentication with ... timed out". This can be
>> fixed by disable the REG_TXPAUSE.
>>
>> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
>> ---
>>   drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>> index a7d76693c02d..9d0ed6760cb6 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>> @@ -1744,6 +1744,11 @@ static void rtl8192e_enable_rf(struct rtl8xxxu_priv *priv)
>>   	val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
>>   	val8 &= ~BIT(0);
>>   	rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
>> +
>> +	/*
>> +	 * Fix transmission failure of rtl8192e.
>> +	 */
>> +	rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
>>   }
>>   
>>   static s8 rtl8192e_cck_rssi(struct rtl8xxxu_priv *priv, u8 cck_agc_rpt)
> By the way, you should get this into the stable kernels too:
> https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

I see.

But since this patch has not been merged into Linus' tree yet, so should 
I wait until this patch is merged or I should issue a v2 patch here and 
Cc it to "table@vger.kernel.org"?


Jun ASAKA.

