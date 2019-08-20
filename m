Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B0D956AE
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 07:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfHTFdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 01:33:46 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:34270 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729060AbfHTFdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 01:33:46 -0400
Received: from [192.168.1.41] ([90.126.162.2])
        by mwinf5d79 with ME
        id rHZf2000603Qemq03HZfS8; Tue, 20 Aug 2019 07:33:43 +0200
X-ME-Helo: [192.168.1.41]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 20 Aug 2019 07:33:43 +0200
X-ME-IP: 90.126.162.2
Subject: Re: [PATCH] nfc: st-nci: Fix an incorrect skb_buff size in
 'st_nci_i2c_read()'
To:     David Miller <davem@davemloft.net>
Cc:     tglx@linutronix.de, gregkh@linuxfoundation.org,
        colin.king@canonical.com, allison@lohutok.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20190806141640.13197-1-christophe.jaillet@wanadoo.fr>
 <20190811.205719.198343441735959015.davem@davemloft.net>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <279f5ad0-667c-2e41-e820-f1fc49432a1a@wanadoo.fr>
Date:   Tue, 20 Aug 2019 07:33:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190811.205719.198343441735959015.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 12/08/2019 à 05:57, David Miller a écrit :
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Date: Tue,  6 Aug 2019 16:16:40 +0200
>
>> In 'st_nci_i2c_read()', we allocate a sk_buff with a size of
>> ST_NCI_I2C_MIN_SIZE + len.
>>
>> However, later on, we first 'skb_reserve()' ST_NCI_I2C_MIN_SIZE bytes, then
>> we 'skb_put()' ST_NCI_I2C_MIN_SIZE bytes.
>> Finally, if 'len' is not 0, we 'skb_put()' 'len' bytes.
>>
>> So we use ST_NCI_I2C_MIN_SIZE*2 + len bytes.
>>
>> This is incorrect and should already panic. I guess that it does not occur
>> because of extra memory allocated because of some rounding.
>>
>> Fix it and allocate enough room for the 'skb_reserve()' and the 'skb_put()'
>> calls.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>> This patch is LIKELY INCORRECT. So think twice to what is the correct
>> solution before applying it.
>> Maybe the skb_reserve should be axed or some other sizes are incorrect.
>> There seems to be an issue, that's all I can say.
> The skb_reserve() should be removed,

I don't fully understand the potential implications, but looks ok to me.
At least, the allocated memory and the size of the used memory would match.

What I don't understand is why is does not BUG_ON with the current code. 
Does my suspected "over allocation" because of rounding/aligment could 
hide the issue?

A Tested-by: by someone who has the corresponding hardware would also be 
useful IMHO.

>   and the second memcpy() should remove
> the " + ST_NCI_I2C_MIN_SIZE".
Hmm, not sure on this one.

The skb is manipulated only with skb_put. So only the tail pointer and 
len are updated. The data pointer remains at the same position, so there 
should effectively be an offset of ST_NCI_I2C_MIN_SIZE for the 2nd memcpy.

Maybe, using skb_put_data would be cleaner here, in order to 
"concatenate" these 2 parts without having to handle by hand the right 
position in the buffer.

If you agree, I'll send a V2.


Thx for the review and comments.

CJ

> This SKB just get sent down to ndlc_recv() so the content returned from I2C
> should places at skb->data to be processed.
>
> Pretty clear this code was never tested.

