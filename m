Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C3B2C4682
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 18:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731571AbgKYRMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 12:12:39 -0500
Received: from spam.lhost.no ([5.158.192.85]:42188 "EHLO mx04.lhost.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730695AbgKYRMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 12:12:39 -0500
X-ASG-Debug-ID: 1606324355-0ffc06424c4c870001-BZBGGp
Received: from s103.paneda.no ([5.158.193.76]) by mx04.lhost.no with ESMTP id mBlfmQPfyW1LXYXC (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO); Wed, 25 Nov 2020 18:12:35 +0100 (CET)
X-Barracuda-Envelope-From: thomas.karlsson@paneda.se
X-Barracuda-Effective-Source-IP: UNKNOWN[5.158.193.76]
X-Barracuda-Apparent-Source-IP: 5.158.193.76
X-ASG-Whitelist: Client
Received: from [192.168.10.188] (83.140.179.234) by s103.paneda.no
 (10.16.55.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.1979.3; Wed, 25
 Nov 2020 18:12:34 +0100
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
From:   Thomas Karlsson <thomas.karlsson@paneda.se>
Message-ID: <4e3c9f30-d43c-54b1-2796-86f38d316ef3@paneda.se>
Date:   Wed, 25 Nov 2020 18:12:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201125085848.4f330dea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: sv
Content-Transfer-Encoding: 8bit
X-Originating-IP: [83.140.179.234]
X-ClientProxiedBy: s103.paneda.no (10.16.55.12) To s103.paneda.no
 (10.16.55.12)
X-Barracuda-Connect: UNKNOWN[5.158.193.76]
X-Barracuda-Start-Time: 1606324355
X-Barracuda-Encrypted: ECDHE-RSA-AES256-SHA384
X-Barracuda-URL: https://mx04.lhost.no:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at lhost.no
X-Barracuda-Scan-Msg-Size: 3846
X-Barracuda-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-25 17:58, Jakub Kicinski wrote:
> On Wed, 25 Nov 2020 13:51:41 +0100 Thomas Karlsson wrote:
>> Den 2020-11-23 kl. 23:30, skrev Jakub Kicinski:
>>> On Mon, 23 Nov 2020 14:22:31 +0000 Thomas Karlsson wrote:  
>>>> Hello,
>>>>
>>>> There is a special queue handling in macvlan.c for broadcast and
>>>> multicast packages that was arbitrarily set to 1000 in commit
>>>> 07d92d5cc977a7fe1e683e1d4a6f723f7f2778cb . While this is probably
>>>> sufficient for most uses cases it is insufficient to support high
>>>> packet rates. I currently have a setup with 144 000 multicast packets
>>>> incoming per second (144 different live audio RTP streams) and suffer
>>>> very frequent packet loss. With unicast this is not an issue and I
>>>> can in addition to the 144kpps load the macvlan interface with
>>>> another 450mbit/s using iperf.
>>>>
>>>> In order to verify that the queue is the problem I edited the define
>>>> to 100000 and recompiled the kernel module. After replacing it with
>>>> rmmod/insmod I get 0 packet loss (measured over 2 days where I before
>>>> had losses every other second or so) and can also load an additional
>>>> 450 mbit/s multicast traffic using iperf without losses. So basically
>>>> no change in performance between unicast/multicast when it comes to
>>>> lost packets on my machine.
>>>>
>>>> I think It would be best if this queue length was configurable
>>>> somehow. Either an option when creating the macvlan (like how
>>>> bridge/passthrough/etc are set) or at least when loading the module
>>>> (for instance by using a config in /etc/modprobe.d). One size does
>>>> not fit all in this situation.  
>>>
>>> The former please. You can add a netlink attribute, should be
>>> reasonably straightforward. The other macvlan attrs are defined
>>> under "MACVLAN section" in if_link.h.
>>>   
>>
>> I did some work towards a patch using the first option,
>> by adding a netlink attribute in if_link.h as suggested.
>> I agree that this was reasonably straightforward, until userspace.
>>
>> In order to use/test my new parameter I need to update iproute2 package
>> as far as I understand. But then since I use the macvlan with docker
>> I also need to update the docker macvlan driver to send this new
>> option to the kernel module.
> 
> I wish I got a cookie every time someone said they can't do the right
> thing because they'd have to update $container_system 😔

lol :)

> 
>> For this reason I would like to know if you would consider
>> merging a patch using the module_param(...) variant instead?
>>
>> I would argue that this still makes the situation better
>> and resolves the packet-loss issue, although not necessarily
>> in an optimal way. However, The upside of being able to specify the
>> parameter on a per macvlan interface level instead of globally is not
>> that big in this situation. Normally you don't use that much
>> multicast anyway so it's a parameter that only will be touched by
>> a very small user base that can understand and handle the implications
>> of such a global setting.
> 
> How about implementing .changelink in macvlan? That way you could
> modify the macvlan device independent of Docker? 
> 
> Make sure you only accept changes to the bc queue len if that's the
> only one you act on.
> 

Hmm, I see. You mean that docker can create the interface and then I can
modify it afterwards? That might be a workaround but I just submitted
a patch (like seconds before your message) with the module_param() option
and this was very clean I think. both in how little code that needed to be
changed and in how simple it is to set the option in the target environment.

This is my first time ever attemting a contribution to the kernel so
I'm quite happy to keep it simple like that too :)
