Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229C5405DB7
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 21:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343663AbhIITuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 15:50:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:52212 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243355AbhIITuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 15:50:11 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mOQ2Z-000DLg-AB; Thu, 09 Sep 2021 21:48:55 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mOQ2Z-000MUU-3O; Thu, 09 Sep 2021 21:48:55 +0200
Subject: Re: [PATCH bpf 1/3] bpf, cgroups: Fix cgroup v2 fallback on v1/v2
 mixed mode
To:     sdf@google.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, tj@kernel.org,
        davem@davemloft.net, m@lambda.lt, alexei.starovoitov@gmail.com,
        andrii@kernel.org
References: <1e9ee1059ddb0ad7cd2c5f9eeaa26606f9d5fbbf.1631189197.git.daniel@iogearbox.net>
 <YTo6vkBA9U65tdDG@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <98a63cf5-5464-c504-db74-3357f37436cb@iogearbox.net>
Date:   Thu, 9 Sep 2021 21:48:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YTo6vkBA9U65tdDG@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26289/Thu Sep  9 10:20:35 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/21 6:47 PM, sdf@google.com wrote:
> On 09/09, Daniel Borkmann wrote:
[...]
>>   static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
>>   {
>> -#if defined(CONFIG_CGROUP_NET_PRIO) || defined(CONFIG_CGROUP_NET_CLASSID)
>> -    unsigned long v;
>> -
>> -    /*
>> -     * @skcd->val is 64bit but the following is safe on 32bit too as we
>> -     * just need the lower ulong to be written and read atomically.
>> -     */
>> -    v = READ_ONCE(skcd->val);
>> -
>> -    if (v & 3)
>> -        return &cgrp_dfl_root.cgrp;
>> -
>> -    return (struct cgroup *)(unsigned long)v ?: &cgrp_dfl_root.cgrp;
>> -#else
>> -    return (struct cgroup *)(unsigned long)skcd->val;
>> -#endif
>> +    return READ_ONCE(skcd->cgroup);
> 
> Do we really need READ_ONCE here? I was always assuming it was there
> because we were flipping that lower bit. Now that it's a simple
> pointer, why not 'return skcd->cgroup' instead?

Hm, good point, from cgroup_sk_alloc() side we don't need it as struct sock is not
public yet at that point, I'll send a v2 and remove the READ_ONCE()/WRITE_ONCE()
pair for the cgroup pointer.

Thanks for spotting!
Daniel
