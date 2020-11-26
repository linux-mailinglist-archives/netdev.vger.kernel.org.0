Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66ED12C5CC5
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 21:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404258AbgKZUAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 15:00:54 -0500
Received: from mx04.lhost.no ([5.158.192.85]:51283 "EHLO mx04.lhost.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728118AbgKZUAx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 15:00:53 -0500
X-ASG-Debug-ID: 1606420847-0ffc06424c740d0001-BZBGGp
Received: from s103.paneda.no ([5.158.193.76]) by mx04.lhost.no with ESMTP id ZJfHbLK3bTw0eRff (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO); Thu, 26 Nov 2020 21:00:49 +0100 (CET)
X-Barracuda-Envelope-From: thomas.karlsson@paneda.se
X-Barracuda-Effective-Source-IP: UNKNOWN[5.158.193.76]
X-Barracuda-Apparent-Source-IP: 5.158.193.76
X-ASG-Whitelist: Client
Received: from [192.168.10.188] (83.140.179.234) by s103.paneda.no
 (10.16.55.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.1979.3; Thu, 26
 Nov 2020 21:00:45 +0100
Subject: Re: Hardcoded multicast queue length in macvlan.c driver causes poor
 multicast receive performance
To:     Jakub Kicinski <kuba@kernel.org>
X-ASG-Orig-Subj: Re: Hardcoded multicast queue length in macvlan.c driver causes poor
 multicast receive performance
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
 <147b704ac1d5426fbaa8617289dad648@paneda.se>
 <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b93a6031-f1b4-729d-784b-b1f465d27071@paneda.se>
 <20201125085848.4f330dea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4e3c9f30-d43c-54b1-2796-86f38d316ef3@paneda.se>
 <20201125100710.7e766d7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <956c4fca-2a54-97cb-5b4c-3a286743884b@paneda.se>
 <20201125150100.287ac72a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Thomas Karlsson <thomas.karlsson@paneda.se>
Message-ID: <3a30c2f6-e400-7001-69ec-683245620f2d@paneda.se>
Date:   Thu, 26 Nov 2020 21:00:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201125150100.287ac72a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [83.140.179.234]
X-ClientProxiedBy: s103.paneda.no (10.16.55.12) To s103.paneda.no
 (10.16.55.12)
X-Barracuda-Connect: UNKNOWN[5.158.193.76]
X-Barracuda-Start-Time: 1606420849
X-Barracuda-Encrypted: ECDHE-RSA-AES256-SHA384
X-Barracuda-URL: https://mx04.lhost.no:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at lhost.no
X-Barracuda-Scan-Msg-Size: 2206
X-Barracuda-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-26 00:01, Jakub Kicinski wrote:
> On Wed, 25 Nov 2020 23:15:39 +0100 Thomas Karlsson wrote:
>>>> This is my first time ever attemting a contribution to the kernel so
>>>> I'm quite happy to keep it simple like that too :)  
>>>
>>> Module params are highly inflexible, we have a general policy not 
>>> to accept them in the netdev world.
>>
>> I see, although the current define seems even less flexible :)
> 
> Just to be clear - the module parameter is a no-go. 
> No point discussing it.

Got it!

> 
>> Although, I might not have fully understood the .changelink you suggest.
>> Is it via the ip link set ... command? 
> 
> Yes.
> 
>> Or is there a way to set the parameters in a more "raw" form that
>> does not require a patch to iproute2 with parameter parsing, error
>> handing, man pages updates, etc. I feel that I'm getting in over my
>> head here.
> 
> We're here to assist! Netlink takes a little bit of effort 
> to comprehend but it's very simple once you get the mechanics!
> 

Thanks for the encouragement, I have been able to build iproute2 today and
I am successfully communicating with the driver now being able to set and retrieve my queue len!

As I'm working on this I do got a question. I placed the bc_queue_len into the struct macvlan_port *port
since that is where the bc_queue is located today. But when I change and retrieve the queue from userspace I realize
that all macvlan interfaces that share the same physical lowerdev uses the same port structure and thus
the same bc_queue_len.

It confused me at first and I'm not sure if that is how it should be. I expected the driver to have different
bc_queues for all macvlan interfaces no matter which lowerdev they were using but obviously that is not the case.

It may be a bit confusing to change bc_queue_len on one macvlan and see that the change was applied to more than one.

But I'm not sure if I should just move bc_queue_len to the struct macvlan_dev either. because then different macvlans will use different queue lengths while they still use the same queue. Which may also be considered a bit illogical

Let me know what you prefer here!

Thanks!




