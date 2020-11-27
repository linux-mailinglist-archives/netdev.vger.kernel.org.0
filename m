Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301E62C6D87
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 00:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730815AbgK0XPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 18:15:22 -0500
Received: from spam.lhost.no ([5.158.192.84]:39835 "EHLO mx03.lhost.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728790AbgK0XNi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 18:13:38 -0500
X-ASG-Debug-ID: 1606518806-0ffc0524dfb4340001-BZBGGp
Received: from s103.paneda.no ([5.158.193.76]) by mx03.lhost.no with ESMTP id mFMiydUCPDOKRSsK (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO); Sat, 28 Nov 2020 00:13:27 +0100 (CET)
X-Barracuda-Envelope-From: thomas.karlsson@paneda.se
X-Barracuda-Effective-Source-IP: UNKNOWN[5.158.193.76]
X-Barracuda-Apparent-Source-IP: 5.158.193.76
X-ASG-Whitelist: Client
Received: from [192.168.10.188] (83.140.179.234) by s103.paneda.no
 (10.16.55.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.1979.3; Sat, 28
 Nov 2020 00:13:23 +0100
Subject: Re: Hardcoded multicast queue length in macvlan.c driver causes poor
 multicast receive performance
To:     Jakub Kicinski <kuba@kernel.org>
X-ASG-Orig-Subj: Re: Hardcoded multicast queue length in macvlan.c driver causes poor
 multicast receive performance
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <jiri@resnulli.us>, <kaber@trash.net>, <edumazet@google.com>,
        <vyasevic@redhat.com>, <alexander.duyck@gmail.com>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
 <147b704ac1d5426fbaa8617289dad648@paneda.se>
 <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b93a6031-f1b4-729d-784b-b1f465d27071@paneda.se>
 <20201125085848.4f330dea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4e3c9f30-d43c-54b1-2796-86f38d316ef3@paneda.se>
 <20201125100710.7e766d7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <956c4fca-2a54-97cb-5b4c-3a286743884b@paneda.se>
 <20201125150100.287ac72a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3a30c2f6-e400-7001-69ec-683245620f2d@paneda.se>
 <20201127092705.67e00d14@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Thomas Karlsson <thomas.karlsson@paneda.se>
Message-ID: <7f18cc47-f1a1-4fa6-0f31-63deb12d9d1b@paneda.se>
Date:   Sat, 28 Nov 2020 00:13:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201127092705.67e00d14@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [83.140.179.234]
X-ClientProxiedBy: s103.paneda.no (10.16.55.12) To s103.paneda.no
 (10.16.55.12)
X-Barracuda-Connect: UNKNOWN[5.158.193.76]
X-Barracuda-Start-Time: 1606518807
X-Barracuda-Encrypted: ECDHE-RSA-AES256-SHA384
X-Barracuda-URL: https://mx03.lhost.no:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at lhost.no
X-Barracuda-Scan-Msg-Size: 2271
X-Barracuda-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-27 18:27, Jakub Kicinski wrote:
> On Thu, 26 Nov 2020 21:00:46 +0100 Thomas Karlsson wrote:
>> On 2020-11-26 00:01, Jakub Kicinski wrote:
>>> On Wed, 25 Nov 2020 23:15:39 +0100 Thomas Karlsson wrote:  
>>>> Or is there a way to set the parameters in a more "raw" form that
>>>> does not require a patch to iproute2 with parameter parsing, error
>>>> handing, man pages updates, etc. I feel that I'm getting in over my
>>>> head here.  
>>>
>>> We're here to assist! Netlink takes a little bit of effort 
>>> to comprehend but it's very simple once you get the mechanics!
>>>   
>>
>> Thanks for the encouragement, I have been able to build iproute2 today and
>> I am successfully communicating with the driver now being able to set and retrieve my queue len!
>>
>> As I'm working on this I do got a question. I placed the bc_queue_len into the struct macvlan_port *port
>> since that is where the bc_queue is located today. But when I change and retrieve the queue from userspace I realize
>> that all macvlan interfaces that share the same physical lowerdev uses the same port structure and thus
>> the same bc_queue_len.
> 
> Indeed looks like its an ingress attribute.
> 
>> It confused me at first and I'm not sure if that is how it should be. I expected the driver to have different
>> bc_queues for all macvlan interfaces no matter which lowerdev they were using but obviously that is not the case.
>>
>> It may be a bit confusing to change bc_queue_len on one macvlan and see that the change was applied to more than one.
>>
>> But I'm not sure if I should just move bc_queue_len to the struct macvlan_dev either. because then different macvlans will use different queue lengths while they still use the same queue. Which may also be considered a bit illogical
>>
>> Let me know what you prefer here!
> 
> I'd record the queue len requested by each interface in their struct
> macvlan_dev and then calculate a max over the members to set the actual
> value in struct macvlan_port.

That sounds like a good approach to me. I can see that for example mtu is
handled in a similar aggregated way. I'll give it a try.
Thanks!

> 
> Let me CC some extra people, looks like macvlan does not have a
> maintainer..
> 
