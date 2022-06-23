Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0137C557AAD
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 14:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbiFWMu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 08:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiFWMuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 08:50:25 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C691929D;
        Thu, 23 Jun 2022 05:50:24 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VHBaHk2_1655988615;
Received: from 30.225.28.168(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VHBaHk2_1655988615)
          by smtp.aliyun-inc.com;
          Thu, 23 Jun 2022 20:50:21 +0800
Message-ID: <c6e21cd4-b756-e566-c267-37f997f53239@linux.alibaba.com>
Date:   Thu, 23 Jun 2022 20:50:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [RFC net-next] net/smc:introduce 1RTT to SMC
Content-Language: en-US
To:     Alexandra Winter <wintera@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1653375127-130233-1-git-send-email-alibuda@linux.alibaba.com>
 <YoyOGlG2kVe4VA4m@TonyMac-Alibaba>
 <64439f1c-9817-befd-c11b-fa64d22620a9@linux.ibm.com>
 <7d57f299-115f-3d34-a45e-1c125a9a580a@linux.alibaba.com>
 <61fbee55-245f-b912-95df-d9557849d08f@linux.alibaba.com>
 <002050da-64a3-4648-6e8f-b3ae8ed3eece@linux.ibm.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <002050da-64a3-4648-6e8f-b3ae8ed3eece@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/6/23 下午7:59, Alexandra Winter wrote:
> 
> 
> On 16.06.22 15:49, D. Wythe wrote:
>>
>>
>> On 2022/6/1 下午2:33, D. Wythe wrote:
>>>
>>> 在 2022/5/25 下午9:42, Alexandra Winter 写道:
>>>
>>>> We need to carefully evaluate them and make sure everything is compatible
>>>> with the existing implementations of SMC-D and SMC-R v1 and v2. In the
>>>> typical s390 environment ROCE LAG is propably not good enough, as the card
>>>> is still a single point of failure. So your ideas need to be compatible
>>>> with link redundancy. We also need to consider that the extension of the
>>>> protocol does not block other desirable extensions.
>>>>
>>>> Your prototype is very helpful for the understanding. Before submitting any
>>>> code patches to net-next, we should agree on the details of the protocol
>>>> extension. Maybe you could formulate your proposal in plain text, so we can
>>>> discuss it here?
>>>>
>>>> We also need to inform you that several public holidays are upcoming in the
>>>> next weeks and several of our team will be out for summer vacation, so please
>>>> allow for longer response times.
>>>>
>>>> Kind regards
>>>> Alexandra Winter
>>>>
>>>
>>> Hi alls,
>>>
>>> In order to achieve signle-link compatibility, we must
>>> complete at least once negotiation. We wish to provide
>>> higher scalability while meeting this feature. There are
>>> few ways to reach this.
>>>
>>> 1. Use the available reserved bits. According to
>>> the SMC v2 protocol, there are at least 28 reserved octets
>>> in PROPOSAL MESSAGE and at least 10 reserved octets in
>>> ACCEPT MESSAGE are available. We can define an area in which
>>> as a feature area, works like bitmap. Considering the subsequent scalability, we MAY use at least 2 reserved ctets, which can support negotiation of at least 16 features.
>>>
>>> 2. Unify all the areas named extension in current
>>> SMC v2 protocol spec without reinterpreting any existing field
>>> and field offset changes, including 'PROPOSAL V1 IP Subnet Extension',
>>> 'PROPOSAL V2 Extension', 'PROPOSAL SMC-DV2 EXTENSION' .etc. And provides
>>> the ability to grow dynamically as needs expand. This scheme will use
>>> at least 10 reserved octets in the PROPOSAL MESSAGE and at least 4 reserved octets in ACCEPT MESSAGE and CONFIRM MESSAGE. Fortunately, we only need to use reserved fields, and the current reserved fields are sufficient. And then we can easily add a new extension named SIGNLE LINK. Limited by space, the details will be elaborated after the scheme is finalized.
>>>
> [...]
>>>
>>>
>>> Look forward to your advice and comments.
>>>
>>> Thanks.
>>
>> Hi all,
>>
>> On the basis of previous，If we can put the application data over the PROPOSAL message,
>> we can achieve SMC 0-RTT. Its process should be similar to the following:
>>
> [...]
> 
> Thank you D. Wythe for the detailed proposal, I have forwarded it to the protocol owner
> and we are currently reviewing it.
> We may contact you and Tony Lu directly to discuss the details, if that is ok for you.
> 
> Kind regards
> Alexandra Winter
> 
> 
> 
> 

Thanks a lot for your support, it seems good to us. We are totally okay with that.

Best Wishes.
D. Wythe

