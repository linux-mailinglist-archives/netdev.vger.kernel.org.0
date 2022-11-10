Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7A4623ECB
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 10:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiKJJj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 04:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiKJJj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 04:39:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A8B11A3E;
        Thu, 10 Nov 2022 01:39:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 105D2B82140;
        Thu, 10 Nov 2022 09:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0754C433D6;
        Thu, 10 Nov 2022 09:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668073192;
        bh=D6RE7UOWJpA7EbAthQbU3kBtGwmEzK7dIzjwKD/PMjI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Sdeezdx5jtd/XT4rzX0jZI+656PDJg7/2pJl+HRrPk99fka5mwPJ+Ja7gpGKgjxsx
         +OSKXKrY2Asw4qouuWeXzPRt1BLyI26uFpp6/sceQhXoFNzz0hSBpn+AUp5O62b7+5
         D5456T2PEJAuayEz6zKmYu7hiNIVCiw/Fc5KOqS/cI+OvghjRGzxgurfE9lJIYK2R3
         4gethJIBNI9yBkyu7pN3/lKYok3tI2bM26OhU61rLx7LYMOHrztm04CtLZ9ayzyBuO
         116SmHF8FmQ7uAtXlT9cheuvAJXOtmQmxxeldA63OzwOCIVEgGow1x5bkSB4v6ZFjw
         8mRPQnlevlnfQ==
Message-ID: <32eacc9d-3866-149a-579a-41f8e405123f@kernel.org>
Date:   Thu, 10 Nov 2022 11:39:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net: ethernet: ti: cpsw_ale: optimize cpsw_ale_restore()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, srk@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221108135643.15094-1-rogerq@kernel.org>
 <20221109191941.6af4f71d@kernel.org>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20221109191941.6af4f71d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/2022 05:19, Jakub Kicinski wrote:
> On Tue,  8 Nov 2022 15:56:43 +0200 Roger Quadros wrote:
>> If an entry was FREE then we don't have to restore it.
> 
> Motivation? Does it make the restore faster?

Yes, since this would be called during system suspend/resume path.
I will update the commit message to mention this.

> 
>> Signed-off-by: Roger Quadros <rogerq@kernel.org>
>> ---
>>
>> Patch depends on
>> https://lore.kernel.org/netdev/20221104132310.31577-3-rogerq@kernel.org/T/
>>
>>  drivers/net/ethernet/ti/cpsw_ale.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
>> index 0c5e783e574c..41bcf34a22f8 100644
>> --- a/drivers/net/ethernet/ti/cpsw_ale.c
>> +++ b/drivers/net/ethernet/ti/cpsw_ale.c
>> @@ -1452,12 +1452,15 @@ void cpsw_ale_dump(struct cpsw_ale *ale, u32 *data)
>>  	}
>>  }
>>  
>> +/* ALE table should be cleared (ALE_CLEAR) before cpsw_ale_restore() */
> 
> Maybe my tree is old but I see we clear only if there is a netdev that

This patch depends on this series
https://lore.kernel.org/netdev/20221104132310.31577-3-rogerq@kernel.org/T/

> needs to be opened but then always call ale_restore(). Is that okay?

If netdev is closed and opened ale_restore() is not called.
ale_restore() is only called during system suspend/resume path
since CPSW-ALE might have lost context during suspend and we want to restore
all valid ALE entries.

I have a question here. How should ageable entries be treated in this case?

> 
> I'd also s/should/must/ 

OK, will fix.

> 
>>  void cpsw_ale_restore(struct cpsw_ale *ale, u32 *data)
>>  {
>> -	int i;
>> +	int i, type;
>>  
>>  	for (i = 0; i < ale->params.ale_entries; i++) {
>> -		cpsw_ale_write(ale, i, data);
>> +		type = cpsw_ale_get_entry_type(data);
>> +		if (type != ALE_TYPE_FREE)
>> +			cpsw_ale_write(ale, i, data);
>>  		data += ALE_ENTRY_WORDS;
>>  	}
>>  }
> 

cheers,
-roger
