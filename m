Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F502F7258
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 06:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733076AbhAOFkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 00:40:24 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:54530 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbhAOFkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 00:40:23 -0500
Received: from [10.193.177.137] (harsha.asicdesigners.com [10.193.177.137] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 10F5cYeG031922;
        Thu, 14 Jan 2021 21:38:36 -0800
Subject: Re: [net] net: feature check mandating HW_CSUM is wrong
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, secdev@chelsio.com,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>, andriin@fb.com,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, ap420073@gmail.com,
        Jiri Pirko <jiri@mellanox.com>, borisp@nvidia.com,
        Tariq Toukan <tariqt@nvidia.com>
References: <20210106175327.5606-1-rohitm@chelsio.com>
 <20210106111710.34ab4eab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3d94bd63-dee0-3699-8e42-193e652592fa@chelsio.com>
 <CAKgT0UcbYhpngJ5qtXvDGK+nqCgUqa9m3CHBT0=ZeFxCvRJSxQ@mail.gmail.com>
 <113bea13-8f7e-af0c-50de-936112a1bc48@gmail.com>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <42d6d5b5-adfb-a6b6-53af-b47e939dd694@chelsio.com>
Date:   Fri, 15 Jan 2021 11:08:34 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <113bea13-8f7e-af0c-50de-936112a1bc48@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 13/01/21 10:37 PM, Tariq Toukan wrote:
>
>
> On 1/13/2021 5:35 AM, Alexander Duyck wrote:
>> On Tue, Jan 12, 2021 at 6:43 PM rohit maheshwari <rohitm@chelsio.com> 
>> wrote:
>>>
>>>
>>> On 07/01/21 12:47 AM, Jakub Kicinski wrote:
>>>> On Wed,  6 Jan 2021 23:23:27 +0530 Rohit Maheshwari wrote:
>>>>> Mandating NETIF_F_HW_CSUM to enable TLS offload feature is wrong.
>>>>> And it broke tls offload feature for the drivers, which are still
>>>>> using NETIF_F_IP_CSUM or NETIF_F_IPV6_CSUM. We should use
>>>>> NETIF_F_CSUM_MASK instead.
>>>>>
>>>>> Fixes: ae0b04b238e2 ("net: Disable NETIF_F_HW_TLS_TX when HW_CSUM 
>>>>> is disabled")
>>>>> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
>>>> Please use Tariq's suggestion.
>>> HW_TLS_TX feature is for both IPv4/v6. And If one device is limited to
>>> support only IPv4 checksum offload, TLS offload should be allowed for
>>> that too. So I think putting a check of CSUM_MASK is enough.
>>
>> The issue is that there is no good software fallback if the packet
>> arrives at the NIC and it cannot handle the IPv6 TLS offload.
>>
>> The problem with the earlier patch you had is that it was just
>> dropping frames if you couldn't handle the offload and "hoping" the
>> other end would catch it. That isn't a good practice for any offload.
>> If you have it enabled you have to have a software fallback and in
>> this case it sounds like you don't have that.
>>
>> In order to do that you would have to alter the fast path to have to
>> check if the device is capable per packet which is really an
>> undesirable setup as it would add considerable overhead and is open to
>> race conditions.
>>
>
> +1
>
> Are there really such modern devices with missing IPv6 csum 
> capabilities, or it's just a missing SW implementation in the device 
> driver?
>
> IMO, it sounds reasonable for this modern TLS device offload to asks 
> for a basic requirement such as IPv6 csum offload capability, to save 
> the overhead.
>
I agree with you, all modern devices support V6 csum, but still if we think
logically, we can't limit TLS offload to work only if both IPV4_CSUM  and
IPV6_CSUM are configured/supported. If there is no dependency of IPV6
in running TLS offload with IPv4  and vice-versa, then why should there
be any restriction as such.

