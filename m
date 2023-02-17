Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3EA469B19F
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 18:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjBQRNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 12:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBQRNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 12:13:20 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A8865378;
        Fri, 17 Feb 2023 09:13:18 -0800 (PST)
Message-ID: <16cc33fe-4759-0a7b-1e03-0d77d2f79351@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676653996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iswA5F5lNLs1pqrmAk9ZATISFsQrtfRAeMLiFeSBeyA=;
        b=KmwKCTI4m/g71PRYZXdmTqcTHfGgRUAIqaiwnPuFFW6qwosLX3YCzx3J35mBr4jnbsy3Ws
        6G3lCJ9vKy+XMujR+05FdS9rQO5yYHME2HXRhkOFhHz4Z3VFaXvZ5iplOqbKy7NSovuD74
        wmM68c7nwJ5aE9n3bTa7OerS1WjfN7Q=
Date:   Fri, 17 Feb 2023 09:13:11 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 3/4] bpf: Add BPF_FIB_LOOKUP_SKIP_NEIGH for
 bpf_fib_lookup
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, 'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        netdev@vger.kernel.org, kernel-team@meta.com
References: <20230217004150.2980689-1-martin.lau@linux.dev>
 <20230217004150.2980689-4-martin.lau@linux.dev>
 <dd4e2b92-53c9-6973-86ff-8cb04913c3ca@iogearbox.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <dd4e2b92-53c9-6973-86ff-8cb04913c3ca@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/23 8:00 AM, Daniel Borkmann wrote:
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 1503f61336b6..6c1956e36c97 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
> [...]
>> @@ -5838,21 +5836,28 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct 
>> bpf_fib_lookup *params,
>>       if (likely(nhc->nhc_gw_family != AF_INET6)) {
>>           if (nhc->nhc_gw_family)
>>               params->ipv4_dst = nhc->nhc_gw.ipv4;
>> -
>> -        neigh = __ipv4_neigh_lookup_noref(dev,
>> -                         (__force u32)params->ipv4_dst);
>>       } else {
>>           struct in6_addr *dst = (struct in6_addr *)params->ipv6_dst;
>>           params->family = AF_INET6;
>>           *dst = nhc->nhc_gw.ipv6;
>> -        neigh = __ipv6_neigh_lookup_noref_stub(dev, dst);
>>       }
>> +    if (flags & BPF_FIB_LOOKUP_SKIP_NEIGH)
>> +        goto set_fwd_params;
>> +
>> +    if (params->family == AF_INET6)
> 
> Nit, would have probably more intuitive to keep the same test also here
> (nhc->nhc_gw_family != AF_INET6), but either way, lgtm.

Ack.

> 
> Are you still required to fill the params->smac in bpf_fib_set_fwd_params()
> in that case, meaning, shouldn't bpf_redirect_neigh() take care of it as well
> from neigh_output()? Looks unnecessary and could be moved out too.

Good point. will move it out from bpf_fib_set_fwd_params also. Thanks for the 
review.

