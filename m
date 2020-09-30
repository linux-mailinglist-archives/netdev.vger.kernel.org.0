Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FDA27F3AB
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbgI3U4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:56:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:53122 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730349AbgI3U4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:56:49 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNj9X-0003cc-LC; Wed, 30 Sep 2020 22:56:43 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNj9X-000Ult-Db; Wed, 30 Sep 2020 22:56:43 +0200
Subject: Re: [PATCH bpf-next v4 3/6] bpf: add redirect_neigh helper as
 redirect drop-in
To:     David Ahern <dsahern@gmail.com>, ast@kernel.org
Cc:     john.fastabend@gmail.com, kafai@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, David Ahern <dsahern@kernel.org>
References: <cover.1601477936.git.daniel@iogearbox.net>
 <f207de81629e1724899b73b8112e0013be782d35.1601477936.git.daniel@iogearbox.net>
 <34c873d1-5014-9fd4-8372-4980f6787904@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <af71966a-f747-a397-192d-201c05e5b5b9@iogearbox.net>
Date:   Wed, 30 Sep 2020 22:56:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <34c873d1-5014-9fd4-8372-4980f6787904@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25943/Wed Sep 30 15:54:21 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/20 6:08 PM, David Ahern wrote:
> On 9/30/20 8:18 AM, Daniel Borkmann wrote:
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 6116a7f54c8f..1f17c6752deb 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3652,6 +3652,19 @@ union bpf_attr {
>>    * 		associated socket instead of the current process.
>>    * 	Return
>>    * 		The id is returned or 0 in case the id could not be retrieved.
>> + *
>> + * long bpf_redirect_neigh(u32 ifindex, u64 flags)
>> + * 	Description
>> + * 		Redirect the packet to another net device of index *ifindex*
>> + * 		and fill in L2 addresses from neighboring subsystem. This helper
> 
> It is worth mentioning in the documentation that this helper does a FIB
> lookup based on the skb's networking header to get the address of the
> next hop and then relies on the neighbor lookup for the L2 address of
> the nexthop.

Makes sense, I'll follow-up and add it.

>> + * 		is somewhat similar to **bpf_redirect**\ (), except that it
>> + * 		fills in e.g. MAC addresses based on the L3 information from
>> + * 		the packet. This helper is supported for IPv4 and IPv6 protocols.
>> + * 		The *flags* argument is reserved and must be 0. The helper is
>> + * 		currently only supported for tc BPF program types.
>> + * 	Return
>> + * 		The helper returns **TC_ACT_REDIRECT** on success or
>> + * 		**TC_ACT_SHOT** on error.
>>    */
>>   #define __BPF_FUNC_MAPPER(FN)		\
>>   	FN(unspec),			\
> 
> Code change looks fine to me:
> 
> Reviewed-by: David Ahern <dsahern@gmail.com>

Thanks for the reviews!
