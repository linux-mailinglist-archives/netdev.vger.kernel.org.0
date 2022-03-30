Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC134EBE1A
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 11:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245050AbiC3Jz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 05:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236889AbiC3Jz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 05:55:27 -0400
Received: from serv108.segi.ulg.ac.be (serv108.segi.ulg.ac.be [139.165.32.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13BA2DFB
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 02:53:40 -0700 (PDT)
Received: from [192.168.1.27] (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 2DBA2200F82B;
        Wed, 30 Mar 2022 11:53:38 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 2DBA2200F82B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1648634018;
        bh=aUeS+Qp9CpFAM3ZF9LTDc73SBPpOI0kvaxy+dLwI9qM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=roW1x316duhXdVEpMIdtUrnKXERskLhi2Fsobc6X0Netq62WkPauE39UMBdwT+QGi
         HOh5p2l+J40SjEBJ7wM4G9DuQE+VhwUxRGTY4/aOHkSYXFtVHU3VLJ2xdDrJAf8hB5
         J3p4NuGUQJRRBVfhmHQwqAUloItzCyteO32L0tgde0ZYzQJslvvvf5i4CC3OusMYxQ
         4uIJLxdaZK7j2mwLds6XDJqLPEsIGcYIQzkm7e5hC1O7bFZRZh5VWdJNxEr7Q9akzx
         fASn6SClN87PE56hO8ITy+tQJKXxn9yrwEubEjFPfiuLRMIz8Z3eAJD5PpKb9J/VRR
         fXYdBe7IodutQ==
Message-ID: <040f897e-edde-a772-ca81-cd8f5a6857b1@uliege.be>
Date:   Wed, 30 Mar 2022 11:53:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC net] Discuss seg6 potential wrong behavior
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        pabeni@redhat.com
References: <20220318202138.37161-1-justin.iurman@uliege.be>
 <21c70ad0-cf4b-1681-c606-768e992bcc6a@kernel.org>
From:   Justin Iurman <justin.iurman@uliege.be>
In-Reply-To: <21c70ad0-cf4b-1681-c606-768e992bcc6a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Thanks for your feedback and sorry for the delay in my response.

On 3/23/22 03:10, David Ahern wrote:
> On 3/18/22 2:21 PM, Justin Iurman wrote:
>> This thread aims to discuss a potential wrong behavior regarding seg6
>> (as well as rpl). I'm curious to know if there is a specific reason for
>> discarding the packet when seg6 is not enabled on an interface and when
> 
> that is standard. MPLS for example does the same.

I guess you mean "standard" from a kernel implementation point of view, 
not from the RFC one, right? Again, I understand *why* it would be 
implemented the current way so that one doesn't bother distinguishing 
between the case I mentioned and other cases (only talking about routing 
headers here, did not give a look at the mpls implementation nor RFCs). 
But still, I can't stop thinking it's wrong, especially when the RFC 
(more than) suggests the opposite.

Indeed, having the case (!seg6_enabled && segments_left == 0) is not 
harmful for a node (only if nexthdr != (IPv6||IPv4) of course, otherwise 
there could probably be something suspicious). So, right now, if an 
operator forgets to enable it on one of its egresses, the packet is just 
silently dropped. And there goes the wasted time trying to figure out 
what's wrong. Also, let's just assume that you want your packet to be 
sent towards a destination Y, and going through a specific node X on the 
path. As long as you don't cross a domain/AS where seg6 is enabled, your 
packet goes through. Fine, but, if you don't own the destination and it 
runs a Linux kernel, the packet will be discarded if seg6 is not enabled 
(which is the case for each interface, by default). Which is sad, 
because there is literally nothing to do and the packet should be accepted.

So, the correct way of handling this specific case mentioned previously 
(which is also in the RFC) would be to continue processing next header. 
It would semantically sound better. And, such a change would not 
introduce any issue, whether seg6 is enabled or not in your domain/AS. I 
insist on this point as it is important.

>> segments_left == 0. Indeed, reading RFC8754, I'm not sure this is the
> 
> 
>> right thing to do. I think it would be more correct to process the next
>> header in the packet. It does not make any sense to prevent further
>> processing when the SRv6 node has literally nothing to do in that
>> specific case. For that, we need to postpone the check of accept_seg6.
>> And, in order to avoid a breach, we also check for accept_seg6 before
>> decapsulation when segments_left == 0. Any comments on this?
>>
>> Also, I'm not sure why accept_seg6 is set the current way. Are we not
>> suppose to prioritize devconf_all? If "all" is set to 1, then it is
> 
> sadly, ipv6 is all over the place with 'all' vs 'dev' settings.

I see. Indeed, changing that might bring some compatibility issues 
depending on configurations. In that case, maybe should we update the 
documentation for each concerned part, so that people know that "all && 
dev" is mandatory to enable the feature (at least for seg6, though).
