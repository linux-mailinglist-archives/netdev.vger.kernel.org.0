Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3400140B17
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 14:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgAQNia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 08:38:30 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:17621 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgAQNia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 08:38:30 -0500
Received: from [10.193.177.117] (shivaram.asicdesigners.com [10.193.177.117] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 00HDc8Kw012428;
        Fri, 17 Jan 2020 05:38:11 -0800
Cc:     ayush.sawal@asicdesigners.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, manojmalviya@chelsio.com,
        Ayush Sawal <ayush.sawal@chelsio.com>, netdev@vger.kernel.org
Subject: Re: Advertise maximum number of sg supported by driver in single
 request
To:     Steffen Klassert <steffen.klassert@secunet.com>
References: <20200115060234.4mm6fsmsrryzpymi@gondor.apana.org.au>
 <9fd07805-8e2e-8c3f-6e5e-026ad2102c5a@chelsio.com>
 <c8d64068-a87b-36dd-910d-fb98e09c7e4b@asicdesigners.com>
 <20200117062300.qfngm2degxvjskkt@gondor.apana.org.au>
 <20d97886-e442-ed47-5685-ff5cd9fcbf1c@asicdesigners.com>
 <20200117070431.GE23018@gauss3.secunet.de>
 <318fd818-0135-8387-6695-6f9ba2a6f28e@asicdesigners.com>
 <20200117121722.GG26283@gauss3.secunet.de>
From:   Ayush Sawal <ayush.sawal@asicdesigners.com>
Message-ID: <179f6f7e-f361-798b-a1c6-30926d8e8bf5@asicdesigners.com>
Date:   Fri, 17 Jan 2020 19:08:05 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200117121722.GG26283@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi steffen,

On 1/17/2020 5:47 PM, Steffen Klassert wrote:
> On Fri, Jan 17, 2020 at 04:28:54PM +0530, Ayush Sawal wrote:
>> Hi steffen,
>>
>> On 1/17/2020 12:34 PM, Steffen Klassert wrote:
>>> On Fri, Jan 17, 2020 at 12:13:07PM +0530, Ayush Sawal wrote:
>>>> Hi Herbert,
>>>>
>>>> On 1/17/2020 11:53 AM, Herbert Xu wrote:
>>>>> On Thu, Jan 16, 2020 at 01:27:24PM +0530, Ayush Sawal wrote:
>>>>>> The max data limit is 15 sgs where each sg contains data of mtu size .
>>>>>> we are running a netperf udp stream test over ipsec tunnel .The ipsec tunnel
>>>>>> is established between two hosts which are directly connected
>>>>> Are you actually getting 15-element SG lists from IPsec? What is
>>>>> generating an skb with 15-element SG lists?
>>>> we have established the ipsec tunnel in transport mode using ip xfrm.
>>>> and running traffic using netserver and netperf.
>>>>
>>>> In server side we are running
>>>> netserver -4
>>>> In client side we are running
>>>> "netperf -H <serverip> -p <port> -t UDP_STREAM  -Cc -- -m 21k"
>>>> where the packet size is 21k ,which is then fragmented into 15 ip fragments
>>>> each of mtu size.
>>> I'm lacking a bit of context here, but this should generate 15 IP
>>> packets that are encrypted one by one.
>> This is what i observed ,please correct me if i am wrong.
>> The packet when reaches esp_output(),is in socket buffer and based on the
>> number of frags ,sg is initialized  using
>> sg_init_table(sg,frags),where frags are 15 in our case.
> The packet should be IP fragmented before it enters esp_output()
> unless this is a UDP GSO packet. What kind of device do you use
> here? Is it a crypto accelerator or a NIC that can do ESP offloads?

We have device which works as a crypto accelerator . It just encrypts 
the packets and send it back to kernel.


