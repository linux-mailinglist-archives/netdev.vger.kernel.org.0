Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751D242D48B
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 10:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhJNIMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 04:12:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:53372 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhJNIMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 04:12:31 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mavoh-000E8D-HS; Thu, 14 Oct 2021 10:10:19 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mavoh-000MV5-9L; Thu, 14 Oct 2021 10:10:19 +0200
Subject: Re: [PATCH net-next 2/3] net, neigh: Use NLA_POLICY_MASK helper for
 NDA_FLAGS_EXT attribute
To:     David Ahern <dsahern@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211013132140.11143-1-daniel@iogearbox.net>
 <20211013132140.11143-3-daniel@iogearbox.net>
 <8be43259-1fc1-2c62-3cd1-100bde6ff702@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <687e2be1-4d16-1f71-bb25-1f27a04d06f0@iogearbox.net>
Date:   Thu, 14 Oct 2021 10:10:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <8be43259-1fc1-2c62-3cd1-100bde6ff702@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26321/Wed Oct 13 10:21:20 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/21 5:13 AM, David Ahern wrote:
> On 10/13/21 7:21 AM, Daniel Borkmann wrote:
>> Instead of open-coding a check for invalid bits in NTF_EXT_MASK, we can just
>> use the NLA_POLICY_MASK() helper instead, and simplify NDA_FLAGS_EXT sanity
>> check this way.
>>
>> Suggested-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> ---
>>   net/core/neighbour.c | 6 +-----
>>   1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
>> index 4fc601f9cd06..922b9ed0fe76 100644
>> --- a/net/core/neighbour.c
>> +++ b/net/core/neighbour.c
>> @@ -1834,7 +1834,7 @@ const struct nla_policy nda_policy[NDA_MAX+1] = {
>>   	[NDA_MASTER]		= { .type = NLA_U32 },
>>   	[NDA_PROTOCOL]		= { .type = NLA_U8 },
>>   	[NDA_NH_ID]		= { .type = NLA_U32 },
>> -	[NDA_FLAGS_EXT]		= { .type = NLA_U32 },
>> +	[NDA_FLAGS_EXT]		= NLA_POLICY_MASK(NLA_U32, NTF_EXT_MASK),
>>   	[NDA_FDB_EXT_ATTRS]	= { .type = NLA_NESTED },
>>   };
>>   
>> @@ -1936,10 +1936,6 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
>>   	if (tb[NDA_FLAGS_EXT]) {
>>   		u32 ext = nla_get_u32(tb[NDA_FLAGS_EXT]);
>>   
>> -		if (ext & ~NTF_EXT_MASK) {
>> -			NL_SET_ERR_MSG(extack, "Invalid extended flags");
>> -			goto out;
>> -		}
>>   		BUILD_BUG_ON(sizeof(neigh->flags) * BITS_PER_BYTE <
>>   			     (sizeof(ndm->ndm_flags) * BITS_PER_BYTE +
>>   			      hweight32(NTF_EXT_MASK)));
>>
> 
> I get that NLA_POLICY_MASK wants to standardize the logic, but the
> generic extack message "reserved bit set" is less useful than the one here.

If the expectation/recommendation is that NLA_POLICY_MASK() should be used, then
it would probably make sense for NLA_POLICY_MASK() itself to improve. For example,
NLA_POLICY_MASK() could perhaps take an optional error string which it should
return via extack rather than the standard "reserved bit set" one or such.. on
the other hand, I see that NL_SET_ERR_MSG_ATTR() already points out the affected
attribute via setting extack->bad_attr, so it be sufficient to figure out that it's
about reserved bits inside NDA_FLAGS_EXT given this is propagated back to user
space via NLMSGERR_ATTR_OFFS.

Thanks,
Daniel
