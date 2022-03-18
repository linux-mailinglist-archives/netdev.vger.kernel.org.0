Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00EDC4DD765
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 10:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbiCRJyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 05:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiCRJyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 05:54:51 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 072DD282;
        Fri, 18 Mar 2022 02:53:25 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:35610.215648910
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-10.133.11.244 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id E1D4528008E;
        Fri, 18 Mar 2022 17:53:21 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 27884d8d2a6147959df3e8db561032d6 for jay.vosburgh@canonical.com;
        Fri, 18 Mar 2022 17:53:24 CST
X-Transaction-ID: 27884d8d2a6147959df3e8db561032d6
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Message-ID: <d7fb4ba2-8501-07c9-3fe1-5d2c3020de25@chinatelecom.cn>
Date:   Fri, 18 Mar 2022 17:53:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4] net:bonding:Add support for IPV6 RLB to balance-alb
 mode
To:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        David Ahern <dsahern@kernel.org>
Cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, oliver@neukum.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn
References: <20220317061521.23985-1-sunshouxin@chinatelecom.cn>
 <eff0021c-5a9b-5c44-3fb7-24387cf13e16@kernel.org> <24597.1647547831@famine>
From:   =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
In-Reply-To: <24597.1647547831@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/3/18 4:10, Jay Vosburgh 写道:
> David Ahern <dsahern@kernel.org> wrote:
>
>> On 3/17/22 12:15 AM, Sun Shouxin wrote:
>>> This patch is implementing IPV6 RLB for balance-alb mode.
>>>
>>> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>>> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>>> ---
>>> changelog:
>>> v1-->v2:
>>> -Remove ndisc_bond_send_na and refactor ndisc_send_na.
>>> -In rlb_nd_xmit, if the lladdr is not local, return curr_active_slave.
>>> -Don't send neighbor advertisement message when receiving
>>>   neighbor advertisement message in rlb6_update_entry_from_na.
>>>
>>> v2-->v3:
>>> -Don't export ndisc_send_na.
>>> -Use ipv6_stub->ndisc_send_na to replace ndisc_send_na
>>>   in rlb6_update_client.
>>>
>>> v3-->v4:
>>> -Submit all code at a whole patch.
>> you misunderstood Jakub's comment. The code should evolve with small,
>> focused patches and each patch needs to compile and function correctly
>> (ie., no breakage).
> 	Agreed; the split of the patches was not at issue, it was that
> each patch in a series must compile and the built kernel must function
> rationally.
>
>> You need to respond to Jiri's question about why this feature is needed.
> 	I'm not entirely sold on adding IPv6 RLB for balance-alb, but
> the IPv4 version of it does see moderate levels of use, even now.  It's
> less common than LACP by far, though.  I'd like to know why someone
> would choose IPv6 RLB over LACP.  I wonder if this is a checklist item
> somewhere that something must have "complete support for IPv6" or words
> to that effect, versus an actual functional need.


This patch is certainly aim fix one real issue in ou lab.
For historical inheritance, the bond6 with ipv4 is widely used in our lab.
We started to support ipv6 for all service last year, networking 
operation and maintenance team
think it does work with ipv6 ALB capacity take it for granted due to 
bond6's specification
but it doesn't work in the end. as you know, it is impossible to change 
link neworking to LACP
because of huge cost and effective to online server.
I believe this is the case another man meet as ipv6 promotion.


>> After that:
>>
>> 1. patch 1 adds void *data to ndisc_send_na stub function and
>> ndisc_send_na direct function. Update all places that use both
>> ndisc_send_na to pass NULL as the data parameter.
>>
>> 2. patch 2 refactors ndisc_send_na to handle the new data argument
>>
>> 3. patch 3 exports any IPv6 functions. explain why each needs to be
>> exported.
>>
>> 4. patch 4 .... bonding changes. (bonding folks can respond on how to
>> introduce that change).
> 	Looking at the previous patch for bonding, my two initial
> requests are:
>
> 	1) A more detailed commit message.  The only way to understand
> how any of this actually works is reading the code, there is no higher
> level description.
>
> 	2) How does this interact with the IPv4 RLB logic?  Is it
> possible for a given bond interface MAC to be "assigned" to two
> different peers (one IPv4, one IPv6), and if so, does that behave in an
> expected manner?  I.e., two peers on the network could receive
> contradictory information via ARP and ND for the MAC address of a given
> peer.  This is already possible with the IPv4 RLB, but with an
> additional IPv6 RLB, a single peer could see two different MACs for a
> given host (one via IPv4, one via IPv6), and another peer could see the
> opposite, or even disjoint information across several peers.
>
> 	-J


Sorry for not fully understood your question

If I understand correctly ,I don't think IPV6 ALB can interact with the 
Ipv4 RLB logic.
Since they use different neighbor table when sending packets , what's more,
in the process of ALB, the rx6_hashtbl is used by IPV6 and rx_hashtbl 
for IPV4.

please rectify me if miss your point.


>
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
