Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937C329E2B0
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgJ2CcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:32:25 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:33369 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgJ2Ca5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:30:57 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id E14505C1946;
        Thu, 29 Oct 2020 10:30:51 +0800 (CST)
Subject: Re: [PATCH net] ip_tunnel: fix over-mtu packet send fail without
 TUNNEL_DONT_FRAGMENT flags
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@kernel.org>
References: <1603272115-25351-1-git-send-email-wenxu@ucloud.cn>
 <20201023141254.7102795d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <c4dae63c-6a99-922e-5bd0-03ac355779ae@ucloud.cn>
 <20201026135626.23684484@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <8e24e490-b3bf-5268-4bd5-98b598b36b36@gmail.com>
 <20201027085548.05b39e0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <057f100e-2b80-f831-0a22-8d2dfe5529bd@ucloud.cn>
Date:   Thu, 29 Oct 2020 10:30:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201027085548.05b39e0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGhgaSh1LGEtPQh4dVkpNS0hCSENNTklKSUpVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hPT1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ny46ORw6Ej5IQk9IDQ0CCApI
        SyMKC0JVSlVKTUtIQkhDTU5JSEtIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFIQk1INwY+
X-HM-Tid: 0a7572318fb22087kuqye14505c1946
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/27/2020 11:55 PM, Jakub Kicinski wrote:
> On Tue, 27 Oct 2020 08:51:07 -0600 David Ahern wrote:
>>> Is this another incarnation of 4cb47a8644cc ("tunnels: PMTU discovery
>>> support for directly bridged IP packets")? Sounds like non-UDP tunnels
>>> need the same treatment to make PMTUD work.
>>>
>>> RFC2003 seems to clearly forbid ignoring the inner DF:  
>> I was looking at this patch Sunday night. To me it seems odd that
>> packets flowing through the overlay affect decisions in the underlay
>> which meant I agree with the proposed change.
> The RFC was probably written before we invented terms like underlay 
> and overlay, and still considered tunneling to be an inefficient hack ;)
>
>> ip_md_tunnel_xmit is inconsistent right now. tnl_update_pmtu is called
>> based on the TUNNEL_DONT_FRAGMENT flag, so why let it be changed later
>> based on the inner header? Or, if you agree with RFC 2003 and the DF
>> should be propagated outer to inner, then it seems like the df reset
>> needs to be moved up before the call to tnl_update_pmtu
> Looks like TUNNEL_DONT_FRAGMENT is intended to switch between using
> PMTU inside the tunnel or just the tunnel dev MTU. ICMP PTB is still
> generated based on the inner headers.
>
> We should be okay to add something like IFLA_GRE_IGNORE_DF to lwt, 
> but IMHO the default should not be violating the RFC.

If we add  TUNNEL_IGNORE_DF to lwt,  the two IGNORE_DF and DONT_FRAGMENT

flags should not coexist ?   Or DONT_FRAGMENT is prior to the IGNORE_DF?


Also there is inconsistent in the kernel for the tunnel device. For geneve and

vxlan tunnel (don't send tunnel with ip_md_tunnel_xmit) in the lwt mode set

the outer df only based  TUNNEL_DONT_FRAGMENT .

And this is also the some behavior for gre device before switching to use 
ip_md_tunnel_xmit as the following patch.

962924f ip_gre: Refactor collect metatdata mode tunnel xmit to ip_md_tunnel_xmit

