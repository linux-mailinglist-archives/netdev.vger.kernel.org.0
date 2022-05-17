Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA92C52AC81
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 22:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352728AbiEQUMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 16:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351826AbiEQUMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 16:12:33 -0400
Received: from smtp.smtpout.orange.fr (smtp08.smtpout.orange.fr [80.12.242.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615A13EF32
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 13:12:31 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id r3YRnwureghzAr3YRn1yRW; Tue, 17 May 2022 22:12:29 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Tue, 17 May 2022 22:12:29 +0200
X-ME-IP: 86.243.180.246
Message-ID: <f59200c5-c720-fe66-f395-31ea096dc300@wanadoo.fr>
Date:   Tue, 17 May 2022 22:12:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 2/2] octeon_ep: Fix irq releasing in the error handling
 path of octep_request_irqs()
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Veerasenareddy Burru <vburru@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Satananda Burla <sburla@marvell.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Newsgroups: gmane.linux.kernel.janitors,gmane.linux.kernel,gmane.linux.network
References: <cover.1652629833.git.christophe.jaillet@wanadoo.fr>
 <a1b6f082fff4e68007914577961113bc452c8030.1652629833.git.christophe.jaillet@wanadoo.fr>
 <20220517052859.GN4009@kadam>
 <eec880be771e75d60ead01cbf71d83fe070ccde8.camel@redhat.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <eec880be771e75d60ead01cbf71d83fe070ccde8.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 17/05/2022 à 10:35, Paolo Abeni a écrit :
> On Tue, 2022-05-17 at 08:28 +0300, Dan Carpenter wrote:
>> On Sun, May 15, 2022 at 05:56:45PM +0200, Christophe JAILLET wrote:
>>> For the error handling to work as expected, the index in the
>>> 'oct->msix_entries' array must be tweaked because, when the irq are
>>> requested there is:
>>> 	msix_entry = &oct->msix_entries[i + num_non_ioq_msix];
>>>
>>> So in the error handling path, 'i + num_non_ioq_msix' should be used
>>> instead of 'i'.
>>>
>>> The 2nd argument of free_irq() also needs to be adjusted.
>>>
>>> Fixes: 37d79d059606 ("octeon_ep: add Tx/Rx processing and interrupt support")
>>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>> ---
>>> I think that the wording above is awful, but I'm sure you get it.
>>> Feel free to rephrase everything to have it more readable.
>>> ---
>>>   drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
>>> index 6b60a03574a0..4dcae805422b 100644
>>> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
>>> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
>>> @@ -257,10 +257,12 @@ static int octep_request_irqs(struct octep_device *oct)
>>>   
>>>   	return 0;
>>>   ioq_irq_err:
>>> +	i += num_non_ioq_msix;
>>>   	while (i > num_non_ioq_msix) {
>>
>> This makes my mind hurt so badly.  Can we not just have two variables
>> for the two different loops instead of re-using i?
>>
>>>   		--i;
>>>   		irq_set_affinity_hint(oct->msix_entries[i].vector, NULL);
>>> -		free_irq(oct->msix_entries[i].vector, oct->ioq_vector[i]);
>>> +		free_irq(oct->msix_entries[i].vector,
>>> +			 oct->ioq_vector[i - num_non_ioq_msix]);
>>>   	}
>>
>> ioq_irq_err:
>>          while (--j >= 0) {
>>                  ioq_vector = oct->ioq_vector[j];
>>                  msix_entry = &oct->msix_entries[j + num_non_ioq_msix];
>>
>>                  irq_set_affinity_hint(msix_entry->vector, NULL);
>>                  free_irq(msix_entry->vector, ioq_vector);
>>          }
>>
>> regards,
>> dan carpenter
> 
> I agree the above would be more readable. @Christophe: could you please
> refactor the code as per Dan's suggestion?

Will do.

I was sure that Dan would comment on this unusual pattern :)

CJ

> 
> Thanks!
> 
> Paolo
> 
> 

