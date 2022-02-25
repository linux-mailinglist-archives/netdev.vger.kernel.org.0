Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6332A4C3F08
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 08:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbiBYHbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 02:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiBYHbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 02:31:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6603125D6F3
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 23:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=TW1rKp98oDuAFK8/qGf7txal58CzOCUTs7rIVVOnDvk=; b=jVJv2a7hPlGdIz5LLA7+99IJoN
        phIRJTk2LgNcv9jkKqPu4kM9BUMvEFNY4givK5BfFUhaSdgs/gsmJjxlHcZzwS3T8FxLinq9byvSi
        ffHGChmjTIHz5h1TvvawO2qpm8Su+pIJq5fNv0/CqIXOp6BBb9KF4Pyg6Ismn0iENmuMwEbGeVE3r
        JTAkxN/ZLEYwX3ZGPK0dLHmYCki8xFzcgAALxtMxW/HnV9xzFb9EU2Mqjd0CMmm9mnyEYZeTlb3/O
        ZKzyGD+G99k2bLRmuN74aPY8faQj41IQPXmH5a0kwI4yYcgCOD1MUemZwKGP/MShqh6v2/XTRgCDy
        CN0K0/8Q==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNV3v-005Zpl-NS; Fri, 25 Feb 2022 07:30:47 +0000
Message-ID: <d397d64f-8ae6-2713-d71c-465ae71baebe@infradead.org>
Date:   Thu, 24 Feb 2022 23:30:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] net: sxgbe: fix return value of __setup handler
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, patches@lists.linux.dev,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Siva Reddy <siva.kallam@samsung.com>,
        Girish K S <ks.giri@samsung.com>,
        Byungho An <bh74.an@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220224033528.24640-1-rdunlap@infradead.org>
 <20220224214302.4262c26f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220224214302.4262c26f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/24/22 21:43, Jakub Kicinski wrote:
> On Wed, 23 Feb 2022 19:35:28 -0800 Randy Dunlap wrote:
>> __setup() handlers should return 1 on success, i.e., the parameter
>> has been handled. A return of 0 causes the "option=value" string to be
>> added to init's environment strings, polluting it.
> 
> Meaning early_param_on_off() also returns the wrong thing?
> Or that's different?

early_param() and its varieties are different -- 0 for success, else error.

>> Fixes: acc18c147b22 ("net: sxgbe: add EEE(Energy Efficient Ethernet) for Samsung sxgbe")
>> Fixes: 1edb9ca69e8a ("net: sxgbe: add basic framework for Samsung 10Gb ethernet driver")
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
>> Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
>>
>> --- linux-next-20220223.orig/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
>> +++ linux-next-20220223/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
>> @@ -2285,18 +2285,18 @@ static int __init sxgbe_cmdline_opt(char
>>  	char *opt;
>>  
>>  	if (!str || !*str)
>> -		return -EINVAL;
>> +		return 1;
>>  	while ((opt = strsep(&str, ",")) != NULL) {
>>  		if (!strncmp(opt, "eee_timer:", 10)) {
>>  			if (kstrtoint(opt + 10, 0, &eee_timer))
>>  				goto err;
>>  		}
>>  	}
>> -	return 0;
>> +	return 1;
>>  
>>  err:
>>  	pr_err("%s: ERROR broken module parameter conversion\n", __func__);
>> -	return -EINVAL;
>> +	return 1;
>>  }
>>  
>>  __setup("sxgbeeth=", sxgbe_cmdline_opt);
> 
> Was the option of making __setup() return void considered?
> Sounds like we always want to return 1 so what's the point?

Well, AFAIK __setup() has been around forever (at least 22 years), so No,
I don't think anyone has considered making it void.

Returning 1 or 0 gives kernel parameter writers the option of how error
input is handled, although 0 is usually wrong. :)

-- 
~Randy
