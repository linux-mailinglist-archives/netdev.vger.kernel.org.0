Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1066EA343
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 07:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbjDUFkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 01:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbjDUFkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 01:40:07 -0400
Received: from smtp.smtpout.orange.fr (smtp-16.smtpout.orange.fr [80.12.242.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A6059F9
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 22:40:05 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id pjV2pQlJ0YD96pjV2pjQ2t; Fri, 21 Apr 2023 07:40:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1682055603;
        bh=7qKZ3uxvb0ZRE+YpwV4WbK5yMlZJV1gsOrqwFy3n2zE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=KOEQaCde+tDiFzYb8LGwh9OhPXUh73UetQ/YZaZtt3UT4E4M9pkvj5Og4I9M2g2QK
         u1L1z0BYUFqNC3hPg1/H51ZONoH2ulxC6Asivzgm9X0r5u/uSy+aQxNpGsxG+KzuVA
         s+Ulzm/7aWRMa77voDeSrnzJeccEJ7JTrZx5q4P4bt65OIJTPUfGc9rbYGb0nhyRB7
         X5efAPbgVCLEgfKBIyxdHuvr4fY/mSqyaJOICDQqY/3dOhatez5V2W627blzulupeE
         w3G7ofXAOfp1e+rsvjeM1H+uHWlVKSzlKG2S2PPlrTrWZHeBDuZSUpBDyyuy0j+3+i
         AJxMwTAk18VHQ==
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 21 Apr 2023 07:40:03 +0200
X-ME-IP: 86.243.2.178
Message-ID: <4385d07a-e124-d2f2-fbd0-eda1d602167b@wanadoo.fr>
Date:   Fri, 21 Apr 2023 07:40:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next] net: dsa: b53: Slightly optimize b53_arl_read()
Content-Language: fr, en-GB
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
References: <c94fb1b4dcd9a04eff08cf9ba2444c348477e554.1682023416.git.christophe.jaillet@wanadoo.fr>
 <be0d976a-2219-d007-617d-6865c0344335@gmail.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <be0d976a-2219-d007-617d-6865c0344335@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 21/04/2023 à 02:40, Florian Fainelli a écrit :
> 
> 
> On 4/20/2023 1:44 PM, Christophe JAILLET wrote:
>> When the 'free_bins' bitmap is cleared, it is better to use its full
>> maximum size instead of only the needed size.
>> This lets the compiler optimize it because the size is now known at 
>> compile
>> time. B53_ARLTBL_MAX_BIN_ENTRIES is small (i.e. currently 4), so a 
>> call to
>> memset() is saved.
>>
>> Also, as 'free_bins' is local to the function, the non-atomic __set_bit()
>> can also safely be used here.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>>   drivers/net/dsa/b53/b53_common.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/dsa/b53/b53_common.c 
>> b/drivers/net/dsa/b53/b53_common.c
>> index 3464ce5e7470..8c55fe0e0747 100644
>> --- a/drivers/net/dsa/b53/b53_common.c
>> +++ b/drivers/net/dsa/b53/b53_common.c
>> @@ -1627,7 +1627,7 @@ static int b53_arl_read(struct b53_device *dev, 
>> u64 mac,
>>       if (ret)
>>           return ret;
>> -    bitmap_zero(free_bins, dev->num_arl_bins);
>> +    bitmap_zero(free_bins, B53_ARLTBL_MAX_BIN_ENTRIES);
> 
> That one I am not a big fan, as the number of ARL bins is a function of 
> the switch model, and this illustrates it well.

Ok, up to you to take or not what looks the better solution.

 From my point of view, the "for (i = 0; i < dev->num_arl_bins" below 
illustrates it better.


Maybe, another approach to save the memset() call would be remove the 
bitmap_zero() call, and declare 'free_bins' as:

    DECLARE_BITMAP(free_bins, B53_ARLTBL_MAX_BIN_ENTRIES) = { };
(this syntax is already used in b53_configure_vlan())


The compiler should still be able to optimize the initialisation and 
this wouldn't, IMHO, introduce confusion about the intent.

Let me know if you prefer to leave this hunk as-is, or if this other 
alternative pleases you.


CJ

> 
>>       /* Read the bins */
>>       for (i = 0; i < dev->num_arl_bins; i++) {
>> @@ -1641,7 +1641,7 @@ static int b53_arl_read(struct b53_device *dev, 
>> u64 mac,
>>           b53_arl_to_entry(ent, mac_vid, fwd_entry);
>>           if (!(fwd_entry & ARLTBL_VALID)) {
>> -            set_bit(i, free_bins);
>> +            __set_bit(i, free_bins);
> 
> I would be keen on taking that hunk but keep the other as-is. Does that 
> work for you?
> -- 
> Florian
> 

