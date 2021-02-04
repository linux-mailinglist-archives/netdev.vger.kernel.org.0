Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E055E30EFBD
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 10:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbhBDJdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 04:33:07 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5346 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbhBDJdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 04:33:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601bbf250001>; Thu, 04 Feb 2021 01:32:21 -0800
Received: from [172.27.8.91] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 4 Feb
 2021 09:32:19 +0000
Subject: Re: [PATCH net] net: psample: Fix the netlink skb length
To:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <idosch@nvidia.com>,
        Yotam Gigi <yotam.gi@gmail.com>
References: <20210203031028.171318-1-cmi@nvidia.com>
 <20210203182103.0f8350a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210204084732.GA3645495@shredder.lan>
From:   Chris Mi <cmi@nvidia.com>
Message-ID: <0a0a4183-9a75-83fe-2b37-fd48f8b9d589@nvidia.com>
Date:   Thu, 4 Feb 2021 17:32:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210204084732.GA3645495@shredder.lan>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612431141; bh=GgslppHdgP7UWmQVyUtwkiCuG0jBAn7LkPSQuODBYi4=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=CkXT81WZkPESJ60LATvY2KyPDn1VHGNJKS1AzuPxZwHOpLT56G2qhvcssQ9pdsP8k
         Vhl4aoq53I9L1q5DpMYUbCMIG/6PZ0fczi4CmIYfQ2ZoZaFzJaZGavSo4z5CE8hs6R
         hc5VVmb+P3PmMBrbRv+9JoqbfNhYPRxHRXSh6P7kCb2ePLjvnEq9QueBqYhjr5lFrJ
         0sQGke33nzjqEanswkup9rnM7yGigkzCqjSi1oOfebbcB98DeBWsC8bLKExnPpyKCC
         VmeB4cMsNGN+6mKmL/UEoy54ehu+ut7PuPJNyP3eMY8dRNBleK8wXnR3Qo+6hko/dV
         6VEzPfNOBjeSw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/4/2021 4:47 PM, Ido Schimmel wrote:
> On Wed, Feb 03, 2021 at 06:21:03PM -0800, Jakub Kicinski wrote:
>> On Wed,  3 Feb 2021 11:10:28 +0800 Chris Mi wrote:
>>> Currently, the netlink skb length only includes metadata and data
>>> length. It doesn't include the psample generic netlink header length.
>> But what's the bug? Did you see oversized messages on the socket? Did
>> one of the nla_put() fail?
> I didn't ask, but I assumed the problem was nla_put(). Agree it needs to
> be noted in the commit message.
>
>>> Fixes: 6ae0a6286171 ("net: Introduce psample, a new genetlink channel for packet sampling")
>>> CC: Yotam Gigi <yotam.gi@gmail.com>
>>> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
>>> Signed-off-by: Chris Mi <cmi@nvidia.com>
>>> ---
>>>   net/psample/psample.c | 10 ++++++----
>>>   1 file changed, 6 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/net/psample/psample.c b/net/psample/psample.c
>>> index 33e238c965bd..807d75f5a40f 100644
>>> --- a/net/psample/psample.c
>>> +++ b/net/psample/psample.c
>>> @@ -363,6 +363,7 @@ void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
>>>   	struct ip_tunnel_info *tun_info;
>>>   #endif
>>>   	struct sk_buff *nl_skb;
>>> +	int header_len;
>>>   	int data_len;
>>>   	int meta_len;
>>>   	void *data;
>>> @@ -381,12 +382,13 @@ void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
>>>   		meta_len += psample_tunnel_meta_len(tun_info);
>>>   #endif
>>>   
>>> +	/* psample generic netlink header size */
>>> +	header_len = nlmsg_total_size(GENL_HDRLEN + psample_nl_family.hdrsize);
>> GENL_HDRLEN is already included by genlmsg_new() and fam->hdrsize is 0
>> / uninitialized for psample_nl_family. What am I missing? Ido?
> Yea, I missed that genlmsg_new() eventually accounts for 'GENL_HDRLEN'.
>
> Chris, assuming the problem is nla_put(), I think some other attribute
> is not accounted for when calculating the size of the skb. Does it only
> happen with packets that include tunnel metadata?
Yes.
>   Because I think I see
> a few problems there:
>
> diff --git a/net/psample/psample.c b/net/psample/psample.c
> index 33e238c965bd..1a233cd128c7 100644
> --- a/net/psample/psample.c
> +++ b/net/psample/psample.c
> @@ -311,8 +311,10 @@ static int psample_tunnel_meta_len(struct ip_tunnel_info *tun_info)
>          int tun_opts_len = tun_info->options_len;
>          int sum = 0;
>   
> +       sum += nla_total_size(0);       /* PSAMPLE_ATTR_TUNNEL */
> +
>          if (tun_key->tun_flags & TUNNEL_KEY)
> -               sum += nla_total_size(sizeof(u64));
> +               sum += nla_total_size_64bit(sizeof(u64));
>   
>          if (tun_info->mode & IP_TUNNEL_INFO_BRIDGE)
>                  sum += nla_total_size(0);
Thanks for this patch. I'll check it.

BTW, maybe I should not mention it, if we have the psample dependency 
removal patch
which is rejected, I think we can debug the psample issue easily. 
Because we can
unload and load psample easily. But if NIC driver calls psample api 
directly.
We have to unload the driver first. After loading the NIC driver, we 
have to enable sriov
and enable switchdev mode again which is time consuming.
>>>   	data_len = min(skb->len, trunc_size);
>>> -	if (meta_len + nla_total_size(data_len) > PSAMPLE_MAX_PACKET_SIZE)
>>> -		data_len = PSAMPLE_MAX_PACKET_SIZE - meta_len - NLA_HDRLEN
>>> +	if (header_len + meta_len + nla_total_size(data_len) > PSAMPLE_MAX_PACKET_SIZE)
>>> +		data_len = PSAMPLE_MAX_PACKET_SIZE - header_len - meta_len - NLA_HDRLEN
>>>   			    - NLA_ALIGNTO;
>>> -
>>> -	nl_skb = genlmsg_new(meta_len + nla_total_size(data_len), GFP_ATOMIC);
>>> +	nl_skb = genlmsg_new(header_len + meta_len + nla_total_size(data_len), GFP_ATOMIC);
>>>   	if (unlikely(!nl_skb))
>>>   		return;
>>>   

