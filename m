Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A645D42A795
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237150AbhJLOsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:48:24 -0400
Received: from www62.your-server.de ([213.133.104.62]:42802 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235294AbhJLOsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 10:48:23 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1maJ2k-000CSH-If; Tue, 12 Oct 2021 16:46:14 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1maJ2k-000EOu-BM; Tue, 12 Oct 2021 16:46:14 +0200
Subject: Re: [PATCH net-next 3/4] net, neigh: Extend neigh->flags to 32 bit to
 allow for extensions
To:     David Ahern <dsahern@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211011121238.25542-1-daniel@iogearbox.net>
 <20211011121238.25542-4-daniel@iogearbox.net>
 <018673d2-6745-47ef-6586-53ddf8aed9b2@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0b1794ec-f55d-3485-d192-e6704af8273d@iogearbox.net>
Date:   Tue, 12 Oct 2021 16:46:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <018673d2-6745-47ef-6586-53ddf8aed9b2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26320/Tue Oct 12 10:17:49 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 4:31 PM, David Ahern wrote:
> On 10/11/21 6:12 AM, Daniel Borkmann wrote:
>> diff --git a/include/net/neighbour.h b/include/net/neighbour.h
>> index eb2a7c03a5b0..26d4ada0aea9 100644
>> --- a/include/net/neighbour.h
>> +++ b/include/net/neighbour.h
>> @@ -144,11 +144,11 @@ struct neighbour {
>>   	struct timer_list	timer;
>>   	unsigned long		used;
>>   	atomic_t		probes;
>> -	__u8			flags;
>> -	__u8			nud_state;
>> -	__u8			type;
>> -	__u8			dead;
>> +	u8			nud_state;
>> +	u8			type;
>> +	u8			dead;
>>   	u8			protocol;
>> +	u32			flags;
>>   	seqlock_t		ha_lock;
>>   	unsigned char		ha[ALIGN(MAX_ADDR_LEN, sizeof(unsigned long))] __aligned(8);
>>   	struct hh_cache		hh;
>> @@ -172,7 +172,7 @@ struct pneigh_entry {
>>   	struct pneigh_entry	*next;
>>   	possible_net_t		net;
>>   	struct net_device	*dev;
>> -	u8			flags;
>> +	u32			flags;
>>   	u8			protocol;
>>   	u8			key[];
>>   };
>> @@ -258,6 +258,10 @@ static inline void *neighbour_priv(const struct neighbour *n)
>>   #define NEIGH_UPDATE_F_ISROUTER			0x40000000
>>   #define NEIGH_UPDATE_F_ADMIN			0x80000000
>>   
>> +/* In-kernel representation for NDA_FLAGS_EXT flags: */
>> +#define NTF_OLD_MASK		0xff
>> +#define NTF_EXT_SHIFT		8
> 
> so only 24 EXT flags can be added. That should be documented; far off
> today, but that's an easy overflow to miss.

Agree, far off today, but this is only kernel internal, so there's always the
option to extend it iff really needed e.g. with u64 as neigh->flags. I'll add
a comment.

> Reviewed-by: David Ahern <dsahern@kernel.org>

Thanks!
