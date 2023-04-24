Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97FDC6ECE9C
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbjDXNdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbjDXNdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:33:33 -0400
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385E686B9;
        Mon, 24 Apr 2023 06:33:14 -0700 (PDT)
Received: from [IPV6:2001:250:4000:5122:ef2c:4d0d:eb7f:c1d2] ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=PLAIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 33ODVp3C013119-33ODVp3D013119
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Mon, 24 Apr 2023 21:31:51 +0800
Message-ID: <6df17c8d-1ed3-6059-e821-bd58e370c641@hust.edu.cn>
Date:   Mon, 24 Apr 2023 21:28:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v4] net: amd: Fix link leak when verifying config failed
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Gencen Gan <gangecen@hust.edu.cn>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        hust-os-kernel-patches@googlegroups.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230424104643.182296-1-gangecen@hust.edu.cn>
 <ZEZ9m4Q7qO0UTx1B@corigine.com>
From:   Dongliang Mu <dzm91@hust.edu.cn>
In-Reply-To: <ZEZ9m4Q7qO0UTx1B@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-FEAS-AUTH-USER: dzm91@hust.edu.cn
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/24/23 21:01, Simon Horman wrote:
> On Mon, Apr 24, 2023 at 06:46:43PM +0800, Gencen Gan wrote:
>> After failing to verify configuration, it returns directly without
>> releasing link, which may cause memory leak.
>>
>> Paolo Abeni thinks that the whole code of this driver is quite
>> "suboptimal" and looks unmainatained since at least ~15y, so he
>> suggests that we could simply remove the whole driver, please
>> take it into consideration.
>>
>> Simon Horman suggests that the fix label should be set to
>> "Linux-2.6.12-rc2" considering that the problem has existed
>> since the driver was introduced and the commit above doesn't
>> seem to exist in net/net-next.
>>
>> Fixes: 99c3b0265649 ("Linux-2.6.12-rc2")
> 
> Unless I'm mistaken, this should be:
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> 
>> Signed-off-by: Gan Gecen <gangecen@hust.edu.cn>
>> Reviewed-by: Paolo Abeni <pabeni@redhat.com>
>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> I think that tags such as Reviewed-by need to be given explicitly.
> And as the above two Reviewed-by tags were not, so it is a bit
> odd for them to appear above.

Hi Semon,

Sorry about the naive mistakes made by Gan Gecen. Our team had 
repeatedly talked about this issue and written it in our kernel 
contribution guidance.

[1] 
https://groups.google.com/g/hust-os-kernel-patches/c/GThhx08kecg/m/5p61iz6KAQAJ

> 
>> ---
>> v3->v4: modify the 'Fixes:' tag to make it more accurate.
>>   drivers/net/ethernet/amd/nmclan_cs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
>> index 823a329a921f..0dd391c84c13 100644
>> --- a/drivers/net/ethernet/amd/nmclan_cs.c
>> +++ b/drivers/net/ethernet/amd/nmclan_cs.c
>> @@ -651,7 +651,7 @@ static int nmclan_config(struct pcmcia_device *link)
>>       } else {
>>         pr_notice("mace id not found: %x %x should be 0x40 0x?9\n",
>>   		sig[0], sig[1]);
>> -      return -ENODEV;
>> +      goto failed;
>>       }
>>     }
>>   
>> -- 
>> 2.34.1
>>
> 
