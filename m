Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119952D0DEA
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 11:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgLGKVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 05:21:47 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6166 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgLGKVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 05:21:47 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fce02120008>; Mon, 07 Dec 2020 02:21:06 -0800
Received: from [172.27.12.71] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Dec
 2020 10:20:56 +0000
Subject: Re: [net-next V2 09/15] net/mlx5e: CT: Use the same counter for both
 directions
To:     Saeed Mahameed <saeed@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ariel Levkovich <lariel@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20200923224824.67340-1-saeed@kernel.org>
 <20200923224824.67340-10-saeed@kernel.org>
 <20201127140128.GC3555@localhost.localdomain>
 <9b24cd270def8ea5432fc117e4fd1ed9c756a58d.camel@kernel.org>
From:   Oz Shlomo <ozsh@nvidia.com>
Message-ID: <e98a5a9d-9c65-9687-ca55-dcd266a6cfdf@nvidia.com>
Date:   Mon, 7 Dec 2020 12:20:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <9b24cd270def8ea5432fc117e4fd1ed9c756a58d.camel@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607336466; bh=iwqbIjuUxOIF5KXLsrfQeDGh9h5Zp0RmkIeXfCYaF9E=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=A9sEKKD2i088905aqaCf1qhFj9ARHW+TxvRSYkIK4oQJp2vd9IGewfJsRqh5P7ZoW
         XiPBdACtJFFsoNgTVkzyHXSD40HtL3I6xtIy1DvGY5u+fRY7rdCeQ38kuLyaiUyVAB
         YPEVLalqu3phcPuKiJm9Wxm0pc2Yd5BSpZMzu9VZPURhKhrEK7zlVi0mZKsTrFvIDU
         KqTn+Zi+/rbFYy7tHzYJouQIaIlm2kPgOe+SzuwCSMuo3fdwfFQpNKEZXq0BFNgHi2
         BjOANEtrk7YObc6dLKBY+L1p/8z7Z43lIOHsjGfvfOMRlLYnOptQdAlzGeYuoxgdRb
         WHOM445U7i4+Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcelo,

On 12/1/2020 11:41 PM, Saeed Mahameed wrote:
> On Fri, 2020-11-27 at 11:01 -0300, Marcelo Ricardo Leitner wrote:
>> On Wed, Sep 23, 2020 at 03:48:18PM -0700, saeed@kernel.org wrote:
>>> From: Oz Shlomo <ozsh@mellanox.com>
>>
>> Sorry for reviving this one, but seemed better for the context.
>>
>>> A connection is represented by two 5-tuple entries, one for each
>>> direction.
>>> Currently, each direction allocates its own hw counter, which is
>>> inefficient as ct aging is managed per connection.
>>>
>>> Share the counter that was allocated for the original direction
>>> with the
>>> reverse direction.
>>
>> Yes, aging is done per connection, but the stats are not. With this
>> patch, with netperf TCP_RR test, I get this: (mangled for
>> readability)
>>
>> # grep 172.0.0.4 /proc/net/nf_conntrack
>> ipv4     2 tcp      6
>>    src=172.0.0.3 dst=172.0.0.4 sport=34018 dport=33396 packets=3941992
>> bytes=264113427
>>    src=172.0.0.4 dst=172.0.0.3 sport=33396 dport=34018 packets=4
>> bytes=218 [HW_OFFLOAD]
>>    mark=0 secctx=system_u:object_r:unlabeled_t:s0 zone=0 use=3
>>
>> while without it (594e31bceb + act_ct patch to enable it posted
>> yesterday + revert), I get:
>>
>> # grep 172.0.0.4 /proc/net/nf_conntrack
>> ipv4     2 tcp      6
>>    src=172.0.0.3 dst=172.0.0.4 sport=41856 dport=32776 packets=1876763
>> bytes=125743084
>>    src=172.0.0.4 dst=172.0.0.3 sport=32776 dport=41856 packets=1876761
>> bytes=125742951 [HW_OFFLOAD]
>>    mark=0 secctx=system_u:object_r:unlabeled_t:s0 zone=0 use=3
>>
>> The same is visible on 'ovs-appctl dpctl/dump-conntrack -s' then.
>> Summing both directions in one like this is at least very misleading.
>> Seems this change was motivated only by hw resources constrains. That
>> said, I'm wondering, can this change be reverted somehow?
>>
>>    Marcelo
> 
> Hi Marcelo, thanks for the report,
> Sorry i am not familiar with this /procfs
> Oz, Ariel, Roi, what is your take on this, it seems that we changed the
> behavior of stats incorrectly.

Indeed we overlooked the CT accounting extension.
We will submit a driver fix.

> 
> Thanks,
> Saeed.
> 
> 

