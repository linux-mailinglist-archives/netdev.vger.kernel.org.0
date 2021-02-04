Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA6730EF9C
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 10:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235169AbhBDJYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 04:24:25 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3391 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbhBDJYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 04:24:20 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601bbd1b0000>; Thu, 04 Feb 2021 01:23:39 -0800
Received: from [172.27.8.91] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 4 Feb
 2021 09:23:38 +0000
Subject: Re: [PATCH net] net: psample: Fix the netlink skb length
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <idosch@nvidia.com>,
        Yotam Gigi <yotam.gi@gmail.com>
References: <20210203031028.171318-1-cmi@nvidia.com>
 <20210203182103.0f8350a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Chris Mi <cmi@nvidia.com>
Message-ID: <d1d03742-3b04-2e6a-2166-ac2ea1a7d5c7@nvidia.com>
Date:   Thu, 4 Feb 2021 17:23:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210203182103.0f8350a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612430619; bh=ZXDo3nhJuPQTiBbaT1Op6HbyeFNUeRCe30CYjzpVPzo=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=eFguI4EUs/+G7cSanlAy9lPP+u+Gozu77B9TARgMZS4wyYbdpc5uXeIu+V/H6SYW4
         JSzAOAOUNze2vaMdAvBL8HBTwxujfmB+DFMgsYkr11gd6H+vry2cBH3wpzw9xezu21
         OKLt7mDUdze/3xWDX2/Hz6rhJLC6jlaVFzhUypgdrROM96wnk8Pli0Pn7NN52y1iUO
         +i76Hx0J6Ybih2TU83d6BA6W/9dzUmkUqHJFvL2NGmD6TAw8kY0RFiRgsvLPtAxnAg
         gI6Gde1oIZ5bq5S11G/wlha00th9ltwIkyJubFs5NHzWsRa0hkwyktjdHtw6V24rFE
         K1AaF0zlmJLJQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/4/2021 10:21 AM, Jakub Kicinski wrote:
> On Wed,  3 Feb 2021 11:10:28 +0800 Chris Mi wrote:
>> Currently, the netlink skb length only includes metadata and data
>> length. It doesn't include the psample generic netlink header length.
> But what's the bug? Did you see oversized messages on the socket?
Yes.
>   Did
> one of the nla_put() fail?
Yes.
>
>> Fixes: 6ae0a6286171 ("net: Introduce psample, a new genetlink channel for packet sampling")
>> CC: Yotam Gigi <yotam.gi@gmail.com>
>> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
>> Signed-off-by: Chris Mi <cmi@nvidia.com>
>> ---
>>   net/psample/psample.c | 10 ++++++----
>>   1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/psample/psample.c b/net/psample/psample.c
>> index 33e238c965bd..807d75f5a40f 100644
>> --- a/net/psample/psample.c
>> +++ b/net/psample/psample.c
>> @@ -363,6 +363,7 @@ void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
>>   	struct ip_tunnel_info *tun_info;
>>   #endif
>>   	struct sk_buff *nl_skb;
>> +	int header_len;
>>   	int data_len;
>>   	int meta_len;
>>   	void *data;
>> @@ -381,12 +382,13 @@ void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
>>   		meta_len += psample_tunnel_meta_len(tun_info);
>>   #endif
>>   
>> +	/* psample generic netlink header size */
>> +	header_len = nlmsg_total_size(GENL_HDRLEN + psample_nl_family.hdrsize);
> GENL_HDRLEN is already included by genlmsg_new() and fam->hdrsize is 0
> / uninitialized for psample_nl_family. What am I missing? Ido?
Thanks for pointing this out. If so, it seems this patch is incorrect.
>
>>   	data_len = min(skb->len, trunc_size);
>> -	if (meta_len + nla_total_size(data_len) > PSAMPLE_MAX_PACKET_SIZE)
>> -		data_len = PSAMPLE_MAX_PACKET_SIZE - meta_len - NLA_HDRLEN
>> +	if (header_len + meta_len + nla_total_size(data_len) > PSAMPLE_MAX_PACKET_SIZE)
>> +		data_len = PSAMPLE_MAX_PACKET_SIZE - header_len - meta_len - NLA_HDRLEN
>>   			    - NLA_ALIGNTO;
>> -
>> -	nl_skb = genlmsg_new(meta_len + nla_total_size(data_len), GFP_ATOMIC);
>> +	nl_skb = genlmsg_new(header_len + meta_len + nla_total_size(data_len), GFP_ATOMIC);
>>   	if (unlikely(!nl_skb))
>>   		return;
>>   

