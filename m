Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9202C4ABA
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 23:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731956AbgKYWPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 17:15:44 -0500
Received: from mx03.lhost.no ([5.158.192.84]:41283 "EHLO mx03.lhost.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730821AbgKYWPo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 17:15:44 -0500
X-ASG-Debug-ID: 1606342540-0ffc0524df582e0001-BZBGGp
Received: from s103.paneda.no ([5.158.193.76]) by mx03.lhost.no with ESMTP id rLj2nfNBsBaTWRzE (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO); Wed, 25 Nov 2020 23:15:40 +0100 (CET)
X-Barracuda-Envelope-From: thomas.karlsson@paneda.se
X-Barracuda-Effective-Source-IP: UNKNOWN[5.158.193.76]
X-Barracuda-Apparent-Source-IP: 5.158.193.76
X-ASG-Whitelist: Client
Received: from [192.168.10.188] (83.140.179.234) by s103.paneda.no
 (10.16.55.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.1979.3; Wed, 25
 Nov 2020 23:15:39 +0100
Subject: Re: Hardcoded multicast queue length in macvlan.c driver causes poor
 multicast receive performance
To:     Jakub Kicinski <kuba@kernel.org>
X-ASG-Orig-Subj: Re: Hardcoded multicast queue length in macvlan.c driver causes poor
 multicast receive performance
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <thomas.karlsson@paneda.se>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
 <147b704ac1d5426fbaa8617289dad648@paneda.se>
 <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b93a6031-f1b4-729d-784b-b1f465d27071@paneda.se>
 <20201125085848.4f330dea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4e3c9f30-d43c-54b1-2796-86f38d316ef3@paneda.se>
 <20201125100710.7e766d7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Thomas Karlsson <thomas.karlsson@paneda.se>
Message-ID: <956c4fca-2a54-97cb-5b4c-3a286743884b@paneda.se>
Date:   Wed, 25 Nov 2020 23:15:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201125100710.7e766d7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: sv
Content-Transfer-Encoding: 7bit
X-Originating-IP: [83.140.179.234]
X-ClientProxiedBy: s103.paneda.no (10.16.55.12) To s103.paneda.no
 (10.16.55.12)
X-Barracuda-Connect: UNKNOWN[5.158.193.76]
X-Barracuda-Start-Time: 1606342540
X-Barracuda-Encrypted: ECDHE-RSA-AES256-SHA384
X-Barracuda-URL: https://mx03.lhost.no:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at lhost.no
X-Barracuda-Scan-Msg-Size: 2578
X-Barracuda-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-25 19:07, Jakub Kicinski wrote:
> On Wed, 25 Nov 2020 18:12:34 +0100 Thomas Karlsson wrote:
>>>> For this reason I would like to know if you would consider
>>>> merging a patch using the module_param(...) variant instead?
>>>>
>>>> I would argue that this still makes the situation better
>>>> and resolves the packet-loss issue, although not necessarily
>>>> in an optimal way. However, The upside of being able to specify the
>>>> parameter on a per macvlan interface level instead of globally is not
>>>> that big in this situation. Normally you don't use that much
>>>> multicast anyway so it's a parameter that only will be touched by
>>>> a very small user base that can understand and handle the implications
>>>> of such a global setting.  
>>>
>>> How about implementing .changelink in macvlan? That way you could
>>> modify the macvlan device independent of Docker? 
>>>
>>> Make sure you only accept changes to the bc queue len if that's the
>>> only one you act on.
>>>   
>>
>> Hmm, I see. You mean that docker can create the interface and then I can
>> modify it afterwards? That might be a workaround but I just submitted
>> a patch (like seconds before your message) with the module_param() option
>> and this was very clean I think. both in how little code that needed to be
>> changed and in how simple it is to set the option in the target environment.
>>
>> This is my first time ever attemting a contribution to the kernel so
>> I'm quite happy to keep it simple like that too :)
> 
> Module params are highly inflexible, we have a general policy not 
> to accept them in the netdev world.
> 

I see, although the current define seems even less flexible :)
Although, I might not have fully understood the .changelink you suggest.
Is it via the ip link set ... command? Or is there a way to set the parameters
in a more "raw" form that does not require a patch to iproute2 with parameter parsing,
error handing, man pages updates, etc. I feel that I'm getting in over my head here.

I appreciate your feedback!

> There should even be a check> in our patchwork which should fail here, but it appears that the patch 
> did not apply in the first place:
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/385b9b4c-25f5-b507-4e69-419883fa8043@paneda.se/
> 
> Make sure you're developing on top of this tree:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
> 

Right, thanks! It's a bit of a learning curve. I had incorrectly done the work on top of torvalds/linux
